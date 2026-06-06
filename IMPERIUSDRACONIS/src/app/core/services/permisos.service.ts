import { HttpClient } from '@angular/common/http';
import { inject, Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { RuntimeConfigService } from './runtime-config.service';
import { CargoOption, CreatePermisoRequest, PermisoCargo, UpdatePermisoCargoRequest } from '../models/permisos.models';

@Injectable({ providedIn: 'root' })
export class PermisosService {
  private readonly http = inject(HttpClient);
  private readonly runtimeConfig = inject(RuntimeConfigService);

  getCargos(): Observable<CargoOption[]> {
    return this.http.get<CargoOption[]>(`${this.runtimeConfig.apiUrl}/permisos/cargos`);
  }

  getByCargo(idCargo: number): Observable<PermisoCargo> {
    return this.http.get<PermisoCargo>(`${this.runtimeConfig.apiUrl}/permisos/${idCargo}`);
  }

  update(idCargo: number, payload: UpdatePermisoCargoRequest): Observable<PermisoCargo> {
    return this.http.put<PermisoCargo>(`${this.runtimeConfig.apiUrl}/permisos/${idCargo}`, payload);
  }

  create(payload: CreatePermisoRequest): Observable<void> {
    return this.http.post<void>(`${this.runtimeConfig.apiUrl}/permisos`, payload);
  }
}
