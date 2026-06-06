using System.ComponentModel.DataAnnotations;

namespace ImperiusDraconisAPI.Models.Marcadores;

public sealed class MarcadorUpdateRequest
{
    [Required]
    [MaxLength(200)]
    public string NombreDinamica { get; set; } = string.Empty;

    [Required]
    [MaxLength(40)]
    public string SubtipoDinamica { get; set; } = string.Empty;

    [MaxLength(510)]
    public string? Observacion { get; set; }

    [Required]
    [MinLength(1)]
    public List<MarcadorUpdateItemRequest> PuntosPorCasa { get; set; } = [];
}
