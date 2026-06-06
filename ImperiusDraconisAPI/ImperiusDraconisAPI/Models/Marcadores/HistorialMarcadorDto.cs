namespace ImperiusDraconisAPI.Models.Marcadores;

public sealed class HistorialMarcadorDto
{
    public int IdHistorial { get; init; }

    public int IdCasa { get; init; }

    public string NombreCasa { get; init; } = string.Empty;

    public int PuntosAcumulados { get; init; }

    public DateTime FechaCierre { get; init; }
}
