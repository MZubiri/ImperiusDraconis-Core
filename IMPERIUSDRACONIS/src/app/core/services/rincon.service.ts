import { HttpClient, HttpParams } from '@angular/common/http';
import { inject, Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { RuntimeConfigService } from './runtime-config.service';
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
  private readonly runtimeConfig = inject(RuntimeConfigService);

  getProductos(filters: RinconProductoFilters = {}): Observable<RinconProducto[]> {
    let params = new HttpParams();

    if (filters.categoria?.trim()) {
      params = params.set('categoria', filters.categoria.trim());
    }

    if (filters.soloDisponibles !== null && filters.soloDisponibles !== undefined) {
      params = params.set('soloDisponibles', filters.soloDisponibles);
    }

    return this.http.get<RinconProducto[]>(`${this.runtimeConfig.apiUrl}/rincon/productos`, { params });
  }

  getProductoById(idProducto: number): Observable<RinconProducto> {
    return this.http.get<RinconProducto>(`${this.runtimeConfig.apiUrl}/rincon/productos/${idProducto}`);
  }

  createPedido(payload: CreateRinconPedidoRequest): Observable<RinconPedido> {
    return this.http.post<RinconPedido>(`${this.runtimeConfig.apiUrl}/rincon/pedidos`, payload);
  }

  getComprobante(idPedido: number): Observable<RinconPedido> {
    return this.http.get<RinconPedido>(`${this.runtimeConfig.apiUrl}/rincon/pedidos/${idPedido}/comprobante`);
  }

  getHistorial(): Observable<RinconPedido[]> {
    return this.http.get<RinconPedido[]>(`${this.runtimeConfig.apiUrl}/rincon/historial`);
  }

  cancelarPedido(idPedido: number): Observable<RinconPedido> {
    return this.http.post<RinconPedido>(`${this.runtimeConfig.apiUrl}/rincon/pedidos/${idPedido}/cancelar`, {});
  }

  getResumenAdmin(): Observable<RinconResumenAdmin> {
    return this.http.get<RinconResumenAdmin>(`${this.runtimeConfig.apiUrl}/rincon/admin/resumen`);
  }

  createProducto(payload: SaveRinconProductoRequest): Observable<RinconProducto> {
    return this.http.post<RinconProducto>(`${this.runtimeConfig.apiUrl}/rincon/admin/productos`, this.toFormData(payload));
  }

  updateProducto(idProducto: number, payload: SaveRinconProductoRequest): Observable<void> {
    return this.http.put<void>(
      `${this.runtimeConfig.apiUrl}/rincon/admin/productos/${idProducto}`,
      this.toFormData(payload)
    );
  }

  deleteProducto(idProducto: number): Observable<void> {
    return this.http.delete<void>(`${this.runtimeConfig.apiUrl}/rincon/admin/productos/${idProducto}`);
  }

  getPedidosPendientes(): Observable<RinconPedido[]> {
    return this.http.get<RinconPedido[]>(`${this.runtimeConfig.apiUrl}/rincon/admin/pedidos-pendientes`);
  }

  marcarEntregado(idPedido: number): Observable<RinconPedido> {
    return this.http.post<RinconPedido>(`${this.runtimeConfig.apiUrl}/rincon/admin/pedidos/${idPedido}/entregado`, {});
  }

  getHistorialAdmin(estado?: number | null): Observable<RinconPedido[]> {
    let params = new HttpParams();
    if (estado !== null && estado !== undefined) {
      params = params.set('estado', estado);
    }

    return this.http.get<RinconPedido[]>(`${this.runtimeConfig.apiUrl}/rincon/admin/historial`, { params });
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
