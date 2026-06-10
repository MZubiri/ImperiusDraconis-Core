using ImperiusDraconisAPI.Models.Game.Eggs;
using ImperiusDraconisAPI.Models.Game.Dragons;
using ImperiusDraconisAPI.Models.Game.Common;
using ImperiusDraconisAPI.Security;
using ImperiusDraconisAPI.Services.Game;
using ImperiusDraconisAPI.Common;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace ImperiusDraconisAPI.Controllers.Game;

[ApiController]
[Route("api/game/v1/eggs")]
[Authorize(AuthenticationSchemes = GameApiKeyAuthenticationDefaults.AuthenticationScheme)]
public sealed class GameEggsController : ControllerBase
{
    private readonly GameEggService _gameEggService;

    public GameEggsController(GameEggService gameEggService)
    {
        _gameEggService = gameEggService;
    }

    /// <summary>
    /// Obtiene el catalogo de huevos activos ordenados por SortOrder.
    /// </summary>
    /// <remarks>
    /// Requiere X-Game-Api-Key.
    /// </remarks>
    [HttpGet("catalog")]
    [ProducesResponseType(typeof(IReadOnlyCollection<GameEggDefinition>), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<ActionResult<IReadOnlyCollection<GameEggDefinition>>> GetCatalog(CancellationToken cancellationToken)
    {
        var catalog = await _gameEggService.GetActiveDefinitionsAsync(cancellationToken);
        return Ok(catalog);
    }

    /// <summary>
    /// Realiza la compra de un huevo del catalogo.
    /// </summary>
    /// <remarks>
    /// Requiere X-Game-Api-Key y X-Idempotency-Key.
    /// </remarks>
    [HttpPost("purchase")]
    [ProducesResponseType(typeof(PurchaseGameEggResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(GameErrorResponse), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(typeof(GameErrorResponse), StatusCodes.Status403Forbidden)]
    [ProducesResponseType(typeof(GameErrorResponse), StatusCodes.Status404NotFound)]
    [ProducesResponseType(typeof(GameErrorResponse), StatusCodes.Status409Conflict)]
    public async Task<ActionResult<PurchaseGameEggResponse>> Purchase(
        [FromBody] PurchaseGameEggRequest request,
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
            var result = await _gameEggService.PurchaseAsync(request, idempotencyKey, cancellationToken);
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
    /// Inicia la incubacion de un huevo.
    /// </summary>
    /// <remarks>
    /// Requiere X-Game-Api-Key.
    /// </remarks>
    [HttpPost("{eggId:long}/incubate")]
    [ProducesResponseType(typeof(GameEgg), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(GameErrorResponse), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(typeof(GameErrorResponse), StatusCodes.Status404NotFound)]
    public async Task<ActionResult<GameEgg>> Incubate(
        long eggId,
        CancellationToken cancellationToken)
    {
        try
        {
            var result = await _gameEggService.IncubateAsync(eggId, cancellationToken);
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
    /// Eclosiona un huevo.
    /// </summary>
    /// <remarks>
    /// Requiere X-Game-Api-Key.
    /// </remarks>
    [HttpPost("{eggId:long}/hatch")]
    [ProducesResponseType(typeof(HatchGameEggResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(GameErrorResponse), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(typeof(GameErrorResponse), StatusCodes.Status404NotFound)]
    public async Task<ActionResult<HatchGameEggResponse>> Hatch(
        long eggId,
        [FromBody] HatchGameEggRequest request,
        CancellationToken cancellationToken)
    {
        try
        {
            var result = await _gameEggService.HatchAsync(eggId, request, cancellationToken);
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
    /// Regala un huevo a otro jugador.
    /// </summary>
    /// <remarks>
    /// Requiere X-Game-Api-Key y X-Idempotency-Key.
    /// </remarks>
    [HttpPost("{eggId:long}/gift")]
    [ProducesResponseType(typeof(GiftGameEggResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(GameErrorResponse), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(typeof(GameErrorResponse), StatusCodes.Status403Forbidden)]
    [ProducesResponseType(typeof(GameErrorResponse), StatusCodes.Status404NotFound)]
    public async Task<ActionResult<GiftGameEggResponse>> Gift(
        long eggId,
        [FromBody] GiftGameEggRequest request,
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
            var result = await _gameEggService.GiftEggAsync(eggId, request, idempotencyKey, cancellationToken);
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
