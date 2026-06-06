import { HttpClient, HttpParams } from '@angular/common/http';
import { inject, Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { API_BASE_URL } from '../constants/api.constants';
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

  getSummary(): Observable<MascotaSummary> {
    return this.http.get<MascotaSummary>(`${API_BASE_URL}/mascotas/resumen`);
  }

  getCatalog(activo?: boolean | null): Observable<MascotaCatalogItem[]> {
    let params = new HttpParams();

    if (activo !== null && activo !== undefined) {
      params = params.set('activo', activo);
    }

    return this.http.get<MascotaCatalogItem[]>(`${API_BASE_URL}/mascotas/catalogo`, { params });
  }

  getFormCatalogs(): Observable<MascotaFormCatalogs> {
    return this.http.get<MascotaFormCatalogs>(`${API_BASE_URL}/mascotas/catalogos-formulario`);
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

    return this.http.get<MascotaAssignment[]>(`${API_BASE_URL}/mascotas/asignaciones`, { params });
  }

  getAssignmentById(idMascotaAlumno: number): Observable<MascotaAssignment> {
    return this.http.get<MascotaAssignment>(`${API_BASE_URL}/mascotas/asignaciones/${idMascotaAlumno}`);
  }

  createAssignment(payload: SaveMascotaAssignmentRequest): Observable<MascotaAssignment> {
    return this.http.post<MascotaAssignment>(`${API_BASE_URL}/mascotas/asignaciones`, payload);
  }

  updateAssignment(
    idMascotaAlumno: number,
    payload: SaveMascotaAssignmentRequest
  ): Observable<void> {
    return this.http.put<void>(`${API_BASE_URL}/mascotas/asignaciones/${idMascotaAlumno}`, payload);
  }

  changeState(
    idMascotaAlumno: number,
    payload: ChangeMascotaStateRequest
  ): Observable<MascotaAssignment> {
    return this.http.patch<MascotaAssignment>(
      `${API_BASE_URL}/mascotas/asignaciones/${idMascotaAlumno}/estado`,
      payload
    );
  }

  deleteAssignment(idMascotaAlumno: number): Observable<void> {
    return this.http.delete<void>(`${API_BASE_URL}/mascotas/asignaciones/${idMascotaAlumno}`);
  }

  getWeeklyChargeCandidates(): Observable<MascotaWeeklyChargeCandidate[]> {
    return this.http.get<MascotaWeeklyChargeCandidate[]>(`${API_BASE_URL}/mascotas/cobro-semanal`);
  }

  processWeeklyCharges(
    payload: ProcessMascotaWeeklyChargeRequest
  ): Observable<MascotaWeeklyChargeResult> {
    return this.http.post<MascotaWeeklyChargeResult>(`${API_BASE_URL}/mascotas/cobro-semanal`, payload);
  }

  getMatrix(): Observable<MascotaMatrixRow[]> {
    return this.http.get<MascotaMatrixRow[]>(`${API_BASE_URL}/mascotas/matriz`);
  }
}
