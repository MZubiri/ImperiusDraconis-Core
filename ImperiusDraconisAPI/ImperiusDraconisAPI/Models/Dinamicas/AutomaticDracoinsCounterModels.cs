using System.ComponentModel.DataAnnotations;

namespace ImperiusDraconisAPI.Models.Dinamicas;

public sealed class AutomaticDracoinsAnalyzeRequest
{
    [Required]
    [MaxLength(50000)]
    public string Text { get; set; } = string.Empty;

    [MaxLength(40)]
    public string? RuleSet { get; set; }

    public List<AutomaticDracoinsRoundAdjustmentRequest> RoundAdjustments { get; set; } = [];
}

public sealed class AutomaticDracoinsRoundAdjustmentRequest
{
    [Range(1, int.MaxValue)]
    public int RoundNumber { get; set; }

    [Range(1, 3)]
    public int Multiplier { get; set; } = 1;
}

public sealed class AutomaticDracoinsAnalyzeResponse
{
    public string DetectedName { get; init; } = string.Empty;

    public IReadOnlyCollection<AutomaticDracoinsRoundDto> Rounds { get; init; } = [];

    public IReadOnlyCollection<AutomaticDracoinsParticipantResultDto> Totals { get; init; } = [];

    public IReadOnlyCollection<string> Warnings { get; init; } = [];

    public string CopyText { get; init; } = string.Empty;
}

public sealed class AutomaticDracoinsRoundDto
{
    public int RoundNumber { get; init; }

    public int DetectedMultiplier { get; init; }

    public int Multiplier { get; init; }

    public IReadOnlyCollection<string> TopParticipants { get; init; } = [];

    public IReadOnlyCollection<string> OtherParticipants { get; init; } = [];

    public IReadOnlyCollection<string> IgnoredParticipants { get; init; } = [];

    public IReadOnlyCollection<AutomaticDracoinsParticipantResultDto> PointsByParticipant { get; init; } = [];
}

public sealed class AutomaticDracoinsParticipantResultDto
{
    public string Participant { get; init; } = string.Empty;

    public int Dracoins { get; init; }
}
