using ImperiusDraconisAPI.Common;
using ImperiusDraconisAPI.Models.Game.Battles;
using ImperiusDraconisAPI.Models.Game.Common;
using ImperiusDraconisAPI.Security;
using ImperiusDraconisAPI.Services.Game;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace ImperiusDraconisAPI.Controllers.Game;
[ApiController,Route("api/game/v1")]
[Authorize(AuthenticationSchemes=GameApiKeyAuthenticationDefaults.AuthenticationScheme)]
public sealed class GameBattlesController(GameBattleService service):ControllerBase
{
    [HttpPost("battles/automatic")]
    public async Task<ActionResult<AutomaticBattleResponse>> Battle([FromBody]AutomaticBattleRequest request,[FromHeader(Name="X-Idempotency-Key")]string? key,CancellationToken ct)
    {if(string.IsNullOrWhiteSpace(key))return BadRequest(new GameErrorResponse{Code="IDEMPOTENCY_KEY_REQUIRED",Message="El header X-Idempotency-Key es obligatorio."});try{return Ok(await service.BattleAsync(request,key,ct));}catch(GameBusinessRuleException ex){return StatusCode(ex.StatusCode,new GameErrorResponse{Code=ex.Code,Message=ex.Message});}}
    [HttpGet("ranking")]
    public async Task<ActionResult<IReadOnlyCollection<GameRankingEntry>>> Ranking([FromQuery]int limit=50,CancellationToken ct=default)=>Ok(await service.GetRankingAsync(limit,ct));
}
