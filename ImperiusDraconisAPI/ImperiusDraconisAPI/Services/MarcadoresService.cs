using System.Globalization;
using ImperiusDraconisAPI.Common;
using ImperiusDraconisAPI.Data;
using ImperiusDraconisAPI.Models.Marcadores;
using Microsoft.Data.SqlClient;

namespace ImperiusDraconisAPI.Services;

public sealed class MarcadoresService
{
    private readonly SqlConnectionFactory _connectionFactory;

    public MarcadoresService(SqlConnectionFactory connectionFactory)
    {
        _connectionFactory = connectionFactory;
    }

    public async Task<IReadOnlyList<MarcadorCasaDto>> GetCurrentAsync(CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);
        return await GetScoreboardAsync(connection, transaction: null, cancellationToken);
    }

    public async Task<PagedResult<HistorialMarcadorDto>> GetHistoryAsync(
        int page,
        int pageSize,
        CancellationToken cancellationToken)
    {
        var normalizedPage = page <= 0 ? 1 : page;
        var normalizedPageSize = pageSize <= 0 ? 20 : pageSize;

        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        var totalRegistros = 0;
        using (var countCommand = new SqlCommand("SELECT COUNT(*) FROM HistorialMarcadores", connection))
        {
            totalRegistros = Convert.ToInt32(await countCommand.ExecuteScalarAsync(cancellationToken));
        }

        var items = new List<HistorialMarcadorDto>();
        using (var command = new SqlCommand(
                   """
                   SELECT
                       H.IdHistorial,
                       H.IdCasa,
                       C.Nombre AS NombreCasa,
                       H.PuntosAcumulados,
                       H.FechaCierre
                   FROM HistorialMarcadores H
                   INNER JOIN Casas C ON C.IdCasa = H.IdCasa
                   ORDER BY H.FechaCierre DESC, H.IdCasa
                   OFFSET @Offset ROWS FETCH NEXT @Fetch ROWS ONLY
                   """,
                   connection))
        {
            command.Parameters.AddWithValue("@Offset", (normalizedPage - 1) * normalizedPageSize);
            command.Parameters.AddWithValue("@Fetch", normalizedPageSize);

            using var reader = await command.ExecuteReaderAsync(cancellationToken);
            while (await reader.ReadAsync(cancellationToken))
            {
                items.Add(new HistorialMarcadorDto
                {
                    IdHistorial = GetRequiredInt(reader, "IdHistorial"),
                    IdCasa = GetRequiredInt(reader, "IdCasa"),
                    NombreCasa = GetString(reader, "NombreCasa"),
                    PuntosAcumulados = GetRequiredInt(reader, "PuntosAcumulados"),
                    FechaCierre = GetDateTime(reader, "FechaCierre")
                });
            }
        }

        return new PagedResult<HistorialMarcadorDto>
        {
            Items = items,
            TotalRegistros = totalRegistros,
            PaginaActual = normalizedPage,
            RegistrosPorPagina = normalizedPageSize
        };
    }

    public async Task<MarcadorUpdateResultDto> CreateUpdateAsync(
        int idResponsable,
        MarcadorUpdateRequest request,
        CancellationToken cancellationToken)
    {
        if (idResponsable <= 0)
        {
            throw new BusinessRuleException("No se pudo identificar al responsable de la actualizacion.");
        }

        var nombreDinamica = request.NombreDinamica?.Trim() ?? string.Empty;
        var subtipo = request.SubtipoDinamica?.Trim() ?? string.Empty;
        var items = request.PuntosPorCasa
            .Where(item => item.Puntos > 0)
            .ToArray();

        if (string.IsNullOrWhiteSpace(nombreDinamica))
        {
            throw new BusinessRuleException("Debes indicar el nombre de la dinamica.");
        }

        if (string.IsNullOrWhiteSpace(subtipo))
        {
            throw new BusinessRuleException("Debes indicar el subtipo de la dinamica.");
        }

        if (items.Length == 0)
        {
            throw new BusinessRuleException("Debes registrar puntos mayores a cero para al menos una casa.");
        }

        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        var houseIds = (await GetScoreboardAsync(connection, transaction: null, cancellationToken))
            .Select(item => item.IdCasa)
            .ToHashSet();

        if (items.Any(item => !houseIds.Contains(item.IdCasa)))
        {
            throw new BusinessRuleException("Se recibio una casa invalida en la actualizacion.");
        }

        await using var transaction = await connection.BeginTransactionAsync(cancellationToken);

        try
        {
            var idDinamica = await InsertDinamicaAsync(
                connection,
                (SqlTransaction)transaction,
                idResponsable,
                nombreDinamica,
                subtipo,
                request.Observacion,
                cancellationToken);

            foreach (var item in items)
            {
                await InsertResultadoAsync(connection, (SqlTransaction)transaction, idDinamica, item.IdCasa, item.Puntos, cancellationToken);
                await UpdateMarcadorAsync(connection, (SqlTransaction)transaction, item.IdCasa, item.Puntos, cancellationToken);
            }

            await transaction.CommitAsync(cancellationToken);

            return new MarcadorUpdateResultDto
            {
                IdDinamica = idDinamica,
                NombreDinamica = nombreDinamica,
                SubtipoDinamica = subtipo,
                TotalPuntosOtorgados = items.Sum(item => item.Puntos),
                MarcadorActual = await GetScoreboardAsync(connection, transaction: null, cancellationToken)
            };
        }
        catch
        {
            await transaction.RollbackAsync(cancellationToken);
            throw;
        }
    }

    public async Task<MarcadorAdjustmentResultDto> CreateAdjustmentAsync(
        int idResponsable,
        MarcadorAdjustmentRequest request,
        CancellationToken cancellationToken)
    {
        if (idResponsable <= 0)
        {
            throw new BusinessRuleException("No se pudo identificar al responsable del ajuste.");
        }

        if (request.Puntos == 0)
        {
            throw new BusinessRuleException("Debes ingresar un ajuste distinto de cero.");
        }

        var observacion = request.Observacion?.Trim() ?? string.Empty;
        if (string.IsNullOrWhiteSpace(observacion))
        {
            throw new BusinessRuleException("La observacion del ajuste es obligatoria.");
        }

        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        var houseIds = (await GetScoreboardAsync(connection, transaction: null, cancellationToken))
            .Select(item => item.IdCasa)
            .ToHashSet();

        if (!houseIds.Contains(request.IdCasa))
        {
            throw new BusinessRuleException("La casa seleccionada no es valida.");
        }

        await using var transaction = await connection.BeginTransactionAsync(cancellationToken);

        try
        {
            var idDinamica = await InsertDinamicaAsync(
                connection,
                (SqlTransaction)transaction,
                idResponsable,
                "Ajuste de puntos",
                "Ajuste",
                observacion,
                cancellationToken);

            await InsertResultadoAsync(connection, (SqlTransaction)transaction, idDinamica, request.IdCasa, request.Puntos, cancellationToken);
            await UpdateMarcadorAsync(connection, (SqlTransaction)transaction, request.IdCasa, request.Puntos, cancellationToken);

            await transaction.CommitAsync(cancellationToken);

            return new MarcadorAdjustmentResultDto
            {
                IdDinamica = idDinamica,
                IdCasa = request.IdCasa,
                PuntosAjustados = request.Puntos,
                MarcadorActual = await GetScoreboardAsync(connection, transaction: null, cancellationToken)
            };
        }
        catch
        {
            await transaction.RollbackAsync(cancellationToken);
            throw;
        }
    }

    public async Task<MarcadorCloseResultDto> CloseScoreboardAsync(CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);
        await using var transaction = await connection.BeginTransactionAsync(cancellationToken);

        try
        {
            var fechaCierre = DateTime.Now;
            int registrosGenerados;

            using (var insertCommand = new SqlCommand(
                       """
                       INSERT INTO HistorialMarcadores (IdCasa, PuntosAcumulados, FechaCierre)
                       SELECT IdCasa, PuntosAcumulados, @FechaCierre
                       FROM MarcadorActual
                       """,
                       connection,
                       (SqlTransaction)transaction))
            {
                insertCommand.Parameters.AddWithValue("@FechaCierre", fechaCierre);
                registrosGenerados = await insertCommand.ExecuteNonQueryAsync(cancellationToken);
            }

            using (var resetCommand = new SqlCommand(
                       "UPDATE MarcadorActual SET PuntosAcumulados = 0",
                       connection,
                       (SqlTransaction)transaction))
            {
                await resetCommand.ExecuteNonQueryAsync(cancellationToken);
            }

            await transaction.CommitAsync(cancellationToken);

            return new MarcadorCloseResultDto
            {
                FechaCierre = fechaCierre,
                RegistrosGenerados = registrosGenerados,
                MarcadorActual = await GetScoreboardAsync(connection, transaction: null, cancellationToken)
            };
        }
        catch
        {
            await transaction.RollbackAsync(cancellationToken);
            throw;
        }
    }

    private static async Task<int> InsertDinamicaAsync(
        SqlConnection connection,
        SqlTransaction transaction,
        int idResponsable,
        string nombre,
        string subtipo,
        string? observacion,
        CancellationToken cancellationToken)
    {
        using var command = new SqlCommand(
            """
            INSERT INTO Dinamicas (Fecha, Nombre, Tipo, Subtipo, IdResponsable, Observacion)
            VALUES (@Fecha, @Nombre, 'Puntos', @Subtipo, @IdResponsable, @Observacion);
            SELECT CAST(SCOPE_IDENTITY() AS int);
            """,
            connection,
            transaction);

        command.Parameters.AddWithValue("@Fecha", DateTime.Now);
        command.Parameters.AddWithValue("@Nombre", nombre);
        command.Parameters.AddWithValue("@Subtipo", subtipo);
        command.Parameters.AddWithValue("@IdResponsable", idResponsable);
        command.Parameters.AddWithValue(
            "@Observacion",
            string.IsNullOrWhiteSpace(observacion) ? DBNull.Value : observacion.Trim());

        return Convert.ToInt32(await command.ExecuteScalarAsync(cancellationToken), CultureInfo.InvariantCulture);
    }

    private static async Task InsertResultadoAsync(
        SqlConnection connection,
        SqlTransaction transaction,
        int idDinamica,
        int idCasa,
        int puntos,
        CancellationToken cancellationToken)
    {
        using var command = new SqlCommand(
            """
            INSERT INTO ResultadosPorCasa (IdDinamica, IdCasa, PuntosOtorgados, DracoinsOtorgados)
            VALUES (@IdDinamica, @IdCasa, @PuntosOtorgados, 0)
            """,
            connection,
            transaction);

        command.Parameters.AddWithValue("@IdDinamica", idDinamica);
        command.Parameters.AddWithValue("@IdCasa", idCasa);
        command.Parameters.AddWithValue("@PuntosOtorgados", puntos);

        await command.ExecuteNonQueryAsync(cancellationToken);
    }

    private static async Task UpdateMarcadorAsync(
        SqlConnection connection,
        SqlTransaction transaction,
        int idCasa,
        int puntos,
        CancellationToken cancellationToken)
    {
        using var command = new SqlCommand(
            """
            UPDATE MarcadorActual
            SET PuntosAcumulados = PuntosAcumulados + @Puntos
            WHERE IdCasa = @IdCasa;

            IF @@ROWCOUNT = 0
            BEGIN
                INSERT INTO MarcadorActual (IdCasa, PuntosAcumulados)
                VALUES (@IdCasa, @Puntos);
            END
            """,
            connection,
            transaction);

        command.Parameters.AddWithValue("@IdCasa", idCasa);
        command.Parameters.AddWithValue("@Puntos", puntos);

        await command.ExecuteNonQueryAsync(cancellationToken);
    }

    private static async Task<IReadOnlyList<MarcadorCasaDto>> GetScoreboardAsync(
        SqlConnection connection,
        SqlTransaction? transaction,
        CancellationToken cancellationToken)
    {
        var items = new List<MarcadorCasaDto>();

        using var command = new SqlCommand(
            """
            SELECT
                C.IdCasa,
                C.Nombre AS NombreCasa,
                ISNULL(C.Color, '') AS Color,
                ISNULL(M.PuntosAcumulados, 0) AS PuntosAcumulados
            FROM Casas C
            LEFT JOIN MarcadorActual M ON M.IdCasa = C.IdCasa
            ORDER BY C.IdCasa
            """,
            connection,
            transaction);

        using var reader = await command.ExecuteReaderAsync(cancellationToken);
        while (await reader.ReadAsync(cancellationToken))
        {
            items.Add(new MarcadorCasaDto
            {
                IdCasa = GetRequiredInt(reader, "IdCasa"),
                NombreCasa = GetString(reader, "NombreCasa"),
                Color = GetString(reader, "Color"),
                PuntosAcumulados = GetRequiredInt(reader, "PuntosAcumulados")
            });
        }

        return items;
    }

    private static string GetString(SqlDataReader reader, string columnName) =>
        reader[columnName] == DBNull.Value ? string.Empty : reader[columnName]?.ToString() ?? string.Empty;

    private static int GetRequiredInt(SqlDataReader reader, string columnName) =>
        Convert.ToInt32(reader[columnName], CultureInfo.InvariantCulture);

    private static DateTime GetDateTime(SqlDataReader reader, string columnName) =>
        Convert.ToDateTime(reader[columnName], CultureInfo.InvariantCulture);
}
