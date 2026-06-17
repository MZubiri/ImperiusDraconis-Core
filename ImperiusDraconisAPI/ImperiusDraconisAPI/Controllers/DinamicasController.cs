using System.Security.Claims;
using System.Collections.Concurrent;
using ImperiusDraconisAPI.Common;
using ImperiusDraconisAPI.Models.Dinamicas;
using ImperiusDraconisAPI.Security;
using ImperiusDraconisAPI.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace ImperiusDraconisAPI.Controllers;

[ApiController]
[Authorize]
[Route("api/dinamicas")]
public sealed class DinamicasController : ControllerBase
{
    private const string AgendaPermission = "Dinamicas:AgendaIndex";
    private const string DeletePermission = "Dinamicas:Eliminar";
    private const string RegistrarDinamicaPorDracoinsPermission = "Dinamicas:RegistrarDin\u00E1micaPorDracoins";
    private const string RegistrarPuntosPermission = "Marcadores:ActualizarMarcador";
    private static readonly ConcurrentDictionary<string, DateTimeOffset> AutomaticRegistrations = new();
    private static readonly TimeSpan AutomaticRegistrationRetention = TimeSpan.FromHours(24);

    private readonly DinamicasService _dinamicasService;
    private readonly MarcadoresService _marcadoresService;
    private readonly AutomaticHousePointsService _automaticHousePointsService;
    private readonly AutomaticDracoinsCounterService _automaticDracoinsCounterService;
    private readonly ILogger<DinamicasController> _logger;

    public DinamicasController(
        DinamicasService dinamicasService,
        MarcadoresService marcadoresService,
        AutomaticHousePointsService automaticHousePointsService,
        AutomaticDracoinsCounterService automaticDracoinsCounterService,
        ILogger<DinamicasController> logger)
    {
        _dinamicasService = dinamicasService;
        _marcadoresService = marcadoresService;
        _automaticHousePointsService = automaticHousePointsService;
        _automaticDracoinsCounterService = automaticDracoinsCounterService;
        _logger = logger;
    }

    [HttpPost("dracoins-contador/analizar")]
    [HasPermission(RegistrarDinamicaPorDracoinsPermission, RegistrarPuntosPermission)]
    [ProducesResponseType(typeof(AutomaticDracoinsAnalyzeResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public ActionResult<AutomaticDracoinsAnalyzeResponse> AnalyzeDracoinsCounter(
        [FromBody] AutomaticDracoinsAnalyzeRequest request)
    {
        try
        {
            return Ok(_automaticDracoinsCounterService.Analyze(request));
        }
        catch (BusinessRuleException exception)
        {
            return BadRequest(new { message = exception.Message });
        }
        catch (Exception exception)
        {
            _logger.LogError(exception, "Error interno al analizar contador de Dracoins.");
            throw;
        }
    }

    [HttpPost("puntos-automaticos/analizar")]
    [HasPermission(RegistrarPuntosPermission)]
    [ProducesResponseType(typeof(AutomaticPointsAnalysisDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<ActionResult<AutomaticPointsAnalysisDto>> AnalyzeAutomaticPoints(
        [FromBody] AutomaticPointsAnalyzeRequest request,
        CancellationToken cancellationToken)
    {
        try
        {
            var houses = await _marcadoresService.GetCurrentAsync(cancellationToken);
            return Ok(_automaticHousePointsService.Analyze(request, houses));
        }
        catch (BusinessRuleException exception)
        {
            return BadRequest(new { message = exception.Message });
        }
        catch (Exception exception)
        {
            _logger.LogError(exception, "Error interno al analizar puntos automaticos.");
            throw;
        }
    }

    [HttpPost("puntos-automaticos/registrar")]
    [HasPermission(RegistrarPuntosPermission)]
    [ProducesResponseType(typeof(Models.Marcadores.MarcadorUpdateResultDto), StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status409Conflict)]
    public async Task<ActionResult<Models.Marcadores.MarcadorUpdateResultDto>> RegisterAutomaticPoints(
        [FromBody] AutomaticPointsRegisterRequest request,
        CancellationToken cancellationToken)
    {
        var requestId = request.ClientRequestId.Trim();
        var now = DateTimeOffset.UtcNow;
        foreach (var registration in AutomaticRegistrations.Where(item => now - item.Value > AutomaticRegistrationRetention))
        {
            AutomaticRegistrations.TryRemove(registration.Key, out _);
        }

        if (!AutomaticRegistrations.TryAdd(requestId, now))
        {
            return Conflict(new { message = "Esta dinamica automatica ya fue registrada." });
        }

        try
        {
            var houses = await _marcadoresService.GetCurrentAsync(cancellationToken);
            var analysis = _automaticHousePointsService.Analyze(request, houses);
            var result = await _marcadoresService.CreateUpdateAsync(
                GetCurrentUserId(),
                new Models.Marcadores.MarcadorUpdateRequest
                {
                    NombreDinamica = request.Name,
                    SubtipoDinamica = request.Subtype,
                    Observacion = request.Observation,
                    PuntosPorCasa = analysis.Totals.Select(item => new Models.Marcadores.MarcadorUpdateItemRequest
                    {
                        IdCasa = item.IdCasa,
                        Puntos = item.Points
                    }).ToList()
                },
                cancellationToken);

            return CreatedAtAction(nameof(GetPointsDetail), new { id = result.IdDinamica }, result);
        }
        catch (BusinessRuleException exception)
        {
            AutomaticRegistrations.TryRemove(requestId, out _);
            return BadRequest(new { message = exception.Message });
        }
        catch (Exception exception)
        {
            AutomaticRegistrations.TryRemove(requestId, out _);
            _logger.LogError(
                exception,
                "Error interno al analizar o registrar puntos automaticos para la solicitud {RequestId}.",
                requestId);
            throw;
        }
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
    [HasPermission(RegistrarDinamicaPorDracoinsPermission, RegistrarPuntosPermission)]
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
