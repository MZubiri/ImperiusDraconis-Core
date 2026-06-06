namespace ImperiusDraconisAPI.Models.Auth;

public sealed class AuthenticatedUserDto
{
    public int IdAlumno { get; init; }

    public string Codigo { get; init; } = string.Empty;

    public string Nombre { get; init; } = string.Empty;

    public int? IdCasa { get; init; }

    public string CasaNombre { get; init; } = string.Empty;

    public int? IdCargo { get; init; }

    public string CargoNombre { get; init; } = string.Empty;

    public string Categoria { get; init; } = string.Empty;

    public string Genero { get; init; } = string.Empty;

    public string FotoPerfil { get; init; } = string.Empty;

    public decimal Dracoins { get; init; }

    public int[] Trabajos { get; init; } = Array.Empty<int>();

    public string[] Permisos { get; init; } = Array.Empty<string>();
}
