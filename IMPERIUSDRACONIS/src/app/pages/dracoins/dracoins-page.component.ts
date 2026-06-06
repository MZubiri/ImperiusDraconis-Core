import { CommonModule } from '@angular/common';
import { HttpErrorResponse } from '@angular/common/http';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { ChangeDetectionStrategy, Component, DestroyRef, computed, inject, signal } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { finalize } from 'rxjs';
import { PagedResult } from '../../core/models/alumnos.models';
import {
  DracoinAdministrativePayment,
  DracoinGeneralMovement,
  DracoinManualPaymentCandidate,
  DracoinSalaryByCargo,
  DracoinSummary,
  DracoinTransfer
} from '../../core/models/dracoins.models';
import { DracoinTransferFavorite } from '../../core/models/preferences.models';
import { AuthService } from '../../core/services/auth.service';
import { DracoinsService } from '../../core/services/dracoins.service';
import { PreferencesService } from '../../core/services/preferences.service';

interface EditableSalary extends DracoinSalaryByCargo {
  sueldoEditado: number | null;
}

type DracoinSection = 'personal' | 'historiales' | 'banco';
type BankTab = 'sueldos' | 'pagos-manuales' | 'historial-pagos';
type PersonalTransferDirection = 'todas' | 'recibidas' | 'enviadas';

@Component({
  selector: 'app-dracoins-page',
  imports: [CommonModule, FormsModule],
  templateUrl: './dracoins-page.component.html',
  styleUrl: './dracoins-page.component.css',
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class DracoinsPageComponent {
  private readonly destroyRef = inject(DestroyRef);

  readonly auth = inject(AuthService);
  readonly dracoinsService = inject(DracoinsService);
  readonly preferencesService = inject(PreferencesService);

  readonly summary = signal<DracoinSummary | null>(null);
  readonly transferHistory = signal<PagedResult<DracoinTransfer> | null>(null);
  readonly generalHistory = signal<PagedResult<DracoinGeneralMovement> | null>(null);
  readonly paymentHistory = signal<PagedResult<DracoinAdministrativePayment> | null>(null);
  readonly salaryCatalog = signal<EditableSalary[]>([]);
  readonly manualPaymentCandidates = signal<DracoinManualPaymentCandidate[]>([]);
  readonly loadingSummary = signal(false);
  readonly loadingTransfers = signal(false);
  readonly loadingGeneralHistory = signal(false);
  readonly loadingPayments = signal(false);
  readonly loadingSalaryCatalog = signal(false);
  readonly loadingManualPayments = signal(false);
  readonly submittingTransfer = signal(false);
  readonly savingSalaries = signal(false);
  readonly processingManualPayments = signal(false);
  readonly errorMessage = signal('');
  readonly transferErrorModalMessage = signal('');
  readonly successMessage = signal('');
  readonly activeSection = signal<DracoinSection>('personal');
  readonly activeBankTab = signal<BankTab>('sueldos');
  readonly transferFavorites = signal<DracoinTransferFavorite[]>([]);
  readonly personalHistoryModalOpen = signal(false);
  readonly latestTransferReceipt = signal<DracoinTransfer | null>(null);

  readonly canViewSummary = computed(() => this.auth.hasPermission('Dracoins:Index'));
  readonly canTransfer = computed(() => this.auth.hasPermission('Dracoins:TransferirDracoins'));
  readonly canViewHistory = computed(() => this.auth.hasPermission('Dracoins:HistorialTransferencias'));
  readonly canViewGeneralHistory = computed(() => this.auth.hasPermission('Dracoins:HistorialGeneral'));
  readonly canViewPayments = computed(() => this.auth.hasPermission('Dracoins:HistorialPagos'));
  readonly canViewSalaryCatalog = computed(() => this.auth.hasPermission('Dracoins:SueldosPorCargo'));
  readonly canUpdateSalaries = computed(() => this.auth.hasPermission('Dracoins:ActualizarSueldos'));
  readonly canPayManualSalaries = computed(() => this.auth.hasPermission('Dracoins:PagarSueldosManual'));
  readonly canViewModule = computed(
    () =>
      this.canViewSummary() ||
      this.canTransfer() ||
      this.canViewHistory() ||
      this.canViewGeneralHistory() ||
      this.canViewPayments() ||
      this.canViewSalaryCatalog() ||
      this.canUpdateSalaries() ||
      this.canPayManualSalaries()
  );
  readonly visibleBalance = computed(() => this.summary()?.saldoActual ?? this.auth.user()?.dracoins ?? 0);
  readonly recentTransfers = computed(() => this.summary()?.transferenciasRecientes ?? []);
  readonly selectedManualPayments = computed(() =>
    this.manualPaymentCandidates()
      .filter((item) => item.montoSugerido > 0)
      .map((item) => ({
        idAlumno: item.idAlumno,
        montoPagado: item.montoSugerido
      }))
  );
  readonly totalSelectedManualPayments = computed(() => this.selectedManualPayments().length);
  readonly totalManualPaymentAmount = computed(() =>
    this.selectedManualPayments().reduce((total, item) => total + item.montoPagado, 0)
  );
  readonly canViewPersonalSection = computed(
    () => this.canTransfer() || this.canViewSummary() || this.canViewHistory()
  );
  readonly canViewHistorySection = computed(() => this.canViewGeneralHistory());
  readonly canViewBankSection = computed(
    () =>
      this.canViewSalaryCatalog() ||
      this.canUpdateSalaries() ||
      this.canPayManualSalaries() ||
      this.canViewPayments()
  );

  codigoDestinatario = '';
  monto: number | null = null;
  observacion = '';
  personalHistoryDirection: PersonalTransferDirection = 'todas';
  personalHistoryCounterparty = '';
  personalHistoryObservation = '';
  personalHistoryMontoMin: number | null = null;
  personalHistoryMontoMax: number | null = null;

  remitente = '';
  destinatario = '';
  montoMin: number | null = null;
  montoMax: number | null = null;
  observacionGeneral = '';
  desde = '';
  hasta = '';

  constructor() {
    if (!this.canViewModule()) {
      return;
    }

    this.loadTransferFavorites();
    this.activeSection.set(this.initialSection());
    this.activeBankTab.set(this.initialBankTab());

    if (this.canViewSummary()) {
      this.loadSummary();
    }

    if (this.canViewHistory()) {
      this.loadTransferHistory();
    }

    if (this.canViewGeneralHistory()) {
      this.loadGeneralHistory();
    }

    if (this.canViewPayments()) {
      this.loadPaymentHistory();
    }

    if (this.canViewSalaryCatalog()) {
      this.loadSalaryCatalog();
    }

    if (this.canPayManualSalaries()) {
      this.loadManualPaymentCandidates();
    }
  }

  loadSummary(): void {
    if (!this.canViewSummary()) {
      return;
    }

    this.loadingSummary.set(true);

    this.dracoinsService
      .getSummary()
      .pipe(
        finalize(() => this.loadingSummary.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (response) => this.summary.set(response),
        error: (error) => this.errorMessage.set(this.readErrorMessage(error, 'No se pudo cargar el resumen.'))
      });
  }

  refreshBalance(): void {
    if (this.canViewSummary()) {
      this.loadSummary();
    }

    this.auth
      .hydrateSession()
      .pipe(takeUntilDestroyed(this.destroyRef))
      .subscribe();
  }

  loadTransferHistory(page = 1): void {
    if (!this.canViewHistory()) {
      return;
    }

    this.loadingTransfers.set(true);

    this.dracoinsService
      .getTransferHistory(page, 10)
      .pipe(
        finalize(() => this.loadingTransfers.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (response) => this.transferHistory.set(response),
        error: (error) =>
          this.errorMessage.set(this.readErrorMessage(error, 'No se pudo cargar el historial personal.'))
      });
  }

  loadGeneralHistory(page = 1): void {
    if (!this.canViewGeneralHistory()) {
      return;
    }

    this.loadingGeneralHistory.set(true);

    this.dracoinsService
      .getGeneralHistory({
        remitente: this.remitente,
        destinatario: this.destinatario,
        montoMin: this.montoMin,
        montoMax: this.montoMax,
        observacion: this.observacionGeneral,
        desde: this.desde || null,
        hasta: this.hasta || null,
        pagina: page,
        registrosPorPagina: 10
      })
      .pipe(
        finalize(() => this.loadingGeneralHistory.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (response) => this.generalHistory.set(response),
        error: (error) =>
          this.errorMessage.set(
            this.readErrorMessage(error, 'No se pudo cargar el historial general de Dracoins.')
          )
      });
  }

  resetGeneralFilters(): void {
    this.remitente = '';
    this.destinatario = '';
    this.montoMin = null;
    this.montoMax = null;
    this.observacionGeneral = '';
    this.desde = '';
    this.hasta = '';
    this.loadGeneralHistory();
  }

  loadPaymentHistory(page = 1): void {
    if (!this.canViewPayments()) {
      return;
    }

    this.loadingPayments.set(true);

    this.dracoinsService
      .getAdministrativePayments(page, 10)
      .pipe(
        finalize(() => this.loadingPayments.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (response) => this.paymentHistory.set(response),
        error: (error) =>
          this.errorMessage.set(
            this.readErrorMessage(error, 'No se pudo cargar el historial de pagos.')
          )
      });
  }

  loadSalaryCatalog(): void {
    if (!this.canViewSalaryCatalog()) {
      return;
    }

    this.loadingSalaryCatalog.set(true);

    this.dracoinsService
      .getSalaryCatalog()
      .pipe(
        finalize(() => this.loadingSalaryCatalog.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (response) =>
          this.salaryCatalog.set(
            response.map((item) => ({
              ...item,
              sueldoEditado: item.sueldoFijo
            }))
          ),
        error: (error) =>
          this.errorMessage.set(
            this.readErrorMessage(error, 'No se pudo cargar el catálogo de sueldos.')
          )
      });
  }

  updateSalaryAmount(idSueldo: number, value: number | null): void {
    this.salaryCatalog.set(
      this.salaryCatalog().map((item) =>
        item.idSueldo === idSueldo
          ? {
              ...item,
              sueldoEditado: value === null || Number.isNaN(value) ? null : Math.max(0, value)
            }
          : item
      )
    );
  }

  saveSalaries(): void {
    if (!this.canUpdateSalaries()) {
      return;
    }

    this.errorMessage.set('');
    this.successMessage.set('');
    this.latestTransferReceipt.set(null);
    this.savingSalaries.set(true);

    this.dracoinsService
      .updateSalaryCatalog({
        items: this.salaryCatalog().map((item) => ({
          idSueldo: item.idSueldo,
          sueldoFijo: item.sueldoEditado ?? 0
        }))
      })
      .pipe(
        finalize(() => this.savingSalaries.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (response) => {
          this.salaryCatalog.set(
            response.map((item) => ({
              ...item,
              sueldoEditado: item.sueldoFijo
            }))
          );
          this.successMessage.set('Sueldos por cargo actualizados correctamente.');
          if (this.canPayManualSalaries()) {
            this.loadManualPaymentCandidates();
          }
        },
        error: (error) =>
          this.errorMessage.set(
            this.readErrorMessage(error, 'No se pudieron guardar los sueldos por cargo.')
          )
      });
  }

  loadManualPaymentCandidates(): void {
    if (!this.canPayManualSalaries()) {
      return;
    }

    this.loadingManualPayments.set(true);

    this.dracoinsService
      .getManualPaymentCandidates()
      .pipe(
        finalize(() => this.loadingManualPayments.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (response) => this.manualPaymentCandidates.set(response),
        error: (error) =>
          this.errorMessage.set(
            this.readErrorMessage(error, 'No se pudo cargar la bandeja de pagos manuales.')
          )
      });
  }

  processManualPayments(): void {
    if (!this.canPayManualSalaries()) {
      return;
    }

    this.errorMessage.set('');
    this.successMessage.set('');
    this.latestTransferReceipt.set(null);
    this.processingManualPayments.set(true);

    this.dracoinsService
      .createManualPayments({
        items: this.selectedManualPayments()
      })
      .pipe(
        finalize(() => this.processingManualPayments.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (response) => {
          this.successMessage.set(
            `Sueldos procesados: ${response.totalPagosProcesados} por ${response.totalMontoPagado} DC.`
          );
          this.loadManualPaymentCandidates();
          if (this.canViewPayments()) {
            this.loadPaymentHistory(1);
          }
        },
        error: (error) =>
          this.errorMessage.set(
            this.readErrorMessage(error, 'No se pudieron procesar los pagos manuales.')
          )
      });
  }

  setActiveSection(section: DracoinSection): void {
    this.activeSection.set(section);
    this.refreshSection(section);
  }

  setActiveBankTab(tab: BankTab): void {
    this.activeBankTab.set(tab);
    this.refreshBankTab(tab);
  }

  closeTransferErrorModal(): void {
    this.transferErrorModalMessage.set('');
  }

  useFavorite(favorite: DracoinTransferFavorite): void {
    this.codigoDestinatario = favorite.codigo;
  }

  addFavoriteFromCurrentRecipient(): void {
    const codigo = this.normalizeFavoriteCode(this.codigoDestinatario);
    if (!codigo) {
      this.errorMessage.set('Escribe un código de destinatario para guardarlo como favorito.');
      return;
    }

    this.addTransferFavorite({
      codigo,
      nombre: ''
    });
  }

  addFavoriteFromTransfer(transfer: DracoinTransfer): void {
    this.addTransferFavorite({
      codigo: this.normalizeFavoriteCode(
        transfer.esRecibido ? transfer.codigoRemitente : transfer.codigoDestinatario
      ),
      nombre: transfer.esRecibido ? transfer.nombreRemitente : transfer.nombreDestinatario
    });
  }

  removeFavorite(codigo: string): void {
    const normalized = this.normalizeFavoriteCode(codigo);
    this.saveTransferFavorites(
      this.transferFavorites().filter((favorite) => favorite.codigo !== normalized)
    );
  }

  isFavorite(codigo: string): boolean {
    const normalized = this.normalizeFavoriteCode(codigo);
    return this.transferFavorites().some((favorite) => favorite.codigo === normalized);
  }

  submitTransfer(): void {
    if (!this.canTransfer()) {
      return;
    }

    this.errorMessage.set('');
    this.transferErrorModalMessage.set('');
    this.successMessage.set('');
    this.latestTransferReceipt.set(null);

    const codigoDestinatario = this.codigoDestinatario.trim();
    const monto = this.monto ?? 0;

    if (!codigoDestinatario) {
      this.showTransferError('La transferencia no es válida: escribe el código del destinatario.');
      return;
    }

    if (monto <= 0) {
      this.showTransferError('La transferencia no es válida: el monto debe ser mayor que cero.');
      return;
    }

    this.submittingTransfer.set(true);

    this.dracoinsService
      .createTransfer({
        codigoDestinatario,
        monto,
        observacion: this.observacion.trim() || null
      })
      .pipe(
        finalize(() => this.submittingTransfer.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (response) => {
          this.successMessage.set(`Transferencia #${response.idMovimiento} registrada correctamente.`);
          this.latestTransferReceipt.set(response);
          this.codigoDestinatario = '';
          this.monto = null;
          this.observacion = '';
          this.refreshPersonalState();
        },
        error: (error) => {
          this.showTransferError(
            this.readErrorMessage(error, 'No se pudo registrar la transferencia.')
          );
        }
      });
  }

  previousTransfersPage(): void {
    const currentPage = this.transferHistory()?.paginaActual ?? 1;
    if (currentPage > 1) {
      this.loadTransferHistory(currentPage - 1);
    }
  }

  nextTransfersPage(): void {
    const result = this.transferHistory();
    if (result && result.paginaActual < result.totalPaginas) {
      this.loadTransferHistory(result.paginaActual + 1);
    }
  }

  filteredPersonalTransfers(): DracoinTransfer[] {
    const counterparty = this.personalHistoryCounterparty.trim().toLowerCase();
    const observation = this.personalHistoryObservation.trim().toLowerCase();

    return (this.transferHistory()?.items ?? []).filter((transfer) => {
      if (this.personalHistoryDirection === 'recibidas' && !transfer.esRecibido) {
        return false;
      }

      if (this.personalHistoryDirection === 'enviadas' && transfer.esRecibido) {
        return false;
      }

      if (this.personalHistoryMontoMin !== null && transfer.monto < this.personalHistoryMontoMin) {
        return false;
      }

      if (this.personalHistoryMontoMax !== null && transfer.monto > this.personalHistoryMontoMax) {
        return false;
      }

      const counterpartyLabel = transfer.esRecibido
        ? `${transfer.codigoRemitente} ${transfer.nombreRemitente}`
        : `${transfer.codigoDestinatario} ${transfer.nombreDestinatario}`;

      return (
        (!counterparty || counterpartyLabel.toLowerCase().includes(counterparty)) &&
        (!observation || (transfer.observacion ?? '').toLowerCase().includes(observation))
      );
    });
  }

  openPersonalHistoryModal(): void {
    this.personalHistoryModalOpen.set(true);
    if (this.canViewHistory()) {
      this.loadTransferHistory(this.transferHistory()?.paginaActual ?? 1);
    }
  }

  closePersonalHistoryModal(): void {
    this.personalHistoryModalOpen.set(false);
  }

  resetPersonalHistoryFilters(): void {
    this.personalHistoryDirection = 'todas';
    this.personalHistoryCounterparty = '';
    this.personalHistoryObservation = '';
    this.personalHistoryMontoMin = null;
    this.personalHistoryMontoMax = null;
  }

  downloadLatestReceipt(): void {
    const transfer = this.latestTransferReceipt();
    if (!transfer) {
      return;
    }

    const canvas = document.createElement('canvas');
    canvas.width = 980;
    canvas.height = 620;
    const context = canvas.getContext('2d');
    if (!context) {
      return;
    }

    context.fillStyle = '#0b1220';
    context.fillRect(0, 0, canvas.width, canvas.height);
    context.fillStyle = '#e8c567';
    context.fillRect(0, 0, canvas.width, 12);
    context.font = '700 42px Arial';
    context.fillText('Comprobante de transferencia', 64, 86);
    context.font = '700 28px Arial';
    context.fillText(`${transfer.monto} DC`, 64, 142);

    context.font = '20px Arial';
    context.fillStyle = '#e9eef8';
    this.drawReceiptLine(context, 'Movimiento', `#${transfer.idMovimiento}`, 64, 218);
    this.drawReceiptLine(context, 'Remitente', `${transfer.codigoRemitente} | ${transfer.nombreRemitente}`, 64, 274);
    this.drawReceiptLine(context, 'Destinatario', `${transfer.codigoDestinatario} | ${transfer.nombreDestinatario}`, 64, 330);
    this.drawReceiptLine(context, 'Fecha', new Date(transfer.fechaTransferencia).toLocaleString(), 64, 386);
    this.drawReceiptLine(context, 'Observación', transfer.observacion || '-', 64, 442);

    context.fillStyle = '#9aa6b8';
    context.font = '18px Arial';
    context.fillText('Imperius Draconis', 64, 552);

    const link = document.createElement('a');
    link.href = canvas.toDataURL('image/png');
    link.download = `comprobante-transferencia-${transfer.idMovimiento}.png`;
    link.click();
  }

  previousGeneralHistoryPage(): void {
    const currentPage = this.generalHistory()?.paginaActual ?? 1;
    if (currentPage > 1) {
      this.loadGeneralHistory(currentPage - 1);
    }
  }

  nextGeneralHistoryPage(): void {
    const result = this.generalHistory();
    if (result && result.paginaActual < result.totalPaginas) {
      this.loadGeneralHistory(result.paginaActual + 1);
    }
  }

  previousPaymentsPage(): void {
    const currentPage = this.paymentHistory()?.paginaActual ?? 1;
    if (currentPage > 1) {
      this.loadPaymentHistory(currentPage - 1);
    }
  }

  nextPaymentsPage(): void {
    const result = this.paymentHistory();
    if (result && result.paginaActual < result.totalPaginas) {
      this.loadPaymentHistory(result.paginaActual + 1);
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

  private refreshPersonalState(): void {
    this.refreshBalance();

    if (this.canViewHistory()) {
      this.loadTransferHistory(1);
    }
  }

  private refreshSection(section: DracoinSection): void {
    if (section === 'personal') {
      this.refreshPersonalState();
      return;
    }

    if (section === 'historiales') {
      this.loadGeneralHistory(1);
      return;
    }

    this.refreshBankTab(this.activeBankTab());
  }

  private refreshBankTab(tab: BankTab): void {
    if (tab === 'sueldos' && this.canViewSalaryCatalog()) {
      this.loadSalaryCatalog();
      return;
    }

    if (tab === 'pagos-manuales' && this.canPayManualSalaries()) {
      this.loadManualPaymentCandidates();
      return;
    }

    if (tab === 'historial-pagos' && this.canViewPayments()) {
      this.loadPaymentHistory(1);
    }
  }

  private showTransferError(message: string): void {
    this.transferErrorModalMessage.set(message);
  }

  private initialSection(): DracoinSection {
    if (this.canViewPersonalSection()) {
      return 'personal';
    }

    if (this.canViewHistorySection()) {
      return 'historiales';
    }

    return 'banco';
  }

  private initialBankTab(): BankTab {
    if (this.canViewSalaryCatalog()) {
      return 'sueldos';
    }

    if (this.canPayManualSalaries()) {
      return 'pagos-manuales';
    }

    return 'historial-pagos';
  }

  private addTransferFavorite(favorite: DracoinTransferFavorite): void {
    const codigo = this.normalizeFavoriteCode(favorite.codigo);
    const nombre = favorite.nombre.trim();
    const currentUserCode = this.normalizeFavoriteCode(this.auth.user()?.codigo ?? '');

    if (!codigo || codigo === currentUserCode) {
      return;
    }

    const withoutDuplicate = this.transferFavorites().filter((item) => item.codigo !== codigo);
    this.saveTransferFavorites([{ codigo, nombre }, ...withoutDuplicate].slice(0, 12), codigo);
  }

  private loadTransferFavorites(): void {
    this.preferencesService
      .getDracoinTransferFavorites()
      .pipe(takeUntilDestroyed(this.destroyRef))
      .subscribe({
        next: (response) => this.transferFavorites.set(response.favoritos),
        error: () => this.errorMessage.set('No se pudieron cargar tus favoritos de transferencia.')
      });
  }

  private saveTransferFavorites(favorites: DracoinTransferFavorite[], addedCode?: string): void {
    this.errorMessage.set('');
    this.successMessage.set('');

    this.preferencesService
      .saveDracoinTransferFavorites({ favoritos: favorites })
      .pipe(takeUntilDestroyed(this.destroyRef))
      .subscribe({
        next: (response) => {
          this.transferFavorites.set(response.favoritos);
          if (!addedCode) {
            return;
          }

          const wasSaved = response.favoritos.some(
            (favorite) => this.normalizeFavoriteCode(favorite.codigo) === addedCode
          );
          if (wasSaved) {
            this.successMessage.set(`Favorito ${addedCode} guardado para transferencias.`);
            return;
          }

          this.errorMessage.set('No se pudo guardar el favorito porque el código no existe o no está activo.');
        },
        error: (error) =>
          this.errorMessage.set(
            this.readErrorMessage(error, 'No se pudieron guardar tus favoritos de transferencia.')
          )
      });
  }

  private normalizeFavoriteCode(value: string): string {
    return value.trim().toUpperCase();
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

  private drawReceiptLine(
    context: CanvasRenderingContext2D,
    label: string,
    value: string,
    x: number,
    y: number
  ): void {
    context.fillStyle = '#9aa6b8';
    context.font = '700 18px Arial';
    context.fillText(label.toUpperCase(), x, y);
    context.fillStyle = '#f8fafc';
    context.font = '22px Arial';
    context.fillText(value.slice(0, 70), x, y + 28);
  }
}
