using System.Text.Json;
using ImperiusDraconisAPI.Models.Game.Eggs;
using Xunit;

namespace ImperiusDraconisAPI.Tests;

public sealed class GameEggDefinitionTests
{
    [Fact]
    public void GameEggDefinition_CanBeInitializedAndSerialized()
    {
        var definition = new GameEggDefinition
        {
            Code = "ELEMENTAL_FIRE",
            DisplayName = "Huevo Elemental de Fuego",
            Description = "Contiene la esencia de las llamas eternas de la academia.",
            PriceDracoins = 650,
            IncubationMinutes = 120,
            DefaultRarity = "RARE",
            Active = true,
            Purchasable = true,
            SortOrder = 20
        };

        Assert.Equal("ELEMENTAL_FIRE", definition.Code);
        Assert.Equal("Huevo Elemental de Fuego", definition.DisplayName);
        Assert.Equal(650, definition.PriceDracoins);
        Assert.Equal(120, definition.IncubationMinutes);
        Assert.Equal("RARE", definition.DefaultRarity);
        Assert.True(definition.Active);
        Assert.True(definition.Purchasable);
        Assert.Equal(20, definition.SortOrder);

        var json = JsonSerializer.Serialize(definition, new JsonSerializerOptions(JsonSerializerDefaults.Web));
        using var document = JsonDocument.Parse(json);
        var root = document.RootElement;

        Assert.Equal("ELEMENTAL_FIRE", root.GetProperty("code").GetString());
        Assert.Equal("Huevo Elemental de Fuego", root.GetProperty("displayName").GetString());
        Assert.Equal(650, root.GetProperty("priceDracoins").GetInt32());
        Assert.Equal(120, root.GetProperty("incubationMinutes").GetInt32());
        Assert.Equal("RARE", root.GetProperty("defaultRarity").GetString());
        Assert.True(root.GetProperty("active").GetBoolean());
        Assert.True(root.GetProperty("purchasable").GetBoolean());
        Assert.Equal(20, root.GetProperty("sortOrder").GetInt32());
    }
}
