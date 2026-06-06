using System.ComponentModel.DataAnnotations;

namespace ImperiusDraconisAPI.Models.Dracoins;

public sealed class UpdateDracoinSalaryItemRequest
{
    [Range(1, int.MaxValue)]
    public int IdSueldo { get; set; }

    [Range(0, 1000000)]
    public decimal SueldoFijo { get; set; }
}
