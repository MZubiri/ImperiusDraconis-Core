using System.ComponentModel.DataAnnotations;

namespace ImperiusDraconisAPI.Models.Mascotas;

public sealed class ProcessMascotaWeeklyChargeRequest
{
    [Required]
    [MinLength(1)]
    public List<int> IdsSeleccionados { get; set; } = [];
}
