using System.Globalization;
using System.Text;
using System.Text.RegularExpressions;
using ImperiusDraconisAPI.Common;
using ImperiusDraconisAPI.Models.Dinamicas;
using ImperiusDraconisAPI.Models.Marcadores;

namespace ImperiusDraconisAPI.Services;

public sealed partial class AutomaticHousePointsService
{
    private static readonly string[] HouseEmojis = ["❤️", "💚", "💙", "💛"];
    private static readonly int[] TopPoints = [30, 25, 20, 15];
    private const int ResponsePoints = 20;

    public AutomaticPointsAnalysisDto Analyze(
        AutomaticPointsAnalyzeRequest request,
        IReadOnlyCollection<MarcadorCasaDto> houses)
    {
        var text = request.Text?.Trim() ?? string.Empty;
        if (string.IsNullOrWhiteSpace(text))
        {
            throw new BusinessRuleException("Pega el texto de la dinamica antes de analizar.");
        }

        var warnings = new List<string>();
        var houseLookup = BuildHouseLookup(houses, warnings);
        var roundMatches = RoundStartRegex().Matches(text);
        if (roundMatches.Count == 0)
        {
            warnings.Add("No se detectaron rondas.");
            return BuildEmptyAnalysis(DetectName(text), warnings);
        }

        var detectedName = DetectName(text[..roundMatches[0].Index]);
        var firstRound = ParseRoundNumber(roundMatches[0]);
        var frogs = ParseFrogs(text[..roundMatches[0].Index], firstRound, houseLookup, request.FrogAdjustments, warnings);
        var adjustments = request.RoundAdjustments
            .GroupBy(item => item.RoundNumber)
            .ToDictionary(group => group.Key, group => group.Last());
        var rounds = new List<AutomaticPointsRoundDto>();

        for (var index = 0; index < roundMatches.Count; index++)
        {
            var match = roundMatches[index];
            var end = index + 1 < roundMatches.Count ? roundMatches[index + 1].Index : text.Length;
            var segment = text[match.Index..end];
            var roundNumber = ParseRoundNumber(match);
            rounds.Add(ParseRound(segment, roundNumber, frogs, houseLookup, adjustments.GetValueOrDefault(roundNumber), warnings));
        }

        AddSequenceWarnings(rounds, warnings);
        var totals = BuildTotals(houseLookup, rounds.SelectMany(item => item.PointsByHouse));

        return new AutomaticPointsAnalysisDto
        {
            DetectedName = detectedName,
            Frogs = frogs,
            Rounds = rounds,
            Totals = totals,
            Warnings = warnings.Distinct().ToArray()
        };
    }

    private static AutomaticPointsRoundDto ParseRound(
        string segment,
        int roundNumber,
        IReadOnlyCollection<AutomaticPointsFrogDto> frogs,
        IReadOnlyDictionary<string, HouseInfo> houseLookup,
        AutomaticPointsRoundAdjustmentRequest? adjustment,
        List<string> warnings)
    {
        var detectedMultiplier = DetectMultiplier(segment);
        var detectedCancelled = segment.Contains("❌", StringComparison.Ordinal) || segment.Contains("//", StringComparison.Ordinal);
        var multiplier = adjustment?.Multiplier ?? detectedMultiplier;
        var cancelled = adjustment?.Cancelled ?? detectedCancelled;
        var content = RoundStartRegex().Replace(segment, string.Empty, 1).Trim();
        var groups = HouseGroupRegex().Matches(content)
            .Select(match => MatchHouseEmojis(match.Value))
            .Where(group => group.Count > 0)
            .ToList();
        var top = groups.FirstOrDefault() ?? [];
        var responses = groups.Skip(1).SelectMany(group => group).ToList();

        if (UnknownHouseEmojiRegex().IsMatch(content))
        {
            warnings.Add($"Ronda {roundNumber}: hay emojis de casa no reconocidos.");
        }

        if (HasUninterpretedText(content))
        {
            warnings.Add($"Ronda {roundNumber}: hay texto que no pudo interpretarse.");
        }

        if (top.Count < 4)
        {
            warnings.Add($"Ronda {roundNumber}: el top tiene menos de 4 casas.");
        }
        else if (top.Count > 4)
        {
            warnings.Add($"Ronda {roundNumber}: el top tiene mas de 4 casas; solo se usan las primeras 4.");
        }

        if (detectedCancelled)
        {
            warnings.Add($"Ronda {roundNumber}: ronda anulada detectada.");
        }

        var scores = new Dictionary<string, int>();
        if (!cancelled)
        {
            for (var index = 0; index < Math.Min(4, top.Count); index++)
            {
                AddPoints(scores, top[index], TopPoints[index] * multiplier);
            }

            foreach (var emoji in responses)
            {
                AddPoints(scores, emoji, ResponsePoints * multiplier);
            }

            foreach (var frog in frogs.Where(item => item.StartRound <= roundNumber))
            {
                AddPoints(scores, frog.HouseEmoji, ResponsePoints * multiplier);
            }
        }

        return new AutomaticPointsRoundDto
        {
            RoundNumber = roundNumber,
            DetectedMultiplier = detectedMultiplier,
            Multiplier = multiplier,
            DetectedCancelled = detectedCancelled,
            Cancelled = cancelled,
            Top = top,
            Responses = responses,
            PointsByHouse = BuildTotals(houseLookup, scores.Select(item => new AutomaticPointsHouseTotalDto
            {
                HouseEmoji = item.Key,
                Points = item.Value
            }))
        };
    }

    private static IReadOnlyCollection<AutomaticPointsFrogDto> ParseFrogs(
        string prefix,
        int firstRound,
        IReadOnlyDictionary<string, HouseInfo> houseLookup,
        IReadOnlyCollection<AutomaticPointsFrogAdjustmentRequest> adjustments,
        List<string> warnings)
    {
        var adjustmentLookup = adjustments
            .GroupBy(item => item.Index)
            .ToDictionary(group => group.Key, group => group.Last());
        var frogs = new List<AutomaticPointsFrogDto>();
        var matches = FrogRegex().Matches(prefix);
        for (var index = 0; index < matches.Count; index++)
        {
            var emoji = NormalizeHeart(matches[index].Groups["house"].Value);
            if (!HouseEmojis.Contains(emoji, StringComparer.Ordinal) || !houseLookup.TryGetValue(emoji, out var house))
            {
                warnings.Add($"Sapo {index + 1}: casa no reconocida.");
                continue;
            }

            if (!adjustmentLookup.ContainsKey(index))
            {
                warnings.Add($"Sapo {index + 1}: sin ronda inicial explicita; se usa la primera ronda.");
            }

            frogs.Add(new AutomaticPointsFrogDto
            {
                Index = index,
                HouseEmoji = emoji,
                IdCasa = house.IdCasa,
                HouseName = house.Name,
                Description = matches[index].Groups["description"].Value.Trim(),
                StartRound = adjustmentLookup.GetValueOrDefault(index)?.StartRound ?? firstRound
            });
        }

        return frogs;
    }

    private static Dictionary<string, HouseInfo> BuildHouseLookup(
        IReadOnlyCollection<MarcadorCasaDto> houses,
        List<string> warnings)
    {
        var lookup = new Dictionary<string, HouseInfo>();
        AddHouse("❤️", "gryffindor");
        AddHouse("💚", "slytherin");
        AddHouse("💙", "ravenclaw");
        AddHouse("💛", "hufflepuff");
        return lookup;

        void AddHouse(string emoji, string expectedName)
        {
            var house = houses.FirstOrDefault(item => NormalizeText(item.NombreCasa).Contains(expectedName, StringComparison.Ordinal));
            if (house is null)
            {
                warnings.Add($"No se encontro la casa {expectedName} en la base de datos.");
                return;
            }

            lookup[emoji] = new HouseInfo(house.IdCasa, house.NombreCasa);
        }
    }

    private static IReadOnlyCollection<AutomaticPointsHouseTotalDto> BuildTotals(
        IReadOnlyDictionary<string, HouseInfo> houseLookup,
        IEnumerable<AutomaticPointsHouseTotalDto> values)
    {
        var points = values
            .GroupBy(item => item.HouseEmoji)
            .ToDictionary(group => group.Key, group => group.Sum(item => item.Points));

        return HouseEmojis
            .Where(houseLookup.ContainsKey)
            .Select(emoji => new AutomaticPointsHouseTotalDto
            {
                HouseEmoji = emoji,
                IdCasa = houseLookup[emoji].IdCasa,
                HouseName = houseLookup[emoji].Name,
                Points = points.GetValueOrDefault(emoji)
            })
            .ToArray();
    }

    private static List<string> MatchHouseEmojis(string value) =>
        HouseEmojiRegex().Matches(value).Select(match => NormalizeHeart(match.Value)).ToList();

    private static string DetectName(string prefix)
    {
        foreach (var line in prefix.Split(['\r', '\n'], StringSplitOptions.RemoveEmptyEntries))
        {
            var trimmed = line.Trim();
            if (!string.IsNullOrWhiteSpace(trimmed) &&
                !trimmed.Contains("🐸", StringComparison.Ordinal) &&
                !HouseEmojiRegex().IsMatch(trimmed))
            {
                return trimmed;
            }
        }

        return string.Empty;
    }

    private static int DetectMultiplier(string text)
    {
        if (TripleRegex().IsMatch(text))
        {
            return 3;
        }

        return DoubleRegex().IsMatch(text) ? 2 : 1;
    }

    private static bool HasUninterpretedText(string content)
    {
        var remaining = HouseEmojiRegex().Replace(content, string.Empty);
        remaining = UnknownHouseEmojiRegex().Replace(remaining, string.Empty);
        remaining = TripleRegex().Replace(remaining, string.Empty);
        remaining = DoubleRegex().Replace(remaining, string.Empty);
        remaining = remaining.Replace("❌", string.Empty, StringComparison.Ordinal)
            .Replace("//", string.Empty, StringComparison.Ordinal);
        return Regex.Replace(remaining, @"[\s\p{P}\p{S}]+", string.Empty).Length > 0;
    }

    private static void AddSequenceWarnings(IReadOnlyList<AutomaticPointsRoundDto> rounds, List<string> warnings)
    {
        for (var index = 1; index < rounds.Count; index++)
        {
            if (rounds[index].RoundNumber != rounds[index - 1].RoundNumber + 1)
            {
                warnings.Add("Hay rondas no correlativas.");
                return;
            }
        }
    }

    private static void AddPoints(IDictionary<string, int> scores, string emoji, int points)
    {
        scores.TryGetValue(emoji, out var current);
        scores[emoji] = current + points;
    }

    private static int ParseRoundNumber(Match match) =>
        int.Parse(match.Groups["number"].Value, CultureInfo.InvariantCulture);

    private static string NormalizeHeart(string emoji) => emoji.Contains('❤') ? "❤️" : emoji;

    private static string NormalizeText(string value)
    {
        var normalized = value.Normalize(NormalizationForm.FormD);
        var builder = new StringBuilder();
        foreach (var character in normalized)
        {
            if (CharUnicodeInfo.GetUnicodeCategory(character) != UnicodeCategory.NonSpacingMark)
            {
                builder.Append(char.ToLowerInvariant(character));
            }
        }

        return builder.ToString().Normalize(NormalizationForm.FormC);
    }

    private static AutomaticPointsAnalysisDto BuildEmptyAnalysis(string detectedName, IReadOnlyCollection<string> warnings) =>
        new()
        {
            DetectedName = detectedName,
            Warnings = warnings
        };

    private sealed record HouseInfo(int IdCasa, string Name);

    [GeneratedRegex(@"(?<!\d)(?<number>\d+)\s*[\.\-\)]\s*", RegexOptions.Multiline)]
    private static partial Regex RoundStartRegex();

    [GeneratedRegex(@"(?<house>\S+)[ \t]*🐸[ \t]*(?<description>.*?)(?=\S+[ \t]*🐸|$)", RegexOptions.Singleline)]
    private static partial Regex FrogRegex();

    [GeneratedRegex(@"(?:❤️|❤|💚|💙|💛)+")]
    private static partial Regex HouseGroupRegex();

    [GeneratedRegex(@"❤️|❤|💚|💙|💛")]
    private static partial Regex HouseEmojiRegex();

    [GeneratedRegex(@"🧡|💜|🖤|🤍|🤎|💔|💕|💖|💗|💘|💝")]
    private static partial Regex UnknownHouseEmojiRegex();

    [GeneratedRegex(@"(?:\btriple\b|\btriples\b|\bx3\b|\*3)", RegexOptions.IgnoreCase)]
    private static partial Regex TripleRegex();

    [GeneratedRegex(@"(?:\bdoble\b|\bdobles\b|\bx2\b|\*2)", RegexOptions.IgnoreCase)]
    private static partial Regex DoubleRegex();
}
