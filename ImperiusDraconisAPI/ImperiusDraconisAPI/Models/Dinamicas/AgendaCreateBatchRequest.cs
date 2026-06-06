using System.ComponentModel.DataAnnotations;

namespace ImperiusDraconisAPI.Models.Dinamicas;

public sealed class AgendaCreateBatchRequest
{
    [Required]
    public DateTime? Fecha { get; set; }

    [Required]
    [MinLength(1)]
    public List<AgendaCreateItemRequest> Items { get; set; } = [];
}
