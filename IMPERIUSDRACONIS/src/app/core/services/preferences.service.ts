import { HttpClient } from '@angular/common/http';
import { inject, Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { API_BASE_URL } from '../constants/api.constants';
import {
  DashboardQuickLinksPreference,
  DracoinTransferFavoritesPreference,
  ThemePreference,
  UpdateDashboardQuickLinksPreferenceRequest,
  UpdateDracoinTransferFavoritesPreferenceRequest,
  UpdateThemePreferenceRequest
} from '../models/preferences.models';

@Injectable({ providedIn: 'root' })
export class PreferencesService {
  private readonly http = inject(HttpClient);

  getDashboardQuickLinks(): Observable<DashboardQuickLinksPreference> {
    return this.http.get<DashboardQuickLinksPreference>(`${API_BASE_URL}/preferencias/dashboard/accesos-rapidos`);
  }

  saveDashboardQuickLinks(payload: UpdateDashboardQuickLinksPreferenceRequest): Observable<void> {
    return this.http.put<void>(`${API_BASE_URL}/preferencias/dashboard/accesos-rapidos`, payload);
  }

  getDracoinTransferFavorites(): Observable<DracoinTransferFavoritesPreference> {
    return this.http.get<DracoinTransferFavoritesPreference>(
      `${API_BASE_URL}/preferencias/dracoins/favoritos-transferencia`
    );
  }

  saveDracoinTransferFavorites(
    payload: UpdateDracoinTransferFavoritesPreferenceRequest
  ): Observable<DracoinTransferFavoritesPreference> {
    return this.http.put<DracoinTransferFavoritesPreference>(
      `${API_BASE_URL}/preferencias/dracoins/favoritos-transferencia`,
      payload
    );
  }

  getTheme(): Observable<ThemePreference> {
    return this.http.get<ThemePreference>(`${API_BASE_URL}/preferencias/apariencia/tema`);
  }

  saveTheme(payload: UpdateThemePreferenceRequest): Observable<ThemePreference> {
    return this.http.put<ThemePreference>(`${API_BASE_URL}/preferencias/apariencia/tema`, payload);
  }
}
