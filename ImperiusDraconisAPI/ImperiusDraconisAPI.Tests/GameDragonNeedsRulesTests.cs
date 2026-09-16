using ImperiusDraconisAPI.Services.Game;
using Xunit;

namespace ImperiusDraconisAPI.Tests;

public sealed class GameDragonNeedsRulesTests
{
    [Fact]
    public void ApplyDecay_UsesElapsedWholeIntervalsAndCanFlee()
    {
        var now = new DateTime(2026, 9, 16, 12, 0, 0, DateTimeKind.Utc);
        var state = GameDragonNeedsRules.ApplyDecay(1, 1, 1, now.AddHours(-12), now);

        Assert.Equal(0, state.Hunger);
        Assert.Equal(0, state.Happiness);
        Assert.Equal(0, state.Life);
        Assert.Equal("FLED", state.Status);
    }

    [Fact]
    public void ApplyDecay_DoesNotReduceLifeWhileHappinessIsHealthy()
    {
        var now = DateTime.UtcNow;
        var state = GameDragonNeedsRules.ApplyDecay(100, 100, 100, now.AddHours(-12), now);

        Assert.Equal(94, state.Hunger);
        Assert.Equal(100, state.Happiness);
        Assert.Equal(100, state.Life);
        Assert.Equal("ACTIVE", state.Status);
    }

    [Theory]
    [InlineData(0, 1, "BABY")]
    [InlineData(80, 4, "YOUNG")]
    [InlineData(250, 11, "ADULT")]
    [InlineData(1000, 20, "ADULT")]
    public void CalculateProgress_ClampsLevelAndChoosesStage(int experience, int level, string stage)
    {
        var now = DateTime.UtcNow;
        var result = GameDragonNeedsRules.CalculateProgress(experience, now.AddHours(-120), now);

        Assert.Equal(level, result.Level);
        Assert.Equal(stage, result.Stage);
    }
}
