import { HttpClient, HttpParams } from '@angular/common/http';
import { inject, Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { RuntimeConfigService } from './runtime-config.service';
import { BibliotecaCategoria, BibliotecaLibro, SaveLibroRequest, SuscripcionStatus } from '../models/biblioteca.models';

@Injectable({ providedIn: 'root' })
export class BibliotecaService {
  private readonly http = inject(HttpClient);
  private readonly runtimeConfig = inject(RuntimeConfigService);

  unlock(password: string): Observable<{ success: boolean; token: string }> {
    return this.http.post<{ success: boolean; token: string }>(
      `${this.runtimeConfig.apiUrl}/biblioteca/unlock`, 
      { password }
    );
  }

  getCategorias(): Observable<BibliotecaCategoria[]> {
    return this.http.get<BibliotecaCategoria[]>(`${this.runtimeConfig.apiUrl}/biblioteca/categorias`);
  }

  getLibros(
    categoriaId?: number | null, 
    busqueda?: string, 
    soloMisLibros: boolean = false
  ): Observable<BibliotecaLibro[]> {
    let params = new HttpParams();
    if (categoriaId !== null && categoriaId !== undefined) {
      params = params.set('categoriaId', categoriaId.toString());
    }
    if (busqueda?.trim()) {
      params = params.set('busqueda', busqueda.trim());
    }
    if (soloMisLibros) {
      params = params.set('soloMisLibros', 'true');
    }

    return this.http.get<BibliotecaLibro[]>(`${this.runtimeConfig.apiUrl}/biblioteca/libros`, { params });
  }

  comprarLibro(id: number): Observable<{ success: boolean; message: string }> {
    return this.http.post<{ success: boolean; message: string }>(
      `${this.runtimeConfig.apiUrl}/biblioteca/comprar/${id}`, 
      {}
    );
  }

  getSuscripcionStatus(): Observable<SuscripcionStatus> {
    return this.http.get<SuscripcionStatus>(`${this.runtimeConfig.apiUrl}/biblioteca/suscripcion`);
  }

  suscribirse(): Observable<{ success: boolean; message: string }> {
    return this.http.post<{ success: boolean; message: string }>(
      `${this.runtimeConfig.apiUrl}/biblioteca/suscribirse`, 
      {}
    );
  }

  // --- MÉTODOS CRUD (Administrador) ---

  crearLibro(payload: SaveLibroRequest): Observable<{ success: boolean; message: string }> {
    return this.http.post<{ success: boolean; message: string }>(
      `${this.runtimeConfig.apiUrl}/biblioteca/libros`, 
      payload
    );
  }

  actualizarLibro(id: number, payload: SaveLibroRequest): Observable<{ success: boolean; message: string }> {
    return this.http.put<{ success: boolean; message: string }>(
      `${this.runtimeConfig.apiUrl}/biblioteca/libros/${id}`, 
      payload
    );
  }

  eliminarLibro(id: number): Observable<{ success: boolean; message: string }> {
    return this.http.delete<{ success: boolean; message: string }>(
      `${this.runtimeConfig.apiUrl}/biblioteca/libros/${id}`
    );
  }

  getLeerUrl(id: number): string {
    const token = localStorage.getItem('imperiusdraconis.session') 
      ? JSON.parse(localStorage.getItem('imperiusdraconis.session')!).token 
      : '';
    return `${this.runtimeConfig.apiUrl}/biblioteca/leer/${id}?access_token=${token}#toolbar=0`;
  }

  descargarLibro(id: number): Observable<Blob> {
    return this.http.get(`${this.runtimeConfig.apiUrl}/biblioteca/descargar/${id}`, {
      responseType: 'blob'
    });
  }

  exportarExcel(): Observable<Blob> {
    return this.http.get(`${this.runtimeConfig.apiUrl}/biblioteca/exportar`, {
      responseType: 'blob'
    });
  }

  importarExcel(file: File): Observable<{ success: boolean; count: number; message: string }> {
    const formData = new FormData();
    formData.append('file', file);
    return this.http.post<{ success: boolean; count: number; message: string }>(
      `${this.runtimeConfig.apiUrl}/biblioteca/importar`,
      formData
    );
  }
}
