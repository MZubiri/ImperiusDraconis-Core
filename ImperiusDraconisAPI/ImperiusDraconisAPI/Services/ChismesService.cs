using System.Globalization;
using ImperiusDraconisAPI.Common;
using ImperiusDraconisAPI.Data;
using ImperiusDraconisAPI.Models.Chismes;
using Microsoft.Data.SqlClient;

namespace ImperiusDraconisAPI.Services;

public sealed class ChismesService
{
    private const int RewardAmount = 50;
    private readonly SqlConnectionFactory _connectionFactory;
    private readonly LegacyAssetStorage _assetStorage;

    public ChismesService(SqlConnectionFactory connectionFactory, LegacyAssetStorage assetStorage)
    {
        _connectionFactory = connectionFactory;
        _assetStorage = assetStorage;
    }

    public bool CanReview(int idAlumno) => idAlumno is 1 or 3;

    public async Task<PagedResult<ChismeDto>> GetAsync(ChismeQuery query, CancellationToken cancellationToken)
    {
        var pagina = query.Pagina <= 0 ? 1 : query.Pagina;
        var registrosPorPagina = query.RegistrosPorPagina <= 0 ? 30 : query.RegistrosPorPagina;
        var fechaInicio = query.FechaInicio?.Date;
        var fechaFin = query.FechaFin?.Date.AddDays(1).AddTicks(-1);

        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        var totalRegistros = 0;
        using (var countCommand = new SqlCommand(
                   """
                   SELECT COUNT(*)
                   FROM Chismes C
                   WHERE (@FechaInicio IS NULL OR C.FechaEnvio >= @FechaInicio)
                     AND (@FechaFin IS NULL OR C.FechaEnvio <= @FechaFin)
                   """,
                   connection))
        {
            countCommand.Parameters.AddWithValue("@FechaInicio", (object?)fechaInicio ?? DBNull.Value);
            countCommand.Parameters.AddWithValue("@FechaFin", (object?)fechaFin ?? DBNull.Value);
            totalRegistros = Convert.ToInt32(
                await countCommand.ExecuteScalarAsync(cancellationToken),
                CultureInfo.InvariantCulture);
        }

        var rows = new List<ChismeDto>();
        using (var command = new SqlCommand(
                   """
                   SELECT
                       C.IdChisme,
                       C.IdAlumno,
                       A.Codigo,
                       A.Nombre AS AlumnoNombre,
                       C.Texto,
                       C.FechaEnvio
                   FROM Chismes C
                   INNER JOIN Alumnos A ON A.IdAlumno = C.IdAlumno
                   WHERE (@FechaInicio IS NULL OR C.FechaEnvio >= @FechaInicio)
                     AND (@FechaFin IS NULL OR C.FechaEnvio <= @FechaFin)
                   ORDER BY C.FechaEnvio DESC, C.IdChisme DESC
                   OFFSET @Offset ROWS FETCH NEXT @Fetch ROWS ONLY
                   """,
                   connection))
        {
            command.Parameters.AddWithValue("@FechaInicio", (object?)fechaInicio ?? DBNull.Value);
            command.Parameters.AddWithValue("@FechaFin", (object?)fechaFin ?? DBNull.Value);
            command.Parameters.AddWithValue("@Offset", (pagina - 1) * registrosPorPagina);
            command.Parameters.AddWithValue("@Fetch", registrosPorPagina);

            using var reader = await command.ExecuteReaderAsync(cancellationToken);
            while (await reader.ReadAsync(cancellationToken))
            {
                rows.Add(new ChismeDto
                {
                    IdChisme = GetRequiredInt(reader, "IdChisme"),
                    IdAlumno = GetRequiredInt(reader, "IdAlumno"),
                    CodigoAlumno = GetString(reader, "Codigo"),
                    AlumnoNombre = GetString(reader, "AlumnoNombre"),
                    Texto = GetString(reader, "Texto"),
                    FechaEnvio = GetDateTime(reader, "FechaEnvio")
                });
            }
        }

        var imagesByChisme = await GetImagesByChismeIdsAsync(
            connection,
            transaction: null,
            rows.Select(item => item.IdChisme),
            cancellationToken);

        return new PagedResult<ChismeDto>
        {
            Items = rows
                .Select(row => new ChismeDto
                {
                    IdChisme = row.IdChisme,
                    IdAlumno = row.IdAlumno,
                    CodigoAlumno = row.CodigoAlumno,
                    AlumnoNombre = row.AlumnoNombre,
                    Texto = row.Texto,
                    FechaEnvio = row.FechaEnvio,
                    Imagenes = imagesByChisme.GetValueOrDefault(row.IdChisme, Array.Empty<string>())
                })
                .ToArray(),
            TotalRegistros = totalRegistros,
            PaginaActual = pagina,
            RegistrosPorPagina = registrosPorPagina
        };
    }

    public async Task<ChismeCreateResultDto> CreateAsync(
        int idAlumno,
        CreateChismeRequest request,
        CancellationToken cancellationToken)
    {
        var texto = request.Texto?.Trim() ?? string.Empty;
        var imagenes = request.Imagenes
            .Where(file => file is { Length: > 0 })
            .ToArray();

        if (string.IsNullOrWhiteSpace(texto) && imagenes.Length == 0)
        {
            throw new BusinessRuleException("Debes escribir un chisme o adjuntar al menos una imagen.");
        }

        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        var alumno = await GetAlumnoAsync(connection, transaction: null, idAlumno, cancellationToken);
        if (alumno is null)
        {
            throw new BusinessRuleException("No se encontro al alumno actual.");
        }

        await using var transaction = await connection.BeginTransactionAsync(cancellationToken);

        try
        {
            int idChisme;
            using (var command = new SqlCommand(
                       """
                       INSERT INTO Chismes (IdAlumno, Texto)
                       OUTPUT INSERTED.IdChisme
                       VALUES (@IdAlumno, @Texto)
                       """,
                       connection,
                       (SqlTransaction)transaction))
            {
                command.Parameters.AddWithValue("@IdAlumno", idAlumno);
                command.Parameters.AddWithValue("@Texto", string.IsNullOrWhiteSpace(texto) ? DBNull.Value : texto);
                idChisme = Convert.ToInt32(
                    await command.ExecuteScalarAsync(cancellationToken),
                    CultureInfo.InvariantCulture);
            }

            var imagePaths = new List<string>();
            foreach (var image in imagenes)
            {
                var path = await _assetStorage.SaveImageAsync(
                    image,
                    Path.Combine("Content", "chismes"),
                    cancellationToken);

                using var insertImageCommand = new SqlCommand(
                    "INSERT INTO ChismeImagenes (IdChisme, RutaImagen) VALUES (@IdChisme, @RutaImagen)",
                    connection,
                    (SqlTransaction)transaction);
                insertImageCommand.Parameters.AddWithValue("@IdChisme", idChisme);
                insertImageCommand.Parameters.AddWithValue("@RutaImagen", path);
                await insertImageCommand.ExecuteNonQueryAsync(cancellationToken);

                imagePaths.Add(path);
            }

            using (var rewardCommand = new SqlCommand(
                       "UPDATE Alumnos SET Dracoins = Dracoins + @Monto WHERE IdAlumno = @IdAlumno",
                       connection,
                       (SqlTransaction)transaction))
            {
                rewardCommand.Parameters.AddWithValue("@Monto", RewardAmount);
                rewardCommand.Parameters.AddWithValue("@IdAlumno", idAlumno);
                await rewardCommand.ExecuteNonQueryAsync(cancellationToken);
            }

            using (var movementCommand = new SqlCommand(
                       """
                       INSERT INTO MovimientosDracoins
                       (CodigoRemitente, CodigoDestinatario, Monto, FechaTransferencia, Observacion)
                       VALUES ('CHISME', @CodigoDestinatario, @Monto, @FechaTransferencia, @Observacion)
                       """,
                       connection,
                       (SqlTransaction)transaction))
            {
                movementCommand.Parameters.AddWithValue("@CodigoDestinatario", alumno.Codigo);
                movementCommand.Parameters.AddWithValue("@Monto", RewardAmount);
                movementCommand.Parameters.AddWithValue("@FechaTransferencia", DateTime.Now);
                movementCommand.Parameters.AddWithValue("@Observacion", "Recompensa por envio de chisme");
                await movementCommand.ExecuteNonQueryAsync(cancellationToken);
            }

            await transaction.CommitAsync(cancellationToken);

            return new ChismeCreateResultDto
            {
                IdChisme = idChisme,
                FechaEnvio = DateTime.Now,
                DracoinsOtorgados = RewardAmount,
                Message = "Tu chisme fue enviado y recibiste 50 Dracoins.",
                Imagenes = imagePaths.ToArray()
            };
        }
        catch
        {
            await transaction.RollbackAsync(cancellationToken);
            throw;
        }
    }

    private static async Task<AlumnoLookup?> GetAlumnoAsync(
        SqlConnection connection,
        SqlTransaction? transaction,
        int idAlumno,
        CancellationToken cancellationToken)
    {
        using var command = new SqlCommand(
            "SELECT TOP 1 IdAlumno, Codigo FROM Alumnos WHERE IdAlumno = @IdAlumno AND Activo = 1",
            connection,
            transaction);
        command.Parameters.AddWithValue("@IdAlumno", idAlumno);

        using var reader = await command.ExecuteReaderAsync(cancellationToken);
        if (!await reader.ReadAsync(cancellationToken))
        {
            return null;
        }

        return new AlumnoLookup
        {
            IdAlumno = GetRequiredInt(reader, "IdAlumno"),
            Codigo = GetString(reader, "Codigo")
        };
    }

    private static async Task<Dictionary<int, string[]>> GetImagesByChismeIdsAsync(
        SqlConnection connection,
        SqlTransaction? transaction,
        IEnumerable<int> idsChisme,
        CancellationToken cancellationToken)
    {
        var ids = idsChisme
            .Where(id => id > 0)
            .Distinct()
            .ToArray();

        if (ids.Length == 0)
        {
            return new Dictionary<int, string[]>();
        }

        var parameterNames = ids
            .Select((_, index) => $"@IdChisme{index}")
            .ToArray();

        var sql =
            $"""
            SELECT IdChisme, RutaImagen
            FROM ChismeImagenes
            WHERE IdChisme IN ({string.Join(", ", parameterNames)})
            ORDER BY IdImagen
            """;

        using var command = new SqlCommand(sql, connection, transaction);
        for (var index = 0; index < ids.Length; index++)
        {
            command.Parameters.AddWithValue(parameterNames[index], ids[index]);
        }

        var result = new Dictionary<int, List<string>>();
        using var reader = await command.ExecuteReaderAsync(cancellationToken);
        while (await reader.ReadAsync(cancellationToken))
        {
            var idChisme = GetRequiredInt(reader, "IdChisme");
            if (!result.TryGetValue(idChisme, out var images))
            {
                images = new List<string>();
                result[idChisme] = images;
            }

            images.Add(GetString(reader, "RutaImagen"));
        }

        return result.ToDictionary(item => item.Key, item => item.Value.ToArray());
    }

    private static string GetString(SqlDataReader reader, string columnName) =>
        reader[columnName] == DBNull.Value ? string.Empty : reader[columnName]?.ToString() ?? string.Empty;

    private static int GetRequiredInt(SqlDataReader reader, string columnName) =>
        Convert.ToInt32(reader[columnName], CultureInfo.InvariantCulture);

    private static DateTime GetDateTime(SqlDataReader reader, string columnName) =>
        Convert.ToDateTime(reader[columnName], CultureInfo.InvariantCulture);

    private sealed class AlumnoLookup
    {
        public int IdAlumno { get; init; }

        public string Codigo { get; init; } = string.Empty;
    }
}
