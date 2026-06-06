namespace ImperiusDraconisAPI.Common;

public sealed class PagedResult<T>
{
    public IReadOnlyCollection<T> Items { get; init; } = Array.Empty<T>();

    public int TotalRegistros { get; init; }

    public int PaginaActual { get; init; }

    public int RegistrosPorPagina { get; init; }

    public int TotalPaginas =>
        RegistrosPorPagina <= 0 ? 0 : (int)Math.Ceiling(TotalRegistros / (double)RegistrosPorPagina);
}
