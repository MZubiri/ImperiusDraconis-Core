namespace ImperiusDraconisAPI.Models.Marcadores;

public sealed class MarcadorCloseResultDto
{
    public DateTime FechaCierre { get; init; }

    public int RegistrosGenerados { get; init; }

    public IReadOnlyCollection<MarcadorCasaDto> MarcadorActual { get; init; } = [];
}
