namespace ImperiusDraconisAPI.Models.Game.Missions;

public sealed class GamePlayerMission
{
    public long Id { get; init; }
    public string Code { get; init; } = string.Empty;
    public string DisplayName { get; init; } = string.Empty;
    public string Description { get; init; } = string.Empty;
    public string MissionType { get; init; } = string.Empty;
    public int ProgressAmount { get; init; }
    public int TargetAmount { get; init; }
    public int RewardDracoins { get; init; }
    public int RewardExperience { get; init; }
    public string Status { get; init; } = string.Empty;
    public DateOnly AssignedDate { get; init; }
}

public sealed class ClaimGameMissionRequest
{
    public long RobloxUserId { get; init; }
}

public sealed class ClaimGameMissionResponse
{
    public long MissionId { get; init; }
    public string Status { get; init; } = string.Empty;
    public int DracoinsAwarded { get; init; }
    public int ExperienceAwarded { get; init; }
    public decimal BalanceAfter { get; init; }
}
