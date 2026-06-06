namespace ImperiusDraconisAPI.Models.Preferences;

public sealed class UpdateDracoinTransferFavoritesPreferenceRequest
{
    public IReadOnlyList<DracoinTransferFavoriteDto> Favoritos { get; init; } = [];
}
