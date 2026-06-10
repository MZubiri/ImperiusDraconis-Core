using System.Text.Json;
using ImperiusDraconisAPI.Models.Game.Eggs;
using Xunit;

namespace ImperiusDraconisAPI.Tests;

public sealed class GameEggGiftsTests
{
    [Fact]
    public void GiftGameEggRequest_CanBeInitializedAndSerialized()
    {
        var request = new GiftGameEggRequest
        {
            SenderRobloxUserId = 11111,
            ReceiverRobloxUserId = 22222
        };

        Assert.Equal(11111, request.SenderRobloxUserId);
        Assert.Equal(22222, request.ReceiverRobloxUserId);

        var json = JsonSerializer.Serialize(request, new JsonSerializerOptions(JsonSerializerDefaults.Web));
        using var document = JsonDocument.Parse(json);
        var root = document.RootElement;

        Assert.Equal(11111, root.GetProperty("senderRobloxUserId").GetInt64());
        Assert.Equal(22222, root.GetProperty("receiverRobloxUserId").GetInt64());
    }

    [Fact]
    public void GiftGameEggResponse_CanBeInitializedAndSerialized()
    {
        var response = new GiftGameEggResponse
        {
            TransferId = 500,
            EggId = 99,
            SenderRobloxUserId = 11111,
            ReceiverRobloxUserId = 22222,
            Status = "PENDING"
        };

        Assert.Equal(500, response.TransferId);
        Assert.Equal(99, response.EggId);
        Assert.Equal(11111, response.SenderRobloxUserId);
        Assert.Equal(22222, response.ReceiverRobloxUserId);
        Assert.Equal("PENDING", response.Status);

        var json = JsonSerializer.Serialize(response, new JsonSerializerOptions(JsonSerializerDefaults.Web));
        using var document = JsonDocument.Parse(json);
        var root = document.RootElement;

        Assert.Equal(500, root.GetProperty("transferId").GetInt64());
        Assert.Equal(99, root.GetProperty("eggId").GetInt64());
        Assert.Equal(11111, root.GetProperty("senderRobloxUserId").GetInt64());
        Assert.Equal(22222, root.GetProperty("receiverRobloxUserId").GetInt64());
        Assert.Equal("PENDING", root.GetProperty("status").GetString());
    }
}
