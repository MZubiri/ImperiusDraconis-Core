import { HttpClient, HttpParams } from '@angular/common/http';
import { inject, Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { RuntimeConfigService } from './runtime-config.service';
import {
  ChangeMascotaStateRequest,
  MascotaAssignment,
  MascotaAssignmentFilters,
  MascotaCatalogItem,
  MascotaFormCatalogs,
  MascotaMatrixRow,
  MascotaSummary,
  MascotaWeeklyChargeCandidate,
  MascotaWeeklyChargeResult,
  ProcessMascotaWeeklyChargeRequest,
  SaveMascotaAssignmentRequest
} from '../models/mascotas.models';

@Injectable({ providedIn: 'root' })
export class MascotasService {
  private readonly http = inject(HttpClient);
  private readonly runtimeConfig = inject(RuntimeConfigService);

  getSummary(): Observable<MascotaSummary> {
    return this.http.get<MascotaSummary>(`${this.runtimeConfig.apiUrl}/mascotas/resumen`);
  }

  getCatalog(activo?: boolean | null): Observable<MascotaCatalogItem[]> {
    let params = new HttpParams();

    if (activo !== null && activo !== undefined) {
      params = params.set('activo', activo);
    }

    return this.http.get<MascotaCatalogItem[]>(`${this.runtimeConfig.apiUrl}/mascotas/catalogo`, { params });
  }

  getFormCatalogs(): Observable<MascotaFormCatalogs> {
    return this.http.get<MascotaFormCatalogs>(`${this.runtimeConfig.apiUrl}/mascotas/catalogos-formulario`);
  }

  getAssignments(filters: MascotaAssignmentFilters = {}): Observable<MascotaAssignment[]> {
    let params = new HttpParams();

    if (filters.filtroEstado) {
      params = params.set('filtroEstado', filters.filtroEstado);
    }

    if (filters.busqueda?.trim()) {
      params = params.set('busqueda', filters.busqueda.trim());
    }

    if (filters.soloPendientesCobro !== null && filters.soloPendientesCobro !== undefined) {
      params = params.set('soloPendientesCobro', filters.soloPendientesCobro);
    }

    return this.http.get<MascotaAssignment[]>(`${this.runtimeConfig.apiUrl}/mascotas/asignaciones`, { params });
  }

  getAssignmentById(idMascotaAlumno: number): Observable<MascotaAssignment> {
    return this.http.get<MascotaAssignment>(`${this.runtimeConfig.apiUrl}/mascotas/asignaciones/${idMascotaAlumno}`);
  }

  createAssignment(payload: SaveMascotaAssignmentRequest): Observable<MascotaAssignment> {
    return this.http.post<MascotaAssignment>(`${this.runtimeConfig.apiUrl}/mascotas/asignaciones`, payload);
  }

  updateAssignment(
    idMascotaAlumno: number,
    payload: SaveMascotaAssignmentRequest
  ): Observable<void> {
    return this.http.put<void>(`${this.runtimeConfig.apiUrl}/mascotas/asignaciones/${idMascotaAlumno}`, payload);
  }

  changeState(
    idMascotaAlumno: number,
    payload: ChangeMascotaStateRequest
  ): Observable<MascotaAssignment> {
    return this.http.patch<MascotaAssignment>(
      `${this.runtimeConfig.apiUrl}/mascotas/asignaciones/${idMascotaAlumno}/estado`,
      payload
    );
  }

  deleteAssignment(idMascotaAlumno: number): Observable<void> {
    return this.http.delete<void>(`${this.runtimeConfig.apiUrl}/mascotas/asignaciones/${idMascotaAlumno}`);
  }

  getWeeklyChargeCandidates(): Observable<MascotaWeeklyChargeCandidate[]> {
    return this.http.get<MascotaWeeklyChargeCandidate[]>(`${this.runtimeConfig.apiUrl}/mascotas/cobro-semanal`);
  }

  processWeeklyCharges(
    payload: ProcessMascotaWeeklyChargeRequest
  ): Observable<MascotaWeeklyChargeResult> {
    return this.http.post<MascotaWeeklyChargeResult>(`${this.runtimeConfig.apiUrl}/mascotas/cobro-semanal`, payload);
  }

  getMatrix(): Observable<MascotaMatrixRow[]> {
    return this.http.get<MascotaMatrixRow[]>(`${this.runtimeConfig.apiUrl}/mascotas/matriz`);
  }
}
