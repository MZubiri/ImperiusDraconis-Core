import { HttpClient } from '@angular/common/http';
import { inject, Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { RuntimeConfigService } from './runtime-config.service';
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
  private readonly runtimeConfig = inject(RuntimeConfigService);

  getDashboardQuickLinks(): Observable<DashboardQuickLinksPreference> {
    return this.http.get<DashboardQuickLinksPreference>(`${this.runtimeConfig.apiUrl}/preferencias/dashboard/accesos-rapidos`);
  }

  saveDashboardQuickLinks(payload: UpdateDashboardQuickLinksPreferenceRequest): Observable<void> {
    return this.http.put<void>(`${this.runtimeConfig.apiUrl}/preferencias/dashboard/accesos-rapidos`, payload);
  }

  getDracoinTransferFavorites(): Observable<DracoinTransferFavoritesPreference> {
    return this.http.get<DracoinTransferFavoritesPreference>(
      `${this.runtimeConfig.apiUrl}/preferencias/dracoins/favoritos-transferencia`
    );
  }

  saveDracoinTransferFavorites(
    payload: UpdateDracoinTransferFavoritesPreferenceRequest
  ): Observable<DracoinTransferFavoritesPreference> {
    return this.http.put<DracoinTransferFavoritesPreference>(
      `${this.runtimeConfig.apiUrl}/preferencias/dracoins/favoritos-transferencia`,
      payload
    );
  }

  getTheme(): Observable<ThemePreference> {
    return this.http.get<ThemePreference>(`${this.runtimeConfig.apiUrl}/preferencias/apariencia/tema`);
  }

  saveTheme(payload: UpdateThemePreferenceRequest): Observable<ThemePreference> {
    return this.http.put<ThemePreference>(`${this.runtimeConfig.apiUrl}/preferencias/apariencia/tema`, payload);
  }
}
