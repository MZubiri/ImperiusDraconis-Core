namespace ImperiusDraconisAPI.Models.Alumnos;

public sealed class CumpleanosItemDto
{
    public int IdAlumno { get; init; }

    public string Nombre { get; init; } = string.Empty;

    public string FotoPerfil { get; init; } = string.Empty;

    public string Categoria { get; init; } = string.Empty;

    public string CasaNombre { get; init; } = string.Empty;

    /// <summary>Mes del cumpleaños (1-12).</summary>
    public int Mes { get; init; }

    /// <summary>Día del cumpleaños (1-31).</summary>
    public int Dia { get; init; }
}
