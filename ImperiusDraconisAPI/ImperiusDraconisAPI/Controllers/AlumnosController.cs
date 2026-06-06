using ImperiusDraconisAPI.Common;
using ImperiusDraconisAPI.Models.Alumnos;
using ImperiusDraconisAPI.Security;
using ImperiusDraconisAPI.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace ImperiusDraconisAPI.Controllers;

[ApiController]
[Authorize]
[Route("api/[controller]")]
public sealed class AlumnosController : ControllerBase
{
    private readonly AlumnosService _alumnosService;

    public AlumnosController(AlumnosService alumnosService)
    {
        _alumnosService = alumnosService;
    }

    [HttpGet]
    [HasPermission("Alumnos:Index")]
    [ProducesResponseType(typeof(PagedResult<AlumnoListItemDto>), StatusCodes.Status200OK)]
    public async Task<ActionResult<PagedResult<AlumnoListItemDto>>> Get(
        [FromQuery] AlumnoQuery query,
        CancellationToken cancellationToken)
    {
        return Ok(await _alumnosService.GetAsync(query, cancellationToken));
    }

    [HttpGet("{id:int}")]
    [HasPermission("Alumnos:Index", "Alumnos:Detalle")]
    [ProducesResponseType(typeof(AlumnoDetailDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult<AlumnoDetailDto>> GetById(int id, CancellationToken cancellationToken)
    {
        var alumno = await _alumnosService.GetByIdAsync(id, cancellationToken);
        return alumno is null ? NotFound() : Ok(alumno);
    }

    [HttpPost]
    [HasPermission("Alumnos:Crear")]
    [ProducesResponseType(typeof(AlumnoDetailDto), StatusCodes.Status201Created)]
    public async Task<ActionResult> Create(
        [FromBody] SaveAlumnoRequest request,
        CancellationToken cancellationToken)
    {
        var id = await _alumnosService.CreateAsync(request, cancellationToken);
        var alumno = await _alumnosService.GetByIdAsync(id, cancellationToken);
        return CreatedAtAction(nameof(GetById), new { id }, alumno);
    }

    [HttpPut("{id:int}")]
    [HasPermission("Alumnos:Editar")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult> Update(
        int id,
        [FromBody] SaveAlumnoRequest request,
        CancellationToken cancellationToken)
    {
        var updated = await _alumnosService.UpdateAsync(id, request, cancellationToken);
        return updated ? NoContent() : NotFound();
    }

    [HttpPatch("{id:int}/estado")]
    [HasPermission("Alumnos:Editar")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult> ChangeEstado(
        int id,
        [FromBody] ChangeEstadoRequest request,
        CancellationToken cancellationToken)
    {
        var updated = await _alumnosService.ChangeStatusAsync(id, request.Activo, cancellationToken);
        return updated ? NoContent() : NotFound();
    }

    [HttpDelete("{id:int}")]
    [HasPermission("Alumnos:Eliminar")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult> Delete(int id, CancellationToken cancellationToken)
    {
        var deleted = await _alumnosService.DeleteAsync(id, cancellationToken);
        return deleted ? NoContent() : NotFound();
    }

    [HttpGet("{id:int}/notas")]
    [HasPermission("Alumnos:Notas")]
    [ProducesResponseType(typeof(IReadOnlyCollection<AlumnoNoteDto>), StatusCodes.Status200OK)]
    public async Task<ActionResult<IReadOnlyCollection<AlumnoNoteDto>>> GetNotas(
        int id,
        CancellationToken cancellationToken)
    {
        return Ok(await _alumnosService.GetNotasAsync(id, cancellationToken));
    }

    [HttpPost("{id:int}/notas")]
    [HasPermission("Alumnos:Notas")]
    [ProducesResponseType(typeof(AlumnoNoteDto), StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<ActionResult<AlumnoNoteDto>> CreateNota(
        int id,
        [FromBody] CreateAlumnoNoteRequest request,
        CancellationToken cancellationToken)
    {
        try
        {
            var note = await _alumnosService.CreateNotaAsync(id, request, cancellationToken);
            return CreatedAtAction(nameof(GetNotas), new { id }, note);
        }
        catch (BusinessRuleException exception)
        {
            return BadRequest(new { message = exception.Message });
        }
    }

    [HttpPut("{id:int}/contrasena")]
    [HasPermission("Alumnos:CambiarContraseña")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult> ResetPassword(
        int id,
        [FromBody] ResetAlumnoPasswordRequest request,
        CancellationToken cancellationToken)
    {
        var updated = await _alumnosService.ResetPasswordAsync(id, request.NuevaContrasena, cancellationToken);
        return updated ? NoContent() : NotFound();
    }

    [HttpGet("casas")]
    [HasPermission("Alumnos:Index", "Alumnos:Crear", "Alumnos:Editar")]
    [ProducesResponseType(typeof(IReadOnlyCollection<CatalogItemDto>), StatusCodes.Status200OK)]
    public async Task<ActionResult<IReadOnlyCollection<CatalogItemDto>>> GetCasas(CancellationToken cancellationToken)
    {
        return Ok(await _alumnosService.GetCasasAsync(cancellationToken));
    }

    [HttpGet("cargos")]
    [HasPermission("Alumnos:Index", "Alumnos:Crear", "Alumnos:Editar")]
    [ProducesResponseType(typeof(IReadOnlyCollection<CatalogItemDto>), StatusCodes.Status200OK)]
    public async Task<ActionResult<IReadOnlyCollection<CatalogItemDto>>> GetCargos(CancellationToken cancellationToken)
    {
        return Ok(await _alumnosService.GetCargosAsync(cancellationToken));
    }

    [HttpGet("siguiente-codigo/{idCasa:int}")]
    [HasPermission("Alumnos:Crear")]
    public async Task<ActionResult> GetSiguienteCodigo(int idCasa, CancellationToken cancellationToken)
    {
        var codigo = await _alumnosService.GetNextCodeAsync(idCasa, cancellationToken);
        return Ok(new { codigo });
    }
}
