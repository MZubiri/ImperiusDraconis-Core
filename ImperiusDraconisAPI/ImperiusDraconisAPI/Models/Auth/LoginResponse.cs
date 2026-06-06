namespace ImperiusDraconisAPI.Models.Auth;

public sealed class LoginResponse
{
    public string Token { get; init; } = string.Empty;

    public DateTimeOffset ExpiresAt { get; init; }

    public AuthenticatedUserDto User { get; init; } = new();
}
