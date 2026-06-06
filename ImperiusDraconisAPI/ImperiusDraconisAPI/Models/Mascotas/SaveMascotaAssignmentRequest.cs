using System.ComponentModel.DataAnnotations;

namespace ImperiusDraconisAPI.Models.Mascotas;

public sealed class SaveMascotaAssignmentRequest
{
    [Range(1, int.MaxValue)]
    public int IdAlumno { get; set; }

    [Range(1, int.MaxValue)]
    public int IdMascota { get; set; }

    [Required]
    [MaxLength(20)]
    public string Estado { get; set; } = string.Empty;

    public DateTime FechaCompra { get; set; }

    public DateTime? FechaUltimoPago { get; set; }

    [MaxLength(100)]
    public string? SubsidiadaPor { get; set; }

    [MaxLength(255)]
    public string? Observaciones { get; set; }
}
