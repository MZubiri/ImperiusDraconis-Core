using ImperiusDraconisAPI.Common;
using ImperiusDraconisAPI.Models.Game.Common;
using ImperiusDraconisAPI.Models.Game.Missions;
using ImperiusDraconisAPI.Security;
using ImperiusDraconisAPI.Services.Game;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace ImperiusDraconisAPI.Controllers.Game;

[ApiController, Route("api/game/v1/missions")]
[Authorize(AuthenticationSchemes = GameApiKeyAuthenticationDefaults.AuthenticationScheme)]
public sealed class GameMissionsController(GameMissionService service) : ControllerBase
{
    [HttpGet("by-roblox/{robloxUserId:long}")]
    public async Task<ActionResult<IReadOnlyCollection<GamePlayerMission>>> GetDaily(long robloxUserId,CancellationToken ct)
    { try{return Ok(await service.GetDailyAsync(robloxUserId,ct));}catch(GameBusinessRuleException ex){return StatusCode(ex.StatusCode,new GameErrorResponse{Code=ex.Code,Message=ex.Message});} }

    [HttpPost("{missionId:long}/claim")]
    public async Task<ActionResult<ClaimGameMissionResponse>> Claim(long missionId,[FromBody] ClaimGameMissionRequest request,[FromHeader(Name="X-Idempotency-Key")]string? key,CancellationToken ct)
    { if(string.IsNullOrWhiteSpace(key))return BadRequest(new GameErrorResponse{Code="IDEMPOTENCY_KEY_REQUIRED",Message="El header X-Idempotency-Key es obligatorio."}); try{return Ok(await service.ClaimAsync(missionId,request,key,ct));}catch(GameBusinessRuleException ex){return StatusCode(ex.StatusCode,new GameErrorResponse{Code=ex.Code,Message=ex.Message});} }
}
