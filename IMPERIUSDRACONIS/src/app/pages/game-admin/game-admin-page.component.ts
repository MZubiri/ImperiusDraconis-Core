import { ChangeDetectionStrategy, Component, DestroyRef, inject, signal } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { finalize } from 'rxjs';
import { GameAdminCatalogs, GameAdminMissionCatalogItem, GameAdminPlayer, GameAdminPriceCatalogItem } from '../../core/models/game.models';
import { GameService } from '../../core/services/game.service';
import { readHttpErrorMessage } from '../../core/utils/http-error.utils';

@Component({
  selector: 'app-game-admin-page',
  imports: [FormsModule],
  templateUrl: './game-admin-page.component.html',
  styleUrl: './game-admin-page.component.css',
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class GameAdminPageComponent {
  private readonly service = inject(GameService);
  private readonly destroyRef = inject(DestroyRef);
  readonly player = signal<GameAdminPlayer | null>(null);
  readonly loading = signal(false);
  readonly message = signal('');
  readonly catalogs = signal<GameAdminCatalogs | null>(null);
  searchId = '';
  searchType: 'student' | 'roblox' = 'student';
  amount = 0;
  justification = '';

  constructor() { this.loadCatalogs(); }

  loadCatalogs(): void {
    this.service.getGameCatalogs().pipe(takeUntilDestroyed(this.destroyRef)).subscribe({
      next: (catalogs) => this.catalogs.set(catalogs),
      error: (error) => this.message.set(readHttpErrorMessage(error, 'No se pudieron cargar los catálogos.'))
    });
  }

  search(): void {
    const value = Number(this.searchId);
    if (!Number.isSafeInteger(value) || value <= 0) { this.message.set('Introduce un identificador válido.'); return; }
    this.loading.set(true); this.message.set('');
    this.service.getAdminPlayer(this.searchType === 'student' ? value : undefined, this.searchType === 'roblox' ? value : undefined)
      .pipe(finalize(() => this.loading.set(false)), takeUntilDestroyed(this.destroyRef))
      .subscribe({ next: (player) => this.player.set(player), error: (error) => this.message.set(readHttpErrorMessage(error, 'No se pudo buscar el jugador.')) });
  }

  adjust(): void {
    const current = this.player();
    if (!current) return;
    this.service.adjustDracoins(current.idAlumno, Number(this.amount), this.justification)
      .pipe(takeUntilDestroyed(this.destroyRef)).subscribe({
        next: ({ balanceAfter }) => { this.player.update((value) => value ? { ...value, dracoins: balanceAfter } : null); this.amount = 0; this.justification = ''; this.message.set('Ajuste registrado en el ledger.'); },
        error: (error) => this.message.set(readHttpErrorMessage(error, 'No se pudo ajustar el saldo.'))
      });
  }

  restore(dragonId: number): void {
    this.service.restoreDragon(dragonId).pipe(takeUntilDestroyed(this.destroyRef)).subscribe({ next: () => this.search(), error: (error) => this.message.set(readHttpErrorMessage(error, 'No se pudo restaurar el dragón.')) });
  }

  savePrice(kind: 'egg' | 'food', item: GameAdminPriceCatalogItem): void {
    this.service.updateGamePriceCatalog(kind, item.code, Number(item.priceDracoins), item.active)
      .pipe(takeUntilDestroyed(this.destroyRef)).subscribe({ next: () => this.message.set(`${item.displayName} actualizado.`), error: (error) => this.message.set(readHttpErrorMessage(error, 'No se pudo actualizar el catálogo.')) });
  }

  saveMission(item: GameAdminMissionCatalogItem): void {
    this.service.updateGameMission(item.code, Number(item.targetAmount), Number(item.rewardDracoins), Number(item.rewardExperience), item.active)
      .pipe(takeUntilDestroyed(this.destroyRef)).subscribe({ next: () => this.message.set(`${item.displayName} actualizada.`), error: (error) => this.message.set(readHttpErrorMessage(error, 'No se pudo actualizar la misión.')) });
  }
}
