import { HttpClient, HttpParams } from '@angular/common/http';
import { inject, Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { API_BASE_URL } from '../constants/api.constants';
import {
  CreateRinconPedidoRequest,
  RinconPedido,
  RinconProducto,
  RinconProductoFilters,
  RinconResumenAdmin,
  SaveRinconProductoRequest
} from '../models/rincon.models';

@Injectable({ providedIn: 'root' })
export class RinconService {
  private readonly http = inject(HttpClient);

  getProductos(filters: RinconProductoFilters = {}): Observable<RinconProducto[]> {
    let params = new HttpParams();

    if (filters.categoria?.trim()) {
      params = params.set('categoria', filters.categoria.trim());
    }

    if (filters.soloDisponibles !== null && filters.soloDisponibles !== undefined) {
      params = params.set('soloDisponibles', filters.soloDisponibles);
    }

    return this.http.get<RinconProducto[]>(`${API_BASE_URL}/rincon/productos`, { params });
  }

  getProductoById(idProducto: number): Observable<RinconProducto> {
    return this.http.get<RinconProducto>(`${API_BASE_URL}/rincon/productos/${idProducto}`);
  }

  createPedido(payload: CreateRinconPedidoRequest): Observable<RinconPedido> {
    return this.http.post<RinconPedido>(`${API_BASE_URL}/rincon/pedidos`, payload);
  }

  getComprobante(idPedido: number): Observable<RinconPedido> {
    return this.http.get<RinconPedido>(`${API_BASE_URL}/rincon/pedidos/${idPedido}/comprobante`);
  }

  getHistorial(): Observable<RinconPedido[]> {
    return this.http.get<RinconPedido[]>(`${API_BASE_URL}/rincon/historial`);
  }

  cancelarPedido(idPedido: number): Observable<RinconPedido> {
    return this.http.post<RinconPedido>(`${API_BASE_URL}/rincon/pedidos/${idPedido}/cancelar`, {});
  }

  getResumenAdmin(): Observable<RinconResumenAdmin> {
    return this.http.get<RinconResumenAdmin>(`${API_BASE_URL}/rincon/admin/resumen`);
  }

  createProducto(payload: SaveRinconProductoRequest): Observable<RinconProducto> {
    return this.http.post<RinconProducto>(`${API_BASE_URL}/rincon/admin/productos`, this.toFormData(payload));
  }

  updateProducto(idProducto: number, payload: SaveRinconProductoRequest): Observable<void> {
    return this.http.put<void>(
      `${API_BASE_URL}/rincon/admin/productos/${idProducto}`,
      this.toFormData(payload)
    );
  }

  deleteProducto(idProducto: number): Observable<void> {
    return this.http.delete<void>(`${API_BASE_URL}/rincon/admin/productos/${idProducto}`);
  }

  getPedidosPendientes(): Observable<RinconPedido[]> {
    return this.http.get<RinconPedido[]>(`${API_BASE_URL}/rincon/admin/pedidos-pendientes`);
  }

  marcarEntregado(idPedido: number): Observable<RinconPedido> {
    return this.http.post<RinconPedido>(`${API_BASE_URL}/rincon/admin/pedidos/${idPedido}/entregado`, {});
  }

  getHistorialAdmin(estado?: number | null): Observable<RinconPedido[]> {
    let params = new HttpParams();
    if (estado !== null && estado !== undefined) {
      params = params.set('estado', estado);
    }

    return this.http.get<RinconPedido[]>(`${API_BASE_URL}/rincon/admin/historial`, { params });
  }

  private toFormData(payload: SaveRinconProductoRequest): FormData {
    const formData = new FormData();
    formData.append('nombre', payload.nombre);
    formData.append('descripcion', payload.descripcion ?? '');
    formData.append('precio', `${payload.precio}`);
    formData.append('stock', `${payload.stock}`);
    formData.append('categoria', payload.categoria ?? '');
    formData.append('imagenUrlActual', payload.imagenUrlActual ?? '');

    if (payload.imagenFile) {
      formData.append('imagenFile', payload.imagenFile);
    }

    return formData;
  }
}
