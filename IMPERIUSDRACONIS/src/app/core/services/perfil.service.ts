import { HttpClient } from '@angular/common/http';
import { inject, Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { RuntimeConfigService } from './runtime-config.service';
import {
  ChangeMyPasswordRequest,
  PerfilDetail,
  UploadProfileImageResponse,
  UpdateMyProfileRequest
} from '../models/perfil.models';

@Injectable({ providedIn: 'root' })
export class PerfilService {
  private readonly http = inject(HttpClient);
  private readonly runtimeConfig = inject(RuntimeConfigService);

  getProfile(): Observable<PerfilDetail> {
    return this.http.get<PerfilDetail>(`${this.runtimeConfig.apiUrl}/perfil`);
  }

  updateProfile(payload: UpdateMyProfileRequest): Observable<void> {
    return this.http.put<void>(`${this.runtimeConfig.apiUrl}/perfil`, payload);
  }

  changePassword(payload: ChangeMyPasswordRequest): Observable<void> {
    return this.http.put<void>(`${this.runtimeConfig.apiUrl}/perfil/contrasena`, payload);
  }

  uploadProfileImage(file: File): Observable<UploadProfileImageResponse> {
    const formData = new FormData();
    formData.append('fotoArchivo', file);
    return this.http.post<UploadProfileImageResponse>(`${this.runtimeConfig.apiUrl}/perfil/foto`, formData);
  }
}
