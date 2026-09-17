import { HttpClient } from '@angular/common/http';
import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { GameAdminCatalogs, GameAdminPlayer, GameLinkCode } from '../models/game.models';
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

  getGameCatalogs(): Observable<GameAdminCatalogs> {
    return this.http.get<GameAdminCatalogs>(`${this.runtimeConfig.apiUrl}/game/v1/admin/catalogs`);
  }

  updateGamePriceCatalog(kind: 'egg' | 'food', code: string, priceDracoins: number, active: boolean): Observable<void> {
    return this.http.put<void>(`${this.runtimeConfig.apiUrl}/game/v1/admin/${kind}-definitions/${encodeURIComponent(code)}`, { priceDracoins, active });
  }

  updateGameMission(code: string, targetAmount: number, rewardDracoins: number, rewardExperience: number, active: boolean): Observable<void> {
    return this.http.put<void>(`${this.runtimeConfig.apiUrl}/game/v1/admin/mission-definitions/${encodeURIComponent(code)}`, { targetAmount, rewardDracoins, rewardExperience, active });
  }
}
