import { CommonModule } from '@angular/common';
import { HttpErrorResponse } from '@angular/common/http';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { ChangeDetectionStrategy, Component, DestroyRef, computed, inject, signal } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { finalize } from 'rxjs';
import { AuditoriaService } from '../../core/services/auditoria.service';
import { AuthService } from '../../core/services/auth.service';
import {
  ResumenAuditoriaListado,
  ResumenAuditoriaAcceso,
  RelacionAccesoNodo,
  DecisionAdministrativa,
  ExcepcionAuditoria,
  CuentaEspecial
} from '../../core/models/auditoria.models';

@Component({
  selector: 'app-auditoria-page',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './auditoria-page.component.html',
  styleUrl: './auditoria-page.component.css',
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class AuditoriaPageComponent {
  private readonly destroyRef = inject(DestroyRef);
  private readonly auditoriaService = inject(AuditoriaService);
  readonly auth = inject(AuthService);

  readonly canView = computed(() => this.auth.hasPermission('Auditoria:VerResumen'));
  readonly canManage = computed(() => this.auth.hasPermission('Auditoria:GestionarDecisiones'));

  readonly resumenes = signal<ResumenAuditoriaListado[]>([]);
  readonly selectedAlumnoId = signal<number | null>(null);
  readonly selectedResumen = signal<ResumenAuditoriaAcceso | null>(null);
  readonly arbolRelaciones = signal<RelacionAccesoNodo | null>(null);
  readonly decisionesHistorial = signal<DecisionAdministrativa[]>([]);

  readonly loading = signal(false);
  readonly loadingDetail = signal(false);
  readonly savingDecision = signal(false);
  readonly savingException = signal(false);
  readonly savingCuentaEspecial = signal(false);

  readonly errorMessage = signal('');
  readonly successMessage = signal('');

  readonly activeTab = signal<'arbol' | 'decisiones' | 'configuraciones'>('arbol');

  // Filtros
  readonly searchQuery = signal('');
  readonly selectedPriority = signal<'TODAS' | 'CRITICA' | 'ALTA' | 'MEDIA' | 'BAJA'>('TODAS');

  // Formulario Decisiones
  decisionModel: DecisionAdministrativa = {
    idAlumno: 0,
    decision: 'EN_OBSERVACION',
    motivo: '',
    notasInternas: ''
  };

  // Formulario Cuenta Especial
  cuentaEspecialModel: CuentaEspecial = {
    idAlumno: 0,
    tipoCuenta: 'CASA',
    descripcion: '',
    multiplicadorAuditoria: 0.25
  };

  // Formulario Excepciones
  excepcionModel: ExcepcionAuditoria = {
    tipoExcepcion: 'RELACION_AUTORIZADA',
    valorA: '',
    valorB: '',
    motivo: ''
  };

  // Listado filtrado
  readonly filteredResumenes = computed(() => {
    const query = this.searchQuery().trim().toLowerCase();
    const priority = this.selectedPriority();
    
    return this.resumenes().filter((item) => {
      // Filtro de búsqueda
      const matchSearch =
        !query ||
        item.nombreAlumno.toLowerCase().includes(query) ||
        item.idAlumno.toString().includes(query) ||
        item.motivosDetalle.toLowerCase().includes(query);

      if (!matchSearch) return false;

      // Filtro de prioridad
      const score = item.relevanciaAuditoria;
      if (priority === 'CRITICA') return score >= 90;
      if (priority === 'ALTA') return score >= 70 && score < 90;
      if (priority === 'MEDIA') return score >= 40 && score < 70;
      if (priority === 'BAJA') return score < 40;

      return true;
    });
  });

  constructor() {
    if (this.canView()) {
      this.loadResumenes();
    }
  }

  loadResumenes(): void {
    this.loading.set(true);
    this.errorMessage.set('');

    this.auditoriaService
      .getResumenes()
      .pipe(
        finalize(() => this.loading.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (data) => {
          this.resumenes.set(data);
        },
        error: (err) => {
          this.errorMessage.set(this.readErrorMessage(err, 'No se pudo cargar la lista de auditorías.'));
        }
      });
  }

  selectAlumno(idAlumno: number): void {
    this.selectedAlumnoId.set(idAlumno);
    this.activeTab.set('arbol');
    this.loadAlumnoDetail(idAlumno);
  }

  loadAlumnoDetail(idAlumno: number): void {
    this.loadingDetail.set(true);
    this.errorMessage.set('');
    this.successMessage.set('');

    // Resetear modelos
    this.decisionModel = {
      idAlumno: idAlumno,
      decision: 'EN_OBSERVACION',
      motivo: '',
      notasInternas: ''
    };

    this.cuentaEspecialModel = {
      idAlumno: idAlumno,
      tipoCuenta: 'CASA',
      descripcion: '',
      multiplicadorAuditoria: 0.25
    };

    this.excepcionModel = {
      tipoExcepcion: 'RELACION_AUTORIZADA',
      valorA: idAlumno.toString(),
      valorB: '',
      motivo: ''
    };

    // Cargar resumen, árbol e historial
    this.auditoriaService
      .getResumen(idAlumno)
      .pipe(takeUntilDestroyed(this.destroyRef))
      .subscribe({
        next: (resumen) => this.selectedResumen.set(resumen),
        error: (err) => this.errorMessage.set(this.readErrorMessage(err, 'Error al cargar resumen.'))
      });

    this.auditoriaService
      .getArbol(idAlumno)
      .pipe(takeUntilDestroyed(this.destroyRef))
      .subscribe({
        next: (arbol) => this.arbolRelaciones.set(arbol),
        error: (err) => this.errorMessage.set(this.readErrorMessage(err, 'Error al cargar árbol de relaciones.'))
      });

    this.auditoriaService
      .getDecisiones(idAlumno)
      .pipe(
        finalize(() => this.loadingDetail.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (decisiones) => this.decisionesHistorial.set(decisiones),
        error: (err) => this.errorMessage.set(this.readErrorMessage(err, 'Error al cargar historial de decisiones.'))
      });
  }

  recalcular(): void {
    const id = this.selectedAlumnoId();
    if (!id) return;

    this.loadingDetail.set(true);
    this.auditoriaService
      .recalcular(id)
      .pipe(takeUntilDestroyed(this.destroyRef))
      .subscribe({
        next: (res) => {
          this.successMessage.set(res.message);
          this.loadAlumnoDetail(id);
          this.loadResumenes();
        },
        error: (err) => {
          this.loadingDetail.set(false);
          this.errorMessage.set(this.readErrorMessage(err, 'Error al recalcular relevancia.'));
        }
      });
  }

  submitDecision(): void {
    if (this.savingDecision() || !this.canManage()) return;

    this.savingDecision.set(true);
    this.errorMessage.set('');
    this.successMessage.set('');

    this.auditoriaService
      .registrarDecision(this.decisionModel)
      .pipe(
        finalize(() => this.savingDecision.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (res) => {
          this.successMessage.set(res.message);
          const id = this.selectedAlumnoId();
          if (id) {
            this.loadAlumnoDetail(id);
          }
          this.loadResumenes();
        },
        error: (err) => {
          this.errorMessage.set(this.readErrorMessage(err, 'No se pudo guardar la decisión administrativa.'));
        }
      });
  }

  submitCuentaEspecial(): void {
    if (this.savingCuentaEspecial() || !this.canManage()) return;

    this.savingCuentaEspecial.set(true);
    this.errorMessage.set('');
    this.successMessage.set('');

    // Ajustar multiplicador según tipo de cuenta si el usuario no lo editó directamente
    if (this.cuentaEspecialModel.tipoCuenta === 'CASA') {
      this.cuentaEspecialModel.multiplicadorAuditoria = 0.25;
    } else if (this.cuentaEspecialModel.tipoCuenta === 'ASISTENTE') {
      this.cuentaEspecialModel.multiplicadorAuditoria = 0.50;
    } else if (this.cuentaEspecialModel.tipoCuenta === 'ADMINISTRATIVA') {
      this.cuentaEspecialModel.multiplicadorAuditoria = 0.10;
    } else if (this.cuentaEspecialModel.tipoCuenta === 'INSTITUCIONAL') {
      this.cuentaEspecialModel.multiplicadorAuditoria = 0.00; // Totalmente excluida
    } else {
      this.cuentaEspecialModel.multiplicadorAuditoria = 1.00;
    }

    this.auditoriaService
      .registrarCuentaEspecial(this.cuentaEspecialModel)
      .pipe(
        finalize(() => this.savingCuentaEspecial.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (res) => {
          this.successMessage.set(res.message);
          const id = this.selectedAlumnoId();
          if (id) {
            this.loadAlumnoDetail(id);
          }
          this.loadResumenes();
        },
        error: (err) => {
          this.errorMessage.set(this.readErrorMessage(err, 'No se pudo registrar la cuenta especial.'));
        }
      });
  }

  submitExcepcion(): void {
    if (this.savingException() || !this.canManage()) return;

    this.savingException.set(true);
    this.errorMessage.set('');
    this.successMessage.set('');

    this.auditoriaService
      .registrarExcepcion(this.excepcionModel)
      .pipe(
        finalize(() => this.savingException.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (res) => {
          this.successMessage.set(res.message);
          const id = this.selectedAlumnoId();
          if (id) {
            this.loadAlumnoDetail(id);
          }
          this.loadResumenes();
        },
        error: (err) => {
          this.errorMessage.set(this.readErrorMessage(err, 'No se pudo crear la excepción permanente.'));
        }
      });
  }

  getPriorityLabel(score: number): string {
    if (score >= 90) return 'Crítica';
    if (score >= 70) return 'Alta';
    if (score >= 40) return 'Media';
    return 'Baja';
  }

  getPriorityClass(score: number): string {
    if (score >= 90) return 'critical';
    if (score >= 70) return 'high';
    if (score >= 40) return 'medium';
    return 'low';
  }

  getDecisionLabel(decision: string): string {
    if (decision === 'EN_OBSERVACION') return 'En Observación';
    if (decision === 'PERMITIDA_FAMILIAR') return 'Permitida (Familiar)';
    if (decision === 'SOSPECHOSA_CONFIRMADA') return 'Sospechosa Confirmada';
    if (decision === 'ACCION_MANUAL') return 'Acción Manual Aplicada';
    return decision;
  }

  private readErrorMessage(error: unknown, fallback: string): string {
    if (error instanceof HttpErrorResponse && typeof error.error?.message === 'string') {
      return error.error.message;
    }
    if (error instanceof HttpErrorResponse && typeof error.error?.Message === 'string') {
      return error.error.Message;
    }
    return fallback;
  }
}
