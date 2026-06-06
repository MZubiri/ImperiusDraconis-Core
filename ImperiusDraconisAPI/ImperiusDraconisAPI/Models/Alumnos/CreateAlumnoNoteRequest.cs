using System.ComponentModel.DataAnnotations;

namespace ImperiusDraconisAPI.Models.Alumnos;

public sealed class CreateAlumnoNoteRequest
{
    [Required]
    [MaxLength(2000)]
    public string Nota { get; set; } = string.Empty;
}
