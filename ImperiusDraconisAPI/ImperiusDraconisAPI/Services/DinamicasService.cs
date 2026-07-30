using System.Globalization;
using System.Text;
using ImperiusDraconisAPI.Common;
using ImperiusDraconisAPI.Data;
using ImperiusDraconisAPI.Models.Dinamicas;
using MySqlConnector;

namespace ImperiusDraconisAPI.Services;

public sealed class DinamicasService
{
    private readonly MySqlConnectionFactory _connectionFactory;

    public DinamicasService(MySqlConnectionFactory connectionFactory)
    {
        _connectionFactory = connectionFactory;
    }

    public async Task<PagedResult<DinamicaListItemDto>> GetDinamicasAsync(
        DinamicasQuery query,
        CancellationToken cancellationToken)
    {
        var normalizedPage = query.Pagina <= 0 ? 1 : query.Pagina;
        var normalizedPageSize = query.RegistrosPorPagina <= 0 ? 10 : query.RegistrosPorPagina;

        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        var whereClause = BuildWhereClause(query, out var parameters);

        var totalRegistros = 0;
        using (var countCommand = new MySqlCommand(
                   $"""
                   SELECT COUNT(*)
                   FROM Dinamicas D
                   LEFT JOIN Alumnos A ON D.IdResponsable = A.IdAlumno
                   {whereClause}
                   """,
                   connection))
        {
            AddParameters(countCommand, parameters);
            totalRegistros = Convert.ToInt32(await countCommand.ExecuteScalarAsync(cancellationToken));
        }

        var items = new List<DinamicaListItemDto>();
        using (var command = new MySqlCommand(
                   $"""
                   SELECT
                       D.IdDinamica,
                       D.Fecha,
                       D.Nombre,
                       COALESCE(D.Tipo, '') AS Tipo,
                       COALESCE(D.Subtipo, '') AS Subtipo,
                       D.IdResponsable,
                       COALESCE(A.Nombre, '') AS NombreResponsable,
                       COALESCE(D.Observacion, '') AS Observacion
                   FROM Dinamicas D
                   LEFT JOIN Alumnos A ON D.IdResponsable = A.IdAlumno
                   {whereClause}
                   ORDER BY D.IdDinamica DESC
                   LIMIT @Fetch OFFSET @Offset
                   """,
                   connection))
        {
            AddParameters(command, parameters);
            command.Parameters.AddWithValue("@Offset", (normalizedPage - 1) * normalizedPageSize);
            command.Parameters.AddWithValue("@Fetch", normalizedPageSize);

            using var reader = await command.ExecuteReaderAsync(cancellationToken);
            while (await reader.ReadAsync(cancellationToken))
            {
                items.Add(new DinamicaListItemDto
                {
                    IdDinamica = GetRequiredInt(reader, "IdDinamica"),
                    Fecha = GetNullableDateTime(reader, "Fecha"),
                    Nombre = GetString(reader, "Nombre"),
                    Tipo = GetString(reader, "Tipo"),
                    Subtipo = GetString(reader, "Subtipo"),
                    IdResponsable = GetNullableInt(reader, "IdResponsable"),
                    NombreResponsable = GetString(reader, "NombreResponsable"),
                    Observacion = GetString(reader, "Observacion")
                });
            }
        }

        return new PagedResult<DinamicaListItemDto>
        {
            Items = items,
            TotalRegistros = totalRegistros,
            PaginaActual = normalizedPage,
            RegistrosPorPagina = normalizedPageSize
        };
    }

    public async Task<DinamicaPuntosDetailDto?> GetPointsDetailAsync(int idDinamica, CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        var dinamica = await GetDinamicaBaseAsync(connection, idDinamica, cancellationToken);
        if (dinamica is null)
        {
            return null;
        }

        var resultados = new List<PuntosCasaDetalleDto>();
        using (var command = new MySqlCommand(
                   """
                   SELECT
                       R.IdCasa,
                       C.Nombre AS NombreCasa,
                       R.PuntosOtorgados
                   FROM ResultadosPorCasa R
                   INNER JOIN Casas C ON C.IdCasa = R.IdCasa
                   WHERE R.IdDinamica = @IdDinamica
                   ORDER BY C.IdCasa
                   """,
                   connection))
        {
            command.Parameters.AddWithValue("@IdDinamica", idDinamica);

            using var reader = await command.ExecuteReaderAsync(cancellationToken);
            while (await reader.ReadAsync(cancellationToken))
            {
                resultados.Add(new PuntosCasaDetalleDto
                {
                    IdCasa = GetRequiredInt(reader, "IdCasa"),
                    NombreCasa = GetString(reader, "NombreCasa"),
                    PuntosOtorgados = GetRequiredInt(reader, "PuntosOtorgados")
                });
            }
        }

        return new DinamicaPuntosDetailDto
        {
            IdDinamica = dinamica.IdDinamica,
            Fecha = dinamica.Fecha,
            Nombre = dinamica.Nombre,
            Tipo = dinamica.Tipo,
            Subtipo = dinamica.Subtipo,
            IdResponsable = dinamica.IdResponsable,
            NombreResponsable = dinamica.NombreResponsable,
            Observacion = dinamica.Observacion,
            Resultados = resultados
        };
    }

    public async Task<DinamicaDracoinsDetailDto?> GetDracoinsDetailAsync(
        int idDinamica,
        CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        var dinamica = await GetDinamicaBaseAsync(connection, idDinamica, cancellationToken);
        if (dinamica is null)
        {
            return null;
        }

        var resultados = new List<DracoinDinamicaDetalleItemDto>();
        using (var command = new MySqlCommand(
                   """
                   SELECT
                       DD.IdAlumno,
                       A.Codigo AS CodigoAlumno,
                       A.Nombre AS NombreAlumno,
                       DD.DracoinsOtorgados,
                       COALESCE(DD.Observacion, '') AS Observacion
                   FROM DracoinsDinamica DD
                   INNER JOIN Alumnos A ON A.IdAlumno = DD.IdAlumno
                   WHERE DD.IdDinamica = @IdDinamica
                   ORDER BY A.Nombre
                   """,
                   connection))
        {
            command.Parameters.AddWithValue("@IdDinamica", idDinamica);

            using var reader = await command.ExecuteReaderAsync(cancellationToken);
            while (await reader.ReadAsync(cancellationToken))
            {
                resultados.Add(new DracoinDinamicaDetalleItemDto
                {
                    IdAlumno = GetRequiredInt(reader, "IdAlumno"),
                    CodigoAlumno = GetString(reader, "CodigoAlumno"),
                    NombreAlumno = GetString(reader, "NombreAlumno"),
                    DracoinsOtorgados = GetRequiredInt(reader, "DracoinsOtorgados"),
                    Observacion = GetString(reader, "Observacion")
                });
            }
        }

        return new DinamicaDracoinsDetailDto
        {
            IdDinamica = dinamica.IdDinamica,
            Fecha = dinamica.Fecha,
            Nombre = dinamica.Nombre,
            Tipo = dinamica.Tipo,
            Subtipo = dinamica.Subtipo,
            IdResponsable = dinamica.IdResponsable,
            NombreResponsable = dinamica.NombreResponsable,
            Observacion = dinamica.Observacion,
            TotalDracoinsOtorgados = resultados.Sum(item => item.DracoinsOtorgados),
            Resultados = resultados
        };
    }

    public async Task<IReadOnlyList<AlumnoActivoDto>> GetActiveStudentsAsync(CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        var items = new List<AlumnoActivoDto>();
        using var command = new MySqlCommand(
            """
            SELECT
                A.IdAlumno,
                A.Codigo,
                A.Nombre,
                A.Emojis,
                A.IdCasa,
                C.Nombre AS CasaNombre,
                A.Dracoins
            FROM Alumnos A
            LEFT JOIN Casas C ON C.IdCasa = A.IdCasa
            WHERE A.Activo = 1
            ORDER BY A.Codigo
            """,
            connection);

        using var reader = await command.ExecuteReaderAsync(cancellationToken);
        while (await reader.ReadAsync(cancellationToken))
        {
            items.Add(new AlumnoActivoDto
            {
                IdAlumno = GetRequiredInt(reader, "IdAlumno"),
                Codigo = GetString(reader, "Codigo"),
                Nombre = GetString(reader, "Nombre"),
                Emojis = GetString(reader, "Emojis"),
                IdCasa = GetNullableInt(reader, "IdCasa"),
                CasaNombre = GetString(reader, "CasaNombre"),
                Dracoins = GetDecimal(reader, "Dracoins")
            });
        }

        return items;
    }

    public async Task<DinamicaDracoinsDetailDto> CreateDracoinsDinamicaAsync(
        int idResponsable,
        RegistrarDinamicaDracoinsRequest request,
        CancellationToken cancellationToken)
    {
        if (idResponsable <= 0)
        {
            throw new BusinessRuleException("No se pudo identificar al responsable de la dinamica.");
        }

        var nombre = request.Nombre.Trim();
        if (string.IsNullOrWhiteSpace(nombre))
        {
            throw new BusinessRuleException("El nombre de la dinamica es obligatorio.");
        }

        var observacion = request.Observacion?.Trim();

        var asignaciones = request.Asignaciones
            .Where(item => item.DracoinsOtorgados > 0)
            .ToArray();

        if (asignaciones.Length == 0)
        {
            throw new BusinessRuleException("Debes asignar Dracoins mayores a cero a por lo menos un alumno.");
        }

        if (asignaciones.Select(item => item.IdAlumno).Distinct().Count() != asignaciones.Length)
        {
            throw new BusinessRuleException("No puedes repetir alumnos dentro de la misma dinamica.");
        }

        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        var alumnos = await GetActiveStudentsLookupAsync(connection, asignaciones.Select(item => item.IdAlumno), cancellationToken);
        if (alumnos.Count != asignaciones.Length)
        {
            throw new BusinessRuleException("Una o mas asignaciones apuntan a alumnos inexistentes o inactivos.");
        }

        await using var transaction = await connection.BeginTransactionAsync(cancellationToken);

        try
        {
            int idDinamica;
            using (var command = new MySqlCommand(
                       """
                       INSERT INTO Dinamicas (Nombre, Tipo, Subtipo, Fecha, IdResponsable, Observacion)
                       VALUES (@Nombre, 'Dracoins', NULL, @Fecha, @IdResponsable, @Observacion);
                       SELECT CAST(SCOPE_IDENTITY() AS int);
                       """,
                       connection,
                       (MySqlTransaction)transaction))
            {
                command.Parameters.AddWithValue("@Nombre", nombre);
                command.Parameters.AddWithValue("@Fecha", DateTime.Today);
                command.Parameters.AddWithValue("@IdResponsable", idResponsable);
                command.Parameters.AddWithValue("@Observacion", string.IsNullOrWhiteSpace(observacion) ? DBNull.Value : observacion);
                idDinamica = Convert.ToInt32(await command.ExecuteScalarAsync(cancellationToken), CultureInfo.InvariantCulture);
            }

            foreach (var asignacion in asignaciones)
            {
                var alumno = alumnos[asignacion.IdAlumno];
                var detalleObservacion = string.IsNullOrWhiteSpace(observacion)
                    ? asignacion.Observacion?.Trim()
                    : observacion;

                using (var insertDetailCommand = new MySqlCommand(
                           """
                           INSERT INTO DracoinsDinamica (IdDinamica, IdAlumno, DracoinsOtorgados, Observacion)
                           VALUES (@IdDinamica, @IdAlumno, @DracoinsOtorgados, @Observacion)
                           """,
                           connection,
                           (MySqlTransaction)transaction))
                {
                    insertDetailCommand.Parameters.AddWithValue("@IdDinamica", idDinamica);
                    insertDetailCommand.Parameters.AddWithValue("@IdAlumno", asignacion.IdAlumno);
                    insertDetailCommand.Parameters.AddWithValue("@DracoinsOtorgados", asignacion.DracoinsOtorgados);
                    insertDetailCommand.Parameters.AddWithValue(
                        "@Observacion",
                        string.IsNullOrWhiteSpace(detalleObservacion) ? DBNull.Value : detalleObservacion);
                    await insertDetailCommand.ExecuteNonQueryAsync(cancellationToken);
                }

                using (var updateAlumnoCommand = new MySqlCommand(
                           """
                           UPDATE Alumnos
                           SET Dracoins = Dracoins + @DracoinsOtorgados
                           WHERE IdAlumno = @IdAlumno
                           """,
                           connection,
                           (MySqlTransaction)transaction))
                {
                    updateAlumnoCommand.Parameters.AddWithValue("@DracoinsOtorgados", asignacion.DracoinsOtorgados);
                    updateAlumnoCommand.Parameters.AddWithValue("@IdAlumno", asignacion.IdAlumno);
                    await updateAlumnoCommand.ExecuteNonQueryAsync(cancellationToken);
                }

                using (var movementCommand = new MySqlCommand(
                           "RegistrarMovimientoDracoins",
                           connection,
                           (MySqlTransaction)transaction))
                {
                    movementCommand.CommandType = System.Data.CommandType.StoredProcedure;
                    movementCommand.Parameters.AddWithValue("@CodigoRemitente", "DINAMICA");
                    movementCommand.Parameters.AddWithValue("@CodigoDestinatario", alumno.Codigo);
                    movementCommand.Parameters.AddWithValue("@Monto", asignacion.DracoinsOtorgados);
                    movementCommand.Parameters.AddWithValue(
                        "@Observacion",
                        BuildMovementObservation(nombre, observacion));

                    await movementCommand.ExecuteScalarAsync(cancellationToken);
                }
            }

            await transaction.CommitAsync(cancellationToken);

            return await GetDracoinsDetailAsync(idDinamica, cancellationToken)
                   ?? throw new InvalidOperationException("No se pudo recuperar la dinamica creada.");
        }
        catch
        {
            await transaction.RollbackAsync(cancellationToken);
            throw;
        }
    }

    public async Task<bool> DeleteDinamicaAsync(int idDinamica, CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        await using var transaction = await connection.BeginTransactionAsync(cancellationToken);

        try
        {
            string? tipo;
            using (var typeCommand = new MySqlCommand(
                       "SELECT Tipo FROM Dinamicas WHERE IdDinamica = @IdDinamica",
                       connection,
                       (MySqlTransaction)transaction))
            {
                typeCommand.Parameters.AddWithValue("@IdDinamica", idDinamica);
                tipo = (await typeCommand.ExecuteScalarAsync(cancellationToken))?.ToString();
            }

            if (string.IsNullOrWhiteSpace(tipo))
            {
                await transaction.RollbackAsync(cancellationToken);
                return false;
            }

            if (string.Equals(tipo, "Puntos", StringComparison.OrdinalIgnoreCase))
            {
                using (var reversePointsCommand = new MySqlCommand(
                           """
                           UPDATE M
                           SET M.PuntosAcumulados = M.PuntosAcumulados - T.Puntos
                           FROM MarcadorActual M
                           INNER JOIN (
                               SELECT IdCasa, SUM(PuntosOtorgados) AS Puntos
                               FROM ResultadosPorCasa
                               WHERE IdDinamica = @IdDinamica
                               GROUP BY IdCasa
                           ) T ON T.IdCasa = M.IdCasa
                           """,
                           connection,
                           (MySqlTransaction)transaction))
                {
                    reversePointsCommand.Parameters.AddWithValue("@IdDinamica", idDinamica);
                    await reversePointsCommand.ExecuteNonQueryAsync(cancellationToken);
                }

                using var deletePointsCommand = new MySqlCommand(
                    "DELETE FROM ResultadosPorCasa WHERE IdDinamica = @IdDinamica",
                    connection,
                    (MySqlTransaction)transaction);
                deletePointsCommand.Parameters.AddWithValue("@IdDinamica", idDinamica);
                await deletePointsCommand.ExecuteNonQueryAsync(cancellationToken);
            }
            else if (string.Equals(tipo, "Dracoins", StringComparison.OrdinalIgnoreCase))
            {
                using (var reverseDracoinsCommand = new MySqlCommand(
                           """
                           UPDATE A
                           SET A.Dracoins = A.Dracoins - T.Total
                           FROM Alumnos A
                           INNER JOIN (
                               SELECT IdAlumno, SUM(DracoinsOtorgados) AS Total
                               FROM DracoinsDinamica
                               WHERE IdDinamica = @IdDinamica
                               GROUP BY IdAlumno
                           ) T ON T.IdAlumno = A.IdAlumno
                           """,
                           connection,
                           (MySqlTransaction)transaction))
                {
                    reverseDracoinsCommand.Parameters.AddWithValue("@IdDinamica", idDinamica);
                    await reverseDracoinsCommand.ExecuteNonQueryAsync(cancellationToken);
                }

                using var deleteDracoinsCommand = new MySqlCommand(
                    "DELETE FROM DracoinsDinamica WHERE IdDinamica = @IdDinamica",
                    connection,
                    (MySqlTransaction)transaction);
                deleteDracoinsCommand.Parameters.AddWithValue("@IdDinamica", idDinamica);
                await deleteDracoinsCommand.ExecuteNonQueryAsync(cancellationToken);
            }
            else
            {
                using (var reversePointsCommand = new MySqlCommand(
                           """
                           UPDATE M
                           SET M.PuntosAcumulados = M.PuntosAcumulados - T.Puntos
                           FROM MarcadorActual M
                           INNER JOIN (
                               SELECT IdCasa, SUM(PuntosOtorgados) AS Puntos
                               FROM ResultadosPorCasa
                               WHERE IdDinamica = @IdDinamica
                               GROUP BY IdCasa
                           ) T ON T.IdCasa = M.IdCasa
                           """,
                           connection,
                           (MySqlTransaction)transaction))
                {
                    reversePointsCommand.Parameters.AddWithValue("@IdDinamica", idDinamica);
                    await reversePointsCommand.ExecuteNonQueryAsync(cancellationToken);
                }

                using (var deletePointsCommand = new MySqlCommand(
                           "DELETE FROM ResultadosPorCasa WHERE IdDinamica = @IdDinamica",
                           connection,
                           (MySqlTransaction)transaction))
                {
                    deletePointsCommand.Parameters.AddWithValue("@IdDinamica", idDinamica);
                    await deletePointsCommand.ExecuteNonQueryAsync(cancellationToken);
                }

                using (var reverseDracoinsCommand = new MySqlCommand(
                           """
                           UPDATE A
                           SET A.Dracoins = A.Dracoins - T.Total
                           FROM Alumnos A
                           INNER JOIN (
                               SELECT IdAlumno, SUM(DracoinsOtorgados) AS Total
                               FROM DracoinsDinamica
                               WHERE IdDinamica = @IdDinamica
                               GROUP BY IdAlumno
                           ) T ON T.IdAlumno = A.IdAlumno
                           """,
                           connection,
                           (MySqlTransaction)transaction))
                {
                    reverseDracoinsCommand.Parameters.AddWithValue("@IdDinamica", idDinamica);
                    await reverseDracoinsCommand.ExecuteNonQueryAsync(cancellationToken);
                }

                using (var deleteDracoinsCommand = new MySqlCommand(
                           "DELETE FROM DracoinsDinamica WHERE IdDinamica = @IdDinamica",
                           connection,
                           (MySqlTransaction)transaction))
                {
                    deleteDracoinsCommand.Parameters.AddWithValue("@IdDinamica", idDinamica);
                    await deleteDracoinsCommand.ExecuteNonQueryAsync(cancellationToken);
                }
            }

            using (var deleteDinamicaCommand = new MySqlCommand(
                       "DELETE FROM Dinamicas WHERE IdDinamica = @IdDinamica",
                       connection,
                       (MySqlTransaction)transaction))
            {
                deleteDinamicaCommand.Parameters.AddWithValue("@IdDinamica", idDinamica);
                var affectedRows = await deleteDinamicaCommand.ExecuteNonQueryAsync(cancellationToken);
                if (affectedRows == 0)
                {
                    await transaction.RollbackAsync(cancellationToken);
                    return false;
                }
            }

            await transaction.CommitAsync(cancellationToken);
            return true;
        }
        catch
        {
            await transaction.RollbackAsync(cancellationToken);
            throw;
        }
    }

    public async Task<IReadOnlyList<AgendaDinamicaDto>> GetAgendaAsync(
        DateTime? fecha,
        CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);
        return await GetAgendaInternalAsync(connection, fecha?.Date, cancellationToken);
    }

    public async Task<AgendaDinamicaDto?> GetAgendaItemAsync(int idAgenda, CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);
        return await GetAgendaItemInternalAsync(connection, idAgenda, cancellationToken);
    }

    public async Task<IReadOnlyList<AgendaResponsableDto>> GetAgendaResponsablesAsync(CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);
        return await GetAgendaResponsablesInternalAsync(connection, cancellationToken);
    }

    public async Task<IReadOnlyList<AgendaDinamicaDto>> CreateAgendaBatchAsync(
        AgendaCreateBatchRequest request,
        CancellationToken cancellationToken)
    {
        var fecha = RequireDate(request.Fecha, "La fecha de agenda es obligatoria.");
        var items = request.Items;
        if (items.Count == 0)
        {
            throw new BusinessRuleException("Debes registrar al menos un bloque de agenda.");
        }

        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        var responsables = (await GetAgendaResponsablesInternalAsync(connection, cancellationToken))
            .ToDictionary(item => item.IdAlumno);

        foreach (var item in items)
        {
            ValidateAgendaItem(item.Hora, item.IdAlumno, item.Titulo);
            if (!responsables.ContainsKey(item.IdAlumno))
            {
                throw new BusinessRuleException("Uno o mas responsables de agenda no son validos.");
            }
        }

        await using var transaction = await connection.BeginTransactionAsync(cancellationToken);

        try
        {
            foreach (var item in items)
            {
                using var command = new MySqlCommand(
                    """
                    INSERT INTO AgendaDinamicas (Fecha, Hora, IdAlumno, Titulo)
                    VALUES (@Fecha, @Hora, @IdAlumno, @Titulo)
                    """,
                    connection,
                    (MySqlTransaction)transaction);
                command.Parameters.AddWithValue("@Fecha", fecha);
                command.Parameters.AddWithValue("@Hora", ParseTime(item.Hora, "Hora invalida en la agenda."));
                command.Parameters.AddWithValue("@IdAlumno", item.IdAlumno);
                command.Parameters.AddWithValue("@Titulo", item.Titulo.Trim());
                await command.ExecuteNonQueryAsync(cancellationToken);
            }

            await transaction.CommitAsync(cancellationToken);
            return await GetAgendaInternalAsync(connection, fecha, cancellationToken);
        }
        catch
        {
            await transaction.RollbackAsync(cancellationToken);
            throw;
        }
    }

    public async Task<AgendaDinamicaDto?> UpdateAgendaAsync(
        int idAgenda,
        AgendaUpdateRequest request,
        CancellationToken cancellationToken)
    {
        var fecha = RequireDate(request.Fecha, "La fecha de agenda es obligatoria.");
        var hora = ParseTime(request.Hora, "La hora de agenda es invalida.");
        var titulo = RequireTitle(request.Titulo, "El titulo de agenda es obligatorio.");

        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        var responsables = (await GetAgendaResponsablesInternalAsync(connection, cancellationToken))
            .ToDictionary(item => item.IdAlumno);
        if (!responsables.ContainsKey(request.IdAlumno))
        {
            throw new BusinessRuleException("El responsable seleccionado no es valido para la agenda.");
        }

        using (var command = new MySqlCommand(
                   """
                   UPDATE AgendaDinamicas
                   SET Fecha = @Fecha,
                       Hora = @Hora,
                       IdAlumno = @IdAlumno,
                       Titulo = @Titulo
                   WHERE IdAgenda = @IdAgenda
                   """,
                   connection))
        {
            command.Parameters.AddWithValue("@Fecha", fecha);
            command.Parameters.AddWithValue("@Hora", hora);
            command.Parameters.AddWithValue("@IdAlumno", request.IdAlumno);
            command.Parameters.AddWithValue("@Titulo", titulo);
            command.Parameters.AddWithValue("@IdAgenda", idAgenda);

            var affectedRows = await command.ExecuteNonQueryAsync(cancellationToken);
            if (affectedRows == 0)
            {
                return null;
            }
        }

        return await GetAgendaItemInternalAsync(connection, idAgenda, cancellationToken);
    }

    public async Task<bool> DeleteAgendaAsync(int idAgenda, CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        using var command = new MySqlCommand(
            "DELETE FROM AgendaDinamicas WHERE IdAgenda = @IdAgenda",
            connection);
        command.Parameters.AddWithValue("@IdAgenda", idAgenda);

        return await command.ExecuteNonQueryAsync(cancellationToken) > 0;
    }

    public async Task<int> ClearAgendaAsync(CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        using var command = new MySqlCommand("DELETE FROM AgendaDinamicas", connection);
        return await command.ExecuteNonQueryAsync(cancellationToken);
    }

    private static string BuildWhereClause(
        DinamicasQuery query,
        out IReadOnlyList<(string Name, object Value)> parameters)
    {
        var conditions = new List<string>();
        var values = new List<(string Name, object Value)>();

        if (!string.IsNullOrWhiteSpace(query.Nombre))
        {
            conditions.Add("D.Nombre LIKE @Nombre");
            values.Add(("@Nombre", $"%{query.Nombre.Trim()}%"));
        }

        if (!string.IsNullOrWhiteSpace(query.Tipo))
        {
            conditions.Add("D.Tipo = @Tipo");
            values.Add(("@Tipo", query.Tipo.Trim()));
        }

        if (!string.IsNullOrWhiteSpace(query.Subtipo))
        {
            conditions.Add("D.Subtipo LIKE @Subtipo");
            values.Add(("@Subtipo", $"%{query.Subtipo.Trim()}%"));
        }

        if (!string.IsNullOrWhiteSpace(query.Responsable))
        {
            conditions.Add("A.Nombre LIKE @Responsable");
            values.Add(("@Responsable", $"%{query.Responsable.Trim()}%"));
        }

        if (query.Desde.HasValue)
        {
            conditions.Add("D.Fecha >= @Desde");
            values.Add(("@Desde", query.Desde.Value.Date));
        }

        if (query.Hasta.HasValue)
        {
            conditions.Add("D.Fecha <= @Hasta");
            values.Add(("@Hasta", query.Hasta.Value.Date));
        }

        parameters = values;
        return conditions.Count == 0 ? string.Empty : $"WHERE {string.Join(" AND ", conditions)}";
    }

    private static void AddParameters(MySqlCommand command, IReadOnlyList<(string Name, object Value)> parameters)
    {
        foreach (var parameter in parameters)
        {
            command.Parameters.AddWithValue(parameter.Name, parameter.Value);
        }
    }

    private static async Task<DinamicaListItemDto?> GetDinamicaBaseAsync(
        MySqlConnection connection,
        int idDinamica,
        CancellationToken cancellationToken)
    {
        using var command = new MySqlCommand(
            """
            SELECT
                D.IdDinamica,
                D.Fecha,
                D.Nombre,
                COALESCE(D.Tipo, '') AS Tipo,
                COALESCE(D.Subtipo, '') AS Subtipo,
                D.IdResponsable,
                COALESCE(A.Nombre, '') AS NombreResponsable,
                COALESCE(D.Observacion, '') AS Observacion
            FROM Dinamicas D
            LEFT JOIN Alumnos A ON D.IdResponsable = A.IdAlumno
            WHERE D.IdDinamica = @IdDinamica
            """,
            connection);
        command.Parameters.AddWithValue("@IdDinamica", idDinamica);

        using var reader = await command.ExecuteReaderAsync(cancellationToken);
        if (!await reader.ReadAsync(cancellationToken))
        {
            return null;
        }

        return new DinamicaListItemDto
        {
            IdDinamica = GetRequiredInt(reader, "IdDinamica"),
            Fecha = GetNullableDateTime(reader, "Fecha"),
            Nombre = GetString(reader, "Nombre"),
            Tipo = GetString(reader, "Tipo"),
            Subtipo = GetString(reader, "Subtipo"),
            IdResponsable = GetNullableInt(reader, "IdResponsable"),
            NombreResponsable = GetString(reader, "NombreResponsable"),
            Observacion = GetString(reader, "Observacion")
        };
    }

    private static async Task<IReadOnlyList<AgendaDinamicaDto>> GetAgendaInternalAsync(
        MySqlConnection connection,
        DateTime? fecha,
        CancellationToken cancellationToken)
    {
        var items = new List<AgendaDinamicaDto>();
        using var command = new MySqlCommand(
            """
            SELECT
                A.IdAgenda,
                A.Fecha,
                A.Hora,
                A.IdAlumno,
                COALESCE(AL.Nombre, '') AS NombreAlumno,
                COALESCE(C.Nombre, '') AS Cargo,
                COALESCE(AL.Genero, '') AS Genero,
                COALESCE(A.Titulo, '') AS Titulo
            FROM AgendaDinamicas A
            INNER JOIN Alumnos AL ON A.IdAlumno = AL.IdAlumno
            INNER JOIN Cargos C ON AL.IdCargo = C.IdCargo
            WHERE (@Fecha IS NULL OR A.Fecha = @Fecha)
            ORDER BY A.Fecha, A.Hora
            """,
            connection);
        command.Parameters.AddWithValue("@Fecha", fecha.HasValue ? fecha.Value : DBNull.Value);

        using var reader = await command.ExecuteReaderAsync(cancellationToken);
        while (await reader.ReadAsync(cancellationToken))
        {
            items.Add(MapAgenda(reader));
        }

        return items;
    }

    private static async Task<AgendaDinamicaDto?> GetAgendaItemInternalAsync(
        MySqlConnection connection,
        int idAgenda,
        CancellationToken cancellationToken)
    {
        using var command = new MySqlCommand(
            """
            SELECT
                A.IdAgenda,
                A.Fecha,
                A.Hora,
                A.IdAlumno,
                COALESCE(AL.Nombre, '') AS NombreAlumno,
                COALESCE(C.Nombre, '') AS Cargo,
                COALESCE(AL.Genero, '') AS Genero,
                COALESCE(A.Titulo, '') AS Titulo
            FROM AgendaDinamicas A
            INNER JOIN Alumnos AL ON A.IdAlumno = AL.IdAlumno
            INNER JOIN Cargos C ON AL.IdCargo = C.IdCargo
            WHERE A.IdAgenda = @IdAgenda
            """,
            connection);
        command.Parameters.AddWithValue("@IdAgenda", idAgenda);

        using var reader = await command.ExecuteReaderAsync(cancellationToken);
        if (!await reader.ReadAsync(cancellationToken))
        {
            return null;
        }

        return MapAgenda(reader);
    }

    private static async Task<IReadOnlyList<AgendaResponsableDto>> GetAgendaResponsablesInternalAsync(
        MySqlConnection connection,
        CancellationToken cancellationToken)
    {
        var items = new List<AgendaResponsableDto>();
        using var command = new MySqlCommand(
            """
            SELECT
                AL.IdAlumno,
                AL.Nombre,
                C.Nombre AS Cargo,
                COALESCE(AL.Genero, '') AS Genero
            FROM Alumnos AL
            INNER JOIN Cargos C ON AL.IdCargo = C.IdCargo
            WHERE AL.Activo = 1
              AND C.Nombre <> 'Alumno'
            ORDER BY AL.Nombre
            """,
            connection);

        using var reader = await command.ExecuteReaderAsync(cancellationToken);
        while (await reader.ReadAsync(cancellationToken))
        {
            items.Add(new AgendaResponsableDto
            {
                IdAlumno = GetRequiredInt(reader, "IdAlumno"),
                Nombre = GetString(reader, "Nombre"),
                Cargo = GetString(reader, "Cargo"),
                Genero = GetString(reader, "Genero")
            });
        }

        return items;
    }

    private static async Task<Dictionary<int, AlumnoActivoDto>> GetActiveStudentsLookupAsync(
        MySqlConnection connection,
        IEnumerable<int> idsAlumnos,
        CancellationToken cancellationToken)
    {
        var ids = idsAlumnos.Distinct().ToArray();
        if (ids.Length == 0)
        {
            return [];
        }

        var parameterNames = ids.Select((_, index) => $"@IdAlumno{index}").ToArray();
        var sql =
            $"""
            SELECT IdAlumno, Codigo, Nombre, Emojis, Dracoins
            FROM Alumnos
            WHERE Activo = 1
              AND IdAlumno IN ({string.Join(", ", parameterNames)})
            """;

        using var command = new MySqlCommand(sql, connection);
        for (var index = 0; index < ids.Length; index++)
        {
            command.Parameters.AddWithValue(parameterNames[index], ids[index]);
        }

        var result = new Dictionary<int, AlumnoActivoDto>();
        using var reader = await command.ExecuteReaderAsync(cancellationToken);
        while (await reader.ReadAsync(cancellationToken))
        {
            var item = new AlumnoActivoDto
            {
                IdAlumno = GetRequiredInt(reader, "IdAlumno"),
                Codigo = GetString(reader, "Codigo"),
                Nombre = GetString(reader, "Nombre"),
                Emojis = GetString(reader, "Emojis"),
                Dracoins = GetDecimal(reader, "Dracoins")
            };
            result[item.IdAlumno] = item;
        }

        return result;
    }

    private static string BuildMovementObservation(string nombreDinamica, string? observacion)
    {
        var builder = new StringBuilder();
        builder.Append("Dinamica: ").Append(nombreDinamica);

        if (!string.IsNullOrWhiteSpace(observacion))
        {
            builder.Append(" - ").Append(observacion.Trim());
        }

        return builder.ToString();
    }

    private static void ValidateAgendaItem(string hora, int idAlumno, string titulo)
    {
        ParseTime(hora, "La hora de agenda es invalida.");
        if (idAlumno <= 0)
        {
            throw new BusinessRuleException("El responsable de agenda es obligatorio.");
        }

        RequireTitle(titulo, "El titulo de agenda es obligatorio.");
    }

    private static DateTime RequireDate(DateTime? value, string message)
    {
        if (!value.HasValue)
        {
            throw new BusinessRuleException(message);
        }

        return value.Value.Date;
    }

    private static TimeSpan ParseTime(string value, string message)
    {
        if (!TimeSpan.TryParse(value, CultureInfo.InvariantCulture, out var result))
        {
            throw new BusinessRuleException(message);
        }

        return result;
    }

    private static string RequireTitle(string value, string message)
    {
        var normalized = value.Trim();
        if (string.IsNullOrWhiteSpace(normalized))
        {
            throw new BusinessRuleException(message);
        }

        return normalized;
    }

    private static AgendaDinamicaDto MapAgenda(MySqlDataReader reader) =>
        new()
        {
            IdAgenda = GetRequiredInt(reader, "IdAgenda"),
            Fecha = Convert.ToDateTime(reader["Fecha"], CultureInfo.InvariantCulture),
            Hora = TimeSpan.Parse(reader["Hora"].ToString() ?? "00:00", CultureInfo.InvariantCulture),
            IdAlumno = GetRequiredInt(reader, "IdAlumno"),
            NombreAlumno = GetString(reader, "NombreAlumno"),
            Cargo = GetString(reader, "Cargo"),
            Genero = GetString(reader, "Genero"),
            Titulo = GetString(reader, "Titulo")
        };

    private static string GetString(MySqlDataReader reader, string columnName) =>
        reader[columnName] == DBNull.Value ? string.Empty : reader[columnName]?.ToString() ?? string.Empty;

    private static int GetRequiredInt(MySqlDataReader reader, string columnName) =>
        Convert.ToInt32(reader[columnName], CultureInfo.InvariantCulture);

    private static int? GetNullableInt(MySqlDataReader reader, string columnName) =>
        reader[columnName] == DBNull.Value
            ? null
            : Convert.ToInt32(reader[columnName], CultureInfo.InvariantCulture);

    private static decimal GetDecimal(MySqlDataReader reader, string columnName) =>
        reader[columnName] == DBNull.Value
            ? 0m
            : Convert.ToDecimal(reader[columnName], CultureInfo.InvariantCulture);

    private static DateTime? GetNullableDateTime(MySqlDataReader reader, string columnName) =>
        reader[columnName] == DBNull.Value
            ? null
            : Convert.ToDateTime(reader[columnName], CultureInfo.InvariantCulture);
}
