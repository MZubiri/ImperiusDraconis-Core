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

public sealed class SaveLibroRequest
{
    [Required(ErrorMessage = "El título es obligatorio.")]
    public string Titulo { get; init; } = string.Empty;

    [Required(ErrorMessage = "El autor es obligatorio.")]
    public string Autor { get; init; } = string.Empty;

    public string? Sinopsis { get; init; }

    public int? IdCategoria { get; init; }

    [Required(ErrorMessage = "La ruta del archivo es obligatoria.")]
    public string RutaArchivo { get; init; } = string.Empty;

    [Required(ErrorMessage = "El formato es obligatorio (ej: .pdf).")]
    public string Formato { get; init; } = string.Empty;

    public decimal PrecioDracoins { get; init; }

    public bool Activo { get; init; } = true;
}

public sealed class SuscripcionStatusDto
{
    public bool Activa { get; init; }
    public DateTime? FechaVencimiento { get; init; }
    public int CostoSuscripcion { get; init; } = 50; // Costo por defecto 50 Dracoins
}

public sealed class BookExcelRow
{
    public int? Id { get; set; }
    public string Titulo { get; set; } = string.Empty;
    public string Autor { get; set; } = string.Empty;
    public string? Sinopsis { get; set; }
    public string? Categoria { get; set; }
    public string RutaArchivo { get; set; } = string.Empty;
    public string Formato { get; set; } = string.Empty;
    public decimal PrecioDracoins { get; set; }
    public bool Activo { get; set; }
}
