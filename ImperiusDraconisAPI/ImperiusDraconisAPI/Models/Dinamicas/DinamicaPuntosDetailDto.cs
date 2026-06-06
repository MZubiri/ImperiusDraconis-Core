namespace ImperiusDraconisAPI.Models.Dinamicas;

public sealed class DinamicaPuntosDetailDto
{
    public int IdDinamica { get; init; }

    public DateTime? Fecha { get; init; }

    public string Nombre { get; init; } = string.Empty;

    public string Tipo { get; init; } = string.Empty;

    public string Subtipo { get; init; } = string.Empty;

    public int? IdResponsable { get; init; }

    public string NombreResponsable { get; init; } = string.Empty;

    public string Observacion { get; init; } = string.Empty;

    public IReadOnlyCollection<PuntosCasaDetalleDto> Resultados { get; init; } = Array.Empty<PuntosCasaDetalleDto>();
}
