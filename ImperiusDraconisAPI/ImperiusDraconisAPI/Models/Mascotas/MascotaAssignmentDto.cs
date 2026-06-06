namespace ImperiusDraconisAPI.Models.Mascotas;

public sealed class MascotaAssignmentDto
{
    public int IdMascotaAlumno { get; init; }

    public int IdAlumno { get; init; }

    public string CodigoAlumno { get; init; } = string.Empty;

    public string NombreAlumno { get; init; } = string.Empty;

    public int IdMascota { get; init; }

    public string NombreMascota { get; init; } = string.Empty;

    public string Estado { get; init; } = string.Empty;

    public DateTime FechaCompra { get; init; }

    public DateTime? FechaUltimoPago { get; init; }

    public decimal PrecioCompra { get; init; }

    public decimal PrecioMantenimiento { get; init; }

    public bool DebePagar { get; init; }

    public string? SubsidiadaPor { get; init; }

    public string? Observaciones { get; init; }
}
