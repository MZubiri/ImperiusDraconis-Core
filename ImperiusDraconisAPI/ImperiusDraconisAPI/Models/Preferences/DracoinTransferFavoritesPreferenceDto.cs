namespace ImperiusDraconisAPI.Models.Preferences;

public sealed class DracoinTransferFavoritesPreferenceDto
{
    public IReadOnlyList<DracoinTransferFavoriteDto> Favoritos { get; init; } = [];
}
