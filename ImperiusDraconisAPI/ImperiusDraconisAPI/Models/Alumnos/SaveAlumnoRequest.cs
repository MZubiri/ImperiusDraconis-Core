using System.ComponentModel.DataAnnotations;

namespace ImperiusDraconisAPI.Models.Alumnos;

public sealed class SaveAlumnoRequest
{
    [Required]
    [MaxLength(10)]
    public string Codigo { get; set; } = string.Empty;

    [Required]
    [MaxLength(100)]
    public string Nombre { get; set; } = string.Empty;

    [MaxLength(20)]
    public string? Emojis { get; set; }

    [MaxLength(15)]
    public string? Telefono { get; set; }

    public int? IdCasa { get; set; }

    public int Puntos { get; set; }

    [MaxLength(50)]
    public string? Nivel { get; set; }

    public int? IdCargo { get; set; }

    public decimal Dracoins { get; set; }

    public bool Activo { get; set; } = true;

    [MaxLength(20)]
    public string? Genero { get; set; }

    public DateTime? Cumpleanos { get; set; }

    [MaxLength(100)]
    public string? Pais { get; set; }

    [MaxLength(10)]
    public string? PrefijoPais { get; set; }

    [MaxLength(100)]
    public string? ZonaHoraria { get; set; }

    [MaxLength(255)]
    [EmailAddress]
    public string? CorreoElectronico { get; set; }

    public string? FotoPerfil { get; set; }

    public string? Contrasena { get; set; }
}
