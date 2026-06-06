namespace ImperiusDraconisAPI.Models.Dracoins;

public sealed class DracoinAdministrativePaymentDto
{
    public int IdPago { get; init; }

    public int IdAlumno { get; init; }

    public string CodigoAlumno { get; init; } = string.Empty;

    public string NombreAlumno { get; init; } = string.Empty;

    public string Cargo { get; init; } = string.Empty;

    public decimal MontoPagado { get; init; }

    public DateTime FechaPago { get; init; }

    public string PagadoPor { get; init; } = string.Empty;

    public string Genero { get; init; } = string.Empty;
}
