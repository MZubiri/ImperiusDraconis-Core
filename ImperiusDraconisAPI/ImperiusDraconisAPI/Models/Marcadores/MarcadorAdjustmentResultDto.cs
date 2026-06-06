namespace ImperiusDraconisAPI.Models.Marcadores;

public sealed class MarcadorAdjustmentResultDto
{
    public int IdDinamica { get; init; }

    public int IdCasa { get; init; }

    public int PuntosAjustados { get; init; }

    public IReadOnlyCollection<MarcadorCasaDto> MarcadorActual { get; init; } = [];
}
