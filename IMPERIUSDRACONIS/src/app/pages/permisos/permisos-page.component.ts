import { CommonModule } from '@angular/common';
import { HttpErrorResponse } from '@angular/common/http';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { ChangeDetectionStrategy, Component, DestroyRef, computed, inject, signal } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { finalize } from 'rxjs';
import { CargoOption, PermisoCargo, PermisoDetalle } from '../../core/models/permisos.models';
import { AuthService } from '../../core/services/auth.service';
import { PermisosService } from '../../core/services/permisos.service';

@Component({
  selector: 'app-permisos-page',
  imports: [CommonModule, FormsModule],
  templateUrl: './permisos-page.component.html',
  styleUrl: './permisos-page.component.css',
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class PermisosPageComponent {
  private readonly destroyRef = inject(DestroyRef);

  readonly auth = inject(AuthService);
  readonly permisosService = inject(PermisosService);

  readonly canView = computed(() =>
    this.auth.hasAnyPermission(['Permisos:Index', 'Permisos:Guardar'])
  );
  readonly canSave = computed(() => this.auth.hasPermission('Permisos:Guardar'));
  readonly cargos = signal<CargoOption[]>([]);
  readonly cargo = signal<PermisoCargo | null>(null);
  readonly loadingCargos = signal(false);
  readonly loadingCargo = signal(false);
  readonly saving = signal(false);
  readonly creating = signal(false);
  readonly errorMessage = signal('');
  readonly successMessage = signal('');
  readonly enabledCount = computed(
    () => this.cargo()?.permisos.filter((item) => item.tienePermiso).length ?? 0
  );

  selectedCargoId: number | null = null;
  nuevoControlador = '';
  nuevaAccion = '';

  constructor() {
    if (this.canView()) {
      this.loadCargos();
    }
  }

  loadCargos(): void {
    this.loadingCargos.set(true);

    this.permisosService
      .getCargos()
      .pipe(
        finalize(() => this.loadingCargos.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (response) => {
          this.cargos.set(response);
          if (!this.selectedCargoId && response.length > 0) {
            this.selectedCargoId = response[0].id;
            this.loadCargo();
          }
        },
        error: (error) =>
          this.errorMessage.set(this.readErrorMessage(error, 'No se pudo cargar el catálogo de cargos.'))
      });
  }

  loadCargo(): void {
    if (!this.selectedCargoId) {
      return;
    }

    this.loadingCargo.set(true);

    this.permisosService
      .getByCargo(this.selectedCargoId)
      .pipe(
        finalize(() => this.loadingCargo.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (response) => this.cargo.set(response),
        error: (error) =>
          this.errorMessage.set(this.readErrorMessage(error, 'No se pudieron cargar los permisos del cargo.'))
      });
  }

  togglePermiso(item: PermisoDetalle, value: boolean): void {
    const current = this.cargo();
    if (!current) {
      return;
    }

    this.cargo.set({
      ...current,
      permisos: current.permisos.map((permiso) =>
        permiso.idPermiso === item.idPermiso ? { ...permiso, tienePermiso: value } : permiso
      )
    });
  }

  save(): void {
    const current = this.cargo();
    if (!current || !this.canSave()) {
      return;
    }

    this.saving.set(true);
    this.errorMessage.set('');
    this.successMessage.set('');

    this.permisosService
      .update(current.idCargo, {
        permisos: current.permisos.map((item) => ({
          idPermiso: item.idPermiso,
          tienePermiso: item.tienePermiso
        }))
      })
      .pipe(
        finalize(() => this.saving.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (response) => {
          this.cargo.set(response);
          this.successMessage.set('Permisos actualizados correctamente.');
          this.auth.hydrateSession().pipe(takeUntilDestroyed(this.destroyRef)).subscribe();
        },
        error: (error) =>
          this.errorMessage.set(this.readErrorMessage(error, 'No se pudieron guardar los cambios.'))
      });
  }

  createPermiso(): void {
    if (!this.canSave()) {
      return;
    }

    this.creating.set(true);
    this.errorMessage.set('');
    this.successMessage.set('');

    this.permisosService
      .create({
        controlador: this.nuevoControlador.trim(),
        accion: this.nuevaAccion.trim()
      })
      .pipe(
        finalize(() => this.creating.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: () => {
          this.successMessage.set('Permiso creado correctamente. Quedó apagado por defecto para cargos y trabajos.');
          this.nuevoControlador = '';
          this.nuevaAccion = '';
          this.loadCargo();
          this.auth.hydrateSession().pipe(takeUntilDestroyed(this.destroyRef)).subscribe();
        },
        error: (error) =>
          this.errorMessage.set(this.readErrorMessage(error, 'No se pudo crear el permiso.'))
      });
  }

  private readErrorMessage(error: unknown, fallback: string): string {
    if (error instanceof HttpErrorResponse && typeof error.error?.message === 'string') {
      return error.error.message;
    }

    return fallback;
  }
}
