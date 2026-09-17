using System.Security.Claims;
using ImperiusDraconisAPI.Common;
using ImperiusDraconisAPI.Models.Game.Admin;
using ImperiusDraconisAPI.Models.Game.Common;
using ImperiusDraconisAPI.Security;
using ImperiusDraconisAPI.Services.Game;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace ImperiusDraconisAPI.Controllers.Game;

[ApiController,Authorize,HasPermission("Permisos:Guardar"),Route("api/game/v1/admin")]
public sealed class GameAdminController(GameAdminService service):ControllerBase
{
    [HttpGet("players")]
    public async Task<ActionResult<GameAdminPlayer>> GetPlayer([FromQuery]int? idAlumno,[FromQuery]long? robloxUserId,CancellationToken ct)
    {try{return Ok(await service.GetPlayerAsync(idAlumno,robloxUserId,ct));}catch(GameBusinessRuleException ex){return StatusCode(ex.StatusCode,new GameErrorResponse{Code=ex.Code,Message=ex.Message});}}
    [HttpPost("dracoins/adjustment")]
    public async Task<ActionResult<GameAdminDracoinAdjustmentResponse>> Adjust([FromBody]GameAdminDracoinAdjustmentRequest request,CancellationToken ct)
    {try{return Ok(await service.AdjustDracoinsAsync(request,CurrentUserId(),ct));}catch(GameBusinessRuleException ex){return StatusCode(ex.StatusCode,new GameErrorResponse{Code=ex.Code,Message=ex.Message});}}
    [HttpPost("dragons/{dragonId:long}/restore")]
    public async Task<IActionResult> Restore(long dragonId,CancellationToken ct)
    {try{await service.RestoreDragonAsync(dragonId,ct);return NoContent();}catch(GameBusinessRuleException ex){return StatusCode(ex.StatusCode,new GameErrorResponse{Code=ex.Code,Message=ex.Message});}}
    [HttpGet("catalogs")]
    public async Task<ActionResult<GameAdminCatalogs>> GetCatalogs(CancellationToken ct)=>Ok(await service.GetCatalogsAsync(ct));
    [HttpPut("egg-definitions/{code}")]
    public async Task<IActionResult> UpdateEgg(string code,[FromBody]GameAdminCatalogUpdateRequest request,CancellationToken ct)
    {try{await service.UpdateEggDefinitionAsync(code,request,ct);return NoContent();}catch(GameBusinessRuleException ex){return StatusCode(ex.StatusCode,new GameErrorResponse{Code=ex.Code,Message=ex.Message});}}
    [HttpPut("food-definitions/{code}")]
    public async Task<IActionResult> UpdateFood(string code,[FromBody]GameAdminCatalogUpdateRequest request,CancellationToken ct)
    {try{await service.UpdateFoodDefinitionAsync(code,request,ct);return NoContent();}catch(GameBusinessRuleException ex){return StatusCode(ex.StatusCode,new GameErrorResponse{Code=ex.Code,Message=ex.Message});}}
    [HttpPut("mission-definitions/{code}")]
    public async Task<IActionResult> UpdateMission(string code,[FromBody]GameAdminMissionUpdateRequest request,CancellationToken ct)
    {try{await service.UpdateMissionDefinitionAsync(code,request,ct);return NoContent();}catch(GameBusinessRuleException ex){return StatusCode(ex.StatusCode,new GameErrorResponse{Code=ex.Code,Message=ex.Message});}}
    private int CurrentUserId()=>int.TryParse(User.FindFirstValue(ClaimTypes.NameIdentifier),out var id)?id:throw new UnauthorizedAccessException();
}
