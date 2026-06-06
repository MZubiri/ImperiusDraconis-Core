namespace ImperiusDraconisAPI.Models.Mascotas;

public sealed class MascotaSummaryDto
{
    public int TotalMascotasCatalogo { get; init; }

    public int TotalAsignaciones { get; init; }

    public int TotalSuscritas { get; init; }

    public int TotalCongeladas { get; init; }

    public int TotalSubsidiadas { get; init; }

    public int TotalNoActivas { get; init; }

    public int TotalEnLibertad { get; init; }

    public int TotalPendientesCobro { get; init; }
}
