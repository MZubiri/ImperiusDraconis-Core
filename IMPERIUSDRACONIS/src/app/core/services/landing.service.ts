import { HttpClient } from '@angular/common/http';
import { inject, Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import {
  LandingAdmin,
  LandingConfiguration,
  LandingContentItem,
  LandingPage,
  SaveLandingConfiguration,
  SaveLandingContent
} from '../models/landing.models';
import { RuntimeConfigService } from './runtime-config.service';

@Injectable({ providedIn: 'root' })
export class LandingService {
  private readonly http = inject(HttpClient);
  private readonly runtimeConfig = inject(RuntimeConfigService);

  getPublic(): Observable<LandingPage> {
    return this.http.get<LandingPage>(`${this.runtimeConfig.apiUrl}/landing`);
  }

  getAdmin(): Observable<LandingAdmin> {
    return this.http.get<LandingAdmin>(`${this.runtimeConfig.apiUrl}/landing/admin`);
  }

  saveConfiguration(payload: SaveLandingConfiguration): Observable<LandingConfiguration> {
    return this.http.put<LandingConfiguration>(
      `${this.runtimeConfig.apiUrl}/landing/admin/configuracion`,
      payload
    );
  }

  saveContent(
    type: string,
    position: number,
    payload: SaveLandingContent
  ): Observable<LandingContentItem> {
    const formData = new FormData();
    formData.set('titulo', payload.titulo);
    formData.set('descripcion', payload.descripcion);
    formData.set('meta', payload.meta);
    formData.set('imagenUrlActual', payload.imagenUrlActual);
    formData.set('enlaceOEmbed', payload.enlaceOEmbed);
    formData.set('activo', String(payload.activo));
    if (payload.imagenFile) {
      formData.set('imagenFile', payload.imagenFile);
    }

    return this.http.put<LandingContentItem>(
      `${this.runtimeConfig.apiUrl}/landing/admin/contenido/${type}/${position}`,
      formData
    );
  }

  deleteGazette(position: number): Observable<void> {
    return this.http.delete<void>(
      `${this.runtimeConfig.apiUrl}/landing/admin/gaceta/${position}`
    );
  }
}
