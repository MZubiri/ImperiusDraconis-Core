import { HttpClient, HttpParams } from '@angular/common/http';
import { inject, Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { API_BASE_URL } from '../constants/api.constants';
import {
  CreateTiendaCompraRequest,
  TiendaAdminCatalogos,
  TiendaCompraCatalogos,
  TiendaComprobante,
  TiendaHistorialAdminFilters,
  TiendaHistorialResult,
  TiendaPanelResumen,
  TiendaPedido,
  TiendaProducto,
  UpdateTiendaPedidoEstadoRequest
} from '../models/tienda.models';

@Injectable({ providedIn: 'root' })
export class TiendaService {
  private readonly http = inject(HttpClient);

  getProductos(filters: { nombre?: string; precioMin?: number | null; precioMax?: number | null } = {}): Observable<TiendaProducto[]> {
    let params = new HttpParams();

    if (filters.nombre?.trim()) {
      params = params.set('nombre', filters.nombre.trim());
    }

    if (filters.precioMin !== null && filters.precioMin !== undefined) {
      params = params.set('precioMin', filters.precioMin);
    }

    if (filters.precioMax !== null && filters.precioMax !== undefined) {
      params = params.set('precioMax', filters.precioMax);
    }

    return this.http.get<TiendaProducto[]>(`${API_BASE_URL}/tienda/productos`, { params });
  }

  getCompraCatalogos(): Observable<TiendaCompraCatalogos> {
    return this.http.get<TiendaCompraCatalogos>(`${API_BASE_URL}/tienda/catalogos-compra`);
  }

  createCompra(payload: CreateTiendaCompraRequest): Observable<TiendaComprobante> {
    return this.http.post<TiendaComprobante>(`${API_BASE_URL}/tienda/compras`, payload);
  }

  getComprobante(idPedido: number): Observable<TiendaComprobante> {
    return this.http.get<TiendaComprobante>(`${API_BASE_URL}/tienda/pedidos/${idPedido}/comprobante`);
  }

  getHistorial(filters: {
    estado?: string;
    nombre?: string;
    desde?: string | null;
    hasta?: string | null;
    pagina?: number;
    registrosPorPagina?: number;
  } = {}): Observable<TiendaHistorialResult> {
    let params = new HttpParams();

    if (filters.estado?.trim()) {
      params = params.set('estado', filters.estado.trim());
    }

    if (filters.nombre?.trim()) {
      params = params.set('nombre', filters.nombre.trim());
    }

    if (filters.desde) {
      params = params.set('desde', filters.desde);
    }

    if (filters.hasta) {
      params = params.set('hasta', filters.hasta);
    }

    params = params.set('pagina', filters.pagina ?? 1).set('registrosPorPagina', filters.registrosPorPagina ?? 10);
    return this.http.get<TiendaHistorialResult>(`${API_BASE_URL}/tienda/historial`, { params });
  }

  cancelarPedido(idPedido: number): Observable<void> {
    return this.http.post<void>(`${API_BASE_URL}/tienda/pedidos/${idPedido}/cancelar`, {});
  }

  getPendientes(): Observable<TiendaPedido[]> {
    return this.http.get<TiendaPedido[]>(`${API_BASE_URL}/tienda/pendientes`);
  }

  tomarPedido(idPedido: number): Observable<TiendaPedido> {
    return this.http.post<TiendaPedido>(`${API_BASE_URL}/tienda/pedidos/${idPedido}/tomar`, {});
  }

  getMisPedidos(): Observable<TiendaPedido[]> {
    return this.http.get<TiendaPedido[]>(`${API_BASE_URL}/tienda/mis-pedidos`);
  }

  cambiarEstadoVendedor(
    idPedido: number,
    payload: UpdateTiendaPedidoEstadoRequest
  ): Observable<TiendaPedido> {
    return this.http.post<TiendaPedido>(`${API_BASE_URL}/tienda/pedidos/${idPedido}/estado`, payload);
  }

  getPanelAdmin(): Observable<TiendaPanelResumen> {
    return this.http.get<TiendaPanelResumen>(`${API_BASE_URL}/tienda/panel-admin`);
  }

  getAdminCatalogos(): Observable<TiendaAdminCatalogos> {
    return this.http.get<TiendaAdminCatalogos>(`${API_BASE_URL}/tienda/catalogos-admin`);
  }

  getHistorialAdmin(filters: TiendaHistorialAdminFilters = {}): Observable<TiendaHistorialResult> {
    let params = new HttpParams();

    if (filters.codigo?.trim()) {
      params = params.set('codigo', filters.codigo.trim());
    }

    if (filters.idVendedor !== null && filters.idVendedor !== undefined) {
      params = params.set('idVendedor', filters.idVendedor);
    }

    if (filters.estado !== null && filters.estado !== undefined) {
      params = params.set('estado', filters.estado);
    }

    params = params.set('pagina', filters.pagina ?? 1).set('registrosPorPagina', filters.registrosPorPagina ?? 10);
    return this.http.get<TiendaHistorialResult>(`${API_BASE_URL}/tienda/historial-admin`, { params });
  }

  cambiarEstadoAdmin(
    idPedido: number,
    payload: UpdateTiendaPedidoEstadoRequest
  ): Observable<TiendaPedido> {
    return this.http.post<TiendaPedido>(`${API_BASE_URL}/tienda/pedidos/${idPedido}/estado-admin`, payload);
  }
}
