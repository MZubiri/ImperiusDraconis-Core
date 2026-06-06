using System.ComponentModel.DataAnnotations;

namespace ImperiusDraconisAPI.Models.Dracoins;

public sealed class UpdateDracoinSalaryCatalogRequest
{
    [Required]
    [MinLength(1)]
    public List<UpdateDracoinSalaryItemRequest> Items { get; set; } = [];
}
