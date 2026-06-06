import { HttpClient } from '@angular/common/http';
import { inject, Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { API_BASE_URL } from '../constants/api.constants';
import { Producto, SaveProductoRequest } from '../models/productos.models';

@Injectable({ providedIn: 'root' })
export class ProductosService {
  private readonly http = inject(HttpClient);

  getAll(): Observable<Producto[]> {
    return this.http.get<Producto[]>(`${API_BASE_URL}/productos`);
  }

  getById(idProducto: number): Observable<Producto> {
    return this.http.get<Producto>(`${API_BASE_URL}/productos/${idProducto}`);
  }

  create(payload: SaveProductoRequest): Observable<Producto> {
    return this.http.post<Producto>(`${API_BASE_URL}/productos`, this.toFormData(payload));
  }

  update(idProducto: number, payload: SaveProductoRequest): Observable<void> {
    return this.http.put<void>(`${API_BASE_URL}/productos/${idProducto}`, this.toFormData(payload));
  }

  delete(idProducto: number): Observable<void> {
    return this.http.delete<void>(`${API_BASE_URL}/productos/${idProducto}`);
  }

  private toFormData(payload: SaveProductoRequest): FormData {
    const formData = new FormData();
    formData.append('nombre', payload.nombre);
    formData.append('descripcion', payload.descripcion ?? '');
    formData.append('precio', `${payload.precio}`);
    formData.append('activo', `${payload.activo}`);
    formData.append('imagenActual', payload.imagenActual ?? '');

    if (payload.fotoArchivo) {
      formData.append('fotoArchivo', payload.fotoArchivo);
    }

    return formData;
  }
}
