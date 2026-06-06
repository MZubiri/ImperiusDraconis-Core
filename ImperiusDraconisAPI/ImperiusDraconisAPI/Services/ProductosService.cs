using System.Globalization;
using ImperiusDraconisAPI.Common;
using ImperiusDraconisAPI.Data;
using ImperiusDraconisAPI.Models.Productos;
using Microsoft.Data.SqlClient;

namespace ImperiusDraconisAPI.Services;

public sealed class ProductosService
{
    private readonly SqlConnectionFactory _connectionFactory;
    private readonly LegacyAssetStorage _assetStorage;

    public ProductosService(SqlConnectionFactory connectionFactory, LegacyAssetStorage assetStorage)
    {
        _connectionFactory = connectionFactory;
        _assetStorage = assetStorage;
    }

    public async Task<IReadOnlyCollection<ProductoDto>> GetAsync(CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        var items = new List<ProductoDto>();
        using var command = new SqlCommand(
            """
            SELECT IdProducto, Nombre, Descripcion, Precio, Imagen, Activo
            FROM Productos
            ORDER BY Nombre
            """,
            connection);
        using var reader = await command.ExecuteReaderAsync(cancellationToken);
        while (await reader.ReadAsync(cancellationToken))
        {
            items.Add(MapProducto(reader));
        }

        return items;
    }

    public async Task<ProductoDto?> GetByIdAsync(int idProducto, CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);
        return await GetByIdInternalAsync(connection, transaction: null, idProducto, cancellationToken);
    }

    public async Task<ProductoDto> CreateAsync(SaveProductoRequest request, CancellationToken cancellationToken)
    {
        var normalized = await NormalizeAsync(request, existingProduct: null, cancellationToken);

        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        int idProducto;
        using (var command = new SqlCommand(
                   """
                   INSERT INTO Productos (Nombre, Descripcion, Precio, Imagen, Activo)
                   VALUES (@Nombre, @Descripcion, @Precio, @Imagen, @Activo);
                   SELECT CAST(SCOPE_IDENTITY() AS int);
                   """,
                   connection))
        {
            command.Parameters.AddWithValue("@Nombre", normalized.Nombre);
            command.Parameters.AddWithValue("@Descripcion", (object?)normalized.Descripcion ?? DBNull.Value);
            command.Parameters.AddWithValue("@Precio", normalized.Precio);
            command.Parameters.AddWithValue("@Imagen", (object?)normalized.Imagen ?? DBNull.Value);
            command.Parameters.AddWithValue("@Activo", normalized.Activo);

            idProducto = Convert.ToInt32(
                await command.ExecuteScalarAsync(cancellationToken),
                CultureInfo.InvariantCulture);
        }

        return await GetByIdInternalAsync(connection, transaction: null, idProducto, cancellationToken)
            ?? throw new InvalidOperationException("No se pudo recuperar el producto creado.");
    }

    public async Task<bool> UpdateAsync(
        int idProducto,
        SaveProductoRequest request,
        CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        var existing = await GetByIdInternalAsync(connection, transaction: null, idProducto, cancellationToken);
        if (existing is null)
        {
            return false;
        }

        var normalized = await NormalizeAsync(request, existing, cancellationToken);

        using var command = new SqlCommand(
            """
            UPDATE Productos
            SET Nombre = @Nombre,
                Descripcion = @Descripcion,
                Precio = @Precio,
                Imagen = @Imagen,
                Activo = @Activo
            WHERE IdProducto = @IdProducto
            """,
            connection);
        command.Parameters.AddWithValue("@IdProducto", idProducto);
        command.Parameters.AddWithValue("@Nombre", normalized.Nombre);
        command.Parameters.AddWithValue("@Descripcion", (object?)normalized.Descripcion ?? DBNull.Value);
        command.Parameters.AddWithValue("@Precio", normalized.Precio);
        command.Parameters.AddWithValue("@Imagen", (object?)normalized.Imagen ?? DBNull.Value);
        command.Parameters.AddWithValue("@Activo", normalized.Activo);

        return await command.ExecuteNonQueryAsync(cancellationToken) > 0;
    }

    public async Task<bool> DeleteAsync(int idProducto, CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        try
        {
            using var command = new SqlCommand(
                "DELETE FROM Productos WHERE IdProducto = @IdProducto",
                connection);
            command.Parameters.AddWithValue("@IdProducto", idProducto);
            return await command.ExecuteNonQueryAsync(cancellationToken) > 0;
        }
        catch (SqlException)
        {
            throw new BusinessRuleException(
                "No se puede eliminar el producto porque ya tiene pedidos asociados.");
        }
    }

    private async Task<NormalizedProducto> NormalizeAsync(
        SaveProductoRequest request,
        ProductoDto? existingProduct,
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

        var imagen = request.ImagenActual?.Trim();
        if (string.IsNullOrWhiteSpace(imagen))
        {
            imagen = existingProduct?.Imagen;
        }

        if (request.FotoArchivo is { Length: > 0 })
        {
            imagen = await _assetStorage.SaveImageAsync(
                request.FotoArchivo,
                Path.Combine("Content", "FotosTienda"),
                cancellationToken);
        }

        return new NormalizedProducto
        {
            Nombre = nombre,
            Descripcion = NormalizeOptional(request.Descripcion, 4000),
            Precio = request.Precio,
            Imagen = imagen,
            Activo = request.Activo
        };
    }

    private static string? NormalizeOptional(string? value, int maxLength)
    {
        var normalized = value?.Trim();
        if (string.IsNullOrWhiteSpace(normalized))
        {
            return null;
        }

        return normalized.Length <= maxLength ? normalized : normalized[..maxLength];
    }

    private static async Task<ProductoDto?> GetByIdInternalAsync(
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
            """,
            connection,
            transaction);
        command.Parameters.AddWithValue("@IdProducto", idProducto);

        using var reader = await command.ExecuteReaderAsync(cancellationToken);
        return await reader.ReadAsync(cancellationToken) ? MapProducto(reader) : null;
    }

    private static ProductoDto MapProducto(SqlDataReader reader) =>
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

    private static decimal GetDecimal(SqlDataReader reader, string columnName) =>
        reader[columnName] == DBNull.Value
            ? 0m
            : Convert.ToDecimal(reader[columnName], CultureInfo.InvariantCulture);

    private static bool GetBoolean(SqlDataReader reader, string columnName) =>
        reader[columnName] != DBNull.Value && Convert.ToBoolean(reader[columnName], CultureInfo.InvariantCulture);

    private sealed class NormalizedProducto
    {
        public string Nombre { get; init; } = string.Empty;

        public string? Descripcion { get; init; }

        public decimal Precio { get; init; }

        public string? Imagen { get; init; }

        public bool Activo { get; init; }
    }
}
