import { HttpClient } from '@angular/common/http';
import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { GameAdminPlayer, GameLinkCode } from '../models/game.models';
import { RuntimeConfigService } from './runtime-config.service';

@Injectable({ providedIn: 'root' })
export class GameService {
  private readonly http = inject(HttpClient);
  private readonly runtimeConfig = inject(RuntimeConfigService);

  createLinkCode(): Observable<GameLinkCode> {
    return this.http.post<GameLinkCode>(`${this.runtimeConfig.apiUrl}/game/v1/links/code`, {});
  }

  getAdminPlayer(idAlumno?: number, robloxUserId?: number): Observable<GameAdminPlayer> {
    const query = idAlumno ? `idAlumno=${idAlumno}` : `robloxUserId=${robloxUserId}`;
    return this.http.get<GameAdminPlayer>(`${this.runtimeConfig.apiUrl}/game/v1/admin/players?${query}`);
  }

  adjustDracoins(idAlumno: number, amount: number, justification: string): Observable<{ balanceAfter: number }> {
    return this.http.post<{ balanceAfter: number }>(`${this.runtimeConfig.apiUrl}/game/v1/admin/dracoins/adjustment`, {
      idAlumno, amount, justification
    });
  }

  restoreDragon(dragonId: number): Observable<void> {
    return this.http.post<void>(`${this.runtimeConfig.apiUrl}/game/v1/admin/dragons/${dragonId}/restore`, {});
  }
}
