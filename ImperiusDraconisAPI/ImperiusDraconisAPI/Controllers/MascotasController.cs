using ImperiusDraconisAPI.Common;
using ImperiusDraconisAPI.Models.Mascotas;
using ImperiusDraconisAPI.Security;
using ImperiusDraconisAPI.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace ImperiusDraconisAPI.Controllers;

[ApiController]
[Authorize]
[Route("api/[controller]")]
public sealed class MascotasController : ControllerBase
{
    private readonly MascotasService _mascotasService;

    public MascotasController(MascotasService mascotasService)
    {
        _mascotasService = mascotasService;
    }

    [HttpGet("resumen")]
    [HasPermission("Mascotas:Index")]
    [ProducesResponseType(typeof(MascotaSummaryDto), StatusCodes.Status200OK)]
    public async Task<ActionResult<MascotaSummaryDto>> GetSummary(CancellationToken cancellationToken)
    {
        return Ok(await _mascotasService.GetSummaryAsync(cancellationToken));
    }

    [HttpGet("catalogo")]
    [HasPermission("Mascotas:Catalogo")]
    [ProducesResponseType(typeof(IReadOnlyCollection<MascotaCatalogItemDto>), StatusCodes.Status200OK)]
    public async Task<ActionResult<IReadOnlyCollection<MascotaCatalogItemDto>>> GetCatalog(
        [FromQuery] bool? activo,
        CancellationToken cancellationToken)
    {
        return Ok(await _mascotasService.GetCatalogAsync(activo, cancellationToken));
    }

    [HttpGet("catalogos-formulario")]
    [HasPermission("Mascotas:AgregarMascotaPorAlumno", "Mascotas:EditarMascotaPorAlumno", "Mascotas:CambiarEstado")]
    [ProducesResponseType(typeof(MascotaFormCatalogsDto), StatusCodes.Status200OK)]
    public async Task<ActionResult<MascotaFormCatalogsDto>> GetFormCatalogs(CancellationToken cancellationToken)
    {
        return Ok(await _mascotasService.GetFormCatalogsAsync(cancellationToken));
    }

    [HttpGet("asignaciones")]
    [HasPermission(
        "Mascotas:Index",
        "Mascotas:EstadoPorAlumno",
        "Mascotas:MascotasPorAlumno",
        "Mascotas:AgregarMascotaPorAlumno",
        "Mascotas:EditarMascotaPorAlumno",
        "Mascotas:EliminarMascotaPorAlumno",
        "Mascotas:CambiarEstado")]
    [ProducesResponseType(typeof(IReadOnlyCollection<MascotaAssignmentDto>), StatusCodes.Status200OK)]
    public async Task<ActionResult<IReadOnlyCollection<MascotaAssignmentDto>>> GetAssignments(
        [FromQuery] string? filtroEstado,
        [FromQuery] string? busqueda,
        [FromQuery] bool? soloPendientesCobro,
        CancellationToken cancellationToken)
    {
        return Ok(await _mascotasService.GetAssignmentsAsync(
            filtroEstado,
            busqueda,
            soloPendientesCobro,
            cancellationToken));
    }

    [HttpGet("asignaciones/{idMascotaAlumno:int}")]
    [HasPermission(
        "Mascotas:Index",
        "Mascotas:EstadoPorAlumno",
        "Mascotas:MascotasPorAlumno",
        "Mascotas:AgregarMascotaPorAlumno",
        "Mascotas:EditarMascotaPorAlumno",
        "Mascotas:EliminarMascotaPorAlumno",
        "Mascotas:CambiarEstado")]
    [ProducesResponseType(typeof(MascotaAssignmentDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult<MascotaAssignmentDto>> GetAssignmentById(
        int idMascotaAlumno,
        CancellationToken cancellationToken)
    {
        var assignment = await _mascotasService.GetAssignmentByIdAsync(idMascotaAlumno, cancellationToken);
        return assignment is null ? NotFound() : Ok(assignment);
    }

    [HttpPost("asignaciones")]
    [HasPermission("Mascotas:AgregarMascotaPorAlumno")]
    [ProducesResponseType(typeof(MascotaAssignmentDto), StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<ActionResult<MascotaAssignmentDto>> CreateAssignment(
        [FromBody] SaveMascotaAssignmentRequest request,
        CancellationToken cancellationToken)
    {
        try
        {
            var assignment = await _mascotasService.CreateAssignmentAsync(request, cancellationToken);
            return CreatedAtAction(nameof(GetAssignmentById), new { idMascotaAlumno = assignment.IdMascotaAlumno }, assignment);
        }
        catch (BusinessRuleException exception)
        {
            return BadRequest(new { message = exception.Message });
        }
    }

    [HttpPut("asignaciones/{idMascotaAlumno:int}")]
    [HasPermission("Mascotas:EditarMascotaPorAlumno")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult> UpdateAssignment(
        int idMascotaAlumno,
        [FromBody] SaveMascotaAssignmentRequest request,
        CancellationToken cancellationToken)
    {
        try
        {
            var updated = await _mascotasService.UpdateAssignmentAsync(idMascotaAlumno, request, cancellationToken);
            return updated ? NoContent() : NotFound();
        }
        catch (BusinessRuleException exception)
        {
            return BadRequest(new { message = exception.Message });
        }
    }

    [HttpPatch("asignaciones/{idMascotaAlumno:int}/estado")]
    [HasPermission("Mascotas:CambiarEstado")]
    [ProducesResponseType(typeof(MascotaAssignmentDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult<MascotaAssignmentDto>> ChangeState(
        int idMascotaAlumno,
        [FromBody] ChangeMascotaStateRequest request,
        CancellationToken cancellationToken)
    {
        try
        {
            var assignment = await _mascotasService.ChangeStateAsync(idMascotaAlumno, request, cancellationToken);
            return assignment is null ? NotFound() : Ok(assignment);
        }
        catch (BusinessRuleException exception)
        {
            return BadRequest(new { message = exception.Message });
        }
    }

    [HttpDelete("asignaciones/{idMascotaAlumno:int}")]
    [HasPermission("Mascotas:EliminarMascotaPorAlumno")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult> DeleteAssignment(int idMascotaAlumno, CancellationToken cancellationToken)
    {
        var deleted = await _mascotasService.DeleteAssignmentAsync(idMascotaAlumno, cancellationToken);
        return deleted ? NoContent() : NotFound();
    }

    [HttpGet("cobro-semanal")]
    [HasPermission("Mascotas:CobroSemanal", "Mascotas:ProcesarCobro")]
    [ProducesResponseType(typeof(IReadOnlyCollection<MascotaWeeklyChargeCandidateDto>), StatusCodes.Status200OK)]
    public async Task<ActionResult<IReadOnlyCollection<MascotaWeeklyChargeCandidateDto>>> GetWeeklyChargeCandidates(
        CancellationToken cancellationToken)
    {
        return Ok(await _mascotasService.GetWeeklyChargeCandidatesAsync(cancellationToken));
    }

    [HttpPost("cobro-semanal")]
    [HasPermission("Mascotas:ProcesarCobro", "Mascotas:CobroSemanal")]
    [ProducesResponseType(typeof(MascotaWeeklyChargeResultDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<ActionResult<MascotaWeeklyChargeResultDto>> ProcessWeeklyCharges(
        [FromBody] ProcessMascotaWeeklyChargeRequest request,
        CancellationToken cancellationToken)
    {
        try
        {
            return Ok(await _mascotasService.ProcessWeeklyChargesAsync(request, cancellationToken));
        }
        catch (BusinessRuleException exception)
        {
            return BadRequest(new { message = exception.Message });
        }
    }

    [HttpGet("matriz")]
    [HasPermission("Mascotas:Index", "Mascotas:EstadoPorAlumno", "Mascotas:MascotasPorAlumno", "Mascotas:CambiarEstado")]
    [ProducesResponseType(typeof(IReadOnlyCollection<MascotaMatrixRowDto>), StatusCodes.Status200OK)]
    public async Task<ActionResult<IReadOnlyCollection<MascotaMatrixRowDto>>> GetMatrix(CancellationToken cancellationToken)
    {
        return Ok(await _mascotasService.GetMatrixAsync(cancellationToken));
    }
}
