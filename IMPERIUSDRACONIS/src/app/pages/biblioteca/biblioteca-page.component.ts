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
  LucideDownload,
  LucideUpload,
  LucideSparkles,
  LucideRocket,
  LucideGhost,
  LucideHeart,
  LucideLeaf,
  LucideScroll,
  LucidePalette,
  LucideChevronLeft,
  LucideChevronRight,
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
      LucideCheck,
      LucideDownload,
      LucideUpload,
      LucideSparkles,
      LucideRocket,
      LucideGhost,
      LucideHeart,
      LucideLeaf,
      LucideScroll,
      LucidePalette,
      LucideChevronLeft,
      LucideChevronRight
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

  // Categorías agrupadas (Grupos principales)
  gruposCategorias = [
    { key: 'todas', nombre: 'Todas', icon: 'book-open' },
    { key: 'arcanas', nombre: 'Artes Arcanas', icon: 'sparkles' },
    { key: 'distopias', nombre: 'Ciencia Ficción', icon: 'rocket' },
    { key: 'sombras', nombre: 'Misterio y Terror', icon: 'ghost' },
    { key: 'novela', nombre: 'Romance y Novela', icon: 'heart' },
    { key: 'alquimia', nombre: 'Bienestar y Salud', icon: 'leaf' },
    { key: 'saber', nombre: 'Estudio y Saber', icon: 'scroll' },
    { key: 'miscelanea', nombre: 'Arte y Ocio', icon: 'palette' }
  ];

  grupoSeleccionado = signal<string>('todas');
  categorias = signal<BibliotecaCategoria[]>([]);
  libros = signal<BibliotecaLibro[]>([]);
  categoriaSeleccionada = signal<number | null>(null);
  busquedaInput = signal<string>('');
  tabActivo = signal<'todos' | 'mis-libros'>('todos');

  // Paginación
  paginaActual = signal<number>(1);
  elementosPorPagina = 24;

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

  // Clasificación de categorías en caliente
  clasificarCategoria(nombre: string): string {
    const nom = nombre.toLowerCase();
    if (nom.includes('fantas') || nom.includes('magia') || nom.includes('ocult') || nom.includes('esoter') || nom.includes('mistic') || nom.includes('teosof') || nom.includes('espiritualidad') || nom.includes('paranormal') || nom.includes('grimorio') || nom.includes('mason')) {
      return 'arcanas';
    }
    if (nom.includes('ciencia fic') || nom.includes('distop') || nom.includes('cyborg') || nom.includes('future') || nom.includes('robot')) {
      return 'distopias';
    }
    if (nom.includes('misterio') || nom.includes('terror') || nom.includes('thriller') || nom.includes('policial') || nom.includes('detective') || nom.includes('negra') || nom.includes('suspense') || nom.includes('intriga') || nom.includes('policiaca') || nom.includes('investigac') || nom.includes('negro')) {
      return 'sombras';
    }
    if (nom.includes('romance') || nom.includes('romant') || nom.includes('erotic') || nom.includes('ertic') || nom.includes('amor') || nom.includes('novela') || nom.includes('drama') || nom.includes('femenina') || nom.includes('matrimonio') || nom.includes('pareja') || nom.includes('comediaromntica') || nom.includes('regency') || nom.includes('loveerotica')) {
      return 'novela';
    }
    if (nom.includes('autoayuda') || nom.includes('bienestar') || nom.includes('psicolog') || nom.includes('desarrollo personal') || nom.includes('crecimiento') || nom.includes('mindfulness') || nom.includes('meditac') || nom.includes('yoga') || nom.includes('salud') || nom.includes('fisioterapia') || nom.includes('medicina') || nom.includes('crianza') || nom.includes('relaciones') || nom.includes('relationships')) {
      return 'alquimia';
    }
    if (nom.includes('educac') || nom.includes('academic') || nom.includes('didactica') || nom.includes('mathematic') || nom.includes('ciencia') || nom.includes('historia') || nom.includes('historico') || nom.includes('ensayo') || nom.includes('biografia') || nom.includes('filosof') || nom.includes('logica') || nom.includes('finanzas') || nom.includes('negocios') || nom.includes('ventas') || nom.includes('emprend') || nom.includes('administracion') || nom.includes('tecnolog') || nom.includes('empleo') || nom.includes('idiomas') || nom.includes('escaneado') || nom.includes('manual') || nom.includes('tratado') || nom.includes('universidad')) {
      return 'saber';
    }
    return 'miscelanea';
  }

  // Filtrar categorías del grupo seleccionado
  categoriasFiltradas = computed(() => {
    const grupo = this.grupoSeleccionado();
    if (grupo === 'todas') {
      return [];
    }
    return this.categorias().filter(cat => this.clasificarCategoria(cat.nombre) === grupo);
  });

  // Filtrar libros según búsqueda, tab, grupo de categoría y subcategoría
  librosFiltrados = computed(() => {
    let list = this.libros();
    const grupo = this.grupoSeleccionado();
    const catId = this.categoriaSeleccionada();

    if (catId !== null) {
      list = list.filter(l => l.idCategoria === catId);
    } else if (grupo !== 'todas') {
      list = list.filter(l => {
        if (!l.idCategoria) return grupo === 'miscelanea';
        const cat = this.categorias().find(c => c.id === l.idCategoria);
        if (!cat) return grupo === 'miscelanea';
        return this.clasificarCategoria(cat.nombre) === grupo;
      });
    }

    return list;
  });

  // Paginación de libros
  paginasTotales = computed(() => {
    const total = this.librosFiltrados().length;
    return total > 0 ? Math.ceil(total / this.elementosPorPagina) : 1;
  });

  librosPaginados = computed(() => {
    const start = (this.paginaActual() - 1) * this.elementosPorPagina;
    const end = start + this.elementosPorPagina;
    return this.librosFiltrados().slice(start, end);
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

    // Se solicita sin ID de categoría para filtrar localmente en cliente y soportar agrupaciones dinámicas
    this.bibliotecaService.getLibros(null, this.busquedaInput(), soloMisLibros).subscribe({
      next: (lbs) => {
        this.libros.set(lbs);
        this.paginaActual.set(1); // Resetear paginación al buscar
        this.loading.set(false);
      },
      error: () => {
        this.errorMsg.set('Error al cargar los libros.');
        this.loading.set(false);
      }
    });
  }

  seleccionarGrupo(key: string): void {
    this.grupoSeleccionado.set(key);
    this.categoriaSeleccionada.set(null);
    this.paginaActual.set(1);
  }

  seleccionarSubcategoria(id: number | null): void {
    this.categoriaSeleccionada.set(id);
    this.paginaActual.set(1);
  }

  obtenerNombreGrupo(key: string): string {
    return this.gruposCategorias.find(g => g.key === key)?.nombre ?? '';
  }

  cambiarPagina(pagina: number): void {
    if (pagina >= 1 && pagina <= this.paginasTotales()) {
      this.paginaActual.set(pagina);
      window.scrollTo({ top: 0, behavior: 'smooth' });
    }
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
    const costo = this.suscripcion()?.costoSuscripcion ?? 250;

    if (this.alumnoDracoins() < costo) {
      alert(`No tienes suficientes Dracoins. La suscripción cuesta ${costo} DC y tienes ${this.alumnoDracoins()} DC.`);
      return;
    }

    const confirmMsg = this.suscripcion()?.activa 
      ? `¿Deseas extender tu suscripción semanal por otros 7 días por ${costo} Dracoins?`
      : `¿Deseas suscribirte a la biblioteca por una semana por ${costo} Dracoins? (Acceso ilimitado a todos los libros y 2 descargas semanales)`;

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

  descargar(libro: BibliotecaLibro): void {
    this.loading.set(true);
    this.bibliotecaService.descargarLibro(libro.id).subscribe({
      next: (blob) => {
        const url = window.URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = `${libro.titulo} - ${libro.autor}${libro.formato}`;
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        window.URL.revokeObjectURL(url);
        
        // Refrescar el estado de la suscripción para actualizar las descargas usadas
        this.bibliotecaService.getSuscripcionStatus().subscribe({
          next: (status) => {
            this.suscripcion.set(status);
            this.loading.set(false);
          },
          error: () => this.loading.set(false)
        });
      },
      error: (err) => {
        this.loading.set(false);
        if (err.error instanceof Blob) {
          const reader = new FileReader();
          reader.onload = (e: any) => {
            try {
              const res = JSON.parse(e.target.result);
              alert(res.message || 'Error al descargar el libro.');
            } catch {
              alert('Error al descargar el libro.');
            }
          };
          reader.readAsText(err.error);
        } else {
          alert(err.error?.message || 'Error al descargar el libro.');
        }
      }
    });
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
    this.formPrecioDracoins = 300;
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

  exportarBiblioteca(): void {
    this.loading.set(true);
    this.bibliotecaService.exportarExcel().pipe(
      finalize(() => this.loading.set(false))
    ).subscribe({
      next: (blob) => {
        const url = window.URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = `grimorios_exportados_${new Date().toISOString().slice(0,10)}.xlsx`;
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        window.URL.revokeObjectURL(url);
      },
      error: (err) => {
        alert('Error al descargar el archivo de Excel.');
      }
    });
  }

  onImportarArchivo(event: Event): void {
    const input = event.target as HTMLInputElement;
    if (!input.files || input.files.length === 0) return;

    const file = input.files[0];
    if (confirm(`¿Deseas importar el archivo "${file.name}"? Se actualizarán los grimorios que coincidan con su ID y se añadirán los nuevos.`)) {
      this.loading.set(true);
      this.bibliotecaService.importarExcel(file).pipe(
        finalize(() => {
          this.loading.set(false);
          input.value = ''; // Limpiar el input para permitir subir el mismo archivo después
        })
      ).subscribe({
        next: (res) => {
          alert(res.message);
          this.cargarDatos(); // Recargar todo el catálogo y categorías
        },
        error: (err) => {
          alert(err.error?.message || 'Error al importar el archivo de Excel.');
        }
      });
    } else {
      input.value = '';
    }
  }
}
