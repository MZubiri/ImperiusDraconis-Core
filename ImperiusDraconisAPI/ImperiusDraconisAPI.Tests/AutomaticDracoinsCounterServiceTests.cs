using ImperiusDraconisAPI.Models.Dinamicas;
using ImperiusDraconisAPI.Services;
using Xunit;

namespace ImperiusDraconisAPI.Tests;

public sealed class AutomaticDracoinsCounterServiceTests
{
    private readonly AutomaticDracoinsCounterService _service = new();

    [Fact]
    public void Analyze_CalculatesBaseFormatAndCopyText()
    {
        var result = Analyze(
            """
            Dinamica Ejemplo

            1. 🥇🥈🥉🏅
            🎖️(🏵️🎗️)🐾🌸
            """);

        Assert.Equal("Dinamica Ejemplo", result.DetectedName);
        Assert.Equal(30, DracoinsFor(result, "🥇"));
        Assert.Equal(25, DracoinsFor(result, "🥈"));
        Assert.Equal(20, DracoinsFor(result, "🥉"));
        Assert.Equal(15, DracoinsFor(result, "🏅"));
        Assert.Equal(10, DracoinsFor(result, "🎖️"));
        Assert.Equal(10, DracoinsFor(result, "🏵️🎗️"));
        Assert.Contains("🥇 30", result.CopyText);
    }

    [Fact]
    public void Analyze_DetectsMultiplierFromMetaLine()
    {
        var result = Analyze(
            """
            1. 🐍🦁🦅🐝
            🐾
            > DOBLES
            """);

        var round = Assert.Single(result.Rounds);
        Assert.Equal(2, round.DetectedMultiplier);
        Assert.Equal(60, DracoinsFor(result, "🐍"));
        Assert.Equal(20, DracoinsFor(result, "🐾"));
    }

    [Fact]
    public void Analyze_KeepsParenthesesGroupsAndZwjEmojiAsParticipants()
    {
        var result = Analyze(
            """
            1. 🐽🐝(🐶🐭)🕷
            (👑🐺)🥋🪅🧟‍♂️
            """);

        Assert.Equal(20, DracoinsFor(result, "🐶🐭"));
        Assert.Equal(10, DracoinsFor(result, "👑🐺"));
        Assert.Equal(10, DracoinsFor(result, "🧟‍♂️"));
    }

    [Fact]
    public void Analyze_UsesManualMultiplierAdjustment()
    {
        var result = _service.Analyze(new AutomaticDracoinsAnalyzeRequest
        {
            Text = """
                1. 🐍🦁🦅🐝
                🐾
                > DOBLES
                """,
            RoundAdjustments = [new AutomaticDracoinsRoundAdjustmentRequest { RoundNumber = 1, Multiplier = 3 }]
        });

        Assert.Equal(3, result.Rounds.Single().Multiplier);
        Assert.Equal(90, DracoinsFor(result, "🐍"));
        Assert.Equal(30, DracoinsFor(result, "🐾"));
    }

    [Fact]
    public void Analyze_AppliesFlashDracoinsRuleWithFixedTopSix()
    {
        var result = _service.Analyze(new AutomaticDracoinsAnalyzeRequest
        {
            Text = """
                1. 🐍🦁🦅🐝🐾🌸
                🐺🐈
                > DOBLES
                """,
            RuleSet = "flash-dracoins"
        });

        Assert.Equal(20, DracoinsFor(result, "🐍"));
        Assert.Equal(20, DracoinsFor(result, "🌸"));
        Assert.Equal(10, DracoinsFor(result, "🐺"));
        Assert.Equal(1, result.Rounds.Single().Multiplier);
    }

    [Fact]
    public void Analyze_AppliesFlashPuntosRuleWithFixedTopSix()
    {
        var result = _service.Analyze(new AutomaticDracoinsAnalyzeRequest
        {
            Text = """
                1. 🐍🦁🦅🐝🐾🌸
                🐺🐈
                """,
            RuleSet = "flash-puntos"
        });

        Assert.Equal(50, DracoinsFor(result, "🐍"));
        Assert.Equal(50, DracoinsFor(result, "🌸"));
        Assert.Equal(20, DracoinsFor(result, "🐺"));
    }

    [Fact]
    public void Analyze_IgnoresParticipantsRepeatedInTopWhenParsingOthers()
    {
        var result = Analyze(
            """
            1. 🐍🦁🦅🐝
            🐍🐾
            """);

        Assert.Equal(30, DracoinsFor(result, "🐍"));
        Assert.Equal(10, DracoinsFor(result, "🐾"));
        Assert.Contains(result.Warnings, warning => warning.Contains("Top y tambien en Otros", StringComparison.Ordinal));
    }

    [Fact]
    public void Analyze_SupportsSuperscriptRoundPrefix()
    {
        var result = Analyze(
            """
            ¹𓍯 ▸ 🐍🦁🦅🐝
            🐾
            """);

        Assert.Equal(1, result.Rounds.Single().RoundNumber);
        Assert.Equal(30, DracoinsFor(result, "🐍"));
    }

    [Fact]
    public void Analyze_WarnsWhenRoundsAreMissingOrMalformed()
    {
        var result = Analyze(
            """
            1. 🐍🦁
            3. 🦅🐝🐾🌸
            """);

        Assert.Contains(result.Warnings, warning => warning.Contains("no tiene segunda linea", StringComparison.Ordinal));
        Assert.Contains(result.Warnings, warning => warning.Contains("menos de 4", StringComparison.Ordinal));
        Assert.Contains(result.Warnings, warning => warning.Contains("no correlativas", StringComparison.Ordinal));
    }

    private AutomaticDracoinsAnalyzeResponse Analyze(string text) =>
        _service.Analyze(new AutomaticDracoinsAnalyzeRequest { Text = text });

    private static int DracoinsFor(AutomaticDracoinsAnalyzeResponse result, string participant) =>
        result.Totals.Single(item => item.Participant == participant).Dracoins;
}
