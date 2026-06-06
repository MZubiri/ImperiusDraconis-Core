using ImperiusDraconisAPI.Common;
using ImperiusDraconisAPI.Models.Productos;
using ImperiusDraconisAPI.Security;
using ImperiusDraconisAPI.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace ImperiusDraconisAPI.Controllers;

[ApiController]
[Authorize]
[Route("api/[controller]")]
public sealed class ProductosController : ControllerBase
{
    private readonly ProductosService _productosService;

    public ProductosController(ProductosService productosService)
    {
        _productosService = productosService;
    }

    [HttpGet]
    [HasPermission("Productos:Index")]
    public async Task<ActionResult> Get(CancellationToken cancellationToken)
    {
        return Ok(await _productosService.GetAsync(cancellationToken));
    }

    [HttpGet("{idProducto:int}")]
    [HasPermission("Productos:Detalles")]
    public async Task<ActionResult<ProductoDto>> GetById(int idProducto, CancellationToken cancellationToken)
    {
        var result = await _productosService.GetByIdAsync(idProducto, cancellationToken);
        return result is null ? NotFound() : Ok(result);
    }

    [HttpPost]
    [HasPermission("Productos:Crear")]
    public async Task<ActionResult<ProductoDto>> Create(
        [FromForm] SaveProductoRequest request,
        CancellationToken cancellationToken)
    {
        try
        {
            var result = await _productosService.CreateAsync(request, cancellationToken);
            return CreatedAtAction(nameof(GetById), new { idProducto = result.IdProducto }, result);
        }
        catch (BusinessRuleException exception)
        {
            return BadRequest(new { message = exception.Message });
        }
    }

    [HttpPut("{idProducto:int}")]
    [HasPermission("Productos:Editar")]
    public async Task<ActionResult> Update(
        int idProducto,
        [FromForm] SaveProductoRequest request,
        CancellationToken cancellationToken)
    {
        try
        {
            var updated = await _productosService.UpdateAsync(idProducto, request, cancellationToken);
            return updated ? NoContent() : NotFound();
        }
        catch (BusinessRuleException exception)
        {
            return BadRequest(new { message = exception.Message });
        }
    }

    [HttpDelete("{idProducto:int}")]
    [HasPermission("Productos:Eliminar", "Productos:EliminarConfirmado")]
    public async Task<ActionResult> Delete(int idProducto, CancellationToken cancellationToken)
    {
        try
        {
            var deleted = await _productosService.DeleteAsync(idProducto, cancellationToken);
            return deleted ? NoContent() : NotFound();
        }
        catch (BusinessRuleException exception)
        {
            return BadRequest(new { message = exception.Message });
        }
    }
}
