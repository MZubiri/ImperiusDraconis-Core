import { HttpClient, HttpParams } from '@angular/common/http';
import { inject, Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { API_BASE_URL } from '../constants/api.constants';
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

  getCurrent(): Observable<MarcadorCasa[]> {
    return this.http.get<MarcadorCasa[]>(`${API_BASE_URL}/marcadores/actual`);
  }

  getHouses(): Observable<MarcadorCasa[]> {
    return this.http.get<MarcadorCasa[]>(`${API_BASE_URL}/marcadores/casas`);
  }

  getHistory(page = 1, pageSize = 12): Observable<PagedResult<HistorialMarcador>> {
    const params = new HttpParams().set('pagina', page).set('registrosPorPagina', pageSize);
    return this.http.get<PagedResult<HistorialMarcador>>(`${API_BASE_URL}/marcadores/historial`, {
      params
    });
  }

  createUpdate(payload: SaveMarcadorUpdateRequest): Observable<MarcadorUpdateResult> {
    return this.http.post<MarcadorUpdateResult>(`${API_BASE_URL}/marcadores/actualizaciones`, payload);
  }

  createAdjustment(payload: SaveMarcadorAdjustmentRequest): Observable<MarcadorAdjustmentResult> {
    return this.http.post<MarcadorAdjustmentResult>(`${API_BASE_URL}/marcadores/ajustes-puntos`, payload);
  }

  closeScoreboard(): Observable<MarcadorCloseResult> {
    return this.http.post<MarcadorCloseResult>(`${API_BASE_URL}/marcadores/cierres`, {});
  }
}
