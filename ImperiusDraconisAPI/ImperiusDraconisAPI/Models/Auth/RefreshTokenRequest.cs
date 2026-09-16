using System.ComponentModel.DataAnnotations;
namespace ImperiusDraconisAPI.Models.Auth;

public sealed class RefreshTokenRequest
{
    [Required, StringLength(256, MinimumLength = 64)]
    public string RefreshToken { get; set; } = string.Empty;
}
