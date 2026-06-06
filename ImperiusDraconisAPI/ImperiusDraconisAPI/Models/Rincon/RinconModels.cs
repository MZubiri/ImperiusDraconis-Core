using Microsoft.AspNetCore.Http;

namespace ImperiusDraconisAPI.Models.Rincon;

public sealed class RinconProductoQuery
{
    public string? Categoria { get; init; }

    public bool? SoloDisponibles { get; init; }
}

public sealed class RinconProductoDto
{
    public int IdProducto { get; init; }

    public string Nombre { get; init; } = string.Empty;

    public string Descripcion { get; init; } = string.Empty;

    public decimal Precio { get; init; }

    public int Stock { get; init; }

    public string ImagenUrl { get; init; } = string.Empty;

    public string Categoria { get; init; } = string.Empty;

    public DateTime? FechaRegistro { get; init; }
}

public sealed class RinconPedidoDetalleDto
{
    public int IdProducto { get; init; }

    public string Nombre { get; init; } = string.Empty;

    public int Cantidad { get; init; }

    public decimal PrecioUnitario { get; init; }

    public decimal Subtotal { get; init; }
}

public sealed class RinconPedidoDto
{
    public int IdPedido { get; init; }

    public int IdAlumno { get; init; }

    public string NombreAlumno { get; init; } = string.Empty;

    public DateTime FechaPedido { get; init; }

    public decimal Total { get; init; }

    public int Estado { get; init; }

    public string EstadoNombre { get; init; } = string.Empty;

    public IReadOnlyCollection<RinconPedidoDetalleDto> Detalles { get; init; } = Array.Empty<RinconPedidoDetalleDto>();
}

public sealed class RinconResumenAdminDto
{
    public int TotalProductos { get; init; }

    public int ProductosSinStock { get; init; }

    public int PedidosPendientes { get; init; }

    public int PedidosEntregados { get; init; }
}

public sealed class SaveRinconProductoRequest
{
    public int? IdProducto { get; init; }

    public string Nombre { get; init; } = string.Empty;

    public string? Descripcion { get; init; }

    public decimal Precio { get; init; }

    public int Stock { get; init; }

    public string? Categoria { get; init; }

    public string? ImagenUrlActual { get; init; }

    public IFormFile? ImagenFile { get; init; }
}

public sealed class CreateRinconPedidoItemRequest
{
    public int IdProducto { get; init; }

    public int Cantidad { get; init; }
}

public sealed class CreateRinconPedidoRequest
{
    public IReadOnlyCollection<CreateRinconPedidoItemRequest> Items { get; init; } =
        Array.Empty<CreateRinconPedidoItemRequest>();
}
