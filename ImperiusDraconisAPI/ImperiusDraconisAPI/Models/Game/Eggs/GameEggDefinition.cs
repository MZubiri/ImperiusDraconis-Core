namespace ImperiusDraconisAPI.Models.Game.Eggs;

public sealed class GameEggDefinition
{
    public string Code { get; init; } = string.Empty;

    public string DisplayName { get; init; } = string.Empty;

    public string Description { get; init; } = string.Empty;

    public int PriceDracoins { get; init; }

    public int IncubationMinutes { get; init; }

    public string DefaultRarity { get; init; } = string.Empty;

    public bool Active { get; init; }

    public bool Purchasable { get; init; }

    public int SortOrder { get; init; }
}
