import { CommonModule } from '@angular/common';
import { HttpErrorResponse } from '@angular/common/http';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { ChangeDetectionStrategy, Component, DestroyRef, computed, inject, signal } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { finalize } from 'rxjs';
import { resolveApiAssetUrl } from '../../core/constants/api.constants';
import { Producto } from '../../core/models/productos.models';
import { AuthService } from '../../core/services/auth.service';
import { ProductosService } from '../../core/services/productos.service';
import { ImageFallbackDirective } from '../../shared/directives/image-fallback.directive';

type FormMode = 'create' | 'edit';

@Component({
  selector: 'app-productos-page',
  imports: [CommonModule, FormsModule, ImageFallbackDirective],
  templateUrl: './productos-page.component.html',
  styleUrl: './productos-page.component.css',
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class ProductosPageComponent {
  private readonly destroyRef = inject(DestroyRef);
  private temporaryImagePreviewUrl: string | null = null;

  readonly auth = inject(AuthService);
  readonly productosService = inject(ProductosService);

  readonly canView = computed(() =>
    this.auth.hasAnyPermission([
      'Productos:Index',
      'Productos:Detalles',
      'Productos:Crear',
      'Productos:Editar',
      'Productos:Eliminar',
      'Productos:EliminarConfirmado'
    ])
  );
  readonly canCreate = computed(() => this.auth.hasPermission('Productos:Crear'));
  readonly canEdit = computed(() => this.auth.hasPermission('Productos:Editar'));
  readonly canDelete = computed(() =>
    this.auth.hasAnyPermission(['Productos:Eliminar', 'Productos:EliminarConfirmado'])
  );
  readonly products = signal<Producto[]>([]);
  readonly selectedProduct = signal<Producto | null>(null);
  readonly loading = signal(false);
  readonly saving = signal(false);
  readonly deleting = signal(false);
  readonly errorMessage = signal('');
  readonly successMessage = signal('');
  readonly activeCount = computed(() => this.products().filter((item) => item.activo).length);

  formMode: FormMode = 'create';
  nombre = '';
  descripcion = '';
  precio: number | null = null;
  activo = true;
  imageFile: File | null = null;
  searchTerm = '';
  imagePreview = '';

  constructor() {
    this.destroyRef.onDestroy(() => this.revokeTemporaryImagePreview());

    if (this.canView()) {
      this.loadProducts();
    }
  }

  loadProducts(): void {
    this.loading.set(true);

    this.productosService
      .getAll()
      .pipe(
        finalize(() => this.loading.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (response) => {
          this.products.set(response);
          if (!this.selectedProduct() && response.length > 0) {
            this.selectProduct(response[0]);
          }
        },
        error: (error) =>
          this.errorMessage.set(this.readErrorMessage(error, 'No se pudo cargar el catálogo de productos.'))
      });
  }

  selectProduct(product: Producto): void {
    this.revokeTemporaryImagePreview();
    this.selectedProduct.set(product);
    this.formMode = 'edit';
    this.nombre = product.nombre;
    this.descripcion = product.descripcion;
    this.precio = product.precio;
    this.activo = product.activo;
    this.imageFile = null;
    this.imagePreview = product.imagen;
  }

  openCreate(): void {
    this.revokeTemporaryImagePreview();
    this.formMode = 'create';
    this.selectedProduct.set(null);
    this.nombre = '';
    this.descripcion = '';
    this.precio = null;
    this.activo = true;
    this.imageFile = null;
    this.imagePreview = '';
  }

  onFileSelected(event: Event): void {
    const input = event.target as HTMLInputElement | null;
    const file = input?.files?.[0] ?? null;
    this.revokeTemporaryImagePreview();
    this.imageFile = file;

    if (!file) {
      this.imagePreview = this.selectedProduct()?.imagen ?? '';
      return;
    }

    this.temporaryImagePreviewUrl = URL.createObjectURL(file);
    this.imagePreview = this.temporaryImagePreviewUrl;
  }

  save(): void {
    if (!this.nombre.trim() || this.precio === null) {
      this.errorMessage.set('Nombre y precio son obligatorios.');
      return;
    }

    this.saving.set(true);
    this.errorMessage.set('');
    this.successMessage.set('');

    const payload = {
      nombre: this.nombre,
      descripcion: this.descripcion || null,
      precio: this.precio,
      activo: this.activo,
      imagenActual: this.imageFile ? this.selectedProduct()?.imagen ?? null : this.imagePreview || null,
      fotoArchivo: this.imageFile
    };

    if (this.formMode === 'create') {
      this.productosService
        .create(payload)
        .pipe(
          finalize(() => this.saving.set(false)),
          takeUntilDestroyed(this.destroyRef)
        )
        .subscribe({
          next: (response: Producto) => {
            this.successMessage.set('Producto creado correctamente.');
            this.loadProducts();
            this.selectProduct(response);
          },
          error: (error: unknown) =>
            this.errorMessage.set(this.readErrorMessage(error, 'No se pudieron guardar los cambios.'))
        });
      return;
    }

    this.productosService
      .update(this.selectedProduct()?.idProducto ?? 0, payload)
      .pipe(
        finalize(() => this.saving.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: () => {
          this.successMessage.set('Producto actualizado correctamente.');
          this.loadProducts();
        },
        error: (error: unknown) =>
          this.errorMessage.set(this.readErrorMessage(error, 'No se pudieron guardar los cambios.'))
      });
  }

  deleteSelected(): void {
    const product = this.selectedProduct();
    if (!product || !this.canDelete() || !confirm(`¿Eliminar ${product.nombre}?`)) {
      return;
    }

    this.deleting.set(true);

    this.productosService
      .delete(product.idProducto)
      .pipe(
        finalize(() => this.deleting.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: () => {
          this.successMessage.set('Producto eliminado correctamente.');
          this.openCreate();
          this.loadProducts();
        },
        error: (error) =>
          this.errorMessage.set(this.readErrorMessage(error, 'No se pudo eliminar el producto.'))
      });
  }

  visibleProducts(): Producto[] {
    const term = this.searchTerm.trim().toLowerCase();
    if (!term) {
      return this.products();
    }

    return this.products().filter((product) => {
      const content = `${product.nombre} ${product.descripcion}`.toLowerCase();
      return content.includes(term);
    });
  }

  imageUrl(path: string): string {
    return resolveApiAssetUrl(path);
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
}
