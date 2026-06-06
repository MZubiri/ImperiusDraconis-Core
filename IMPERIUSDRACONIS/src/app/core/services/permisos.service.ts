import { HttpClient } from '@angular/common/http';
import { inject, Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { API_BASE_URL } from '../constants/api.constants';
import { CargoOption, CreatePermisoRequest, PermisoCargo, UpdatePermisoCargoRequest } from '../models/permisos.models';

@Injectable({ providedIn: 'root' })
export class PermisosService {
  private readonly http = inject(HttpClient);

  getCargos(): Observable<CargoOption[]> {
    return this.http.get<CargoOption[]>(`${API_BASE_URL}/permisos/cargos`);
  }

  getByCargo(idCargo: number): Observable<PermisoCargo> {
    return this.http.get<PermisoCargo>(`${API_BASE_URL}/permisos/${idCargo}`);
  }

  update(idCargo: number, payload: UpdatePermisoCargoRequest): Observable<PermisoCargo> {
    return this.http.put<PermisoCargo>(`${API_BASE_URL}/permisos/${idCargo}`, payload);
  }

  create(payload: CreatePermisoRequest): Observable<void> {
    return this.http.post<void>(`${API_BASE_URL}/permisos`, payload);
  }
}
