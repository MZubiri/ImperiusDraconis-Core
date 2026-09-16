import { HttpClient } from '@angular/common/http';
import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { GameLinkCode } from '../models/game.models';
import { RuntimeConfigService } from './runtime-config.service';

@Injectable({ providedIn: 'root' })
export class GameService {
  private readonly http = inject(HttpClient);
  private readonly runtimeConfig = inject(RuntimeConfigService);

  createLinkCode(): Observable<GameLinkCode> {
    return this.http.post<GameLinkCode>(`${this.runtimeConfig.apiUrl}/game/v1/links/code`, {});
  }
}
