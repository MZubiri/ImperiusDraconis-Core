using System.ComponentModel.DataAnnotations;

namespace ImperiusDraconisAPI.Models.Dracoins;

public sealed class CreateDracoinManualPaymentItemRequest
{
    [Range(1, int.MaxValue)]
    public int IdAlumno { get; set; }

    [Range(1, 1000000)]
    public decimal MontoPagado { get; set; }
}
