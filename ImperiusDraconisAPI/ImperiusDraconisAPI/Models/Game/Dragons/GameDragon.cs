namespace ImperiusDraconisAPI.Models.Game.Dragons;

public sealed class GameDragon
{
    public long Id { get; init; }

    public int IdAlumno { get; init; }

    public string Name { get; init; } = string.Empty;

    public string Rarity { get; init; } = string.Empty;

    public string Temperament { get; init; } = string.Empty;

    public int Level { get; init; }

    public string Stage { get; init; } = string.Empty;

    public DateTime HatchedAt { get; init; }
}

public sealed class HatchGameEggRequest
{
    public long RobloxUserId { get; init; }

    public string Name { get; init; } = string.Empty;
}

public sealed class HatchGameEggResponse
{
    public long EggId { get; init; }

    public string EggStatus { get; init; } = string.Empty;

    public GameDragon Dragon { get; init; } = new();
}

public sealed class SelectDragonRequest
{
    public long RobloxUserId { get; init; }
}

public sealed class SelectDragonResponse
{
    public long DragonId { get; init; }

    public bool Selected { get; init; }
}

