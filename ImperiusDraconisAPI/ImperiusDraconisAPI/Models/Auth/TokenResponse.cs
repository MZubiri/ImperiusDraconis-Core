namespace ImperiusDraconisAPI.Models.Auth;

public sealed class TokenResponse
{
    public string AccessToken { get; init; } = string.Empty;
    public string RefreshToken { get; init; } = string.Empty;
    public DateTimeOffset ExpiresAt { get; init; }
    public AuthenticatedUserDto User { get; init; } = new();
}
