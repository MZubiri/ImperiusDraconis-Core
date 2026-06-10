using System.Text.Json;
using ImperiusDraconisAPI.Models.Game.Players;
using Xunit;

namespace ImperiusDraconisAPI.Tests;

public sealed class GameDragonCapacityTests
{
    [Fact]
    public void PurchaseDragonCapacityResponse_CanBeInitializedAndSerialized()
    {
        var response = new PurchaseDragonCapacityResponse
        {
            RobloxUserId = 12345678,
            PurchasedSlots = 3,
            MaxCapacity = 10,
            PricePaid = 450,
            BalanceAfter = 1550.00m
        };

        Assert.Equal(12345678, response.RobloxUserId);
        Assert.Equal(3, response.PurchasedSlots);
        Assert.Equal(10, response.MaxCapacity);
        Assert.Equal(450, response.PricePaid);
        Assert.Equal(1550.00m, response.BalanceAfter);

        var json = JsonSerializer.Serialize(response, new JsonSerializerOptions(JsonSerializerDefaults.Web));
        using var document = JsonDocument.Parse(json);
        var root = document.RootElement;

        Assert.Equal(12345678, root.GetProperty("robloxUserId").GetInt64());
        Assert.Equal(3, root.GetProperty("purchasedSlots").GetInt32());
        Assert.Equal(10, root.GetProperty("maxCapacity").GetInt32());
        Assert.Equal(450, root.GetProperty("pricePaid").GetInt32());
        Assert.Equal(1550.00m, root.GetProperty("balanceAfter").GetDecimal());
    }
}
