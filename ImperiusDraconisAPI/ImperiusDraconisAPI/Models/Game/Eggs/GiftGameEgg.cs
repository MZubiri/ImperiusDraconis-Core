namespace ImperiusDraconisAPI.Models.Game.Eggs;

public sealed class GiftGameEggRequest
{
    public long SenderRobloxUserId { get; init; }

    public long ReceiverRobloxUserId { get; init; }
}

public sealed class GiftGameEggResponse
{
    public long TransferId { get; init; }

    public long EggId { get; init; }

    public long SenderRobloxUserId { get; init; }

    public long ReceiverRobloxUserId { get; init; }

    public string Status { get; init; } = string.Empty;
}

public sealed class ProcessGiftTransferRequest
{
    public long ReceiverRobloxUserId { get; init; }
}
