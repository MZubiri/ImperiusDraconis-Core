using ImperiusDraconisAPI.Models.Game.Eggs;
using ImperiusDraconisAPI.Models.Game.Players;

namespace ImperiusDraconisAPI.Models.Game.Admin;

public sealed class GameAdminPlayer
{
    public int IdAlumno { get; init; }
    public long? RobloxUserId { get; init; }
    public string DisplayName { get; init; } = string.Empty;
    public decimal Dracoins { get; init; }
    public IReadOnlyCollection<GameEgg> Eggs { get; init; } = [];
    public IReadOnlyCollection<GameBootstrapDragonDto> Dragons { get; init; } = [];
    public IReadOnlyCollection<GameAdminLedgerEntry> Ledger { get; init; } = [];
}

public sealed class GameAdminLedgerEntry
{
    public long Id { get; init; }
    public decimal Amount { get; init; }
    public decimal BalanceAfter { get; init; }
    public string Reason { get; init; } = string.Empty;
    public string ReferenceType { get; init; } = string.Empty;
    public string? ReferenceId { get; init; }
    public DateTime CreatedAt { get; init; }
}

public sealed class GameAdminDracoinAdjustmentRequest
{
    public int IdAlumno { get; init; }
    public int Amount { get; init; }
    public string Justification { get; init; } = string.Empty;
}

public sealed class GameAdminDracoinAdjustmentResponse
{
    public int IdAlumno { get; init; }
    public int Amount { get; init; }
    public decimal BalanceAfter { get; init; }
}

public sealed class GameAdminCatalogUpdateRequest
{
    public int PriceDracoins { get; init; }
    public bool Active { get; init; }
}
