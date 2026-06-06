import { HttpClient } from '@angular/common/http';
import { inject, Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { API_BASE_URL } from '../constants/api.constants';
import {
  SaveTrabajoAssignmentsRequest,
  SaveTrabajoRequest,
  TrabajoAlumnoAssignments,
  TrabajoCatalogs,
  TrabajoOption,
  TrabajoPermisos,
  UpdateTrabajoPermisosRequest
} from '../models/trabajos.models';

@Injectable({ providedIn: 'root' })
export class TrabajosService {
  private readonly http = inject(HttpClient);

  getCatalogs(): Observable<TrabajoCatalogs> {
    return this.http.get<TrabajoCatalogs>(`${API_BASE_URL}/trabajos/catalogos`);
  }

  getAll(): Observable<TrabajoOption[]> {
    return this.http.get<TrabajoOption[]>(`${API_BASE_URL}/trabajos`);
  }

  create(payload: SaveTrabajoRequest): Observable<TrabajoOption> {
    return this.http.post<TrabajoOption>(`${API_BASE_URL}/trabajos`, payload);
  }

  update(idTrabajo: number, payload: SaveTrabajoRequest): Observable<TrabajoOption> {
    return this.http.put<TrabajoOption>(`${API_BASE_URL}/trabajos/${idTrabajo}`, payload);
  }

  delete(idTrabajo: number): Observable<void> {
    return this.http.delete<void>(`${API_BASE_URL}/trabajos/${idTrabajo}`);
  }

  getAssignments(idAlumno: number): Observable<TrabajoAlumnoAssignments> {
    return this.http.get<TrabajoAlumnoAssignments>(`${API_BASE_URL}/trabajos/asignaciones/${idAlumno}`);
  }

  updateAssignments(
    idAlumno: number,
    payload: SaveTrabajoAssignmentsRequest
  ): Observable<TrabajoAlumnoAssignments> {
    return this.http.put<TrabajoAlumnoAssignments>(
      `${API_BASE_URL}/trabajos/asignaciones/${idAlumno}`,
      payload
    );
  }

  getPermissions(idTrabajo: number): Observable<TrabajoPermisos> {
    return this.http.get<TrabajoPermisos>(`${API_BASE_URL}/trabajos/${idTrabajo}/permisos`);
  }

  updatePermissions(idTrabajo: number, payload: UpdateTrabajoPermisosRequest): Observable<TrabajoPermisos> {
    return this.http.put<TrabajoPermisos>(`${API_BASE_URL}/trabajos/${idTrabajo}/permisos`, payload);
  }
}
