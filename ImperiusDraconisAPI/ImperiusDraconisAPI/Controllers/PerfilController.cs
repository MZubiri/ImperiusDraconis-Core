using System.Security.Claims;
using ImperiusDraconisAPI.Common;
using ImperiusDraconisAPI.Models.Alumnos;
using ImperiusDraconisAPI.Models.Perfil;
using ImperiusDraconisAPI.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace ImperiusDraconisAPI.Controllers;

[ApiController]
[Authorize]
[Route("api/[controller]")]
public sealed class PerfilController : ControllerBase
{
    private readonly AlumnosService _alumnosService;
    private readonly LegacyAssetStorage _assetStorage;

    public PerfilController(AlumnosService alumnosService, LegacyAssetStorage assetStorage)
    {
        _alumnosService = alumnosService;
        _assetStorage = assetStorage;
    }

    [HttpGet]
    [ProducesResponseType(typeof(AlumnoDetailDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult<AlumnoDetailDto>> Get(CancellationToken cancellationToken)
    {
        var idAlumno = GetCurrentUserId();
        if (!idAlumno.HasValue)
        {
            return Unauthorized();
        }

        var perfil = await _alumnosService.GetByIdAsync(idAlumno.Value, cancellationToken);
        return perfil is null ? NotFound() : Ok(perfil);
    }

    [HttpPut]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult> Update(
        [FromBody] UpdateMyProfileRequest request,
        CancellationToken cancellationToken)
    {
        var idAlumno = GetCurrentUserId();
        if (!idAlumno.HasValue)
        {
            return Unauthorized();
        }

        var updated = await _alumnosService.UpdateProfileAsync(idAlumno.Value, request, cancellationToken);
        return updated ? NoContent() : NotFound();
    }

    [HttpPut("contrasena")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<ActionResult> ChangePassword(
        [FromBody] ChangeMyPasswordRequest request,
        CancellationToken cancellationToken)
    {
        var idAlumno = GetCurrentUserId();
        if (!idAlumno.HasValue)
        {
            return Unauthorized();
        }

        try
        {
            await _alumnosService.ChangeOwnPasswordAsync(idAlumno.Value, request, cancellationToken);
            return NoContent();
        }
        catch (BusinessRuleException exception)
        {
            return BadRequest(new { message = exception.Message });
        }
    }

    [HttpPost("foto")]
    [ProducesResponseType(typeof(UploadProfileImageResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<ActionResult<UploadProfileImageResponse>> UploadImage(
        [FromForm] UploadProfileImageRequest request,
        CancellationToken cancellationToken)
    {
        if (!GetCurrentUserId().HasValue)
        {
            return Unauthorized();
        }

        try
        {
            var path = await _assetStorage.SaveImageAsync(
                request.FotoArchivo!,
                Path.Combine("Content", "FotosPerfil"),
                cancellationToken);

            return Ok(new UploadProfileImageResponse { FotoPerfil = path });
        }
        catch (BusinessRuleException exception)
        {
            return BadRequest(new { message = exception.Message });
        }
    }

    private int? GetCurrentUserId()
    {
        var claim = User.Claims.FirstOrDefault(current => current.Type == ClaimTypes.NameIdentifier)?.Value;
        return int.TryParse(claim, out var idAlumno) ? idAlumno : null;
    }
}
