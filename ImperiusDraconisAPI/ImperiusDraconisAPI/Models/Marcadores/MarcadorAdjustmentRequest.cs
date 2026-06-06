using System.ComponentModel.DataAnnotations;

namespace ImperiusDraconisAPI.Models.Marcadores;

public sealed class MarcadorAdjustmentRequest
{
    [Range(1, int.MaxValue)]
    public int IdCasa { get; set; }

    [Range(-1000000, 1000000)]
    public int Puntos { get; set; }

    [Required]
    [MaxLength(500)]
    public string Observacion { get; set; } = string.Empty;
}
