using ImperiusDraconisAPI.Common;
using ImperiusDraconisAPI.Models.Game.Common;
using ImperiusDraconisAPI.Models.Game.Players;
using ImperiusDraconisAPI.Security;
using ImperiusDraconisAPI.Services.Game;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace ImperiusDraconisAPI.Controllers.Game;

[ApiController]
[Route("api/game/v1/players")]
[Authorize(AuthenticationSchemes = GameApiKeyAuthenticationDefaults.AuthenticationScheme)]
public sealed class GamePlayersController : ControllerBase
{
    private readonly GamePlayerService _gamePlayerService;

    public GamePlayersController(GamePlayerService gamePlayerService)
    {
        _gamePlayerService = gamePlayerService;
    }

    /// <summary>
    /// Obtiene el estado inicial persistente de un jugador Roblox vinculado.
    /// </summary>
    /// <remarks>
    /// Incluye los huevos persistidos. Dragones y ranking permanecen vacios hasta sus epicos correspondientes.
    /// </remarks>
    [HttpGet("by-roblox/{robloxUserId:long}")]
    [ProducesResponseType(typeof(GamePlayerBootstrapResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(GameErrorResponse), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(typeof(GameErrorResponse), StatusCodes.Status403Forbidden)]
    [ProducesResponseType(typeof(GameErrorResponse), StatusCodes.Status404NotFound)]
    [ProducesResponseType(typeof(GameErrorResponse), StatusCodes.Status500InternalServerError)]
    public async Task<ActionResult<GamePlayerBootstrapResponse>> GetByRobloxUserId(
        long robloxUserId,
        CancellationToken cancellationToken)
    {
        try
        {
            return Ok(await _gamePlayerService.GetBootstrapAsync(robloxUserId, cancellationToken));
        }
        catch (GameBusinessRuleException exception)
        {
            return StatusCode(exception.StatusCode, new GameErrorResponse
            {
                Code = exception.Code,
                Message = exception.Message
            });
        }
        catch (Exception exception)
        {
            return StatusCode(StatusCodes.Status500InternalServerError, new GameErrorResponse
            {
                Code = "INTERNAL_SERVER_ERROR",
                Message = exception.Message
            });
        }
    }

    /// <summary>
    /// Compra capacidad adicional de dragones.
    /// </summary>
    /// <remarks>
    /// Requiere X-Game-Api-Key y X-Idempotency-Key.
    /// </remarks>
    [HttpPost("{robloxUserId:long}/dragon-capacity/purchase")]
    [ProducesResponseType(typeof(PurchaseDragonCapacityResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(GameErrorResponse), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(typeof(GameErrorResponse), StatusCodes.Status403Forbidden)]
    [ProducesResponseType(typeof(GameErrorResponse), StatusCodes.Status404NotFound)]
    public async Task<ActionResult<PurchaseDragonCapacityResponse>> PurchaseCapacity(
        long robloxUserId,
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
            var result = await _gamePlayerService.PurchaseCapacityAsync(robloxUserId, idempotencyKey, cancellationToken);
            return Ok(result);
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
        catch (Exception exception)
        {
            return StatusCode(StatusCodes.Status500InternalServerError, new GameErrorResponse
            {
                Code = "INTERNAL_SERVER_ERROR",
                Message = exception.Message
            });
        }
    }
}
