using System.ComponentModel.DataAnnotations;

namespace ImperiusDraconisAPI.Models.Dracoins;

public sealed class DracoinTransferRequest
{
    [Required]
    [MaxLength(10)]
    public string CodigoDestinatario { get; set; } = string.Empty;

    [Range(1, int.MaxValue)]
    public int Monto { get; set; }

    [MaxLength(255)]
    public string? Observacion { get; set; }
}
