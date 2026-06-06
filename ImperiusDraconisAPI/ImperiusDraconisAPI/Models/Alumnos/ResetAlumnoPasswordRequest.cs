using System.ComponentModel.DataAnnotations;

namespace ImperiusDraconisAPI.Models.Alumnos;

public sealed class ResetAlumnoPasswordRequest
{
    [Required]
    [MinLength(6)]
    [MaxLength(100)]
    public string NuevaContrasena { get; set; } = string.Empty;
}
