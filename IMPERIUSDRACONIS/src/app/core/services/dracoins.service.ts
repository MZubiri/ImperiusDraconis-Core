import { HttpClient, HttpParams } from '@angular/common/http';
import { inject, Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { API_BASE_URL } from '../constants/api.constants';
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

  getSummary(): Observable<DracoinSummary> {
    return this.http.get<DracoinSummary>(`${API_BASE_URL}/dracoins/resumen`);
  }

  getTransferHistory(page = 1, pageSize = 10): Observable<PagedResult<DracoinTransfer>> {
    const params = new HttpParams().set('pagina', page).set('registrosPorPagina', pageSize);
    return this.http.get<PagedResult<DracoinTransfer>>(`${API_BASE_URL}/dracoins/transferencias`, {
      params
    });
  }

  createTransfer(payload: SaveDracoinTransferRequest): Observable<DracoinTransfer> {
    return this.http.post<DracoinTransfer>(`${API_BASE_URL}/dracoins/transferencias`, payload);
  }

  getAdministrativePayments(
    page = 1,
    pageSize = 10
  ): Observable<PagedResult<DracoinAdministrativePayment>> {
    const params = new HttpParams().set('pagina', page).set('registrosPorPagina', pageSize);
    return this.http.get<PagedResult<DracoinAdministrativePayment>>(
      `${API_BASE_URL}/dracoins/historial-pagos`,
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
      `${API_BASE_URL}/dracoins/historial-general`,
      { params }
    );
  }

  getSalaryCatalog(): Observable<DracoinSalaryByCargo[]> {
    return this.http.get<DracoinSalaryByCargo[]>(`${API_BASE_URL}/dracoins/sueldos-por-cargo`);
  }

  updateSalaryCatalog(
    payload: UpdateDracoinSalaryCatalogRequest
  ): Observable<DracoinSalaryByCargo[]> {
    return this.http.put<DracoinSalaryByCargo[]>(`${API_BASE_URL}/dracoins/sueldos-por-cargo`, payload);
  }

  getManualPaymentCandidates(): Observable<DracoinManualPaymentCandidate[]> {
    return this.http.get<DracoinManualPaymentCandidate[]>(`${API_BASE_URL}/dracoins/pagos-manuales`);
  }

  createManualPayments(
    payload: CreateDracoinManualPaymentsRequest
  ): Observable<DracoinManualPaymentsResult> {
    return this.http.post<DracoinManualPaymentsResult>(`${API_BASE_URL}/dracoins/pagos-manuales`, payload);
  }
}
