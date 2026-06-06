using System.Security.Claims;
using ImperiusDraconisAPI.Common;
using ImperiusDraconisAPI.Models.Rincon;
using ImperiusDraconisAPI.Security;
using ImperiusDraconisAPI.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace ImperiusDraconisAPI.Controllers;

[ApiController]
[Authorize]
[Route("api/[controller]")]
public sealed class RinconController : ControllerBase
{
    private readonly RinconService _rinconService;

    public RinconController(RinconService rinconService)
    {
        _rinconService = rinconService;
    }

    [HttpGet("productos")]
    [HasPermission("Rincon:Catalogo", "Rincon:GestionarProductos")]
    public async Task<ActionResult<IReadOnlyCollection<RinconProductoDto>>> GetProductos(
        [FromQuery] RinconProductoQuery query,
        CancellationToken cancellationToken)
    {
        return Ok(await _rinconService.GetCatalogAsync(query, cancellationToken));
    }

    [HttpGet("productos/{idProducto:int}")]
    [HasPermission("Rincon:Catalogo", "Rincon:GestionarProductos")]
    public async Task<ActionResult<RinconProductoDto>> GetProductoById(
        int idProducto,
        CancellationToken cancellationToken)
    {
        var result = await _rinconService.GetByIdAsync(idProducto, cancellationToken);
        return result is null ? NotFound() : Ok(result);
    }

    [HttpPost("pedidos")]
    [HasPermission("Rincon:Comprar")]
    public async Task<ActionResult<RinconPedidoDto>> CreatePedido(
        [FromBody] CreateRinconPedidoRequest request,
        CancellationToken cancellationToken)
    {
        try
        {
            var result = await _rinconService.CreatePedidoAsync(GetCurrentUserId(), request, cancellationToken);
            return CreatedAtAction(nameof(GetComprobante), new { idPedido = result.IdPedido }, result);
        }
        catch (BusinessRuleException exception)
        {
            return BadRequest(new { message = exception.Message });
        }
    }

    [HttpGet("pedidos/{idPedido:int}/comprobante")]
    [HasPermission("Rincon:Historial", "Rincon:PanelAdmin", "Rincon:GestionarPedidos")]
    public async Task<ActionResult<RinconPedidoDto>> GetComprobante(
        int idPedido,
        CancellationToken cancellationToken)
    {
        var result = await _rinconService.GetComprobanteAsync(
            idPedido,
            GetCurrentUserId(),
            HasAnyPermission("Rincon:PanelAdmin", "Rincon:GestionarPedidos"),
            cancellationToken);
        return result is null ? NotFound() : Ok(result);
    }

    [HttpGet("historial")]
    [HasPermission("Rincon:Historial")]
    public async Task<ActionResult<IReadOnlyCollection<RinconPedidoDto>>> GetHistorial(CancellationToken cancellationToken)
    {
        return Ok(await _rinconService.GetHistorialAsync(GetCurrentUserId(), cancellationToken));
    }

    [HttpPost("pedidos/{idPedido:int}/cancelar")]
    [HasPermission("Rincon:CancelarPedido", "Rincon:GestionarPedidos")]
    public async Task<ActionResult<RinconPedidoDto>> CancelarPedido(
        int idPedido,
        CancellationToken cancellationToken)
    {
        try
        {
            var result = await _rinconService.CancelarPedidoAsync(
                idPedido,
                GetCurrentUserId(),
                HasAnyPermission("Rincon:GestionarPedidos"),
                cancellationToken);
            return result is null ? NotFound() : Ok(result);
        }
        catch (BusinessRuleException exception)
        {
            return BadRequest(new { message = exception.Message });
        }
    }

    [HttpGet("admin/resumen")]
    [HasPermission("Rincon:PanelAdmin")]
    public async Task<ActionResult<RinconResumenAdminDto>> GetResumenAdmin(CancellationToken cancellationToken)
    {
        return Ok(await _rinconService.GetResumenAdminAsync(cancellationToken));
    }

    [HttpPost("admin/productos")]
    [HasPermission("Rincon:GestionarProductos")]
    public async Task<ActionResult<RinconProductoDto>> CreateProducto(
        [FromForm] SaveRinconProductoRequest request,
        CancellationToken cancellationToken)
    {
        try
        {
            var result = await _rinconService.CreateProductoAsync(request, cancellationToken);
            return CreatedAtAction(nameof(GetProductoById), new { idProducto = result.IdProducto }, result);
        }
        catch (BusinessRuleException exception)
        {
            return BadRequest(new { message = exception.Message });
        }
    }

    [HttpPut("admin/productos/{idProducto:int}")]
    [HasPermission("Rincon:GestionarProductos")]
    public async Task<ActionResult> UpdateProducto(
        int idProducto,
        [FromForm] SaveRinconProductoRequest request,
        CancellationToken cancellationToken)
    {
        try
        {
            var updated = await _rinconService.UpdateProductoAsync(idProducto, request, cancellationToken);
            return updated ? NoContent() : NotFound();
        }
        catch (BusinessRuleException exception)
        {
            return BadRequest(new { message = exception.Message });
        }
    }

    [HttpDelete("admin/productos/{idProducto:int}")]
    [HasPermission("Rincon:GestionarProductos")]
    public async Task<ActionResult> DeleteProducto(int idProducto, CancellationToken cancellationToken)
    {
        try
        {
            var deleted = await _rinconService.DeleteProductoAsync(idProducto, cancellationToken);
            return deleted ? NoContent() : NotFound();
        }
        catch (BusinessRuleException exception)
        {
            return BadRequest(new { message = exception.Message });
        }
    }

    [HttpGet("admin/pedidos-pendientes")]
    [HasPermission("Rincon:GestionarPedidos")]
    public async Task<ActionResult<IReadOnlyCollection<RinconPedidoDto>>> GetPedidosPendientes(
        CancellationToken cancellationToken)
    {
        return Ok(await _rinconService.GetPedidosPendientesAsync(cancellationToken));
    }

    [HttpPost("admin/pedidos/{idPedido:int}/entregado")]
    [HasPermission("Rincon:GestionarPedidos")]
    public async Task<ActionResult<RinconPedidoDto>> MarcarEntregado(
        int idPedido,
        CancellationToken cancellationToken)
    {
        var result = await _rinconService.MarcarEntregadoAsync(idPedido, cancellationToken);
        return result is null ? NotFound() : Ok(result);
    }

    [HttpGet("admin/historial")]
    [HasPermission("Rincon:PanelAdmin", "Rincon:GestionarPedidos")]
    public async Task<ActionResult<IReadOnlyCollection<RinconPedidoDto>>> GetHistorialAdmin(
        [FromQuery] int? estado,
        CancellationToken cancellationToken)
    {
        return Ok(await _rinconService.GetHistorialAdminAsync(estado, cancellationToken));
    }

    private int GetCurrentUserId() =>
        int.TryParse(User.FindFirstValue(ClaimTypes.NameIdentifier), out var idAlumno) ? idAlumno : 0;

    private bool HasAnyPermission(params string[] permissions) =>
        User.Claims.Any(claim =>
            claim.Type == "permission" &&
            permissions.Any(permission =>
                string.Equals(claim.Value, permission, StringComparison.OrdinalIgnoreCase)));
}
