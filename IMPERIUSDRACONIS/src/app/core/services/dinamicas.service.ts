import { HttpClient, HttpParams } from '@angular/common/http';
import { inject, Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { API_BASE_URL } from '../constants/api.constants';
import { PagedResult } from '../models/alumnos.models';
import {
  AgendaCreateBatchRequest,
  AgendaDinamica,
  AgendaResponsable,
  AgendaUpdateRequest,
  AlumnoActivo,
  DinamicaDracoinsDetail,
  DinamicaListItem,
  DinamicaPuntosDetail,
  DinamicasFilters,
  RegistrarDinamicaDracoinsRequest
} from '../models/dinamicas.models';

@Injectable({ providedIn: 'root' })
export class DinamicasService {
  private readonly http = inject(HttpClient);

  getDinamicas(filters: DinamicasFilters): Observable<PagedResult<DinamicaListItem>> {
    let params = new HttpParams()
      .set('pagina', filters.pagina ?? 1)
      .set('registrosPorPagina', filters.registrosPorPagina ?? 10);

    if (filters.nombre?.trim()) {
      params = params.set('nombre', filters.nombre.trim());
    }

    if (filters.tipo?.trim()) {
      params = params.set('tipo', filters.tipo.trim());
    }

    if (filters.subtipo?.trim()) {
      params = params.set('subtipo', filters.subtipo.trim());
    }

    if (filters.responsable?.trim()) {
      params = params.set('responsable', filters.responsable.trim());
    }

    if (filters.desde) {
      params = params.set('desde', filters.desde);
    }

    if (filters.hasta) {
      params = params.set('hasta', filters.hasta);
    }

    return this.http.get<PagedResult<DinamicaListItem>>(`${API_BASE_URL}/dinamicas`, { params });
  }

  getPointsDetail(idDinamica: number): Observable<DinamicaPuntosDetail> {
    return this.http.get<DinamicaPuntosDetail>(`${API_BASE_URL}/dinamicas/${idDinamica}/detalle-puntos`);
  }

  getDracoinsDetail(idDinamica: number): Observable<DinamicaDracoinsDetail> {
    return this.http.get<DinamicaDracoinsDetail>(
      `${API_BASE_URL}/dinamicas/${idDinamica}/detalle-dracoins`
    );
  }

  getActiveStudents(): Observable<AlumnoActivo[]> {
    return this.http.get<AlumnoActivo[]>(`${API_BASE_URL}/dinamicas/alumnos-activos`);
  }

  getAgenda(fecha?: string | null): Observable<AgendaDinamica[]> {
    let params = new HttpParams();
    if (fecha) {
      params = params.set('fecha', fecha);
    }

    return this.http.get<AgendaDinamica[]>(`${API_BASE_URL}/dinamicas/agenda`, { params });
  }

  getAgendaResponsables(): Observable<AgendaResponsable[]> {
    return this.http.get<AgendaResponsable[]>(`${API_BASE_URL}/dinamicas/agenda/responsables`);
  }

  getAgendaItem(idAgenda: number): Observable<AgendaDinamica> {
    return this.http.get<AgendaDinamica>(`${API_BASE_URL}/dinamicas/agenda/${idAgenda}`);
  }

  createAgendaBatch(payload: AgendaCreateBatchRequest): Observable<AgendaDinamica[]> {
    return this.http.post<AgendaDinamica[]>(`${API_BASE_URL}/dinamicas/agenda/lotes`, payload);
  }

  updateAgenda(idAgenda: number, payload: AgendaUpdateRequest): Observable<AgendaDinamica> {
    return this.http.put<AgendaDinamica>(`${API_BASE_URL}/dinamicas/agenda/${idAgenda}`, payload);
  }

  deleteAgenda(idAgenda: number): Observable<void> {
    return this.http.delete<void>(`${API_BASE_URL}/dinamicas/agenda/${idAgenda}`);
  }

  clearAgenda(): Observable<void> {
    return this.http.delete<void>(`${API_BASE_URL}/dinamicas/agenda`);
  }

  createDracoinsDinamica(
    payload: RegistrarDinamicaDracoinsRequest
  ): Observable<DinamicaDracoinsDetail> {
    return this.http.post<DinamicaDracoinsDetail>(`${API_BASE_URL}/dinamicas/dracoins`, payload);
  }

  deleteDinamica(idDinamica: number): Observable<void> {
    return this.http.delete<void>(`${API_BASE_URL}/dinamicas/${idDinamica}`);
  }
}
