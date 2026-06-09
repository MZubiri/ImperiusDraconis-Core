using ImperiusDraconisAPI.Models.Game.Eggs;
using ImperiusDraconisAPI.Security;
using ImperiusDraconisAPI.Services.Game;
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
}
