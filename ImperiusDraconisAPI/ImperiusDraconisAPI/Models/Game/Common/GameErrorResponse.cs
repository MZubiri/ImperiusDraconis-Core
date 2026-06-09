namespace ImperiusDraconisAPI.Models.Game.Common;

public sealed class GameErrorResponse
{
    public string Code { get; init; } = string.Empty;

    public string Message { get; init; } = string.Empty;
}
