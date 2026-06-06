using System.Security.Claims;
using ImperiusDraconisAPI.Common;
using ImperiusDraconisAPI.Models.Dracoins;
using ImperiusDraconisAPI.Security;
using ImperiusDraconisAPI.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace ImperiusDraconisAPI.Controllers;

[ApiController]
[Authorize]
[Route("api/[controller]")]
public sealed class DracoinsController : ControllerBase
{
    private readonly DracoinsService _dracoinsService;

    public DracoinsController(DracoinsService dracoinsService)
    {
        _dracoinsService = dracoinsService;
    }

    [HttpGet("resumen")]
    [HasPermission("Dracoins:Index")]
    [ProducesResponseType(typeof(DracoinSummaryDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult<DracoinSummaryDto>> GetSummary(CancellationToken cancellationToken)
    {
        var summary = await _dracoinsService.GetSummaryAsync(GetCurrentUserId(), cancellationToken);
        return summary is null ? NotFound() : Ok(summary);
    }

    [HttpPost("transferencias")]
    [HasPermission("Dracoins:TransferirDracoins")]
    [ProducesResponseType(typeof(DracoinTransferDto), StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<ActionResult<DracoinTransferDto>> CreateTransfer(
        [FromBody] DracoinTransferRequest request,
        CancellationToken cancellationToken)
    {
        try
        {
            var transfer = await _dracoinsService.CreateTransferAsync(GetCurrentUserId(), request, cancellationToken);
            return CreatedAtAction(nameof(GetTransferById), new { id = transfer.IdMovimiento }, transfer);
        }
        catch (BusinessRuleException exception)
        {
            return BadRequest(new { message = exception.Message });
        }
    }

    [HttpGet("transferencias")]
    [HasPermission("Dracoins:HistorialTransferencias")]
    [ProducesResponseType(typeof(PagedResult<DracoinTransferDto>), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult<PagedResult<DracoinTransferDto>>> GetTransferHistory(
        [FromQuery] int pagina = 1,
        [FromQuery] int registrosPorPagina = 20,
        CancellationToken cancellationToken = default)
    {
        var result = await _dracoinsService.GetTransferHistoryAsync(
            GetCurrentUserId(),
            pagina,
            registrosPorPagina,
            cancellationToken);

        return result is null ? NotFound() : Ok(result);
    }

    [HttpGet("transferencias/{id:int}")]
    [HasPermission("Dracoins:HistorialTransferencias")]
    [ProducesResponseType(typeof(DracoinTransferDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult<DracoinTransferDto>> GetTransferById(int id, CancellationToken cancellationToken)
    {
        var transfer = await _dracoinsService.GetTransferByIdAsync(id, GetCurrentUserId(), cancellationToken);
        return transfer is null ? NotFound() : Ok(transfer);
    }

    [HttpGet("historial-general")]
    [HasPermission("Dracoins:HistorialGeneral")]
    [ProducesResponseType(typeof(PagedResult<DracoinGeneralMovementDto>), StatusCodes.Status200OK)]
    public async Task<ActionResult<PagedResult<DracoinGeneralMovementDto>>> GetGeneralHistory(
        [FromQuery] string? remitente,
        [FromQuery] string? destinatario,
        [FromQuery] int? montoMin,
        [FromQuery] int? montoMax,
        [FromQuery] string? observacion,
        [FromQuery] DateTime? desde,
        [FromQuery] DateTime? hasta,
        [FromQuery] int pagina = 1,
        [FromQuery] int registrosPorPagina = 20,
        CancellationToken cancellationToken = default)
    {
        return Ok(await _dracoinsService.GetGeneralHistoryAsync(
            remitente,
            destinatario,
            montoMin,
            montoMax,
            observacion,
            desde,
            hasta,
            pagina,
            registrosPorPagina,
            cancellationToken));
    }

    [HttpGet("historial-pagos")]
    [HasPermission("Dracoins:HistorialPagos")]
    [ProducesResponseType(typeof(PagedResult<DracoinAdministrativePaymentDto>), StatusCodes.Status200OK)]
    public async Task<ActionResult<PagedResult<DracoinAdministrativePaymentDto>>> GetAdministrativePayments(
        [FromQuery] int pagina = 1,
        [FromQuery] int registrosPorPagina = 20,
        CancellationToken cancellationToken = default)
    {
        return Ok(await _dracoinsService.GetAdministrativePaymentsAsync(
            pagina,
            registrosPorPagina,
            cancellationToken));
    }

    [HttpGet("sueldos-por-cargo")]
    [HasPermission("Dracoins:SueldosPorCargo")]
    [ProducesResponseType(typeof(IReadOnlyCollection<DracoinSalaryByCargoDto>), StatusCodes.Status200OK)]
    public async Task<ActionResult<IReadOnlyCollection<DracoinSalaryByCargoDto>>> GetSalaryCatalog(
        CancellationToken cancellationToken)
    {
        return Ok(await _dracoinsService.GetSalaryCatalogAsync(cancellationToken));
    }

    [HttpPut("sueldos-por-cargo")]
    [HasPermission("Dracoins:ActualizarSueldos")]
    [ProducesResponseType(typeof(IReadOnlyCollection<DracoinSalaryByCargoDto>), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<ActionResult<IReadOnlyCollection<DracoinSalaryByCargoDto>>> UpdateSalaryCatalog(
        [FromBody] UpdateDracoinSalaryCatalogRequest request,
        CancellationToken cancellationToken)
    {
        try
        {
            return Ok(await _dracoinsService.UpdateSalaryCatalogAsync(request, cancellationToken));
        }
        catch (BusinessRuleException exception)
        {
            return BadRequest(new { message = exception.Message });
        }
    }

    [HttpGet("pagos-manuales")]
    [HasPermission("Dracoins:PagarSueldosManual")]
    [ProducesResponseType(typeof(IReadOnlyCollection<DracoinManualPaymentCandidateDto>), StatusCodes.Status200OK)]
    public async Task<ActionResult<IReadOnlyCollection<DracoinManualPaymentCandidateDto>>> GetManualPaymentCandidates(
        CancellationToken cancellationToken)
    {
        return Ok(await _dracoinsService.GetManualPaymentCandidatesAsync(cancellationToken));
    }

    [HttpPost("pagos-manuales")]
    [HasPermission("Dracoins:PagarSueldosManual")]
    [ProducesResponseType(typeof(DracoinManualPaymentsResultDto), StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<ActionResult<DracoinManualPaymentsResultDto>> CreateManualPayments(
        [FromBody] CreateDracoinManualPaymentsRequest request,
        CancellationToken cancellationToken)
    {
        try
        {
            var result = await _dracoinsService.CreateManualPaymentsAsync(
                GetCurrentUserId(),
                request,
                cancellationToken);

            return CreatedAtAction(nameof(GetAdministrativePayments), new { pagina = 1, registrosPorPagina = 20 }, result);
        }
        catch (BusinessRuleException exception)
        {
            return BadRequest(new { message = exception.Message });
        }
    }

    private int GetCurrentUserId() =>
        int.TryParse(User.FindFirstValue(ClaimTypes.NameIdentifier), out var idAlumno) ? idAlumno : 0;
}
