using System.ComponentModel.DataAnnotations;

namespace ImperiusDraconisAPI.Models.Dinamicas;

public sealed class RegistrarDinamicaDracoinsItemRequest
{
    [Range(1, int.MaxValue)]
    public int IdAlumno { get; set; }

    [Range(0, int.MaxValue)]
    public int DracoinsOtorgados { get; set; }

    [MaxLength(510)]
    public string? Observacion { get; set; }
}
