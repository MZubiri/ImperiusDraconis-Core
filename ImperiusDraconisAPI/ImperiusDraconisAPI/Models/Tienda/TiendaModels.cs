using ImperiusDraconisAPI.Common;

namespace ImperiusDraconisAPI.Models.Tienda;

public sealed class TiendaProductoDto
{
    public int IdProducto { get; init; }

    public string Nombre { get; init; } = string.Empty;

    public string Descripcion { get; init; } = string.Empty;

    public decimal Precio { get; init; }

    public string Imagen { get; init; } = string.Empty;

    public bool Activo { get; init; }
}

public sealed class TiendaProductoQuery
{
    public string? Nombre { get; init; }

    public decimal? PrecioMin { get; init; }

    public decimal? PrecioMax { get; init; }
}

public sealed class TiendaCompraCatalogosDto
{
    public IReadOnlyCollection<CatalogItemDto> Destinatarios { get; init; } = Array.Empty<CatalogItemDto>();
}

public sealed class TiendaPanelResumenDto
{
    public int TotalProductosActivos { get; init; }

    public int TotalPedidosPendientes { get; init; }

    public int TotalPedidosTomados { get; init; }

    public int TotalPedidosEntregados { get; init; }

    public int TotalPedidosCancelados { get; init; }
}

public sealed class TiendaHistorialQuery
{
    public string? Estado { get; init; }

    public string? Nombre { get; init; }

    public DateTime? Desde { get; init; }

    public DateTime? Hasta { get; init; }

    public int Pagina { get; init; } = 1;

    public int RegistrosPorPagina { get; init; } = 10;
}

public sealed class TiendaHistorialAdminQuery
{
    public string? Codigo { get; init; }

    public int? IdVendedor { get; init; }

    public int? Estado { get; init; }

    public int Pagina { get; init; } = 1;

    public int RegistrosPorPagina { get; init; } = 10;
}

public sealed class TiendaPedidoDto
{
    public int IdPedido { get; init; }

    public DateTime FechaPedido { get; init; }

    public decimal Total { get; init; }

    public int IdEstado { get; init; }

    public string Estado { get; init; } = string.Empty;

    public int IdComprador { get; init; }

    public string CodigoComprador { get; init; } = string.Empty;

    public string NombreComprador { get; init; } = string.Empty;

    public int? IdDestinatario { get; init; }

    public string CodigoDestinatario { get; init; } = string.Empty;

    public string NombreDestinatario { get; init; } = string.Empty;

    public int? IdVendedor { get; init; }

    public string NombreVendedor { get; init; } = string.Empty;

    public string Producto { get; init; } = string.Empty;

    public string Imagen { get; init; } = string.Empty;

    public string Comentario { get; init; } = string.Empty;

    public bool PuedeCancelar { get; init; }
}

public sealed class TiendaComprobanteDto
{
    public int IdPedido { get; init; }

    public DateTime FechaPedido { get; init; }

    public decimal Total { get; init; }

    public string Producto { get; init; } = string.Empty;

    public string Imagen { get; init; } = string.Empty;

    public decimal Precio { get; init; }

    public string Comprador { get; init; } = string.Empty;

    public string Destinatario { get; init; } = string.Empty;

    public string Estado { get; init; } = string.Empty;

    public string Comentario { get; init; } = string.Empty;
}

public sealed class TiendaAdminCatalogosDto
{
    public IReadOnlyCollection<CatalogItemDto> Vendedores { get; init; } = Array.Empty<CatalogItemDto>();

    public IReadOnlyCollection<CatalogItemDto> Estados { get; init; } = Array.Empty<CatalogItemDto>();
}

public sealed class CreateTiendaCompraRequest
{
    public int IdProducto { get; init; }

    public int? IdDestinatario { get; init; }

    public string? Comentario { get; init; }
}

public sealed class UpdateTiendaPedidoEstadoRequest
{
    public int NuevoEstado { get; init; }

    public string? Observacion { get; init; }
}
