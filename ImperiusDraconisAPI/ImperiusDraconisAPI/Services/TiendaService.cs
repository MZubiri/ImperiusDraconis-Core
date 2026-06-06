using System.Globalization;
using ImperiusDraconisAPI.Common;
using ImperiusDraconisAPI.Data;
using ImperiusDraconisAPI.Models.Tienda;
using Microsoft.Data.SqlClient;

namespace ImperiusDraconisAPI.Services;

public sealed class TiendaService
{
    private const int EstadoPendiente = 1;
    private const int EstadoPagado = 2;
    private const int EstadoEntregado = 3;
    private const int EstadoCancelado = 4;

    private readonly SqlConnectionFactory _connectionFactory;

    public TiendaService(SqlConnectionFactory connectionFactory)
    {
        _connectionFactory = connectionFactory;
    }

    public async Task<IReadOnlyCollection<TiendaProductoDto>> GetCatalogAsync(
        TiendaProductoQuery query,
        CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        var filters = new List<string> { "Activo = 1" };
        using var command = new SqlCommand { Connection = connection };

        if (!string.IsNullOrWhiteSpace(query.Nombre))
        {
            filters.Add("Nombre LIKE @Nombre");
            command.Parameters.AddWithValue("@Nombre", $"%{query.Nombre.Trim()}%");
        }

        if (query.PrecioMin.HasValue)
        {
            filters.Add("Precio >= @PrecioMin");
            command.Parameters.AddWithValue("@PrecioMin", query.PrecioMin.Value);
        }

        if (query.PrecioMax.HasValue)
        {
            filters.Add("Precio <= @PrecioMax");
            command.Parameters.AddWithValue("@PrecioMax", query.PrecioMax.Value);
        }

        command.CommandText =
            $"""
            SELECT IdProducto, Nombre, Descripcion, Precio, Imagen, Activo
            FROM Productos
            WHERE {string.Join(" AND ", filters)}
            ORDER BY Nombre
            """;

        var items = new List<TiendaProductoDto>();
        using var reader = await command.ExecuteReaderAsync(cancellationToken);
        while (await reader.ReadAsync(cancellationToken))
        {
            items.Add(MapProducto(reader));
        }

        return items;
    }

    public async Task<TiendaCompraCatalogosDto> GetCompraCatalogosAsync(
        int idAlumnoActual,
        CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        var destinatarios = new List<CatalogItemDto>();
        using var command = new SqlCommand(
            """
            SELECT IdAlumno, Codigo, Nombre
            FROM Alumnos
            WHERE Activo = 1
              AND IdAlumno <> @IdAlumnoActual
            ORDER BY Codigo
            """,
            connection);
        command.Parameters.AddWithValue("@IdAlumnoActual", idAlumnoActual);

        using var reader = await command.ExecuteReaderAsync(cancellationToken);
        while (await reader.ReadAsync(cancellationToken))
        {
            destinatarios.Add(new CatalogItemDto
            {
                Id = GetRequiredInt(reader, "IdAlumno"),
                Nombre = $"{GetString(reader, "Codigo")} - {GetString(reader, "Nombre")}"
            });
        }

        return new TiendaCompraCatalogosDto
        {
            Destinatarios = destinatarios
        };
    }

    public async Task<TiendaPanelResumenDto> GetPanelResumenAsync(CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        return new TiendaPanelResumenDto
        {
            TotalProductosActivos = await CountAsync(
                connection,
                "SELECT COUNT(*) FROM Productos WHERE Activo = 1",
                cancellationToken),
            TotalPedidosPendientes = await CountAsync(
                connection,
                "SELECT COUNT(*) FROM Pedidos WHERE IdEstado = 1",
                cancellationToken),
            TotalPedidosTomados = await CountAsync(
                connection,
                "SELECT COUNT(*) FROM Pedidos WHERE IdEstado = 2",
                cancellationToken),
            TotalPedidosEntregados = await CountAsync(
                connection,
                "SELECT COUNT(*) FROM Pedidos WHERE IdEstado = 3",
                cancellationToken),
            TotalPedidosCancelados = await CountAsync(
                connection,
                "SELECT COUNT(*) FROM Pedidos WHERE IdEstado = 4",
                cancellationToken)
        };
    }

    public async Task<TiendaComprobanteDto> CreateCompraAsync(
        int idComprador,
        CreateTiendaCompraRequest request,
        CancellationToken cancellationToken)
    {
        if (request.IdProducto <= 0)
        {
            throw new BusinessRuleException("Debes seleccionar un producto valido.");
        }

        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        var producto = await GetProductoActivoAsync(connection, transaction: null, request.IdProducto, cancellationToken)
            ?? throw new BusinessRuleException("El producto seleccionado no existe o esta inactivo.");

        var comprador = await GetAlumnoAsync(connection, transaction: null, idComprador, cancellationToken)
            ?? throw new BusinessRuleException("No se encontro al comprador actual.");

        if (comprador.Dracoins < producto.Precio)
        {
            throw new BusinessRuleException("No tienes suficientes Dracoins para comprar este producto.");
        }

        if (request.IdDestinatario.HasValue && request.IdDestinatario.Value == idComprador)
        {
            throw new BusinessRuleException("No puedes enviarte el regalo a ti mismo.");
        }

        if (request.IdDestinatario.HasValue)
        {
            var destinatario = await GetAlumnoAsync(
                connection,
                transaction: null,
                request.IdDestinatario.Value,
                cancellationToken);

            if (destinatario is null)
            {
                throw new BusinessRuleException("El destinatario seleccionado no esta disponible.");
            }
        }

        await using var transaction = await connection.BeginTransactionAsync(cancellationToken);

        try
        {
            using (var discountCommand = new SqlCommand(
                       "UPDATE Alumnos SET Dracoins = Dracoins - @Monto WHERE IdAlumno = @IdAlumno",
                       connection,
                       (SqlTransaction)transaction))
            {
                discountCommand.Parameters.AddWithValue("@Monto", producto.Precio);
                discountCommand.Parameters.AddWithValue("@IdAlumno", idComprador);
                await discountCommand.ExecuteNonQueryAsync(cancellationToken);
            }

            var idPedido = 0;
            using (var insertPedidoCommand = new SqlCommand(
                       """
                       INSERT INTO Pedidos
                       (IdComprador, IdDestinatario, FechaPedido, IdEstado, Total, Comentario)
                       VALUES (@IdComprador, @IdDestinatario, @FechaPedido, @IdEstado, @Total, @Comentario);
                       SELECT CAST(SCOPE_IDENTITY() AS int);
                       """,
                       connection,
                       (SqlTransaction)transaction))
            {
                insertPedidoCommand.Parameters.AddWithValue("@IdComprador", idComprador);
                insertPedidoCommand.Parameters.AddWithValue(
                    "@IdDestinatario",
                    (object?)request.IdDestinatario ?? DBNull.Value);
                insertPedidoCommand.Parameters.AddWithValue("@FechaPedido", DateTime.Now);
                insertPedidoCommand.Parameters.AddWithValue("@IdEstado", EstadoPendiente);
                insertPedidoCommand.Parameters.AddWithValue("@Total", producto.Precio);
                insertPedidoCommand.Parameters.AddWithValue(
                    "@Comentario",
                    string.IsNullOrWhiteSpace(request.Comentario)
                        ? DBNull.Value
                        : request.Comentario.Trim());

                idPedido = Convert.ToInt32(
                    await insertPedidoCommand.ExecuteScalarAsync(cancellationToken),
                    CultureInfo.InvariantCulture);
            }

            using (var insertDetalleCommand = new SqlCommand(
                       """
                       INSERT INTO DetallePedidos
                       (IdPedido, IdProducto, Cantidad, PrecioUnitario, Subtotal)
                       VALUES (@IdPedido, @IdProducto, 1, @PrecioUnitario, @Subtotal)
                       """,
                       connection,
                       (SqlTransaction)transaction))
            {
                insertDetalleCommand.Parameters.AddWithValue("@IdPedido", idPedido);
                insertDetalleCommand.Parameters.AddWithValue("@IdProducto", producto.IdProducto);
                insertDetalleCommand.Parameters.AddWithValue("@PrecioUnitario", producto.Precio);
                insertDetalleCommand.Parameters.AddWithValue("@Subtotal", producto.Precio);
                await insertDetalleCommand.ExecuteNonQueryAsync(cancellationToken);
            }

            await InsertHistorialEstadoAsync(
                connection,
                (SqlTransaction)transaction,
                idPedido,
                EstadoPendiente,
                idComprador,
                request.IdDestinatario.HasValue ? "Pedido creado como regalo." : "Pedido creado.",
                cancellationToken);

            await transaction.CommitAsync(cancellationToken);

            return await GetComprobanteInternalAsync(connection, transaction: null, idPedido, cancellationToken)
                ?? throw new InvalidOperationException("No se pudo recuperar el comprobante generado.");
        }
        catch
        {
            await transaction.RollbackAsync(cancellationToken);
            throw;
        }
    }

    public async Task<TiendaComprobanteDto?> GetComprobanteAsync(
        int idPedido,
        int idAlumnoActual,
        bool canAdmin,
        CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        var pedido = await GetPedidoByIdInternalAsync(connection, transaction: null, idPedido, cancellationToken);
        if (pedido is null || !CanAccessPedido(pedido, idAlumnoActual, canAdmin))
        {
            return null;
        }

        return await GetComprobanteInternalAsync(connection, transaction: null, idPedido, cancellationToken);
    }

    public async Task<PagedResult<TiendaPedidoDto>> GetHistorialAsync(
        int idAlumno,
        TiendaHistorialQuery query,
        CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        var pagina = query.Pagina <= 0 ? 1 : query.Pagina;
        var registrosPorPagina = query.RegistrosPorPagina <= 0 ? 10 : query.RegistrosPorPagina;
        var fechaHasta = query.Hasta?.Date.AddDays(1).AddTicks(-1);

        var filters = new List<string> { "P.IdComprador = @IdCompradorFiltro" };
        if (!string.IsNullOrWhiteSpace(query.Estado))
        {
            filters.Add("E.Nombre = @EstadoFiltro");
        }

        if (!string.IsNullOrWhiteSpace(query.Nombre))
        {
            filters.Add("Pr.Nombre LIKE @NombreFiltro");
        }

        if (query.Desde.HasValue)
        {
            filters.Add("P.FechaPedido >= @FechaDesde");
        }

        if (query.Hasta.HasValue)
        {
            filters.Add("P.FechaPedido <= @FechaHasta");
        }

        var where = $"WHERE {string.Join(" AND ", filters)}";
        var totalRegistros = await CountPedidosAsync(
            connection,
            where,
            command =>
            {
                command.Parameters.AddWithValue("@IdCompradorFiltro", idAlumno);
                if (!string.IsNullOrWhiteSpace(query.Estado))
                {
                    command.Parameters.AddWithValue("@EstadoFiltro", query.Estado.Trim());
                }

                if (!string.IsNullOrWhiteSpace(query.Nombre))
                {
                    command.Parameters.AddWithValue("@NombreFiltro", $"%{query.Nombre.Trim()}%");
                }

                if (query.Desde.HasValue)
                {
                    command.Parameters.AddWithValue("@FechaDesde", query.Desde.Value.Date);
                }

                if (query.Hasta.HasValue)
                {
                    command.Parameters.AddWithValue("@FechaHasta", (object?)fechaHasta ?? DBNull.Value);
                }
            },
            cancellationToken);

        using var command = CreatePedidoProjectionCommand(connection, transaction: null, where);
        command.Parameters.AddWithValue("@IdCompradorFiltro", idAlumno);
        if (!string.IsNullOrWhiteSpace(query.Estado))
        {
            command.Parameters.AddWithValue("@EstadoFiltro", query.Estado.Trim());
        }

        if (!string.IsNullOrWhiteSpace(query.Nombre))
        {
            command.Parameters.AddWithValue("@NombreFiltro", $"%{query.Nombre.Trim()}%");
        }

        if (query.Desde.HasValue)
        {
            command.Parameters.AddWithValue("@FechaDesde", query.Desde.Value.Date);
        }

        if (query.Hasta.HasValue)
        {
            command.Parameters.AddWithValue("@FechaHasta", (object?)fechaHasta ?? DBNull.Value);
        }

        command.CommandText += " ORDER BY P.IdPedido DESC OFFSET @Offset ROWS FETCH NEXT @Fetch ROWS ONLY";
        command.Parameters.AddWithValue("@Offset", (pagina - 1) * registrosPorPagina);
        command.Parameters.AddWithValue("@Fetch", registrosPorPagina);

        var items = await ReadPedidosAsync(command, cancellationToken);
        return new PagedResult<TiendaPedidoDto>
        {
            Items = items,
            TotalRegistros = totalRegistros,
            PaginaActual = pagina,
            RegistrosPorPagina = registrosPorPagina
        };
    }

    public async Task<bool> CancelarPedidoAsync(
        int idPedido,
        int idAlumno,
        CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);
        await using var transaction = await connection.BeginTransactionAsync(cancellationToken);

        var pedido = await GetPedidoEstadoContextAsync(connection, (SqlTransaction)transaction, idPedido, cancellationToken);
        if (pedido is null)
        {
            return false;
        }

        if (pedido.IdComprador != idAlumno)
        {
            throw new BusinessRuleException("Solo el comprador puede cancelar este pedido.");
        }

        if (pedido.IdEstado != EstadoPendiente || (DateTime.Now - pedido.FechaPedido).TotalDays < 7)
        {
            throw new BusinessRuleException("El pedido ya no cumple las condiciones para ser cancelado.");
        }

        try
        {
            using (var updateCommand = new SqlCommand(
                       """
                       UPDATE Pedidos
                       SET IdEstado = @EstadoCancelado
                       WHERE IdPedido = @IdPedido
                         AND IdComprador = @IdComprador
                         AND IdEstado = @EstadoPendiente
                       """,
                       connection,
                       (SqlTransaction)transaction))
            {
                updateCommand.Parameters.AddWithValue("@EstadoCancelado", EstadoCancelado);
                updateCommand.Parameters.AddWithValue("@IdPedido", idPedido);
                updateCommand.Parameters.AddWithValue("@IdComprador", idAlumno);
                updateCommand.Parameters.AddWithValue("@EstadoPendiente", EstadoPendiente);
                if (await updateCommand.ExecuteNonQueryAsync(cancellationToken) == 0)
                {
                    throw new BusinessRuleException("No se pudo cancelar el pedido.");
                }
            }

            using (var refundCommand = new SqlCommand(
                       "UPDATE Alumnos SET Dracoins = Dracoins + @Monto WHERE IdAlumno = @IdAlumno",
                       connection,
                       (SqlTransaction)transaction))
            {
                refundCommand.Parameters.AddWithValue("@Monto", pedido.Total);
                refundCommand.Parameters.AddWithValue("@IdAlumno", idAlumno);
                await refundCommand.ExecuteNonQueryAsync(cancellationToken);
            }

            await InsertHistorialEstadoAsync(
                connection,
                (SqlTransaction)transaction,
                idPedido,
                EstadoCancelado,
                idAlumno,
                "Cancelacion por el comprador.",
                cancellationToken);

            await transaction.CommitAsync(cancellationToken);
            return true;
        }
        catch
        {
            await transaction.RollbackAsync(cancellationToken);
            throw;
        }
    }

    public async Task<IReadOnlyCollection<TiendaPedidoDto>> GetPendientesAsync(CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        using var command = CreatePedidoProjectionCommand(
            connection,
            transaction: null,
            "WHERE P.IdEstado = @EstadoPendiente ORDER BY P.IdPedido DESC");
        command.Parameters.AddWithValue("@EstadoPendiente", EstadoPendiente);

        return await ReadPedidosAsync(command, cancellationToken);
    }

    public async Task<TiendaPedidoDto?> TomarPedidoAsync(
        int idPedido,
        int idVendedor,
        CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);
        await using var transaction = await connection.BeginTransactionAsync(cancellationToken);

        var pedido = await GetPedidoEstadoContextAsync(connection, (SqlTransaction)transaction, idPedido, cancellationToken);
        if (pedido is null)
        {
            return null;
        }

        if (pedido.IdEstado != EstadoPendiente)
        {
            throw new BusinessRuleException("El pedido ya no se encuentra pendiente.");
        }

        try
        {
            using (var command = new SqlCommand(
                       """
                       UPDATE Pedidos
                       SET IdEstado = @EstadoPagado,
                           IdVendedor = @IdVendedor
                       WHERE IdPedido = @IdPedido
                         AND IdEstado = @EstadoPendiente
                       """,
                       connection,
                       (SqlTransaction)transaction))
            {
                command.Parameters.AddWithValue("@EstadoPagado", EstadoPagado);
                command.Parameters.AddWithValue("@IdVendedor", idVendedor);
                command.Parameters.AddWithValue("@IdPedido", idPedido);
                command.Parameters.AddWithValue("@EstadoPendiente", EstadoPendiente);

                if (await command.ExecuteNonQueryAsync(cancellationToken) == 0)
                {
                    throw new BusinessRuleException("No se pudo tomar el pedido.");
                }
            }

            await InsertHistorialEstadoAsync(
                connection,
                (SqlTransaction)transaction,
                idPedido,
                EstadoPagado,
                idVendedor,
                "Pedido tomado por vendedor.",
                cancellationToken);

            await transaction.CommitAsync(cancellationToken);
            return await GetPedidoByIdInternalAsync(connection, transaction: null, idPedido, cancellationToken);
        }
        catch
        {
            await transaction.RollbackAsync(cancellationToken);
            throw;
        }
    }

    public async Task<IReadOnlyCollection<TiendaPedidoDto>> GetMisPedidosAsync(
        int idVendedor,
        CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        using var command = CreatePedidoProjectionCommand(
            connection,
            transaction: null,
            """
            WHERE P.IdVendedor = @IdVendedor
              AND P.IdEstado IN (@EstadoPagado, @EstadoEntregado)
            ORDER BY P.FechaPedido DESC, P.IdPedido DESC
            """);
        command.Parameters.AddWithValue("@IdVendedor", idVendedor);
        command.Parameters.AddWithValue("@EstadoPagado", EstadoPagado);
        command.Parameters.AddWithValue("@EstadoEntregado", EstadoEntregado);

        return await ReadPedidosAsync(command, cancellationToken);
    }

    public async Task<TiendaPedidoDto?> CambiarEstadoVendedorAsync(
        int idPedido,
        int idVendedor,
        UpdateTiendaPedidoEstadoRequest request,
        CancellationToken cancellationToken)
    {
        if (request.NuevoEstado is not (EstadoEntregado or EstadoCancelado))
        {
            throw new BusinessRuleException("El estado solicitado no es valido para el vendedor.");
        }

        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);
        await using var transaction = await connection.BeginTransactionAsync(cancellationToken);

        var pedido = await GetPedidoEstadoContextAsync(connection, (SqlTransaction)transaction, idPedido, cancellationToken);
        if (pedido is null)
        {
            return null;
        }

        if (pedido.IdVendedor != idVendedor)
        {
            throw new BusinessRuleException("El pedido no esta asignado al vendedor actual.");
        }

        if (pedido.IdEstado != EstadoPagado)
        {
            throw new BusinessRuleException("Solo puedes cerrar pedidos que sigan pagados.");
        }

        try
        {
            using (var updateCommand = new SqlCommand(
                       """
                       UPDATE Pedidos
                       SET IdEstado = @NuevoEstado
                       WHERE IdPedido = @IdPedido
                         AND IdVendedor = @IdVendedor
                         AND IdEstado = @EstadoPagado
                       """,
                       connection,
                       (SqlTransaction)transaction))
            {
                updateCommand.Parameters.AddWithValue("@NuevoEstado", request.NuevoEstado);
                updateCommand.Parameters.AddWithValue("@IdPedido", idPedido);
                updateCommand.Parameters.AddWithValue("@IdVendedor", idVendedor);
                updateCommand.Parameters.AddWithValue("@EstadoPagado", EstadoPagado);

                if (await updateCommand.ExecuteNonQueryAsync(cancellationToken) == 0)
                {
                    throw new BusinessRuleException("No se pudo actualizar el estado del pedido.");
                }
            }

            if (request.NuevoEstado == EstadoEntregado)
            {
                var comision = Math.Round(pedido.Total * 0.15m, 2, MidpointRounding.AwayFromZero);
                using var commissionCommand = new SqlCommand(
                    "UPDATE Alumnos SET Dracoins = Dracoins + @Monto WHERE IdAlumno = @IdVendedor",
                    connection,
                    (SqlTransaction)transaction);
                commissionCommand.Parameters.AddWithValue("@Monto", comision);
                commissionCommand.Parameters.AddWithValue("@IdVendedor", idVendedor);
                await commissionCommand.ExecuteNonQueryAsync(cancellationToken);
            }
            else
            {
                using var refundCommand = new SqlCommand(
                    "UPDATE Alumnos SET Dracoins = Dracoins + @Monto WHERE IdAlumno = @IdComprador",
                    connection,
                    (SqlTransaction)transaction);
                refundCommand.Parameters.AddWithValue("@Monto", pedido.Total);
                refundCommand.Parameters.AddWithValue("@IdComprador", pedido.IdComprador);
                await refundCommand.ExecuteNonQueryAsync(cancellationToken);
            }

            await InsertHistorialEstadoAsync(
                connection,
                (SqlTransaction)transaction,
                idPedido,
                request.NuevoEstado,
                idVendedor,
                request.Observacion,
                cancellationToken);

            await transaction.CommitAsync(cancellationToken);
            return await GetPedidoByIdInternalAsync(connection, transaction: null, idPedido, cancellationToken);
        }
        catch
        {
            await transaction.RollbackAsync(cancellationToken);
            throw;
        }
    }

    public async Task<TiendaAdminCatalogosDto> GetAdminCatalogosAsync(CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        var vendedores = new List<CatalogItemDto>();
        using (var vendedoresCommand = new SqlCommand(
                   """
                   SELECT DISTINCT A.IdAlumno, A.Codigo, A.Nombre
                   FROM Alumnos A
                   INNER JOIN AlumnosTrabajos AT ON AT.IdAlumno = A.IdAlumno
                   WHERE A.Activo = 1
                     AND AT.IdTrabajo IN (1, 2, 3, 4)
                   ORDER BY A.Nombre
                   """,
                   connection))
        using (var reader = await vendedoresCommand.ExecuteReaderAsync(cancellationToken))
        {
            while (await reader.ReadAsync(cancellationToken))
            {
                vendedores.Add(new CatalogItemDto
                {
                    Id = GetRequiredInt(reader, "IdAlumno"),
                    Nombre = $"{GetString(reader, "Codigo")} - {GetString(reader, "Nombre")}"
                });
            }
        }

        return new TiendaAdminCatalogosDto
        {
            Vendedores = vendedores,
            Estados =
            [
                new CatalogItemDto { Id = EstadoPendiente, Nombre = "Pendiente" },
                new CatalogItemDto { Id = EstadoPagado, Nombre = "Pagado" },
                new CatalogItemDto { Id = EstadoEntregado, Nombre = "Entregado" },
                new CatalogItemDto { Id = EstadoCancelado, Nombre = "Cancelado" }
            ]
        };
    }

    public async Task<PagedResult<TiendaPedidoDto>> GetHistorialAdminAsync(
        TiendaHistorialAdminQuery query,
        CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        var pagina = query.Pagina <= 0 ? 1 : query.Pagina;
        var registrosPorPagina = query.RegistrosPorPagina <= 0 ? 10 : query.RegistrosPorPagina;

        var filters = new List<string>();
        if (!string.IsNullOrWhiteSpace(query.Codigo))
        {
            filters.Add("AC.Codigo = @CodigoFiltro");
        }

        if (query.IdVendedor.HasValue)
        {
            filters.Add("P.IdVendedor = @IdVendedorFiltro");
        }

        if (query.Estado.HasValue)
        {
            filters.Add("P.IdEstado = @EstadoFiltro");
        }

        var where = filters.Count == 0 ? string.Empty : $"WHERE {string.Join(" AND ", filters)}";
        var totalRegistros = await CountPedidosAsync(
            connection,
            where,
            command =>
            {
                if (!string.IsNullOrWhiteSpace(query.Codigo))
                {
                    command.Parameters.AddWithValue("@CodigoFiltro", query.Codigo.Trim());
                }

                if (query.IdVendedor.HasValue)
                {
                    command.Parameters.AddWithValue("@IdVendedorFiltro", query.IdVendedor.Value);
                }

                if (query.Estado.HasValue)
                {
                    command.Parameters.AddWithValue("@EstadoFiltro", query.Estado.Value);
                }
            },
            cancellationToken);

        using var command = CreatePedidoProjectionCommand(connection, transaction: null, where);
        if (!string.IsNullOrWhiteSpace(query.Codigo))
        {
            command.Parameters.AddWithValue("@CodigoFiltro", query.Codigo.Trim());
        }

        if (query.IdVendedor.HasValue)
        {
            command.Parameters.AddWithValue("@IdVendedorFiltro", query.IdVendedor.Value);
        }

        if (query.Estado.HasValue)
        {
            command.Parameters.AddWithValue("@EstadoFiltro", query.Estado.Value);
        }

        command.CommandText += " ORDER BY P.FechaPedido DESC, P.IdPedido DESC OFFSET @Offset ROWS FETCH NEXT @Fetch ROWS ONLY";
        command.Parameters.AddWithValue("@Offset", (pagina - 1) * registrosPorPagina);
        command.Parameters.AddWithValue("@Fetch", registrosPorPagina);

        var items = await ReadPedidosAsync(command, cancellationToken);
        return new PagedResult<TiendaPedidoDto>
        {
            Items = items,
            TotalRegistros = totalRegistros,
            PaginaActual = pagina,
            RegistrosPorPagina = registrosPorPagina
        };
    }

    public async Task<TiendaPedidoDto?> CambiarEstadoAdminAsync(
        int idPedido,
        int idAlumno,
        UpdateTiendaPedidoEstadoRequest request,
        CancellationToken cancellationToken)
    {
        if (request.NuevoEstado is < EstadoPendiente or > EstadoCancelado)
        {
            throw new BusinessRuleException("El estado solicitado no es valido.");
        }

        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);
        await using var transaction = await connection.BeginTransactionAsync(cancellationToken);

        var pedido = await GetPedidoEstadoContextAsync(connection, (SqlTransaction)transaction, idPedido, cancellationToken);
        if (pedido is null)
        {
            return null;
        }

        try
        {
            using (var command = new SqlCommand(
                       "UPDATE Pedidos SET IdEstado = @NuevoEstado WHERE IdPedido = @IdPedido",
                       connection,
                       (SqlTransaction)transaction))
            {
                command.Parameters.AddWithValue("@NuevoEstado", request.NuevoEstado);
                command.Parameters.AddWithValue("@IdPedido", idPedido);
                await command.ExecuteNonQueryAsync(cancellationToken);
            }

            await InsertHistorialEstadoAsync(
                connection,
                (SqlTransaction)transaction,
                idPedido,
                request.NuevoEstado,
                idAlumno,
                request.Observacion,
                cancellationToken);

            await transaction.CommitAsync(cancellationToken);
            return await GetPedidoByIdInternalAsync(connection, transaction: null, idPedido, cancellationToken);
        }
        catch
        {
            await transaction.RollbackAsync(cancellationToken);
            throw;
        }
    }

    private static bool CanAccessPedido(TiendaPedidoDto pedido, int idAlumno, bool canAdmin) =>
        canAdmin ||
        pedido.IdComprador == idAlumno ||
        pedido.IdDestinatario == idAlumno ||
        pedido.IdVendedor == idAlumno;

    private static async Task<int> CountPedidosAsync(
        SqlConnection connection,
        string whereClause,
        Action<SqlCommand> parameterBuilder,
        CancellationToken cancellationToken)
    {
        using var command = new SqlCommand(
            $"""
            SELECT COUNT(*)
            FROM Pedidos P
            INNER JOIN EstadosPedido E ON E.IdEstado = P.IdEstado
            INNER JOIN DetallePedidos DP ON DP.IdPedido = P.IdPedido
            INNER JOIN Productos Pr ON Pr.IdProducto = DP.IdProducto
            INNER JOIN Alumnos AC ON AC.IdAlumno = P.IdComprador
            LEFT JOIN Alumnos AD ON AD.IdAlumno = P.IdDestinatario
            LEFT JOIN Alumnos AV ON AV.IdAlumno = P.IdVendedor
            {whereClause}
            """,
            connection);
        parameterBuilder(command);
        return Convert.ToInt32(await command.ExecuteScalarAsync(cancellationToken), CultureInfo.InvariantCulture);
    }

    private static async Task<IReadOnlyCollection<TiendaPedidoDto>> ReadPedidosAsync(
        SqlCommand command,
        CancellationToken cancellationToken)
    {
        var items = new List<TiendaPedidoDto>();
        using var reader = await command.ExecuteReaderAsync(cancellationToken);
        while (await reader.ReadAsync(cancellationToken))
        {
            var fechaPedido = GetDateTime(reader, "FechaPedido");
            var estado = GetString(reader, "Estado");
            items.Add(new TiendaPedidoDto
            {
                IdPedido = GetRequiredInt(reader, "IdPedido"),
                FechaPedido = fechaPedido,
                Total = GetDecimal(reader, "Total"),
                IdEstado = GetRequiredInt(reader, "IdEstado"),
                Estado = estado,
                IdComprador = GetRequiredInt(reader, "IdComprador"),
                CodigoComprador = GetString(reader, "CodigoComprador"),
                NombreComprador = GetString(reader, "NombreComprador"),
                IdDestinatario = GetNullableInt(reader, "IdDestinatario"),
                CodigoDestinatario = GetString(reader, "CodigoDestinatario"),
                NombreDestinatario = GetString(reader, "NombreDestinatario"),
                IdVendedor = GetNullableInt(reader, "IdVendedor"),
                NombreVendedor = GetString(reader, "NombreVendedor"),
                Producto = GetString(reader, "Producto"),
                Imagen = GetString(reader, "Imagen"),
                Comentario = GetString(reader, "Comentario"),
                PuedeCancelar = string.Equals(estado, "Pendiente", StringComparison.OrdinalIgnoreCase) &&
                                (DateTime.Now - fechaPedido).TotalDays >= 7
            });
        }

        return items;
    }

    private static SqlCommand CreatePedidoProjectionCommand(
        SqlConnection connection,
        SqlTransaction? transaction,
        string whereAndOrderClause)
    {
        return new SqlCommand(
            $"""
            SELECT
                P.IdPedido,
                P.FechaPedido,
                P.Total,
                P.IdEstado,
                E.Nombre AS Estado,
                P.IdComprador,
                AC.Codigo AS CodigoComprador,
                AC.Nombre AS NombreComprador,
                P.IdDestinatario,
                AD.Codigo AS CodigoDestinatario,
                AD.Nombre AS NombreDestinatario,
                P.IdVendedor,
                AV.Nombre AS NombreVendedor,
                Pr.Nombre AS Producto,
                Pr.Imagen,
                P.Comentario
            FROM Pedidos P
            INNER JOIN EstadosPedido E ON E.IdEstado = P.IdEstado
            INNER JOIN DetallePedidos DP ON DP.IdPedido = P.IdPedido
            INNER JOIN Productos Pr ON Pr.IdProducto = DP.IdProducto
            INNER JOIN Alumnos AC ON AC.IdAlumno = P.IdComprador
            LEFT JOIN Alumnos AD ON AD.IdAlumno = P.IdDestinatario
            LEFT JOIN Alumnos AV ON AV.IdAlumno = P.IdVendedor
            {whereAndOrderClause}
            """,
            connection,
            transaction);
    }

    private static async Task<int> CountAsync(
        SqlConnection connection,
        string sql,
        CancellationToken cancellationToken)
    {
        using var command = new SqlCommand(sql, connection);
        return Convert.ToInt32(await command.ExecuteScalarAsync(cancellationToken), CultureInfo.InvariantCulture);
    }

    private static async Task<TiendaPedidoDto?> GetPedidoByIdInternalAsync(
        SqlConnection connection,
        SqlTransaction? transaction,
        int idPedido,
        CancellationToken cancellationToken)
    {
        using var command = CreatePedidoProjectionCommand(
            connection,
            transaction,
            "WHERE P.IdPedido = @IdPedido");
        command.Parameters.AddWithValue("@IdPedido", idPedido);

        var items = await ReadPedidosAsync(command, cancellationToken);
        return items.FirstOrDefault();
    }

    private static async Task<TiendaComprobanteDto?> GetComprobanteInternalAsync(
        SqlConnection connection,
        SqlTransaction? transaction,
        int idPedido,
        CancellationToken cancellationToken)
    {
        using var command = new SqlCommand(
            """
            SELECT
                P.IdPedido,
                P.FechaPedido,
                P.Total,
                E.Nombre AS Estado,
                P.Comentario,
                Pr.Nombre AS Producto,
                Pr.Imagen,
                Pr.Precio,
                AC.Nombre AS Comprador,
                AD.Nombre AS Destinatario
            FROM Pedidos P
            INNER JOIN EstadosPedido E ON E.IdEstado = P.IdEstado
            INNER JOIN DetallePedidos DP ON DP.IdPedido = P.IdPedido
            INNER JOIN Productos Pr ON Pr.IdProducto = DP.IdProducto
            INNER JOIN Alumnos AC ON AC.IdAlumno = P.IdComprador
            LEFT JOIN Alumnos AD ON AD.IdAlumno = P.IdDestinatario
            WHERE P.IdPedido = @IdPedido
            """,
            connection,
            transaction);
        command.Parameters.AddWithValue("@IdPedido", idPedido);

        using var reader = await command.ExecuteReaderAsync(cancellationToken);
        if (!await reader.ReadAsync(cancellationToken))
        {
            return null;
        }

        return new TiendaComprobanteDto
        {
            IdPedido = GetRequiredInt(reader, "IdPedido"),
            FechaPedido = GetDateTime(reader, "FechaPedido"),
            Total = GetDecimal(reader, "Total"),
            Producto = GetString(reader, "Producto"),
            Imagen = GetString(reader, "Imagen"),
            Precio = GetDecimal(reader, "Precio"),
            Comprador = GetString(reader, "Comprador"),
            Destinatario = GetString(reader, "Destinatario"),
            Estado = GetString(reader, "Estado"),
            Comentario = GetString(reader, "Comentario")
        };
    }

    private static async Task<PedidoEstadoContext?> GetPedidoEstadoContextAsync(
        SqlConnection connection,
        SqlTransaction? transaction,
        int idPedido,
        CancellationToken cancellationToken)
    {
        using var command = new SqlCommand(
            """
            SELECT
                IdPedido,
                IdComprador,
                IdVendedor,
                FechaPedido,
                IdEstado,
                Total
            FROM Pedidos
            WHERE IdPedido = @IdPedido
            """,
            connection,
            transaction);
        command.Parameters.AddWithValue("@IdPedido", idPedido);

        using var reader = await command.ExecuteReaderAsync(cancellationToken);
        if (!await reader.ReadAsync(cancellationToken))
        {
            return null;
        }

        return new PedidoEstadoContext
        {
            IdPedido = GetRequiredInt(reader, "IdPedido"),
            IdComprador = GetRequiredInt(reader, "IdComprador"),
            IdVendedor = GetNullableInt(reader, "IdVendedor"),
            FechaPedido = GetDateTime(reader, "FechaPedido"),
            IdEstado = GetRequiredInt(reader, "IdEstado"),
            Total = GetDecimal(reader, "Total")
        };
    }

    private static async Task<TiendaProductoDto?> GetProductoActivoAsync(
        SqlConnection connection,
        SqlTransaction? transaction,
        int idProducto,
        CancellationToken cancellationToken)
    {
        using var command = new SqlCommand(
            """
            SELECT IdProducto, Nombre, Descripcion, Precio, Imagen, Activo
            FROM Productos
            WHERE IdProducto = @IdProducto
              AND Activo = 1
            """,
            connection,
            transaction);
        command.Parameters.AddWithValue("@IdProducto", idProducto);

        using var reader = await command.ExecuteReaderAsync(cancellationToken);
        return await reader.ReadAsync(cancellationToken) ? MapProducto(reader) : null;
    }

    private static async Task<AlumnoContext?> GetAlumnoAsync(
        SqlConnection connection,
        SqlTransaction? transaction,
        int idAlumno,
        CancellationToken cancellationToken)
    {
        using var command = new SqlCommand(
            """
            SELECT TOP 1 IdAlumno, Codigo, Nombre, Dracoins
            FROM Alumnos
            WHERE IdAlumno = @IdAlumno
              AND Activo = 1
            """,
            connection,
            transaction);
        command.Parameters.AddWithValue("@IdAlumno", idAlumno);

        using var reader = await command.ExecuteReaderAsync(cancellationToken);
        if (!await reader.ReadAsync(cancellationToken))
        {
            return null;
        }

        return new AlumnoContext
        {
            IdAlumno = GetRequiredInt(reader, "IdAlumno"),
            Codigo = GetString(reader, "Codigo"),
            Nombre = GetString(reader, "Nombre"),
            Dracoins = GetDecimal(reader, "Dracoins")
        };
    }

    private static async Task InsertHistorialEstadoAsync(
        SqlConnection connection,
        SqlTransaction transaction,
        int idPedido,
        int idEstado,
        int usuarioCambio,
        string? observacion,
        CancellationToken cancellationToken)
    {
        using var command = new SqlCommand(
            """
            INSERT INTO HistorialEstadosPedido
            (IdPedido, IdEstado, FechaCambio, UsuarioCambio, Observacion)
            VALUES (@IdPedido, @IdEstado, @FechaCambio, @UsuarioCambio, @Observacion)
            """,
            connection,
            transaction);
        command.Parameters.AddWithValue("@IdPedido", idPedido);
        command.Parameters.AddWithValue("@IdEstado", idEstado);
        command.Parameters.AddWithValue("@FechaCambio", DateTime.Now);
        command.Parameters.AddWithValue("@UsuarioCambio", usuarioCambio);
        command.Parameters.AddWithValue(
            "@Observacion",
            string.IsNullOrWhiteSpace(observacion) ? DBNull.Value : observacion.Trim());
        await command.ExecuteNonQueryAsync(cancellationToken);
    }

    private static TiendaProductoDto MapProducto(SqlDataReader reader) =>
        new()
        {
            IdProducto = GetRequiredInt(reader, "IdProducto"),
            Nombre = GetString(reader, "Nombre"),
            Descripcion = GetString(reader, "Descripcion"),
            Precio = GetDecimal(reader, "Precio"),
            Imagen = GetString(reader, "Imagen"),
            Activo = GetBoolean(reader, "Activo")
        };

    private static string GetString(SqlDataReader reader, string columnName) =>
        reader[columnName] == DBNull.Value ? string.Empty : reader[columnName]?.ToString() ?? string.Empty;

    private static int GetRequiredInt(SqlDataReader reader, string columnName) =>
        Convert.ToInt32(reader[columnName], CultureInfo.InvariantCulture);

    private static int? GetNullableInt(SqlDataReader reader, string columnName) =>
        reader[columnName] == DBNull.Value
            ? null
            : Convert.ToInt32(reader[columnName], CultureInfo.InvariantCulture);

    private static decimal GetDecimal(SqlDataReader reader, string columnName) =>
        reader[columnName] == DBNull.Value
            ? 0m
            : Convert.ToDecimal(reader[columnName], CultureInfo.InvariantCulture);

    private static bool GetBoolean(SqlDataReader reader, string columnName) =>
        reader[columnName] != DBNull.Value && Convert.ToBoolean(reader[columnName], CultureInfo.InvariantCulture);

    private static DateTime GetDateTime(SqlDataReader reader, string columnName) =>
        Convert.ToDateTime(reader[columnName], CultureInfo.InvariantCulture);

    private sealed class AlumnoContext
    {
        public int IdAlumno { get; init; }

        public string Codigo { get; init; } = string.Empty;

        public string Nombre { get; init; } = string.Empty;

        public decimal Dracoins { get; init; }
    }

    private sealed class PedidoEstadoContext
    {
        public int IdPedido { get; init; }

        public int IdComprador { get; init; }

        public int? IdVendedor { get; init; }

        public DateTime FechaPedido { get; init; }

        public int IdEstado { get; init; }

        public decimal Total { get; init; }
    }
}
