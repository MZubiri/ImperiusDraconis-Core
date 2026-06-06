import { CommonModule } from '@angular/common';
import { HttpErrorResponse } from '@angular/common/http';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { ChangeDetectionStrategy, Component, DestroyRef, computed, inject, signal } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { finalize } from 'rxjs';
import { PagedResult } from '../../core/models/alumnos.models';
import {
  HistorialMarcador,
  MarcadorAdjustmentResult,
  MarcadorCasa,
  MarcadorCloseResult,
  MarcadorUpdateResult
} from '../../core/models/marcadores.models';
import { AuthService } from '../../core/services/auth.service';
import { MarcadoresService } from '../../core/services/marcadores.service';

interface MarcadorCasaEditable extends MarcadorCasa {
  puntos: number;
}

type MarcadoresPanel = 'marcador' | 'actualizar' | 'ajustar' | 'historial';

@Component({
  selector: 'app-marcadores-page',
  imports: [CommonModule, FormsModule],
  templateUrl: './marcadores-page.component.html',
  styleUrl: './marcadores-page.component.css',
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class MarcadoresPageComponent {
  private readonly destroyRef = inject(DestroyRef);

  readonly auth = inject(AuthService);
  readonly marcadoresService = inject(MarcadoresService);

  readonly currentScoreboard = signal<MarcadorCasa[]>([]);
  readonly history = signal<PagedResult<HistorialMarcador> | null>(null);
  readonly editableHouses = signal<MarcadorCasaEditable[]>([]);
  readonly loadingCurrent = signal(false);
  readonly loadingHouses = signal(false);
  readonly loadingHistory = signal(false);
  readonly submitting = signal(false);
  readonly submittingAdjustment = signal(false);
  readonly closingScoreboard = signal(false);
  readonly errorMessage = signal('');
  readonly successMessage = signal('');
  readonly activePanel = signal<MarcadoresPanel>('marcador');
  readonly closeConfirmOpen = signal(false);

  readonly canOpenPanel = computed(() => this.auth.hasPermission('Marcadores:Index'));
  readonly canViewCurrent = computed(() => this.auth.hasPermission('Marcadores:MarcadorActual'));
  readonly canUpdate = computed(() => this.auth.hasPermission('Marcadores:ActualizarMarcador'));
  readonly canAdjust = computed(() => this.auth.hasPermission('Marcadores:AjustesPuntos'));
  readonly canViewHistory = computed(() => this.auth.hasPermission('Marcadores:Historial'));
  readonly canViewModule = computed(
    () =>
      this.canOpenPanel() ||
      this.canViewCurrent() ||
      this.canAdjust() ||
      this.canViewHistory()
  );
  readonly canViewScoreboard = computed(
    () => this.canViewCurrent() || this.canAdjust()
  );
  readonly visibleScoreboard = computed(() =>
    this.currentScoreboard().filter((house) => house.nombreCasa.trim().toLowerCase() !== 'id')
  );
  readonly rankedScoreboard = computed(() =>
    [...this.visibleScoreboard()].sort((left, right) => right.puntosAcumulados - left.puntosAcumulados)
  );
  readonly leader = computed(() => this.rankedScoreboard()[0] ?? null);
  readonly totalPoints = computed(() =>
    this.visibleScoreboard().reduce((total, house) => total + house.puntosAcumulados, 0)
  );

  nombreDinamica = '';
  subtipoDinamica = 'Normal';
  observacion = '';

  ajusteIdCasa: number | null = null;
  ajustePuntos: number | null = null;
  ajusteObservacion = '';

  constructor() {
    if (!this.canViewModule()) {
      return;
    }

    if (this.canAdjust()) {
      this.loadHouses();
    } else if (this.canViewCurrent()) {
      this.loadCurrent();
    }

    if (this.canViewHistory()) {
      this.loadHistory();
    }
  }

  setActivePanel(panel: MarcadoresPanel): void {
    this.activePanel.set(panel);
  }

  loadCurrent(): void {
    if (!this.canViewCurrent()) {
      return;
    }

    this.loadingCurrent.set(true);

    this.marcadoresService
      .getCurrent()
      .pipe(
        finalize(() => this.loadingCurrent.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (response) => this.currentScoreboard.set(response),
        error: (error) =>
          this.errorMessage.set(
            this.readErrorMessage(error, 'No se pudo cargar el marcador actual.')
          )
      });
  }

  loadHouses(): void {
    if (!this.canUpdate() && !this.canAdjust()) {
      return;
    }

    this.loadingHouses.set(true);

    this.marcadoresService
      .getHouses()
      .pipe(
        finalize(() => this.loadingHouses.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (response) => {
          this.currentScoreboard.set(response);
          this.editableHouses.set(response.map((house) => ({ ...house, puntos: 0 })));

          if (this.ajusteIdCasa === null) {
            const firstVisible = response.find((house) => house.nombreCasa.trim().toLowerCase() !== 'id');
            this.ajusteIdCasa = firstVisible?.idCasa ?? response[0]?.idCasa ?? null;
          }
        },
        error: (error) =>
          this.errorMessage.set(this.readErrorMessage(error, 'No se pudo cargar la lista de casas.'))
      });
  }

  loadHistory(page = 1): void {
    if (!this.canViewHistory()) {
      return;
    }

    this.loadingHistory.set(true);

    this.marcadoresService
      .getHistory(page, 12)
      .pipe(
        finalize(() => this.loadingHistory.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (response) => this.history.set(response),
        error: (error) =>
          this.errorMessage.set(this.readErrorMessage(error, 'No se pudo cargar el historial.'))
      });
  }

  submitUpdate(): void {
    if (!this.canUpdate()) {
      return;
    }

    this.errorMessage.set('');
    this.successMessage.set('');
    this.submitting.set(true);

    this.marcadoresService
      .createUpdate({
        nombreDinamica: this.nombreDinamica.trim(),
        subtipoDinamica: this.subtipoDinamica,
        observacion: this.observacion.trim() || null,
        puntosPorCasa: this.editableHouses().map((house) => ({
          idCasa: house.idCasa,
          puntos: house.puntos ?? 0
        }))
      })
      .pipe(
        finalize(() => this.submitting.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (response) => this.applyUpdateResult(response),
        error: (error) =>
          this.errorMessage.set(
            this.readErrorMessage(error, 'No se pudo registrar la actualizacion del marcador.')
          )
      });
  }

  submitAdjustment(): void {
    if (!this.canAdjust()) {
      return;
    }

    this.errorMessage.set('');
    this.successMessage.set('');
    this.submittingAdjustment.set(true);

    this.marcadoresService
      .createAdjustment({
        idCasa: this.ajusteIdCasa ?? 0,
        puntos: this.ajustePuntos ?? 0,
        observacion: this.ajusteObservacion.trim()
      })
      .pipe(
        finalize(() => this.submittingAdjustment.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (response) => this.applyAdjustmentResult(response),
        error: (error) =>
          this.errorMessage.set(
            this.readErrorMessage(error, 'No se pudo registrar el ajuste de puntos.')
          )
      });
  }

  closeScoreboard(): void {
    if (!this.canAdjust()) {
      return;
    }

    this.closeConfirmOpen.set(true);
  }

  closeScoreboardModal(): void {
    this.closeConfirmOpen.set(false);
  }

  confirmCloseScoreboard(): void {
    if (!this.canAdjust()) {
      return;
    }

    this.errorMessage.set('');
    this.successMessage.set('');
    this.closingScoreboard.set(true);

    this.marcadoresService
      .closeScoreboard()
      .pipe(
        finalize(() => this.closingScoreboard.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (response) => {
          this.closeScoreboardModal();
          this.applyCloseResult(response);
        },
        error: (error) =>
          this.errorMessage.set(
            this.readErrorMessage(error, 'No se pudo cerrar el marcador actual.')
          )
      });
  }

  previousHistoryPage(): void {
    const currentPage = this.history()?.paginaActual ?? 1;
    if (currentPage > 1) {
      this.loadHistory(currentPage - 1);
    }
  }

  nextHistoryPage(): void {
    const result = this.history();
    if (result && result.paginaActual < result.totalPaginas) {
      this.loadHistory(result.paginaActual + 1);
    }
  }

  toneFor(house: MarcadorCasa): string {
    const source = `${house.nombreCasa} ${house.color}`.trim().toLowerCase();

    if (source.includes('gryffindor') || source.includes('rojo')) {
      return 'gryffindor';
    }

    if (source.includes('hufflepuff') || source.includes('amarillo')) {
      return 'hufflepuff';
    }

    if (source.includes('ravenclaw') || source.includes('azul')) {
      return 'ravenclaw';
    }

    if (source.includes('slytherin') || source.includes('verde')) {
      return 'slytherin';
    }

    return 'neutral';
  }

  private applyUpdateResult(response: MarcadorUpdateResult): void {
    this.successMessage.set(`Dinamica #${response.idDinamica} registrada correctamente.`);
    this.nombreDinamica = '';
    this.subtipoDinamica = 'Normal';
    this.observacion = '';
    this.currentScoreboard.set(response.marcadorActual);
    this.editableHouses.set(response.marcadorActual.map((house) => ({ ...house, puntos: 0 })));
  }

  private applyAdjustmentResult(response: MarcadorAdjustmentResult): void {
    this.successMessage.set(`Ajuste #${response.idDinamica} registrado correctamente.`);
    this.ajustePuntos = null;
    this.ajusteObservacion = '';
    this.currentScoreboard.set(response.marcadorActual);
    this.editableHouses.set(response.marcadorActual.map((house) => ({ ...house, puntos: 0 })));
  }

  private applyCloseResult(response: MarcadorCloseResult): void {
    this.successMessage.set(
      `Marcador cerrado correctamente. Se archivaron ${response.registrosGenerados} registros.`
    );
    this.currentScoreboard.set(response.marcadorActual);
    this.editableHouses.set(response.marcadorActual.map((house) => ({ ...house, puntos: 0 })));

    if (this.canViewHistory()) {
      this.loadHistory(1);
    }
  }

  private readErrorMessage(error: unknown, fallback: string): string {
    if (error instanceof HttpErrorResponse) {
      if (typeof error.error === 'string' && error.error.trim()) {
        return error.error;
      }

      if (error.error?.message) {
        return error.error.message as string;
      }
    }

    return fallback;
  }
}
