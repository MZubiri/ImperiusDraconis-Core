import { CommonModule } from '@angular/common';
import { HttpErrorResponse } from '@angular/common/http';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { ChangeDetectionStrategy, Component, DestroyRef, computed, inject, signal } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { catchError, finalize, forkJoin, map, Observable, of, switchMap } from 'rxjs';
import { resolveApiAssetUrl } from '../../core/constants/api.constants';
import { RinconPedido, RinconProducto, RinconResumenAdmin } from '../../core/models/rincon.models';
import { AuthService } from '../../core/services/auth.service';
import { RinconService } from '../../core/services/rincon.service';
import { ImageFallbackDirective } from '../../shared/directives/image-fallback.directive';

interface RinconCartItem extends RinconProducto {
  cantidad: number;
}

type FormMode = 'create' | 'edit';
type RinconViewMode = 'store' | 'history' | 'admin';
type RinconAdminSection = 'overview' | 'products' | 'pending' | 'history';

@Component({
  selector: 'app-rincon-page',
  imports: [CommonModule, FormsModule, ImageFallbackDirective],
  templateUrl: './rincon-page.component.html',
  styleUrl: './rincon-page.component.css',
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class RinconPageComponent {
  private readonly destroyRef = inject(DestroyRef);
  private temporaryImagePreviewUrl: string | null = null;

  readonly auth = inject(AuthService);
  readonly rinconService = inject(RinconService);

  readonly canViewCatalog = computed(() =>
    this.auth.hasAnyPermission(['Rincon:Catalogo', 'Rincon:GestionarProductos'])
  );
  readonly canBuy = computed(() => this.auth.hasPermission('Rincon:Comprar'));
  readonly canViewHistory = computed(() => this.auth.hasPermission('Rincon:Historial'));
  readonly canCancel = computed(() =>
    this.auth.hasAnyPermission(['Rincon:CancelarPedido', 'Rincon:GestionarPedidos'])
  );
  readonly canViewSummary = computed(() => this.auth.hasPermission('Rincon:PanelAdmin'));
  readonly canManageProducts = computed(() => this.auth.hasPermission('Rincon:GestionarProductos'));
  readonly canManageOrders = computed(() => this.auth.hasPermission('Rincon:GestionarPedidos'));
  readonly canViewAdmin = computed(() =>
    this.auth.hasAnyPermission(['Rincon:PanelAdmin', 'Rincon:GestionarProductos', 'Rincon:GestionarPedidos'])
  );
  readonly products = signal<RinconProducto[]>([]);
  readonly adminProducts = signal<RinconProducto[]>([]);
  readonly history = signal<RinconPedido[]>([]);
  readonly cart = signal<RinconCartItem[]>([]);
  readonly receipt = signal<RinconPedido | null>(null);
  readonly summary = signal<RinconResumenAdmin | null>(null);
  readonly pendingOrders = signal<RinconPedido[]>([]);
  readonly adminHistory = signal<RinconPedido[]>([]);
  readonly editingProduct = signal<RinconProducto | null>(null);
  readonly loading = signal(false);
  readonly processing = signal(false);
  readonly errorMessage = signal('');
  readonly successMessage = signal('');
  readonly viewMode = signal<RinconViewMode>('store');
  readonly adminSection = signal<RinconAdminSection>('overview');
  readonly cartModalOpen = signal(false);
  readonly receiptModalOpen = signal(false);
  readonly categories = computed(() =>
    [...new Set(this.products().map((item) => item.categoria).filter(Boolean))].sort()
  );
  readonly cartCount = computed(() =>
    this.cart().reduce((total, item) => total + item.cantidad, 0)
  );
  readonly totalCart = computed(() =>
    this.cart().reduce((total, item) => total + item.precio * item.cantidad, 0)
  );
  readonly historyCount = computed(() => this.history().length);
  readonly adminCategories = computed(() =>
    [...new Set(this.adminProducts().map((item) => item.categoria).filter(Boolean))].sort()
  );

  searchTerm = '';
  categoria = '';
  soloDisponibles = true;
  adminEstado: number | null = null;
  adminSearchTerm = '';
  adminCategoryFilter = '';
  adminStockFilter: 'all' | 'available' | 'out' = 'all';

  formMode: FormMode = 'create';
  nombre = '';
  descripcion = '';
  precio: number | null = null;
  stock: number | null = null;
  categoriaProducto = '';
  imagenFile: File | null = null;
  imagenActual = '';

  constructor() {
    this.destroyRef.onDestroy(() => this.revokeTemporaryImagePreview());
    if (this.canViewCatalog()) {
      this.loadProducts();
    }
    if (this.canViewHistory()) {
      this.loadHistory();
    }
    if (!this.canViewCatalog() && this.canViewHistory()) {
      this.viewMode.set('history');
    } else if (!this.canViewCatalog() && this.canViewAdmin()) {
      this.showAdminOverview();
    }
  }

  showStore(): void {
    if (!this.canViewCatalog()) {
      return;
    }
    this.viewMode.set('store');
  }

  showHistory(): void {
    if (!this.canViewHistory()) {
      return;
    }
    this.viewMode.set('history');
    this.loadHistory();
  }

  openCartModal(): void {
    this.cartModalOpen.set(true);
    this.receiptModalOpen.set(false);
  }

  closeCartModal(): void {
    this.cartModalOpen.set(false);
  }

  closeReceiptModal(): void {
    this.receiptModalOpen.set(false);
  }

  showAdminOverview(): void {
    if (!this.canViewAdmin()) {
      return;
    }

    this.viewMode.set('admin');
    this.adminSection.set('overview');

    if (this.canViewSummary() && !this.summary()) {
      this.loadSummary();
    }
  }

  showAdminProducts(): void {
    if (!this.canManageProducts()) {
      return;
    }

    this.viewMode.set('admin');
    this.adminSection.set('products');

    if (!this.adminProducts().length) {
      this.loadAdminProducts();
    }
  }

  showAdminPending(): void {
    if (!this.canManageOrders()) {
      return;
    }

    this.viewMode.set('admin');
    this.adminSection.set('pending');
    this.loadPendingOrders();
  }

  showAdminHistory(estado: number | null = this.adminEstado): void {
    if (!this.canManageOrders()) {
      return;
    }

    this.adminEstado = estado;
    this.viewMode.set('admin');
    this.adminSection.set('history');
    this.loadAdminHistory();
  }

  loadProducts(): void {
    if (!this.canViewCatalog()) {
      return;
    }
    this.loading.set(true);

    this.rinconService
      .getProductos({
        categoria: this.categoria || null,
        soloDisponibles: this.soloDisponibles
      })
      .pipe(
        finalize(() => this.loading.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (response) => this.products.set(response),
        error: (error) =>
          this.errorMessage.set(this.readErrorMessage(error, 'No se pudo cargar el catálogo del Rincón.'))
      });
  }

  onStoreFiltersChange(): void {
    this.loadProducts();
  }

  visibleProducts(): RinconProducto[] {
    const term = this.normalizeSearchText(this.searchTerm);
    if (!term) {
      return this.products();
    }

    return this.products().filter((product) => {
      const content = this.normalizeSearchText(`${product.nombre} ${product.descripcion} ${product.categoria}`);
      return content.includes(term);
    });
  }

  loadAdminProducts(): void {
    if (!this.canManageProducts()) {
      return;
    }
    this.rinconService
      .getProductos({ soloDisponibles: false })
      .pipe(takeUntilDestroyed(this.destroyRef))
      .subscribe({
        next: (response) => this.adminProducts.set(response),
        error: (error) =>
          this.errorMessage.set(
            this.readErrorMessage(error, 'No se pudo cargar la administración de productos del Rincón.')
          )
      });
  }

  visibleAdminProducts(): RinconProducto[] {
    const term = this.normalizeSearchText(this.adminSearchTerm);

    return this.adminProducts()
      .filter((item) => {
        if (this.adminCategoryFilter && item.categoria !== this.adminCategoryFilter) {
          return false;
        }

        if (this.adminStockFilter === 'available' && item.stock <= 0) {
          return false;
        }

        if (this.adminStockFilter === 'out' && item.stock > 0) {
          return false;
        }

        if (!term) {
          return true;
        }

        const content = this.normalizeSearchText(`${item.nombre} ${item.descripcion} ${item.categoria}`);
        return content.includes(term);
      })
      .sort((a, b) => {
        if (a.stock === 0 && b.stock > 0) {
          return -1;
        }

        if (a.stock > 0 && b.stock === 0) {
          return 1;
        }

        return a.nombre.localeCompare(b.nombre);
      });
  }

  clearAdminFilters(): void {
    this.adminSearchTerm = '';
    this.adminCategoryFilter = '';
    this.adminStockFilter = 'all';
  }

  isEditingProduct(product: RinconProducto): boolean {
    return this.editingProduct()?.idProducto === product.idProducto;
  }

  loadHistory(): void {
    if (!this.canViewHistory()) {
      return;
    }
    this.rinconService
      .getHistorial()
      .pipe(
        switchMap((orders) => this.hydrateOrderDetails(orders)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (response) => this.history.set(response),
        error: (error) =>
          this.errorMessage.set(this.readErrorMessage(error, 'No se pudo cargar el historial del Rincón.'))
      });
  }

  loadSummary(): void {
    if (!this.canViewSummary()) {
      return;
    }
    this.rinconService
      .getResumenAdmin()
      .pipe(takeUntilDestroyed(this.destroyRef))
      .subscribe({
        next: (response) => this.summary.set(response),
        error: () => void 0
      });
  }

  loadPendingOrders(): void {
    if (!this.canManageOrders()) {
      return;
    }
    this.rinconService
      .getPedidosPendientes()
      .pipe(
        switchMap((orders) => this.hydrateOrderDetails(orders)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (response) => this.pendingOrders.set(response),
        error: (error) =>
          this.errorMessage.set(this.readErrorMessage(error, 'No se pudo cargar la cola pendiente del Rincón.'))
      });
  }

  loadAdminHistory(): void {
    if (!this.canManageOrders()) {
      return;
    }
    this.rinconService
      .getHistorialAdmin(this.adminEstado)
      .pipe(
        switchMap((orders) => this.hydrateOrderDetails(orders)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (response) => this.adminHistory.set(response),
        error: (error) =>
          this.errorMessage.set(this.readErrorMessage(error, 'No se pudo cargar el historial administrativo.'))
      });
  }

  addToCart(product: RinconProducto): void {
    if (!this.canBuy()) {
      return;
    }
    const current = this.cart();
    const existing = current.find((item) => item.idProducto === product.idProducto);
    if (existing) {
      this.cart.set(
        current.map((item) =>
          item.idProducto === product.idProducto
            ? { ...item, cantidad: Math.min(item.cantidad + 1, product.stock) }
            : item
        )
      );
      this.openCartModal();
      return;
    }

    this.cart.set([...current, { ...product, cantidad: 1 }]);
    this.openCartModal();
  }

  updateCartQuantity(idProducto: number, cantidad: number): void {
    const safeQuantity = Math.max(1, cantidad);
    this.cart.set(
      this.cart().map((item) =>
        item.idProducto === idProducto ? { ...item, cantidad: Math.min(safeQuantity, item.stock) } : item
      )
    );
  }

  removeFromCart(idProducto: number): void {
    this.cart.set(this.cart().filter((item) => item.idProducto !== idProducto));
  }

  checkout(): void {
    if (!this.canBuy() || !this.cart().length) {
      return;
    }

    this.processing.set(true);
    this.rinconService
      .createPedido({
        items: this.cart().map((item) => ({
          idProducto: item.idProducto,
          cantidad: item.cantidad
        }))
      })
      .pipe(
        finalize(() => this.processing.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (response) => {
          this.receipt.set(response);
          this.cart.set([]);
          this.cartModalOpen.set(false);
          this.receiptModalOpen.set(true);
          this.successMessage.set('Compra realizada correctamente en el Rincón.');
          this.auth.hydrateSession().pipe(takeUntilDestroyed(this.destroyRef)).subscribe();
          this.loadProducts();
          this.loadHistory();
          if (this.canViewAdmin()) {
            this.loadSummary();
            this.loadPendingOrders();
            this.loadAdminHistory();
            this.loadAdminProducts();
          }
        },
        error: (error) =>
          this.errorMessage.set(this.readErrorMessage(error, 'No se pudo finalizar la compra del Rincón.'))
      });
  }

  openReceipt(idPedido: number): void {
    this.processing.set(true);
    this.errorMessage.set('');

    this.rinconService
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
          this.errorMessage.set(this.readErrorMessage(error, 'No se pudo cargar el comprobante del Rincón.'))
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
    link.download = `comprobante-rincon-${receipt.idPedido}.png`;
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
      const file = blob ? new File([blob], `comprobante-rincon-${receipt.idPedido}.png`, { type: 'image/png' }) : null;
      const navigatorWithShare = navigator as Navigator & {
        canShare?: (data: ShareData) => boolean;
      };

      if (file && navigator.share && navigatorWithShare.canShare?.({ files: [file] })) {
        await navigator.share({
          title: `Comprobante Rincón #${receipt.idPedido}`,
          text,
          files: [file]
        });
        return;
      }

      if (navigator.share) {
        await navigator.share({
          title: `Comprobante Rincón #${receipt.idPedido}`,
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

  openCreate(): void {
    this.revokeTemporaryImagePreview();
    this.formMode = 'create';
    this.editingProduct.set(null);
    this.nombre = '';
    this.descripcion = '';
    this.precio = null;
    this.stock = null;
    this.categoriaProducto = '';
    this.imagenFile = null;
    this.imagenActual = '';
  }

  editProduct(product: RinconProducto): void {
    this.revokeTemporaryImagePreview();
    this.formMode = 'edit';
    this.editingProduct.set(product);
    this.nombre = product.nombre;
    this.descripcion = product.descripcion;
    this.precio = product.precio;
    this.stock = product.stock;
    this.categoriaProducto = product.categoria;
    this.imagenFile = null;
    this.imagenActual = product.imagenUrl;
  }

  onFileSelected(event: Event): void {
    const input = event.target as HTMLInputElement | null;
    const file = input?.files?.[0] ?? null;
    this.revokeTemporaryImagePreview();
    this.imagenFile = file;

    if (!file) {
      this.imagenActual = this.editingProduct()?.imagenUrl ?? '';
      return;
    }

    this.temporaryImagePreviewUrl = URL.createObjectURL(file);
    this.imagenActual = this.temporaryImagePreviewUrl;
  }

  saveProduct(): void {
    if (!this.canManageProducts() || !this.nombre.trim() || this.precio === null || this.stock === null) {
      this.errorMessage.set('Nombre, precio y stock son obligatorios.');
      return;
    }

    this.processing.set(true);

    const payload = {
      nombre: this.nombre,
      descripcion: this.descripcion || null,
      precio: this.precio,
      stock: this.stock,
      categoria: this.categoriaProducto || null,
      imagenUrlActual: this.imagenFile ? this.editingProduct()?.imagenUrl ?? null : this.imagenActual || null,
      imagenFile: this.imagenFile
    };

    if (this.formMode === 'create') {
      this.rinconService
        .createProducto(payload)
        .pipe(
          finalize(() => this.processing.set(false)),
          takeUntilDestroyed(this.destroyRef)
        )
        .subscribe({
          next: (response: RinconProducto) => {
            this.successMessage.set('Producto del Rincón creado correctamente.');
            this.loadProducts();
            this.loadAdminProducts();
            this.loadSummary();
            this.editProduct(response);
          },
          error: (error: unknown) =>
            this.errorMessage.set(this.readErrorMessage(error, 'No se pudo guardar el producto del Rincón.'))
        });
      return;
    }

    this.rinconService
      .updateProducto(this.editingProduct()?.idProducto ?? 0, payload)
      .pipe(
        finalize(() => this.processing.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: () => {
          this.successMessage.set('Producto del Rincón actualizado correctamente.');
          this.loadProducts();
          this.loadAdminProducts();
          this.loadSummary();
        },
        error: (error: unknown) =>
          this.errorMessage.set(this.readErrorMessage(error, 'No se pudo guardar el producto del Rincón.'))
      });
  }

  deleteProduct(): void {
    const product = this.editingProduct();
    if (!this.canManageProducts() || !product || !confirm(`¿Eliminar ${product.nombre}?`)) {
      return;
    }

    this.processing.set(true);
    this.rinconService
      .deleteProducto(product.idProducto)
      .pipe(
        finalize(() => this.processing.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: () => {
          this.successMessage.set('Producto del Rincón eliminado correctamente.');
          this.openCreate();
          this.loadProducts();
          this.loadAdminProducts();
          this.loadSummary();
        },
        error: (error) =>
          this.errorMessage.set(this.readErrorMessage(error, 'No se pudo eliminar el producto del Rincón.'))
      });
  }

  markDelivered(idPedido: number): void {
    if (!this.canManageOrders()) {
      return;
    }
    this.processing.set(true);
    this.rinconService
      .marcarEntregado(idPedido)
      .pipe(
        finalize(() => this.processing.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: () => {
          this.successMessage.set('Pedido marcado como entregado.');
          this.loadPendingOrders();
          this.loadAdminHistory();
          this.loadSummary();
        },
        error: (error) =>
          this.errorMessage.set(this.readErrorMessage(error, 'No se pudo marcar el pedido como entregado.'))
      });
  }

  cancelOrder(idPedido: number): void {
    if (!this.canCancel() || !confirm('¿Cancelar este pedido y reembolsar al comprador?')) {
      return;
    }

    this.processing.set(true);
    this.rinconService
      .cancelarPedido(idPedido)
      .pipe(
        finalize(() => this.processing.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: () => {
          this.successMessage.set('Pedido cancelado correctamente. Reembolso aplicado al comprador.');
          this.auth.hydrateSession().pipe(takeUntilDestroyed(this.destroyRef)).subscribe();
          this.loadProducts();
          this.loadHistory();
          if (this.canViewAdmin()) {
            this.loadAdminProducts();
            this.loadPendingOrders();
            this.loadAdminHistory();
            this.loadSummary();
          }
        },
        error: (error) =>
          this.errorMessage.set(this.readErrorMessage(error, 'No se pudo cancelar el pedido.'))
      });
  }

  imageUrl(path: string): string {
    return resolveApiAssetUrl(path);
  }

  private hydrateOrderDetails(orders: RinconPedido[]): Observable<RinconPedido[]> {
    if (!orders.length) {
      return of([]);
    }

    return forkJoin(
      orders.map((order) =>
        this.rinconService.getComprobante(order.idPedido).pipe(
          map((fullOrder) => ({
            ...order,
            detalles: fullOrder.detalles ?? []
          })),
          catchError(() => of(order))
        )
      )
    );
  }

  private revokeTemporaryImagePreview(): void {
    if (!this.temporaryImagePreviewUrl) {
      return;
    }

    URL.revokeObjectURL(this.temporaryImagePreviewUrl);
    this.temporaryImagePreviewUrl = null;
  }

  private readErrorMessage(error: unknown, fallback: string): string {
    if (error instanceof HttpErrorResponse && typeof error.error?.message === 'string') {
      return error.error.message;
    }

    return fallback;
  }

  private normalizeSearchText(value: string): string {
    return value
      .normalize('NFD')
      .replace(/[\u0300-\u036f]/g, '')
      .trim()
      .toLowerCase();
  }

  private createReceiptCanvas(receipt: RinconPedido): HTMLCanvasElement {
    const canvas = document.createElement('canvas');
    canvas.width = 1080;
    canvas.height = 1350;
    const context = canvas.getContext('2d');

    if (!context) {
      return canvas;
    }

    const gradient = context.createLinearGradient(0, 0, canvas.width, canvas.height);
    gradient.addColorStop(0, '#101827');
    gradient.addColorStop(1, '#172032');
    context.fillStyle = gradient;
    context.fillRect(0, 0, canvas.width, canvas.height);

    context.strokeStyle = '#e8c567';
    context.lineWidth = 8;
    this.roundRect(context, 54, 54, 972, 1242, 36);
    context.stroke();

    context.fillStyle = '#e8c567';
    context.font = '700 34px Inter, Arial, sans-serif';
    context.fillText('RINCON DEL RATON', 110, 150);

    context.fillStyle = '#f6f2e8';
    context.font = '700 74px Inter, Arial';
    context.fillText('Comprobante', 110, 245);

    context.fillStyle = '#c2c8d3';
    context.font = '400 30px Inter, Arial, sans-serif';
    context.fillText(`Pedido #${receipt.idPedido}`, 110, 315);
    context.fillText(new Date(receipt.fechaPedido).toLocaleString(), 110, 360);

    this.drawReceiptRow(context, 'Estado', receipt.estadoNombre, 110, 470);
    this.drawReceiptRow(context, 'Comprador', receipt.nombreAlumno, 110, 560);

    context.fillStyle = '#c2c8d3';
    context.font = '400 28px Inter, Arial, sans-serif';
    context.fillText('Productos', 110, 700);
    context.fillStyle = '#f6f2e8';
    context.font = '700 32px Inter, Arial, sans-serif';

    let y = 750;
    for (const detail of receipt.detalles.slice(0, 6)) {
      this.wrapText(
        context,
        `${detail.cantidad}x ${detail.nombre} - ${this.formatNumber(detail.subtotal)} DC`,
        110,
        y,
        850,
        38
      );
      y += 48;
    }

    if (receipt.detalles.length > 6) {
      context.fillText(`+ ${receipt.detalles.length - 6} productos mas`, 110, y);
    }

    context.fillStyle = '#e8c567';
    context.font = '800 78px Inter, Arial, sans-serif';
    context.fillText(`${this.formatNumber(receipt.total)} DC`, 110, 1080);

    context.fillStyle = '#5bb98c';
    context.font = '700 28px Inter, Arial, sans-serif';
    context.fillText('Gracias por tu compra', 110, 1210);

    return canvas;
  }

  private drawReceiptRow(
    context: CanvasRenderingContext2D,
    label: string,
    value: string,
    x: number,
    y: number
  ): void {
    context.fillStyle = '#c2c8d3';
    context.font = '400 28px Inter, Arial, sans-serif';
    context.fillText(label, x, y);
    context.fillStyle = '#f6f2e8';
    context.font = '700 36px Inter, Arial, sans-serif';
    this.wrapText(context, value || 'Sin registrar', x, y + 48, 850, 44);
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

  private receiptShareText(receipt: RinconPedido): string {
    return [
      `Comprobante Rincón #${receipt.idPedido}`,
      `Total: ${this.formatNumber(receipt.total)} DC`,
      `Estado: ${receipt.estadoNombre}`,
      `Comprador: ${receipt.nombreAlumno}`,
      receipt.detalles.length
        ? `Productos: ${receipt.detalles.map((item) => `${item.cantidad}x ${item.nombre}`).join(', ')}`
        : ''
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
