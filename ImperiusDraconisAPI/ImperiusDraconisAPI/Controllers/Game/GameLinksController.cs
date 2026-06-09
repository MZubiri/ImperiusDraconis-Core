using System.Security.Claims;
using ImperiusDraconisAPI.Common;
using ImperiusDraconisAPI.Models.Game.Common;
using ImperiusDraconisAPI.Models.Game.Links;
using ImperiusDraconisAPI.Security;
using ImperiusDraconisAPI.Services.Game;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace ImperiusDraconisAPI.Controllers.Game;

[ApiController]
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
    [Authorize]
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
            return StatusCode(exception.StatusCode, new GameErrorResponse
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

    /// <summary>
    /// Consume un codigo temporal y vincula un jugador Roblox con Imperius.
    /// </summary>
    /// <remarks>
    /// Requiere X-Game-Api-Key y una X-Idempotency-Key unica para la solicitud.
    /// </remarks>
    [HttpPost("consume")]
    [Authorize(AuthenticationSchemes = GameApiKeyAuthenticationDefaults.AuthenticationScheme)]
    [ProducesResponseType(typeof(ConsumeGameLinkCodeResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(GameErrorResponse), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(typeof(GameErrorResponse), StatusCodes.Status403Forbidden)]
    [ProducesResponseType(typeof(GameErrorResponse), StatusCodes.Status409Conflict)]
    public async Task<ActionResult<ConsumeGameLinkCodeResponse>> ConsumeCode(
        [FromBody] ConsumeGameLinkCodeRequest request,
        [FromHeader(Name = "X-Idempotency-Key")] string? idempotencyKey,
        CancellationToken cancellationToken)
    {
        if (string.IsNullOrWhiteSpace(idempotencyKey))
        {
            return BadRequest(new GameErrorResponse
            {
                Code = "IDEMPOTENCY_KEY_REQUIRED",
                Message = "El header X-Idempotency-Key es obligatorio."
            });
        }

        try
        {
            return Ok(await _gameLinkService.ConsumeAsync(request, idempotencyKey, cancellationToken));
        }
        catch (GameBusinessRuleException exception)
        {
            return StatusCode(exception.StatusCode, new GameErrorResponse
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
