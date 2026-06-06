import { HttpClient, HttpParams } from '@angular/common/http';
import { inject, Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { RuntimeConfigService } from './runtime-config.service';
import { PagedResult } from '../models/alumnos.models';
import {
  HistorialMarcador,
  MarcadorAdjustmentResult,
  MarcadorCasa,
  MarcadorCloseResult,
  MarcadorUpdateResult,
  SaveMarcadorAdjustmentRequest,
  SaveMarcadorUpdateRequest
} from '../models/marcadores.models';

@Injectable({ providedIn: 'root' })
export class MarcadoresService {
  private readonly http = inject(HttpClient);
  private readonly runtimeConfig = inject(RuntimeConfigService);

  getCurrent(): Observable<MarcadorCasa[]> {
    return this.http.get<MarcadorCasa[]>(`${this.runtimeConfig.apiUrl}/marcadores/actual`);
  }

  getHouses(): Observable<MarcadorCasa[]> {
    return this.http.get<MarcadorCasa[]>(`${this.runtimeConfig.apiUrl}/marcadores/casas`);
  }

  getHistory(page = 1, pageSize = 12): Observable<PagedResult<HistorialMarcador>> {
    const params = new HttpParams().set('pagina', page).set('registrosPorPagina', pageSize);
    return this.http.get<PagedResult<HistorialMarcador>>(`${this.runtimeConfig.apiUrl}/marcadores/historial`, {
      params
    });
  }

  createUpdate(payload: SaveMarcadorUpdateRequest): Observable<MarcadorUpdateResult> {
    return this.http.post<MarcadorUpdateResult>(`${this.runtimeConfig.apiUrl}/marcadores/actualizaciones`, payload);
  }

  createAdjustment(payload: SaveMarcadorAdjustmentRequest): Observable<MarcadorAdjustmentResult> {
    return this.http.post<MarcadorAdjustmentResult>(`${this.runtimeConfig.apiUrl}/marcadores/ajustes-puntos`, payload);
  }

  closeScoreboard(): Observable<MarcadorCloseResult> {
    return this.http.post<MarcadorCloseResult>(`${this.runtimeConfig.apiUrl}/marcadores/cierres`, {});
  }
}
