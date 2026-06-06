using ImperiusDraconisAPI.Models.Permisos;
using ImperiusDraconisAPI.Common;
using ImperiusDraconisAPI.Security;
using ImperiusDraconisAPI.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace ImperiusDraconisAPI.Controllers;

[ApiController]
[Authorize]
[Route("api/[controller]")]
public sealed class PermisosController : ControllerBase
{
    private readonly PermisosService _permisosService;

    public PermisosController(PermisosService permisosService)
    {
        _permisosService = permisosService;
    }

    [HttpGet("cargos")]
    [HasPermission("Permisos:Index", "Permisos:Guardar")]
    public async Task<ActionResult> GetCargos(CancellationToken cancellationToken)
    {
        return Ok(await _permisosService.GetCargosAsync(cancellationToken));
    }

    [HttpGet("{idCargo:int}")]
    [HasPermission("Permisos:Index", "Permisos:Guardar")]
    public async Task<ActionResult<PermisoCargoDto>> GetByCargo(int idCargo, CancellationToken cancellationToken)
    {
        var result = await _permisosService.GetByCargoAsync(idCargo, cancellationToken);
        return result is null ? NotFound() : Ok(result);
    }

    [HttpPut("{idCargo:int}")]
    [HasPermission("Permisos:Guardar")]
    public async Task<ActionResult<PermisoCargoDto>> Update(
        int idCargo,
        [FromBody] UpdatePermisoCargoRequest request,
        CancellationToken cancellationToken)
    {
        var result = await _permisosService.UpdateAsync(idCargo, request, cancellationToken);
        return result is null ? NotFound() : Ok(result);
    }

    [HttpPost]
    [HasPermission("Permisos:Guardar")]
    public async Task<IActionResult> Create(
        [FromBody] CreatePermisoRequest request,
        CancellationToken cancellationToken)
    {
        try
        {
            await _permisosService.CreateAsync(request, cancellationToken);
            return NoContent();
        }
        catch (BusinessRuleException exception)
        {
            return BadRequest(new { message = exception.Message });
        }
    }
}
