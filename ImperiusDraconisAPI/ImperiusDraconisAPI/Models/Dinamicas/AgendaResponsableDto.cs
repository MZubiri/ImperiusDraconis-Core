namespace ImperiusDraconisAPI.Models.Dinamicas;

public sealed class AgendaResponsableDto
{
    public int IdAlumno { get; init; }

    public string Nombre { get; init; } = string.Empty;

    public string Cargo { get; init; } = string.Empty;

    public string Genero { get; init; } = string.Empty;
}
