import { CommonModule } from '@angular/common';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import {
  ChangeDetectionStrategy,
  ChangeDetectorRef,
  Component,
  DestroyRef,
  inject,
  signal
} from '@angular/core';
import { FormsModule } from '@angular/forms';
import { CumpleanosItem } from '../../core/models/alumnos.models';
import { AlumnosService } from '../../core/services/alumnos.service';
import { AuthService } from '../../core/services/auth.service';
import { RuntimeConfigService } from '../../core/services/runtime-config.service';
import { resolveProfileAvatarUrl } from '../../core/constants/profile.constants';
import { ImageFallbackDirective } from '../../shared/directives/image-fallback.directive';

@Component({
  selector: 'app-cumpleanos-page',
  imports: [CommonModule, FormsModule, ImageFallbackDirective],
  templateUrl: './cumpleanos-page.component.html',
  styleUrl: './cumpleanos-page.component.css',
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class CumpleanosPageComponent {
  private readonly destroyRef = inject(DestroyRef);
  private readonly changeDetectorRef = inject(ChangeDetectorRef);
  private readonly alumnosService = inject(AlumnosService);
  readonly auth = inject(AuthService);
  readonly runtimeConfig = inject(RuntimeConfigService);

  readonly meses = [
    { value: 1,  label: 'Enero' },
    { value: 2,  label: 'Febrero' },
    { value: 3,  label: 'Marzo' },
    { value: 4,  label: 'Abril' },
    { value: 5,  label: 'Mayo' },
    { value: 6,  label: 'Junio' },
    { value: 7,  label: 'Julio' },
    { value: 8,  label: 'Agosto' },
    { value: 9,  label: 'Septiembre' },
    { value: 10, label: 'Octubre' },
    { value: 11, label: 'Noviembre' },
    { value: 12, label: 'Diciembre' }
  ] as const;

  mesSeleccionado: number | null = null;
  items = signal<CumpleanosItem[]>([]);
  loading = signal(false);
  error = signal<string | null>(null);

  constructor() {
    // Cargar todos los cumpleaños al inicio
    this.load();
  }

  load(): void {
    this.loading.set(true);
    this.error.set(null);

    const mes = this.mesSeleccionado ?? undefined;
    this.alumnosService
      .getCumpleanos(mes)
      .pipe(takeUntilDestroyed(this.destroyRef))
      .subscribe({
        next: (data) => {
          this.items.set(data);
          this.loading.set(false);
          this.changeDetectorRef.markForCheck();
        },
        error: () => {
          this.error.set('No se pudieron cargar los cumpleaños. Intenta de nuevo.');
          this.loading.set(false);
          this.changeDetectorRef.markForCheck();
        }
      });
  }

  onMesChange(): void {
    this.load();
  }

  limpiarFiltro(): void {
    this.mesSeleccionado = null;
    this.load();
  }

  /** Formatea el día y mes como "DD/MM" sin mostrar el año. */
  formatFecha(dia: number, mes: number): string {
    return `${String(dia).padStart(2, '0')}/${String(mes).padStart(2, '0')}`;
  }

  getNombreMes(mes: number): string {
    return this.meses.find(m => m.value === mes)?.label ?? '';
  }

  /** Agrupa los items por mes para la vista agrupada. */
  get itemsPorMes(): { mes: number; label: string; items: CumpleanosItem[] }[] {
    const grupos = new Map<number, CumpleanosItem[]>();
    for (const item of this.items()) {
      const lista = grupos.get(item.mes) ?? [];
      lista.push(item);
      grupos.set(item.mes, lista);
    }
    return Array.from(grupos.entries())
      .sort(([a], [b]) => a - b)
      .map(([mes, items]) => ({ mes, label: this.getNombreMes(mes), items }));
  }

  avatarUrl(path: string | null | undefined): string {
    return resolveProfileAvatarUrl(path, this.runtimeConfig);
  }

  hasPermission(permission: string): boolean {
    return this.auth.hasPermission(permission);
  }
}
