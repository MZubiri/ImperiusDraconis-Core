namespace ImperiusDraconisAPI.Models.Mascotas;

public sealed class MascotaCatalogItemDto
{
    public int IdMascota { get; init; }

    public string Nombre { get; init; } = string.Empty;

    public decimal PrecioCompra { get; init; }

    public decimal PrecioMantenimiento { get; init; }

    public bool Activo { get; init; }
}
