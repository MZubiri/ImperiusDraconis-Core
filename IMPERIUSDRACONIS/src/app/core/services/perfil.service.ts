import { HttpClient } from '@angular/common/http';
import { inject, Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { API_BASE_URL } from '../constants/api.constants';
import {
  ChangeMyPasswordRequest,
  PerfilDetail,
  UploadProfileImageResponse,
  UpdateMyProfileRequest
} from '../models/perfil.models';

@Injectable({ providedIn: 'root' })
export class PerfilService {
  private readonly http = inject(HttpClient);

  getProfile(): Observable<PerfilDetail> {
    return this.http.get<PerfilDetail>(`${API_BASE_URL}/perfil`);
  }

  updateProfile(payload: UpdateMyProfileRequest): Observable<void> {
    return this.http.put<void>(`${API_BASE_URL}/perfil`, payload);
  }

  changePassword(payload: ChangeMyPasswordRequest): Observable<void> {
    return this.http.put<void>(`${API_BASE_URL}/perfil/contrasena`, payload);
  }

  uploadProfileImage(file: File): Observable<UploadProfileImageResponse> {
    const formData = new FormData();
    formData.append('fotoArchivo', file);
    return this.http.post<UploadProfileImageResponse>(`${API_BASE_URL}/perfil/foto`, formData);
  }
}
