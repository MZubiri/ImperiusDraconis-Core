using ImperiusDraconisAPI.Common;

namespace ImperiusDraconisAPI.Services.Game;

internal static class GameEggRules
{
    private const int MaxDefinitionCodeLength = 50;

    private static readonly HashSet<string> Rarities =
    [
        "COMMON",
        "RARE",
        "EPIC",
        "LEGENDARY",
        "MYTHIC"
    ];

    private static readonly HashSet<string> Statuses =
    [
        "OWNED",
        "INCUBATING",
        "READY_TO_HATCH",
        "HATCHED"
    ];

    public static string NormalizeRarity(string rarity)
    {
        if (string.IsNullOrWhiteSpace(rarity))
        {
            throw Invalid("La rareza del huevo no es valida.");
        }

        var normalized = rarity.Trim().ToUpperInvariant();
        if (!Rarities.Contains(normalized))
        {
            throw Invalid("La rareza del huevo no es valida.");
        }

        return normalized;
    }

    public static string NormalizeDefinitionCode(string definitionCode)
    {
        if (string.IsNullOrWhiteSpace(definitionCode))
        {
            throw Invalid("El codigo de definicion del huevo es obligatorio.");
        }

        var normalized = definitionCode.Trim().ToUpperInvariant();
        if (normalized.Length > MaxDefinitionCodeLength
            || normalized.Any(character => character != '_' && !char.IsAsciiLetterOrDigit(character)))
        {
            throw Invalid("El codigo de definicion del huevo no es valido.");
        }

        return normalized;
    }

    public static string NormalizeStatus(string status)
    {
        if (string.IsNullOrWhiteSpace(status))
        {
            throw Invalid("El estado del huevo no es valido.");
        }

        var normalized = status.Trim().ToUpperInvariant();
        if (!Statuses.Contains(normalized))
        {
            throw Invalid("El estado del huevo no es valido.");
        }

        return normalized;
    }

    public static void ValidateState(
        string status,
        DateTime acquiredAt,
        DateTime? incubationStartedAt,
        DateTime? incubationEndsAt)
    {
        var hasStartedAt = incubationStartedAt.HasValue;
        var hasEndsAt = incubationEndsAt.HasValue;

        if (hasStartedAt != hasEndsAt)
        {
            throw Invalid("Las fechas de incubacion deben informarse juntas.");
        }

        if (status == "OWNED" && hasStartedAt)
        {
            throw Invalid("Un huevo OWNED no puede tener fechas de incubacion.");
        }

        if (status != "OWNED" && !hasStartedAt)
        {
            throw Invalid("El estado del huevo requiere fechas de incubacion.");
        }

        if (hasStartedAt
            && (incubationStartedAt!.Value < acquiredAt
                || incubationEndsAt!.Value <= incubationStartedAt.Value))
        {
            throw Invalid("Las fechas de incubacion no son validas.");
        }
    }

    public static string GetEffectiveStatus(string persistedStatus, DateTime? incubationEndsAt, DateTime utcNow)
    {
        return persistedStatus == "INCUBATING" && incubationEndsAt <= utcNow
            ? "READY_TO_HATCH"
            : persistedStatus;
    }

    public static void ValidateTransition(
        string currentStatus,
        string targetStatus,
        DateTime? incubationEndsAt,
        DateTime utcNow)
    {
        var allowed = currentStatus switch
        {
            "OWNED" => targetStatus is "OWNED" or "INCUBATING",
            "INCUBATING" => targetStatus is "INCUBATING" or "READY_TO_HATCH",
            "READY_TO_HATCH" => targetStatus == "READY_TO_HATCH",
            _ => false
        };

        if (!allowed)
        {
            throw Invalid($"No se permite cambiar un huevo de {currentStatus} a {targetStatus}.");
        }

        if (targetStatus == "READY_TO_HATCH" && incubationEndsAt > utcNow)
        {
            throw Invalid("El huevo aun no esta listo para eclosionar.");
        }
    }

    private static GameBusinessRuleException Invalid(string message)
    {
        return new GameBusinessRuleException(
            "INVALID_EGG_STATE",
            message,
            StatusCodes.Status400BadRequest);
    }
}
