using System.Security.Claims;
using ImperiusDraconisAPI.Common;
using ImperiusDraconisAPI.Models.Tienda;
using ImperiusDraconisAPI.Security;
using ImperiusDraconisAPI.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace ImperiusDraconisAPI.Controllers;

[ApiController]
[Authorize]
[Route("api/[controller]")]
public sealed class TiendaController : ControllerBase
{
    private readonly TiendaService _tiendaService;

    public TiendaController(TiendaService tiendaService)
    {
        _tiendaService = tiendaService;
    }

    [HttpGet("productos")]
    public async Task<ActionResult<IReadOnlyCollection<TiendaProductoDto>>> GetProductos(
        [FromQuery] TiendaProductoQuery query,
        CancellationToken cancellationToken)
    {
        return Ok(await _tiendaService.GetCatalogAsync(query, cancellationToken));
    }

    [HttpGet("catalogos-compra")]
    public async Task<ActionResult<TiendaCompraCatalogosDto>> GetCompraCatalogos(CancellationToken cancellationToken)
    {
        return Ok(await _tiendaService.GetCompraCatalogosAsync(GetCurrentUserId(), cancellationToken));
    }

    [HttpPost("compras")]
    public async Task<ActionResult<TiendaComprobanteDto>> CreateCompra(
        [FromBody] CreateTiendaCompraRequest request,
        CancellationToken cancellationToken)
    {
        try
        {
            var result = await _tiendaService.CreateCompraAsync(GetCurrentUserId(), request, cancellationToken);
            return CreatedAtAction(nameof(GetComprobante), new { idPedido = result.IdPedido }, result);
        }
        catch (BusinessRuleException exception)
        {
            return BadRequest(new { message = exception.Message });
        }
    }

    [HttpGet("pedidos/{idPedido:int}/comprobante")]
    public async Task<ActionResult<TiendaComprobanteDto>> GetComprobante(
        int idPedido,
        CancellationToken cancellationToken)
    {
        var result = await _tiendaService.GetComprobanteAsync(
            idPedido,
            GetCurrentUserId(),
            CanAdmin(),
            cancellationToken);
        return result is null ? NotFound() : Ok(result);
    }

    [HttpGet("historial")]
    public async Task<ActionResult<PagedResult<TiendaPedidoDto>>> GetHistorial(
        [FromQuery] TiendaHistorialQuery query,
        CancellationToken cancellationToken)
    {
        return Ok(await _tiendaService.GetHistorialAsync(GetCurrentUserId(), query, cancellationToken));
    }

    [HttpPost("pedidos/{idPedido:int}/cancelar")]
    public async Task<ActionResult> CancelarPedido(int idPedido, CancellationToken cancellationToken)
    {
        try
        {
            var result = await _tiendaService.CancelarPedidoAsync(idPedido, GetCurrentUserId(), cancellationToken);
            return result ? NoContent() : NotFound();
        }
        catch (BusinessRuleException exception)
        {
            return BadRequest(new { message = exception.Message });
        }
    }

    [HttpGet("pendientes")]
    [HasPermission("Tienda:Pendientes")]
    public async Task<ActionResult<IReadOnlyCollection<TiendaPedidoDto>>> GetPendientes(CancellationToken cancellationToken)
    {
        return Ok(await _tiendaService.GetPendientesAsync(cancellationToken));
    }

    [HttpPost("pedidos/{idPedido:int}/tomar")]
    [HasPermission("Tienda:Pendientes")]
    public async Task<ActionResult<TiendaPedidoDto>> TomarPedido(int idPedido, CancellationToken cancellationToken)
    {
        try
        {
            var result = await _tiendaService.TomarPedidoAsync(idPedido, GetCurrentUserId(), cancellationToken);
            return result is null ? NotFound() : Ok(result);
        }
        catch (BusinessRuleException exception)
        {
            return BadRequest(new { message = exception.Message });
        }
    }

    [HttpGet("mis-pedidos")]
    [HasPermission("Tienda:MisPedidos")]
    public async Task<ActionResult<IReadOnlyCollection<TiendaPedidoDto>>> GetMisPedidos(CancellationToken cancellationToken)
    {
        return Ok(await _tiendaService.GetMisPedidosAsync(GetCurrentUserId(), cancellationToken));
    }

    [HttpPost("pedidos/{idPedido:int}/estado")]
    [HasPermission("Tienda:MisPedidos")]
    public async Task<ActionResult<TiendaPedidoDto>> CambiarEstadoVendedor(
        int idPedido,
        [FromBody] UpdateTiendaPedidoEstadoRequest request,
        CancellationToken cancellationToken)
    {
        try
        {
            var result = await _tiendaService.CambiarEstadoVendedorAsync(
                idPedido,
                GetCurrentUserId(),
                request,
                cancellationToken);
            return result is null ? NotFound() : Ok(result);
        }
        catch (BusinessRuleException exception)
        {
            return BadRequest(new { message = exception.Message });
        }
    }

    [HttpGet("panel-admin")]
    [HasPermission("Tienda:PanelAdmin")]
    public async Task<ActionResult<TiendaPanelResumenDto>> GetPanelAdmin(CancellationToken cancellationToken)
    {
        return Ok(await _tiendaService.GetPanelResumenAsync(cancellationToken));
    }

    [HttpGet("catalogos-admin")]
    [HasPermission("Tienda:HistorialAdmin")]
    public async Task<ActionResult<TiendaAdminCatalogosDto>> GetAdminCatalogos(CancellationToken cancellationToken)
    {
        return Ok(await _tiendaService.GetAdminCatalogosAsync(cancellationToken));
    }

    [HttpGet("historial-admin")]
    [HasPermission("Tienda:HistorialAdmin")]
    public async Task<ActionResult<PagedResult<TiendaPedidoDto>>> GetHistorialAdmin(
        [FromQuery] TiendaHistorialAdminQuery query,
        CancellationToken cancellationToken)
    {
        return Ok(await _tiendaService.GetHistorialAdminAsync(query, cancellationToken));
    }

    [HttpPost("pedidos/{idPedido:int}/estado-admin")]
    [HasPermission("Tienda:HistorialAdmin")]
    public async Task<ActionResult<TiendaPedidoDto>> CambiarEstadoAdmin(
        int idPedido,
        [FromBody] UpdateTiendaPedidoEstadoRequest request,
        CancellationToken cancellationToken)
    {
        try
        {
            var result = await _tiendaService.CambiarEstadoAdminAsync(
                idPedido,
                GetCurrentUserId(),
                request,
                cancellationToken);
            return result is null ? NotFound() : Ok(result);
        }
        catch (BusinessRuleException exception)
        {
            return BadRequest(new { message = exception.Message });
        }
    }

    private int GetCurrentUserId() =>
        int.TryParse(User.FindFirstValue(ClaimTypes.NameIdentifier), out var idAlumno) ? idAlumno : 0;

    private bool CanAdmin() =>
        User.Claims.Any(claim =>
            claim.Type == "permission" &&
            string.Equals(claim.Value, "Tienda:HistorialAdmin", StringComparison.OrdinalIgnoreCase));
}
