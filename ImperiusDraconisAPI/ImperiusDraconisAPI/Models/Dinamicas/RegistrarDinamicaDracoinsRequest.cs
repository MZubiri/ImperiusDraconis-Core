using System.ComponentModel.DataAnnotations;

namespace ImperiusDraconisAPI.Models.Dinamicas;

public sealed class RegistrarDinamicaDracoinsRequest
{
    [Required]
    [MaxLength(200)]
    public string Nombre { get; set; } = string.Empty;

    [MaxLength(510)]
    public string? Observacion { get; set; }

    [Required]
    [MinLength(1)]
    public List<RegistrarDinamicaDracoinsItemRequest> Asignaciones { get; set; } = [];
}
