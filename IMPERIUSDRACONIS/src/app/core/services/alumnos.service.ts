import { HttpClient, HttpParams } from '@angular/common/http';
import { inject, Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { API_BASE_URL } from '../constants/api.constants';
import {
  AlumnoDetail,
  AlumnoFilters,
  AlumnoListItem,
  AlumnoNote,
  CatalogItem,
  CreateAlumnoNoteRequest,
  PagedResult,
  ResetAlumnoPasswordRequest,
  SaveAlumnoRequest
} from '../models/alumnos.models';

interface NextCodeResponse {
  codigo: string;
}

@Injectable({ providedIn: 'root' })
export class AlumnosService {
  private readonly http = inject(HttpClient);

  getAlumnos(filters: AlumnoFilters): Observable<PagedResult<AlumnoListItem>> {
    let params = new HttpParams()
      .set('pagina', filters.pagina ?? 1)
      .set('registrosPorPagina', filters.registrosPorPagina ?? 18)
      .set('ordenarPor', filters.ordenarPor ?? 'nombre')
      .set('orden', filters.orden ?? 'asc');

    if (filters.codigo?.trim()) {
      params = params.set('codigo', filters.codigo.trim());
    }

    if (filters.nombre?.trim()) {
      params = params.set('nombre', filters.nombre.trim());
    }

    if (filters.idCasa) {
      params = params.set('idCasa', filters.idCasa);
    }

    if (filters.activo !== null && filters.activo !== undefined) {
      params = params.set('activo', filters.activo);
    }

    return this.http.get<PagedResult<AlumnoListItem>>(`${API_BASE_URL}/alumnos`, { params });
  }

  getAlumno(idAlumno: number): Observable<AlumnoDetail> {
    return this.http.get<AlumnoDetail>(`${API_BASE_URL}/alumnos/${idAlumno}`);
  }

  createAlumno(payload: SaveAlumnoRequest): Observable<AlumnoDetail> {
    return this.http.post<AlumnoDetail>(`${API_BASE_URL}/alumnos`, payload);
  }

  updateAlumno(idAlumno: number, payload: SaveAlumnoRequest): Observable<void> {
    return this.http.put<void>(`${API_BASE_URL}/alumnos/${idAlumno}`, payload);
  }

  changeEstado(idAlumno: number, activo: boolean): Observable<void> {
    return this.http.patch<void>(`${API_BASE_URL}/alumnos/${idAlumno}/estado`, { activo });
  }

  deleteAlumno(idAlumno: number): Observable<void> {
    return this.http.delete<void>(`${API_BASE_URL}/alumnos/${idAlumno}`);
  }

  getCasas(): Observable<CatalogItem[]> {
    return this.http.get<CatalogItem[]>(`${API_BASE_URL}/alumnos/casas`);
  }

  getCargos(): Observable<CatalogItem[]> {
    return this.http.get<CatalogItem[]>(`${API_BASE_URL}/alumnos/cargos`);
  }

  getNextCodigo(idCasa: number): Observable<NextCodeResponse> {
    return this.http.get<NextCodeResponse>(`${API_BASE_URL}/alumnos/siguiente-codigo/${idCasa}`);
  }

  getNotas(idAlumno: number): Observable<AlumnoNote[]> {
    return this.http.get<AlumnoNote[]>(`${API_BASE_URL}/alumnos/${idAlumno}/notas`);
  }

  createNota(idAlumno: number, payload: CreateAlumnoNoteRequest): Observable<AlumnoNote> {
    return this.http.post<AlumnoNote>(`${API_BASE_URL}/alumnos/${idAlumno}/notas`, payload);
  }

  resetPassword(idAlumno: number, payload: ResetAlumnoPasswordRequest): Observable<void> {
    return this.http.put<void>(`${API_BASE_URL}/alumnos/${idAlumno}/contrasena`, payload);
  }
}
