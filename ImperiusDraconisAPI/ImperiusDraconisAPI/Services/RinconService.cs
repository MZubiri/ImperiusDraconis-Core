using System.Globalization;
using ImperiusDraconisAPI.Common;
using ImperiusDraconisAPI.Data;
using ImperiusDraconisAPI.Models.Rincon;
using Microsoft.Data.SqlClient;

namespace ImperiusDraconisAPI.Services;

public sealed class RinconService
{
    private const int AdminAlumnoId = 3;
    private const int EstadoPendiente = 1;
    private const int EstadoEntregado = 2;
    private const int EstadoCancelado = 4;

    private readonly SqlConnectionFactory _connectionFactory;
    private readonly LegacyAssetStorage _assetStorage;

    public RinconService(SqlConnectionFactory connectionFactory, LegacyAssetStorage assetStorage)
    {
        _connectionFactory = connectionFactory;
        _assetStorage = assetStorage;
    }

    public bool IsAdmin(int idAlumno) => idAlumno == AdminAlumnoId;

    public async Task<IReadOnlyCollection<RinconProductoDto>> GetCatalogAsync(
        RinconProductoQuery query,
        CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        var filters = new List<string>();
        using var command = new SqlCommand { Connection = connection };

        if (!string.IsNullOrWhiteSpace(query.Categoria))
        {
            filters.Add("Categoria = @Categoria");
            command.Parameters.AddWithValue("@Categoria", query.Categoria.Trim());
        }

        if (query.SoloDisponibles == true)
        {
            filters.Add("Stock > 0");
        }

        command.CommandText =
            $"""
            SELECT IdProducto, Nombre, Descripcion, Precio, Stock, ImagenUrl, Categoria, FechaRegistro
            FROM ProductosRincon
            {(filters.Count == 0 ? string.Empty : $"WHERE {string.Join(" AND ", filters)}")}
            ORDER BY Categoria, Nombre
            """;

        var items = new List<RinconProductoDto>();
        using var reader = await command.ExecuteReaderAsync(cancellationToken);
        while (await reader.ReadAsync(cancellationToken))
        {
            items.Add(MapProducto(reader));
        }

        return items;
    }

    public async Task<RinconProductoDto?> GetByIdAsync(int idProducto, CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);
        return await GetProductoByIdInternalAsync(connection, transaction: null, idProducto, cancellationToken);
    }

    public async Task<RinconPedidoDto> CreatePedidoAsync(
        int idAlumno,
        CreateRinconPedidoRequest request,
        CancellationToken cancellationToken)
    {
        var items = request.Items
            .Where(item => item.IdProducto > 0 && item.Cantidad > 0)
            .GroupBy(item => item.IdProducto)
            .Select(group => new CreateRinconPedidoItemRequest
            {
                IdProducto = group.Key,
                Cantidad = group.Sum(item => item.Cantidad)
            })
            .ToArray();

        if (items.Length == 0)
        {
            throw new BusinessRuleException("Debes seleccionar al menos un producto del Rincon.");
        }

        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        var alumno = await GetAlumnoAsync(connection, transaction: null, idAlumno, cancellationToken)
            ?? throw new BusinessRuleException("No se encontro al alumno actual.");

        var productos = await GetProductosByIdsAsync(
            connection,
            transaction: null,
            items.Select(item => item.IdProducto),
            cancellationToken);

        if (productos.Count != items.Length)
        {
            throw new BusinessRuleException("Uno o mas productos seleccionados ya no existen.");
        }

        decimal total = 0m;
        foreach (var item in items)
        {
            var producto = productos[item.IdProducto];
            if (producto.Stock < item.Cantidad)
            {
                throw new BusinessRuleException($"Stock insuficiente para {producto.Nombre}.");
            }

            total += producto.Precio * item.Cantidad;
        }

        if (alumno.Dracoins < total)
        {
            throw new BusinessRuleException("No tienes suficientes Dracoins para completar esta compra.");
        }

        await using var transaction = await connection.BeginTransactionAsync(cancellationToken);

        try
        {
            int idPedido;
            using (var insertPedidoCommand = new SqlCommand(
                       """
                       INSERT INTO PedidosRincon (IdAlumno, FechaPedido, Total, Estado)
                       VALUES (@IdAlumno, @FechaPedido, @Total, @Estado);
                       SELECT CAST(SCOPE_IDENTITY() AS int);
                       """,
                       connection,
                       (SqlTransaction)transaction))
            {
                insertPedidoCommand.Parameters.AddWithValue("@IdAlumno", idAlumno);
                insertPedidoCommand.Parameters.AddWithValue("@FechaPedido", DateTime.Now);
                insertPedidoCommand.Parameters.AddWithValue("@Total", total);
                insertPedidoCommand.Parameters.AddWithValue("@Estado", EstadoPendiente);
                idPedido = Convert.ToInt32(
                    await insertPedidoCommand.ExecuteScalarAsync(cancellationToken),
                    CultureInfo.InvariantCulture);
            }

            foreach (var item in items)
            {
                var producto = productos[item.IdProducto];

                using (var insertDetalleCommand = new SqlCommand(
                           """
                           INSERT INTO DetallesPedidoRincon
                           (IdPedido, IdProducto, Cantidad, PrecioUnitario)
                           VALUES (@IdPedido, @IdProducto, @Cantidad, @PrecioUnitario)
                           """,
                           connection,
                           (SqlTransaction)transaction))
                {
                    insertDetalleCommand.Parameters.AddWithValue("@IdPedido", idPedido);
                    insertDetalleCommand.Parameters.AddWithValue("@IdProducto", item.IdProducto);
                    insertDetalleCommand.Parameters.AddWithValue("@Cantidad", item.Cantidad);
                    insertDetalleCommand.Parameters.AddWithValue("@PrecioUnitario", producto.Precio);
                    await insertDetalleCommand.ExecuteNonQueryAsync(cancellationToken);
                }

                using (var stockCommand = new SqlCommand(
                           """
                           UPDATE ProductosRincon
                           SET Stock = Stock - @Cantidad
                           WHERE IdProducto = @IdProducto
                             AND Stock >= @Cantidad
                           """,
                           connection,
                           (SqlTransaction)transaction))
                {
                    stockCommand.Parameters.AddWithValue("@Cantidad", item.Cantidad);
                    stockCommand.Parameters.AddWithValue("@IdProducto", item.IdProducto);
                    if (await stockCommand.ExecuteNonQueryAsync(cancellationToken) == 0)
                    {
                        throw new BusinessRuleException($"No se pudo reservar stock para {producto.Nombre}.");
                    }
                }
            }

            using (var discountCommand = new SqlCommand(
                       "UPDATE Alumnos SET Dracoins = Dracoins - @Monto WHERE IdAlumno = @IdAlumno",
                       connection,
                       (SqlTransaction)transaction))
            {
                discountCommand.Parameters.AddWithValue("@Monto", total);
                discountCommand.Parameters.AddWithValue("@IdAlumno", idAlumno);
                await discountCommand.ExecuteNonQueryAsync(cancellationToken);
            }

            using (var commissionCommand = new SqlCommand(
                       "UPDATE Alumnos SET Dracoins = Dracoins + @Monto WHERE IdAlumno = @IdAdmin",
                       connection,
                       (SqlTransaction)transaction))
            {
                commissionCommand.Parameters.AddWithValue("@Monto", Math.Round(total / 2m, 2, MidpointRounding.AwayFromZero));
                commissionCommand.Parameters.AddWithValue("@IdAdmin", AdminAlumnoId);
                await commissionCommand.ExecuteNonQueryAsync(cancellationToken);
            }

            await transaction.CommitAsync(cancellationToken);
            return await GetPedidoByIdInternalAsync(connection, transaction: null, idPedido, cancellationToken)
                ?? throw new InvalidOperationException("No se pudo recuperar el pedido generado.");
        }
        catch
        {
            await transaction.RollbackAsync(cancellationToken);
            throw;
        }
    }

    public async Task<IReadOnlyCollection<RinconPedidoDto>> GetHistorialAsync(
        int idAlumno,
        CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        using var command = new SqlCommand(
            """
            SELECT P.IdPedido, P.IdAlumno, A.Nombre AS NombreAlumno, P.FechaPedido, P.Total, P.Estado
            FROM PedidosRincon P
            INNER JOIN Alumnos A ON A.IdAlumno = P.IdAlumno
            WHERE P.IdAlumno = @IdAlumno
            ORDER BY P.FechaPedido DESC, P.IdPedido DESC
            """,
            connection);
        command.Parameters.AddWithValue("@IdAlumno", idAlumno);

        return await ReadPedidoSummariesAsync(command, cancellationToken);
    }

    public async Task<RinconPedidoDto?> GetComprobanteAsync(
        int idPedido,
        int idAlumno,
        bool isAdmin,
        CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        var pedido = await GetPedidoByIdInternalAsync(connection, transaction: null, idPedido, cancellationToken);
        if (pedido is null)
        {
            return null;
        }

        if (!isAdmin && pedido.IdAlumno != idAlumno)
        {
            return null;
        }

        return pedido;
    }

    public async Task<RinconPedidoDto?> CancelarPedidoAsync(
        int idPedido,
        int idAlumnoSolicitante,
        bool isAdmin,
        CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);
        await using var transaction = await connection.BeginTransactionAsync(cancellationToken);

        try
        {
            var pedido = await GetPedidoByIdInternalAsync(
                connection,
                (SqlTransaction)transaction,
                idPedido,
                cancellationToken);

            if (pedido is null)
            {
                await transaction.RollbackAsync(cancellationToken);
                return null;
            }

            if (!isAdmin && pedido.IdAlumno != idAlumnoSolicitante)
            {
                throw new BusinessRuleException("Solo el comprador o un administrador puede cancelar este pedido.");
            }

            if (pedido.Estado != EstadoPendiente)
            {
                throw new BusinessRuleException("Solo se pueden cancelar pedidos pendientes.");
            }

            using (var updateStatusCommand = new SqlCommand(
                       """
                       UPDATE PedidosRincon
                       SET Estado = @EstadoCancelado
                       WHERE IdPedido = @IdPedido
                         AND Estado = @EstadoPendiente
                       """,
                       connection,
                       (SqlTransaction)transaction))
            {
                updateStatusCommand.Parameters.AddWithValue("@EstadoCancelado", EstadoCancelado);
                updateStatusCommand.Parameters.AddWithValue("@IdPedido", idPedido);
                updateStatusCommand.Parameters.AddWithValue("@EstadoPendiente", EstadoPendiente);

                if (await updateStatusCommand.ExecuteNonQueryAsync(cancellationToken) == 0)
                {
                    throw new BusinessRuleException("No se pudo cancelar el pedido.");
                }
            }

            using (var restoreStockCommand = new SqlCommand(
                       """
                       UPDATE PR
                       SET PR.Stock = PR.Stock + D.Cantidad
                       FROM ProductosRincon PR
                       INNER JOIN DetallesPedidoRincon D ON D.IdProducto = PR.IdProducto
                       WHERE D.IdPedido = @IdPedido
                       """,
                       connection,
                       (SqlTransaction)transaction))
            {
                restoreStockCommand.Parameters.AddWithValue("@IdPedido", idPedido);
                await restoreStockCommand.ExecuteNonQueryAsync(cancellationToken);
            }

            using (var refundCommand = new SqlCommand(
                       "UPDATE Alumnos SET Dracoins = Dracoins + @Monto WHERE IdAlumno = @IdAlumno",
                       connection,
                       (SqlTransaction)transaction))
            {
                refundCommand.Parameters.AddWithValue("@Monto", pedido.Total);
                refundCommand.Parameters.AddWithValue("@IdAlumno", pedido.IdAlumno);
                await refundCommand.ExecuteNonQueryAsync(cancellationToken);
            }

            using (var reverseCommissionCommand = new SqlCommand(
                       "UPDATE Alumnos SET Dracoins = Dracoins - @Monto WHERE IdAlumno = @IdAdmin",
                       connection,
                       (SqlTransaction)transaction))
            {
                reverseCommissionCommand.Parameters.AddWithValue(
                    "@Monto",
                    Math.Round(pedido.Total / 2m, 2, MidpointRounding.AwayFromZero));
                reverseCommissionCommand.Parameters.AddWithValue("@IdAdmin", AdminAlumnoId);
                await reverseCommissionCommand.ExecuteNonQueryAsync(cancellationToken);
            }

            await transaction.CommitAsync(cancellationToken);

            return await GetPedidoByIdInternalAsync(connection, transaction: null, idPedido, cancellationToken);
        }
        catch
        {
            await transaction.RollbackAsync(cancellationToken);
            throw;
        }
    }

    public async Task<RinconResumenAdminDto> GetResumenAdminAsync(CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        return new RinconResumenAdminDto
        {
            TotalProductos = await CountAsync(connection, "SELECT COUNT(*) FROM ProductosRincon", cancellationToken),
            ProductosSinStock = await CountAsync(connection, "SELECT COUNT(*) FROM ProductosRincon WHERE Stock <= 0", cancellationToken),
            PedidosPendientes = await CountAsync(connection, "SELECT COUNT(*) FROM PedidosRincon WHERE Estado = 1", cancellationToken),
            PedidosEntregados = await CountAsync(connection, "SELECT COUNT(*) FROM PedidosRincon WHERE Estado = 2", cancellationToken)
        };
    }

    public async Task<RinconProductoDto> CreateProductoAsync(
        SaveRinconProductoRequest request,
        CancellationToken cancellationToken)
    {
        var normalized = await NormalizeProductoAsync(request, existing: null, cancellationToken);

        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        int idProducto;
        using (var command = new SqlCommand(
                   """
                   INSERT INTO ProductosRincon
                   (Nombre, Descripcion, Precio, Stock, ImagenUrl, Categoria, FechaRegistro)
                   VALUES (@Nombre, @Descripcion, @Precio, @Stock, @ImagenUrl, @Categoria, @FechaRegistro);
                   SELECT CAST(SCOPE_IDENTITY() AS int);
                   """,
                   connection))
        {
            command.Parameters.AddWithValue("@Nombre", normalized.Nombre);
            command.Parameters.AddWithValue("@Descripcion", (object?)normalized.Descripcion ?? DBNull.Value);
            command.Parameters.AddWithValue("@Precio", normalized.Precio);
            command.Parameters.AddWithValue("@Stock", normalized.Stock);
            command.Parameters.AddWithValue("@ImagenUrl", (object?)normalized.ImagenUrl ?? DBNull.Value);
            command.Parameters.AddWithValue("@Categoria", (object?)normalized.Categoria ?? DBNull.Value);
            command.Parameters.AddWithValue("@FechaRegistro", DateTime.Now);
            idProducto = Convert.ToInt32(
                await command.ExecuteScalarAsync(cancellationToken),
                CultureInfo.InvariantCulture);
        }

        return await GetProductoByIdInternalAsync(connection, transaction: null, idProducto, cancellationToken)
            ?? throw new InvalidOperationException("No se pudo recuperar el producto creado.");
    }

    public async Task<bool> UpdateProductoAsync(
        int idProducto,
        SaveRinconProductoRequest request,
        CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        var existing = await GetProductoByIdInternalAsync(connection, transaction: null, idProducto, cancellationToken);
        if (existing is null)
        {
            return false;
        }

        var normalized = await NormalizeProductoAsync(request, existing, cancellationToken);

        using var command = new SqlCommand(
            """
            UPDATE ProductosRincon
            SET Nombre = @Nombre,
                Descripcion = @Descripcion,
                Precio = @Precio,
                Stock = @Stock,
                ImagenUrl = @ImagenUrl,
                Categoria = @Categoria
            WHERE IdProducto = @IdProducto
            """,
            connection);
        command.Parameters.AddWithValue("@IdProducto", idProducto);
        command.Parameters.AddWithValue("@Nombre", normalized.Nombre);
        command.Parameters.AddWithValue("@Descripcion", (object?)normalized.Descripcion ?? DBNull.Value);
        command.Parameters.AddWithValue("@Precio", normalized.Precio);
        command.Parameters.AddWithValue("@Stock", normalized.Stock);
        command.Parameters.AddWithValue("@ImagenUrl", (object?)normalized.ImagenUrl ?? DBNull.Value);
        command.Parameters.AddWithValue("@Categoria", (object?)normalized.Categoria ?? DBNull.Value);

        return await command.ExecuteNonQueryAsync(cancellationToken) > 0;
    }

    public async Task<bool> DeleteProductoAsync(int idProducto, CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        try
        {
            using var command = new SqlCommand(
                "DELETE FROM ProductosRincon WHERE IdProducto = @IdProducto",
                connection);
            command.Parameters.AddWithValue("@IdProducto", idProducto);
            return await command.ExecuteNonQueryAsync(cancellationToken) > 0;
        }
        catch (SqlException)
        {
            throw new BusinessRuleException("No se puede eliminar el producto porque tiene pedidos asociados.");
        }
    }

    public async Task<IReadOnlyCollection<RinconPedidoDto>> GetPedidosPendientesAsync(CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        using var command = new SqlCommand(
            """
            SELECT P.IdPedido, P.IdAlumno, A.Nombre AS NombreAlumno, P.FechaPedido, P.Total, P.Estado
            FROM PedidosRincon P
            INNER JOIN Alumnos A ON A.IdAlumno = P.IdAlumno
            WHERE P.Estado = @Estado
            ORDER BY P.FechaPedido DESC, P.IdPedido DESC
            """,
            connection);
        command.Parameters.AddWithValue("@Estado", EstadoPendiente);

        return await ReadPedidoSummariesAsync(command, cancellationToken);
    }

    public async Task<RinconPedidoDto?> MarcarEntregadoAsync(int idPedido, CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        using (var command = new SqlCommand(
                   """
                   UPDATE PedidosRincon
                   SET Estado = @EstadoEntregado
                   WHERE IdPedido = @IdPedido
                     AND Estado = @EstadoPendiente
                   """,
                   connection))
        {
            command.Parameters.AddWithValue("@EstadoEntregado", EstadoEntregado);
            command.Parameters.AddWithValue("@IdPedido", idPedido);
            command.Parameters.AddWithValue("@EstadoPendiente", EstadoPendiente);
            var rows = await command.ExecuteNonQueryAsync(cancellationToken);
            if (rows == 0)
            {
                return null;
            }
        }

        return await GetPedidoByIdInternalAsync(connection, transaction: null, idPedido, cancellationToken);
    }

    public async Task<IReadOnlyCollection<RinconPedidoDto>> GetHistorialAdminAsync(
        int? estado,
        CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        using var command = new SqlCommand(
            $"""
            SELECT P.IdPedido, P.IdAlumno, A.Nombre AS NombreAlumno, P.FechaPedido, P.Total, P.Estado
            FROM PedidosRincon P
            INNER JOIN Alumnos A ON A.IdAlumno = P.IdAlumno
            {(estado.HasValue ? "WHERE P.Estado = @Estado" : string.Empty)}
            ORDER BY P.FechaPedido DESC, P.IdPedido DESC
            """,
            connection);
        if (estado.HasValue)
        {
            command.Parameters.AddWithValue("@Estado", estado.Value);
        }

        return await ReadPedidoSummariesAsync(command, cancellationToken);
    }

    private async Task<NormalizedProducto> NormalizeProductoAsync(
        SaveRinconProductoRequest request,
        RinconProductoDto? existing,
        CancellationToken cancellationToken)
    {
        var nombre = request.Nombre?.Trim() ?? string.Empty;
        if (string.IsNullOrWhiteSpace(nombre))
        {
            throw new BusinessRuleException("El nombre del producto es obligatorio.");
        }

        if (request.Precio < 0)
        {
            throw new BusinessRuleException("El precio no puede ser negativo.");
        }

        if (request.Stock < 0)
        {
            throw new BusinessRuleException("El stock no puede ser negativo.");
        }

        var imagenUrl = request.ImagenUrlActual?.Trim();
        if (string.IsNullOrWhiteSpace(imagenUrl))
        {
            imagenUrl = existing?.ImagenUrl;
        }

        if (request.ImagenFile is { Length: > 0 })
        {
            imagenUrl = await _assetStorage.SaveImageAsync(
                request.ImagenFile,
                Path.Combine("Content", "rincon"),
                cancellationToken);
        }

        return new NormalizedProducto
        {
            Nombre = nombre,
            Descripcion = NormalizeOptional(request.Descripcion, 4000),
            Precio = request.Precio,
            Stock = request.Stock,
            ImagenUrl = imagenUrl,
            Categoria = NormalizeOptional(request.Categoria, 200)
        };
    }

    private static async Task<IReadOnlyCollection<RinconPedidoDto>> ReadPedidoSummariesAsync(
        SqlCommand command,
        CancellationToken cancellationToken)
    {
        var items = new List<RinconPedidoDto>();
        using var reader = await command.ExecuteReaderAsync(cancellationToken);
        while (await reader.ReadAsync(cancellationToken))
        {
            items.Add(new RinconPedidoDto
            {
                IdPedido = GetRequiredInt(reader, "IdPedido"),
                IdAlumno = GetRequiredInt(reader, "IdAlumno"),
                NombreAlumno = GetString(reader, "NombreAlumno"),
                FechaPedido = GetDateTime(reader, "FechaPedido"),
                Total = GetDecimal(reader, "Total"),
                Estado = GetRequiredInt(reader, "Estado"),
                EstadoNombre = GetEstadoNombre(GetRequiredInt(reader, "Estado"))
            });
        }

        return items;
    }

    private static async Task<RinconPedidoDto?> GetPedidoByIdInternalAsync(
        SqlConnection connection,
        SqlTransaction? transaction,
        int idPedido,
        CancellationToken cancellationToken)
    {
        using var command = new SqlCommand(
            """
            SELECT P.IdPedido, P.IdAlumno, A.Nombre AS NombreAlumno, P.FechaPedido, P.Total, P.Estado
            FROM PedidosRincon P
            INNER JOIN Alumnos A ON A.IdAlumno = P.IdAlumno
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

        var pedido = new RinconPedidoDto
        {
            IdPedido = GetRequiredInt(reader, "IdPedido"),
            IdAlumno = GetRequiredInt(reader, "IdAlumno"),
            NombreAlumno = GetString(reader, "NombreAlumno"),
            FechaPedido = GetDateTime(reader, "FechaPedido"),
            Total = GetDecimal(reader, "Total"),
            Estado = GetRequiredInt(reader, "Estado"),
            EstadoNombre = GetEstadoNombre(GetRequiredInt(reader, "Estado"))
        };
        reader.Close();

        return new RinconPedidoDto
        {
            IdPedido = pedido.IdPedido,
            IdAlumno = pedido.IdAlumno,
            NombreAlumno = pedido.NombreAlumno,
            FechaPedido = pedido.FechaPedido,
            Total = pedido.Total,
            Estado = pedido.Estado,
            EstadoNombre = pedido.EstadoNombre,
            Detalles = await GetDetallesByPedidoAsync(connection, transaction, idPedido, cancellationToken)
        };
    }

    private static async Task<IReadOnlyCollection<RinconPedidoDetalleDto>> GetDetallesByPedidoAsync(
        SqlConnection connection,
        SqlTransaction? transaction,
        int idPedido,
        CancellationToken cancellationToken)
    {
        using var command = new SqlCommand(
            """
            SELECT D.IdProducto, P.Nombre, D.Cantidad, D.PrecioUnitario
            FROM DetallesPedidoRincon D
            INNER JOIN ProductosRincon P ON P.IdProducto = D.IdProducto
            WHERE D.IdPedido = @IdPedido
            ORDER BY D.IdDetalle
            """,
            connection,
            transaction);
        command.Parameters.AddWithValue("@IdPedido", idPedido);

        var items = new List<RinconPedidoDetalleDto>();
        using var reader = await command.ExecuteReaderAsync(cancellationToken);
        while (await reader.ReadAsync(cancellationToken))
        {
            var cantidad = GetRequiredInt(reader, "Cantidad");
            var precioUnitario = GetDecimal(reader, "PrecioUnitario");
            items.Add(new RinconPedidoDetalleDto
            {
                IdProducto = GetRequiredInt(reader, "IdProducto"),
                Nombre = GetString(reader, "Nombre"),
                Cantidad = cantidad,
                PrecioUnitario = precioUnitario,
                Subtotal = precioUnitario * cantidad
            });
        }

        return items;
    }

    private static async Task<RinconProductoDto?> GetProductoByIdInternalAsync(
        SqlConnection connection,
        SqlTransaction? transaction,
        int idProducto,
        CancellationToken cancellationToken)
    {
        using var command = new SqlCommand(
            """
            SELECT IdProducto, Nombre, Descripcion, Precio, Stock, ImagenUrl, Categoria, FechaRegistro
            FROM ProductosRincon
            WHERE IdProducto = @IdProducto
            """,
            connection,
            transaction);
        command.Parameters.AddWithValue("@IdProducto", idProducto);

        using var reader = await command.ExecuteReaderAsync(cancellationToken);
        return await reader.ReadAsync(cancellationToken) ? MapProducto(reader) : null;
    }

    private static async Task<Dictionary<int, RinconProductoDto>> GetProductosByIdsAsync(
        SqlConnection connection,
        SqlTransaction? transaction,
        IEnumerable<int> idsProducto,
        CancellationToken cancellationToken)
    {
        var ids = idsProducto
            .Where(id => id > 0)
            .Distinct()
            .ToArray();

        if (ids.Length == 0)
        {
            return new Dictionary<int, RinconProductoDto>();
        }

        var parameterNames = ids.Select((_, index) => $"@IdProducto{index}").ToArray();
        using var command = new SqlCommand(
            $"""
            SELECT IdProducto, Nombre, Descripcion, Precio, Stock, ImagenUrl, Categoria, FechaRegistro
            FROM ProductosRincon
            WHERE IdProducto IN ({string.Join(", ", parameterNames)})
            """,
            connection,
            transaction);

        for (var index = 0; index < ids.Length; index++)
        {
            command.Parameters.AddWithValue(parameterNames[index], ids[index]);
        }

        var items = new Dictionary<int, RinconProductoDto>();
        using var reader = await command.ExecuteReaderAsync(cancellationToken);
        while (await reader.ReadAsync(cancellationToken))
        {
            var producto = MapProducto(reader);
            items[producto.IdProducto] = producto;
        }

        return items;
    }

    private static async Task<AlumnoContext?> GetAlumnoAsync(
        SqlConnection connection,
        SqlTransaction? transaction,
        int idAlumno,
        CancellationToken cancellationToken)
    {
        using var command = new SqlCommand(
            """
            SELECT TOP 1 IdAlumno, Dracoins
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
            Dracoins = GetDecimal(reader, "Dracoins")
        };
    }

    private static async Task<int> CountAsync(
        SqlConnection connection,
        string sql,
        CancellationToken cancellationToken)
    {
        using var command = new SqlCommand(sql, connection);
        return Convert.ToInt32(await command.ExecuteScalarAsync(cancellationToken), CultureInfo.InvariantCulture);
    }

    private static RinconProductoDto MapProducto(SqlDataReader reader) =>
        new()
        {
            IdProducto = GetRequiredInt(reader, "IdProducto"),
            Nombre = GetString(reader, "Nombre"),
            Descripcion = GetString(reader, "Descripcion"),
            Precio = GetDecimal(reader, "Precio"),
            Stock = GetRequiredInt(reader, "Stock"),
            ImagenUrl = GetString(reader, "ImagenUrl"),
            Categoria = GetString(reader, "Categoria"),
            FechaRegistro = reader["FechaRegistro"] == DBNull.Value
                ? null
                : Convert.ToDateTime(reader["FechaRegistro"], CultureInfo.InvariantCulture)
        };

    private static string? NormalizeOptional(string? value, int maxLength)
    {
        var normalized = value?.Trim();
        if (string.IsNullOrWhiteSpace(normalized))
        {
            return null;
        }

        return normalized.Length <= maxLength ? normalized : normalized[..maxLength];
    }

    private static string GetEstadoNombre(int estado) => estado switch
    {
        EstadoEntregado => "Entregado",
        EstadoCancelado => "Cancelado",
        _ => "Pendiente"
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

    private sealed class AlumnoContext
    {
        public int IdAlumno { get; init; }

        public decimal Dracoins { get; init; }
    }

    private sealed class NormalizedProducto
    {
        public string Nombre { get; init; } = string.Empty;

        public string? Descripcion { get; init; }

        public decimal Precio { get; init; }

        public int Stock { get; init; }

        public string? ImagenUrl { get; init; }

        public string? Categoria { get; init; }
    }
}
