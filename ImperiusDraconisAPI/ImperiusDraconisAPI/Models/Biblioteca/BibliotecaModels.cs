using System.ComponentModel.DataAnnotations;

namespace ImperiusDraconisAPI.Models.Biblioteca;

public sealed class BibliotecaCategoriaDto
{
    public int Id { get; init; }
    public string Nombre { get; init; } = string.Empty;
    public string? Descripcion { get; init; }
}

public sealed class BibliotecaLibroDto
{
    public int Id { get; init; }
    public string Titulo { get; init; } = string.Empty;
    public string Autor { get; init; } = string.Empty;
    public string? Sinopsis { get; init; }
    public int? IdCategoria { get; init; }
    public string CategoriaNombre { get; init; } = string.Empty;
    public string Formato { get; init; } = string.Empty;
    public decimal PrecioDracoins { get; init; }
    public bool Comprado { get; init; }
}

public sealed class UnlockBibliotecaRequest
{
    [Required(ErrorMessage = "La contraseña es obligatoria.")]
    public string Password { get; init; } = string.Empty;
}
