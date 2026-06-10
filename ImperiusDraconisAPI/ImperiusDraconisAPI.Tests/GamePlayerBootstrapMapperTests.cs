using System.Text.Json;
using ImperiusDraconisAPI.Models.Game.Eggs;
using ImperiusDraconisAPI.Models.Game.Players;
using ImperiusDraconisAPI.Services.Game;
using Xunit;

namespace ImperiusDraconisAPI.Tests;

public sealed class GamePlayerBootstrapMapperTests
{
    [Fact]
    public void Map_BuildsCurrentBootstrapWithStableFuturePlaceholders()
    {
        var result = GamePlayerBootstrapMapper.Map(
            "1.0.0",
            1,
            123456789,
            "Luna",
            "Ravenclaw",
            84885m,
            0,
            10);

        Assert.Equal("1.0.0", result.GameVersion);
        Assert.Equal(123456789, result.Player.RobloxUserId);
        Assert.Equal("Luna", result.Player.DisplayName);
        Assert.Equal("Ravenclaw", result.Player.HouseName);
        Assert.Equal(84885m, result.Economy.Dracoins);
        Assert.Equal(1, result.Capacity.BaseSlots);
        Assert.Equal(0, result.Capacity.PurchasedSlots);
        Assert.Equal(1, result.Capacity.TotalSlots);
        Assert.Equal(10, result.Capacity.MaxCapacity);
        Assert.Equal(1, result.Capacity.AvailableSlots);
        Assert.Empty(result.Eggs);
        Assert.Empty(result.Dragons);
        Assert.Null(result.SelectedDragon);
        Assert.Null(result.Ranking);
    }

    [Fact]
    public void Map_IncludesPurchasedSlotsInTotalAndAvailableCapacity()
    {
        var result = GamePlayerBootstrapMapper.Map(
            "1.0.0",
            1,
            123,
            "Harry",
            "Gryffindor",
            400m,
            4,
            10);

        Assert.Equal(5, result.Capacity.TotalSlots);
        Assert.Equal(5, result.Capacity.AvailableSlots);
    }

    [Fact]
    public void Map_DoesNotReportCapacityAboveConfiguredMaximum()
    {
        var result = GamePlayerBootstrapMapper.Map(
            "1.0.0",
            1,
            123,
            "Harry",
            "Gryffindor",
            400m,
            9,
            8);

        Assert.Equal(8, result.Capacity.TotalSlots);
        Assert.Equal(8, result.Capacity.AvailableSlots);
    }

    [Fact]
    public void Map_IncludesEggsAndSubtractsOnlyActiveEggsFromCapacity()
    {
        var acquiredAt = new DateTime(2026, 6, 9, 12, 0, 0, DateTimeKind.Utc);
        var result = GamePlayerBootstrapMapper.Map(
            "1.0.0",
            1,
            123,
            "Harry",
            "Gryffindor",
            400m,
            2,
            10,
            [
                new GameEgg
                {
                    Id = 10,
                    IdAlumno = 3,
                    EggDefinitionCode = "ELEMENTAL_FIRE",
                    Rarity = "RARE",
                    AcquiredAt = acquiredAt,
                    Status = "OWNED"
                },
                new GameEgg
                {
                    Id = 11,
                    IdAlumno = 3,
                    Rarity = "COMMON",
                    AcquiredAt = acquiredAt,
                    IncubationStartedAt = acquiredAt,
                    IncubationEndsAt = acquiredAt.AddHours(1),
                    Status = "HATCHED"
                }
            ]);

        Assert.Equal(2, result.Eggs.Count);
        Assert.Equal(2, result.Capacity.AvailableSlots);
        var egg = Assert.Single(result.Eggs, item => item.Id == 10);
        Assert.Equal("ELEMENTAL_FIRE", egg.EggDefinitionCode);
        Assert.Equal("RARE", egg.Rarity);
        Assert.Equal("OWNED", egg.Status);
        Assert.Null(Assert.Single(result.Eggs, item => item.Id == 11).EggDefinitionCode);
    }

    [Fact]
    public void Map_SerializesExpectedJsonContract()
    {
        var result = GamePlayerBootstrapMapper.Map(
            "1.0.0",
            1,
            123456789,
            "Luna",
            "Ravenclaw",
            84885m,
            0,
            10);

        using var document = JsonDocument.Parse(
            JsonSerializer.Serialize(result, new JsonSerializerOptions(JsonSerializerDefaults.Web)));
        var root = document.RootElement;

        Assert.Equal("1.0.0", root.GetProperty("gameVersion").GetString());
        Assert.Equal(123456789, root.GetProperty("player").GetProperty("robloxUserId").GetInt64());
        Assert.Equal(84885m, root.GetProperty("economy").GetProperty("dracoins").GetDecimal());
        Assert.Equal(1, root.GetProperty("capacity").GetProperty("availableSlots").GetInt32());
        Assert.Equal(0, root.GetProperty("eggs").GetArrayLength());
        Assert.Equal(0, root.GetProperty("dragons").GetArrayLength());
        Assert.Equal(JsonValueKind.Null, root.GetProperty("selectedDragon").ValueKind);
        Assert.Equal(JsonValueKind.Null, root.GetProperty("ranking").ValueKind);
    }

    [Fact]
    public void Map_IncludesDragonsAndCalculatesCapacityCorrectly()
    {
        var hatchedAt = new DateTime(2026, 6, 10, 12, 0, 0, DateTimeKind.Utc);
        var dragons = new[]
        {
            new GameBootstrapDragonDto
            {
                Id = 1,
                Name = "Aurelia",
                Rarity = "LEGENDARY",
                Temperament = "NOBLE",
                SpeciesCode = "ELEMENTAL_FIRE",
                Level = 3,
                Stage = "YOUNG",
                HatchedAt = hatchedAt,
                Life = 90,
                Happiness = 80,
                Hunger = 70,
                Experience = 150,
                Status = "ACTIVE",
                Selected = true,
                LastNeedsUpdateAt = hatchedAt
            },
            new GameBootstrapDragonDto
            {
                Id = 2,
                Name = "Draco",
                Rarity = "COMMON",
                Temperament = "PEREZOSO",
                SpeciesCode = "ELEMENTAL_EARTH",
                Level = 1,
                Stage = "BABY",
                HatchedAt = hatchedAt,
                Life = 0,
                Happiness = 0,
                Hunger = 0,
                Experience = 0,
                Status = "FLED",
                Selected = false,
                LastNeedsUpdateAt = hatchedAt
            }
        };

        var result = GamePlayerBootstrapMapper.Map(
            "1.0.0",
            1, // base slots
            123,
            "Harry",
            "Gryffindor",
            400m,
            2, // purchased slots (total slots = 3)
            10,
            [
                new GameEgg
                {
                    Id = 10,
                    Status = "OWNED" // consumes 1 slot
                },
                new GameEgg
                {
                    Id = 11,
                    Status = "HATCHED" // consumes 0 slots
                }
            ],
            dragons // dragons: Aurelia (ACTIVE, consumes 1 slot), Draco (FLED, consumes 0 slots)
        );

        // total slots = 3. occupied slots = 1 (egg 10) + 1 (dragon 1) = 2.
        // available slots = 3 - 2 = 1.
        Assert.Equal(3, result.Capacity.TotalSlots);
        Assert.Equal(1, result.Capacity.AvailableSlots);
        Assert.Equal(2, result.Dragons.Count);
        
        Assert.NotNull(result.SelectedDragon);
        Assert.Equal(1, result.SelectedDragon.Id);
        Assert.Equal("Aurelia", result.SelectedDragon.Name);
        Assert.Equal("LEGENDARY", result.SelectedDragon.Rarity);
        Assert.Equal("NOBLE", result.SelectedDragon.Temperament);
        Assert.Equal("ELEMENTAL_FIRE", result.SelectedDragon.SpeciesCode);
        Assert.Equal(3, result.SelectedDragon.Level);
        Assert.Equal("YOUNG", result.SelectedDragon.Stage);
        Assert.Equal(90, result.SelectedDragon.Life);
        Assert.Equal(80, result.SelectedDragon.Happiness);
        Assert.Equal(70, result.SelectedDragon.Hunger);
        Assert.Equal(150, result.SelectedDragon.Experience);
        Assert.Equal("ACTIVE", result.SelectedDragon.Status);
        Assert.True(result.SelectedDragon.Selected);
    }
}

