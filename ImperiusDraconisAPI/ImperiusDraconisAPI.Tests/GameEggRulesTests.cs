using ImperiusDraconisAPI.Common;
using ImperiusDraconisAPI.Services.Game;
using Xunit;

namespace ImperiusDraconisAPI.Tests;

public sealed class GameEggRulesTests
{
    [Theory]
    [InlineData("common", "COMMON")]
    [InlineData(" RARE ", "RARE")]
    [InlineData("MYTHIC", "MYTHIC")]
    public void NormalizeRarity_ReturnsCanonicalValue(string value, string expected)
    {
        Assert.Equal(expected, GameEggRules.NormalizeRarity(value));
    }

    [Fact]
    public void NormalizeRarity_RejectsUnknownValue()
    {
        var exception = Assert.Throws<GameBusinessRuleException>(
            () => GameEggRules.NormalizeRarity("ULTRA"));

        Assert.Equal("INVALID_EGG_STATE", exception.Code);
    }

    [Fact]
    public void ValidateState_RejectsOwnedEggWithIncubationDates()
    {
        var acquiredAt = DateTime.UtcNow;

        Assert.Throws<GameBusinessRuleException>(() => GameEggRules.ValidateState(
            "OWNED",
            acquiredAt,
            acquiredAt,
            acquiredAt.AddHours(1)));
    }

    [Fact]
    public void GetEffectiveStatus_ReturnsReadyWhenIncubationExpired()
    {
        var utcNow = DateTime.UtcNow;

        Assert.Equal(
            "READY_TO_HATCH",
            GameEggRules.GetEffectiveStatus("INCUBATING", utcNow.AddMinutes(-1), utcNow));
        Assert.Equal(
            "INCUBATING",
            GameEggRules.GetEffectiveStatus("INCUBATING", utcNow.AddMinutes(1), utcNow));
    }

    [Fact]
    public void ValidateTransition_RejectsReturningIncubatingEggToOwned()
    {
        Assert.Throws<GameBusinessRuleException>(() => GameEggRules.ValidateTransition(
            "INCUBATING",
            "OWNED",
            null,
            DateTime.UtcNow));
    }

    [Fact]
    public void ValidateTransition_RejectsReadyStatusBeforeIncubationEnds()
    {
        var utcNow = DateTime.UtcNow;

        Assert.Throws<GameBusinessRuleException>(() => GameEggRules.ValidateTransition(
            "INCUBATING",
            "READY_TO_HATCH",
            utcNow.AddMinutes(1),
            utcNow));
    }
}
