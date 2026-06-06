namespace ImperiusDraconisAPI.Models.Dinamicas;

public sealed class DinamicasQuery
{
    public string? Nombre { get; set; }

    public string? Tipo { get; set; }

    public string? Subtipo { get; set; }

    public string? Responsable { get; set; }

    public DateTime? Desde { get; set; }

    public DateTime? Hasta { get; set; }

    public int Pagina { get; set; } = 1;

    public int RegistrosPorPagina { get; set; } = 10;
}
