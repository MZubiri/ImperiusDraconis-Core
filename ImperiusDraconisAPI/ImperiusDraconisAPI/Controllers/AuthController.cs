using System.Security.Claims;
using ImperiusDraconisAPI.Common;
using ImperiusDraconisAPI.Models.Auth;
using ImperiusDraconisAPI.Services;
using ImperiusDraconisAPI.Services.Auditoria;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.RateLimiting;

namespace ImperiusDraconisAPI.Controllers;

[ApiController]
[Route("api/[controller]")]
public sealed class AuthController : ControllerBase
{
    private readonly AuthService _authService;
    private readonly IAuditoriaService _auditoriaService;

    public AuthController(AuthService authService, IAuditoriaService auditoriaService)
    {
        _authService = authService;
        _auditoriaService = auditoriaService;
    }

    [AllowAnonymous]
    [EnableRateLimiting("LoginPolicy")]
    [HttpPost("login")]
    [ProducesResponseType(typeof(LoginResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<ActionResult<LoginResponse>> Login(
        [FromBody] LoginRequest request,
        CancellationToken cancellationToken)
    {
        var response = await _authService.LoginAsync(request, cancellationToken);

        string ipAddress = HttpContext.Connection.RemoteIpAddress?.ToString() ?? "0.0.0.0";
        string userAgent = HttpContext.Request.Headers["User-Agent"].ToString() ?? "Desconocido";
        string fingerprint = request.FingerprintHash ?? "Desconocido";

        if (response is null)
        {
            // Intentar buscar el IdAlumno por código para registrar el intento fallido
            int? idAlumno = await _authService.ObtenerIdAlumnoPorCodigoAsync(request.Codigo, cancellationToken);
            if (idAlumno.HasValue)
            {
                await _auditoriaService.RegistrarAccesoAsync(idAlumno.Value, ipAddress, userAgent, fingerprint, exito: false);
            }

            return Unauthorized(new { message = "Credenciales invalidas o usuario inactivo." });
        }

        // Registrar acceso exitoso
        await _auditoriaService.RegistrarAccesoAsync(response.User.IdAlumno, ipAddress, userAgent, fingerprint, exito: true);

        return Ok(response);
    }

    [AllowAnonymous]
    [EnableRateLimiting("LoginPolicy")]
    [HttpPost("recuperar-contrasena")]
    [ProducesResponseType(typeof(RecoverPasswordResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<ActionResult<RecoverPasswordResponse>> RecoverPassword(
        [FromBody] RecoverPasswordRequest request,
        CancellationToken cancellationToken)
    {
        try
        {
            return Ok(await _authService.RecoverPasswordAsync(request, cancellationToken));
        }
        catch (BusinessRuleException exception)
        {
            return BadRequest(new { message = exception.Message });
        }
    }

    [Authorize]
    [HttpGet("me")]
    [ProducesResponseType(typeof(AuthenticatedUserDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<ActionResult<AuthenticatedUserDto>> Me(CancellationToken cancellationToken)
    {
        var idAlumnoClaim = User.Claims.FirstOrDefault(claim => claim.Type == ClaimTypes.NameIdentifier)?.Value;
        if (!int.TryParse(idAlumnoClaim, out var idAlumno))
        {
            return Unauthorized();
        }

        var user = await _authService.GetCurrentUserAsync(idAlumno, cancellationToken);
        return user is null ? Unauthorized() : Ok(user);
    }
}
