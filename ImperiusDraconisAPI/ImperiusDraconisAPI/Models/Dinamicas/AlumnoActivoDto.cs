namespace ImperiusDraconisAPI.Models.Dinamicas;

public sealed class AlumnoActivoDto
{
    public int IdAlumno { get; init; }

    public string Codigo { get; init; } = string.Empty;

    public string Nombre { get; init; } = string.Empty;

    public string Emojis { get; init; } = string.Empty;

    public decimal Dracoins { get; init; }
}
