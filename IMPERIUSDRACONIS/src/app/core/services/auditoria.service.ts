import { HttpClient } from '@angular/common/http';
import { inject, Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { RuntimeConfigService } from './runtime-config.service';
import {
  ResumenAuditoriaListado,
  ResumenAuditoriaAcceso,
  RelacionAccesoNodo,
  DecisionAdministrativa,
  ExcepcionAuditoria,
  CuentaEspecial
} from '../models/auditoria.models';

@Injectable({ providedIn: 'root' })
export class AuditoriaService {
  private readonly http = inject(HttpClient);
  private readonly runtimeConfig = inject(RuntimeConfigService);

  private get baseUrl(): string {
    return `${this.runtimeConfig.apiUrl}/admin/auditoria`;
  }

  getResumenes(): Observable<ResumenAuditoriaListado[]> {
    return this.http.get<ResumenAuditoriaListado[]>(`${this.baseUrl}/resumenes`);
  }

  getResumen(idAlumno: number): Observable<ResumenAuditoriaAcceso> {
    return this.http.get<ResumenAuditoriaAcceso>(`${this.baseUrl}/alumno/${idAlumno}/resumen`);
  }

  recalcular(idAlumno: number): Observable<{ message: string }> {
    return this.http.post<{ message: string }>(`${this.baseUrl}/alumno/${idAlumno}/recalcular`, {});
  }

  registrarDecision(payload: DecisionAdministrativa): Observable<{ message: string }> {
    return this.http.post<{ message: string }>(`${this.baseUrl}/decisiones`, payload);
  }

  getDecisiones(idAlumno: number): Observable<DecisionAdministrativa[]> {
    return this.http.get<DecisionAdministrativa[]>(`${this.baseUrl}/alumno/${idAlumno}/decisiones`);
  }

  registrarExcepcion(payload: ExcepcionAuditoria): Observable<{ message: string }> {
    return this.http.post<{ message: string }>(`${this.baseUrl}/excepciones`, payload);
  }

  getExcepciones(): Observable<ExcepcionAuditoria[]> {
    return this.http.get<ExcepcionAuditoria[]>(`${this.baseUrl}/excepciones`);
  }

  registrarCuentaEspecial(payload: CuentaEspecial): Observable<{ message: string }> {
    return this.http.post<{ message: string }>(`${this.baseUrl}/especiales`, payload);
  }

  getArbol(idAlumno: number): Observable<RelacionAccesoNodo> {
    return this.http.get<RelacionAccesoNodo>(`${this.baseUrl}/alumno/${idAlumno}/arbol`);
  }
}
