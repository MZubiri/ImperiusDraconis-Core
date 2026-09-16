import { ChangeDetectionStrategy, Component, DestroyRef, computed, inject, signal } from '@angular/core';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { finalize, interval, startWith } from 'rxjs';
import { GameLinkCode } from '../../core/models/game.models';
import { GameService } from '../../core/services/game.service';
import { readHttpErrorMessage } from '../../core/utils/http-error.utils';

@Component({
  selector: 'app-game-link-page',
  templateUrl: './game-link-page.component.html',
  styleUrl: './game-link-page.component.css',
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class GameLinkPageComponent {
  private readonly destroyRef = inject(DestroyRef);
  private readonly gameService = inject(GameService);

  readonly linkCode = signal<GameLinkCode | null>(null);
  readonly loading = signal(false);
  readonly errorMessage = signal('');
  readonly now = signal(Date.now());
  readonly secondsRemaining = computed(() => {
    const value = this.linkCode();
    return value ? Math.max(0, Math.ceil((new Date(value.expiresAt).getTime() - this.now()) / 1000)) : 0;
  });
  readonly formattedRemaining = computed(() => {
    const seconds = this.secondsRemaining();
    return `${Math.floor(seconds / 60)}:${String(seconds % 60).padStart(2, '0')}`;
  });

  constructor() {
    interval(1000).pipe(startWith(0), takeUntilDestroyed(this.destroyRef)).subscribe(() => this.now.set(Date.now()));
  }

  generateCode(): void {
    this.loading.set(true);
    this.errorMessage.set('');
    this.gameService.createLinkCode()
      .pipe(finalize(() => this.loading.set(false)), takeUntilDestroyed(this.destroyRef))
      .subscribe({
        next: (code) => this.linkCode.set(code),
        error: (error) => this.errorMessage.set(readHttpErrorMessage(error, 'No se pudo generar el codigo.'))
      });
  }
}
