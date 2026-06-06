import { CommonModule } from '@angular/common';
import { HttpErrorResponse } from '@angular/common/http';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { ChangeDetectionStrategy, Component, DestroyRef, computed, inject, signal } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { finalize } from 'rxjs';
import {
  ChangeMascotaStateRequest,
  MascotaAssignment,
  MascotaCatalogItem,
  MascotaFormCatalogs,
  MascotaMatrixRow,
  MascotaSummary,
  MascotaWeeklyChargeCandidate,
  SaveMascotaAssignmentRequest
} from '../../core/models/mascotas.models';
import { AuthService } from '../../core/services/auth.service';
import { MascotasService } from '../../core/services/mascotas.service';

type FormMode = 'hidden' | 'create' | 'edit';
type MascotasPanel = 'asignaciones' | 'catalogo' | 'cobro' | 'matriz';

interface SelectableWeeklyChargeCandidate extends MascotaWeeklyChargeCandidate {
  seleccionado: boolean;
}

interface AssignmentFormModel {
  idAlumno: number | null;
  idMascota: number | null;
  estado: string;
  fechaCompra: string;
  fechaUltimoPago: string;
  subsidiadaPor: string;
  observaciones: string;
}

interface StateFormModel {
  nuevoEstado: string;
  subsidiadaPor: string;
  observaciones: string;
}

@Component({
  selector: 'app-mascotas-page',
  imports: [CommonModule, FormsModule],
  templateUrl: './mascotas-page.component.html',
  styleUrl: './mascotas-page.component.css',
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class MascotasPageComponent {
  private readonly destroyRef = inject(DestroyRef);

  readonly auth = inject(AuthService);
  readonly mascotasService = inject(MascotasService);

  readonly summary = signal<MascotaSummary | null>(null);
  readonly catalog = signal<MascotaCatalogItem[]>([]);
  readonly formCatalogs = signal<MascotaFormCatalogs | null>(null);
  readonly assignments = signal<MascotaAssignment[]>([]);
  readonly selectedAssignment = signal<MascotaAssignment | null>(null);
  readonly weeklyChargeCandidates = signal<SelectableWeeklyChargeCandidate[]>([]);
  readonly matrixRows = signal<MascotaMatrixRow[]>([]);
  readonly formMode = signal<FormMode>('hidden');
  readonly loadingSummary = signal(false);
  readonly loadingCatalog = signal(false);
  readonly loadingFormCatalogs = signal(false);
  readonly loadingAssignments = signal(false);
  readonly loadingSelection = signal(false);
  readonly loadingWeeklyCharges = signal(false);
  readonly loadingMatrix = signal(false);
  readonly savingAssignment = signal(false);
  readonly updatingState = signal(false);
  readonly deletingAssignment = signal(false);
  readonly processingWeeklyCharges = signal(false);
  readonly errorMessage = signal('');
  readonly successMessage = signal('');
  readonly activePanel = signal<MascotasPanel>('matriz');
  readonly deleteConfirmOpen = signal(false);

  readonly canViewSummary = computed(() => this.auth.hasPermission('Mascotas:Index'));
  readonly canViewCatalog = computed(() => this.auth.hasPermission('Mascotas:Catalogo'));
  readonly canViewAssignments = computed(() =>
    this.auth.hasAnyPermission([
      'Mascotas:Index',
      'Mascotas:EstadoPorAlumno',
      'Mascotas:MascotasPorAlumno',
      'Mascotas:AgregarMascotaPorAlumno',
      'Mascotas:EditarMascotaPorAlumno',
      'Mascotas:EliminarMascotaPorAlumno',
      'Mascotas:CambiarEstado'
    ])
  );
  readonly canCreateAssignment = computed(() => this.auth.hasPermission('Mascotas:AgregarMascotaPorAlumno'));
  readonly canEditAssignment = computed(() => this.auth.hasPermission('Mascotas:EditarMascotaPorAlumno'));
  readonly canDeleteAssignment = computed(() => this.auth.hasPermission('Mascotas:EliminarMascotaPorAlumno'));
  readonly canChangeState = computed(() => this.auth.hasPermission('Mascotas:CambiarEstado'));
  readonly canViewWeeklyCharges = computed(() =>
    this.auth.hasAnyPermission(['Mascotas:CobroSemanal', 'Mascotas:ProcesarCobro'])
  );
  readonly canProcessWeeklyCharges = computed(() =>
    this.auth.hasAnyPermission(['Mascotas:ProcesarCobro', 'Mascotas:CobroSemanal'])
  );
  readonly canViewMatrix = computed(() =>
    this.auth.hasAnyPermission([
      'Mascotas:Index',
      'Mascotas:EstadoPorAlumno',
      'Mascotas:MascotasPorAlumno',
      'Mascotas:CambiarEstado'
    ])
  );
  readonly canUseFormCatalogs = computed(
    () => this.canCreateAssignment() || this.canEditAssignment() || this.canChangeState()
  );
  readonly canOpenWorkbench = computed(
    () =>
      this.canCreateAssignment() ||
      this.canEditAssignment() ||
      this.canDeleteAssignment() ||
      this.canChangeState()
  );
  readonly canViewModule = computed(
    () =>
      this.canViewSummary() ||
      this.canViewCatalog() ||
      this.canViewAssignments() ||
      this.canViewWeeklyCharges() ||
      this.canViewMatrix()
  );
  readonly selectedWeeklyChargeIds = computed(() =>
    this.weeklyChargeCandidates()
      .filter((candidate) => candidate.seleccionado)
      .map((candidate) => candidate.idMascotaAlumno)
  );
  readonly totalSelectedWeeklyChargeAmount = computed(() =>
    this.weeklyChargeCandidates()
      .filter((candidate) => candidate.seleccionado)
      .reduce((total, candidate) => total + candidate.precioMantenimiento, 0)
  );
  readonly assignmentCount = computed(
    () => this.summary()?.totalAsignaciones ?? this.assignments().length
  );
  readonly dueCount = computed(
    () => this.summary()?.totalPendientesCobro ?? this.weeklyChargeCandidates().length
  );
  readonly activeCatalogCount = computed(
    () => this.catalog().filter((item) => item.activo).length || this.formCatalogs()?.mascotas.length || 0
  );

  filtroEstado: 'todas' | 'vigente' | 'no activa' | 'congelada' | 'subsidiada' = 'todas';
  busqueda = '';
  soloPendientesCobro = false;

  assignmentForm: AssignmentFormModel = this.createEmptyAssignmentForm();
  stateForm: StateFormModel = this.createEmptyStateForm();

  constructor() {
    if (!this.canViewModule()) {
      return;
    }

    this.activePanel.set(this.initialPanel());

    if (this.canViewSummary()) {
      this.loadSummary();
    }

    if (this.canViewCatalog()) {
      this.loadCatalog();
    }

    if (this.canUseFormCatalogs()) {
      this.loadFormCatalogs();
    }

    if (this.canViewAssignments()) {
      this.loadAssignments();
    }

    if (this.canViewWeeklyCharges()) {
      this.loadWeeklyChargeCandidates();
    }

    if (this.canViewMatrix()) {
      this.loadMatrix();
    }
  }

  loadSummary(): void {
    if (!this.canViewSummary()) {
      return;
    }

    this.loadingSummary.set(true);

    this.mascotasService
      .getSummary()
      .pipe(
        finalize(() => this.loadingSummary.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (response) => this.summary.set(response),
        error: (error) =>
          this.errorMessage.set(this.readErrorMessage(error, 'No se pudo cargar el resumen de mascotas.'))
      });
  }

  loadCatalog(): void {
    if (!this.canViewCatalog()) {
      return;
    }

    this.loadingCatalog.set(true);

    this.mascotasService
      .getCatalog()
      .pipe(
        finalize(() => this.loadingCatalog.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (response) => this.catalog.set(response),
        error: (error) =>
          this.errorMessage.set(this.readErrorMessage(error, 'No se pudo cargar el catálogo de mascotas.'))
      });
  }

  loadFormCatalogs(): void {
    if (!this.canUseFormCatalogs()) {
      return;
    }

    this.loadingFormCatalogs.set(true);

    this.mascotasService
      .getFormCatalogs()
      .pipe(
        finalize(() => this.loadingFormCatalogs.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (response) => {
          this.formCatalogs.set(response);

          if (this.formMode() === 'hidden' && this.canCreateAssignment()) {
            this.resetAssignmentForm();
          }

          if (this.selectedAssignment()) {
            this.syncStateForm(this.selectedAssignment());
          }
        },
        error: (error) =>
          this.errorMessage.set(
            this.readErrorMessage(error, 'No se pudieron cargar los catálogos del formulario.')
          )
      });
  }

  loadAssignments(): void {
    if (!this.canViewAssignments()) {
      return;
    }

    this.loadingAssignments.set(true);

    this.mascotasService
      .getAssignments({
        filtroEstado: this.filtroEstado,
        busqueda: this.busqueda,
        soloPendientesCobro: this.soloPendientesCobro
      })
      .pipe(
        finalize(() => this.loadingAssignments.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (response) => {
          this.assignments.set(response);

          const selectedId = this.selectedAssignment()?.idMascotaAlumno;
          if (selectedId && !response.some((item) => item.idMascotaAlumno === selectedId)) {
            this.selectedAssignment.set(null);
          }
        },
        error: (error) =>
          this.errorMessage.set(this.readErrorMessage(error, 'No se pudieron cargar las asignaciones.'))
      });
  }

  loadSelectedAssignment(idMascotaAlumno: number): void {
    this.loadingSelection.set(true);

    this.mascotasService
      .getAssignmentById(idMascotaAlumno)
      .pipe(
        finalize(() => this.loadingSelection.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (response) => {
          this.selectedAssignment.set(response);
          this.syncStateForm(response);

          if (this.formMode() === 'edit') {
            this.patchAssignmentForm(response);
          }
        },
        error: (error) =>
          this.errorMessage.set(this.readErrorMessage(error, 'No se pudo cargar la asignación seleccionada.'))
      });
  }

  loadWeeklyChargeCandidates(): void {
    if (!this.canViewWeeklyCharges()) {
      return;
    }

    this.loadingWeeklyCharges.set(true);

    this.mascotasService
      .getWeeklyChargeCandidates()
      .pipe(
        finalize(() => this.loadingWeeklyCharges.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (response) =>
          this.weeklyChargeCandidates.set(response.map((candidate) => ({ ...candidate, seleccionado: false }))),
        error: (error) =>
          this.errorMessage.set(
            this.readErrorMessage(error, 'No se pudo cargar la bandeja de cobro semanal.')
          )
      });
  }

  loadMatrix(): void {
    if (!this.canViewMatrix()) {
      return;
    }

    this.loadingMatrix.set(true);

    this.mascotasService
      .getMatrix()
      .pipe(
        finalize(() => this.loadingMatrix.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (response) => this.matrixRows.set(response),
        error: (error) =>
          this.errorMessage.set(this.readErrorMessage(error, 'No se pudo cargar la matriz de mascotas.'))
      });
  }

  applyFilters(): void {
    this.loadAssignments();
  }

  resetFilters(): void {
    this.filtroEstado = 'todas';
    this.busqueda = '';
    this.soloPendientesCobro = false;
    this.loadAssignments();
  }

  setActivePanel(panel: MascotasPanel): void {
    this.activePanel.set(panel);
  }

  selectAssignment(assignment: MascotaAssignment): void {
    this.formMode.set('hidden');
    this.loadSelectedAssignment(assignment.idMascotaAlumno);
  }

  startCreateAssignment(): void {
    this.formMode.set('create');
    this.resetAssignmentForm();
  }

  startEditAssignment(): void {
    const assignment = this.selectedAssignment();
    if (!assignment) {
      return;
    }

    this.formMode.set('edit');
    this.patchAssignmentForm(assignment);
  }

  cancelAssignmentForm(): void {
    this.formMode.set('hidden');
    this.assignmentForm = this.createEmptyAssignmentForm();
  }

  saveAssignment(): void {
    if (this.formMode() === 'hidden') {
      return;
    }

    if (this.formMode() === 'create' && !this.canCreateAssignment()) {
      return;
    }

    if (this.formMode() === 'edit' && !this.canEditAssignment()) {
      return;
    }

    const payload = this.buildAssignmentPayload();
    if (!payload) {
      return;
    }

    this.errorMessage.set('');
    this.successMessage.set('');
    this.savingAssignment.set(true);

    if (this.formMode() === 'edit' && this.selectedAssignment()) {
      this.mascotasService
        .updateAssignment(this.selectedAssignment()!.idMascotaAlumno, payload)
        .pipe(
          finalize(() => this.savingAssignment.set(false)),
          takeUntilDestroyed(this.destroyRef)
        )
        .subscribe({
          next: () => {
            this.successMessage.set('Asignación actualizada correctamente.');
            this.formMode.set('hidden');
            this.resetAssignmentForm();
            this.refreshDataAfterMutation(this.selectedAssignment()?.idMascotaAlumno ?? null);
          },
          error: (error) =>
            this.errorMessage.set(this.readErrorMessage(error, 'No se pudo guardar la asignación.'))
        });

      return;
    }

    this.mascotasService
      .createAssignment(payload)
      .pipe(
        finalize(() => this.savingAssignment.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (response) => {
          this.successMessage.set('Mascota asignada correctamente.');
          this.formMode.set('hidden');
          this.resetAssignmentForm();
          this.refreshDataAfterMutation(response.idMascotaAlumno);
        },
        error: (error) =>
          this.errorMessage.set(this.readErrorMessage(error, 'No se pudo guardar la asignación.'))
      });
  }

  saveStateChange(): void {
    const assignment = this.selectedAssignment();
    if (!assignment || !this.canChangeState()) {
      return;
    }

    const payload: ChangeMascotaStateRequest = {
      nuevoEstado: this.stateForm.nuevoEstado.trim(),
      subsidiadaPor: this.normalizeOptional(this.stateForm.subsidiadaPor),
      observaciones: this.normalizeOptional(this.stateForm.observaciones)
    };

    if (!payload.nuevoEstado) {
      this.errorMessage.set('Debes indicar el nuevo estado.');
      return;
    }

    this.errorMessage.set('');
    this.successMessage.set('');
    this.updatingState.set(true);

    this.mascotasService
      .changeState(assignment.idMascotaAlumno, payload)
      .pipe(
        finalize(() => this.updatingState.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (response) => {
          this.selectedAssignment.set(response);
          this.syncStateForm(response);
          this.successMessage.set('Estado actualizado correctamente.');
          this.refreshDataAfterMutation(response.idMascotaAlumno, { reloadSelection: false });
        },
        error: (error) =>
          this.errorMessage.set(this.readErrorMessage(error, 'No se pudo actualizar el estado.'))
      });
  }

  deleteSelectedAssignment(): void {
    const assignment = this.selectedAssignment();
    if (!assignment || !this.canDeleteAssignment()) {
      return;
    }

    this.deleteConfirmOpen.set(true);
  }

  closeDeleteConfirm(): void {
    this.deleteConfirmOpen.set(false);
  }

  closeAssignmentModal(): void {
    this.selectedAssignment.set(null);
    this.formMode.set('hidden');
    this.resetAssignmentForm();
    this.closeDeleteConfirm();
  }

  confirmDeleteSelectedAssignment(): void {
    const assignment = this.selectedAssignment();
    if (!assignment || !this.canDeleteAssignment()) {
      return;
    }

    this.errorMessage.set('');
    this.successMessage.set('');
    this.deletingAssignment.set(true);

    this.mascotasService
      .deleteAssignment(assignment.idMascotaAlumno)
      .pipe(
        finalize(() => this.deletingAssignment.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: () => {
          this.selectedAssignment.set(null);
          this.formMode.set('hidden');
          this.closeDeleteConfirm();
          this.resetAssignmentForm();
          this.successMessage.set('Asignación eliminada correctamente.');
          this.refreshDataAfterMutation(null, { reloadSelection: false });
        },
        error: (error) =>
          this.errorMessage.set(this.readErrorMessage(error, 'No se pudo eliminar la asignación.'))
      });
  }

  setWeeklyChargeSelection(idMascotaAlumno: number, seleccionado: boolean): void {
    this.weeklyChargeCandidates.set(
      this.weeklyChargeCandidates().map((candidate) =>
        candidate.idMascotaAlumno === idMascotaAlumno ? { ...candidate, seleccionado } : candidate
      )
    );
  }

  selectAllWeeklyCharges(): void {
    this.weeklyChargeCandidates.set(
      this.weeklyChargeCandidates().map((candidate) => ({ ...candidate, seleccionado: true }))
    );
  }

  clearWeeklyChargeSelection(): void {
    this.weeklyChargeCandidates.set(
      this.weeklyChargeCandidates().map((candidate) => ({ ...candidate, seleccionado: false }))
    );
  }

  processWeeklyCharges(): void {
    if (!this.canProcessWeeklyCharges()) {
      return;
    }

    if (this.selectedWeeklyChargeIds().length === 0) {
      this.errorMessage.set('Selecciona al menos una mascota para cobrar.');
      return;
    }

    this.errorMessage.set('');
    this.successMessage.set('');
    this.processingWeeklyCharges.set(true);

    this.mascotasService
      .processWeeklyCharges({ idsSeleccionados: this.selectedWeeklyChargeIds() })
      .pipe(
        finalize(() => this.processingWeeklyCharges.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (response) => {
          const rejectedSuffix = response.alumnosRechazados.length
            ? ` Rechazadas: ${response.alumnosRechazados.join(', ')}.`
            : '';

          this.successMessage.set(
            `Cobro semanal procesado. Exitosas: ${response.totalProcesadas}. Rechazadas: ${response.totalRechazadas}.${rejectedSuffix}`.trim()
          );

          this.clearWeeklyChargeSelection();
          this.refreshDataAfterMutation(this.selectedAssignment()?.idMascotaAlumno ?? null);
          this.auth.hydrateSession().pipe(takeUntilDestroyed(this.destroyRef)).subscribe();
        },
        error: (error) =>
          this.errorMessage.set(
            this.readErrorMessage(error, 'No se pudo procesar el cobro semanal.')
          )
      });
  }

  stateTone(state: string | null | undefined): string {
    const normalized = (state ?? '').trim().toLowerCase();

    if (normalized === 'suscrita') {
      return 'state-success';
    }

    if (normalized === 'subsidiada') {
      return 'state-info';
    }

    if (normalized === 'congelada') {
      return 'state-neutral';
    }

    if (normalized === 'no activa' || normalized === 'en libertad') {
      return 'state-warn';
    }

    return '';
  }

  private refreshDataAfterMutation(
    selectedId: number | null,
    options: { reloadSelection?: boolean } = {}
  ): void {
    if (this.canViewSummary()) {
      this.loadSummary();
    }

    if (this.canViewAssignments()) {
      this.loadAssignments();
    }

    if (this.canViewWeeklyCharges()) {
      this.loadWeeklyChargeCandidates();
    }

    if (this.canViewMatrix()) {
      this.loadMatrix();
    }

    if (options.reloadSelection !== false && selectedId) {
      this.loadSelectedAssignment(selectedId);
    }
  }

  private initialPanel(): MascotasPanel {
    if (this.canViewMatrix()) {
      return 'matriz';
    }

    if (this.canViewAssignments()) {
      return 'asignaciones';
    }

    if (this.canViewCatalog()) {
      return 'catalogo';
    }

    return 'cobro';
  }

  private buildAssignmentPayload(): SaveMascotaAssignmentRequest | null {
    if (!this.assignmentForm.idAlumno || !this.assignmentForm.idMascota) {
      this.errorMessage.set('Debes seleccionar un alumno y una mascota.');
      return null;
    }

    if (!this.assignmentForm.estado.trim()) {
      this.errorMessage.set('Debes indicar un estado.');
      return null;
    }

    if (!this.assignmentForm.fechaCompra) {
      this.errorMessage.set('Debes indicar la fecha de compra.');
      return null;
    }

    return {
      idAlumno: this.assignmentForm.idAlumno,
      idMascota: this.assignmentForm.idMascota,
      estado: this.assignmentForm.estado.trim(),
      fechaCompra: this.assignmentForm.fechaCompra,
      fechaUltimoPago: this.assignmentForm.fechaUltimoPago || null,
      subsidiadaPor: this.normalizeOptional(this.assignmentForm.subsidiadaPor),
      observaciones: this.normalizeOptional(this.assignmentForm.observaciones)
    };
  }

  private resetAssignmentForm(): void {
    const catalogs = this.formCatalogs();
    this.assignmentForm = {
      idAlumno: catalogs?.alumnos[0]?.idAlumno ?? null,
      idMascota: catalogs?.mascotas[0]?.idMascota ?? null,
      estado: catalogs?.estados[0] ?? 'Suscrita',
      fechaCompra: this.today(),
      fechaUltimoPago: '',
      subsidiadaPor: '',
      observaciones: ''
    };
  }

  private patchAssignmentForm(assignment: MascotaAssignment): void {
    this.assignmentForm = {
      idAlumno: assignment.idAlumno,
      idMascota: assignment.idMascota,
      estado: assignment.estado,
      fechaCompra: this.toDateInput(assignment.fechaCompra),
      fechaUltimoPago: this.toDateInput(assignment.fechaUltimoPago),
      subsidiadaPor: assignment.subsidiadaPor ?? '',
      observaciones: assignment.observaciones ?? ''
    };
  }

  private syncStateForm(assignment: MascotaAssignment | null): void {
    if (!assignment) {
      this.stateForm = this.createEmptyStateForm();
      return;
    }

    this.stateForm = {
      nuevoEstado: assignment.estado,
      subsidiadaPor: assignment.subsidiadaPor ?? '',
      observaciones: assignment.observaciones ?? ''
    };
  }

  private createEmptyAssignmentForm(): AssignmentFormModel {
    return {
      idAlumno: null,
      idMascota: null,
      estado: 'Suscrita',
      fechaCompra: this.today(),
      fechaUltimoPago: '',
      subsidiadaPor: '',
      observaciones: ''
    };
  }

  private createEmptyStateForm(): StateFormModel {
    return {
      nuevoEstado: 'Suscrita',
      subsidiadaPor: '',
      observaciones: ''
    };
  }

  private today(): string {
    return new Date().toISOString().slice(0, 10);
  }

  private toDateInput(value: string | null | undefined): string {
    return value ? value.slice(0, 10) : '';
  }

  private normalizeOptional(value: string): string | null {
    const normalized = value.trim();
    return normalized ? normalized : null;
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
