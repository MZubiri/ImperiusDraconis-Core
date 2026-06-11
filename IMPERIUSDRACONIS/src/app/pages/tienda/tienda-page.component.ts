import { CommonModule } from '@angular/common';
import { HttpErrorResponse } from '@angular/common/http';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { ChangeDetectionStrategy, Component, DestroyRef, computed, inject, signal } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import { finalize } from 'rxjs';
import { ActivatedRoute } from '@angular/router';
import { CatalogItem } from '../../core/models/alumnos.models';
import {
  TiendaAdminCatalogos,
  TiendaComprobante,
  TiendaHistorialResult,
  TiendaPanelResumen,
  TiendaPedido,
  TiendaProducto
} from '../../core/models/tienda.models';
import { AuthService } from '../../core/services/auth.service';
import { RuntimeConfigService } from '../../core/services/runtime-config.service';
import { TiendaService } from '../../core/services/tienda.service';
import { ImageFallbackDirective } from '../../shared/directives/image-fallback.directive';

type TiendaViewMode = 'store' | 'history' | 'admin';
type TiendaAdminSection = 'overview' | 'pending' | 'my-orders' | 'history';

@Component({
  selector: 'app-tienda-page',
  imports: [CommonModule, FormsModule, ImageFallbackDirective],
  templateUrl: './tienda-page.component.html',
  styleUrl: './tienda-page.component.css',
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class TiendaPageComponent {
  private readonly destroyRef = inject(DestroyRef);
  private readonly route = inject(ActivatedRoute);
  private readonly router = inject(Router);

  readonly auth = inject(AuthService);
  readonly tiendaService = inject(TiendaService);
  readonly runtimeConfig = inject(RuntimeConfigService);

  readonly products = signal<TiendaProducto[]>([]);
  readonly selectedProduct = signal<TiendaProducto | null>(null);
  readonly recipients = signal<CatalogItem[]>([]);
  readonly receipt = signal<TiendaComprobante | null>(null);
  readonly history = signal<TiendaHistorialResult | null>(null);
  readonly pendingOrders = signal<TiendaPedido[]>([]);
  readonly myOrders = signal<TiendaPedido[]>([]);
  readonly panelSummary = signal<TiendaPanelResumen | null>(null);
  readonly adminCatalogs = signal<TiendaAdminCatalogos | null>(null);
  readonly adminHistory = signal<TiendaHistorialResult | null>(null);
  readonly loadingProducts = signal(false);
  readonly loadingHistory = signal(false);
  readonly processing = signal(false);
  readonly loadingVendor = signal(false);
  readonly loadingAdmin = signal(false);
  readonly errorMessage = signal('');
  readonly successMessage = signal('');
  readonly viewMode = signal<TiendaViewMode>('store');
  readonly adminSection = signal<TiendaAdminSection>('overview');
  readonly purchaseModalOpen = signal(false);
  readonly receiptModalOpen = signal(false);

  readonly canManageProducts = computed(() =>
    this.auth.hasAnyPermission([
      'Productos:Index',
      'Productos:Detalles',
      'Productos:Crear',
      'Productos:Editar',
      'Productos:Eliminar',
      'Productos:EliminarConfirmado'
    ])
  );
  readonly canViewPending = computed(() => this.auth.hasPermission('Tienda:Pendientes'));
  readonly canViewMyOrders = computed(() => this.auth.hasPermission('Tienda:MisPedidos'));
  readonly canViewPanelAdmin = computed(() => this.auth.hasPermission('Tienda:PanelAdmin'));
  readonly canViewAdminHistory = computed(() => this.auth.hasPermission('Tienda:HistorialAdmin'));
  readonly hasAdminPanelAccess = computed(
    () =>
      this.canManageProducts() ||
      this.canViewPending() ||
      this.canViewMyOrders() ||
      this.canViewPanelAdmin() ||
      this.canViewAdminHistory()
  );
  readonly totalPending = computed(() => this.pendingOrders().length);
  readonly totalMyOrders = computed(() => this.myOrders().length);
  readonly historyCount = computed(() => this.history()?.totalRegistros ?? this.history()?.items.length ?? 0);
  readonly historyStatusOptions = ['', 'Pendiente', 'Tomado', 'Entregado', 'Cancelado'] as const;
  readonly priceBounds = computed(() => {
    const prices = this.products()
      .map((product) => product.precio)
      .filter((price) => Number.isFinite(price));

    if (!prices.length) {
      return { min: 0, max: 0 };
    }

    return {
      min: Math.floor(Math.min(...prices)),
      max: Math.ceil(Math.max(...prices))
    };
  });

  nombreProducto = '';
  precioMin: number | null = null;
  precioMax: number | null = null;
  comentario = '';
  purchaseMode: 'self' | 'gift' = 'self';
  idDestinatario: number | null = null;

  estadoHistorial = '';
  nombreHistorial = '';
  desdeHistorial = '';
  hastaHistorial = '';

  codigoAdmin = '';
  idVendedorAdmin: number | null = null;
  estadoAdmin: number | null = null;

  constructor() {
    this.viewMode.set(this.resolveInitialViewMode());
    this.loadProducts();
    this.loadCompraCatalogos();
    this.loadHistory();
  }

  private resolveInitialViewMode(): TiendaViewMode {
    const routePath = this.route.snapshot.url.map((segment) => segment.path).join('/').toLowerCase();
    return routePath.includes('historial') ? 'history' : 'store';
  }

  showStore(): void {
    this.viewMode.set('store');
  }

  showHistory(): void {
    this.viewMode.set('history');
    this.loadHistory(this.history()?.paginaActual ?? 1);
  }

  showAdminOverview(): void {
    if (!this.hasAdminPanelAccess()) {
      return;
    }

    this.viewMode.set('admin');
    this.adminSection.set('overview');

    if (this.canViewPanelAdmin() && !this.panelSummary()) {
      this.loadPanelAdmin();
    }
  }

  showAdminPending(): void {
    if (!this.canViewPending()) {
      return;
    }

    this.viewMode.set('admin');
    this.adminSection.set('pending');
    this.loadPendingOrders();
  }

  showAdminMyOrders(): void {
    if (!this.canViewMyOrders()) {
      return;
    }

    this.viewMode.set('admin');
    this.adminSection.set('my-orders');
    this.loadMyOrders();
  }

  showAdminHistory(): void {
    if (!this.canViewAdminHistory()) {
      return;
    }
    this.viewMode.set('admin');
    this.adminSection.set('history');

    if (!this.adminCatalogs()) {
      this.loadAdminCatalogs();
    }

    this.loadAdminHistory(this.adminHistory()?.paginaActual ?? 1);
  }

  goToProductos(): void {
    void this.router.navigate(['/productos']);
  }

  loadProducts(): void {
    this.loadingProducts.set(true);

    this.tiendaService
      .getProductos()
      .pipe(
        finalize(() => this.loadingProducts.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (response) => {
          this.products.set(response);
          this.syncSelectedProduct();
        },
        error: (error) =>
          this.errorMessage.set(this.readErrorMessage(error, 'No se pudo cargar el catálogo de tienda.'))
      });
  }

  onProductFiltersChange(): void {
    this.syncSelectedProduct();
  }

  onMinPriceSliderChange(value: number | string): void {
    const bounds = this.priceBounds();
    const raw = this.parseSliderValue(value, bounds.min);
    const clamped = this.clamp(raw, bounds.min, this.getSliderMaxValue());
    this.precioMin = clamped <= bounds.min ? null : clamped;
    this.onProductFiltersChange();
  }

  onMaxPriceSliderChange(value: number | string): void {
    const bounds = this.priceBounds();
    const raw = this.parseSliderValue(value, bounds.max);
    const clamped = this.clamp(raw, this.getSliderMinValue(), bounds.max);
    this.precioMax = clamped >= bounds.max ? null : clamped;
    this.onProductFiltersChange();
  }

  getSliderMinValue(): number {
    return this.precioMin ?? this.priceBounds().min;
  }

  getSliderMaxValue(): number {
    return this.precioMax ?? this.priceBounds().max;
  }

  getSliderMinPercent(): number {
    return this.toSliderPercent(this.getSliderMinValue());
  }

  getSliderMaxPercent(): number {
    return this.toSliderPercent(this.getSliderMaxValue());
  }

  resetProductFilters(): void {
    this.nombreProducto = '';
    this.precioMin = null;
    this.precioMax = null;
    this.syncSelectedProduct();
  }

  filteredProducts(): TiendaProducto[] {
    const normalizedName = this.nombreProducto.trim().toLowerCase();

    return this.products().filter((product) => {
      const matchesName =
        !normalizedName ||
        product.nombre.toLowerCase().includes(normalizedName) ||
        product.descripcion.toLowerCase().includes(normalizedName);
      const matchesMin = this.precioMin === null || product.precio >= this.precioMin;
      const matchesMax = this.precioMax === null || product.precio <= this.precioMax;

      return matchesName && matchesMin && matchesMax;
    });
  }

  loadCompraCatalogos(): void {
    this.tiendaService
      .getCompraCatalogos()
      .pipe(takeUntilDestroyed(this.destroyRef))
      .subscribe({
        next: (response) => this.recipients.set(response.destinatarios),
        error: () => void 0
      });
  }

  loadHistory(page = 1): void {
    this.loadingHistory.set(true);

    this.tiendaService
      .getHistorial({
        estado: this.estadoHistorial,
        nombre: this.nombreHistorial,
        desde: this.desdeHistorial || null,
        hasta: this.hastaHistorial || null,
        pagina: page,
        registrosPorPagina: 10
      })
      .pipe(
        finalize(() => this.loadingHistory.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (response) => this.history.set(response),
        error: (error) =>
          this.errorMessage.set(this.readErrorMessage(error, 'No se pudo cargar tu historial de pedidos.'))
      });
  }

  onHistoryFiltersChange(): void {
    this.loadHistory(1);
  }

  loadPendingOrders(): void {
    this.loadingVendor.set(true);

    this.tiendaService
      .getPendientes()
      .pipe(
        finalize(() => this.loadingVendor.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (response) => this.pendingOrders.set(response),
        error: (error) =>
          this.errorMessage.set(this.readErrorMessage(error, 'No se pudo cargar la bandeja de pendientes.'))
      });
  }

  loadMyOrders(): void {
    this.loadingVendor.set(true);

    this.tiendaService
      .getMisPedidos()
      .pipe(
        finalize(() => this.loadingVendor.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (response) => this.myOrders.set(response),
        error: (error) =>
          this.errorMessage.set(this.readErrorMessage(error, 'No se pudo cargar la cola del vendedor.'))
      });
  }

  loadPanelAdmin(): void {
    this.loadingAdmin.set(true);

    this.tiendaService
      .getPanelAdmin()
      .pipe(
        finalize(() => this.loadingAdmin.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (response) => this.panelSummary.set(response),
        error: () => void 0
      });
  }

  loadAdminCatalogs(): void {
    this.tiendaService
      .getAdminCatalogos()
      .pipe(takeUntilDestroyed(this.destroyRef))
      .subscribe({
        next: (response) => this.adminCatalogs.set(response),
        error: () => void 0
      });
  }

  loadAdminHistory(page = 1): void {
    this.loadingAdmin.set(true);

    this.tiendaService
      .getHistorialAdmin({
        codigo: this.codigoAdmin,
        idVendedor: this.idVendedorAdmin,
        estado: this.estadoAdmin,
        pagina: page,
        registrosPorPagina: 10
      })
      .pipe(
        finalize(() => this.loadingAdmin.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (response) => this.adminHistory.set(response),
        error: (error) =>
          this.errorMessage.set(this.readErrorMessage(error, 'No se pudo cargar el historial administrativo.'))
      });
  }

  selectProduct(product: TiendaProducto): void {
    this.selectedProduct.set(product);
    this.purchaseModalOpen.set(true);
    this.receiptModalOpen.set(false);
  }

  closePurchaseModal(): void {
    this.purchaseModalOpen.set(false);
  }

  closeReceiptModal(): void {
    this.receiptModalOpen.set(false);
  }

  onPurchaseModeChange(): void {
    if (this.purchaseMode === 'self') {
      this.idDestinatario = null;
    }
  }

  comprar(): void {
    const product = this.selectedProduct();
    if (!product) {
      return;
    }

    const esRegalo = this.purchaseMode === 'gift';

    if (esRegalo && !this.idDestinatario) {
      this.errorMessage.set('Selecciona un destinatario para registrar el regalo.');
      return;
    }

    this.processing.set(true);
    this.errorMessage.set('');
    this.successMessage.set('');

    this.tiendaService
      .createCompra({
        idProducto: product.idProducto,
        idDestinatario: esRegalo ? this.idDestinatario : null,
        comentario: this.comentario || null
      })
      .pipe(
        finalize(() => this.processing.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (response) => {
          this.receipt.set(response);
          this.purchaseModalOpen.set(false);
          this.receiptModalOpen.set(true);
          this.successMessage.set('Pedido registrado correctamente.');
          this.comentario = '';
          this.purchaseMode = 'self';
          this.idDestinatario = null;
          this.refreshCurrentUser();
          this.loadHistory();
          if (this.canViewPanelAdmin()) {
            this.loadPanelAdmin();
          }
          if (this.canViewPending()) {
            this.loadPendingOrders();
          }
        },
        error: (error) =>
          this.errorMessage.set(this.readErrorMessage(error, 'No se pudo procesar la compra.'))
      });
  }

  openReceipt(idPedido: number): void {
    this.processing.set(true);
    this.errorMessage.set('');

    this.tiendaService
      .getComprobante(idPedido)
      .pipe(
        finalize(() => this.processing.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (response) => {
          this.receipt.set(response);
          this.receiptModalOpen.set(true);
        },
        error: (error) =>
          this.errorMessage.set(this.readErrorMessage(error, 'No se pudo cargar el comprobante.'))
      });
  }

  downloadReceiptPng(): void {
    const receipt = this.receipt();
    if (!receipt) {
      return;
    }

    const canvas = this.createReceiptCanvas(receipt);
    const link = document.createElement('a');
    link.href = canvas.toDataURL('image/png');
    link.download = `comprobante-${receipt.idPedido}.png`;
    link.click();
  }

  async shareReceipt(): Promise<void> {
    const receipt = this.receipt();
    if (!receipt) {
      return;
    }

    const text = this.receiptShareText(receipt);

    try {
      const canvas = this.createReceiptCanvas(receipt);
      const blob = await new Promise<Blob | null>((resolve) => canvas.toBlob(resolve, 'image/png'));
      const file = blob ? new File([blob], `comprobante-${receipt.idPedido}.png`, { type: 'image/png' }) : null;
      const navigatorWithShare = navigator as Navigator & {
        canShare?: (data: ShareData) => boolean;
      };

      if (file && navigator.share && navigatorWithShare.canShare?.({ files: [file] })) {
        await navigator.share({
          title: `Comprobante #${receipt.idPedido}`,
          text,
          files: [file]
        });
        return;
      }

      if (navigator.share) {
        await navigator.share({
          title: `Comprobante #${receipt.idPedido}`,
          text
        });
        return;
      }
    } catch (error) {
      if (error instanceof DOMException && error.name === 'AbortError') {
        return;
      }
    }

    const shareUrl = `https://wa.me/?text=${encodeURIComponent(text)}`;
    window.open(shareUrl, '_blank', 'noopener,noreferrer');

    try {
      await navigator.clipboard?.writeText(text);
      this.successMessage.set('Comprobante listo para compartir y copiado al portapapeles.');
    } catch {
      this.successMessage.set('Comprobante listo para compartir.');
    }
  }

  cancelarPedido(idPedido: number): void {
    if (!confirm('¿Cancelar este pedido?')) {
      return;
    }

    this.processing.set(true);
    this.tiendaService
      .cancelarPedido(idPedido)
      .pipe(
        finalize(() => this.processing.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: () => {
          this.successMessage.set('Pedido cancelado correctamente.');
          this.refreshCurrentUser();
          this.loadHistory(this.history()?.paginaActual ?? 1);
          if (this.canViewPanelAdmin()) {
            this.loadPanelAdmin();
          }
        },
        error: (error) =>
          this.errorMessage.set(this.readErrorMessage(error, 'No se pudo cancelar el pedido.'))
      });
  }

  tomarPedido(idPedido: number): void {
    this.processing.set(true);
    this.tiendaService
      .tomarPedido(idPedido)
      .pipe(
        finalize(() => this.processing.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: () => {
          this.successMessage.set('Pedido tomado correctamente.');
          if (this.canViewPanelAdmin()) {
            this.loadPanelAdmin();
          }
          this.loadPendingOrders();
          this.loadMyOrders();
        },
        error: (error) =>
          this.errorMessage.set(this.readErrorMessage(error, 'No se pudo tomar el pedido.'))
      });
  }

  cambiarEstadoVendedor(idPedido: number, nuevoEstado: number): void {
    this.processing.set(true);
    this.tiendaService
      .cambiarEstadoVendedor(idPedido, { nuevoEstado })
      .pipe(
        finalize(() => this.processing.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: () => {
          this.successMessage.set('Estado del pedido actualizado.');
          this.refreshCurrentUser();
          if (this.canViewPanelAdmin()) {
            this.loadPanelAdmin();
          }
          this.loadMyOrders();
          if (this.canViewPending()) {
            this.loadPendingOrders();
          }
          if (this.canViewAdminHistory()) {
            this.loadAdminHistory(this.adminHistory()?.paginaActual ?? 1);
          }
        },
        error: (error) =>
          this.errorMessage.set(this.readErrorMessage(error, 'No se pudo actualizar el pedido.'))
      });
  }

  cambiarEstadoAdmin(idPedido: number, nuevoEstado: number): void {
    this.processing.set(true);
    this.tiendaService
      .cambiarEstadoAdmin(idPedido, { nuevoEstado })
      .pipe(
        finalize(() => this.processing.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: () => {
          this.successMessage.set('Estado administrativo actualizado.');
          if (this.canViewPanelAdmin()) {
            this.loadPanelAdmin();
          }
          this.loadAdminHistory(this.adminHistory()?.paginaActual ?? 1);
        },
        error: (error) =>
          this.errorMessage.set(this.readErrorMessage(error, 'No se pudo guardar el cambio administrativo.'))
      });
  }

  imageUrl(path: string): string {
    return this.runtimeConfig.resolveApiAssetUrl(path);
  }

  private refreshCurrentUser(): void {
    this.auth.hydrateSession().pipe(takeUntilDestroyed(this.destroyRef)).subscribe();
  }

  private syncSelectedProduct(): void {
    const current = this.selectedProduct();
    const visibleProducts = this.filteredProducts();

    if (current && visibleProducts.some((product) => product.idProducto === current.idProducto)) {
      return;
    }

    this.selectedProduct.set(visibleProducts[0] ?? null);
  }

  private readErrorMessage(error: unknown, fallback: string): string {
    if (error instanceof HttpErrorResponse && typeof error.error?.message === 'string') {
      return error.error.message;
    }

    return fallback;
  }

  private parseSliderValue(value: number | string, fallback: number): number {
    const parsed = typeof value === 'number' ? value : Number(value);
    return Number.isFinite(parsed) ? parsed : fallback;
  }

  private clamp(value: number, min: number, max: number): number {
    return Math.min(Math.max(value, min), max);
  }

  private toSliderPercent(value: number): number {
    const bounds = this.priceBounds();
    if (bounds.max <= bounds.min) {
      return 50;
    }

    const percent = ((value - bounds.min) / (bounds.max - bounds.min)) * 100;
    return this.clamp(percent, 0, 100);
  }

  private createReceiptCanvas(receipt: TiendaComprobante): HTMLCanvasElement {
    const canvas = document.createElement('canvas');
    canvas.width = 800;
    canvas.height = 1100;
    const context = canvas.getContext('2d');

    if (!context) {
      return canvas;
    }

    // 1. Fondo principal con gradiente
    const bgGradient = context.createLinearGradient(0, 0, canvas.width, canvas.height);
    bgGradient.addColorStop(0, '#090f1d');
    bgGradient.addColorStop(1, '#131e35');
    context.fillStyle = bgGradient;
    context.fillRect(0, 0, canvas.width, canvas.height);

    // 2. Línea dorada decorativa arriba
    context.fillStyle = '#e8c567';
    context.fillRect(0, 0, canvas.width, 10);

    // 3. Dibujar la tarjeta / ticket interno con esquinas redondeadas
    context.strokeStyle = 'rgba(232, 197, 103, 0.25)';
    context.lineWidth = 2;
    this.roundRect(context, 40, 50, 720, 1000, 24);
    context.stroke();

    // 4. Cabecera
    context.fillStyle = '#e8c567';
    context.font = '700 20px Inter, Arial, sans-serif';
    context.textAlign = 'center';
    context.fillText('EMPORIO DEL DRAGÓN', 400, 110);

    context.fillStyle = '#f8fafc';
    context.font = '800 32px Inter, Arial, sans-serif';
    context.fillText('COMPROBANTE DE COMPRA', 400, 165);

    // Subtítulo con ID de pedido
    context.fillStyle = '#94a3b8';
    context.font = '600 18px monospace';
    context.fillText(`Pedido #${receipt.idPedido}`, 400, 205);

    // Línea divisoria punteada
    this.drawDashedLine(context, 80, 240, 720, 240);

    // 5. Caja del Monto (Total Box)
    context.fillStyle = 'rgba(232, 197, 103, 0.06)';
    this.roundRect(context, 100, 270, 600, 130, 16);
    context.fill();
    context.strokeStyle = 'rgba(232, 197, 103, 0.3)';
    context.lineWidth = 1;
    this.roundRect(context, 100, 270, 600, 130, 16);
    context.stroke();

    // Texto dentro de la caja de monto
    context.fillStyle = '#94a3b8';
    context.font = '700 16px Inter, Arial, sans-serif';
    context.fillText('TOTAL PAGADO', 400, 310);

    context.fillStyle = '#e8c567';
    context.font = '800 54px Inter, Arial, sans-serif';
    context.fillText(`${this.formatNumber(receipt.total)} DC`, 400, 370);

    // 6. Filas de Información
    context.textAlign = 'left';
    
    // Producto
    this.drawReceiptRow(context, 'Producto', receipt.producto, 100, 470);

    // Estado
    this.drawReceiptRow(context, 'Estado', receipt.estado, 100, 570);

    // Comprador
    this.drawReceiptRow(context, 'Comprador', receipt.comprador, 100, 670);

    // Destinatario
    if (receipt.destinatario) {
      this.drawReceiptRow(context, 'Destinatario', receipt.destinatario, 100, 770);
    }

    // Comentario (si existe)
    let comentarioY = receipt.destinatario ? 870 : 770;
    if (receipt.comentario) {
      this.drawReceiptRow(context, 'Comentario', receipt.comentario, 100, comentarioY);
      comentarioY += 70;
    }

    // Línea divisoria inferior
    this.drawDashedLine(context, 80, 960, 720, 960);

    // 7. Pie de comprobante
    context.textAlign = 'center';
    context.fillStyle = '#10b981';
    context.font = '700 18px Inter, Arial, sans-serif';
    context.fillText('¡Gracias por tu compra!', 400, 1005);

    return canvas;
  }

  private drawDashedLine(
    context: CanvasRenderingContext2D,
    x1: number,
    y1: number,
    x2: number,
    y2: number
  ): void {
    context.beginPath();
    context.setLineDash([8, 8]);
    context.strokeStyle = 'rgba(232, 197, 103, 0.22)';
    context.lineWidth = 2;
    context.moveTo(x1, y1);
    context.lineTo(x2, y2);
    context.stroke();
    context.setLineDash([]);
  }

  private drawReceiptRow(
    context: CanvasRenderingContext2D,
    label: string,
    value: string,
    x: number,
    y: number
  ): void {
    context.fillStyle = '#94a3b8';
    context.font = '700 16px Inter, Arial, sans-serif';
    context.fillText(label.toUpperCase(), x, y);
    context.fillStyle = '#f8fafc';
    context.font = '700 24px Inter, Arial, sans-serif';
    this.wrapText(context, value || 'Sin registrar', x, y + 28, 600, 32);
  }

  private wrapText(
    context: CanvasRenderingContext2D,
    text: string,
    x: number,
    y: number,
    maxWidth: number,
    lineHeight: number
  ): void {
    const words = text.split(' ');
    let line = '';

    for (const word of words) {
      const testLine = line ? `${line} ${word}` : word;
      if (context.measureText(testLine).width > maxWidth && line) {
        context.fillText(line, x, y);
        line = word;
        y += lineHeight;
      } else {
        line = testLine;
      }
    }

    if (line) {
      context.fillText(line, x, y);
    }
  }

  private roundRect(
    context: CanvasRenderingContext2D,
    x: number,
    y: number,
    width: number,
    height: number,
    radius: number
  ): void {
    context.beginPath();
    context.moveTo(x + radius, y);
    context.lineTo(x + width - radius, y);
    context.quadraticCurveTo(x + width, y, x + width, y + radius);
    context.lineTo(x + width, y + height - radius);
    context.quadraticCurveTo(x + width, y + height, x + width - radius, y + height);
    context.lineTo(x + radius, y + height);
    context.quadraticCurveTo(x, y + height, x, y + height - radius);
    context.lineTo(x, y + radius);
    context.quadraticCurveTo(x, y, x + radius, y);
    context.closePath();
  }

  private receiptShareText(receipt: TiendaComprobante): string {
    return [
      `Comprobante #${receipt.idPedido}`,
      `Producto: ${receipt.producto}`,
      `Total: ${this.formatNumber(receipt.total)} DC`,
      `Estado: ${receipt.estado}`,
      `Comprador: ${receipt.comprador}`,
      receipt.destinatario ? `Destinatario: ${receipt.destinatario}` : ''
    ]
      .filter(Boolean)
      .join('\n');
  }

  private formatNumber(value: number): string {
    return new Intl.NumberFormat('es-PE', {
      maximumFractionDigits: 2
    }).format(value);
  }
}
