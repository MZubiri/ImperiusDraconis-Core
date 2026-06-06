namespace ImperiusDraconisAPI.Models.Dracoins;

public sealed class DracoinSummaryDto
{
    public int IdAlumno { get; init; }

    public string Codigo { get; init; } = string.Empty;

    public string Nombre { get; init; } = string.Empty;

    public decimal SaldoActual { get; init; }

    public int TotalTransferenciasEnviadas { get; init; }

    public int TotalTransferenciasRecibidas { get; init; }

    public int MontoEnviadoTotal { get; init; }

    public int MontoRecibidoTotal { get; init; }

    public IReadOnlyCollection<DracoinTransferDto> TransferenciasRecientes { get; init; } =
        Array.Empty<DracoinTransferDto>();
}
