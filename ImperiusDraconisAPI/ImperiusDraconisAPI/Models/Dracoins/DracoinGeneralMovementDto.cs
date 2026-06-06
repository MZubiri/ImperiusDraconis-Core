namespace ImperiusDraconisAPI.Models.Dracoins;

public sealed class DracoinGeneralMovementDto
{
    public int IdMovimiento { get; init; }

    public string CodigoRemitente { get; init; } = string.Empty;

    public string NombreRemitente { get; init; } = string.Empty;

    public string CodigoDestinatario { get; init; } = string.Empty;

    public string NombreDestinatario { get; init; } = string.Empty;

    public int Monto { get; init; }

    public DateTime FechaTransferencia { get; init; }

    public string Observacion { get; init; } = string.Empty;
}
