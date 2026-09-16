using ImperiusDraconisAPI.Models.Game.Players;

namespace ImperiusDraconisAPI.Models.Game.Dragons;

public sealed class GameFoodDefinition
{
    public string Code { get; init; } = string.Empty;
    public string DisplayName { get; init; } = string.Empty;
    public string Description { get; init; } = string.Empty;
    public int PriceDracoins { get; init; }
    public int HungerGain { get; init; }
    public int LifeGain { get; init; }
    public int HappinessGain { get; init; }
    public int ExperienceGain { get; init; }
}

public sealed class DragonPlayerRequest
{
    public long RobloxUserId { get; init; }
}

public sealed class DragonCareResponse
{
    public GameBootstrapDragonDto Dragon { get; init; } = new();
    public decimal BalanceAfter { get; init; }
    public DateTime? NextPetAt { get; init; }
    public string Message { get; init; } = string.Empty;
}
