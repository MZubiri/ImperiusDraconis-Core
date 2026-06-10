namespace ImperiusDraconisAPI.Models.Game.Players;

public sealed class PurchaseDragonCapacityResponse
{
    public long RobloxUserId { get; init; }

    public int PurchasedSlots { get; init; }

    public int MaxCapacity { get; init; }

    public int PricePaid { get; init; }

    public decimal BalanceAfter { get; init; }
}
