import { HttpClient } from '@angular/common/http';
import { inject, Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { RuntimeConfigService } from './runtime-config.service';
import { Producto, SaveProductoRequest } from '../models/productos.models';

@Injectable({ providedIn: 'root' })
export class ProductosService {
  private readonly http = inject(HttpClient);
  private readonly runtimeConfig = inject(RuntimeConfigService);

  getAll(): Observable<Producto[]> {
    return this.http.get<Producto[]>(`${this.runtimeConfig.apiUrl}/productos`);
  }

  getById(idProducto: number): Observable<Producto> {
    return this.http.get<Producto>(`${this.runtimeConfig.apiUrl}/productos/${idProducto}`);
  }

  create(payload: SaveProductoRequest): Observable<Producto> {
    return this.http.post<Producto>(`${this.runtimeConfig.apiUrl}/productos`, this.toFormData(payload));
  }

  update(idProducto: number, payload: SaveProductoRequest): Observable<void> {
    return this.http.put<void>(`${this.runtimeConfig.apiUrl}/productos/${idProducto}`, this.toFormData(payload));
  }

  delete(idProducto: number): Observable<void> {
    return this.http.delete<void>(`${this.runtimeConfig.apiUrl}/productos/${idProducto}`);
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
