import { HttpClient } from '@angular/common/http';
import { inject, Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { RuntimeConfigService } from './runtime-config.service';
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
  private readonly runtimeConfig = inject(RuntimeConfigService);

  getCatalogs(): Observable<TrabajoCatalogs> {
    return this.http.get<TrabajoCatalogs>(`${this.runtimeConfig.apiUrl}/trabajos/catalogos`);
  }

  getAll(): Observable<TrabajoOption[]> {
    return this.http.get<TrabajoOption[]>(`${this.runtimeConfig.apiUrl}/trabajos`);
  }

  create(payload: SaveTrabajoRequest): Observable<TrabajoOption> {
    return this.http.post<TrabajoOption>(`${this.runtimeConfig.apiUrl}/trabajos`, payload);
  }

  update(idTrabajo: number, payload: SaveTrabajoRequest): Observable<TrabajoOption> {
    return this.http.put<TrabajoOption>(`${this.runtimeConfig.apiUrl}/trabajos/${idTrabajo}`, payload);
  }

  delete(idTrabajo: number): Observable<void> {
    return this.http.delete<void>(`${this.runtimeConfig.apiUrl}/trabajos/${idTrabajo}`);
  }

  getAssignments(idAlumno: number): Observable<TrabajoAlumnoAssignments> {
    return this.http.get<TrabajoAlumnoAssignments>(`${this.runtimeConfig.apiUrl}/trabajos/asignaciones/${idAlumno}`);
  }

  updateAssignments(
    idAlumno: number,
    payload: SaveTrabajoAssignmentsRequest
  ): Observable<TrabajoAlumnoAssignments> {
    return this.http.put<TrabajoAlumnoAssignments>(
      `${this.runtimeConfig.apiUrl}/trabajos/asignaciones/${idAlumno}`,
      payload
    );
  }

  getPermissions(idTrabajo: number): Observable<TrabajoPermisos> {
    return this.http.get<TrabajoPermisos>(`${this.runtimeConfig.apiUrl}/trabajos/${idTrabajo}/permisos`);
  }

  updatePermissions(idTrabajo: number, payload: UpdateTrabajoPermisosRequest): Observable<TrabajoPermisos> {
    return this.http.put<TrabajoPermisos>(`${this.runtimeConfig.apiUrl}/trabajos/${idTrabajo}/permisos`, payload);
  }
}
