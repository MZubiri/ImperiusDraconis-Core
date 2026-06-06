namespace ImperiusDraconisAPI.Models.Mascotas;

public sealed class MascotaWeeklyChargeResultDto
{
    public int TotalProcesadas { get; init; }

    public int TotalRechazadas { get; init; }

    public IReadOnlyCollection<string> AlumnosRechazados { get; init; } = Array.Empty<string>();
}
