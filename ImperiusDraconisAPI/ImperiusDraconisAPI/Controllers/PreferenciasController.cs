using System.Security.Claims;
using ImperiusDraconisAPI.Models.Preferences;
using ImperiusDraconisAPI.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace ImperiusDraconisAPI.Controllers;

[ApiController]
[Authorize]
[Route("api/[controller]")]
public sealed class PreferenciasController : ControllerBase
{
    private readonly UserPreferencesService _preferencesService;

    public PreferenciasController(UserPreferencesService preferencesService)
    {
        _preferencesService = preferencesService;
    }

    [HttpGet("dashboard/accesos-rapidos")]
    [ProducesResponseType(typeof(DashboardQuickLinksPreferenceDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<ActionResult<DashboardQuickLinksPreferenceDto>> GetDashboardQuickLinks(
        CancellationToken cancellationToken)
    {
        var idAlumno = GetCurrentUserId();
        if (!idAlumno.HasValue)
        {
            return Unauthorized();
        }

        return Ok(await _preferencesService.GetDashboardQuickLinksAsync(idAlumno.Value, cancellationToken));
    }

    [HttpPut("dashboard/accesos-rapidos")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<ActionResult> SaveDashboardQuickLinks(
        [FromBody] UpdateDashboardQuickLinksPreferenceRequest request,
        CancellationToken cancellationToken)
    {
        var idAlumno = GetCurrentUserId();
        if (!idAlumno.HasValue)
        {
            return Unauthorized();
        }

        await _preferencesService.SaveDashboardQuickLinksAsync(idAlumno.Value, request, cancellationToken);
        return NoContent();
    }

    [HttpGet("dracoins/favoritos-transferencia")]
    [ProducesResponseType(typeof(DracoinTransferFavoritesPreferenceDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<ActionResult<DracoinTransferFavoritesPreferenceDto>> GetDracoinTransferFavorites(
        CancellationToken cancellationToken)
    {
        var idAlumno = GetCurrentUserId();
        if (!idAlumno.HasValue)
        {
            return Unauthorized();
        }

        return Ok(await _preferencesService.GetDracoinTransferFavoritesAsync(idAlumno.Value, cancellationToken));
    }

    [HttpPut("dracoins/favoritos-transferencia")]
    [ProducesResponseType(typeof(DracoinTransferFavoritesPreferenceDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<ActionResult<DracoinTransferFavoritesPreferenceDto>> SaveDracoinTransferFavorites(
        [FromBody] UpdateDracoinTransferFavoritesPreferenceRequest request,
        CancellationToken cancellationToken)
    {
        var idAlumno = GetCurrentUserId();
        if (!idAlumno.HasValue)
        {
            return Unauthorized();
        }

        return Ok(await _preferencesService.SaveDracoinTransferFavoritesAsync(
            idAlumno.Value,
            request,
            cancellationToken));
    }

    [HttpGet("apariencia/tema")]
    [ProducesResponseType(typeof(ThemePreferenceDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<ActionResult<ThemePreferenceDto>> GetTheme(CancellationToken cancellationToken)
    {
        var idAlumno = GetCurrentUserId();
        if (!idAlumno.HasValue)
        {
            return Unauthorized();
        }

        return Ok(await _preferencesService.GetThemeAsync(idAlumno.Value, cancellationToken));
    }

    [HttpPut("apariencia/tema")]
    [ProducesResponseType(typeof(ThemePreferenceDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<ActionResult<ThemePreferenceDto>> SaveTheme(
        [FromBody] UpdateThemePreferenceRequest request,
        CancellationToken cancellationToken)
    {
        var idAlumno = GetCurrentUserId();
        if (!idAlumno.HasValue)
        {
            return Unauthorized();
        }

        return Ok(await _preferencesService.SaveThemeAsync(idAlumno.Value, request, cancellationToken));
    }

    private int? GetCurrentUserId()
    {
        var claim = User.Claims.FirstOrDefault(current => current.Type == ClaimTypes.NameIdentifier)?.Value;
        return int.TryParse(claim, out var idAlumno) ? idAlumno : null;
    }
}
