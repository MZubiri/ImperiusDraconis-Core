import { HttpClient, HttpParams } from '@angular/common/http';
import { inject, Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { RuntimeConfigService } from './runtime-config.service';
import {
  AlumnoDetail,
  AlumnoFilters,
  AlumnoListItem,
  AlumnoNote,
  CatalogItem,
  CreateAlumnoNoteRequest,
  CumpleanosItem,
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
  private readonly runtimeConfig = inject(RuntimeConfigService);

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

    return this.http.get<PagedResult<AlumnoListItem>>(`${this.runtimeConfig.apiUrl}/alumnos`, { params });
  }

  getAlumno(idAlumno: number): Observable<AlumnoDetail> {
    return this.http.get<AlumnoDetail>(`${this.runtimeConfig.apiUrl}/alumnos/${idAlumno}`);
  }

  createAlumno(payload: SaveAlumnoRequest): Observable<AlumnoDetail> {
    return this.http.post<AlumnoDetail>(`${this.runtimeConfig.apiUrl}/alumnos`, payload);
  }

  updateAlumno(idAlumno: number, payload: SaveAlumnoRequest): Observable<void> {
    return this.http.put<void>(`${this.runtimeConfig.apiUrl}/alumnos/${idAlumno}`, payload);
  }

  changeEstado(idAlumno: number, activo: boolean): Observable<void> {
    return this.http.patch<void>(`${this.runtimeConfig.apiUrl}/alumnos/${idAlumno}/estado`, { activo });
  }

  deleteAlumno(idAlumno: number): Observable<void> {
    return this.http.delete<void>(`${this.runtimeConfig.apiUrl}/alumnos/${idAlumno}`);
  }

  getCasas(): Observable<CatalogItem[]> {
    return this.http.get<CatalogItem[]>(`${this.runtimeConfig.apiUrl}/alumnos/casas`);
  }

  getCargos(): Observable<CatalogItem[]> {
    return this.http.get<CatalogItem[]>(`${this.runtimeConfig.apiUrl}/alumnos/cargos`);
  }

  getNextCodigo(idCasa: number): Observable<NextCodeResponse> {
    return this.http.get<NextCodeResponse>(`${this.runtimeConfig.apiUrl}/alumnos/siguiente-codigo/${idCasa}`);
  }

  getNotas(idAlumno: number): Observable<AlumnoNote[]> {
    return this.http.get<AlumnoNote[]>(`${this.runtimeConfig.apiUrl}/alumnos/${idAlumno}/notas`);
  }

  createNota(idAlumno: number, payload: CreateAlumnoNoteRequest): Observable<AlumnoNote> {
    return this.http.post<AlumnoNote>(`${this.runtimeConfig.apiUrl}/alumnos/${idAlumno}/notas`, payload);
  }

  resetPassword(idAlumno: number, payload: ResetAlumnoPasswordRequest): Observable<void> {
    return this.http.put<void>(`${this.runtimeConfig.apiUrl}/alumnos/${idAlumno}/contrasena`, payload);
  }

  getCumpleanos(mes?: number): Observable<CumpleanosItem[]> {
    let params = new HttpParams();
    if (mes !== undefined && mes !== null) {
      params = params.set('mes', mes);
    }
    return this.http.get<CumpleanosItem[]>(`${this.runtimeConfig.apiUrl}/alumnos/cumpleanos`, { params });
  }
}
