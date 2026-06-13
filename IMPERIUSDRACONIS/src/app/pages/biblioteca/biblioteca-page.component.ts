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
  LucideDynamicIcon,
  provideLucideIcons
} from '@lucide/angular';
import { finalize } from 'rxjs';
import { BibliotecaCategoria, BibliotecaLibro } from '../../core/models/biblioteca.models';
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
      LucideArrowLeft
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

  libroActivo = signal<BibliotecaLibro | null>(null);
  libroUrlSafe = signal<SafeResourceUrl | null>(null);

  // Alumno logueado (para ver su saldo de Dracoins reactivo desde AuthService)
  alumnoDracoins = computed(() => this.authService.user()?.dracoins ?? 0);

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
      next: (cats) => {
        this.categorias.set(cats);
      }
    });

    // Cargar libros
    this.buscarLibros();
  }

  buscarLibros(): void {
    this.loading.set(true);
    this.bibliotecaService.getLibros(this.categoriaSeleccionada(), this.busquedaInput()).subscribe({
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
            // Actualizar dracoins del usuario refrescando la sesion
            this.authService.hydrateSession().subscribe();
            // Recargar los libros para actualizar el flag de 'comprado'
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

  leer(libro: BibliotecaLibro): void {
    if (libro.precioDracoins > 0 && !libro.comprado) {
      alert('Debes comprar este libro primero.');
      return;
    }

    this.libroActivo.set(libro);
    const rawUrl = this.bibliotecaService.getLeerUrl(libro.id);
    this.libroUrlSafe.set(this.sanitizer.bypassSecurityTrustResourceUrl(rawUrl));
  }

  cerrarLectura(): void {
    this.libroActivo.set(null);
    this.libroUrlSafe.set(null);
  }
}
