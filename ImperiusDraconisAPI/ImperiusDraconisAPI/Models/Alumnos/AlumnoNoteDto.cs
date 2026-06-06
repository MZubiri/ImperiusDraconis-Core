namespace ImperiusDraconisAPI.Models.Alumnos;

public sealed class AlumnoNoteDto
{
    public int IdNota { get; init; }

    public int IdAlumno { get; init; }

    public string Nota { get; init; } = string.Empty;

    public DateTime Fecha { get; init; }
}
