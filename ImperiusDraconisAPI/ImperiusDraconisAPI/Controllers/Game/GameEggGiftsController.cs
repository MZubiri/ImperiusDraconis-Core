using ImperiusDraconisAPI.Common;
using ImperiusDraconisAPI.Models.Game.Eggs;
using ImperiusDraconisAPI.Models.Game.Common;
using ImperiusDraconisAPI.Security;
using ImperiusDraconisAPI.Services.Game;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace ImperiusDraconisAPI.Controllers.Game;

[ApiController]
[Route("api/game/v1/egg-gifts")]
[Authorize(AuthenticationSchemes = GameApiKeyAuthenticationDefaults.AuthenticationScheme)]
public sealed class GameEggGiftsController : ControllerBase
{
    private readonly GameEggService _gameEggService;

    public GameEggGiftsController(GameEggService gameEggService)
    {
        _gameEggService = gameEggService;
    }

    /// <summary>
    /// Acepta una transferencia de huevo regalado.
    /// </summary>
    /// <remarks>
    /// Requiere X-Game-Api-Key y X-Idempotency-Key.
    /// </remarks>
    [HttpPost("{transferId:long}/accept")]
    [ProducesResponseType(typeof(GiftGameEggResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(GameErrorResponse), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(typeof(GameErrorResponse), StatusCodes.Status404NotFound)]
    public async Task<ActionResult<GiftGameEggResponse>> Accept(
        long transferId,
        [FromBody] ProcessGiftTransferRequest request,
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
            var result = await _gameEggService.AcceptGiftAsync(transferId, request, idempotencyKey, cancellationToken);
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

    /// <summary>
    /// Rechaza una transferencia de huevo regalado.
    /// </summary>
    /// <remarks>
    /// Requiere X-Game-Api-Key y X-Idempotency-Key.
    /// </remarks>
    [HttpPost("{transferId:long}/reject")]
    [ProducesResponseType(typeof(GiftGameEggResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(GameErrorResponse), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(typeof(GameErrorResponse), StatusCodes.Status404NotFound)]
    public async Task<ActionResult<GiftGameEggResponse>> Reject(
        long transferId,
        [FromBody] ProcessGiftTransferRequest request,
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
            var result = await _gameEggService.RejectGiftAsync(transferId, request, idempotencyKey, cancellationToken);
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
