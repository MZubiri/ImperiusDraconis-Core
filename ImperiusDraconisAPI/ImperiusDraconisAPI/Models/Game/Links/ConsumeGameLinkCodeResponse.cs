namespace ImperiusDraconisAPI.Models.Game.Links;

public sealed class ConsumeGameLinkCodeResponse
{
    public int IdAlumno { get; init; }

    public long RobloxUserId { get; init; }

    public string DisplayName { get; init; } = string.Empty;

    public string HouseName { get; init; } = string.Empty;

    public int WelcomeDracoins { get; init; }

    public decimal BalanceAfter { get; init; }

    public int BaseSlots { get; init; }

    public int PurchasedSlots { get; init; }

    public int TotalSlots { get; init; }

    public int MaxCapacity { get; init; }

    public DateTime LinkedAt { get; init; }
}
