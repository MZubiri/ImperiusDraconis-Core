namespace ImperiusDraconisAPI.Models.Game.Links;

public sealed class ConsumeGameLinkCodeRequest
{
    public string Code { get; init; } = string.Empty;

    public long RobloxUserId { get; init; }
}
