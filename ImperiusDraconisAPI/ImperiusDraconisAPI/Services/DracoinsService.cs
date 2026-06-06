using System.Data;
using System.Globalization;
using System.Text;
using ImperiusDraconisAPI.Common;
using ImperiusDraconisAPI.Data;
using ImperiusDraconisAPI.Models.Dracoins;
using Microsoft.Data.SqlClient;

namespace ImperiusDraconisAPI.Services;

public sealed class DracoinsService
{
    private const string BancoCode = "BANCO";
    private readonly SqlConnectionFactory _connectionFactory;

    public DracoinsService(SqlConnectionFactory connectionFactory)
    {
        _connectionFactory = connectionFactory;
    }

    public async Task<DracoinSummaryDto?> GetSummaryAsync(int idAlumno, CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        var currentUser = await GetCurrentAlumnoAsync(connection, idAlumno, cancellationToken);
        if (currentUser is null)
        {
            return null;
        }

        var sentStats = await GetTransferStatsAsync(connection, currentUser.Codigo, sent: true, cancellationToken);
        var receivedStats = await GetTransferStatsAsync(connection, currentUser.Codigo, sent: false, cancellationToken);
        var recentTransfers = await GetTransferHistoryInternalAsync(
            connection,
            currentUser.Codigo,
            page: 1,
            pageSize: 5,
            cancellationToken);

        return new DracoinSummaryDto
        {
            IdAlumno = currentUser.IdAlumno,
            Codigo = currentUser.Codigo,
            Nombre = currentUser.Nombre,
            SaldoActual = currentUser.Dracoins,
            TotalTransferenciasEnviadas = sentStats.TotalTransferencias,
            TotalTransferenciasRecibidas = receivedStats.TotalTransferencias,
            MontoEnviadoTotal = sentStats.MontoTotal,
            MontoRecibidoTotal = receivedStats.MontoTotal,
            TransferenciasRecientes = recentTransfers.Items
        };
    }

    public async Task<DracoinTransferDto> CreateTransferAsync(
        int idAlumno,
        DracoinTransferRequest request,
        CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        var remitente = await GetCurrentAlumnoAsync(connection, idAlumno, cancellationToken);
        if (remitente is null)
        {
            throw new BusinessRuleException("El usuario remitente no existe o esta inactivo.");
        }

        var codigoDestinatario = request.CodigoDestinatario.Trim();
        if (string.Equals(remitente.Codigo, codigoDestinatario, StringComparison.OrdinalIgnoreCase))
        {
            throw new BusinessRuleException("No puedes transferirte Dracoins a ti mismo.");
        }

        if (request.Monto <= 0)
        {
            throw new BusinessRuleException("El monto debe ser mayor a cero.");
        }

        if (remitente.Dracoins < request.Monto)
        {
            throw new BusinessRuleException("Monto invalido o saldo insuficiente.");
        }

        var destinatario = await GetAlumnoByCodigoAsync(connection, codigoDestinatario, cancellationToken);
        if (destinatario is null)
        {
            throw new BusinessRuleException("El destinatario no existe o esta inactivo.");
        }

        await using var transaction = await connection.BeginTransactionAsync(cancellationToken);

        try
        {
            using (var debitCommand = new SqlCommand(
                       "UPDATE Alumnos SET Dracoins = Dracoins - @Monto WHERE IdAlumno = @IdAlumno",
                       connection,
                       (SqlTransaction)transaction))
            {
                debitCommand.Parameters.AddWithValue("@Monto", request.Monto);
                debitCommand.Parameters.AddWithValue("@IdAlumno", remitente.IdAlumno);
                await debitCommand.ExecuteNonQueryAsync(cancellationToken);
            }

            using (var creditCommand = new SqlCommand(
                       "UPDATE Alumnos SET Dracoins = Dracoins + @Monto WHERE Codigo = @Codigo",
                       connection,
                       (SqlTransaction)transaction))
            {
                creditCommand.Parameters.AddWithValue("@Monto", request.Monto);
                creditCommand.Parameters.AddWithValue("@Codigo", destinatario.Codigo);
                await creditCommand.ExecuteNonQueryAsync(cancellationToken);
            }

            var idMovimiento = await RegisterMovementAsync(
                connection,
                (SqlTransaction)transaction,
                remitente.Codigo,
                destinatario.Codigo,
                request.Monto,
                request.Observacion,
                cancellationToken);

            await transaction.CommitAsync(cancellationToken);

            var transfer = await GetTransferByIdAsync(idMovimiento, idAlumno, cancellationToken);
            return transfer ?? throw new InvalidOperationException("No se pudo recuperar la transferencia creada.");
        }
        catch
        {
            await transaction.RollbackAsync(cancellationToken);
            throw;
        }
    }

    public async Task<PagedResult<DracoinTransferDto>?> GetTransferHistoryAsync(
        int idAlumno,
        int page,
        int pageSize,
        CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        var currentUser = await GetCurrentAlumnoAsync(connection, idAlumno, cancellationToken);
        if (currentUser is null)
        {
            return null;
        }

        return await GetTransferHistoryInternalAsync(connection, currentUser.Codigo, page, pageSize, cancellationToken);
    }

    public async Task<DracoinTransferDto?> GetTransferByIdAsync(
        int idMovimiento,
        int idAlumno,
        CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        var currentUser = await GetCurrentAlumnoAsync(connection, idAlumno, cancellationToken);
        if (currentUser is null)
        {
            return null;
        }

        using var command = new SqlCommand(
            """
            SELECT
                M.IdMovimiento,
                M.CodigoRemitente,
                AR.Nombre AS NombreRemitente,
                M.CodigoDestinatario,
                AD.Nombre AS NombreDestinatario,
                M.Monto,
                M.FechaTransferencia,
                M.Observacion
            FROM MovimientosDracoins M
            LEFT JOIN Alumnos AR ON AR.Codigo = M.CodigoRemitente
            LEFT JOIN Alumnos AD ON AD.Codigo = M.CodigoDestinatario
            WHERE M.IdMovimiento = @IdMovimiento
              AND (M.CodigoRemitente = @Codigo OR M.CodigoDestinatario = @Codigo)
            """,
            connection);
        command.Parameters.AddWithValue("@IdMovimiento", idMovimiento);
        command.Parameters.AddWithValue("@Codigo", currentUser.Codigo);

        using var reader = await command.ExecuteReaderAsync(cancellationToken);
        if (!await reader.ReadAsync(cancellationToken))
        {
            return null;
        }

        return MapTransfer(reader, currentUser.Codigo);
    }

    public async Task<PagedResult<DracoinGeneralMovementDto>> GetGeneralHistoryAsync(
        string? remitente,
        string? destinatario,
        int? montoMin,
        int? montoMax,
        string? observacion,
        DateTime? desde,
        DateTime? hasta,
        int page,
        int pageSize,
        CancellationToken cancellationToken)
    {
        var normalizedPage = page <= 0 ? 1 : page;
        var normalizedPageSize = pageSize <= 0 ? 20 : pageSize;

        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        var queryBase = new StringBuilder(
            """
            FROM MovimientosDracoins M
            LEFT JOIN Alumnos AR ON AR.Codigo = M.CodigoRemitente
            LEFT JOIN Alumnos AD ON AD.Codigo = M.CodigoDestinatario
            WHERE 1 = 1
            """);

        using var countCommand = new SqlCommand { Connection = connection };

        if (!string.IsNullOrWhiteSpace(remitente))
        {
            queryBase.Append(" AND M.CodigoRemitente LIKE @Remitente");
            countCommand.Parameters.AddWithValue("@Remitente", $"%{remitente.Trim()}%");
        }

        if (!string.IsNullOrWhiteSpace(destinatario))
        {
            queryBase.Append(" AND M.CodigoDestinatario LIKE @Destinatario");
            countCommand.Parameters.AddWithValue("@Destinatario", $"%{destinatario.Trim()}%");
        }

        if (montoMin.HasValue)
        {
            queryBase.Append(" AND M.Monto >= @MontoMin");
            countCommand.Parameters.AddWithValue("@MontoMin", montoMin.Value);
        }

        if (montoMax.HasValue)
        {
            queryBase.Append(" AND M.Monto <= @MontoMax");
            countCommand.Parameters.AddWithValue("@MontoMax", montoMax.Value);
        }

        if (!string.IsNullOrWhiteSpace(observacion))
        {
            queryBase.Append(" AND ISNULL(M.Observacion, '') LIKE @Observacion");
            countCommand.Parameters.AddWithValue("@Observacion", $"%{observacion.Trim()}%");
        }

        if (desde.HasValue)
        {
            queryBase.Append(" AND M.FechaTransferencia >= @Desde");
            countCommand.Parameters.AddWithValue("@Desde", desde.Value.Date);
        }

        if (hasta.HasValue)
        {
            queryBase.Append(" AND M.FechaTransferencia <= @Hasta");
            countCommand.Parameters.AddWithValue("@Hasta", hasta.Value.Date.AddDays(1).AddTicks(-1));
        }

        countCommand.CommandText = $"SELECT COUNT(*) {queryBase}";
        var totalRegistros = Convert.ToInt32(await countCommand.ExecuteScalarAsync(cancellationToken));

        var items = new List<DracoinGeneralMovementDto>();
        using var command = new SqlCommand(
            $"""
            SELECT
                M.IdMovimiento,
                M.CodigoRemitente,
                ISNULL(AR.Nombre, '') AS NombreRemitente,
                M.CodigoDestinatario,
                ISNULL(AD.Nombre, '') AS NombreDestinatario,
                M.Monto,
                M.FechaTransferencia,
                ISNULL(M.Observacion, '') AS Observacion
            {queryBase}
            ORDER BY M.FechaTransferencia DESC
            OFFSET @Offset ROWS FETCH NEXT @Fetch ROWS ONLY
            """,
            connection);
        CopyParameters(countCommand, command);
        command.Parameters.AddWithValue("@Offset", (normalizedPage - 1) * normalizedPageSize);
        command.Parameters.AddWithValue("@Fetch", normalizedPageSize);

        using (var reader = await command.ExecuteReaderAsync(cancellationToken))
        {
            while (await reader.ReadAsync(cancellationToken))
            {
                items.Add(new DracoinGeneralMovementDto
                {
                    IdMovimiento = GetRequiredInt(reader, "IdMovimiento"),
                    CodigoRemitente = GetString(reader, "CodigoRemitente"),
                    NombreRemitente = GetString(reader, "NombreRemitente"),
                    CodigoDestinatario = GetString(reader, "CodigoDestinatario"),
                    NombreDestinatario = GetString(reader, "NombreDestinatario"),
                    Monto = GetRequiredInt(reader, "Monto"),
                    FechaTransferencia = GetDateTime(reader, "FechaTransferencia"),
                    Observacion = GetString(reader, "Observacion")
                });
            }
        }

        return new PagedResult<DracoinGeneralMovementDto>
        {
            Items = items,
            TotalRegistros = totalRegistros,
            PaginaActual = normalizedPage,
            RegistrosPorPagina = normalizedPageSize
        };
    }

    public async Task<PagedResult<DracoinAdministrativePaymentDto>> GetAdministrativePaymentsAsync(
        int page,
        int pageSize,
        CancellationToken cancellationToken)
    {
        var normalizedPage = page <= 0 ? 1 : page;
        var normalizedPageSize = pageSize <= 0 ? 20 : pageSize;

        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        var totalRegistros = 0;
        using (var countCommand = new SqlCommand(
                   """
                   SELECT COUNT(*)
                   FROM PagosAdministrativos PA
                   INNER JOIN Alumnos A ON PA.IdAlumno = A.IdAlumno
                   """,
                   connection))
        {
            totalRegistros = Convert.ToInt32(await countCommand.ExecuteScalarAsync(cancellationToken));
        }

        var items = new List<DracoinAdministrativePaymentDto>();
        using (var command = new SqlCommand(
                   """
                   SELECT
                       PA.IdPago,
                       PA.IdAlumno,
                       A.Codigo AS CodigoAlumno,
                       A.Nombre AS NombreAlumno,
                       PA.Cargo,
                       PA.MontoPagado,
                       PA.FechaPago,
                       PA.PagadoPor,
                       A.Genero
                   FROM PagosAdministrativos PA
                   INNER JOIN Alumnos A ON PA.IdAlumno = A.IdAlumno
                   ORDER BY PA.FechaPago DESC
                   OFFSET @Offset ROWS FETCH NEXT @Fetch ROWS ONLY
                   """,
                   connection))
        {
            command.Parameters.AddWithValue("@Offset", (normalizedPage - 1) * normalizedPageSize);
            command.Parameters.AddWithValue("@Fetch", normalizedPageSize);

            using var reader = await command.ExecuteReaderAsync(cancellationToken);
            while (await reader.ReadAsync(cancellationToken))
            {
                items.Add(new DracoinAdministrativePaymentDto
                {
                    IdPago = GetRequiredInt(reader, "IdPago"),
                    IdAlumno = GetRequiredInt(reader, "IdAlumno"),
                    CodigoAlumno = GetString(reader, "CodigoAlumno"),
                    NombreAlumno = GetString(reader, "NombreAlumno"),
                    Cargo = GetString(reader, "Cargo"),
                    MontoPagado = GetDecimal(reader, "MontoPagado"),
                    FechaPago = GetDateTime(reader, "FechaPago"),
                    PagadoPor = GetString(reader, "PagadoPor"),
                    Genero = GetString(reader, "Genero")
                });
            }
        }

        return new PagedResult<DracoinAdministrativePaymentDto>
        {
            Items = items,
            TotalRegistros = totalRegistros,
            PaginaActual = normalizedPage,
            RegistrosPorPagina = normalizedPageSize
        };
    }

    public async Task<IReadOnlyList<DracoinSalaryByCargoDto>> GetSalaryCatalogAsync(CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);
        return await GetSalaryCatalogInternalAsync(connection, transaction: null, cancellationToken);
    }

    public async Task<IReadOnlyList<DracoinSalaryByCargoDto>> UpdateSalaryCatalogAsync(
        UpdateDracoinSalaryCatalogRequest request,
        CancellationToken cancellationToken)
    {
        var items = request.Items
            .GroupBy(item => item.IdSueldo)
            .Select(group => group.Last())
            .ToList();

        if (items.Count == 0)
        {
            throw new BusinessRuleException("Debes enviar al menos un sueldo para actualizar.");
        }

        foreach (var item in items)
        {
            if (item.IdSueldo <= 0)
            {
                throw new BusinessRuleException("Uno o mas sueldos no son validos.");
            }

            EnsureWholeDracoinValue(item.SueldoFijo, "Los sueldos deben ser enteros para conservar consistencia con los movimientos.");
        }

        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);
        await using var transaction = await connection.BeginTransactionAsync(cancellationToken);

        try
        {
            foreach (var item in items)
            {
                using var command = new SqlCommand(
                    """
                    UPDATE SueldosCargo
                    SET SueldoFijo = @SueldoFijo
                    WHERE IdSueldo = @IdSueldo
                    """,
                    connection,
                    (SqlTransaction)transaction);
                command.Parameters.AddWithValue("@IdSueldo", item.IdSueldo);
                command.Parameters.AddWithValue("@SueldoFijo", item.SueldoFijo);

                var affectedRows = await command.ExecuteNonQueryAsync(cancellationToken);
                if (affectedRows == 0)
                {
                    throw new BusinessRuleException("Uno o mas cargos de sueldo no existen.");
                }
            }

            await transaction.CommitAsync(cancellationToken);
        }
        catch
        {
            await transaction.RollbackAsync(cancellationToken);
            throw;
        }

        return await GetSalaryCatalogInternalAsync(connection, transaction: null, cancellationToken);
    }

    public async Task<IReadOnlyList<DracoinManualPaymentCandidateDto>> GetManualPaymentCandidatesAsync(
        CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);
        return await GetManualPaymentCandidatesInternalAsync(connection, null, transaction: null, cancellationToken);
    }

    public async Task<DracoinManualPaymentsResultDto> CreateManualPaymentsAsync(
        int idAlumnoEjecutor,
        CreateDracoinManualPaymentsRequest request,
        CancellationToken cancellationToken)
    {
        var items = request.Items
            .GroupBy(item => item.IdAlumno)
            .Select(group => group.Last())
            .ToList();

        if (items.Count == 0)
        {
            throw new BusinessRuleException("Debes seleccionar al menos un pago manual.");
        }

        foreach (var item in items)
        {
            if (item.IdAlumno <= 0)
            {
                throw new BusinessRuleException("Uno o mas pagos manuales no son validos.");
            }
        }

        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);
        await using var transaction = await connection.BeginTransactionAsync(cancellationToken);

        try
        {
            var executor = await GetCurrentExecutorAsync(
                connection,
                idAlumnoEjecutor,
                (SqlTransaction)transaction,
                cancellationToken);

            if (executor is null)
            {
                throw new BusinessRuleException("El usuario que ejecuta el pago no existe o esta inactivo.");
            }

            var itemIds = items.Select(item => item.IdAlumno).ToArray();
            var candidates = await GetManualPaymentCandidatesInternalAsync(
                connection,
                itemIds,
                (SqlTransaction)transaction,
                cancellationToken);

            var candidatesById = candidates.ToDictionary(item => item.IdAlumno);
            if (candidatesById.Count != itemIds.Length)
            {
                throw new BusinessRuleException("Uno o mas destinatarios no son validos para pago manual.");
            }

            var now = DateTime.Now;
            var pagadoPor = $"{executor.Nombre} ({executor.CargoNombre})";
            var processedPayments = new List<DracoinAdministrativePaymentDto>();
            decimal totalMontoPagado = 0m;

            foreach (var item in items)
            {
                var candidate = candidatesById[item.IdAlumno];
                EnsureWholeDracoinValue(
                    candidate.MontoSugerido,
                    "Los sueldos configurados deben usar montos enteros de Dracoins.");
                var wholeAmount = decimal.ToInt32(candidate.MontoSugerido);
                totalMontoPagado += candidate.MontoSugerido;

                var personalizedCargo = GetPersonalizedCargo(candidate.Cargo, candidate.Genero);
                var observacion =
                    $"Pago de sueldo (BANCO) al cargo {personalizedCargo}. Ejecutado por {executor.Nombre} ({executor.CargoNombre}).";

                int idPago;
                using (var paymentCommand = new SqlCommand(
                           """
                           INSERT INTO PagosAdministrativos (IdAlumno, Cargo, MontoPagado, FechaPago, PagadoPor)
                           VALUES (@IdAlumno, @Cargo, @MontoPagado, @FechaPago, @PagadoPor);
                           SELECT CAST(SCOPE_IDENTITY() AS INT);
                           """,
                           connection,
                           (SqlTransaction)transaction))
                {
                    paymentCommand.Parameters.AddWithValue("@IdAlumno", candidate.IdAlumno);
                    paymentCommand.Parameters.AddWithValue("@Cargo", candidate.Cargo);
                    paymentCommand.Parameters.AddWithValue("@MontoPagado", candidate.MontoSugerido);
                    paymentCommand.Parameters.AddWithValue("@FechaPago", now);
                    paymentCommand.Parameters.AddWithValue("@PagadoPor", pagadoPor);

                    idPago = Convert.ToInt32(
                        await paymentCommand.ExecuteScalarAsync(cancellationToken),
                        CultureInfo.InvariantCulture);
                }

                using (var creditCommand = new SqlCommand(
                           "UPDATE Alumnos SET Dracoins = Dracoins + @Monto WHERE IdAlumno = @IdAlumno",
                           connection,
                           (SqlTransaction)transaction))
                {
                    creditCommand.Parameters.AddWithValue("@Monto", wholeAmount);
                    creditCommand.Parameters.AddWithValue("@IdAlumno", candidate.IdAlumno);
                    await creditCommand.ExecuteNonQueryAsync(cancellationToken);
                }

                await RegisterMovementAsync(
                    connection,
                    (SqlTransaction)transaction,
                    BancoCode,
                    candidate.CodigoAlumno,
                    wholeAmount,
                    observacion,
                    cancellationToken);

                processedPayments.Add(new DracoinAdministrativePaymentDto
                {
                    IdPago = idPago,
                    IdAlumno = candidate.IdAlumno,
                    CodigoAlumno = candidate.CodigoAlumno,
                    NombreAlumno = candidate.NombreAlumno,
                    Cargo = candidate.Cargo,
                    MontoPagado = candidate.MontoSugerido,
                    FechaPago = now,
                    PagadoPor = pagadoPor,
                    Genero = candidate.Genero
                });
            }

            await transaction.CommitAsync(cancellationToken);

            return new DracoinManualPaymentsResultDto
            {
                TotalPagosProcesados = processedPayments.Count,
                TotalMontoPagado = totalMontoPagado,
                Pagos = processedPayments
            };
        }
        catch
        {
            await transaction.RollbackAsync(cancellationToken);
            throw;
        }
    }

    private async Task<PagedResult<DracoinTransferDto>> GetTransferHistoryInternalAsync(
        SqlConnection connection,
        string codigo,
        int page,
        int pageSize,
        CancellationToken cancellationToken)
    {
        var normalizedPage = page <= 0 ? 1 : page;
        var normalizedPageSize = pageSize <= 0 ? 20 : pageSize;

        var totalRegistros = 0;
        using (var countCommand = new SqlCommand(
                   """
                   SELECT COUNT(*)
                   FROM MovimientosDracoins
                   WHERE CodigoRemitente = @Codigo OR CodigoDestinatario = @Codigo
                   """,
                   connection))
        {
            countCommand.Parameters.AddWithValue("@Codigo", codigo);
            totalRegistros = Convert.ToInt32(await countCommand.ExecuteScalarAsync(cancellationToken));
        }

        var items = new List<DracoinTransferDto>();
        using (var command = new SqlCommand(
                   """
                   SELECT
                       M.IdMovimiento,
                       M.CodigoRemitente,
                       AR.Nombre AS NombreRemitente,
                       M.CodigoDestinatario,
                       AD.Nombre AS NombreDestinatario,
                       M.Monto,
                       M.FechaTransferencia,
                       M.Observacion
                   FROM MovimientosDracoins M
                   LEFT JOIN Alumnos AR ON AR.Codigo = M.CodigoRemitente
                   LEFT JOIN Alumnos AD ON AD.Codigo = M.CodigoDestinatario
                   WHERE M.CodigoRemitente = @Codigo OR M.CodigoDestinatario = @Codigo
                   ORDER BY M.FechaTransferencia DESC
                   OFFSET @Offset ROWS FETCH NEXT @Fetch ROWS ONLY
                   """,
                   connection))
        {
            command.Parameters.AddWithValue("@Codigo", codigo);
            command.Parameters.AddWithValue("@Offset", (normalizedPage - 1) * normalizedPageSize);
            command.Parameters.AddWithValue("@Fetch", normalizedPageSize);

            using var reader = await command.ExecuteReaderAsync(cancellationToken);
            while (await reader.ReadAsync(cancellationToken))
            {
                items.Add(MapTransfer(reader, codigo));
            }
        }

        return new PagedResult<DracoinTransferDto>
        {
            Items = items,
            TotalRegistros = totalRegistros,
            PaginaActual = normalizedPage,
            RegistrosPorPagina = normalizedPageSize
        };
    }

    private async Task<IReadOnlyList<DracoinSalaryByCargoDto>> GetSalaryCatalogInternalAsync(
        SqlConnection connection,
        SqlTransaction? transaction,
        CancellationToken cancellationToken)
    {
        var items = new List<DracoinSalaryByCargoDto>();
        using var command = new SqlCommand(
            """
            SELECT IdSueldo, Cargo, SueldoFijo
            FROM SueldosCargo
            ORDER BY Cargo
            """,
            connection,
            transaction);

        using var reader = await command.ExecuteReaderAsync(cancellationToken);
        while (await reader.ReadAsync(cancellationToken))
        {
            items.Add(new DracoinSalaryByCargoDto
            {
                IdSueldo = GetRequiredInt(reader, "IdSueldo"),
                Cargo = GetString(reader, "Cargo"),
                SueldoFijo = GetDecimal(reader, "SueldoFijo")
            });
        }

        return items;
    }

    private async Task<IReadOnlyList<DracoinManualPaymentCandidateDto>> GetManualPaymentCandidatesInternalAsync(
        SqlConnection connection,
        IReadOnlyCollection<int>? filterIds,
        SqlTransaction? transaction,
        CancellationToken cancellationToken)
    {
        var queryBuilder = new StringBuilder(
            """
            SELECT
                A.IdAlumno,
                A.Codigo AS CodigoAlumno,
                A.Nombre AS NombreAlumno,
                C.Nombre AS Cargo,
                A.Genero,
                S.SueldoFijo AS MontoSugerido,
                A.Dracoins AS DracoinsActuales
            FROM Alumnos A
            INNER JOIN Cargos C ON A.IdCargo = C.IdCargo
            INNER JOIN SueldosCargo S ON LTRIM(RTRIM(LOWER(C.Nombre))) = LTRIM(RTRIM(LOWER(S.Cargo)))
            WHERE LTRIM(RTRIM(LOWER(C.Nombre))) <> 'alumno'
              AND A.Activo = 1
            """);

        using var command = new SqlCommand { Connection = connection, Transaction = transaction };

        if (filterIds is { Count: > 0 })
        {
            var parameterNames = new List<string>();
            var index = 0;

            foreach (var id in filterIds.Distinct())
            {
                var parameterName = $"@IdAlumno{index++}";
                parameterNames.Add(parameterName);
                command.Parameters.AddWithValue(parameterName, id);
            }

            queryBuilder.Append($" AND A.IdAlumno IN ({string.Join(", ", parameterNames)})");
        }

        queryBuilder.Append(" ORDER BY A.Nombre");
        command.CommandText = queryBuilder.ToString();

        var items = new List<DracoinManualPaymentCandidateDto>();
        using var reader = await command.ExecuteReaderAsync(cancellationToken);
        while (await reader.ReadAsync(cancellationToken))
        {
            items.Add(new DracoinManualPaymentCandidateDto
            {
                IdAlumno = GetRequiredInt(reader, "IdAlumno"),
                CodigoAlumno = GetString(reader, "CodigoAlumno"),
                NombreAlumno = GetString(reader, "NombreAlumno"),
                Cargo = GetString(reader, "Cargo"),
                Genero = GetString(reader, "Genero"),
                MontoSugerido = GetDecimal(reader, "MontoSugerido"),
                DracoinsActuales = GetDecimal(reader, "DracoinsActuales")
            });
        }

        return items;
    }

    private async Task<(int TotalTransferencias, int MontoTotal)> GetTransferStatsAsync(
        SqlConnection connection,
        string codigo,
        bool sent,
        CancellationToken cancellationToken)
    {
        var column = sent ? "CodigoRemitente" : "CodigoDestinatario";

        using var command = new SqlCommand(
            $"""
            SELECT
                COUNT(*) AS TotalTransferencias,
                ISNULL(SUM(Monto), 0) AS MontoTotal
            FROM MovimientosDracoins
            WHERE {column} = @Codigo
            """,
            connection);
        command.Parameters.AddWithValue("@Codigo", codigo);

        using var reader = await command.ExecuteReaderAsync(cancellationToken);
        if (!await reader.ReadAsync(cancellationToken))
        {
            return (0, 0);
        }

        return (
            GetRequiredInt(reader, "TotalTransferencias"),
            GetRequiredInt(reader, "MontoTotal"));
    }

    private async Task<AlumnoContext?> GetCurrentAlumnoAsync(
        SqlConnection connection,
        int idAlumno,
        CancellationToken cancellationToken)
    {
        using var command = new SqlCommand(
            """
            SELECT IdAlumno, Codigo, Nombre, Dracoins
            FROM Alumnos
            WHERE IdAlumno = @IdAlumno
              AND Activo = 1
            """,
            connection);
        command.Parameters.AddWithValue("@IdAlumno", idAlumno);

        using var reader = await command.ExecuteReaderAsync(cancellationToken);
        if (!await reader.ReadAsync(cancellationToken))
        {
            return null;
        }

        return new AlumnoContext(
            GetRequiredInt(reader, "IdAlumno"),
            GetString(reader, "Codigo"),
            GetString(reader, "Nombre"),
            GetDecimal(reader, "Dracoins"));
    }

    private async Task<ExecutorContext?> GetCurrentExecutorAsync(
        SqlConnection connection,
        int idAlumno,
        SqlTransaction transaction,
        CancellationToken cancellationToken)
    {
        using var command = new SqlCommand(
            """
            SELECT
                A.IdAlumno,
                A.Codigo,
                A.Nombre,
                ISNULL(C.Nombre, '') AS CargoNombre,
                A.Genero
            FROM Alumnos A
            LEFT JOIN Cargos C ON C.IdCargo = A.IdCargo
            WHERE A.IdAlumno = @IdAlumno
              AND A.Activo = 1
            """,
            connection,
            transaction);
        command.Parameters.AddWithValue("@IdAlumno", idAlumno);

        using var reader = await command.ExecuteReaderAsync(cancellationToken);
        if (!await reader.ReadAsync(cancellationToken))
        {
            return null;
        }

        return new ExecutorContext(
            GetRequiredInt(reader, "IdAlumno"),
            GetString(reader, "Codigo"),
            GetString(reader, "Nombre"),
            GetString(reader, "CargoNombre"),
            GetString(reader, "Genero"));
    }

    private async Task<AlumnoContext?> GetAlumnoByCodigoAsync(
        SqlConnection connection,
        string codigo,
        CancellationToken cancellationToken)
    {
        using var command = new SqlCommand(
            """
            SELECT TOP 1 IdAlumno, Codigo, Nombre, Dracoins
            FROM Alumnos
            WHERE Codigo = @Codigo
              AND Activo = 1
            """,
            connection);
        command.Parameters.AddWithValue("@Codigo", codigo);

        using var reader = await command.ExecuteReaderAsync(cancellationToken);
        if (!await reader.ReadAsync(cancellationToken))
        {
            return null;
        }

        return new AlumnoContext(
            GetRequiredInt(reader, "IdAlumno"),
            GetString(reader, "Codigo"),
            GetString(reader, "Nombre"),
            GetDecimal(reader, "Dracoins"));
    }

    private static async Task<int> RegisterMovementAsync(
        SqlConnection connection,
        SqlTransaction transaction,
        string codigoRemitente,
        string codigoDestinatario,
        int monto,
        string? observacion,
        CancellationToken cancellationToken)
    {
        using var movementCommand = new SqlCommand(
            "RegistrarMovimientoDracoins",
            connection,
            transaction);
        movementCommand.CommandType = CommandType.StoredProcedure;
        movementCommand.Parameters.AddWithValue("@CodigoRemitente", codigoRemitente);
        movementCommand.Parameters.AddWithValue("@CodigoDestinatario", codigoDestinatario);
        movementCommand.Parameters.AddWithValue("@Monto", monto);
        movementCommand.Parameters.AddWithValue(
            "@Observacion",
            string.IsNullOrWhiteSpace(observacion)
                ? DBNull.Value
                : observacion.Trim());

        return Convert.ToInt32(
            await movementCommand.ExecuteScalarAsync(cancellationToken),
            CultureInfo.InvariantCulture);
    }

    private static void CopyParameters(SqlCommand source, SqlCommand destination)
    {
        foreach (SqlParameter parameter in source.Parameters)
        {
            destination.Parameters.AddWithValue(parameter.ParameterName, parameter.Value);
        }
    }

    private static void EnsureWholeDracoinValue(decimal value, string message)
    {
        if (value < 0)
        {
            throw new BusinessRuleException("Los montos no pueden ser negativos.");
        }

        if (decimal.Truncate(value) != value)
        {
            throw new BusinessRuleException(message);
        }
    }

    private static string GetPersonalizedCargo(string cargo, string genero)
    {
        if (string.IsNullOrWhiteSpace(cargo))
        {
            return string.Empty;
        }

        return cargo.Trim().ToLowerInvariant() switch
        {
            "prefecto" => genero switch
            {
                "Femenino" => "Prefecta",
                "No binario" => "Prefecte",
                _ => "Prefecto"
            },
            "alumno" => genero switch
            {
                "Femenino" => "Alumna",
                "No binario" => "Alumne",
                _ => "Alumno"
            },
            "inquisidor" => genero switch
            {
                "Femenino" => "Inquisidora",
                "No binario" => "Inquisidore",
                _ => "Inquisidor"
            },
            "subdirector" => genero switch
            {
                "Femenino" => "Subdirectora",
                "No binario" => "Subdirectore",
                _ => "Subdirector"
            },
            "directora" => genero switch
            {
                "Masculino" => "Director",
                "No binario" => "Directore",
                _ => "Directora"
            },
            "jefe de casa" => genero switch
            {
                "Femenino" => "Jefa de casa",
                "No binario" => "Jefe de casa",
                _ => "Jefe de casa"
            },
            "prefecto restringido" => genero switch
            {
                "Femenino" => "Prefecta restringida",
                "No binario" => "Prefecte restringide",
                _ => "Prefecto restringido"
            },
            "jefe restringido" => genero switch
            {
                "Femenino" => "Jefa restringida",
                "No binario" => "Jefe restringide",
                _ => "Jefe restringido"
            },
            "alta restringido" => genero switch
            {
                "Femenino" => "Alta restringida",
                "No binario" => "Alta restringide",
                _ => "Alta restringido"
            },
            _ => cargo
        };
    }

    private static DracoinTransferDto MapTransfer(SqlDataReader reader, string codigoActual) =>
        new()
        {
            IdMovimiento = GetRequiredInt(reader, "IdMovimiento"),
            CodigoRemitente = GetString(reader, "CodigoRemitente"),
            NombreRemitente = GetString(reader, "NombreRemitente"),
            CodigoDestinatario = GetString(reader, "CodigoDestinatario"),
            NombreDestinatario = GetString(reader, "NombreDestinatario"),
            Monto = GetRequiredInt(reader, "Monto"),
            FechaTransferencia = GetDateTime(reader, "FechaTransferencia"),
            Observacion = GetString(reader, "Observacion"),
            EsRecibido = string.Equals(
                GetString(reader, "CodigoDestinatario"),
                codigoActual,
                StringComparison.OrdinalIgnoreCase)
        };

    private static string GetString(SqlDataReader reader, string columnName) =>
        reader[columnName] == DBNull.Value ? string.Empty : reader[columnName]?.ToString() ?? string.Empty;

    private static int GetRequiredInt(SqlDataReader reader, string columnName) =>
        Convert.ToInt32(reader[columnName], CultureInfo.InvariantCulture);

    private static decimal GetDecimal(SqlDataReader reader, string columnName) =>
        reader[columnName] == DBNull.Value
            ? 0m
            : Convert.ToDecimal(reader[columnName], CultureInfo.InvariantCulture);

    private static DateTime GetDateTime(SqlDataReader reader, string columnName) =>
        Convert.ToDateTime(reader[columnName], CultureInfo.InvariantCulture);

    private sealed record AlumnoContext(int IdAlumno, string Codigo, string Nombre, decimal Dracoins);

    private sealed record ExecutorContext(
        int IdAlumno,
        string Codigo,
        string Nombre,
        string CargoNombre,
        string Genero);
}
