using System.Globalization;
using ImperiusDraconisAPI.Common;
using ImperiusDraconisAPI.Data;
using ImperiusDraconisAPI.Models.Alumnos;
using ImperiusDraconisAPI.Models.Perfil;
using Microsoft.Data.SqlClient;

namespace ImperiusDraconisAPI.Services;

public sealed class AlumnosService
{
    private const string DefaultFotoPerfil = "~/Content/FotosPerfil/default.jpg";
    private const string PasswordColumn = "[Contrase\u00f1a]";

    private static readonly IReadOnlyDictionary<string, string> OrdenamientoPermitido =
        new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
        {
            ["nombre"] = "A.Nombre",
            ["dracoins"] = "A.Dracoins",
            ["codigo"] = "A.Codigo",
            ["casa"] = "C.Nombre"
        };

    private static readonly IReadOnlyDictionary<string, string> PrefijosPais =
        new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
        {
            ["Peru"] = "+51",
            ["Per\u00fa"] = "+51",
            ["Mexico"] = "+52",
            ["M\u00e9xico"] = "+52",
            ["Argentina"] = "+54",
            ["Colombia"] = "+57",
            ["Chile"] = "+56",
            ["Ecuador"] = "+593",
            ["Venezuela"] = "+58",
            ["Espana"] = "+34",
            ["Espa\u00f1a"] = "+34"
        };

    private readonly SqlConnectionFactory _connectionFactory;

    public AlumnosService(SqlConnectionFactory connectionFactory)
    {
        _connectionFactory = connectionFactory;
    }

    public async Task<PagedResult<AlumnoListItemDto>> GetAsync(AlumnoQuery query, CancellationToken cancellationToken)
    {
        var pagina = query.Pagina <= 0 ? 1 : query.Pagina;
        var registrosPorPagina = query.RegistrosPorPagina <= 0 ? 30 : query.RegistrosPorPagina;
        var orderBy = OrdenamientoPermitido.TryGetValue(query.OrdenarPor ?? string.Empty, out var mappedColumn)
            ? mappedColumn
            : "A.Nombre";
        var orderDirection = string.Equals(query.Orden, "desc", StringComparison.OrdinalIgnoreCase) ? "DESC" : "ASC";

        var filtros = new List<string> { "1 = 1" };
        var parameters = new List<SqlParameter>();

        if (!string.IsNullOrWhiteSpace(query.Codigo))
        {
            filtros.Add("A.Codigo LIKE @Codigo");
            parameters.Add(new SqlParameter("@Codigo", $"%{query.Codigo.Trim()}%"));
        }

        if (!string.IsNullOrWhiteSpace(query.Nombre))
        {
            filtros.Add("A.Nombre LIKE @Nombre");
            parameters.Add(new SqlParameter("@Nombre", $"%{query.Nombre.Trim()}%"));
        }

        if (query.IdCasa.HasValue)
        {
            filtros.Add("A.IdCasa = @IdCasa");
            parameters.Add(new SqlParameter("@IdCasa", query.IdCasa.Value));
        }

        if (query.Activo.HasValue)
        {
            filtros.Add("A.Activo = @Activo");
            parameters.Add(new SqlParameter("@Activo", query.Activo.Value));
        }

        var whereClause = string.Join(" AND ", filtros);
        var totalRegistros = 0;
        var items = new List<AlumnoListItemDto>();

        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        using (var countCommand = new SqlCommand(
                   $"""
                    SELECT COUNT(*)
                    FROM Alumnos A
                    LEFT JOIN Casas C ON A.IdCasa = C.IdCasa
                    LEFT JOIN Cargos CG ON A.IdCargo = CG.IdCargo
                    WHERE {whereClause}
                    """,
                   connection))
        {
            countCommand.Parameters.AddRange(parameters.Select(CloneParameter).ToArray());
            totalRegistros = Convert.ToInt32(await countCommand.ExecuteScalarAsync(cancellationToken), CultureInfo.InvariantCulture);
        }

        using (var command = new SqlCommand(
                   $"""
                    SELECT
                        A.IdAlumno,
                        A.Codigo,
                        A.Nombre,
                        A.Telefono,
                        A.IdCasa,
                        A.IdCargo,
                        A.Dracoins,
                        A.Activo,
                        ISNULL(A.Categoria, 'Alumno') AS Categoria,
                        C.Nombre AS CasaNombre,
                        ISNULL(CG.Nombre, 'Alumno') AS NombreCargo,
                        A.Genero,
                        A.CorreoElectronico
                    FROM Alumnos A
                    LEFT JOIN Casas C ON A.IdCasa = C.IdCasa
                    LEFT JOIN Cargos CG ON A.IdCargo = CG.IdCargo
                    WHERE {whereClause}
                    ORDER BY {orderBy} {orderDirection}
                    OFFSET @Offset ROWS FETCH NEXT @Fetch ROWS ONLY
                    """,
                   connection))
        {
            command.Parameters.AddRange(parameters.Select(CloneParameter).ToArray());
            command.Parameters.AddWithValue("@Offset", (pagina - 1) * registrosPorPagina);
            command.Parameters.AddWithValue("@Fetch", registrosPorPagina);

            using var reader = await command.ExecuteReaderAsync(cancellationToken);
            while (await reader.ReadAsync(cancellationToken))
            {
                items.Add(new AlumnoListItemDto
                {
                    IdAlumno = GetRequiredInt(reader, "IdAlumno"),
                    Codigo = GetString(reader, "Codigo"),
                    Nombre = GetString(reader, "Nombre"),
                    Telefono = GetString(reader, "Telefono"),
                    IdCasa = GetNullableInt(reader, "IdCasa"),
                    IdCargo = GetNullableInt(reader, "IdCargo"),
                    Dracoins = GetDecimal(reader, "Dracoins"),
                    Activo = GetBool(reader, "Activo"),
                    Categoria = GetString(reader, "Categoria"),
                    CasaNombre = GetString(reader, "CasaNombre"),
                    NombreCargo = GetString(reader, "NombreCargo"),
                    Genero = GetString(reader, "Genero"),
                    CorreoElectronico = GetString(reader, "CorreoElectronico")
                });
            }
        }

        return new PagedResult<AlumnoListItemDto>
        {
            Items = items,
            TotalRegistros = totalRegistros,
            PaginaActual = pagina,
            RegistrosPorPagina = registrosPorPagina
        };
    }

    public async Task<AlumnoDetailDto?> GetByIdAsync(int idAlumno, CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        using var command = new SqlCommand(
            """
            SELECT
                A.IdAlumno,
                A.Codigo,
                A.Nombre,
                A.Telefono,
                A.IdCasa,
                C.Nombre AS CasaNombre,
                A.IdCargo,
                ISNULL(CG.Nombre, 'Alumno') AS NombreCargo,
                ISNULL(A.Puntos, 0) AS Puntos,
                A.Nivel,
                A.Dracoins,
                A.Activo,
                ISNULL(A.Categoria, 'Alumno') AS Categoria,
                A.Genero,
                A.FotoPerfil,
                A.Cumpleanos,
                A.Pais,
                A.PrefijoPais,
                A.ZonaHoraria,
                A.CorreoElectronico
            FROM Alumnos A
            LEFT JOIN Casas C ON A.IdCasa = C.IdCasa
            LEFT JOIN Cargos CG ON A.IdCargo = CG.IdCargo
            WHERE A.IdAlumno = @IdAlumno
            """,
            connection);
        command.Parameters.AddWithValue("@IdAlumno", idAlumno);

        await connection.OpenAsync(cancellationToken);
        using var reader = await command.ExecuteReaderAsync(cancellationToken);
        if (!await reader.ReadAsync(cancellationToken))
        {
            return null;
        }

        return new AlumnoDetailDto
        {
            IdAlumno = GetRequiredInt(reader, "IdAlumno"),
            Codigo = GetString(reader, "Codigo"),
            Nombre = GetString(reader, "Nombre"),
            Telefono = GetString(reader, "Telefono"),
            IdCasa = GetNullableInt(reader, "IdCasa"),
            CasaNombre = GetString(reader, "CasaNombre"),
            IdCargo = GetNullableInt(reader, "IdCargo"),
            NombreCargo = GetString(reader, "NombreCargo"),
            Puntos = GetRequiredInt(reader, "Puntos"),
            Nivel = GetString(reader, "Nivel"),
            Dracoins = GetDecimal(reader, "Dracoins"),
            Activo = GetBool(reader, "Activo"),
            Categoria = GetString(reader, "Categoria"),
            Genero = GetString(reader, "Genero"),
            FotoPerfil = GetString(reader, "FotoPerfil"),
            Cumpleanos = GetNullableDate(reader, "Cumpleanos"),
            Pais = GetString(reader, "Pais"),
            PrefijoPais = GetString(reader, "PrefijoPais"),
            ZonaHoraria = GetString(reader, "ZonaHoraria"),
            CorreoElectronico = GetString(reader, "CorreoElectronico")
        };
    }

    public async Task<int> CreateAsync(SaveAlumnoRequest request, CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        using var command = new SqlCommand(
            $"""
            INSERT INTO Alumnos
            (
                Codigo,
                Nombre,
                Telefono,
                IdCasa,
                Puntos,
                Nivel,
                IdCargo,
                Dracoins,
                Activo,
                Categoria,
                {PasswordColumn},
                FotoPerfil,
                Genero,
                Cumpleanos,
                Pais,
                PrefijoPais,
                ZonaHoraria,
                CorreoElectronico
            )
            VALUES
            (
                @Codigo,
                @Nombre,
                @Telefono,
                @IdCasa,
                @Puntos,
                @Nivel,
                @IdCargo,
                @Dracoins,
                @Activo,
                @Categoria,
                @Contrasena,
                @FotoPerfil,
                @Genero,
                @Cumpleanos,
                @Pais,
                @PrefijoPais,
                @ZonaHoraria,
                @CorreoElectronico
            );

            SELECT CAST(SCOPE_IDENTITY() AS int);
            """,
            connection);

        FillSaveParameters(command, request, includePassword: true);
        await connection.OpenAsync(cancellationToken);

        return Convert.ToInt32(await command.ExecuteScalarAsync(cancellationToken), CultureInfo.InvariantCulture);
    }

    public async Task<bool> UpdateAsync(int idAlumno, SaveAlumnoRequest request, CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        var sql =
            """
            UPDATE Alumnos
            SET
                Codigo = @Codigo,
                Nombre = @Nombre,
                Telefono = @Telefono,
                IdCasa = @IdCasa,
                Puntos = @Puntos,
                Nivel = @Nivel,
                IdCargo = @IdCargo,
                Dracoins = @Dracoins,
                Activo = @Activo,
                Categoria = @Categoria,
                FotoPerfil = @FotoPerfil,
                Genero = @Genero,
                Cumpleanos = @Cumpleanos,
                Pais = @Pais,
                PrefijoPais = @PrefijoPais,
                ZonaHoraria = @ZonaHoraria,
                CorreoElectronico = @CorreoElectronico
            """;

        if (!string.IsNullOrWhiteSpace(request.Contrasena))
        {
            sql += $", {PasswordColumn} = @Contrasena";
        }

        sql += " WHERE IdAlumno = @IdAlumno";

        using var command = new SqlCommand(sql, connection);
        FillSaveParameters(command, request, includePassword: !string.IsNullOrWhiteSpace(request.Contrasena));
        command.Parameters.AddWithValue("@IdAlumno", idAlumno);

        return await command.ExecuteNonQueryAsync(cancellationToken) > 0;
    }

    public async Task<bool> ChangeStatusAsync(int idAlumno, bool activo, CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        using var command = new SqlCommand(
            "UPDATE Alumnos SET Activo = @Activo WHERE IdAlumno = @IdAlumno",
            connection);
        command.Parameters.AddWithValue("@Activo", activo);
        command.Parameters.AddWithValue("@IdAlumno", idAlumno);

        await connection.OpenAsync(cancellationToken);
        return await command.ExecuteNonQueryAsync(cancellationToken) > 0;
    }

    public async Task<bool> DeleteAsync(int idAlumno, CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        using var transaction = connection.BeginTransaction();

        using (var deleteNotesCommand = new SqlCommand(
                   "DELETE FROM NotasAlumno WHERE IdAlumno = @IdAlumno",
                   connection,
                   transaction))
        {
            deleteNotesCommand.Parameters.AddWithValue("@IdAlumno", idAlumno);
            await deleteNotesCommand.ExecuteNonQueryAsync(cancellationToken);
        }

        using var deleteAlumnoCommand = new SqlCommand(
            "DELETE FROM Alumnos WHERE IdAlumno = @IdAlumno",
            connection,
            transaction);
        deleteAlumnoCommand.Parameters.AddWithValue("@IdAlumno", idAlumno);

        var rowsAffected = await deleteAlumnoCommand.ExecuteNonQueryAsync(cancellationToken);
        transaction.Commit();

        return rowsAffected > 0;
    }

    public async Task<string> GetNextCodeAsync(int idCasa, CancellationToken cancellationToken)
    {
        var prefijo = GetCasaPrefix(idCasa);
        var maxValue = 0;

        using var connection = _connectionFactory.CreateConnection();
        using var command = new SqlCommand(
            """
            SELECT Codigo
            FROM Alumnos
            WHERE IdCasa = @IdCasa AND Codigo LIKE @Prefijo + '%'
            """,
            connection);
        command.Parameters.AddWithValue("@IdCasa", idCasa);
        command.Parameters.AddWithValue("@Prefijo", prefijo);

        await connection.OpenAsync(cancellationToken);
        using var reader = await command.ExecuteReaderAsync(cancellationToken);
        while (await reader.ReadAsync(cancellationToken))
        {
            var codigo = GetString(reader, "Codigo");
            var numericPart = new string(codigo.Skip(1).Where(char.IsDigit).ToArray());
            if (int.TryParse(numericPart, out var value) && value > maxValue)
            {
                maxValue = value;
            }
        }

        return $"{prefijo}{maxValue + 1}";
    }

    public async Task<IReadOnlyCollection<CatalogItemDto>> GetCasasAsync(CancellationToken cancellationToken)
    {
        return await GetCatalogAsync(
            "SELECT IdCasa AS Id, Nombre FROM Casas ORDER BY Nombre",
            cancellationToken);
    }

    public async Task<IReadOnlyCollection<CatalogItemDto>> GetCargosAsync(CancellationToken cancellationToken)
    {
        return await GetCatalogAsync(
            "SELECT IdCargo AS Id, Nombre FROM Cargos ORDER BY Nombre",
            cancellationToken);
    }

    public async Task<IReadOnlyCollection<AlumnoNoteDto>> GetNotasAsync(int idAlumno, CancellationToken cancellationToken)
    {
        var notes = new List<AlumnoNoteDto>();

        using var connection = _connectionFactory.CreateConnection();
        using var command = new SqlCommand(
            """
            SELECT IdNota, IdAlumno, Nota, Fecha
            FROM NotasAlumno
            WHERE IdAlumno = @IdAlumno
            ORDER BY Fecha DESC, IdNota DESC
            """,
            connection);
        command.Parameters.AddWithValue("@IdAlumno", idAlumno);

        await connection.OpenAsync(cancellationToken);
        using var reader = await command.ExecuteReaderAsync(cancellationToken);
        while (await reader.ReadAsync(cancellationToken))
        {
            notes.Add(new AlumnoNoteDto
            {
                IdNota = GetRequiredInt(reader, "IdNota"),
                IdAlumno = GetRequiredInt(reader, "IdAlumno"),
                Nota = GetString(reader, "Nota"),
                Fecha = GetNullableDate(reader, "Fecha") ?? DateTime.MinValue
            });
        }

        return notes;
    }

    public async Task<AlumnoNoteDto> CreateNotaAsync(
        int idAlumno,
        CreateAlumnoNoteRequest request,
        CancellationToken cancellationToken)
    {
        var nota = request.Nota.Trim();
        if (nota.Length == 0)
        {
            throw new BusinessRuleException("La nota es obligatoria.");
        }

        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        if (!await AlumnoExistsAsync(connection, idAlumno, cancellationToken))
        {
            throw new BusinessRuleException("El alumno no existe.");
        }

        using var command = new SqlCommand(
            """
            INSERT INTO NotasAlumno (IdAlumno, Nota)
            OUTPUT INSERTED.IdNota, INSERTED.IdAlumno, INSERTED.Nota, INSERTED.Fecha
            VALUES (@IdAlumno, @Nota)
            """,
            connection);
        command.Parameters.AddWithValue("@IdAlumno", idAlumno);
        command.Parameters.AddWithValue("@Nota", nota);

        using var reader = await command.ExecuteReaderAsync(cancellationToken);
        if (!await reader.ReadAsync(cancellationToken))
        {
            throw new BusinessRuleException("No se pudo registrar la nota.");
        }

        return new AlumnoNoteDto
        {
            IdNota = GetRequiredInt(reader, "IdNota"),
            IdAlumno = GetRequiredInt(reader, "IdAlumno"),
            Nota = GetString(reader, "Nota"),
            Fecha = GetNullableDate(reader, "Fecha") ?? DateTime.MinValue
        };
    }

    public async Task<bool> ResetPasswordAsync(
        int idAlumno,
        string nuevaContrasena,
        CancellationToken cancellationToken)
    {
        var rawPassword = nuevaContrasena.Trim();
        if (rawPassword.Length == 0)
        {
            throw new BusinessRuleException("La nueva contrasena es obligatoria.");
        }

        using var connection = _connectionFactory.CreateConnection();
        using var command = new SqlCommand(
            $"UPDATE Alumnos SET {PasswordColumn} = @Contrasena WHERE IdAlumno = @IdAlumno",
            connection);
        command.Parameters.AddWithValue("@Contrasena", PasswordHasher.HashPassword(rawPassword));
        command.Parameters.AddWithValue("@IdAlumno", idAlumno);

        await connection.OpenAsync(cancellationToken);
        return await command.ExecuteNonQueryAsync(cancellationToken) > 0;
    }

    public async Task<bool> UpdateProfileAsync(
        int idAlumno,
        UpdateMyProfileRequest request,
        CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        using var command = new SqlCommand(
            """
            UPDATE Alumnos
            SET
                Telefono = @Telefono,
                CorreoElectronico = @CorreoElectronico,
                Cumpleanos = @Cumpleanos,
                Pais = @Pais,
                PrefijoPais = @PrefijoPais,
                ZonaHoraria = @ZonaHoraria,
                FotoPerfil = @FotoPerfil
            WHERE IdAlumno = @IdAlumno
            """,
            connection);

        command.Parameters.AddWithValue("@IdAlumno", idAlumno);
        command.Parameters.AddWithValue("@Telefono", (object?)request.Telefono?.Trim() ?? DBNull.Value);
        command.Parameters.AddWithValue(
            "@CorreoElectronico",
            (object?)request.CorreoElectronico?.Trim() ?? DBNull.Value);
        command.Parameters.AddWithValue("@Cumpleanos", (object?)request.Cumpleanos ?? DBNull.Value);
        command.Parameters.AddWithValue("@Pais", (object?)request.Pais?.Trim() ?? DBNull.Value);
        command.Parameters.AddWithValue(
            "@PrefijoPais",
            ResolvePrefijoPais(request.Pais, request.PrefijoPais));
        command.Parameters.AddWithValue("@ZonaHoraria", (object?)request.ZonaHoraria?.Trim() ?? DBNull.Value);
        command.Parameters.AddWithValue(
            "@FotoPerfil",
            string.IsNullOrWhiteSpace(request.FotoPerfil) ? DefaultFotoPerfil : request.FotoPerfil.Trim());

        await connection.OpenAsync(cancellationToken);
        return await command.ExecuteNonQueryAsync(cancellationToken) > 0;
    }

    public async Task ChangeOwnPasswordAsync(
        int idAlumno,
        ChangeMyPasswordRequest request,
        CancellationToken cancellationToken)
    {
        var contrasenaActual = request.ContrasenaActual.Trim();
        if (contrasenaActual.Length == 0)
        {
            throw new BusinessRuleException("La contrasena actual es obligatoria.");
        }

        var nuevaContrasena = request.NuevaContrasena.Trim();
        if (nuevaContrasena.Length < 6)
        {
            throw new BusinessRuleException("La nueva contrasena debe tener al menos 6 caracteres.");
        }

        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        string? hashActual;
        using (var readCommand = new SqlCommand(
                   $"SELECT {PasswordColumn} FROM Alumnos WHERE IdAlumno = @IdAlumno",
                   connection))
        {
            readCommand.Parameters.AddWithValue("@IdAlumno", idAlumno);
            var result = await readCommand.ExecuteScalarAsync(cancellationToken);
            if (result is null || result == DBNull.Value)
            {
                throw new BusinessRuleException("El alumno no existe.");
            }

            hashActual = result.ToString();
        }

        if (!string.Equals(hashActual, PasswordHasher.HashPassword(contrasenaActual), StringComparison.Ordinal))
        {
            throw new BusinessRuleException("La contrasena actual es incorrecta.");
        }

        using var updateCommand = new SqlCommand(
            $"UPDATE Alumnos SET {PasswordColumn} = @Contrasena WHERE IdAlumno = @IdAlumno",
            connection);
        updateCommand.Parameters.AddWithValue("@IdAlumno", idAlumno);
        updateCommand.Parameters.AddWithValue("@Contrasena", PasswordHasher.HashPassword(nuevaContrasena));

        await updateCommand.ExecuteNonQueryAsync(cancellationToken);
    }

    private async Task<IReadOnlyCollection<CatalogItemDto>> GetCatalogAsync(
        string sql,
        CancellationToken cancellationToken)
    {
        var items = new List<CatalogItemDto>();

        using var connection = _connectionFactory.CreateConnection();
        using var command = new SqlCommand(sql, connection);
        await connection.OpenAsync(cancellationToken);

        using var reader = await command.ExecuteReaderAsync(cancellationToken);
        while (await reader.ReadAsync(cancellationToken))
        {
            items.Add(new CatalogItemDto
            {
                Id = GetRequiredInt(reader, "Id"),
                Nombre = GetString(reader, "Nombre")
            });
        }

        return items;
    }

    private static async Task<bool> AlumnoExistsAsync(
        SqlConnection connection,
        int idAlumno,
        CancellationToken cancellationToken)
    {
        using var command = new SqlCommand(
            "SELECT COUNT(1) FROM Alumnos WHERE IdAlumno = @IdAlumno",
            connection);
        command.Parameters.AddWithValue("@IdAlumno", idAlumno);

        return Convert.ToInt32(
            await command.ExecuteScalarAsync(cancellationToken),
            CultureInfo.InvariantCulture) > 0;
    }

    private static void FillSaveParameters(SqlCommand command, SaveAlumnoRequest request, bool includePassword)
    {
        command.Parameters.AddWithValue("@Codigo", request.Codigo.Trim());
        command.Parameters.AddWithValue("@Nombre", request.Nombre.Trim());
        command.Parameters.AddWithValue("@Telefono", (object?)request.Telefono?.Trim() ?? DBNull.Value);
        command.Parameters.AddWithValue("@IdCasa", (object?)request.IdCasa ?? DBNull.Value);
        command.Parameters.AddWithValue("@Puntos", request.Puntos);
        command.Parameters.AddWithValue("@Nivel", (object?)request.Nivel?.Trim() ?? DBNull.Value);
        command.Parameters.AddWithValue("@IdCargo", (object?)request.IdCargo ?? DBNull.Value);
        command.Parameters.AddWithValue("@Dracoins", request.Dracoins);
        command.Parameters.AddWithValue("@Activo", request.Activo);
        command.Parameters.AddWithValue("@Categoria", "Alumno");
        command.Parameters.AddWithValue(
            "@FotoPerfil",
            string.IsNullOrWhiteSpace(request.FotoPerfil) ? DefaultFotoPerfil : request.FotoPerfil.Trim());
        command.Parameters.AddWithValue("@Genero", (object?)request.Genero?.Trim() ?? DBNull.Value);
        command.Parameters.AddWithValue("@Cumpleanos", (object?)request.Cumpleanos ?? DBNull.Value);
        command.Parameters.AddWithValue("@Pais", (object?)request.Pais?.Trim() ?? DBNull.Value);
        command.Parameters.AddWithValue(
            "@PrefijoPais",
            ResolvePrefijoPais(request.Pais, request.PrefijoPais));
        command.Parameters.AddWithValue("@ZonaHoraria", (object?)request.ZonaHoraria?.Trim() ?? DBNull.Value);
        command.Parameters.AddWithValue(
            "@CorreoElectronico",
            (object?)request.CorreoElectronico?.Trim() ?? DBNull.Value);

        if (includePassword)
        {
            var rawPassword = string.IsNullOrWhiteSpace(request.Contrasena) ? "123456" : request.Contrasena.Trim();
            command.Parameters.AddWithValue("@Contrasena", PasswordHasher.HashPassword(rawPassword));
        }
    }

    private static string GetCasaPrefix(int idCasa) =>
        idCasa switch
        {
            1 => "G",
            2 => "H",
            3 => "R",
            4 => "S",
            _ => "A"
        };

    private static object ResolvePrefijoPais(string? pais, string? prefijoPais)
    {
        if (!string.IsNullOrWhiteSpace(prefijoPais))
        {
            return prefijoPais.Trim();
        }

        if (!string.IsNullOrWhiteSpace(pais) && PrefijosPais.TryGetValue(pais.Trim(), out var prefijo))
        {
            return prefijo;
        }

        return DBNull.Value;
    }

    private static SqlParameter CloneParameter(SqlParameter parameter) =>
        new(parameter.ParameterName, parameter.Value);

    private static string GetString(SqlDataReader reader, string columnName) =>
        reader[columnName] == DBNull.Value ? string.Empty : reader[columnName]?.ToString() ?? string.Empty;

    private static int GetRequiredInt(SqlDataReader reader, string columnName) =>
        Convert.ToInt32(reader[columnName], CultureInfo.InvariantCulture);

    private static int? GetNullableInt(SqlDataReader reader, string columnName) =>
        reader[columnName] == DBNull.Value
            ? null
            : Convert.ToInt32(reader[columnName], CultureInfo.InvariantCulture);

    private static bool GetBool(SqlDataReader reader, string columnName) =>
        reader[columnName] != DBNull.Value && Convert.ToBoolean(reader[columnName], CultureInfo.InvariantCulture);

    private static decimal GetDecimal(SqlDataReader reader, string columnName) =>
        reader[columnName] == DBNull.Value
            ? 0m
            : Convert.ToDecimal(reader[columnName], CultureInfo.InvariantCulture);

    private static DateTime? GetNullableDate(SqlDataReader reader, string columnName) =>
        reader[columnName] == DBNull.Value
            ? null
            : Convert.ToDateTime(reader[columnName], CultureInfo.InvariantCulture);
}
