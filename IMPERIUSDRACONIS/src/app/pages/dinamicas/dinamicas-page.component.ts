import { CommonModule } from '@angular/common';
import { HttpErrorResponse } from '@angular/common/http';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { ChangeDetectionStrategy, Component, DestroyRef, computed, inject, signal } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { finalize } from 'rxjs';
import { PagedResult } from '../../core/models/alumnos.models';
import {
  AgendaDinamica,
  AgendaResponsable,
  AlumnoActivo,
  AutomaticPointsAnalysis,
  DinamicaDracoinsDetail,
  DinamicaListItem,
  DinamicaPuntosDetail
} from '../../core/models/dinamicas.models';
import { AuthService } from '../../core/services/auth.service';
import { DinamicasService } from '../../core/services/dinamicas.service';
import { MarcadorCasa } from '../../core/models/marcadores.models';
import { MarcadoresService } from '../../core/services/marcadores.service';

const DINAMICAS_REGISTRAR_DRACOINS_PERMISSION = 'Dinamicas:RegistrarDin\u00E1micaPorDracoins';

interface AssignableAlumno extends AlumnoActivo {
  seleccionado: boolean;
  dracoinsOtorgados: number | null;
}

interface AgendaDraftRow {
  hora: string;
  idAlumno: number | null;
  titulo: string;
}

interface EditablePointsHouse extends MarcadorCasa {
  puntos: number;
}

type DinamicasSection = 'listado' | 'registrar' | 'puntos' | 'agenda';
type PointsRegistrationMode = 'manual' | 'automatic';
type AgendaModalMode = 'create' | 'edit' | null;

@Component({
  selector: 'app-dinamicas-page',
  imports: [CommonModule, FormsModule],
  templateUrl: './dinamicas-page.component.html',
  styleUrl: './dinamicas-page.component.css',
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class DinamicasPageComponent {
  private readonly destroyRef = inject(DestroyRef);

  readonly auth = inject(AuthService);
  readonly dinamicasService = inject(DinamicasService);
  readonly marcadoresService = inject(MarcadoresService);
  readonly agendaTypes = [
    'Dinámica por puntos',
    'Dinámica por Dracoins',
    'Actividad por Puntos',
    'Actividad por Dracoins',
    'Clase',
    'Karaoke',
    'Especial'
  ] as const;

  readonly result = signal<PagedResult<DinamicaListItem> | null>(null);
  readonly selectedDinamica = signal<DinamicaListItem | null>(null);
  readonly selectedPointsDetail = signal<DinamicaPuntosDetail | null>(null);
  readonly selectedDracoinsDetail = signal<DinamicaDracoinsDetail | null>(null);
  readonly assignableStudents = signal<AssignableAlumno[]>([]);
  readonly agendaItems = signal<AgendaDinamica[]>([]);
  readonly agendaResponsables = signal<AgendaResponsable[]>([]);
  readonly pointsHouses = signal<EditablePointsHouse[]>([]);
  readonly automaticPointsAnalysis = signal<AutomaticPointsAnalysis | null>(null);
  readonly selectedAgenda = signal<AgendaDinamica | null>(null);
  readonly agendaRows = signal<AgendaDraftRow[]>([{ hora: '', idAlumno: null, titulo: '' }]);
  readonly loadingList = signal(false);
  readonly loadingDetail = signal(false);
  readonly loadingStudents = signal(false);
  readonly loadingAgenda = signal(false);
  readonly loadingAgendaResponsables = signal(false);
  readonly loadingPointsHouses = signal(false);
  readonly submitting = signal(false);
  readonly submittingPoints = signal(false);
  readonly analyzingAutomaticPoints = signal(false);
  readonly submittingAutomaticPoints = signal(false);
  readonly submittingAgenda = signal(false);
  readonly deletingDinamicaId = signal<number | null>(null);
  readonly deletingAgendaId = signal<number | null>(null);
  readonly clearingAgenda = signal(false);
  readonly errorMessage = signal('');
  readonly successMessage = signal('');
  readonly activeSection = signal<DinamicasSection>('listado');
  readonly dinamicaToDelete = signal<DinamicaListItem | null>(null);
  readonly agendaToDelete = signal<AgendaDinamica | null>(null);
  readonly confirmClearAgendaOpen = signal(false);
  readonly agendaModalMode = signal<AgendaModalMode>(null);

  readonly canViewIndex = computed(() => this.auth.hasPermission('Dinamicas:Index'));
  readonly canViewPointsDetail = computed(() => this.auth.hasPermission('Dinamicas:DetallePuntos'));
  readonly canViewDracoinsDetail = computed(() => this.auth.hasPermission('Dinamicas:DetalleDracoins'));
  readonly canRegisterDracoins = computed(() =>
    this.auth.hasPermission(DINAMICAS_REGISTRAR_DRACOINS_PERMISSION)
  );
  readonly canRegisterPoints = computed(() => this.auth.hasPermission('Marcadores:ActualizarMarcador'));
  readonly canDeleteDinamica = computed(() => this.auth.hasPermission('Dinamicas:Eliminar'));
  readonly canManageAgenda = computed(() => this.auth.hasPermission('Dinamicas:AgendaIndex'));
  readonly canViewModule = computed(
    () =>
      this.canViewIndex() ||
      this.canViewPointsDetail() ||
      this.canViewDracoinsDetail() ||
      this.canRegisterDracoins() ||
      this.canRegisterPoints() ||
      this.canDeleteDinamica() ||
      this.canManageAgenda()
  );
  readonly canViewListSection = computed(
    () => this.canViewIndex() || this.canViewPointsDetail() || this.canViewDracoinsDetail()
  );
  readonly dinamicas = computed(() => this.result()?.items ?? []);
  readonly selectedAssignments = computed(() =>
    this.assignableStudents()
      .filter((student) => (student.dracoinsOtorgados ?? 0) > 0)
      .map((student) => ({
        idAlumno: student.idAlumno,
        dracoinsOtorgados: student.dracoinsOtorgados ?? 0,
        observacion: null
      }))
  );
  readonly totalSelectedStudents = computed(
    () => this.selectedAssignments().length
  );
  readonly totalAssignedDracoins = computed(() =>
    this.selectedAssignments().reduce((total, item) => total + item.dracoinsOtorgados, 0)
  );
  readonly totalAssignedPoints = computed(() =>
    this.pointsHouses().reduce((total, house) => total + (house.puntos ?? 0), 0)
  );

  nombre = '';
  tipo = '';
  subtipo = '';
  responsable = '';
  desde = '';
  hasta = '';

  nombreDinamica = '';
  observacionDinamica = '';
  nombreDinamicaPuntos = '';
  subtipoDinamicaPuntos = 'Normal';
  observacionDinamicaPuntos = '';
  pointsRegistrationMode: PointsRegistrationMode = 'manual';
  automaticPointsText = '';
  automaticPointsName = '';
  automaticPointsSubtype = 'Normal';
  automaticPointsObservation = '';
  automaticPointsRequestId = this.createRequestId();
  studentSearch = '';

  agendaFilterDate = '';
  agendaFormDate = this.todayString();
  agendaEditFecha = this.todayString();
  agendaEditHora = '';
  agendaEditIdAlumno: number | null = null;
  agendaEditTitulo = '';

  constructor() {
    if (!this.canViewModule()) {
      return;
    }

    this.activeSection.set(this.initialSection());

    if (this.canViewIndex()) {
      this.loadDinamicas();
    }

    if (this.canRegisterDracoins()) {
      this.loadActiveStudents();
    }

    if (this.canRegisterPoints()) {
      this.loadPointsHouses();
    }

    if (this.canManageAgenda()) {
      this.loadAgenda();
      this.loadAgendaResponsables();
    }
  }

  setActiveSection(section: DinamicasSection): void {
    this.activeSection.set(section);
    this.refreshSection(section);
  }

  loadDinamicas(page = 1): void {
    if (!this.canViewIndex()) {
      return;
    }

    this.loadingList.set(true);
    this.errorMessage.set('');

    this.dinamicasService
      .getDinamicas({
        nombre: this.nombre,
        tipo: this.tipo,
        subtipo: this.subtipo,
        responsable: this.responsable,
        desde: this.desde || null,
        hasta: this.hasta || null,
        pagina: page,
        registrosPorPagina: 10
      })
      .pipe(
        finalize(() => this.loadingList.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (response) => this.result.set(response),
        error: (error) =>
          this.errorMessage.set(this.readErrorMessage(error, 'No se pudo cargar el listado.'))
      });
  }

  resetFilters(): void {
    this.nombre = '';
    this.tipo = '';
    this.subtipo = '';
    this.responsable = '';
    this.desde = '';
    this.hasta = '';
    this.loadDinamicas();
  }

  openDetail(item: DinamicaListItem): void {
    this.selectedDinamica.set(item);
    this.selectedPointsDetail.set(null);
    this.selectedDracoinsDetail.set(null);
    this.loadingDetail.set(true);
    this.errorMessage.set('');

    if (item.tipo.toLowerCase() === 'puntos' && this.canViewPointsDetail()) {
      this.dinamicasService
        .getPointsDetail(item.idDinamica)
        .pipe(
          finalize(() => this.loadingDetail.set(false)),
          takeUntilDestroyed(this.destroyRef)
        )
        .subscribe({
          next: (detail) => this.selectedPointsDetail.set(detail),
          error: (error) =>
            this.errorMessage.set(
              this.readErrorMessage(error, 'No se pudo cargar el detalle de la dinámica.')
            )
        });
      return;
    }

    if (item.tipo.toLowerCase() === 'dracoins' && this.canViewDracoinsDetail()) {
      this.dinamicasService
        .getDracoinsDetail(item.idDinamica)
        .pipe(
          finalize(() => this.loadingDetail.set(false)),
          takeUntilDestroyed(this.destroyRef)
        )
        .subscribe({
          next: (detail) => this.selectedDracoinsDetail.set(detail),
          error: (error) =>
            this.errorMessage.set(
              this.readErrorMessage(error, 'No se pudo cargar el detalle de la dinámica.')
            )
        });
      return;
    }

    this.loadingDetail.set(false);
    this.errorMessage.set('Tu sesión no tiene permiso para ver el detalle de esta dinámica.');
  }

  closeDetail(): void {
    this.selectedDinamica.set(null);
    this.selectedPointsDetail.set(null);
    this.selectedDracoinsDetail.set(null);
    this.loadingDetail.set(false);
  }

  filteredStudents(): AssignableAlumno[] {
    const search = this.studentSearch.trim().toLowerCase();
    const students = this.assignableStudents();
    if (!search) {
      return students;
    }

    return students.filter((student) => `${student.codigo} ${student.nombre}`.toLowerCase().includes(search));
  }

  loadActiveStudents(): void {
    if (!this.canRegisterDracoins()) {
      return;
    }

    this.loadingStudents.set(true);

    this.dinamicasService
      .getActiveStudents()
      .pipe(
        finalize(() => this.loadingStudents.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (response) =>
          this.assignableStudents.set(
            response.map((student) => ({
              ...student,
              seleccionado: false,
              dracoinsOtorgados: null
            }))
          ),
        error: (error) =>
          this.errorMessage.set(
            this.readErrorMessage(error, 'No se pudo cargar la lista de alumnos activos.')
          )
      });
  }

  setAssignedDracoins(idAlumno: number, value: number | null): void {
    this.assignableStudents.set(
      this.assignableStudents().map((student) =>
        student.idAlumno === idAlumno
          ? {
              ...student,
              seleccionado: (value ?? 0) > 0,
              dracoinsOtorgados: value === null || Number.isNaN(value) ? null : Math.max(0, value)
            }
          : student
      )
    );
  }

  loadPointsHouses(): void {
    if (!this.canRegisterPoints()) {
      return;
    }

    this.loadingPointsHouses.set(true);

    this.marcadoresService
      .getHouses()
      .pipe(
        finalize(() => this.loadingPointsHouses.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (response) =>
          this.pointsHouses.set(
            response
              .filter((house) => house.nombreCasa.trim().toLowerCase() !== 'id')
              .map((house) => ({ ...house, puntos: 0 }))
          ),
        error: (error) =>
          this.errorMessage.set(this.readErrorMessage(error, 'No se pudo cargar la lista de casas.'))
      });
  }

  setHousePoints(idCasa: number, value: number | null): void {
    this.pointsHouses.set(
      this.pointsHouses().map((house) =>
        house.idCasa === idCasa
          ? {
              ...house,
              puntos: value === null || Number.isNaN(value) ? 0 : Math.max(0, value)
            }
          : house
      )
    );
  }

  submitPointsDinamica(): void {
    if (!this.canRegisterPoints()) {
      return;
    }

    this.errorMessage.set('');
    this.successMessage.set('');
    this.submittingPoints.set(true);

    this.marcadoresService
      .createUpdate({
        nombreDinamica: this.nombreDinamicaPuntos.trim(),
        subtipoDinamica: this.subtipoDinamicaPuntos,
        observacion: this.observacionDinamicaPuntos.trim() || null,
        puntosPorCasa: this.pointsHouses().map((house) => ({
          idCasa: house.idCasa,
          puntos: house.puntos ?? 0
        }))
      })
      .pipe(
        finalize(() => this.submittingPoints.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (response) => {
          this.successMessage.set(`Dinámica por puntos #${response.idDinamica} registrada correctamente.`);
          this.nombreDinamicaPuntos = '';
          this.subtipoDinamicaPuntos = 'Normal';
          this.observacionDinamicaPuntos = '';
          this.pointsHouses.set(this.pointsHouses().map((house) => ({ ...house, puntos: 0 })));
          if (this.canViewIndex()) {
            this.loadDinamicas(1);
          }
        },
        error: (error) =>
          this.errorMessage.set(
            this.readErrorMessage(error, 'No se pudo registrar la dinámica por puntos.')
          )
      });
  }

  analyzeAutomaticPoints(): void {
    if (!this.canRegisterPoints()) {
      return;
    }

    this.errorMessage.set('');
    this.successMessage.set('');
    this.analyzingAutomaticPoints.set(true);

    this.dinamicasService
      .analyzeAutomaticPoints(this.buildAutomaticAnalyzePayload())
      .pipe(
        finalize(() => this.analyzingAutomaticPoints.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (analysis) => {
          this.automaticPointsAnalysis.set(analysis);
          if (!this.automaticPointsName.trim()) {
            this.automaticPointsName = analysis.detectedName;
          }
        },
        error: (error) =>
          this.errorMessage.set(
            this.readErrorMessage(error, 'No se pudo analizar el contador automático.')
          )
      });
  }

  updateAutomaticRound(roundNumber: number, multiplier: number, cancelled: boolean): void {
    const analysis = this.automaticPointsAnalysis();
    if (!analysis) {
      return;
    }

    this.automaticPointsAnalysis.set({
      ...analysis,
      rounds: analysis.rounds.map((round) =>
        round.roundNumber === roundNumber ? { ...round, multiplier, cancelled } : round
      )
    });
    this.analyzeAutomaticPoints();
  }

  updateAutomaticFrog(index: number, startRound: number): void {
    const analysis = this.automaticPointsAnalysis();
    if (!analysis || !Number.isFinite(startRound)) {
      return;
    }

    this.automaticPointsAnalysis.set({
      ...analysis,
      frogs: analysis.frogs.map((frog) =>
        frog.index === index ? { ...frog, startRound: Math.max(1, startRound) } : frog
      )
    });
    this.analyzeAutomaticPoints();
  }

  submitAutomaticPoints(): void {
    if (!this.canRegisterPoints() || !this.automaticPointsAnalysis()) {
      return;
    }

    this.errorMessage.set('');
    this.successMessage.set('');
    this.submittingAutomaticPoints.set(true);

    this.dinamicasService
      .registerAutomaticPoints({
        ...this.buildAutomaticAnalyzePayload(),
        name: this.automaticPointsName.trim(),
        subtype: this.automaticPointsSubtype,
        observation: this.automaticPointsObservation.trim() || null,
        clientRequestId: this.automaticPointsRequestId
      })
      .pipe(
        finalize(() => this.submittingAutomaticPoints.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (response) => {
          this.successMessage.set(`Dinámica automática #${response.idDinamica} registrada correctamente.`);
          this.resetAutomaticPoints();
          if (this.canViewIndex()) {
            this.loadDinamicas(1);
          }
        },
        error: (error) =>
          this.errorMessage.set(
            this.readErrorMessage(error, 'No se pudo registrar la dinámica automática.')
          )
      });
  }

  resetAutomaticPoints(): void {
    this.automaticPointsText = '';
    this.automaticPointsName = '';
    this.automaticPointsSubtype = 'Normal';
    this.automaticPointsObservation = '';
    this.automaticPointsAnalysis.set(null);
    this.automaticPointsRequestId = this.createRequestId();
  }

  submitDracoinsDinamica(): void {
    if (!this.canRegisterDracoins()) {
      return;
    }

    const observacionGeneral = this.observacionDinamica.trim();

    this.errorMessage.set('');
    this.successMessage.set('');
    this.submitting.set(true);

    this.dinamicasService
      .createDracoinsDinamica({
        nombre: this.nombreDinamica.trim(),
        observacion: observacionGeneral || null,
        asignaciones: this.selectedAssignments()
      })
      .pipe(
        finalize(() => this.submitting.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (detail) => {
          this.successMessage.set(`Dinámica #${detail.idDinamica} registrada correctamente.`);
          this.nombreDinamica = '';
          this.observacionDinamica = '';
          this.studentSearch = '';
          this.selectedDinamica.set({
            idDinamica: detail.idDinamica,
            fecha: detail.fecha,
            nombre: detail.nombre,
            tipo: detail.tipo,
            subtipo: detail.subtipo,
            idResponsable: detail.idResponsable,
            nombreResponsable: detail.nombreResponsable,
            observacion: detail.observacion || observacionGeneral
          });
          this.selectedPointsDetail.set(null);
          this.selectedDracoinsDetail.set({
            ...detail,
            observacion: detail.observacion || observacionGeneral
          });
          this.assignableStudents.set(
            this.assignableStudents().map((student) => ({
              ...student,
              seleccionado: false,
              dracoinsOtorgados: null
            }))
          );

          if (this.canViewIndex()) {
            this.loadDinamicas(1);
          }

          this.auth
            .hydrateSession()
            .pipe(takeUntilDestroyed(this.destroyRef))
            .subscribe();
        },
        error: (error) =>
          this.errorMessage.set(
            this.readErrorMessage(error, 'No se pudo registrar la dinámica por dracoins.')
          )
      });
  }

  deleteDinamica(item: DinamicaListItem): void {
    if (!this.canDeleteDinamica()) {
      return;
    }

    this.dinamicaToDelete.set(item);
  }

  closeDinamicaDeleteModal(): void {
    this.dinamicaToDelete.set(null);
  }

  confirmDeleteDinamica(): void {
    const item = this.dinamicaToDelete();
    if (!item || !this.canDeleteDinamica()) {
      return;
    }

    this.deletingDinamicaId.set(item.idDinamica);
    this.errorMessage.set('');
    this.successMessage.set('');

    this.dinamicasService
      .deleteDinamica(item.idDinamica)
      .pipe(
        finalize(() => this.deletingDinamicaId.set(null)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: () => {
          this.successMessage.set(`Dinámica #${item.idDinamica} eliminada correctamente.`);
          this.closeDinamicaDeleteModal();
          if (this.selectedDinamica()?.idDinamica === item.idDinamica) {
            this.selectedDinamica.set(null);
            this.selectedPointsDetail.set(null);
            this.selectedDracoinsDetail.set(null);
          }

          this.loadDinamicas(this.result()?.paginaActual ?? 1);
        },
        error: (error) =>
          this.errorMessage.set(
            this.readErrorMessage(error, 'No se pudo eliminar la dinámica seleccionada.')
          )
      });
  }

  loadAgenda(): void {
    if (!this.canManageAgenda()) {
      return;
    }

    this.loadingAgenda.set(true);

    this.dinamicasService
      .getAgenda(this.agendaFilterDate || null)
      .pipe(
        finalize(() => this.loadingAgenda.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (items) => this.agendaItems.set(items),
        error: (error) =>
          this.errorMessage.set(this.readErrorMessage(error, 'No se pudo cargar la agenda.'))
      });
  }

  resetAgendaFilter(): void {
    this.agendaFilterDate = '';
    this.loadAgenda();
  }

  loadAgendaResponsables(): void {
    if (!this.canManageAgenda()) {
      return;
    }

    this.loadingAgendaResponsables.set(true);

    this.dinamicasService
      .getAgendaResponsables()
      .pipe(
        finalize(() => this.loadingAgendaResponsables.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (items) => this.agendaResponsables.set(items),
        error: (error) =>
          this.errorMessage.set(
            this.readErrorMessage(error, 'No se pudo cargar la lista de responsables.')
          )
      });
  }

  addAgendaRow(): void {
    this.agendaRows.set([...this.agendaRows(), { hora: '', idAlumno: null, titulo: '' }]);
  }

  openAgendaCreateModal(): void {
    this.selectedAgenda.set(null);
    this.agendaRows.set([{ hora: '', idAlumno: null, titulo: '' }]);
    this.agendaFormDate = this.agendaFilterDate || this.todayString();
    this.agendaModalMode.set('create');
  }

  closeAgendaModal(): void {
    this.agendaModalMode.set(null);
    this.cancelAgendaEdit();
  }

  removeAgendaRow(index: number): void {
    if (this.agendaRows().length === 1) {
      this.agendaRows.set([{ hora: '', idAlumno: null, titulo: '' }]);
      return;
    }

    this.agendaRows.set(this.agendaRows().filter((_, currentIndex) => currentIndex !== index));
  }

  updateAgendaRow(index: number, patch: Partial<AgendaDraftRow>): void {
    this.agendaRows.set(
      this.agendaRows().map((row, currentIndex) =>
        currentIndex === index ? { ...row, ...patch } : row
      )
    );
  }

  submitAgendaBatch(): void {
    if (!this.canManageAgenda()) {
      return;
    }

    const items = this.agendaRows()
      .filter((row) => row.hora.trim() || row.idAlumno !== null || row.titulo.trim())
      .map((row) => ({
        hora: row.hora,
        idAlumno: row.idAlumno ?? 0,
        titulo: row.titulo
      }));

    this.submittingAgenda.set(true);
    this.errorMessage.set('');
    this.successMessage.set('');

    this.dinamicasService
      .createAgendaBatch({
        fecha: this.agendaFormDate || null,
        items
      })
      .pipe(
        finalize(() => this.submittingAgenda.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (itemsResponse) => {
          this.successMessage.set('Agenda registrada correctamente.');
          this.agendaItems.set(itemsResponse);
          this.agendaRows.set([{ hora: '', idAlumno: null, titulo: '' }]);
          this.selectedAgenda.set(null);
          this.agendaEditFecha = this.agendaFormDate || this.todayString();
          this.agendaEditHora = '';
          this.agendaEditIdAlumno = null;
          this.agendaEditTitulo = '';
          this.agendaFilterDate = this.agendaFormDate;
          this.agendaModalMode.set(null);
        },
        error: (error) =>
          this.errorMessage.set(
            this.readErrorMessage(error, 'No se pudo registrar la agenda del día.')
          )
      });
  }

  startAgendaEdit(item: AgendaDinamica): void {
    this.selectedAgenda.set(item);
    this.agendaEditFecha = item.fecha.slice(0, 10);
    this.agendaEditHora = item.hora.slice(0, 5);
    this.agendaEditIdAlumno = item.idAlumno;
    this.agendaEditTitulo = item.titulo;
    this.agendaModalMode.set('edit');
  }

  cancelAgendaEdit(): void {
    this.selectedAgenda.set(null);
    this.agendaEditFecha = this.todayString();
    this.agendaEditHora = '';
    this.agendaEditIdAlumno = null;
    this.agendaEditTitulo = '';
  }

  submitAgendaEdit(): void {
    const item = this.selectedAgenda();
    if (!this.canManageAgenda() || !item) {
      return;
    }

    this.submittingAgenda.set(true);
    this.errorMessage.set('');
    this.successMessage.set('');

    this.dinamicasService
      .updateAgenda(item.idAgenda, {
        fecha: this.agendaEditFecha || null,
        hora: this.agendaEditHora,
        idAlumno: this.agendaEditIdAlumno ?? 0,
        titulo: this.agendaEditTitulo
      })
      .pipe(
        finalize(() => this.submittingAgenda.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (updated) => {
          this.successMessage.set(`Agenda #${updated.idAgenda} actualizada correctamente.`);
          this.loadAgenda();
          this.startAgendaEdit(updated);
          this.agendaModalMode.set(null);
        },
        error: (error) =>
          this.errorMessage.set(
            this.readErrorMessage(error, 'No se pudo actualizar la agenda seleccionada.')
          )
      });
  }

  deleteAgenda(item: AgendaDinamica): void {
    if (!this.canManageAgenda()) {
      return;
    }

    this.agendaToDelete.set(item);
  }

  closeAgendaDeleteModal(): void {
    this.agendaToDelete.set(null);
  }

  confirmDeleteAgenda(): void {
    const item = this.agendaToDelete();
    if (!item || !this.canManageAgenda()) {
      return;
    }

    this.deletingAgendaId.set(item.idAgenda);
    this.errorMessage.set('');
    this.successMessage.set('');

    this.dinamicasService
      .deleteAgenda(item.idAgenda)
      .pipe(
        finalize(() => this.deletingAgendaId.set(null)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: () => {
          this.successMessage.set(`Agenda #${item.idAgenda} eliminada correctamente.`);
          this.closeAgendaDeleteModal();
          if (this.selectedAgenda()?.idAgenda === item.idAgenda) {
            this.cancelAgendaEdit();
          }

          this.loadAgenda();
        },
        error: (error) =>
          this.errorMessage.set(
            this.readErrorMessage(error, 'No se pudo eliminar la agenda seleccionada.')
          )
      });
  }

  clearAgenda(): void {
    if (!this.canManageAgenda()) {
      return;
    }

    this.confirmClearAgendaOpen.set(true);
  }

  closeClearAgendaModal(): void {
    this.confirmClearAgendaOpen.set(false);
  }

  confirmClearAgenda(): void {
    if (!this.canManageAgenda()) {
      return;
    }

    this.clearingAgenda.set(true);
    this.errorMessage.set('');
    this.successMessage.set('');

    this.dinamicasService
      .clearAgenda()
      .pipe(
        finalize(() => this.clearingAgenda.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: () => {
          this.successMessage.set('La agenda fue limpiada correctamente.');
          this.agendaItems.set([]);
          this.cancelAgendaEdit();
          this.closeClearAgendaModal();
        },
        error: (error) =>
          this.errorMessage.set(this.readErrorMessage(error, 'No se pudo limpiar la agenda.'))
      });
  }

  previousPage(): void {
    const currentPage = this.result()?.paginaActual ?? 1;
    if (currentPage > 1) {
      this.loadDinamicas(currentPage - 1);
    }
  }

  nextPage(): void {
    const current = this.result();
    if (current && current.paginaActual < current.totalPaginas) {
      this.loadDinamicas(current.paginaActual + 1);
    }
  }

  coerceNullableNumber(value: string): number | null {
    const trimmed = value.trim();
    if (!trimmed) {
      return null;
    }

    const parsed = Number(trimmed);
    return Number.isFinite(parsed) ? parsed : null;
  }

  private buildAutomaticAnalyzePayload() {
    const analysis = this.automaticPointsAnalysis();
    return {
      text: this.automaticPointsText,
      roundAdjustments: (analysis?.rounds ?? []).map((round) => ({
        roundNumber: round.roundNumber,
        multiplier: round.multiplier,
        cancelled: round.cancelled
      })),
      frogAdjustments: (analysis?.frogs ?? []).map((frog) => ({
        index: frog.index,
        startRound: frog.startRound
      }))
    };
  }

  private createRequestId(): string {
    return globalThis.crypto?.randomUUID?.() ?? `${Date.now()}-${Math.random()}`;
  }

  private todayString(): string {
    return new Date().toISOString().slice(0, 10);
  }

  private refreshSection(section: DinamicasSection): void {
    if (section === 'listado') {
      if (this.canViewIndex()) {
        this.loadDinamicas(this.result()?.paginaActual ?? 1);
      }

      return;
    }

    if (section === 'registrar') {
      this.loadActiveStudents();
      return;
    }

    if (section === 'puntos') {
      this.loadPointsHouses();
      return;
    }

    this.loadAgenda();
    this.loadAgendaResponsables();
  }

  private initialSection(): DinamicasSection {
    if (this.canViewListSection()) {
      return 'listado';
    }

    if (this.canRegisterDracoins()) {
      return 'registrar';
    }

    if (this.canRegisterPoints()) {
      return 'puntos';
    }

    return 'agenda';
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
