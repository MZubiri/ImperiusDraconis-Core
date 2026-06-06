using System.Security.Claims;
using ImperiusDraconisAPI.Common;
using ImperiusDraconisAPI.Models.Marcadores;
using ImperiusDraconisAPI.Security;
using ImperiusDraconisAPI.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace ImperiusDraconisAPI.Controllers;

[ApiController]
[Authorize]
[Route("api/[controller]")]
public sealed class MarcadoresController : ControllerBase
{
    private const string UpdatePermission = "Marcadores:ActualizarMarcador";
    private const string AdjustmentPermission = "Marcadores:AjustesPuntos";

    private readonly MarcadoresService _marcadoresService;

    public MarcadoresController(MarcadoresService marcadoresService)
    {
        _marcadoresService = marcadoresService;
    }

    [HttpGet("actual")]
    [HasPermission("Marcadores:MarcadorActual")]
    [ProducesResponseType(typeof(IReadOnlyCollection<MarcadorCasaDto>), StatusCodes.Status200OK)]
    public async Task<ActionResult<IReadOnlyCollection<MarcadorCasaDto>>> GetCurrent(CancellationToken cancellationToken)
    {
        return Ok(await _marcadoresService.GetCurrentAsync(cancellationToken));
    }

    [HttpGet("casas")]
    [HasPermission(UpdatePermission, AdjustmentPermission)]
    [ProducesResponseType(typeof(IReadOnlyCollection<MarcadorCasaDto>), StatusCodes.Status200OK)]
    public async Task<ActionResult<IReadOnlyCollection<MarcadorCasaDto>>> GetHouses(CancellationToken cancellationToken)
    {
        return Ok(await _marcadoresService.GetCurrentAsync(cancellationToken));
    }

    [HttpGet("historial")]
    [HasPermission("Marcadores:Historial")]
    [ProducesResponseType(typeof(PagedResult<HistorialMarcadorDto>), StatusCodes.Status200OK)]
    public async Task<ActionResult<PagedResult<HistorialMarcadorDto>>> GetHistory(
        [FromQuery] int pagina = 1,
        [FromQuery] int registrosPorPagina = 20,
        CancellationToken cancellationToken = default)
    {
        return Ok(await _marcadoresService.GetHistoryAsync(pagina, registrosPorPagina, cancellationToken));
    }

    [HttpPost("actualizaciones")]
    [HasPermission(UpdatePermission)]
    [ProducesResponseType(typeof(MarcadorUpdateResultDto), StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<ActionResult<MarcadorUpdateResultDto>> CreateUpdate(
        [FromBody] MarcadorUpdateRequest request,
        CancellationToken cancellationToken)
    {
        try
        {
            var result = await _marcadoresService.CreateUpdateAsync(
                GetCurrentUserId(),
                request,
                cancellationToken);

            return CreatedAtAction(nameof(GetCurrent), result);
        }
        catch (BusinessRuleException exception)
        {
            return BadRequest(new { message = exception.Message });
        }
    }

    [HttpPost("ajustes-puntos")]
    [HasPermission(AdjustmentPermission)]
    [ProducesResponseType(typeof(MarcadorAdjustmentResultDto), StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<ActionResult<MarcadorAdjustmentResultDto>> CreateAdjustment(
        [FromBody] MarcadorAdjustmentRequest request,
        CancellationToken cancellationToken)
    {
        try
        {
            var result = await _marcadoresService.CreateAdjustmentAsync(
                GetCurrentUserId(),
                request,
                cancellationToken);

            return CreatedAtAction(nameof(GetCurrent), result);
        }
        catch (BusinessRuleException exception)
        {
            return BadRequest(new { message = exception.Message });
        }
    }

    [HttpPost("cierres")]
    [HasPermission(AdjustmentPermission)]
    [ProducesResponseType(typeof(MarcadorCloseResultDto), StatusCodes.Status200OK)]
    public async Task<ActionResult<MarcadorCloseResultDto>> CloseScoreboard(CancellationToken cancellationToken)
    {
        return Ok(await _marcadoresService.CloseScoreboardAsync(cancellationToken));
    }

    private int GetCurrentUserId() =>
        int.TryParse(User.FindFirstValue(ClaimTypes.NameIdentifier), out var idAlumno) ? idAlumno : 0;
}
