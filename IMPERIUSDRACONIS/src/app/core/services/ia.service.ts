import { HttpClient } from '@angular/common/http';
import { inject, Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { RuntimeConfigService } from './runtime-config.service';
import { FormatCorrectionRequest, FormatCorrectionResponse } from '../models/ia.models';

@Injectable({ providedIn: 'root' })
export class IaService {
  private readonly http = inject(HttpClient);
  private readonly runtimeConfig = inject(RuntimeConfigService);

  correctFormat(payload: FormatCorrectionRequest): Observable<FormatCorrectionResponse> {
    return this.http.post<FormatCorrectionResponse>(
      `${this.runtimeConfig.apiUrl}/ia/corregir-formato`,
      payload
    );
  }
}
