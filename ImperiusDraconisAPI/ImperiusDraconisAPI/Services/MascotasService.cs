using System.Globalization;
using System.Text;
using ImperiusDraconisAPI.Common;
using ImperiusDraconisAPI.Data;
using ImperiusDraconisAPI.Models.Mascotas;
using Microsoft.Data.SqlClient;

namespace ImperiusDraconisAPI.Services;

public sealed class MascotasService
{
    private static readonly string[] AllowedStates =
    [
        "Suscrita",
        "Congelada",
        "Subsidiada",
        "No activa",
        "En libertad"
    ];

    private readonly SqlConnectionFactory _connectionFactory;

    public MascotasService(SqlConnectionFactory connectionFactory)
    {
        _connectionFactory = connectionFactory;
    }

    public async Task<MascotaSummaryDto> GetSummaryAsync(CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        var totalMascotasCatalogo = 0;
        using (var countMascotasCommand = new SqlCommand("SELECT COUNT(*) FROM Mascotas", connection))
        {
            totalMascotasCatalogo = Convert.ToInt32(
                await countMascotasCommand.ExecuteScalarAsync(cancellationToken),
                CultureInfo.InvariantCulture);
        }

        var totalsByState = new Dictionary<string, int>(StringComparer.OrdinalIgnoreCase);
        using (var command = new SqlCommand(
                   """
                   SELECT Estado, COUNT(*) AS Total
                   FROM MascotasPorAlumno
                   GROUP BY Estado
                   """,
                   connection))
        using (var reader = await command.ExecuteReaderAsync(cancellationToken))
        {
            while (await reader.ReadAsync(cancellationToken))
            {
                totalsByState[GetString(reader, "Estado")] = GetRequiredInt(reader, "Total");
            }
        }

        var totalPendientesCobro = 0;
        using (var dueCommand = new SqlCommand(
                   """
                   SELECT COUNT(*)
                   FROM MascotasPorAlumno
                   WHERE Estado IN ('Suscrita', 'No activa')
                     AND (FechaUltimoPago IS NULL OR CONVERT(date, FechaUltimoPago) < @InicioSemana)
                   """,
                   connection))
        {
            dueCommand.Parameters.AddWithValue("@InicioSemana", GetStartOfWeek(DateTime.Today));
            totalPendientesCobro = Convert.ToInt32(
                await dueCommand.ExecuteScalarAsync(cancellationToken),
                CultureInfo.InvariantCulture);
        }

        return new MascotaSummaryDto
        {
            TotalMascotasCatalogo = totalMascotasCatalogo,
            TotalAsignaciones = totalsByState.Values.Sum(),
            TotalSuscritas = GetTotalForState(totalsByState, "Suscrita"),
            TotalCongeladas = GetTotalForState(totalsByState, "Congelada"),
            TotalSubsidiadas = GetTotalForState(totalsByState, "Subsidiada"),
            TotalNoActivas = GetTotalForState(totalsByState, "No activa"),
            TotalEnLibertad = GetTotalForState(totalsByState, "En libertad"),
            TotalPendientesCobro = totalPendientesCobro
        };
    }

    public async Task<IReadOnlyCollection<MascotaCatalogItemDto>> GetCatalogAsync(
        bool? activo,
        CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);
        return await GetCatalogInternalAsync(connection, transaction: null, activo, cancellationToken);
    }

    public async Task<MascotaFormCatalogsDto> GetFormCatalogsAsync(CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        return new MascotaFormCatalogsDto
        {
            Alumnos = await GetActiveAlumnoOptionsAsync(connection, transaction: null, cancellationToken),
            Mascotas = await GetCatalogInternalAsync(connection, transaction: null, activo: true, cancellationToken),
            Estados = AllowedStates
        };
    }

    public async Task<IReadOnlyCollection<MascotaAssignmentDto>> GetAssignmentsAsync(
        string? filtroEstado,
        string? busqueda,
        bool? soloPendientesCobro,
        CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);
        return await GetAssignmentsInternalAsync(
            connection,
            transaction: null,
            filtroEstado,
            busqueda,
            soloPendientesCobro,
            cancellationToken);
    }

    public async Task<MascotaAssignmentDto?> GetAssignmentByIdAsync(int idMascotaAlumno, CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);
        return await GetAssignmentByIdInternalAsync(connection, transaction: null, idMascotaAlumno, cancellationToken);
    }

    public async Task<MascotaAssignmentDto> CreateAssignmentAsync(
        SaveMascotaAssignmentRequest request,
        CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        var normalized = await NormalizeAndValidateAssignmentAsync(
            connection,
            transaction: null,
            request,
            cancellationToken);

        using var command = new SqlCommand(
            """
            INSERT INTO MascotasPorAlumno
            (
                IdAlumno,
                IdMascota,
                Estado,
                FechaCompra,
                FechaUltimoPago,
                SubsidiadaPor,
                Observaciones
            )
            VALUES
            (
                @IdAlumno,
                @IdMascota,
                @Estado,
                @FechaCompra,
                @FechaUltimoPago,
                @SubsidiadaPor,
                @Observaciones
            );
            SELECT CAST(SCOPE_IDENTITY() AS int);
            """,
            connection);

        command.Parameters.AddWithValue("@IdAlumno", normalized.IdAlumno);
        command.Parameters.AddWithValue("@IdMascota", normalized.IdMascota);
        command.Parameters.AddWithValue("@Estado", normalized.Estado);
        command.Parameters.AddWithValue("@FechaCompra", normalized.FechaCompra);
        command.Parameters.AddWithValue("@FechaUltimoPago", (object?)normalized.FechaUltimoPago ?? DBNull.Value);
        command.Parameters.AddWithValue("@SubsidiadaPor", (object?)normalized.SubsidiadaPor ?? DBNull.Value);
        command.Parameters.AddWithValue("@Observaciones", (object?)normalized.Observaciones ?? DBNull.Value);

        var idMascotaAlumno = Convert.ToInt32(
            await command.ExecuteScalarAsync(cancellationToken),
            CultureInfo.InvariantCulture);

        var created = await GetAssignmentByIdInternalAsync(connection, transaction: null, idMascotaAlumno, cancellationToken);
        return created ?? throw new InvalidOperationException("No se pudo recuperar la asignacion creada.");
    }

    public async Task<bool> UpdateAssignmentAsync(
        int idMascotaAlumno,
        SaveMascotaAssignmentRequest request,
        CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        if (!await AssignmentExistsAsync(connection, transaction: null, idMascotaAlumno, cancellationToken))
        {
            return false;
        }

        var normalized = await NormalizeAndValidateAssignmentAsync(
            connection,
            transaction: null,
            request,
            cancellationToken);

        using var command = new SqlCommand(
            """
            UPDATE MascotasPorAlumno
            SET IdAlumno = @IdAlumno,
                IdMascota = @IdMascota,
                Estado = @Estado,
                FechaCompra = @FechaCompra,
                FechaUltimoPago = @FechaUltimoPago,
                SubsidiadaPor = @SubsidiadaPor,
                Observaciones = @Observaciones
            WHERE IdMascotaAlumno = @IdMascotaAlumno
            """,
            connection);

        command.Parameters.AddWithValue("@IdMascotaAlumno", idMascotaAlumno);
        command.Parameters.AddWithValue("@IdAlumno", normalized.IdAlumno);
        command.Parameters.AddWithValue("@IdMascota", normalized.IdMascota);
        command.Parameters.AddWithValue("@Estado", normalized.Estado);
        command.Parameters.AddWithValue("@FechaCompra", normalized.FechaCompra);
        command.Parameters.AddWithValue("@FechaUltimoPago", (object?)normalized.FechaUltimoPago ?? DBNull.Value);
        command.Parameters.AddWithValue("@SubsidiadaPor", (object?)normalized.SubsidiadaPor ?? DBNull.Value);
        command.Parameters.AddWithValue("@Observaciones", (object?)normalized.Observaciones ?? DBNull.Value);

        return await command.ExecuteNonQueryAsync(cancellationToken) > 0;
    }

    public async Task<MascotaAssignmentDto?> ChangeStateAsync(
        int idMascotaAlumno,
        ChangeMascotaStateRequest request,
        CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        if (!await AssignmentExistsAsync(connection, transaction: null, idMascotaAlumno, cancellationToken))
        {
            return null;
        }

        var estado = NormalizeState(request.NuevoEstado);
        var subsidiadaPor = NormalizeOptional(request.SubsidiadaPor, maxLength: 100);
        var observaciones = NormalizeOptional(request.Observaciones, maxLength: 255);

        using (var command = new SqlCommand(
                   """
                   UPDATE MascotasPorAlumno
                   SET Estado = @Estado,
                       SubsidiadaPor = @SubsidiadaPor,
                       Observaciones = @Observaciones
                   WHERE IdMascotaAlumno = @IdMascotaAlumno
                   """,
                   connection))
        {
            command.Parameters.AddWithValue("@IdMascotaAlumno", idMascotaAlumno);
            command.Parameters.AddWithValue("@Estado", estado);
            command.Parameters.AddWithValue("@SubsidiadaPor", (object?)subsidiadaPor ?? DBNull.Value);
            command.Parameters.AddWithValue("@Observaciones", (object?)observaciones ?? DBNull.Value);
            await command.ExecuteNonQueryAsync(cancellationToken);
        }

        return await GetAssignmentByIdInternalAsync(connection, transaction: null, idMascotaAlumno, cancellationToken);
    }

    public async Task<bool> DeleteAssignmentAsync(int idMascotaAlumno, CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        using var command = new SqlCommand(
            "DELETE FROM MascotasPorAlumno WHERE IdMascotaAlumno = @IdMascotaAlumno",
            connection);
        command.Parameters.AddWithValue("@IdMascotaAlumno", idMascotaAlumno);
        return await command.ExecuteNonQueryAsync(cancellationToken) > 0;
    }

    public async Task<IReadOnlyCollection<MascotaWeeklyChargeCandidateDto>> GetWeeklyChargeCandidatesAsync(
        CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);
        return await GetWeeklyChargeCandidatesInternalAsync(connection, transaction: null, cancellationToken);
    }

    public async Task<MascotaWeeklyChargeResultDto> ProcessWeeklyChargesAsync(
        ProcessMascotaWeeklyChargeRequest request,
        CancellationToken cancellationToken)
    {
        var idsSeleccionados = request.IdsSeleccionados
            .Where(id => id > 0)
            .Distinct()
            .ToArray();

        if (idsSeleccionados.Length == 0)
        {
            throw new BusinessRuleException("Debes seleccionar al menos una mascota para procesar el cobro.");
        }

        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);
        await using var transaction = await connection.BeginTransactionAsync(cancellationToken);

        var procesadas = 0;
        var rechazadas = 0;
        var alumnosRechazados = new List<string>();
        var fechaHoy = DateTime.Today;
        var fechaMovimiento = DateTime.Now;

        try
        {
            foreach (var idMascotaAlumno in idsSeleccionados)
            {
                var candidate = await GetWeeklyChargeCandidateByIdInternalAsync(
                    connection,
                    (SqlTransaction)transaction,
                    idMascotaAlumno,
                    cancellationToken);

                if (candidate is null)
                {
                    continue;
                }

                if (candidate.PrecioMantenimiento != decimal.Truncate(candidate.PrecioMantenimiento))
                {
                    throw new BusinessRuleException(
                        $"La mascota #{candidate.IdMascotaAlumno} tiene un mantenimiento no compatible con el historial de Dracoins.");
                }

                if (candidate.DracoinsDisponibles >= candidate.PrecioMantenimiento)
                {
                    using (var updateAlumnoCommand = new SqlCommand(
                               "UPDATE Alumnos SET Dracoins = Dracoins - @Monto WHERE IdAlumno = @IdAlumno",
                               connection,
                               (SqlTransaction)transaction))
                    {
                        updateAlumnoCommand.Parameters.AddWithValue("@Monto", candidate.PrecioMantenimiento);
                        updateAlumnoCommand.Parameters.AddWithValue("@IdAlumno", candidate.IdAlumno);
                        await updateAlumnoCommand.ExecuteNonQueryAsync(cancellationToken);
                    }

                    using (var updateMascotaCommand = new SqlCommand(
                               """
                               UPDATE MascotasPorAlumno
                               SET FechaUltimoPago = @FechaUltimoPago,
                                   Estado = 'Suscrita'
                               WHERE IdMascotaAlumno = @IdMascotaAlumno
                               """,
                               connection,
                               (SqlTransaction)transaction))
                    {
                        updateMascotaCommand.Parameters.AddWithValue("@FechaUltimoPago", fechaHoy);
                        updateMascotaCommand.Parameters.AddWithValue("@IdMascotaAlumno", candidate.IdMascotaAlumno);
                        await updateMascotaCommand.ExecuteNonQueryAsync(cancellationToken);
                    }

                    using (var insertMovementCommand = new SqlCommand(
                               """
                               INSERT INTO MovimientosDracoins
                               (CodigoRemitente, CodigoDestinatario, Monto, FechaTransferencia, Observacion)
                               VALUES (@CodigoRemitente, 'COBRO', @Monto, @FechaTransferencia, @Observacion)
                               """,
                               connection,
                               (SqlTransaction)transaction))
                    {
                        insertMovementCommand.Parameters.AddWithValue("@CodigoRemitente", candidate.CodigoAlumno);
                        insertMovementCommand.Parameters.AddWithValue("@Monto", -decimal.ToInt32(candidate.PrecioMantenimiento));
                        insertMovementCommand.Parameters.AddWithValue("@FechaTransferencia", fechaMovimiento);
                        insertMovementCommand.Parameters.AddWithValue(
                            "@Observacion",
                            $"Cobro semanal de mascota: {candidate.NombreMascota}");
                        await insertMovementCommand.ExecuteNonQueryAsync(cancellationToken);
                    }

                    procesadas++;
                    continue;
                }

                using (var updateMascotaCommand = new SqlCommand(
                           "UPDATE MascotasPorAlumno SET Estado = 'No activa' WHERE IdMascotaAlumno = @IdMascotaAlumno",
                           connection,
                           (SqlTransaction)transaction))
                {
                    updateMascotaCommand.Parameters.AddWithValue("@IdMascotaAlumno", candidate.IdMascotaAlumno);
                    await updateMascotaCommand.ExecuteNonQueryAsync(cancellationToken);
                }

                rechazadas++;
                alumnosRechazados.Add($"{candidate.CodigoAlumno} - {candidate.NombreAlumno}");
            }

            await transaction.CommitAsync(cancellationToken);

            return new MascotaWeeklyChargeResultDto
            {
                TotalProcesadas = procesadas,
                TotalRechazadas = rechazadas,
                AlumnosRechazados = alumnosRechazados
            };
        }
        catch
        {
            await transaction.RollbackAsync(cancellationToken);
            throw;
        }
    }

    public async Task<IReadOnlyCollection<MascotaMatrixRowDto>> GetMatrixAsync(CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        var items = new List<MascotaMatrixRowDto>();
        using var command = new SqlCommand(
            """
            SELECT
                A.IdAlumno,
                A.Codigo AS CodigoAlumno,
                A.Nombre AS NombreAlumno,
                MAX(CASE WHEN M.Nombre = 'Lechuza' THEN MPA.IdMascotaAlumno END) AS IdMascotaLechuza,
                MAX(CASE WHEN M.Nombre = 'Lechuza' THEN MPA.Estado END) AS EstadoLechuza,
                MAX(CASE WHEN M.Nombre = 'Gato' THEN MPA.IdMascotaAlumno END) AS IdMascotaGato,
                MAX(CASE WHEN M.Nombre = 'Gato' THEN MPA.Estado END) AS EstadoGato,
                MAX(CASE WHEN M.Nombre = 'Sapo' THEN MPA.IdMascotaAlumno END) AS IdMascotaSapo,
                MAX(CASE WHEN M.Nombre = 'Sapo' THEN MPA.Estado END) AS EstadoSapo,
                MAX(CASE WHEN M.Nombre = 'Giratiempo' THEN MPA.IdMascotaAlumno END) AS IdMascotaGiratiempo,
                MAX(CASE WHEN M.Nombre = 'Giratiempo' THEN MPA.Estado END) AS EstadoGiratiempo
            FROM Alumnos A
            LEFT JOIN MascotasPorAlumno MPA ON MPA.IdAlumno = A.IdAlumno
            LEFT JOIN Mascotas M ON M.IdMascota = MPA.IdMascota
            GROUP BY A.IdAlumno, A.Codigo, A.Nombre
            HAVING COUNT(MPA.IdMascotaAlumno) > 0
            ORDER BY A.Nombre
            """,
            connection);

        using var reader = await command.ExecuteReaderAsync(cancellationToken);
        while (await reader.ReadAsync(cancellationToken))
        {
            items.Add(new MascotaMatrixRowDto
            {
                IdAlumno = GetRequiredInt(reader, "IdAlumno"),
                CodigoAlumno = GetString(reader, "CodigoAlumno"),
                NombreAlumno = GetString(reader, "NombreAlumno"),
                IdMascotaLechuza = GetNullableInt(reader, "IdMascotaLechuza"),
                EstadoLechuza = GetString(reader, "EstadoLechuza"),
                IdMascotaGato = GetNullableInt(reader, "IdMascotaGato"),
                EstadoGato = GetString(reader, "EstadoGato"),
                IdMascotaSapo = GetNullableInt(reader, "IdMascotaSapo"),
                EstadoSapo = GetString(reader, "EstadoSapo"),
                IdMascotaGiratiempo = GetNullableInt(reader, "IdMascotaGiratiempo"),
                EstadoGiratiempo = GetString(reader, "EstadoGiratiempo")
            });
        }

        return items;
    }

    private static int GetTotalForState(IReadOnlyDictionary<string, int> totalsByState, string state) =>
        totalsByState.TryGetValue(state, out var total) ? total : 0;

    private static DateTime GetStartOfWeek(DateTime date)
    {
        var difference = (7 + (date.DayOfWeek - DayOfWeek.Monday)) % 7;
        return date.Date.AddDays(-difference);
    }

    private static bool IsDueForWeeklyCharge(DateTime? fechaUltimoPago) =>
        !fechaUltimoPago.HasValue || fechaUltimoPago.Value.Date < GetStartOfWeek(DateTime.Today);

    private static string? NormalizeOptional(string? value, int maxLength)
    {
        var normalized = value?.Trim();
        if (string.IsNullOrWhiteSpace(normalized))
        {
            return null;
        }

        return normalized.Length <= maxLength ? normalized : normalized[..maxLength];
    }

    private static string NormalizeState(string? estado)
    {
        var normalized = estado?.Trim() ?? string.Empty;
        var match = AllowedStates.FirstOrDefault(current =>
            string.Equals(current, normalized, StringComparison.OrdinalIgnoreCase));

        return match ?? throw new BusinessRuleException("El estado seleccionado no es valido.");
    }

    private static string NormalizeFiltroEstado(string? filtroEstado)
    {
        var normalized = filtroEstado?.Trim().ToLowerInvariant();
        return normalized switch
        {
            "vigente" => "suscrita",
            "suscrita" => "suscrita",
            "no activa" => "no activa",
            "congelada" => "congelada",
            "subsidiada" => "subsidiada",
            "todas" => "todas",
            _ => "todas"
        };
    }

    private async Task<NormalizedMascotaAssignment> NormalizeAndValidateAssignmentAsync(
        SqlConnection connection,
        SqlTransaction? transaction,
        SaveMascotaAssignmentRequest request,
        CancellationToken cancellationToken)
    {
        if (request.IdAlumno <= 0)
        {
            throw new BusinessRuleException("Debes seleccionar un alumno valido.");
        }

        if (request.IdMascota <= 0)
        {
            throw new BusinessRuleException("Debes seleccionar una mascota valida.");
        }

        if (request.FechaCompra == default)
        {
            throw new BusinessRuleException("La fecha de compra es obligatoria.");
        }

        if (!await ActiveAlumnoExistsAsync(connection, transaction, request.IdAlumno, cancellationToken))
        {
            throw new BusinessRuleException("El alumno seleccionado no existe o esta inactivo.");
        }

        if (!await ActiveMascotaExistsAsync(connection, transaction, request.IdMascota, cancellationToken))
        {
            throw new BusinessRuleException("La mascota seleccionada no existe o esta inactiva.");
        }

        return new NormalizedMascotaAssignment
        {
            IdAlumno = request.IdAlumno,
            IdMascota = request.IdMascota,
            Estado = NormalizeState(request.Estado),
            FechaCompra = request.FechaCompra.Date,
            FechaUltimoPago = request.FechaUltimoPago?.Date,
            SubsidiadaPor = NormalizeOptional(request.SubsidiadaPor, maxLength: 100),
            Observaciones = NormalizeOptional(request.Observaciones, maxLength: 255)
        };
    }

    private async Task<IReadOnlyCollection<MascotaCatalogItemDto>> GetCatalogInternalAsync(
        SqlConnection connection,
        SqlTransaction? transaction,
        bool? activo,
        CancellationToken cancellationToken)
    {
        var query = new StringBuilder(
            """
            SELECT
                IdMascota,
                Nombre,
                PrecioCompra,
                PrecioMantenimiento,
                Activo
            FROM Mascotas
            WHERE 1 = 1
            """);

        using var command = new SqlCommand { Connection = connection, Transaction = transaction };
        if (activo.HasValue)
        {
            query.Append(" AND Activo = @Activo");
            command.Parameters.AddWithValue("@Activo", activo.Value);
        }

        query.Append(" ORDER BY Nombre");
        command.CommandText = query.ToString();

        var items = new List<MascotaCatalogItemDto>();
        using var reader = await command.ExecuteReaderAsync(cancellationToken);
        while (await reader.ReadAsync(cancellationToken))
        {
            items.Add(new MascotaCatalogItemDto
            {
                IdMascota = GetRequiredInt(reader, "IdMascota"),
                Nombre = GetString(reader, "Nombre"),
                PrecioCompra = GetRequiredDecimal(reader, "PrecioCompra"),
                PrecioMantenimiento = GetRequiredDecimal(reader, "PrecioMantenimiento"),
                Activo = GetRequiredBoolean(reader, "Activo")
            });
        }

        return items;
    }

    private async Task<IReadOnlyCollection<MascotaAlumnoOptionDto>> GetActiveAlumnoOptionsAsync(
        SqlConnection connection,
        SqlTransaction? transaction,
        CancellationToken cancellationToken)
    {
        var items = new List<MascotaAlumnoOptionDto>();
        using var command = new SqlCommand(
            """
            SELECT IdAlumno, Codigo, Nombre
            FROM Alumnos
            WHERE Activo = 1
            ORDER BY Codigo
            """,
            connection,
            transaction);

        using var reader = await command.ExecuteReaderAsync(cancellationToken);
        while (await reader.ReadAsync(cancellationToken))
        {
            items.Add(new MascotaAlumnoOptionDto
            {
                IdAlumno = GetRequiredInt(reader, "IdAlumno"),
                Codigo = GetString(reader, "Codigo"),
                Nombre = GetString(reader, "Nombre")
            });
        }

        return items;
    }

    private async Task<IReadOnlyCollection<MascotaAssignmentDto>> GetAssignmentsInternalAsync(
        SqlConnection connection,
        SqlTransaction? transaction,
        string? filtroEstado,
        string? busqueda,
        bool? soloPendientesCobro,
        CancellationToken cancellationToken)
    {
        var normalizedFilter = NormalizeFiltroEstado(filtroEstado);
        var query = new StringBuilder(
            """
            SELECT
                MPA.IdMascotaAlumno,
                MPA.IdAlumno,
                A.Codigo AS CodigoAlumno,
                A.Nombre AS NombreAlumno,
                MPA.IdMascota,
                M.Nombre AS NombreMascota,
                MPA.Estado,
                MPA.FechaCompra,
                MPA.FechaUltimoPago,
                M.PrecioCompra,
                M.PrecioMantenimiento,
                ISNULL(MPA.SubsidiadaPor, '') AS SubsidiadaPor,
                ISNULL(MPA.Observaciones, '') AS Observaciones
            FROM MascotasPorAlumno MPA
            INNER JOIN Alumnos A ON A.IdAlumno = MPA.IdAlumno
            INNER JOIN Mascotas M ON M.IdMascota = MPA.IdMascota
            WHERE 1 = 1
            """);

        using var command = new SqlCommand { Connection = connection, Transaction = transaction };

        if (normalizedFilter == "suscrita")
        {
            query.Append(" AND MPA.Estado = 'Suscrita'");
        }
        else if (normalizedFilter != "todas")
        {
            query.Append(" AND LOWER(MPA.Estado) = @EstadoFiltro");
            command.Parameters.AddWithValue("@EstadoFiltro", normalizedFilter);
        }

        if (!string.IsNullOrWhiteSpace(busqueda))
        {
            query.Append(
                """
                 AND (
                    A.Codigo LIKE @Busqueda
                    OR A.Nombre LIKE @Busqueda
                    OR M.Nombre LIKE @Busqueda
                    OR MPA.Estado LIKE @Busqueda
                 )
                """);
            command.Parameters.AddWithValue("@Busqueda", $"%{busqueda.Trim()}%");
        }

        if (soloPendientesCobro == true)
        {
            query.Append(
                """
                 AND MPA.Estado IN ('Suscrita', 'No activa')
                 AND (MPA.FechaUltimoPago IS NULL OR CONVERT(date, MPA.FechaUltimoPago) < @InicioSemana)
                """);
            command.Parameters.AddWithValue("@InicioSemana", GetStartOfWeek(DateTime.Today));
        }

        query.Append(" ORDER BY MPA.IdMascotaAlumno DESC");
        command.CommandText = query.ToString();

        var items = new List<MascotaAssignmentDto>();
        using var reader = await command.ExecuteReaderAsync(cancellationToken);
        while (await reader.ReadAsync(cancellationToken))
        {
            var fechaUltimoPago = GetNullableDateTime(reader, "FechaUltimoPago");
            var estado = GetString(reader, "Estado");

            items.Add(new MascotaAssignmentDto
            {
                IdMascotaAlumno = GetRequiredInt(reader, "IdMascotaAlumno"),
                IdAlumno = GetRequiredInt(reader, "IdAlumno"),
                CodigoAlumno = GetString(reader, "CodigoAlumno"),
                NombreAlumno = GetString(reader, "NombreAlumno"),
                IdMascota = GetRequiredInt(reader, "IdMascota"),
                NombreMascota = GetString(reader, "NombreMascota"),
                Estado = estado,
                FechaCompra = GetDateTime(reader, "FechaCompra"),
                FechaUltimoPago = fechaUltimoPago,
                PrecioCompra = GetRequiredDecimal(reader, "PrecioCompra"),
                PrecioMantenimiento = GetRequiredDecimal(reader, "PrecioMantenimiento"),
                DebePagar = string.Equals(estado, "Suscrita", StringComparison.OrdinalIgnoreCase)
                    && IsDueForWeeklyCharge(fechaUltimoPago),
                SubsidiadaPor = NormalizeOptional(GetString(reader, "SubsidiadaPor"), maxLength: 100),
                Observaciones = NormalizeOptional(GetString(reader, "Observaciones"), maxLength: 255)
            });
        }

        return items;
    }

    private async Task<MascotaAssignmentDto?> GetAssignmentByIdInternalAsync(
        SqlConnection connection,
        SqlTransaction? transaction,
        int idMascotaAlumno,
        CancellationToken cancellationToken)
    {
        using var command = new SqlCommand(
            """
            SELECT
                MPA.IdMascotaAlumno,
                MPA.IdAlumno,
                A.Codigo AS CodigoAlumno,
                A.Nombre AS NombreAlumno,
                MPA.IdMascota,
                M.Nombre AS NombreMascota,
                MPA.Estado,
                MPA.FechaCompra,
                MPA.FechaUltimoPago,
                M.PrecioCompra,
                M.PrecioMantenimiento,
                ISNULL(MPA.SubsidiadaPor, '') AS SubsidiadaPor,
                ISNULL(MPA.Observaciones, '') AS Observaciones
            FROM MascotasPorAlumno MPA
            INNER JOIN Alumnos A ON A.IdAlumno = MPA.IdAlumno
            INNER JOIN Mascotas M ON M.IdMascota = MPA.IdMascota
            WHERE MPA.IdMascotaAlumno = @IdMascotaAlumno
            """,
            connection,
            transaction);
        command.Parameters.AddWithValue("@IdMascotaAlumno", idMascotaAlumno);

        using var reader = await command.ExecuteReaderAsync(cancellationToken);
        if (!await reader.ReadAsync(cancellationToken))
        {
            return null;
        }

        var fechaUltimoPago = GetNullableDateTime(reader, "FechaUltimoPago");
        var estado = GetString(reader, "Estado");

        return new MascotaAssignmentDto
        {
            IdMascotaAlumno = GetRequiredInt(reader, "IdMascotaAlumno"),
            IdAlumno = GetRequiredInt(reader, "IdAlumno"),
            CodigoAlumno = GetString(reader, "CodigoAlumno"),
            NombreAlumno = GetString(reader, "NombreAlumno"),
            IdMascota = GetRequiredInt(reader, "IdMascota"),
            NombreMascota = GetString(reader, "NombreMascota"),
            Estado = estado,
            FechaCompra = GetDateTime(reader, "FechaCompra"),
            FechaUltimoPago = fechaUltimoPago,
            PrecioCompra = GetRequiredDecimal(reader, "PrecioCompra"),
            PrecioMantenimiento = GetRequiredDecimal(reader, "PrecioMantenimiento"),
            DebePagar = string.Equals(estado, "Suscrita", StringComparison.OrdinalIgnoreCase)
                && IsDueForWeeklyCharge(fechaUltimoPago),
            SubsidiadaPor = NormalizeOptional(GetString(reader, "SubsidiadaPor"), maxLength: 100),
            Observaciones = NormalizeOptional(GetString(reader, "Observaciones"), maxLength: 255)
        };
    }

    private async Task<IReadOnlyCollection<MascotaWeeklyChargeCandidateDto>> GetWeeklyChargeCandidatesInternalAsync(
        SqlConnection connection,
        SqlTransaction? transaction,
        CancellationToken cancellationToken)
    {
        var items = new List<MascotaWeeklyChargeCandidateDto>();
        using var command = new SqlCommand(
            """
            SELECT
                MPA.IdMascotaAlumno,
                MPA.IdAlumno,
                A.Codigo AS CodigoAlumno,
                A.Nombre AS NombreAlumno,
                A.Dracoins AS DracoinsDisponibles,
                M.Nombre AS NombreMascota,
                MPA.Estado,
                M.PrecioMantenimiento,
                MPA.FechaUltimoPago
            FROM MascotasPorAlumno MPA
            INNER JOIN Alumnos A ON A.IdAlumno = MPA.IdAlumno
            INNER JOIN Mascotas M ON M.IdMascota = MPA.IdMascota
            WHERE MPA.Estado IN ('Suscrita', 'No activa')
              AND (MPA.FechaUltimoPago IS NULL OR CONVERT(date, MPA.FechaUltimoPago) < @InicioSemana)
            ORDER BY A.Nombre, M.Nombre, MPA.IdMascotaAlumno
            """,
            connection,
            transaction);
        command.Parameters.AddWithValue("@InicioSemana", GetStartOfWeek(DateTime.Today));

        using var reader = await command.ExecuteReaderAsync(cancellationToken);
        while (await reader.ReadAsync(cancellationToken))
        {
            items.Add(new MascotaWeeklyChargeCandidateDto
            {
                IdMascotaAlumno = GetRequiredInt(reader, "IdMascotaAlumno"),
                IdAlumno = GetRequiredInt(reader, "IdAlumno"),
                CodigoAlumno = GetString(reader, "CodigoAlumno"),
                NombreAlumno = GetString(reader, "NombreAlumno"),
                NombreMascota = GetString(reader, "NombreMascota"),
                Estado = GetString(reader, "Estado"),
                PrecioMantenimiento = GetRequiredDecimal(reader, "PrecioMantenimiento"),
                FechaUltimoPago = GetNullableDateTime(reader, "FechaUltimoPago"),
                DracoinsDisponibles = GetRequiredDecimal(reader, "DracoinsDisponibles"),
                DebePagar = true
            });
        }

        return items;
    }

    private async Task<MascotaWeeklyChargeCandidateDto?> GetWeeklyChargeCandidateByIdInternalAsync(
        SqlConnection connection,
        SqlTransaction transaction,
        int idMascotaAlumno,
        CancellationToken cancellationToken)
    {
        using var command = new SqlCommand(
            """
            SELECT
                MPA.IdMascotaAlumno,
                MPA.IdAlumno,
                A.Codigo AS CodigoAlumno,
                A.Nombre AS NombreAlumno,
                A.Dracoins AS DracoinsDisponibles,
                M.Nombre AS NombreMascota,
                MPA.Estado,
                M.PrecioMantenimiento,
                MPA.FechaUltimoPago
            FROM MascotasPorAlumno MPA
            INNER JOIN Alumnos A ON A.IdAlumno = MPA.IdAlumno
            INNER JOIN Mascotas M ON M.IdMascota = MPA.IdMascota
            WHERE MPA.IdMascotaAlumno = @IdMascotaAlumno
              AND MPA.Estado IN ('Suscrita', 'No activa')
              AND (MPA.FechaUltimoPago IS NULL OR CONVERT(date, MPA.FechaUltimoPago) < @InicioSemana)
            """,
            connection,
            transaction);
        command.Parameters.AddWithValue("@IdMascotaAlumno", idMascotaAlumno);
        command.Parameters.AddWithValue("@InicioSemana", GetStartOfWeek(DateTime.Today));

        using var reader = await command.ExecuteReaderAsync(cancellationToken);
        if (!await reader.ReadAsync(cancellationToken))
        {
            return null;
        }

        return new MascotaWeeklyChargeCandidateDto
        {
            IdMascotaAlumno = GetRequiredInt(reader, "IdMascotaAlumno"),
            IdAlumno = GetRequiredInt(reader, "IdAlumno"),
            CodigoAlumno = GetString(reader, "CodigoAlumno"),
            NombreAlumno = GetString(reader, "NombreAlumno"),
            NombreMascota = GetString(reader, "NombreMascota"),
            Estado = GetString(reader, "Estado"),
            PrecioMantenimiento = GetRequiredDecimal(reader, "PrecioMantenimiento"),
            FechaUltimoPago = GetNullableDateTime(reader, "FechaUltimoPago"),
            DracoinsDisponibles = GetRequiredDecimal(reader, "DracoinsDisponibles"),
            DebePagar = true
        };
    }

    private static async Task<bool> ActiveAlumnoExistsAsync(
        SqlConnection connection,
        SqlTransaction? transaction,
        int idAlumno,
        CancellationToken cancellationToken)
    {
        using var command = new SqlCommand(
            "SELECT COUNT(*) FROM Alumnos WHERE IdAlumno = @IdAlumno AND Activo = 1",
            connection,
            transaction);
        command.Parameters.AddWithValue("@IdAlumno", idAlumno);

        return Convert.ToInt32(await command.ExecuteScalarAsync(cancellationToken), CultureInfo.InvariantCulture) > 0;
    }

    private static async Task<bool> ActiveMascotaExistsAsync(
        SqlConnection connection,
        SqlTransaction? transaction,
        int idMascota,
        CancellationToken cancellationToken)
    {
        using var command = new SqlCommand(
            "SELECT COUNT(*) FROM Mascotas WHERE IdMascota = @IdMascota AND Activo = 1",
            connection,
            transaction);
        command.Parameters.AddWithValue("@IdMascota", idMascota);

        return Convert.ToInt32(await command.ExecuteScalarAsync(cancellationToken), CultureInfo.InvariantCulture) > 0;
    }

    private static async Task<bool> AssignmentExistsAsync(
        SqlConnection connection,
        SqlTransaction? transaction,
        int idMascotaAlumno,
        CancellationToken cancellationToken)
    {
        using var command = new SqlCommand(
            "SELECT COUNT(*) FROM MascotasPorAlumno WHERE IdMascotaAlumno = @IdMascotaAlumno",
            connection,
            transaction);
        command.Parameters.AddWithValue("@IdMascotaAlumno", idMascotaAlumno);

        return Convert.ToInt32(await command.ExecuteScalarAsync(cancellationToken), CultureInfo.InvariantCulture) > 0;
    }

    private static string GetString(SqlDataReader reader, string columnName) =>
        reader[columnName] == DBNull.Value
            ? string.Empty
            : Convert.ToString(reader[columnName], CultureInfo.InvariantCulture) ?? string.Empty;

    private static int GetRequiredInt(SqlDataReader reader, string columnName) =>
        Convert.ToInt32(reader[columnName], CultureInfo.InvariantCulture);

    private static int? GetNullableInt(SqlDataReader reader, string columnName) =>
        reader[columnName] == DBNull.Value ? null : Convert.ToInt32(reader[columnName], CultureInfo.InvariantCulture);

    private static decimal GetRequiredDecimal(SqlDataReader reader, string columnName) =>
        Convert.ToDecimal(reader[columnName], CultureInfo.InvariantCulture);

    private static bool GetRequiredBoolean(SqlDataReader reader, string columnName) =>
        Convert.ToBoolean(reader[columnName], CultureInfo.InvariantCulture);

    private static DateTime GetDateTime(SqlDataReader reader, string columnName) =>
        Convert.ToDateTime(reader[columnName], CultureInfo.InvariantCulture);

    private static DateTime? GetNullableDateTime(SqlDataReader reader, string columnName) =>
        reader[columnName] == DBNull.Value
            ? null
            : Convert.ToDateTime(reader[columnName], CultureInfo.InvariantCulture);

    private sealed class NormalizedMascotaAssignment
    {
        public int IdAlumno { get; init; }

        public int IdMascota { get; init; }

        public string Estado { get; init; } = string.Empty;

        public DateTime FechaCompra { get; init; }

        public DateTime? FechaUltimoPago { get; init; }

        public string? SubsidiadaPor { get; init; }

        public string? Observaciones { get; init; }
    }
}
