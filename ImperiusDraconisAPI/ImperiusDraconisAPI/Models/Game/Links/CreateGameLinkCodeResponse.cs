namespace ImperiusDraconisAPI.Models.Game.Links;

public sealed class CreateGameLinkCodeResponse
{
    public string Code { get; init; } = string.Empty;

    public DateTime ExpiresAt { get; init; }

    public int ExpiresInSeconds { get; init; }
}
