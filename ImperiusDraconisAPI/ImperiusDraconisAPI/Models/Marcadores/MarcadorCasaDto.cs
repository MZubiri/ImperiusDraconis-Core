namespace ImperiusDraconisAPI.Models.Marcadores;

public sealed class MarcadorCasaDto
{
    public int IdCasa { get; init; }

    public string NombreCasa { get; init; } = string.Empty;

    public string Color { get; init; } = string.Empty;

    public int PuntosAcumulados { get; init; }
}
