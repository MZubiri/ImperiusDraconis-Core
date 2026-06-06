using System.Security.Claims;
using ImperiusDraconisAPI.Common;
using ImperiusDraconisAPI.Models.Dinamicas;
using ImperiusDraconisAPI.Security;
using ImperiusDraconisAPI.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace ImperiusDraconisAPI.Controllers;

[ApiController]
[Authorize]
[Route("api/[controller]")]
public sealed class DinamicasController : ControllerBase
{
    private const string AgendaPermission = "Dinamicas:AgendaIndex";
    private const string DeletePermission = "Dinamicas:Eliminar";
    private const string RegistrarDinamicaPorDracoinsPermission = "Dinamicas:RegistrarDin\u00E1micaPorDracoins";

    private readonly DinamicasService _dinamicasService;

    public DinamicasController(DinamicasService dinamicasService)
    {
        _dinamicasService = dinamicasService;
    }

    [HttpGet]
    [HasPermission("Dinamicas:Index")]
    [ProducesResponseType(typeof(PagedResult<DinamicaListItemDto>), StatusCodes.Status200OK)]
    public async Task<ActionResult<PagedResult<DinamicaListItemDto>>> GetDinamicas(
        [FromQuery] DinamicasQuery query,
        CancellationToken cancellationToken)
    {
        return Ok(await _dinamicasService.GetDinamicasAsync(query, cancellationToken));
    }

    [HttpGet("alumnos-activos")]
    [HasPermission(RegistrarDinamicaPorDracoinsPermission)]
    [ProducesResponseType(typeof(IReadOnlyCollection<AlumnoActivoDto>), StatusCodes.Status200OK)]
    public async Task<ActionResult<IReadOnlyCollection<AlumnoActivoDto>>> GetActiveStudents(
        CancellationToken cancellationToken)
    {
        return Ok(await _dinamicasService.GetActiveStudentsAsync(cancellationToken));
    }

    [HttpGet("agenda")]
    [HasPermission(AgendaPermission)]
    [ProducesResponseType(typeof(IReadOnlyCollection<AgendaDinamicaDto>), StatusCodes.Status200OK)]
    public async Task<ActionResult<IReadOnlyCollection<AgendaDinamicaDto>>> GetAgenda(
        [FromQuery] DateTime? fecha,
        CancellationToken cancellationToken)
    {
        return Ok(await _dinamicasService.GetAgendaAsync(fecha, cancellationToken));
    }

    [HttpGet("agenda/responsables")]
    [HasPermission(AgendaPermission)]
    [ProducesResponseType(typeof(IReadOnlyCollection<AgendaResponsableDto>), StatusCodes.Status200OK)]
    public async Task<ActionResult<IReadOnlyCollection<AgendaResponsableDto>>> GetAgendaResponsables(
        CancellationToken cancellationToken)
    {
        return Ok(await _dinamicasService.GetAgendaResponsablesAsync(cancellationToken));
    }

    [HttpGet("agenda/{id:int}")]
    [HasPermission(AgendaPermission)]
    [ProducesResponseType(typeof(AgendaDinamicaDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult<AgendaDinamicaDto>> GetAgendaItem(int id, CancellationToken cancellationToken)
    {
        var item = await _dinamicasService.GetAgendaItemAsync(id, cancellationToken);
        return item is null ? NotFound() : Ok(item);
    }

    [HttpGet("{id:int}/detalle-puntos")]
    [HasPermission("Dinamicas:DetallePuntos")]
    [ProducesResponseType(typeof(DinamicaPuntosDetailDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult<DinamicaPuntosDetailDto>> GetPointsDetail(int id, CancellationToken cancellationToken)
    {
        var detail = await _dinamicasService.GetPointsDetailAsync(id, cancellationToken);
        return detail is null ? NotFound() : Ok(detail);
    }

    [HttpGet("{id:int}/detalle-dracoins")]
    [HasPermission("Dinamicas:DetalleDracoins")]
    [ProducesResponseType(typeof(DinamicaDracoinsDetailDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult<DinamicaDracoinsDetailDto>> GetDracoinsDetail(
        int id,
        CancellationToken cancellationToken)
    {
        var detail = await _dinamicasService.GetDracoinsDetailAsync(id, cancellationToken);
        return detail is null ? NotFound() : Ok(detail);
    }

    [HttpPost("dracoins")]
    [HasPermission(RegistrarDinamicaPorDracoinsPermission)]
    [ProducesResponseType(typeof(DinamicaDracoinsDetailDto), StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<ActionResult<DinamicaDracoinsDetailDto>> CreateDracoinsDinamica(
        [FromBody] RegistrarDinamicaDracoinsRequest request,
        CancellationToken cancellationToken)
    {
        try
        {
            var result = await _dinamicasService.CreateDracoinsDinamicaAsync(
                GetCurrentUserId(),
                request,
                cancellationToken);

            return CreatedAtAction(nameof(GetDracoinsDetail), new { id = result.IdDinamica }, result);
        }
        catch (BusinessRuleException exception)
        {
            return BadRequest(new { message = exception.Message });
        }
    }

    [HttpPost("agenda/lotes")]
    [HasPermission(AgendaPermission)]
    [ProducesResponseType(typeof(IReadOnlyCollection<AgendaDinamicaDto>), StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<ActionResult<IReadOnlyCollection<AgendaDinamicaDto>>> CreateAgendaBatch(
        [FromBody] AgendaCreateBatchRequest request,
        CancellationToken cancellationToken)
    {
        try
        {
            var items = await _dinamicasService.CreateAgendaBatchAsync(request, cancellationToken);
            return CreatedAtAction(nameof(GetAgenda), new { fecha = request.Fecha?.Date }, items);
        }
        catch (BusinessRuleException exception)
        {
            return BadRequest(new { message = exception.Message });
        }
    }

    [HttpPut("agenda/{id:int}")]
    [HasPermission(AgendaPermission)]
    [ProducesResponseType(typeof(AgendaDinamicaDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult<AgendaDinamicaDto>> UpdateAgenda(
        int id,
        [FromBody] AgendaUpdateRequest request,
        CancellationToken cancellationToken)
    {
        try
        {
            var item = await _dinamicasService.UpdateAgendaAsync(id, request, cancellationToken);
            return item is null ? NotFound() : Ok(item);
        }
        catch (BusinessRuleException exception)
        {
            return BadRequest(new { message = exception.Message });
        }
    }

    [HttpDelete("agenda/{id:int}")]
    [HasPermission(AgendaPermission)]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> DeleteAgenda(int id, CancellationToken cancellationToken)
    {
        return await _dinamicasService.DeleteAgendaAsync(id, cancellationToken) ? NoContent() : NotFound();
    }

    [HttpDelete("agenda")]
    [HasPermission(AgendaPermission)]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    public async Task<IActionResult> ClearAgenda(CancellationToken cancellationToken)
    {
        await _dinamicasService.ClearAgendaAsync(cancellationToken);
        return NoContent();
    }

    [HttpDelete("{id:int}")]
    [HasPermission(DeletePermission)]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> DeleteDinamica(int id, CancellationToken cancellationToken)
    {
        return await _dinamicasService.DeleteDinamicaAsync(id, cancellationToken) ? NoContent() : NotFound();
    }

    private int GetCurrentUserId() =>
        int.TryParse(User.FindFirstValue(ClaimTypes.NameIdentifier), out var idAlumno) ? idAlumno : 0;
}
