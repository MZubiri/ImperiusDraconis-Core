import { HttpClient, HttpParams } from '@angular/common/http';
import { inject, Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { RuntimeConfigService } from './runtime-config.service';
import { PagedResult } from '../models/alumnos.models';
import {
  DracoinAdministrativePayment,
  DracoinGeneralHistoryFilters,
  DracoinGeneralMovement,
  DracoinManualPaymentCandidate,
  DracoinManualPaymentsResult,
  DracoinSalaryByCargo,
  DracoinSummary,
  DracoinTransfer,
  SaveDracoinTransferRequest,
  CreateDracoinManualPaymentsRequest,
  UpdateDracoinSalaryCatalogRequest
} from '../models/dracoins.models';

@Injectable({ providedIn: 'root' })
export class DracoinsService {
  private readonly http = inject(HttpClient);
  private readonly runtimeConfig = inject(RuntimeConfigService);

  getSummary(): Observable<DracoinSummary> {
    return this.http.get<DracoinSummary>(`${this.runtimeConfig.apiUrl}/dracoins/resumen`);
  }

  getTransferHistory(page = 1, pageSize = 10): Observable<PagedResult<DracoinTransfer>> {
    const params = new HttpParams().set('pagina', page).set('registrosPorPagina', pageSize);
    return this.http.get<PagedResult<DracoinTransfer>>(`${this.runtimeConfig.apiUrl}/dracoins/transferencias`, {
      params
    });
  }

  createTransfer(payload: SaveDracoinTransferRequest): Observable<DracoinTransfer> {
    return this.http.post<DracoinTransfer>(`${this.runtimeConfig.apiUrl}/dracoins/transferencias`, payload);
  }

  getAdministrativePayments(
    page = 1,
    pageSize = 10
  ): Observable<PagedResult<DracoinAdministrativePayment>> {
    const params = new HttpParams().set('pagina', page).set('registrosPorPagina', pageSize);
    return this.http.get<PagedResult<DracoinAdministrativePayment>>(
      `${this.runtimeConfig.apiUrl}/dracoins/historial-pagos`,
      { params }
    );
  }

  getGeneralHistory(
    filters: DracoinGeneralHistoryFilters
  ): Observable<PagedResult<DracoinGeneralMovement>> {
    let params = new HttpParams()
      .set('pagina', filters.pagina ?? 1)
      .set('registrosPorPagina', filters.registrosPorPagina ?? 10);

    if (filters.remitente?.trim()) {
      params = params.set('remitente', filters.remitente.trim());
    }

    if (filters.destinatario?.trim()) {
      params = params.set('destinatario', filters.destinatario.trim());
    }

    if (filters.montoMin !== null && filters.montoMin !== undefined) {
      params = params.set('montoMin', filters.montoMin);
    }

    if (filters.montoMax !== null && filters.montoMax !== undefined) {
      params = params.set('montoMax', filters.montoMax);
    }

    if (filters.observacion?.trim()) {
      params = params.set('observacion', filters.observacion.trim());
    }

    if (filters.desde) {
      params = params.set('desde', filters.desde);
    }

    if (filters.hasta) {
      params = params.set('hasta', filters.hasta);
    }

    return this.http.get<PagedResult<DracoinGeneralMovement>>(
      `${this.runtimeConfig.apiUrl}/dracoins/historial-general`,
      { params }
    );
  }

  getSalaryCatalog(): Observable<DracoinSalaryByCargo[]> {
    return this.http.get<DracoinSalaryByCargo[]>(`${this.runtimeConfig.apiUrl}/dracoins/sueldos-por-cargo`);
  }

  updateSalaryCatalog(
    payload: UpdateDracoinSalaryCatalogRequest
  ): Observable<DracoinSalaryByCargo[]> {
    return this.http.put<DracoinSalaryByCargo[]>(`${this.runtimeConfig.apiUrl}/dracoins/sueldos-por-cargo`, payload);
  }

  getManualPaymentCandidates(): Observable<DracoinManualPaymentCandidate[]> {
    return this.http.get<DracoinManualPaymentCandidate[]>(`${this.runtimeConfig.apiUrl}/dracoins/pagos-manuales`);
  }

  createManualPayments(
    payload: CreateDracoinManualPaymentsRequest
  ): Observable<DracoinManualPaymentsResult> {
    return this.http.post<DracoinManualPaymentsResult>(`${this.runtimeConfig.apiUrl}/dracoins/pagos-manuales`, payload);
  }
}
