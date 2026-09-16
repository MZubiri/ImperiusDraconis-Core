using ImperiusDraconisAPI.Common;
using ImperiusDraconisAPI.Models.Game.Common;
using ImperiusDraconisAPI.Models.Game.Dragons;
using ImperiusDraconisAPI.Security;
using ImperiusDraconisAPI.Services.Game;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace ImperiusDraconisAPI.Controllers.Game;

[ApiController]
[Route("api/game/v1/dragons")]
[Authorize(AuthenticationSchemes = GameApiKeyAuthenticationDefaults.AuthenticationScheme)]
public sealed class GameDragonsController : ControllerBase
{
    private readonly GameDragonService _gameDragonService;
    private readonly GameDragonCareService _gameDragonCareService;

    public GameDragonsController(GameDragonService gameDragonService, GameDragonCareService gameDragonCareService)
    {
        _gameDragonService = gameDragonService;
        _gameDragonCareService = gameDragonCareService;
    }

    [HttpGet("food-catalog")]
    public async Task<ActionResult<IReadOnlyCollection<GameFoodDefinition>>> GetFoodCatalog(CancellationToken cancellationToken) =>
        Ok(await _gameDragonCareService.GetFoodCatalogAsync(cancellationToken));

    [HttpPost("{dragonId:long}/feed/{foodCode}")]
    public async Task<ActionResult<DragonCareResponse>> Feed(
        long dragonId,
        string foodCode,
        [FromBody] DragonPlayerRequest request,
        [FromHeader(Name = "X-Idempotency-Key")] string? idempotencyKey,
        CancellationToken cancellationToken) =>
        await ExecuteCare(() => _gameDragonCareService.FeedAsync(dragonId, foodCode, request, RequireKey(idempotencyKey), cancellationToken));

    [HttpPost("{dragonId:long}/pet")]
    public async Task<ActionResult<DragonCareResponse>> Pet(
        long dragonId,
        [FromBody] DragonPlayerRequest request,
        [FromHeader(Name = "X-Idempotency-Key")] string? idempotencyKey,
        CancellationToken cancellationToken) =>
        await ExecuteCare(() => _gameDragonCareService.PetAsync(dragonId, request, RequireKey(idempotencyKey), cancellationToken));

    private async Task<ActionResult<DragonCareResponse>> ExecuteCare(Func<Task<DragonCareResponse>> action)
    {
        try { return Ok(await action()); }
        catch (GameBusinessRuleException exception)
        {
            return StatusCode(exception.StatusCode, new GameErrorResponse { Code = exception.Code, Message = exception.Message });
        }
    }

    private static string RequireKey(string? key)
    {
        if (string.IsNullOrWhiteSpace(key))
            throw new GameBusinessRuleException("IDEMPOTENCY_KEY_REQUIRED", "El header X-Idempotency-Key es obligatorio.", 400);
        return key;
    }

    /// <summary>
    /// Selecciona un dragon como acompañante activo.
    /// </summary>
    /// <remarks>
    /// Requiere X-Game-Api-Key y X-Idempotency-Key.
    /// </remarks>
    [HttpPost("{dragonId:long}/select")]
    [ProducesResponseType(typeof(SelectDragonResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(GameErrorResponse), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(typeof(GameErrorResponse), StatusCodes.Status403Forbidden)]
    [ProducesResponseType(typeof(GameErrorResponse), StatusCodes.Status404NotFound)]
    [ProducesResponseType(typeof(GameErrorResponse), StatusCodes.Status500InternalServerError)]
    public async Task<ActionResult<SelectDragonResponse>> SelectDragon(
        long dragonId,
        [FromBody] SelectDragonRequest request,
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
            var result = await _gameDragonService.SelectDragonAsync(dragonId, request, idempotencyKey, cancellationToken);
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
