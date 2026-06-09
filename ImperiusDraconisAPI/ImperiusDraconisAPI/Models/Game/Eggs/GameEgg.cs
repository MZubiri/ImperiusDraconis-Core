namespace ImperiusDraconisAPI.Models.Game.Eggs;

public sealed class GameEgg
{
    public long Id { get; init; }

    public int IdAlumno { get; init; }

    public string? EggDefinitionCode { get; init; }

    public string Rarity { get; init; } = string.Empty;

    public DateTime AcquiredAt { get; init; }

    public DateTime? IncubationStartedAt { get; init; }

    public DateTime? IncubationEndsAt { get; init; }

    public string Status { get; init; } = string.Empty;
}

public sealed class CreateGameEggCommand
{
    public int IdAlumno { get; init; }

    public string EggDefinitionCode { get; init; } = string.Empty;

    public string Rarity { get; init; } = string.Empty;
}

public sealed class UpdateGameEggCommand
{
    public DateTime? IncubationStartedAt { get; init; }

    public DateTime? IncubationEndsAt { get; init; }

    public string Status { get; init; } = string.Empty;
}
