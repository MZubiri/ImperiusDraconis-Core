import { CommonModule } from '@angular/common';
import { Component, inject, OnInit, signal, computed } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { DomSanitizer, SafeResourceUrl } from '@angular/platform-browser';
import {
  LucideBookOpen,
  LucideLock,
  LucideUnlock,
  LucideSearch,
  LucideCoins,
  LucideX,
  LucideArrowLeft,
  LucidePlus,
  LucideEdit,
  LucideTrash2,
  LucideCheck,
  LucideDynamicIcon,
  provideLucideIcons
} from '@lucide/angular';
import { finalize } from 'rxjs';
import { BibliotecaCategoria, BibliotecaLibro, SaveLibroRequest, SuscripcionStatus } from '../../core/models/biblioteca.models';
import { BibliotecaService } from '../../core/services/biblioteca.service';
import { AuthService } from '../../core/services/auth.service';

@Component({
  selector: 'app-biblioteca-page',
  standalone: true,
  imports: [CommonModule, FormsModule, LucideDynamicIcon],
  templateUrl: './biblioteca-page.component.html',
  styleUrls: ['./biblioteca-page.component.css'],
  providers: [
    provideLucideIcons(
      LucideBookOpen,
      LucideLock,
      LucideUnlock,
      LucideSearch,
      LucideCoins,
      LucideX,
      LucideArrowLeft,
      LucidePlus,
      LucideEdit,
      LucideTrash2,
      LucideCheck
    )
  ]
})
export class BibliotecaPageComponent implements OnInit {
  private readonly bibliotecaService = inject(BibliotecaService);
  private readonly authService = inject(AuthService);
  private readonly sanitizer = inject(DomSanitizer);

  // Estados reactivos
  desbloqueado = signal<boolean>(false);
  passwordInput = signal<string>('');
  loading = signal<boolean>(false);
  errorMsg = signal<string>('');

  categorias = signal<BibliotecaCategoria[]>([]);
  libros = signal<BibliotecaLibro[]>([]);
  categoriaSeleccionada = signal<number | null>(null);
  busquedaInput = signal<string>('');
  tabActivo = signal<'todos' | 'mis-libros'>('todos');

  // Suscripción
  suscripcion = signal<SuscripcionStatus | null>(null);

  // Lectura
  libroActivo = signal<BibliotecaLibro | null>(null);
  libroUrlSafe = signal<SafeResourceUrl | null>(null);

  // Alumno logueado y rol
  alumnoDracoins = computed(() => this.authService.user()?.dracoins ?? 0);
  esAdmin = computed(() => {
    const cargo = this.authService.user()?.cargoNombre?.toLowerCase() ?? '';
    const esMaestre = cargo === 'maestre' || cargo === 'director' || cargo === 'administrador';
    const tienePermiso = this.authService.permissions().some(p => p.toLowerCase() === 'biblioteca:admin');
    return esMaestre || tienePermiso;
  });

  // Modales CRUD
  mostrarCrudModal = signal<boolean>(false);
  editandoLibroId = signal<number | null>(null);
  
  // Campos de formulario
  formTitulo = '';
  formAutor = '';
  formSinopsis = '';
  formIdCategoria: number | null = null;
  formRutaArchivo = '';
  formFormato = '.pdf';
  formPrecioDracoins = 0;
  formActivo = true;

  ngOnInit(): void {
    const isUnlocked = sessionStorage.getItem('biblioteca_desbloqueada') === 'true';
    if (isUnlocked) {
      this.desbloqueado.set(true);
      this.cargarDatos();
    }
  }

  desbloquear(): void {
    if (!this.passwordInput().trim()) {
      this.errorMsg.set('Introduce la contraseña.');
      return;
    }

    this.loading.set(true);
    this.errorMsg.set('');

    this.bibliotecaService.unlock(this.passwordInput()).subscribe({
      next: (res) => {
        if (res.success) {
          sessionStorage.setItem('biblioteca_desbloqueada', 'true');
          this.desbloqueado.set(true);
          this.cargarDatos();
        }
      },
      error: (err) => {
        this.loading.set(false);
        this.errorMsg.set(err.error?.message || 'Contraseña incorrecta. Inténtalo de nuevo.');
      }
    });
  }

  cargarDatos(): void {
    this.loading.set(true);
    this.errorMsg.set('');

    // Cargar categorias
    this.bibliotecaService.getCategorias().subscribe({
      next: (cats) => this.categorias.set(cats)
    });

    // Cargar estado de la suscripción
    this.bibliotecaService.getSuscripcionStatus().subscribe({
      next: (status) => this.suscripcion.set(status)
    });

    // Cargar libros
    this.buscarLibros();
  }

  buscarLibros(): void {
    this.loading.set(true);
    const soloMisLibros = this.tabActivo() === 'mis-libros';

    this.bibliotecaService.getLibros(this.categoriaSeleccionada(), this.busquedaInput(), soloMisLibros).subscribe({
      next: (lbs) => {
        this.libros.set(lbs);
        this.loading.set(false);
      },
      error: () => {
        this.errorMsg.set('Error al cargar los libros.');
        this.loading.set(false);
      }
    });
  }

  seleccionarCategoria(catId: number | null): void {
    this.categoriaSeleccionada.set(catId);
    this.buscarLibros();
  }

  cambiarTab(tab: 'todos' | 'mis-libros'): void {
    this.tabActivo.set(tab);
    this.buscarLibros();
  }

  comprar(libro: BibliotecaLibro): void {
    if (this.alumnoDracoins() < libro.precioDracoins) {
      alert(`No tienes suficientes Dracoins. Necesitas ${libro.precioDracoins} y tienes ${this.alumnoDracoins()}.`);
      return;
    }

    if (confirm(`¿Estás seguro de que deseas comprar "${libro.titulo}" por ${libro.precioDracoins} Dracoins?`)) {
      this.loading.set(true);
      this.bibliotecaService.comprarLibro(libro.id).subscribe({
        next: (res) => {
          if (res.success) {
            alert(res.message);
            this.authService.hydrateSession().subscribe();
            this.buscarLibros();
          }
        },
        error: (err) => {
          this.loading.set(false);
          alert(err.error?.message || 'Ocurrió un error al procesar la compra.');
        }
      });
    }
  }

  suscribirse(): void {
    const costo = this.suscripcion()?.costoSuscripcion ?? 50;

    if (this.alumnoDracoins() < costo) {
      alert(`No tienes suficientes Dracoins. La suscripción cuesta ${costo} DC y tienes ${this.alumnoDracoins()} DC.`);
      return;
    }

    const confirmMsg = this.suscripcion()?.activa 
      ? `¿Deseas extender tu suscripción semanal por otros 7 días por ${costo} Dracoins?`
      : `¿Deseas suscribirte a la biblioteca por una semana por ${costo} Dracoins? (Acceso ilimitado a todos los libros)`;

    if (confirm(confirmMsg)) {
      this.loading.set(true);
      this.bibliotecaService.suscribirse().subscribe({
        next: (res) => {
          if (res.success) {
            alert(res.message);
            this.authService.hydrateSession().subscribe();
            this.cargarDatos(); // Recarga libros y estado de suscripción
          }
        },
        error: (err) => {
          this.loading.set(false);
          alert(err.error?.message || 'Ocurrió un error al procesar la suscripción.');
        }
      });
    }
  }

  leer(libro: BibliotecaLibro): void {
    this.libroActivo.set(libro);
    const rawUrl = this.bibliotecaService.getLeerUrl(libro.id);
    this.libroUrlSafe.set(this.sanitizer.bypassSecurityTrustResourceUrl(rawUrl));
  }

  cerrarLectura(): void {
    this.libroActivo.set(null);
    this.libroUrlSafe.set(null);
  }

  // --- LÓGICA DE CRUD DE LIBROS ---

  abrirNuevoLibroModal(): void {
    this.editandoLibroId.set(null);
    this.formTitulo = '';
    this.formAutor = '';
    this.formSinopsis = '';
    this.formIdCategoria = this.categorias().length > 0 ? this.categorias()[0].id : null;
    this.formRutaArchivo = 'Libros/PDF/'; // Ruta de base
    this.formFormato = '.pdf';
    this.formPrecioDracoins = 0;
    this.formActivo = true;

    this.mostrarCrudModal.set(true);
  }

  abrirEditarLibroModal(libro: BibliotecaLibro): void {
    this.editandoLibroId.set(libro.id);
    this.formTitulo = libro.titulo;
    this.formAutor = libro.autor;
    this.formSinopsis = libro.sinopsis ?? '';
    this.formIdCategoria = libro.idCategoria ?? null;
    this.formRutaArchivo = libro.rutaArchivo ?? 'Libros/PDF/';
    this.formFormato = libro.formato;
    this.formPrecioDracoins = libro.precioDracoins;
    this.formActivo = libro.activo ?? true;

    this.mostrarCrudModal.set(true);
  }

  cerrarCrudModal(): void {
    this.mostrarCrudModal.set(false);
    this.editandoLibroId.set(null);
  }

  guardarLibro(): void {
    if (!this.formTitulo.trim() || !this.formAutor.trim() || !this.formRutaArchivo.trim() || !this.formFormato.trim()) {
      alert('Por favor, completa todos los campos requeridos.');
      return;
    }

    const payload: SaveLibroRequest = {
      titulo: this.formTitulo.trim(),
      autor: this.formAutor.trim(),
      sinopsis: this.formSinopsis.trim() || undefined,
      idCategoria: this.formIdCategoria,
      rutaArchivo: this.formRutaArchivo.trim(),
      formato: this.formFormato.trim(),
      precioDracoins: this.formPrecioDracoins,
      activo: this.formActivo
    };

    this.loading.set(true);

    const request$ = this.editandoLibroId() !== null
      ? this.bibliotecaService.actualizarLibro(this.editandoLibroId()!, payload)
      : this.bibliotecaService.crearLibro(payload);

    request$.pipe(
      finalize(() => this.loading.set(false))
    ).subscribe({
      next: (res) => {
        alert(res.message);
        this.cerrarCrudModal();
        this.buscarLibros();
      },
      error: (err) => {
        alert(err.error?.message || 'Error al guardar el libro.');
      }
    });
  }

  eliminarLibro(libro: BibliotecaLibro): void {
    if (confirm(`¿Estás completamente seguro de eliminar "${libro.titulo}"?`)) {
      this.loading.set(true);
      this.bibliotecaService.eliminarLibro(libro.id).pipe(
        finalize(() => this.loading.set(false))
      ).subscribe({
        next: (res) => {
          alert(res.message);
          this.buscarLibros();
        },
        error: (err) => {
          alert(err.error?.message || 'Error al eliminar el libro.');
        }
      });
    }
  }
}
