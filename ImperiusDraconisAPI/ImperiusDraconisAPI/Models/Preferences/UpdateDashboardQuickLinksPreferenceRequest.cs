namespace ImperiusDraconisAPI.Models.Preferences;

public sealed class UpdateDashboardQuickLinksPreferenceRequest
{
    public IReadOnlyList<string> Routes { get; init; } = [];
}
