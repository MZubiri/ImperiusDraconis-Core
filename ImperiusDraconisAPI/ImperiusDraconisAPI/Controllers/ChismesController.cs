using System.Security.Claims;
using ImperiusDraconisAPI.Common;
using ImperiusDraconisAPI.Models.Chismes;
using ImperiusDraconisAPI.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace ImperiusDraconisAPI.Controllers;

[ApiController]
[Authorize]
[Route("api/[controller]")]
public sealed class ChismesController : ControllerBase
{
    private readonly ChismesService _chismesService;

    public ChismesController(ChismesService chismesService)
    {
        _chismesService = chismesService;
    }

    [HttpGet]
    [ProducesResponseType(typeof(PagedResult<ChismeDto>), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    public async Task<ActionResult<PagedResult<ChismeDto>>> Get(
        [FromQuery] ChismeQuery query,
        CancellationToken cancellationToken)
    {
        if (!_chismesService.CanReview(GetCurrentUserId()))
        {
            return Forbid();
        }

        return Ok(await _chismesService.GetAsync(query, cancellationToken));
    }

    [HttpPost]
    [ProducesResponseType(typeof(ChismeCreateResultDto), StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<ActionResult<ChismeCreateResultDto>> Create(
        [FromForm] CreateChismeRequest request,
        CancellationToken cancellationToken)
    {
        try
        {
            var result = await _chismesService.CreateAsync(GetCurrentUserId(), request, cancellationToken);
            return CreatedAtAction(nameof(Get), result);
        }
        catch (BusinessRuleException exception)
        {
            return BadRequest(new { message = exception.Message });
        }
    }

    private int GetCurrentUserId() =>
        int.TryParse(User.FindFirstValue(ClaimTypes.NameIdentifier), out var idAlumno) ? idAlumno : 0;
}
