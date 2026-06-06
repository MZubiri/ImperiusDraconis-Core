using ImperiusDraconisAPI.Common;
using ImperiusDraconisAPI.Models.Trabajos;
using ImperiusDraconisAPI.Security;
using ImperiusDraconisAPI.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace ImperiusDraconisAPI.Controllers;

[ApiController]
[Authorize]
[Route("api/[controller]")]
public sealed class TrabajosController : ControllerBase
{
    private readonly TrabajosService _trabajosService;

    public TrabajosController(TrabajosService trabajosService)
    {
        _trabajosService = trabajosService;
    }

    [HttpGet("catalogos")]
    [HasPermission("Trabajos:Index", "Trabajos:AsignarAlumnos", "Trabajos:AsignarPermisos", "Permisos:Guardar")]
    public async Task<ActionResult<TrabajoCatalogsDto>> GetCatalogs(CancellationToken cancellationToken)
    {
        return Ok(await _trabajosService.GetCatalogsAsync(cancellationToken));
    }

    [HttpGet]
    [HasPermission("Trabajos:Index", "Trabajos:AsignarPermisos", "Permisos:Guardar")]
    public async Task<ActionResult<IReadOnlyCollection<TrabajoOptionDto>>> GetAll(CancellationToken cancellationToken)
    {
        return Ok(await _trabajosService.GetAllAsync(cancellationToken));
    }

    [HttpPost]
    [HasPermission("Trabajos:Crear", "Permisos:Guardar")]
    public async Task<ActionResult<TrabajoOptionDto>> Create(
        [FromBody] SaveTrabajoRequest request,
        CancellationToken cancellationToken)
    {
        try
        {
            var result = await _trabajosService.CreateAsync(request, cancellationToken);
            return CreatedAtAction(nameof(GetAll), new { id = result.IdTrabajo }, result);
        }
        catch (BusinessRuleException exception)
        {
            return BadRequest(new { message = exception.Message });
        }
    }

    [HttpPut("{idTrabajo:int}")]
    [HasPermission("Trabajos:Editar", "Permisos:Guardar")]
    public async Task<ActionResult<TrabajoOptionDto>> Update(
        int idTrabajo,
        [FromBody] SaveTrabajoRequest request,
        CancellationToken cancellationToken)
    {
        try
        {
            var result = await _trabajosService.UpdateAsync(idTrabajo, request, cancellationToken);
            return result is null ? NotFound() : Ok(result);
        }
        catch (BusinessRuleException exception)
        {
            return BadRequest(new { message = exception.Message });
        }
    }

    [HttpDelete("{idTrabajo:int}")]
    [HasPermission("Trabajos:Eliminar", "Permisos:Guardar")]
    public async Task<IActionResult> Delete(int idTrabajo, CancellationToken cancellationToken)
    {
        return await _trabajosService.DeleteAsync(idTrabajo, cancellationToken) ? NoContent() : NotFound();
    }

    [HttpGet("asignaciones/{idAlumno:int}")]
    [HasPermission("Trabajos:AsignarAlumnos", "Permisos:Guardar")]
    public async Task<ActionResult<TrabajoAlumnoAssignmentsDto>> GetAssignments(
        int idAlumno,
        CancellationToken cancellationToken)
    {
        var result = await _trabajosService.GetAssignmentsAsync(idAlumno, cancellationToken);
        return result is null ? NotFound() : Ok(result);
    }

    [HttpPut("asignaciones/{idAlumno:int}")]
    [HasPermission("Trabajos:AsignarAlumnos", "Permisos:Guardar")]
    public async Task<ActionResult<TrabajoAlumnoAssignmentsDto>> UpdateAssignments(
        int idAlumno,
        [FromBody] SaveTrabajoAssignmentsRequest request,
        CancellationToken cancellationToken)
    {
        try
        {
            var result = await _trabajosService.UpdateAssignmentsAsync(idAlumno, request, cancellationToken);
            return result is null ? NotFound() : Ok(result);
        }
        catch (BusinessRuleException exception)
        {
            return BadRequest(new { message = exception.Message });
        }
    }

    [HttpGet("{idTrabajo:int}/permisos")]
    [HasPermission("Trabajos:AsignarPermisos", "Permisos:Guardar")]
    public async Task<ActionResult<TrabajoPermisosDto>> GetPermissions(
        int idTrabajo,
        CancellationToken cancellationToken)
    {
        var result = await _trabajosService.GetPermissionsAsync(idTrabajo, cancellationToken);
        return result is null ? NotFound() : Ok(result);
    }

    [HttpPut("{idTrabajo:int}/permisos")]
    [HasPermission("Trabajos:AsignarPermisos", "Permisos:Guardar")]
    public async Task<ActionResult<TrabajoPermisosDto>> UpdatePermissions(
        int idTrabajo,
        [FromBody] UpdateTrabajoPermisosRequest request,
        CancellationToken cancellationToken)
    {
        try
        {
            var result = await _trabajosService.UpdatePermissionsAsync(idTrabajo, request, cancellationToken);
            return result is null ? NotFound() : Ok(result);
        }
        catch (BusinessRuleException exception)
        {
            return BadRequest(new { message = exception.Message });
        }
    }
}
