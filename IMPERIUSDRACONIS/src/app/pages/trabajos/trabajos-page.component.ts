import { CommonModule } from '@angular/common';
import { HttpErrorResponse } from '@angular/common/http';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { ChangeDetectionStrategy, Component, DestroyRef, computed, inject, signal } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { finalize } from 'rxjs';
import {
  TrabajoAlumnoAssignments,
  TrabajoCatalogs,
  TrabajoOption,
  TrabajoPermisoItem,
  TrabajoPermisos
} from '../../core/models/trabajos.models';
import { AuthService } from '../../core/services/auth.service';
import { TrabajosService } from '../../core/services/trabajos.service';

type TrabajoPanel = 'catalogo' | 'alumnos' | 'permisos';

@Component({
  selector: 'app-trabajos-page',
  imports: [CommonModule, FormsModule],
  templateUrl: './trabajos-page.component.html',
  styleUrl: './trabajos-page.component.css',
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class TrabajosPageComponent {
  private readonly destroyRef = inject(DestroyRef);

  readonly auth = inject(AuthService);
  readonly trabajosService = inject(TrabajosService);

  readonly activePanel = signal<TrabajoPanel>('catalogo');
  readonly catalogs = signal<TrabajoCatalogs | null>(null);
  readonly trabajos = signal<TrabajoOption[]>([]);
  readonly selectedTrabajo = signal<TrabajoOption | null>(null);
  readonly assignment = signal<TrabajoAlumnoAssignments | null>(null);
  readonly trabajoPermisos = signal<TrabajoPermisos | null>(null);
  readonly loadingCatalogs = signal(false);
  readonly loadingTrabajos = signal(false);
  readonly loadingAssignment = signal(false);
  readonly loadingTrabajoPermisos = signal(false);
  readonly saving = signal(false);
  readonly savingTrabajo = signal(false);
  readonly savingTrabajoPermisos = signal(false);
  readonly deletingTrabajoId = signal<number | null>(null);
  readonly errorMessage = signal('');
  readonly successMessage = signal('');
  readonly selectedCount = computed(
    () => this.assignment()?.trabajos.filter((item) => item.asignado).length ?? 0
  );
  readonly enabledTrabajoPermisosCount = computed(
    () => this.trabajoPermisos()?.permisos.filter((item) => item.tienePermiso).length ?? 0
  );

  readonly canView = computed(() =>
    this.auth.hasAnyPermission(['Trabajos:Index', 'Trabajos:AsignarAlumnos', 'Trabajos:AsignarPermisos', 'Permisos:Guardar'])
  );
  readonly canManageCatalog = computed(() =>
    this.auth.hasAnyPermission(['Trabajos:Crear', 'Trabajos:Editar', 'Trabajos:Eliminar', 'Permisos:Guardar'])
  );
  readonly canAssignAlumnos = computed(() =>
    this.auth.hasAnyPermission(['Trabajos:AsignarAlumnos', 'Permisos:Guardar'])
  );
  readonly canAssignPermisos = computed(() =>
    this.auth.hasAnyPermission(['Trabajos:AsignarPermisos', 'Permisos:Guardar'])
  );

  selectedAlumnoId: number | null = null;
  selectedTrabajoPermisosId: number | null = null;
  trabajoForm = this.createEmptyTrabajoForm();

  constructor() {
    if (this.canView()) {
      this.loadCatalogs();
      this.loadTrabajos();
    }
  }

  setActivePanel(panel: TrabajoPanel): void {
    this.activePanel.set(panel);

    if (panel === 'alumnos') {
      this.loadAssignments();
    }

    if (panel === 'permisos') {
      this.loadTrabajoPermisos();
    }
  }

  loadCatalogs(): void {
    this.loadingCatalogs.set(true);

    this.trabajosService
      .getCatalogs()
      .pipe(
        finalize(() => this.loadingCatalogs.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (response) => {
          this.catalogs.set(response);
          this.trabajos.set(response.trabajos);

          if (!this.selectedAlumnoId && response.alumnos.length > 0) {
            this.selectedAlumnoId = response.alumnos[0].id;
          }

          if (!this.selectedTrabajoPermisosId && response.trabajos.length > 0) {
            this.selectedTrabajoPermisosId = response.trabajos[0].idTrabajo;
          }
        },
        error: (error) =>
          this.errorMessage.set(this.readErrorMessage(error, 'No se pudieron cargar los catálogos.'))
      });
  }

  loadTrabajos(): void {
    this.loadingTrabajos.set(true);

    this.trabajosService
      .getAll()
      .pipe(
        finalize(() => this.loadingTrabajos.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (response) => this.trabajos.set(response),
        error: (error) =>
          this.errorMessage.set(this.readErrorMessage(error, 'No se pudo cargar el catálogo de trabajos.'))
      });
  }

  startCreateTrabajo(): void {
    this.selectedTrabajo.set(null);
    this.trabajoForm = this.createEmptyTrabajoForm();
  }

  startEditTrabajo(trabajo: TrabajoOption): void {
    this.selectedTrabajo.set(trabajo);
    this.trabajoForm = {
      nombre: trabajo.nombre,
      descripcion: trabajo.descripcion
    };
  }

  saveTrabajo(): void {
    if (!this.canManageCatalog()) {
      return;
    }

    const selected = this.selectedTrabajo();
    this.savingTrabajo.set(true);
    this.clearMessages();

    const request = {
      nombre: this.trabajoForm.nombre.trim(),
      descripcion: this.trabajoForm.descripcion.trim() || null
    };

    const operation = selected
      ? this.trabajosService.update(selected.idTrabajo, request)
      : this.trabajosService.create(request);

    operation
      .pipe(
        finalize(() => this.savingTrabajo.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (trabajo) => {
          this.successMessage.set(selected ? 'Trabajo actualizado correctamente.' : 'Trabajo creado correctamente.');
          this.selectedTrabajo.set(trabajo);
          this.trabajoForm = {
            nombre: trabajo.nombre,
            descripcion: trabajo.descripcion
          };
          this.loadCatalogs();
          this.loadTrabajos();
        },
        error: (error) => this.errorMessage.set(this.readErrorMessage(error, 'No se pudo guardar el trabajo.'))
      });
  }

  deleteTrabajo(trabajo: TrabajoOption): void {
    if (!this.canManageCatalog()) {
      return;
    }

    this.deletingTrabajoId.set(trabajo.idTrabajo);
    this.clearMessages();

    this.trabajosService
      .delete(trabajo.idTrabajo)
      .pipe(
        finalize(() => this.deletingTrabajoId.set(null)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: () => {
          this.successMessage.set('Trabajo eliminado correctamente.');
          if (this.selectedTrabajo()?.idTrabajo === trabajo.idTrabajo) {
            this.startCreateTrabajo();
          }
          this.loadCatalogs();
          this.loadTrabajos();
        },
        error: (error) => this.errorMessage.set(this.readErrorMessage(error, 'No se pudo eliminar el trabajo.'))
      });
  }

  loadAssignments(): void {
    if (!this.selectedAlumnoId || !this.canAssignAlumnos()) {
      return;
    }

    this.loadingAssignment.set(true);

    this.trabajosService
      .getAssignments(this.selectedAlumnoId)
      .pipe(
        finalize(() => this.loadingAssignment.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (response) => this.assignment.set(response),
        error: (error) =>
          this.errorMessage.set(this.readErrorMessage(error, 'No se pudo cargar la asignación del alumno.'))
      });
  }

  toggleTrabajo(idTrabajo: number, checked: boolean): void {
    const current = this.assignment();
    if (!current) {
      return;
    }

    this.assignment.set({
      ...current,
      trabajos: current.trabajos.map((trabajo) =>
        trabajo.idTrabajo === idTrabajo ? { ...trabajo, asignado: checked } : trabajo
      )
    });
  }

  saveAssignments(): void {
    const current = this.assignment();
    if (!current || !this.canAssignAlumnos()) {
      return;
    }

    this.saving.set(true);
    this.clearMessages();

    this.trabajosService
      .updateAssignments(current.idAlumno, {
        idsTrabajo: current.trabajos.filter((item) => item.asignado).map((item) => item.idTrabajo)
      })
      .pipe(
        finalize(() => this.saving.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (response) => {
          this.assignment.set(response);
          this.successMessage.set('Trabajos del alumno actualizados correctamente.');
          this.auth.hydrateSession().pipe(takeUntilDestroyed(this.destroyRef)).subscribe();
        },
        error: (error) =>
          this.errorMessage.set(this.readErrorMessage(error, 'No se pudieron guardar las asignaciones.'))
      });
  }

  loadTrabajoPermisos(): void {
    if (!this.selectedTrabajoPermisosId || !this.canAssignPermisos()) {
      return;
    }

    this.loadingTrabajoPermisos.set(true);

    this.trabajosService
      .getPermissions(this.selectedTrabajoPermisosId)
      .pipe(
        finalize(() => this.loadingTrabajoPermisos.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (response) => this.trabajoPermisos.set(response),
        error: (error) =>
          this.errorMessage.set(this.readErrorMessage(error, 'No se pudieron cargar los permisos del trabajo.'))
      });
  }

  toggleTrabajoPermiso(item: TrabajoPermisoItem, value: boolean): void {
    const current = this.trabajoPermisos();
    if (!current) {
      return;
    }

    this.trabajoPermisos.set({
      ...current,
      permisos: current.permisos.map((permiso) =>
        permiso.controlador === item.controlador && permiso.accion === item.accion
          ? { ...permiso, tienePermiso: value }
          : permiso
      )
    });
  }

  saveTrabajoPermisos(): void {
    const current = this.trabajoPermisos();
    if (!current || !this.canAssignPermisos()) {
      return;
    }

    this.savingTrabajoPermisos.set(true);
    this.clearMessages();

    this.trabajosService
      .updatePermissions(current.idTrabajo, {
        permisos: current.permisos.map((item) => ({
          controlador: item.controlador,
          accion: item.accion,
          tienePermiso: item.tienePermiso
        }))
      })
      .pipe(
        finalize(() => this.savingTrabajoPermisos.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (response) => {
          this.trabajoPermisos.set(response);
          this.successMessage.set('Permisos del trabajo actualizados correctamente.');
          this.auth.hydrateSession().pipe(takeUntilDestroyed(this.destroyRef)).subscribe();
        },
        error: (error) =>
          this.errorMessage.set(this.readErrorMessage(error, 'No se pudieron guardar los permisos del trabajo.'))
      });
  }

  private createEmptyTrabajoForm(): { nombre: string; descripcion: string } {
    return {
      nombre: '',
      descripcion: ''
    };
  }

  private clearMessages(): void {
    this.successMessage.set('');
    this.errorMessage.set('');
  }

  private readErrorMessage(error: unknown, fallback: string): string {
    if (error instanceof HttpErrorResponse && typeof error.error?.message === 'string') {
      return error.error.message;
    }

    return fallback;
  }
}
