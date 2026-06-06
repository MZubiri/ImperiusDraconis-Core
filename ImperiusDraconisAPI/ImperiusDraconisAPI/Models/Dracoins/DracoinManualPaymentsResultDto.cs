namespace ImperiusDraconisAPI.Models.Dracoins;

public sealed class DracoinManualPaymentsResultDto
{
    public int TotalPagosProcesados { get; init; }

    public decimal TotalMontoPagado { get; init; }

    public IReadOnlyList<DracoinAdministrativePaymentDto> Pagos { get; init; } = [];
}
