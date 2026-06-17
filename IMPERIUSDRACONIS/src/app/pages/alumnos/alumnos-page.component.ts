import { CommonModule } from '@angular/common';
import { HttpErrorResponse } from '@angular/common/http';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { ChangeDetectionStrategy, ChangeDetectorRef, Component, DestroyRef, computed, inject, signal } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { finalize, forkJoin } from 'rxjs';
import {
  AlumnoDetail,
  AlumnoListItem,
  AlumnoNote,
  CatalogItem,
  PagedResult,
  SaveAlumnoRequest
} from '../../core/models/alumnos.models';
import { resolveProfileAvatarUrl } from '../../core/constants/profile.constants';
import { AuthService } from '../../core/services/auth.service';
import { AlumnosService } from '../../core/services/alumnos.service';
import { RuntimeConfigService } from '../../core/services/runtime-config.service';
import { ImageFallbackDirective } from '../../shared/directives/image-fallback.directive';

type FormMode = 'create' | 'edit';
type AlumnoModalMode = 'detail' | 'form' | 'notes' | 'password';
type AlumnosViewMode = 'list' | 'emojis';

interface AlumnoFormModel {
  codigo: string;
  nombre: string;
  telefono: string;
  idCasa: number | null;
  idCargo: number | null;
  nivel: string;
  dracoins: number | null;
  activo: boolean;
  genero: string;
  cumpleanos: string;
  pais: string;
  prefijoPais: string;
  zonaHoraria: string;
  correoElectronico: string;
  fotoPerfil: string;
  contrasena: string;
}

interface PaisOption {
  nombre: string;
  prefijo: string;
  zonaHoraria?: string;
}

@Component({
  selector: 'app-alumnos-page',
  imports: [CommonModule, FormsModule, ImageFallbackDirective],
  templateUrl: './alumnos-page.component.html',
  styleUrl: './alumnos-page.component.css',
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class AlumnosPageComponent {
  private readonly destroyRef = inject(DestroyRef);
  private readonly changeDetectorRef = inject(ChangeDetectorRef);
  private readonly alumnosPermissions = [
    'Alumnos:Index',
    'Alumnos:Detalle',
    'Alumnos:Crear',
    'Alumnos:Editar',
    'Alumnos:ModificarEmojis',
    'Alumnos:Eliminar',
    'Alumnos:Notas',
    'Alumnos:CambiarContraseña'
  ] as const;

  readonly auth = inject(AuthService);
  readonly alumnosService = inject(AlumnosService);
  readonly runtimeConfig = inject(RuntimeConfigService);

  readonly casas = signal<CatalogItem[]>([]);
  readonly cargos = signal<CatalogItem[]>([]);
  readonly resultado = signal<PagedResult<AlumnoListItem> | null>(null);
  readonly selectedAlumno = signal<AlumnoDetail | null>(null);
  readonly notas = signal<AlumnoNote[]>([]);
  readonly loading = signal(false);
  readonly detailLoading = signal(false);
  readonly catalogsLoading = signal(false);
  readonly notesLoading = signal(false);
  readonly nextCodeLoading = signal(false);
  readonly savingForm = signal(false);
  readonly changingStatus = signal(false);
  readonly deleting = signal(false);
  readonly savingNote = signal(false);
  readonly resettingPassword = signal(false);
  readonly emojiSavingId = signal<number | null>(null);
  readonly errorMessage = signal('');
  readonly successMessage = signal('');
  readonly activeView = signal<AlumnosViewMode>('list');
  readonly formMode = signal<FormMode | null>(null);
  readonly showFormPanel = signal(false);
  readonly showNotesPanel = signal(false);
  readonly showPasswordPanel = signal(false);
  readonly alumnoModalMode = signal<AlumnoModalMode | null>(null);
  readonly deleteConfirmOpen = signal(false);
  readonly dracoinsSortActive = signal(false);
  readonly filtersCollapsed = signal(false);

  private filterReloadTimer: ReturnType<typeof setTimeout> | null = null;

  readonly alumnos = computed(() => this.resultado()?.items ?? []);
  readonly emojiDrafts = signal<Record<number, string>>({});
  readonly canList = computed(() => this.auth.hasPermission('Alumnos:Index'));
  readonly canDetail = computed(
    () => this.auth.hasPermission('Alumnos:Index') || this.auth.hasPermission('Alumnos:Detalle')
  );
  readonly canCreate = computed(() => this.auth.hasPermission('Alumnos:Crear'));
  readonly canEdit = computed(() => this.auth.hasPermission('Alumnos:Editar'));
  readonly canManageEmojis = computed(() => this.auth.hasPermission('Alumnos:ModificarEmojis'));
  readonly canDelete = computed(() => this.auth.hasPermission('Alumnos:Eliminar'));
  readonly canNotes = computed(() => this.auth.hasPermission('Alumnos:Notas'));
  readonly canResetPassword = computed(() => this.auth.hasPermission('Alumnos:CambiarContraseña'));
  readonly canViewModule = computed(() => this.auth.hasAnyPermission(this.alumnosPermissions));
  readonly selectedNotesCount = computed(() => this.notas().length);
  readonly formTitle = computed(() => {
    if (this.formMode() === 'create') {
      return 'Crear alumno';
    }

    if (this.formMode() === 'edit') {
      return 'Editar alumno';
    }

    return 'Formulario';
  });

  codigo = '';
  nombre = '';
  idCasa: number | null = null;
  estado: 'all' | 'active' | 'inactive' = 'active';

  notaTexto = '';
  nuevaContrasena = '';
  confirmarContrasena = '';

  form: AlumnoFormModel = this.createEmptyForm();

  readonly generos = ['Masculino', 'Femenino', 'No binario'] as const;
  readonly paises: PaisOption[] = [
    { nombre: 'Argentina', prefijo: '+54', zonaHoraria: 'America/Argentina/Buenos_Aires' },
    { nombre: 'Bolivia', prefijo: '+591', zonaHoraria: 'America/La_Paz' },
    { nombre: 'Chile', prefijo: '+56', zonaHoraria: 'America/Santiago' },
    { nombre: 'Colombia', prefijo: '+57', zonaHoraria: 'America/Bogota' },
    { nombre: 'Ecuador', prefijo: '+593', zonaHoraria: 'America/Guayaquil' },
    { nombre: 'España', prefijo: '+34', zonaHoraria: 'Europe/Madrid' },
    { nombre: 'México', prefijo: '+52', zonaHoraria: 'America/Mexico_City' },
    { nombre: 'Perú', prefijo: '+51', zonaHoraria: 'America/Lima' },
    { nombre: 'Venezuela', prefijo: '+58', zonaHoraria: 'America/Caracas' }
  ];

  constructor() {
    if (!this.canViewModule()) {
      return;
    }

    if (this.canList() || this.canCreate() || this.canEdit() || this.canManageEmojis()) {
      this.loadCatalogs();
    }

    if (this.canList()) {
      this.loadAlumnos();
    }

    if (this.canCreate()) {
      this.form = this.createEmptyForm();
      this.formMode.set('create');
    }
  }

  loadAlumnos(page = 1): void {
    if (!this.canList()) {
      return;
    }

    this.clearFilterReloadTimer();

    this.loading.set(true);
    this.errorMessage.set('');

    this.alumnosService
      .getAlumnos({
        codigo: this.codigo,
        nombre: this.nombre,
        idCasa: this.idCasa,
        activo: this.estado === 'all' ? null : this.estado === 'active',
        pagina: page,
        registrosPorPagina: 18,
        ordenarPor: this.dracoinsSortActive() ? 'dracoins' : 'nombre',
        orden: this.dracoinsSortActive() ? 'desc' : 'asc'
      })
      .pipe(
        finalize(() => this.loading.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (response) => {
          this.resultado.set(response);
          this.syncEmojiDrafts(response.items);
        },
        error: (error) => {
          this.errorMessage.set(this.readErrorMessage(error, 'No se pudo cargar la lista de alumnos.'));
        }
      });
  }

  resetFilters(): void {
    this.codigo = '';
    this.nombre = '';
    this.idCasa = null;
    this.estado = 'active';
    this.loadAlumnos(1);
  }

  toggleFilters(): void {
    this.filtersCollapsed.update((current) => !current);
  }

  onLiveFilterChange(): void {
    this.scheduleLiveReload(1);
  }

  toggleDracoinsSort(): void {
    this.dracoinsSortActive.update((current) => !current);
    this.loadAlumnos(this.resultado()?.paginaActual ?? 1);
  }

  avatarUrl(path?: string | null): string {
    return resolveProfileAvatarUrl(path, this.runtimeConfig);
  }

  openAlumno(idAlumno: number): void {
    if (!this.canDetail()) {
      return;
    }

    this.detailLoading.set(true);
    this.errorMessage.set('');

    this.alumnosService
      .getAlumno(idAlumno)
      .pipe(
        finalize(() => this.detailLoading.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (alumno) => {
          this.selectedAlumno.set(alumno);
          if (this.canNotes()) {
            this.loadNotas(alumno.idAlumno);
          } else {
            this.notas.set([]);
          }

          if (this.formMode() === 'edit') {
            this.form = this.mapAlumnoToForm(alumno);
          }

          this.alumnoModalMode.set('detail');
        },
        error: (error) => {
          this.errorMessage.set(this.readErrorMessage(error, 'No se pudo cargar el detalle del alumno.'));
        }
      });
  }

  startCreate(): void {
    if (!this.canCreate()) {
      return;
    }

    this.clearMessages();
    this.selectedAlumno.set(null);
    this.notas.set([]);
    this.formMode.set('create');
    this.form = {
      ...this.createEmptyForm(),
      idCargo: this.getAlumnoCargoId(),
      activo: true,
      dracoins: 0,
      nivel: '',
      zonaHoraria: '',
      fotoPerfil: '',
      pais: 'Perú',
      prefijoPais: '+51',
      contrasena: ''
    };
    this.notaTexto = '';
    this.nuevaContrasena = '';
    this.confirmarContrasena = '';
    this.showFormPanel.set(true);
    this.alumnoModalMode.set('form');
  }

  startEdit(): void {
    const alumno = this.selectedAlumno();
    if (!alumno || !this.canEdit()) {
      return;
    }

    this.clearMessages();
    this.formMode.set('edit');
    this.form = this.mapAlumnoToForm(alumno);
    this.showFormPanel.set(true);
    this.alumnoModalMode.set('form');
  }

  closeFormPanel(): void {
    this.showFormPanel.set(false);
    this.formMode.set(this.canCreate() ? 'create' : null);
    this.alumnoModalMode.set(this.selectedAlumno() ? 'detail' : null);
  }

  cancelForm(): void {
    this.clearMessages();
    this.closeFormPanel();
  }

  closeNotesPanel(): void {
    this.showNotesPanel.set(false);
    this.alumnoModalMode.set(this.selectedAlumno() ? 'detail' : null);
  }

  closePasswordPanel(): void {
    this.showPasswordPanel.set(false);
    this.alumnoModalMode.set(this.selectedAlumno() ? 'detail' : null);
  }

  closeAlumnoModal(): void {
    this.alumnoModalMode.set(null);
    this.showFormPanel.set(false);
    this.showNotesPanel.set(false);
    this.showPasswordPanel.set(false);
    this.deleteConfirmOpen.set(false);
  }

  openNotesPanel(): void {
    if (!this.selectedAlumno() || !this.canNotes()) {
      return;
    }

    this.clearMessages();
    this.showNotesPanel.set(true);
    this.alumnoModalMode.set('notes');
  }

  openPasswordPanel(): void {
    if (!this.selectedAlumno() || !this.canResetPassword()) {
      return;
    }

    this.clearMessages();
    this.nuevaContrasena = '';
    this.confirmarContrasena = '';
    this.showPasswordPanel.set(true);
    this.alumnoModalMode.set('password');
  }

  openDeleteConfirm(): void {
    if (!this.selectedAlumno() || !this.canDelete()) {
      return;
    }

    this.clearMessages();
    this.deleteConfirmOpen.set(true);
  }

  closeDeleteConfirm(): void {
    if (this.deleting()) {
      return;
    }

    this.deleteConfirmOpen.set(false);
  }

  onCasaSelected(idCasa: number | null): void {
    this.form = {
      ...this.form,
      idCasa
    };

    if (this.formMode() !== 'create' || !idCasa) {
      return;
    }

    this.nextCodeLoading.set(true);
    this.alumnosService
      .getNextCodigo(idCasa)
      .pipe(
        finalize(() => this.nextCodeLoading.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (response) => {
          this.form = {
            ...this.form,
            codigo: response.codigo
          };
          this.changeDetectorRef.markForCheck();
        },
        error: (error) => {
          this.errorMessage.set(
            this.readErrorMessage(error, 'No se pudo calcular el siguiente código para la casa.')
          );
        }
      });
  }

  submitForm(): void {
    const mode = this.formMode();
    if (!mode) {
      return;
    }

    const payload = this.buildPayload();
    if (!payload) {
      return;
    }

    this.clearMessages();
    this.savingForm.set(true);

    if (mode === 'create') {
      this.alumnosService
        .createAlumno(payload)
        .pipe(
          finalize(() => this.savingForm.set(false)),
          takeUntilDestroyed(this.destroyRef)
        )
        .subscribe({
          next: (alumnoCreado) => {
            this.successMessage.set(`Alumno ${alumnoCreado.codigo} creado correctamente.`);
            this.selectedAlumno.set(alumnoCreado);
            this.form = this.createEmptyForm();
            this.formMode.set(null);
            this.showFormPanel.set(false);
            this.alumnoModalMode.set('detail');
            if (this.canNotes()) {
              this.loadNotas(alumnoCreado.idAlumno);
            }
            if (this.canList()) {
              this.loadAlumnos(1);
            }
          },
          error: (error) => {
            this.errorMessage.set(this.readErrorMessage(error, 'No se pudo guardar el alumno.'));
          }
        });
      return;
    }

    this.alumnosService
      .updateAlumno(this.selectedAlumno()!.idAlumno, payload)
      .pipe(
        finalize(() => this.savingForm.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: () => {
          this.successMessage.set('Alumno actualizado correctamente.');
          this.formMode.set(null);
          this.showFormPanel.set(false);
          this.alumnoModalMode.set('detail');
          if (this.selectedAlumno() && this.canDetail()) {
            this.openAlumno(this.selectedAlumno()!.idAlumno);
          }
          if (this.canList()) {
            this.loadAlumnos(this.resultado()?.paginaActual ?? 1);
          }
        },
        error: (error) => {
          this.errorMessage.set(this.readErrorMessage(error, 'No se pudo guardar el alumno.'));
        }
      });
  }

  changeEstado(): void {
    const alumno = this.selectedAlumno();
    if (!alumno || !this.canEdit()) {
      return;
    }

    this.clearMessages();
    this.changingStatus.set(true);

    this.alumnosService
      .changeEstado(alumno.idAlumno, !alumno.activo)
      .pipe(
        finalize(() => this.changingStatus.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: () => {
          this.successMessage.set(
            `Alumno ${alumno.codigo} ${alumno.activo ? 'desactivado' : 'activado'} correctamente.`
          );
          if (this.canDetail()) {
            this.openAlumno(alumno.idAlumno);
          }
          if (this.canList()) {
            this.loadAlumnos(this.resultado()?.paginaActual ?? 1);
          }
        },
        error: (error) => {
          this.errorMessage.set(this.readErrorMessage(error, 'No se pudo cambiar el estado del alumno.'));
        }
      });
  }

  deleteSelected(): void {
    const alumno = this.selectedAlumno();
    if (!alumno || !this.canDelete()) {
      return;
    }

    this.clearMessages();
    this.deleting.set(true);

    this.alumnosService
      .deleteAlumno(alumno.idAlumno)
      .pipe(
        finalize(() => this.deleting.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: () => {
          this.successMessage.set(`Alumno ${alumno.codigo} eliminado correctamente.`);
          this.deleteConfirmOpen.set(false);
          this.selectedAlumno.set(null);
          this.notas.set([]);
          this.closeAlumnoModal();
          this.formMode.set(this.canCreate() ? 'create' : null);
          this.form = this.createEmptyForm();
          if (this.canList()) {
            this.loadAlumnos(this.resultado()?.paginaActual ?? 1);
          }
        },
        error: (error) => {
          this.errorMessage.set(this.readErrorMessage(error, 'No se pudo eliminar el alumno.'));
        }
      });
  }

  loadNotas(idAlumno: number): void {
    if (!this.canNotes()) {
      return;
    }

    this.notesLoading.set(true);

    this.alumnosService
      .getNotas(idAlumno)
      .pipe(
        finalize(() => this.notesLoading.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (notes) => this.notas.set(notes),
        error: (error) => {
          this.errorMessage.set(this.readErrorMessage(error, 'No se pudieron cargar las notas del alumno.'));
        }
      });
  }

  createNota(): void {
    const alumno = this.selectedAlumno();
    const nota = this.notaTexto.trim();
    if (!alumno || !this.canNotes()) {
      return;
    }

    if (!nota) {
      this.errorMessage.set('La nota no puede estar vacía.');
      return;
    }

    this.clearMessages();
    this.savingNote.set(true);

    this.alumnosService
      .createNota(alumno.idAlumno, { nota })
      .pipe(
        finalize(() => this.savingNote.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (note) => {
          this.notas.update((current) => [note, ...current]);
          this.notaTexto = '';
          this.successMessage.set(`Nota registrada para ${alumno.codigo}.`);
          this.showNotesPanel.set(false);
        },
        error: (error) => {
          this.errorMessage.set(this.readErrorMessage(error, 'No se pudo guardar la nota.'));
        }
      });
  }

  resetPassword(): void {
    const alumno = this.selectedAlumno();
    const nueva = this.nuevaContrasena.trim();
    const confirmar = this.confirmarContrasena.trim();

    if (!alumno || !this.canResetPassword()) {
      return;
    }

    if (nueva.length < 6) {
      this.errorMessage.set('La nueva contraseña debe tener al menos 6 caracteres.');
      return;
    }

    if (nueva !== confirmar) {
      this.errorMessage.set('La confirmación de la contraseña no coincide.');
      return;
    }

    this.clearMessages();
    this.resettingPassword.set(true);

    this.alumnosService
      .resetPassword(alumno.idAlumno, { nuevaContrasena: nueva })
      .pipe(
        finalize(() => this.resettingPassword.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: () => {
          this.nuevaContrasena = '';
          this.confirmarContrasena = '';
          this.successMessage.set(`Contraseña de ${alumno.codigo} actualizada correctamente.`);
          this.showPasswordPanel.set(false);
        },
        error: (error) => {
          this.errorMessage.set(this.readErrorMessage(error, 'No se pudo actualizar la contraseña.'));
        }
      });
  }

  previousPage(): void {
    const pagina = this.resultado()?.paginaActual ?? 1;
    if (pagina > 1) {
      this.loadAlumnos(pagina - 1);
    }
  }

  nextPage(): void {
    const result = this.resultado();
    if (result && result.paginaActual < result.totalPaginas) {
      this.loadAlumnos(result.paginaActual + 1);
    }
  }

  private scheduleLiveReload(page = 1): void {
    this.clearFilterReloadTimer();
    this.filterReloadTimer = setTimeout(() => {
      this.filterReloadTimer = null;
      this.loadAlumnos(page);
    }, 180);
  }

  private clearFilterReloadTimer(): void {
    if (this.filterReloadTimer) {
      clearTimeout(this.filterReloadTimer);
      this.filterReloadTimer = null;
    }
  }

  private loadCatalogs(): void {
    this.catalogsLoading.set(true);

    forkJoin({
      casas: this.alumnosService.getCasas(),
      cargos: this.alumnosService.getCargos()
    })
      .pipe(
        finalize(() => this.catalogsLoading.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: ({ casas, cargos }) => {
          this.casas.set(casas);
          this.cargos.set(cargos);
        },
        error: (error) => {
          this.errorMessage.set(this.readErrorMessage(error, 'No se pudieron cargar los catálogos de alumnos.'));
        }
      });
  }

  private buildPayload(): SaveAlumnoRequest | null {
    const codigo = this.form.codigo.trim();
    const nombre = this.form.nombre.trim();

    if (!codigo || !nombre) {
      this.errorMessage.set('Código y nombre son obligatorios.');
      return null;
    }

    const creating = this.formMode() === 'create';

    return {
      codigo,
      nombre,
      telefono: this.normalizeText(this.form.telefono),
      idCasa: this.form.idCasa,
      nivel: creating ? null : this.normalizeText(this.form.nivel),
      idCargo: creating ? this.getAlumnoCargoId() : this.form.idCargo,
      dracoins: creating ? 0 : this.form.dracoins ?? 0,
      activo: creating ? true : this.form.activo,
      genero: this.normalizeText(this.form.genero),
      cumpleanos: this.form.cumpleanos || null,
      pais: this.normalizeText(this.form.pais),
      prefijoPais: this.normalizeText(this.form.prefijoPais),
      zonaHoraria: creating
        ? this.getPaisOption(this.form.pais)?.zonaHoraria ?? this.inferZonaHorariaFromPais(this.form.pais) ?? null
        : this.normalizeText(this.form.zonaHoraria),
      correoElectronico: this.normalizeText(this.form.correoElectronico),
      fotoPerfil: creating ? null : this.normalizeText(this.form.fotoPerfil),
      contrasena: null
    };
  }

  private mapAlumnoToForm(alumno: AlumnoDetail): AlumnoFormModel {
    return {
      codigo: alumno.codigo,
      nombre: alumno.nombre,
      telefono: alumno.telefono,
      idCasa: alumno.idCasa,
      idCargo: alumno.idCargo,
      nivel: alumno.nivel,
      dracoins: alumno.dracoins,
      activo: alumno.activo,
      genero: alumno.genero,
      cumpleanos: this.toDateInputValue(alumno.cumpleanos),
      pais: alumno.pais,
      prefijoPais: alumno.prefijoPais,
      zonaHoraria: alumno.zonaHoraria,
      correoElectronico: alumno.correoElectronico,
      fotoPerfil: alumno.fotoPerfil,
      contrasena: ''
    };
  }

  private createEmptyForm(): AlumnoFormModel {
    return {
      codigo: '',
      nombre: '',
      telefono: '',
      idCasa: null,
      idCargo: null,
      nivel: '',
      dracoins: 0,
      activo: true,
      genero: '',
      cumpleanos: '',
      pais: '',
      prefijoPais: '',
      zonaHoraria: '',
      correoElectronico: '',
      fotoPerfil: '',
      contrasena: ''
    };
  }

  onPaisSelected(): void {
    const pais = this.getPaisOption(this.form.pais);
    if (!pais) {
      this.form = {
        ...this.form,
        prefijoPais: ''
      };
      return;
    }

    this.form = {
      ...this.form,
      prefijoPais: pais.prefijo,
      zonaHoraria: pais.zonaHoraria ?? this.form.zonaHoraria
    };
  }

  setActiveView(view: AlumnosViewMode): void {
    this.activeView.set(view);
  }

  emojiDraftValue(idAlumno: number): string {
    return this.emojiDrafts()[idAlumno] ?? '';
  }

  onEmojiDraftChange(alumno: AlumnoListItem, value: string): void {
    const normalized = this.normalizeEmojis(value) ?? '';
    this.emojiDrafts.update((current) => ({
      ...current,
      [alumno.idAlumno]: normalized
    }));
  }

  resetEmojiDraft(alumno: AlumnoListItem): void {
    this.emojiDrafts.update((current) => ({
      ...current,
      [alumno.idAlumno]: alumno.emojis ?? ''
    }));
  }

  saveAlumnoEmojis(alumno: AlumnoListItem): void {
    if (!this.canManageEmojis()) {
      return;
    }

    const emojis = this.normalizeEmojis(this.emojiDraftValue(alumno.idAlumno));
    if (this.countEmojiTextElements(emojis ?? '') > 2) {
      this.errorMessage.set('Cada alumno puede tener máximo dos emojis.');
      return;
    }

    this.clearMessages();
    this.emojiSavingId.set(alumno.idAlumno);

    this.alumnosService
      .updateAlumnoEmojis(alumno.idAlumno, { emojis })
      .pipe(
        finalize(() => this.emojiSavingId.set(null)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: () => {
          this.successMessage.set(`Emojis de ${alumno.codigo} actualizados.`);
          if (this.selectedAlumno()?.idAlumno === alumno.idAlumno && this.canDetail()) {
            this.openAlumno(alumno.idAlumno);
          }
          this.loadAlumnos(this.resultado()?.paginaActual ?? 1);
        },
        error: (error) => {
          this.errorMessage.set(this.readErrorMessage(error, 'No se pudieron guardar los emojis del alumno.'));
        }
      });
  }

  getPaisOption(nombrePais: string): PaisOption | undefined {
    const normalizedPais = nombrePais.trim().toLowerCase();
    return this.paises.find((pais) => pais.nombre.toLowerCase() === normalizedPais);
  }

  private getAlumnoCargoId(): number | null {
    const alumnoCargo = this.cargos().find((cargo) => cargo.nombre.trim().toLowerCase() === 'alumno');
    return alumnoCargo?.id ?? null;
  }

  private inferZonaHorariaFromPais(pais: string): string | null {
    const normalized = pais.trim().toLowerCase();
    const zoneByCountry: Record<string, string> = {
      argentina: 'America/Argentina/Buenos_Aires',
      bolivia: 'America/La_Paz',
      chile: 'America/Santiago',
      colombia: 'America/Bogota',
      ecuador: 'America/Guayaquil',
      españa: 'Europe/Madrid',
      mexico: 'America/Mexico_City',
      peru: 'America/Lima',
      venezuela: 'America/Caracas'
    };

    return zoneByCountry[normalized] ?? null;
  }

  private normalizeText(value: string): string | null {
    const trimmed = value.trim();
    return trimmed ? trimmed : null;
  }

  private normalizeEmojis(value: string): string | null {
    const normalized = value.replace(/\s+/g, '');
    return normalized ? normalized : null;
  }

  private syncEmojiDrafts(items: AlumnoListItem[]): void {
    this.emojiDrafts.update((current) => {
      const next = { ...current };
      for (const alumno of items) {
        next[alumno.idAlumno] = alumno.emojis ?? '';
      }

      return next;
    });
  }

  private countEmojiTextElements(value: string): number {
    const intlWithSegmenter = Intl as typeof Intl & {
      Segmenter?: new (
        locales?: string | string[],
        options?: { granularity: 'grapheme' }
      ) => { segment: (input: string) => Iterable<unknown> };
    };
    const segmenter = typeof Intl !== 'undefined' && intlWithSegmenter.Segmenter
      ? new intlWithSegmenter.Segmenter(undefined, { granularity: 'grapheme' })
      : null;

    if (segmenter) {
      return Array.from(segmenter.segment(value)).length;
    }

    return Array.from(value).length;
  }

  private toDateInputValue(value: string | null): string {
    if (!value) {
      return '';
    }

    return value.split('T')[0] ?? '';
  }

  private clearMessages(): void {
    this.errorMessage.set('');
    this.successMessage.set('');
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
