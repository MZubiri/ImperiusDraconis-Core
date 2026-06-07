using System.ComponentModel.DataAnnotations;

namespace ImperiusDraconisAPI.Models.Ia;

public sealed class FormatCorrectionRequest
{
    [Required]
    [MaxLength(10000)]
    public string Texto { get; set; } = string.Empty;

    [Required]
    [MaxLength(20)]
    public string Tipo { get; set; } = string.Empty;
}

public sealed class FormatCorrectionResponse
{
    public string TextoCorregido { get; init; } = string.Empty;

    public string Advertencia { get; init; } = "Revisa el resultado antes de analizar.";
}
