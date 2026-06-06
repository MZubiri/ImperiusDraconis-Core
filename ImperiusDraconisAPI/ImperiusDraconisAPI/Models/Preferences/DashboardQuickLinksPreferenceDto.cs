namespace ImperiusDraconisAPI.Models.Preferences;

public sealed class DashboardQuickLinksPreferenceDto
{
    public bool HasPreference { get; init; }

    public IReadOnlyList<string> Routes { get; init; } = [];
}
