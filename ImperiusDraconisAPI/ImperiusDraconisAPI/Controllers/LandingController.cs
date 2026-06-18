using ImperiusDraconisAPI.Common;
using ImperiusDraconisAPI.Models.Landing;
using ImperiusDraconisAPI.Security;
using ImperiusDraconisAPI.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace ImperiusDraconisAPI.Controllers;

[ApiController]
[Authorize]
[Route("api/landing")]
public sealed class LandingController : ControllerBase
{
    private const string AdminPermission = "Landing:Administrar";
    private readonly LandingService _landingService;

    public LandingController(LandingService landingService)
    {
        _landingService = landingService;
    }

    [AllowAnonymous]
    [HttpGet]
    public async Task<ActionResult<LandingPageDto>> GetPublic(CancellationToken cancellationToken)
    {
        return Ok(await _landingService.GetPublicAsync(cancellationToken));
    }

    [HttpGet("admin")]
    [HasPermission(AdminPermission)]
    public async Task<ActionResult<LandingAdminDto>> GetAdmin(CancellationToken cancellationToken)
    {
        return Ok(await _landingService.GetAdminAsync(cancellationToken));
    }

    [HttpPut("admin/configuracion")]
    [HasPermission(AdminPermission)]
    public async Task<ActionResult<LandingConfigurationDto>> SaveConfiguration(
        [FromBody] SaveLandingConfigurationRequest request,
        CancellationToken cancellationToken)
    {
        try
        {
            return Ok(await _landingService.SaveConfigurationAsync(request, cancellationToken));
        }
        catch (BusinessRuleException exception)
        {
            return BadRequest(new { message = exception.Message });
        }
    }

    [HttpPut("admin/contenido/{tipo}/{posicion:int}")]
    [HasPermission(AdminPermission)]
    public async Task<ActionResult<LandingContentItemDto>> SaveContent(
        string tipo,
        int posicion,
        [FromForm] SaveLandingContentRequest request,
        CancellationToken cancellationToken)
    {
        try
        {
            return Ok(await _landingService.SaveContentAsync(tipo, posicion, request, cancellationToken));
        }
        catch (BusinessRuleException exception)
        {
            return BadRequest(new { message = exception.Message });
        }
    }

    [HttpDelete("admin/gaceta/{posicion:int}")]
    [HasPermission(AdminPermission)]
    public async Task<IActionResult> DeleteGazette(int posicion, CancellationToken cancellationToken)
    {
        return await _landingService.DeleteGazetteAsync(posicion, cancellationToken)
            ? NoContent()
            : NotFound();
    }
}
