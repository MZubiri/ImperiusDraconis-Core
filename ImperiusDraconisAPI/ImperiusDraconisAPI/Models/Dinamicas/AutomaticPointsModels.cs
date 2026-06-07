using System.ComponentModel.DataAnnotations;

namespace ImperiusDraconisAPI.Models.Dinamicas;

public class AutomaticPointsAnalyzeRequest
{
    [Required]
    [MaxLength(50000)]
    public string Text { get; set; } = string.Empty;

    public List<AutomaticPointsRoundAdjustmentRequest> RoundAdjustments { get; set; } = [];

    public List<AutomaticPointsFrogAdjustmentRequest> FrogAdjustments { get; set; } = [];
}

public sealed class AutomaticPointsRegisterRequest : AutomaticPointsAnalyzeRequest
{
    [Required]
    [MaxLength(200)]
    public string Name { get; set; } = string.Empty;

    [Required]
    [MaxLength(40)]
    public string Subtype { get; set; } = "Normal";

    [MaxLength(510)]
    public string? Observation { get; set; }

    [Required]
    [MaxLength(80)]
    public string ClientRequestId { get; set; } = string.Empty;
}

public sealed class AutomaticPointsRoundAdjustmentRequest
{
    [Range(1, int.MaxValue)]
    public int RoundNumber { get; set; }

    [Range(1, 3)]
    public int Multiplier { get; set; } = 1;

    public bool Cancelled { get; set; }
}

public sealed class AutomaticPointsFrogAdjustmentRequest
{
    [Range(0, int.MaxValue)]
    public int Index { get; set; }

    [Range(1, int.MaxValue)]
    public int StartRound { get; set; }
}

public sealed class AutomaticPointsAnalysisDto
{
    public string DetectedName { get; init; } = string.Empty;

    public IReadOnlyCollection<AutomaticPointsFrogDto> Frogs { get; init; } = [];

    public IReadOnlyCollection<AutomaticPointsRoundDto> Rounds { get; init; } = [];

    public IReadOnlyCollection<AutomaticPointsHouseTotalDto> Totals { get; init; } = [];

    public IReadOnlyCollection<string> Warnings { get; init; } = [];
}

public sealed class AutomaticPointsFrogDto
{
    public int Index { get; init; }

    public string HouseEmoji { get; init; } = string.Empty;

    public int IdCasa { get; init; }

    public string HouseName { get; init; } = string.Empty;

    public string Description { get; init; } = string.Empty;

    public int StartRound { get; init; }
}

public sealed class AutomaticPointsRoundDto
{
    public int RoundNumber { get; init; }

    public int DetectedMultiplier { get; init; }

    public int Multiplier { get; init; }

    public bool DetectedCancelled { get; init; }

    public bool Cancelled { get; init; }

    public IReadOnlyCollection<string> Top { get; init; } = [];

    public IReadOnlyCollection<string> Responses { get; init; } = [];

    public IReadOnlyCollection<AutomaticPointsHouseTotalDto> PointsByHouse { get; init; } = [];
}

public sealed class AutomaticPointsHouseTotalDto
{
    public string HouseEmoji { get; init; } = string.Empty;

    public int IdCasa { get; init; }

    public string HouseName { get; init; } = string.Empty;

    public int Points { get; init; }
}
