using ImperiusDraconisAPI.Models.Game.Players;

namespace ImperiusDraconisAPI.Services.Game;

internal static class GamePlayerBootstrapMapper
{
    public static GamePlayerBootstrapResponse Map(
        string gameVersion,
        int baseSlots,
        long robloxUserId,
        string displayName,
        string houseName,
        decimal dracoins,
        int purchasedSlots,
        int maxCapacity)
    {
        var totalSlots = Math.Min(maxCapacity, baseSlots + purchasedSlots);

        return new GamePlayerBootstrapResponse
        {
            GameVersion = gameVersion,
            Player = new GameBootstrapPlayerDto
            {
                RobloxUserId = robloxUserId,
                DisplayName = displayName,
                HouseName = houseName
            },
            Economy = new GameBootstrapEconomyDto
            {
                Dracoins = dracoins
            },
            Capacity = new GameBootstrapCapacityDto
            {
                BaseSlots = baseSlots,
                PurchasedSlots = purchasedSlots,
                TotalSlots = totalSlots,
                MaxCapacity = maxCapacity,
                AvailableSlots = totalSlots
            },
            Eggs = [],
            Dragons = [],
            SelectedDragon = null,
            Ranking = null
        };
    }
}
