using System.ComponentModel.DataAnnotations;

namespace ImperiusDraconisAPI.Models.Alumnos;

public sealed class UpdateAlumnoEmojisRequest
{
    [MaxLength(20)]
    public string? Emojis { get; set; }
}
