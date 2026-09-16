namespace ImperiusDraconisAPI.Models.Game.Battles;

public sealed class AutomaticBattleRequest
{
    public long RobloxUserId { get; init; }
}

public sealed class GameBattleRound
{
    public int Round { get; init; }
    public int PlayerDamage { get; init; }
    public int OpponentDamage { get; init; }
    public int PlayerLife { get; init; }
    public int OpponentLife { get; init; }
}

public sealed class AutomaticBattleResponse
{
    public long BattleId { get; init; }
    public long DragonId { get; init; }
    public string OpponentName { get; init; } = string.Empty;
    public string Result { get; init; } = string.Empty;
    public int RankingPoints { get; init; }
    public int RewardDracoins { get; init; }
    public int RewardExperience { get; init; }
    public decimal BalanceAfter { get; init; }
    public IReadOnlyCollection<GameBattleRound> Rounds { get; init; } = [];
}

public sealed class GameRankingEntry
{
    public int Position { get; init; }
    public long RobloxUserId { get; init; }
    public string DisplayName { get; init; } = string.Empty;
    public string HouseName { get; init; } = string.Empty;
    public int Points { get; init; }
    public int Wins { get; init; }
    public int Battles { get; init; }
}
