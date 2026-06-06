namespace ImperiusDraconisAPI.Models.Mascotas;

public sealed class MascotaWeeklyChargeCandidateDto
{
    public int IdMascotaAlumno { get; init; }

    public int IdAlumno { get; init; }

    public string CodigoAlumno { get; init; } = string.Empty;

    public string NombreAlumno { get; init; } = string.Empty;

    public string NombreMascota { get; init; } = string.Empty;

    public string Estado { get; init; } = string.Empty;

    public decimal PrecioMantenimiento { get; init; }

    public DateTime? FechaUltimoPago { get; init; }

    public decimal DracoinsDisponibles { get; init; }

    public bool DebePagar { get; init; } = true;
}
