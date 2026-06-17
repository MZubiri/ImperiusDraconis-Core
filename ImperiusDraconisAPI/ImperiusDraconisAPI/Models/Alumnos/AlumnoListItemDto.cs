namespace ImperiusDraconisAPI.Models.Alumnos;

public sealed class AlumnoListItemDto
{
    public int IdAlumno { get; init; }

    public string Codigo { get; init; } = string.Empty;

    public string Nombre { get; init; } = string.Empty;

    public string Emojis { get; init; } = string.Empty;

    public decimal Dracoins { get; init; }

    public bool Activo { get; init; }

    public string Categoria { get; init; } = string.Empty;

    public int? IdCasa { get; init; }

    public string CasaNombre { get; init; } = string.Empty;

    public int? IdCargo { get; init; }

    public string NombreCargo { get; init; } = string.Empty;

    public string Genero { get; init; } = string.Empty;

    public string Telefono { get; init; } = string.Empty;

    public string CorreoElectronico { get; init; } = string.Empty;
}
