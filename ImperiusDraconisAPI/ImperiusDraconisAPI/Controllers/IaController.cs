using System.Security.Claims;
using ImperiusDraconisAPI.Common;
using ImperiusDraconisAPI.Models.Ia;
using ImperiusDraconisAPI.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace ImperiusDraconisAPI.Controllers;

[ApiController]
[Authorize]
[Route("api/ia")]
public sealed class IaController : ControllerBase
{
    private const string PointsPermission = "Marcadores:ActualizarMarcador";
    private const string DracoinsPermission = "Dinamicas:RegistrarDin\u00E1micaPorDracoins";

    private readonly GeminiFormatCorrectionService _formatCorrectionService;

    public IaController(GeminiFormatCorrectionService formatCorrectionService)
    {
        _formatCorrectionService = formatCorrectionService;
    }

    [HttpPost("corregir-formato")]
    [ProducesResponseType(typeof(FormatCorrectionResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status502BadGateway)]
    public async Task<ActionResult<FormatCorrectionResponse>> CorrectFormat(
        [FromBody] FormatCorrectionRequest request,
        CancellationToken cancellationToken)
    {
        var type = request.Tipo.Trim().ToLowerInvariant();
        var requiredPermission = type switch
        {
            "puntos" => PointsPermission,
            "dracoins" => DracoinsPermission,
            _ => null
        };

        if (requiredPermission is null)
        {
            return BadRequest(new { error = "El tipo solo puede ser puntos o dracoins." });
        }

        if (!HasPermission(requiredPermission))
        {
            return Forbid();
        }

        try
        {
            var correctedText = await _formatCorrectionService.CorrectAsync(
                GetCurrentUserId(),
                type,
                request.Texto,
                cancellationToken);

            return Ok(new FormatCorrectionResponse
            {
                TextoCorregido = correctedText
            });
        }
        catch (BusinessRuleException exception)
        {
            return StatusCode(StatusCodes.Status502BadGateway, new { error = exception.Message });
        }
    }

    private bool HasPermission(string permission) =>
        User.Claims.Any(claim =>
            claim.Type == "permission" &&
            string.Equals(claim.Value, permission, StringComparison.OrdinalIgnoreCase));

    private int GetCurrentUserId() =>
        int.TryParse(User.FindFirstValue(ClaimTypes.NameIdentifier), out var id) ? id : 0;
}
