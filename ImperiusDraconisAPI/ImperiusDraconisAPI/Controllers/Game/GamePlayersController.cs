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
    /// Los sistemas de huevos, dragones y ranking se devuelven vacios hasta sus epicos correspondientes.
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
    }
}
