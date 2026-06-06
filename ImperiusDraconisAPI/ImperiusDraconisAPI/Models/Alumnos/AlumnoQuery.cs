namespace ImperiusDraconisAPI.Models.Alumnos;

public sealed class AlumnoQuery
{
    public string? Codigo { get; init; }

    public string? Nombre { get; init; }

    public int? IdCasa { get; init; }

    public bool? Activo { get; init; }

    public int Pagina { get; init; } = 1;

    public int RegistrosPorPagina { get; init; } = 30;

    public string OrdenarPor { get; init; } = "Nombre";

    public string Orden { get; init; } = "asc";
}
