using ImperiusDraconisAPI.Models.Dinamicas;
using ImperiusDraconisAPI.Models.Marcadores;
using ImperiusDraconisAPI.Services;
using System.Text.Json;
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

        var owl = Assert.Single(result.LechuzasDetectadas);
        Assert.Equal("💚", owl.EmojiCasa);
        Assert.Equal("Ale", owl.Duenio);
        Assert.Equal("Piper", owl.Nombre);
        Assert.Equal(10, owl.DetectedRoundNumber);
        Assert.Equal(["💚", "💙", "💛", "❤️"], result.Rounds.Single().Top);
        Assert.Equal(["💛", "💙", "💛", "💛", "❤️", "💚", "💚", "❤️", "💛"], result.Rounds.Single().Responses);
    }

    [Fact]
    public void Analyze_DetectsOwlInMiddleOfRound()
    {
        var result = Analyze("3. ❤️💚💙🦉Luna - Athena💛💙");

        var owl = Assert.Single(result.LechuzasDetectadas);
        Assert.Equal("Luna", owl.Duenio);
        Assert.Equal("Athena", owl.Nombre);
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
            result.LechuzasDetectadas,
            owl =>
            {
                Assert.Equal("Hedwig", owl.Nombre);
                Assert.Equal(1, owl.DetectedRoundNumber);
            },
            owl =>
            {
                Assert.Equal("Athena", owl.Nombre);
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

        Assert.Single(result.LechuzasDetectadas);
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

        var owl = Assert.Single(result.LechuzasDetectadas);
        Assert.Equal(5, owl.DetectedRoundNumber);
        Assert.Equal(8, owl.Ronda);
    }

    [Fact]
    public void Analyze_SerializesDetectedOwlsForFrontend()
    {
        var result = Analyze("10. 💚🦉Ale - Piper💙💛❤️");

        var json = JsonSerializer.Serialize(result, new JsonSerializerOptions(JsonSerializerDefaults.Web));
        using var document = JsonDocument.Parse(json);
        var owl = document.RootElement.GetProperty("lechuzasDetectadas")[0];

        Assert.Equal("Slytherin", owl.GetProperty("casa").GetString());
        Assert.Equal("💚", owl.GetProperty("emojiCasa").GetString());
        Assert.Equal("Ale", owl.GetProperty("duenio").GetString());
        Assert.Equal("Piper", owl.GetProperty("nombre").GetString());
        Assert.Equal(10, owl.GetProperty("ronda").GetInt32());
    }

    private AutomaticPointsAnalysisDto Analyze(string text) =>
        _service.Analyze(new AutomaticPointsAnalyzeRequest { Text = text }, Houses);

    private static int PointsFor(AutomaticPointsRoundDto round, string emoji) =>
        round.PointsByHouse.Single(item => item.HouseEmoji == emoji).Points;
}
