using ImperiusDraconisAPI.Models.Game.Players;
using ImperiusDraconisAPI.Models.Game.Eggs;
using System.Linq;

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
        int maxCapacity,
        IReadOnlyCollection<GameEgg>? eggs = null,
        IReadOnlyCollection<GameBootstrapDragonDto>? dragons = null)
    {
        eggs ??= [];
        dragons ??= [];

        var totalSlots = Math.Min(maxCapacity, baseSlots + purchasedSlots);
        var occupiedSlots = eggs.Count(egg => egg.Status != "HATCHED") + dragons.Count(d => d.Status != "FLED");
        var availableSlots = Math.Max(0, totalSlots - occupiedSlots);

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
                AvailableSlots = availableSlots
            },
            Eggs = eggs.Select(egg => new GameBootstrapEggDto
            {
                Id = egg.Id,
                EggDefinitionCode = egg.EggDefinitionCode,
                Rarity = egg.Rarity,
                AcquiredAt = egg.AcquiredAt,
                IncubationStartedAt = egg.IncubationStartedAt,
                IncubationEndsAt = egg.IncubationEndsAt,
                Status = egg.Status
            }).ToArray(),
            Dragons = dragons,
            SelectedDragon = dragons.FirstOrDefault(d => d.Selected),
            Ranking = null
        };
    }
}

