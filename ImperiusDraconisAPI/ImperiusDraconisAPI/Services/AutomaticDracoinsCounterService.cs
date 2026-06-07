using System.Globalization;
using System.Text;
using System.Text.RegularExpressions;
using ImperiusDraconisAPI.Common;
using ImperiusDraconisAPI.Models.Dinamicas;

namespace ImperiusDraconisAPI.Services;

public sealed partial class AutomaticDracoinsCounterService
{
    private static readonly int[] TopPoints = [30, 25, 20, 15];
    private const int OtherParticipantPoints = 10;
    private static readonly HashSet<int> InvisibleCodepoints =
    [
        0x2060, 0x200B, 0xFEFF, 0x200E, 0x200F,
        0x202A, 0x202B, 0x202C, 0x202D, 0x202E
    ];

    public AutomaticDracoinsAnalyzeResponse Analyze(AutomaticDracoinsAnalyzeRequest request)
    {
        var text = NormalizeParticipant(request.Text ?? string.Empty).Trim();
        if (string.IsNullOrWhiteSpace(text))
        {
            throw new BusinessRuleException("Pega el texto de la dinamica antes de analizar.");
        }

        var warnings = new List<string>();
        var (detectedName, blocks) = ParseBlocks(text);
        if (blocks.Count == 0)
        {
            warnings.Add("No se detectaron rondas.");
            return BuildResponse(detectedName, [], warnings);
        }

        var adjustments = request.RoundAdjustments
            .GroupBy(item => item.RoundNumber)
            .ToDictionary(group => group.Key, group => group.Last());
        var rounds = blocks
            .Select(block => ParseRound(block, adjustments.GetValueOrDefault(block.RoundNumber), warnings))
            .ToArray();

        AddSequenceWarnings(rounds, warnings);
        var totals = BuildTotals(rounds.SelectMany(round => round.PointsByParticipant));
        return BuildResponse(detectedName, rounds, warnings, totals);
    }

    private static AutomaticDracoinsRoundDto ParseRound(
        RoundBlock block,
        AutomaticDracoinsRoundAdjustmentRequest? adjustment,
        List<string> warnings)
    {
        var detectedMultiplier = block.Lines.Select(DetectMultiplier).FirstOrDefault(multiplier => multiplier > 1);
        if (detectedMultiplier == 0)
        {
            detectedMultiplier = 1;
        }

        var multiplier = adjustment?.Multiplier ?? detectedMultiplier;
        var topParticipants = ParseParticipantsFromLine(block.TopLine).ToArray();
        var otherParticipantsRaw = ParseParticipantsFromLine(block.OtherLine).ToArray();
        var topScored = topParticipants.Take(4).ToArray();
        var topScoredSet = topScored.ToHashSet(StringComparer.Ordinal);
        var ignored = otherParticipantsRaw.Where(topScoredSet.Contains).ToArray();
        var otherParticipants = otherParticipantsRaw.Where(participant => !topScoredSet.Contains(participant)).ToArray();

        if (string.IsNullOrWhiteSpace(block.OtherLine))
        {
            warnings.Add($"Ronda {block.RoundNumber}: no tiene segunda linea.");
        }

        if (topParticipants.Length < 4)
        {
            warnings.Add($"Ronda {block.RoundNumber}: top tiene menos de 4 participantes.");
        }

        if (topParticipants.Length > 4)
        {
            warnings.Add($"Ronda {block.RoundNumber}: top tiene mas de 4 participantes; solo se usan los primeros 4.");
        }

        if (ignored.Length > 0)
        {
            warnings.Add($"Ronda {block.RoundNumber}: participante aparece en Top y tambien en Otros.");
        }

        var repeated = topParticipants.Concat(otherParticipantsRaw)
            .GroupBy(participant => participant, StringComparer.Ordinal)
            .Where(group => group.Count() > 1)
            .Select(group => group.Key)
            .ToArray();
        if (repeated.Length > 0)
        {
            warnings.Add($"Ronda {block.RoundNumber}: hay participantes repetidos: {string.Join(", ", repeated)}.");
        }

        foreach (var extraLine in block.ExtraLines.Where(line => !IsMetaLine(line) && ParseParticipantsFromLine(line).Count > 0))
        {
            warnings.Add($"Ronda {block.RoundNumber}: hay texto que no pudo interpretarse: {extraLine}");
        }

        var scores = new Dictionary<string, int>(StringComparer.Ordinal);
        for (var index = 0; index < topScored.Length; index++)
        {
            AddPoints(scores, topScored[index], TopPoints[index] * multiplier);
        }

        foreach (var participant in otherParticipants)
        {
            AddPoints(scores, participant, OtherParticipantPoints * multiplier);
        }

        return new AutomaticDracoinsRoundDto
        {
            RoundNumber = block.RoundNumber,
            DetectedMultiplier = detectedMultiplier,
            Multiplier = multiplier,
            TopParticipants = topParticipants,
            OtherParticipants = otherParticipants,
            IgnoredParticipants = ignored,
            PointsByParticipant = BuildTotals(scores.Select(item => new AutomaticDracoinsParticipantResultDto
            {
                Participant = item.Key,
                Dracoins = item.Value
            }))
        };
    }

    private static (string DetectedName, IReadOnlyList<RoundBlock> Blocks) ParseBlocks(string text)
    {
        var lines = text.Split(['\r', '\n'], StringSplitOptions.RemoveEmptyEntries)
            .Select(line => line.Trim())
            .Where(line => !string.IsNullOrWhiteSpace(line))
            .ToArray();

        if (lines.Length == 0)
        {
            return (string.Empty, []);
        }

        var detectedName = string.Empty;
        var startIndex = 0;
        if (!IsRoundStartLine(lines[0]))
        {
            detectedName = lines[0];
            startIndex = 1;
        }

        var rawBlocks = new List<List<string>>();
        List<string>? currentBlock = null;
        foreach (var line in lines.Skip(startIndex))
        {
            if (IsRoundStartLine(line))
            {
                if (currentBlock is not null)
                {
                    rawBlocks.Add(currentBlock);
                }

                currentBlock = [line];
                continue;
            }

            currentBlock?.Add(line);
        }

        if (currentBlock is not null)
        {
            rawBlocks.Add(currentBlock);
        }

        return (detectedName, rawBlocks.Select(ParseBlock).ToArray());
    }

    private static RoundBlock ParseBlock(IReadOnlyList<string> block)
    {
        var topLine = block[0];
        var emojiLines = new List<string>();
        var metaLines = new List<string>();

        foreach (var line in block.Skip(1))
        {
            (IsMetaLine(line) ? metaLines : emojiLines).Add(line);
        }

        var otherLine = emojiLines.FirstOrDefault() ?? string.Empty;
        var extraLines = emojiLines.Skip(1).Concat(metaLines).ToArray();
        return new RoundBlock(GetRoundNumber(topLine), topLine, otherLine, extraLines, block);
    }

    private static IReadOnlyList<string> ParseParticipantsFromLine(string line)
    {
        var value = RemoveRoundPrefix(line.Trim());
        var participants = new List<string>();

        for (var index = 0; index < value.Length;)
        {
            if (char.IsWhiteSpace(value[index]))
            {
                index++;
                continue;
            }

            if (value[index] == '(')
            {
                var endIndex = value.IndexOf(')', index + 1);
                if (endIndex >= 0)
                {
                    var participantGroup = NormalizeParticipant(RemoveWhitespace(value[(index + 1)..endIndex]));
                    if (!string.IsNullOrWhiteSpace(participantGroup) && !IsInvisibleCluster(participantGroup))
                    {
                        participants.Add(participantGroup);
                    }

                    index = endIndex + 1;
                    continue;
                }
            }

            var element = GetNextTextElement(value, index);
            var normalized = NormalizeParticipant(element.Text);
            if (!string.IsNullOrWhiteSpace(normalized) &&
                !IsInvisibleCluster(normalized) &&
                !IsAsciiAlphanumericCluster(normalized) &&
                IsParticipantCluster(normalized))
            {
                participants.Add(normalized);
            }

            index += element.Length;
        }

        return participants.Where(participant => participant != ".").ToArray();
    }

    private static string RemoveRoundPrefix(string line)
    {
        var classicMatch = ClassicRoundStartRegex().Match(line);
        if (classicMatch.Success)
        {
            return line[classicMatch.Length..].Trim();
        }

        var superscriptMatch = SuperscriptRoundStartRegex().Match(line);
        if (!superscriptMatch.Success)
        {
            return line;
        }

        var builder = new StringBuilder();
        for (var index = superscriptMatch.Length; index < line.Length;)
        {
            var element = GetNextTextElement(line, index);
            if (builder.Length > 0 || IsRealEmojiCluster(NormalizeParticipant(element.Text)))
            {
                builder.Append(element.Text);
            }

            index += element.Length;
        }

        return builder.ToString().Trim();
    }

    private static bool IsRoundStartLine(string line) =>
        ClassicRoundStartRegex().IsMatch(line) || SuperscriptRoundStartRegex().IsMatch(line);

    private static int GetRoundNumber(string line)
    {
        var classicMatch = ClassicRoundStartRegex().Match(line);
        if (classicMatch.Success)
        {
            return int.Parse(classicMatch.Groups["number"].Value, CultureInfo.InvariantCulture);
        }

        var superscriptMatch = SuperscriptRoundStartRegex().Match(line);
        return superscriptMatch.Success
            ? int.Parse(TranslateSuperscriptDigits(superscriptMatch.Value), CultureInfo.InvariantCulture)
            : 0;
    }

    private static bool IsMetaLine(string line)
    {
        var value = line.Trim();
        if (value.StartsWith('>') || value.StartsWith('*') || value.StartsWith('•'))
        {
            return true;
        }

        if (value.StartsWith('-') && !ClassicRoundStartRegex().IsMatch(value))
        {
            return true;
        }

        return MetaKeywordRegex().IsMatch(value);
    }

    private static int DetectMultiplier(string text)
    {
        if (TripleRegex().IsMatch(text))
        {
            return 3;
        }

        return DoubleRegex().IsMatch(text) ? 2 : 1;
    }

    private static void AddSequenceWarnings(IReadOnlyList<AutomaticDracoinsRoundDto> rounds, List<string> warnings)
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

    private static IReadOnlyCollection<AutomaticDracoinsParticipantResultDto> BuildTotals(
        IEnumerable<AutomaticDracoinsParticipantResultDto> values)
    {
        return values
            .GroupBy(item => item.Participant, StringComparer.Ordinal)
            .Select(group => new AutomaticDracoinsParticipantResultDto
            {
                Participant = group.Key,
                Dracoins = group.Sum(item => item.Dracoins)
            })
            .OrderByDescending(item => item.Dracoins)
            .ThenBy(item => item.Participant, StringComparer.Ordinal)
            .ToArray();
    }

    private static AutomaticDracoinsAnalyzeResponse BuildResponse(
        string detectedName,
        IReadOnlyCollection<AutomaticDracoinsRoundDto> rounds,
        List<string> warnings,
        IReadOnlyCollection<AutomaticDracoinsParticipantResultDto>? totals = null)
    {
        var resolvedTotals = totals ?? [];
        return new AutomaticDracoinsAnalyzeResponse
        {
            DetectedName = detectedName,
            Rounds = rounds,
            Totals = resolvedTotals,
            Warnings = warnings.Distinct().ToArray(),
            CopyText = string.Join('\n', resolvedTotals.Select(item => $"{item.Participant} {item.Dracoins}"))
        };
    }

    private static void AddPoints(IDictionary<string, int> scores, string participant, int points)
    {
        scores.TryGetValue(participant, out var current);
        scores[participant] = current + points;
    }

    private static (string Text, int Length) GetNextTextElement(string value, int index)
    {
        var textElement = StringInfo.GetNextTextElement(value, index);
        return (textElement, textElement.Length);
    }

    private static string NormalizeParticipant(string value)
    {
        var builder = new StringBuilder(value.Length);
        foreach (var rune in value.EnumerateRunes())
        {
            if (!InvisibleCodepoints.Contains(rune.Value))
            {
                builder.Append(rune.ToString());
            }
        }

        return builder.ToString();
    }

    private static string RemoveWhitespace(string value)
    {
        var builder = new StringBuilder(value.Length);
        foreach (var character in value)
        {
            if (!char.IsWhiteSpace(character))
            {
                builder.Append(character);
            }
        }

        return builder.ToString();
    }

    private static bool IsInvisibleCluster(string value)
    {
        if (string.IsNullOrWhiteSpace(value))
        {
            return true;
        }

        foreach (var rune in value.EnumerateRunes())
        {
            var category = Rune.GetUnicodeCategory(rune);
            if (category is UnicodeCategory.Control or UnicodeCategory.Format or UnicodeCategory.SpaceSeparator)
            {
                continue;
            }

            if (IsParticipantRune(rune))
            {
                return false;
            }

            if (category.ToString().StartsWith("Letter", StringComparison.Ordinal) ||
                category.ToString().StartsWith("Number", StringComparison.Ordinal) ||
                category.ToString().StartsWith("Punctuation", StringComparison.Ordinal) ||
                category.ToString().StartsWith("Symbol", StringComparison.Ordinal))
            {
                return false;
            }
        }

        return true;
    }

    private static bool IsAsciiAlphanumericCluster(string value) =>
        value.All(character => character <= 127 && char.IsLetterOrDigit(character));

    private static bool IsParticipantCluster(string value) =>
        value.EnumerateRunes().Any(IsParticipantRune);

    private static bool IsRealEmojiCluster(string value) =>
        value.EnumerateRunes().Any(IsEmojiRune);

    private static bool IsParticipantRune(Rune rune)
    {
        var category = Rune.GetUnicodeCategory(rune);
        if (category is UnicodeCategory.MathSymbol or UnicodeCategory.CurrencySymbol or UnicodeCategory.ModifierSymbol or UnicodeCategory.OtherSymbol)
        {
            return true;
        }

        return rune.Value is >= 0x1F300 and <= 0x1FAFF
            or >= 0x2600 and <= 0x27BF
            or >= 0x1F1E0 and <= 0x1F1FF
            or >= 0x2300 and <= 0x23FF
            or >= 0x2B00 and <= 0x2BFF
            or >= 0x1FA00 and <= 0x1FFFF;
    }

    private static bool IsEmojiRune(Rune rune) =>
        rune.Value is >= 0x1F300 and <= 0x1FAFF
            or >= 0x2600 and <= 0x27BF
            or >= 0x1F1E0 and <= 0x1F1FF
            or >= 0x2300 and <= 0x23FF
            or >= 0x2B00 and <= 0x2BFF
            or >= 0x1FA00 and <= 0x1FFFF;

    private static string TranslateSuperscriptDigits(string value) =>
        value.Replace('⁰', '0')
            .Replace('¹', '1')
            .Replace('²', '2')
            .Replace('³', '3')
            .Replace('⁴', '4')
            .Replace('⁵', '5')
            .Replace('⁶', '6')
            .Replace('⁷', '7')
            .Replace('⁸', '8')
            .Replace('⁹', '9');

    private sealed record RoundBlock(
        int RoundNumber,
        string TopLine,
        string OtherLine,
        IReadOnlyCollection<string> ExtraLines,
        IReadOnlyCollection<string> Lines);

    [GeneratedRegex(@"^\s*(?<number>\d+)\s*[\.\-\)]\s*")]
    private static partial Regex ClassicRoundStartRegex();

    [GeneratedRegex(@"^[⁰¹²³⁴⁵⁶⁷⁸⁹]+")]
    private static partial Regex SuperscriptRoundStartRegex();

    [GeneratedRegex(@"(?:\btriple\b|\btriples\b|\bx3\b|\*3)", RegexOptions.IgnoreCase)]
    private static partial Regex TripleRegex();

    [GeneratedRegex(@"(?:\bdoble\b|\bdobles\b|\bx2\b|\*2)", RegexOptions.IgnoreCase)]
    private static partial Regex DoubleRegex();

    [GeneratedRegex(@"\b(?:doble|dobles|triple|triples|normal|x2|x3)\b|\*[23]", RegexOptions.IgnoreCase)]
    private static partial Regex MetaKeywordRegex();
}
