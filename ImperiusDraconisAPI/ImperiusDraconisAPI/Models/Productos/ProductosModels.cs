using Microsoft.AspNetCore.Http;

namespace ImperiusDraconisAPI.Models.Productos;

public sealed class ProductoDto
{
    public int IdProducto { get; init; }

    public string Nombre { get; init; } = string.Empty;

    public string Descripcion { get; init; } = string.Empty;

    public decimal Precio { get; init; }

    public string Imagen { get; init; } = string.Empty;

    public bool Activo { get; init; }
}

public sealed class SaveProductoRequest
{
    public int? IdProducto { get; init; }

    public string Nombre { get; init; } = string.Empty;

    public string? Descripcion { get; init; }

    public decimal Precio { get; init; }

    public bool Activo { get; init; } = true;

    public string? ImagenActual { get; init; }

    public IFormFile? FotoArchivo { get; init; }
}
