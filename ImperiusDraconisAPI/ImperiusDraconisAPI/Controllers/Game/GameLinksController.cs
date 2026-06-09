using System.Security.Claims;
using ImperiusDraconisAPI.Common;
using ImperiusDraconisAPI.Models.Game.Common;
using ImperiusDraconisAPI.Models.Game.Links;
using ImperiusDraconisAPI.Services.Game;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace ImperiusDraconisAPI.Controllers.Game;

[ApiController]
[Authorize]
[Route("api/game/v1/links")]
public sealed class GameLinksController : ControllerBase
{
    private readonly GameLinkService _gameLinkService;

    public GameLinksController(GameLinkService gameLinkService)
    {
        _gameLinkService = gameLinkService;
    }

    /// <summary>
    /// Genera un codigo temporal para vincular la cuenta Imperius autenticada con Roblox.
    /// </summary>
    /// <remarks>
    /// No recibe body. Generar un nuevo codigo revoca cualquier codigo anterior pendiente.
    /// </remarks>
    [HttpPost("code")]
    [ProducesResponseType(typeof(CreateGameLinkCodeResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(GameErrorResponse), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(typeof(GameErrorResponse), StatusCodes.Status409Conflict)]
    public async Task<ActionResult<CreateGameLinkCodeResponse>> CreateCode(CancellationToken cancellationToken)
    {
        if (!TryGetCurrentAlumnoId(out var idAlumno))
        {
            return Unauthorized();
        }

        try
        {
            return Ok(await _gameLinkService.CreateLinkCodeAsync(idAlumno, cancellationToken));
        }
        catch (GameBusinessRuleException exception)
        {
            return Conflict(new GameErrorResponse
            {
                Code = exception.Code,
                Message = exception.Message
            });
        }
        catch (BusinessRuleException exception)
        {
            return BadRequest(new GameErrorResponse
            {
                Code = "BUSINESS_RULE_ERROR",
                Message = exception.Message
            });
        }
    }

    private bool TryGetCurrentAlumnoId(out int idAlumno) =>
        int.TryParse(User.FindFirstValue(ClaimTypes.NameIdentifier), out idAlumno);
}
