namespace ImperiusDraconisAPI.Models.Dinamicas;

public sealed class PuntosCasaDetalleDto
{
    public int IdCasa { get; init; }

    public string NombreCasa { get; init; } = string.Empty;

    public int PuntosOtorgados { get; init; }
}
