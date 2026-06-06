using System.ComponentModel.DataAnnotations;

namespace ImperiusDraconisAPI.Models.Dracoins;

public sealed class CreateDracoinManualPaymentsRequest
{
    [Required]
    [MinLength(1)]
    public List<CreateDracoinManualPaymentItemRequest> Items { get; set; } = [];
}
