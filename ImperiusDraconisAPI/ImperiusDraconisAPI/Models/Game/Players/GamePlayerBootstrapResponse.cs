namespace ImperiusDraconisAPI.Models.Game.Players;

public sealed class GamePlayerBootstrapResponse
{
    public string GameVersion { get; init; } = string.Empty;

    public GameBootstrapPlayerDto Player { get; init; } = new();

    public GameBootstrapEconomyDto Economy { get; init; } = new();

    public GameBootstrapCapacityDto Capacity { get; init; } = new();

    public IReadOnlyCollection<GameBootstrapEggDto> Eggs { get; init; } = [];

    public IReadOnlyCollection<GameBootstrapDragonDto> Dragons { get; init; } = [];

    public GameBootstrapDragonDto? SelectedDragon { get; init; }

    public GameBootstrapRankingDto? Ranking { get; init; }
}

public sealed class GameBootstrapPlayerDto
{
    public long RobloxUserId { get; init; }

    public string DisplayName { get; init; } = string.Empty;

    public string HouseName { get; init; } = string.Empty;
}

public sealed class GameBootstrapEconomyDto
{
    public decimal Dracoins { get; init; }
}

public sealed class GameBootstrapCapacityDto
{
    public int BaseSlots { get; init; }

    public int PurchasedSlots { get; init; }

    public int TotalSlots { get; init; }

    public int MaxCapacity { get; init; }

    public int AvailableSlots { get; init; }
}

public sealed class GameBootstrapEggDto
{
    public long Id { get; init; }

    public string? EggDefinitionCode { get; init; }

    public string Rarity { get; init; } = string.Empty;

    public DateTime AcquiredAt { get; init; }

    public DateTime? IncubationStartedAt { get; init; }

    public DateTime? IncubationEndsAt { get; init; }

    public string Status { get; init; } = string.Empty;
}

public sealed class GameBootstrapDragonDto
{
    public long Id { get; init; }

    public string Name { get; init; } = string.Empty;

    public string Rarity { get; init; } = string.Empty;

    public string Temperament { get; init; } = string.Empty;

    public string SpeciesCode { get; init; } = string.Empty;

    public int Level { get; init; }

    public string Stage { get; init; } = string.Empty;

    public DateTime HatchedAt { get; init; }

    public int Life { get; init; }

    public int Happiness { get; init; }

    public int Hunger { get; init; }

    public int Experience { get; init; }

    public string Status { get; init; } = string.Empty;

    public bool Selected { get; init; }

    public DateTime LastNeedsUpdateAt { get; init; }
}

public sealed class GameBootstrapRankingDto;

