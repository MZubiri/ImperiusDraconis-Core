using System;
using System.Text.Json;
using ImperiusDraconisAPI.Models.Game.Dragons;
using Xunit;

namespace ImperiusDraconisAPI.Tests;

public sealed class GameDragonTests
{
    [Fact]
    public void GameDragon_CanBeInitializedAndSerialized()
    {
        var hatchedAt = DateTime.UtcNow;
        var dragon = new GameDragon
        {
            Id = 42,
            IdAlumno = 10,
            Name = "Ignis",
            Rarity = "RARE",
            Temperament = "AGRESIVO",
            Level = 1,
            Stage = "BABY",
            HatchedAt = hatchedAt
        };

        Assert.Equal(42, dragon.Id);
        Assert.Equal(10, dragon.IdAlumno);
        Assert.Equal("Ignis", dragon.Name);
        Assert.Equal("RARE", dragon.Rarity);
        Assert.Equal("AGRESIVO", dragon.Temperament);
        Assert.Equal(1, dragon.Level);
        Assert.Equal("BABY", dragon.Stage);
        Assert.Equal(hatchedAt, dragon.HatchedAt);

        var json = JsonSerializer.Serialize(dragon, new JsonSerializerOptions(JsonSerializerDefaults.Web));
        using var document = JsonDocument.Parse(json);
        var root = document.RootElement;

        Assert.Equal(42, root.GetProperty("id").GetInt64());
        Assert.Equal(10, root.GetProperty("idAlumno").GetInt32());
        Assert.Equal("Ignis", root.GetProperty("name").GetString());
        Assert.Equal("RARE", root.GetProperty("rarity").GetString());
        Assert.Equal("AGRESIVO", root.GetProperty("temperament").GetString());
        Assert.Equal(1, root.GetProperty("level").GetInt32());
        Assert.Equal("BABY", root.GetProperty("stage").GetString());
    }

    [Fact]
    public void HatchGameEggRequest_CanBeInitializedAndSerialized()
    {
        var request = new HatchGameEggRequest
        {
            RobloxUserId = 12345678,
            Name = "Saphira"
        };

        Assert.Equal(12345678, request.RobloxUserId);
        Assert.Equal("Saphira", request.Name);
    }

    [Fact]
    public void SelectDragonRequest_CanBeInitializedAndSerialized()
    {
        var request = new SelectDragonRequest
        {
            RobloxUserId = 87654321
        };

        Assert.Equal(87654321, request.RobloxUserId);

        var json = JsonSerializer.Serialize(request, new JsonSerializerOptions(JsonSerializerDefaults.Web));
        using var document = JsonDocument.Parse(json);
        var root = document.RootElement;

        Assert.Equal(87654321, root.GetProperty("robloxUserId").GetInt64());
    }

    [Fact]
    public void SelectDragonResponse_CanBeInitializedAndSerialized()
    {
        var response = new SelectDragonResponse
        {
            DragonId = 123,
            Selected = true
        };

        Assert.Equal(123, response.DragonId);
        Assert.True(response.Selected);

        var json = JsonSerializer.Serialize(response, new JsonSerializerOptions(JsonSerializerDefaults.Web));
        using var document = JsonDocument.Parse(json);
        var root = document.RootElement;

        Assert.Equal(123, root.GetProperty("dragonId").GetInt64());
        Assert.True(root.GetProperty("selected").GetBoolean());
    }
}

