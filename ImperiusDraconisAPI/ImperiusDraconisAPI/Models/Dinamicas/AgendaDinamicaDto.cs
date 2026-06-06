namespace ImperiusDraconisAPI.Models.Dinamicas;

public sealed class AgendaDinamicaDto
{
    public int IdAgenda { get; init; }

    public DateTime Fecha { get; init; }

    public TimeSpan Hora { get; init; }

    public int IdAlumno { get; init; }

    public string NombreAlumno { get; init; } = string.Empty;

    public string Cargo { get; init; } = string.Empty;

    public string Genero { get; init; } = string.Empty;

    public string Titulo { get; init; } = string.Empty;
}
