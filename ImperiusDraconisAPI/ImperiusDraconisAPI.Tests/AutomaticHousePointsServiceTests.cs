using ImperiusDraconisAPI.Models.Dinamicas;
using ImperiusDraconisAPI.Models.Marcadores;
using ImperiusDraconisAPI.Services;
using Xunit;

namespace ImperiusDraconisAPI.Tests;

public sealed class AutomaticHousePointsServiceTests
{
    private static readonly MarcadorCasaDto[] Houses =
    [
        new() { IdCasa = 1, NombreCasa = "Gryffindor" },
        new() { IdCasa = 2, NombreCasa = "Slytherin" },
        new() { IdCasa = 3, NombreCasa = "Ravenclaw" },
        new() { IdCasa = 4, NombreCasa = "Hufflepuff" }
    ];

    private readonly AutomaticHousePointsService _service = new();

    [Fact]
    public void Analyze_DetectsOwlAtStartOfRoundBeforeBuildingTop()
    {
        var result = Analyze("10. 💚🦉Ale - Piper💙💛💛❤️💙💛💛❤️💚💚❤️💛");

        var owl = Assert.Single(result.Owls);
        Assert.Equal("💚", owl.HouseEmoji);
        Assert.Equal("Ale", owl.Owner);
        Assert.Equal("Piper", owl.Name);
        Assert.Equal(10, owl.DetectedRoundNumber);
        Assert.Equal(["💚", "💙", "💛", "❤️"], result.Rounds.Single().Top);
        Assert.Equal(["💛", "💙", "💛", "💛", "❤️", "💚", "💚", "❤️", "💛"], result.Rounds.Single().Responses);
    }

    [Fact]
    public void Analyze_DetectsOwlInMiddleOfRound()
    {
        var result = Analyze("3. ❤️💚💙🦉Luna - Athena💛💙");

        var owl = Assert.Single(result.Owls);
        Assert.Equal("Luna", owl.Owner);
        Assert.Equal("Athena", owl.Name);
        Assert.Equal(["❤️", "💚", "💙", "💛"], result.Rounds.Single().Top);
        Assert.Equal(["💙"], result.Rounds.Single().Responses);
    }

    [Fact]
    public void Analyze_DetectsMultipleOwlsInTheirRounds()
    {
        var result = Analyze(
            """
            1. ❤️🦉Harry - Hedwig💚💙💛
            2. 💙🦉Luna - Athena💚❤️💛
            """);

        Assert.Collection(
            result.Owls,
            owl =>
            {
                Assert.Equal("Hedwig", owl.Name);
                Assert.Equal(1, owl.DetectedRoundNumber);
            },
            owl =>
            {
                Assert.Equal("Athena", owl.Name);
                Assert.Equal(2, owl.DetectedRoundNumber);
            });
    }

    [Fact]
    public void Analyze_PreservesMultiplierWhenRoundContainsOwl()
    {
        var result = Analyze("4. 💛❤️💚💙🦉Cedric - Aurora x2");

        var round = Assert.Single(result.Rounds);
        Assert.Equal(2, round.Multiplier);
        Assert.Equal(2000, PointsFor(round, "💛"));
    }

    [Fact]
    public void Analyze_PreservesCancelledRoundWhenItContainsOwl()
    {
        var result = Analyze("5. ❤️🦉Harry - Hedwig💚💙💛 ❌");

        Assert.Single(result.Owls);
        var round = Assert.Single(result.Rounds);
        Assert.True(round.Cancelled);
        Assert.All(round.PointsByHouse, item => Assert.Equal(0, item.Points));
    }

    [Fact]
    public void Analyze_AppliesEditedOwlRound()
    {
        var result = _service.Analyze(
            new AutomaticPointsAnalyzeRequest
            {
                Text = "5. ❤️🦉Harry - Hedwig💚💙💛",
                OwlAdjustments = [new AutomaticPointsOwlAdjustmentRequest { Index = 0, RoundNumber = 8 }]
            },
            Houses);

        var owl = Assert.Single(result.Owls);
        Assert.Equal(5, owl.DetectedRoundNumber);
        Assert.Equal(8, owl.RoundNumber);
    }

    private AutomaticPointsAnalysisDto Analyze(string text) =>
        _service.Analyze(new AutomaticPointsAnalyzeRequest { Text = text }, Houses);

    private static int PointsFor(AutomaticPointsRoundDto round, string emoji) =>
        round.PointsByHouse.Single(item => item.HouseEmoji == emoji).Points;
}
