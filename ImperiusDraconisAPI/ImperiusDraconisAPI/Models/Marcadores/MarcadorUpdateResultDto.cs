namespace ImperiusDraconisAPI.Models.Marcadores;

public sealed class MarcadorUpdateResultDto
{
    public int IdDinamica { get; init; }

    public string NombreDinamica { get; init; } = string.Empty;

    public string SubtipoDinamica { get; init; } = string.Empty;

    public int TotalPuntosOtorgados { get; init; }

    public IReadOnlyCollection<MarcadorCasaDto> MarcadorActual { get; init; } = Array.Empty<MarcadorCasaDto>();
}
