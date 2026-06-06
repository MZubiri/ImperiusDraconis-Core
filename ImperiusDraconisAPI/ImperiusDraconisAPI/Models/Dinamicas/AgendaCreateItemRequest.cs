using System.ComponentModel.DataAnnotations;

namespace ImperiusDraconisAPI.Models.Dinamicas;

public sealed class AgendaCreateItemRequest
{
    [Required]
    public string Hora { get; set; } = string.Empty;

    [Range(1, int.MaxValue)]
    public int IdAlumno { get; set; }

    [MaxLength(200)]
    public string Titulo { get; set; } = string.Empty;
}
