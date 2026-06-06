export interface DashboardQuickLinksPreference {
  hasPreference: boolean;
  routes: string[];
}

export interface UpdateDashboardQuickLinksPreferenceRequest {
  routes: string[];
}

export interface DracoinTransferFavorite {
  codigo: string;
  nombre: string;
}

export interface DracoinTransferFavoritesPreference {
  favoritos: DracoinTransferFavorite[];
}

export interface UpdateDracoinTransferFavoritesPreferenceRequest {
  favoritos: DracoinTransferFavorite[];
}

export interface ThemePreference {
  tema: string;
}

export interface UpdateThemePreferenceRequest {
  tema: string;
}
