using System.ComponentModel.DataAnnotations;

namespace ImperiusDraconisAPI.Models.Mascotas;

public sealed class ChangeMascotaStateRequest
{
    [Required]
    [MaxLength(20)]
    public string NuevoEstado { get; set; } = string.Empty;

    [MaxLength(100)]
    public string? SubsidiadaPor { get; set; }

    [MaxLength(255)]
    public string? Observaciones { get; set; }
}
