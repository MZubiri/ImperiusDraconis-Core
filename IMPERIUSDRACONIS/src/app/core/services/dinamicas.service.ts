import { HttpClient, HttpParams } from '@angular/common/http';
import { inject, Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { RuntimeConfigService } from './runtime-config.service';
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
  private readonly runtimeConfig = inject(RuntimeConfigService);

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

    return this.http.get<PagedResult<DinamicaListItem>>(`${this.runtimeConfig.apiUrl}/dinamicas`, { params });
  }

  getPointsDetail(idDinamica: number): Observable<DinamicaPuntosDetail> {
    return this.http.get<DinamicaPuntosDetail>(`${this.runtimeConfig.apiUrl}/dinamicas/${idDinamica}/detalle-puntos`);
  }

  getDracoinsDetail(idDinamica: number): Observable<DinamicaDracoinsDetail> {
    return this.http.get<DinamicaDracoinsDetail>(
      `${this.runtimeConfig.apiUrl}/dinamicas/${idDinamica}/detalle-dracoins`
    );
  }

  getActiveStudents(): Observable<AlumnoActivo[]> {
    return this.http.get<AlumnoActivo[]>(`${this.runtimeConfig.apiUrl}/dinamicas/alumnos-activos`);
  }

  getAgenda(fecha?: string | null): Observable<AgendaDinamica[]> {
    let params = new HttpParams();
    if (fecha) {
      params = params.set('fecha', fecha);
    }

    return this.http.get<AgendaDinamica[]>(`${this.runtimeConfig.apiUrl}/dinamicas/agenda`, { params });
  }

  getAgendaResponsables(): Observable<AgendaResponsable[]> {
    return this.http.get<AgendaResponsable[]>(`${this.runtimeConfig.apiUrl}/dinamicas/agenda/responsables`);
  }

  getAgendaItem(idAgenda: number): Observable<AgendaDinamica> {
    return this.http.get<AgendaDinamica>(`${this.runtimeConfig.apiUrl}/dinamicas/agenda/${idAgenda}`);
  }

  createAgendaBatch(payload: AgendaCreateBatchRequest): Observable<AgendaDinamica[]> {
    return this.http.post<AgendaDinamica[]>(`${this.runtimeConfig.apiUrl}/dinamicas/agenda/lotes`, payload);
  }

  updateAgenda(idAgenda: number, payload: AgendaUpdateRequest): Observable<AgendaDinamica> {
    return this.http.put<AgendaDinamica>(`${this.runtimeConfig.apiUrl}/dinamicas/agenda/${idAgenda}`, payload);
  }

  deleteAgenda(idAgenda: number): Observable<void> {
    return this.http.delete<void>(`${this.runtimeConfig.apiUrl}/dinamicas/agenda/${idAgenda}`);
  }

  clearAgenda(): Observable<void> {
    return this.http.delete<void>(`${this.runtimeConfig.apiUrl}/dinamicas/agenda`);
  }

  createDracoinsDinamica(
    payload: RegistrarDinamicaDracoinsRequest
  ): Observable<DinamicaDracoinsDetail> {
    return this.http.post<DinamicaDracoinsDetail>(`${this.runtimeConfig.apiUrl}/dinamicas/dracoins`, payload);
  }

  deleteDinamica(idDinamica: number): Observable<void> {
    return this.http.delete<void>(`${this.runtimeConfig.apiUrl}/dinamicas/${idDinamica}`);
  }
}
