import { CommonModule } from '@angular/common';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { ChangeDetectionStrategy, Component, DestroyRef, inject } from '@angular/core';
import { RouterLink, RouterLinkActive, RouterOutlet } from '@angular/router';
import {
  LucideBriefcaseBusiness,
  LucideCoins,
  LucideDynamicIcon,
  LucideGauge,
  LucideGraduationCap,
  LucideLayoutDashboard,
  LucideLogOut,
  LucideMenu,
  LucidePawPrint,
  LucideShieldCheck,
  LucideShoppingBag,
  LucideStore,
  LucideTrophy,
  LucideUserRound,
  LucideEye,
  LucideBookOpen,
  provideLucideIcons
} from '@lucide/angular';
import { resolveProfileAvatarUrl } from '../../core/constants/profile.constants';
import { AuthService } from '../../core/services/auth.service';
import { PreferencesService } from '../../core/services/preferences.service';
import { RuntimeConfigService } from '../../core/services/runtime-config.service';

@Component({
  selector: 'app-shell',
  imports: [CommonModule, RouterLink, RouterLinkActive, RouterOutlet, LucideDynamicIcon],
  providers: [
    provideLucideIcons(
      LucideBriefcaseBusiness,
      LucideCoins,
      LucideGauge,
      LucideGraduationCap,
      LucideLayoutDashboard,
      LucideLogOut,
      LucideMenu,
      LucidePawPrint,
      LucideShieldCheck,
      LucideShoppingBag,
      LucideStore,
      LucideTrophy,
      LucideUserRound,
      LucideEye,
      LucideBookOpen
    )
  ],
  templateUrl: './app-shell.component.html',
  styleUrl: './app-shell.component.css',
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class AppShellComponent {
  private readonly destroyRef = inject(DestroyRef);
  private readonly alumnosPermissions = [
    'Alumnos:Index',
    'Alumnos:Detalle',
    'Alumnos:Crear',
    'Alumnos:Editar',
    'Alumnos:Eliminar',
    'Alumnos:Notas',
    'Alumnos:CambiarContraseña'
  ] as const;

  readonly auth = inject(AuthService);
  readonly preferencesService = inject(PreferencesService);
  readonly runtimeConfig = inject(RuntimeConfigService);
  readonly themes = [
    { value: 'imperius', label: 'Imperius', asset: '/theme-assets/imperius-logo.webp' },
    { value: 'gryffindor', label: 'Gryffindor', asset: '/theme-assets/gryffindor-shield.webp' },
    { value: 'hufflepuff', label: 'Hufflepuff', asset: '/theme-assets/hufflepuff-shield.webp' },
    { value: 'ravenclaw', label: 'Ravenclaw', asset: '/theme-assets/ravenclaw-shield.webp' },
    { value: 'slytherin', label: 'Slytherin', asset: '/theme-assets/slytherin-shield.webp' },
    { value: 'dark', label: 'Oscuro', asset: '/theme-assets/imperius-logo.webp' },
    { value: 'corporate', label: 'Corporativo', asset: '/theme-assets/imperius-logo.webp' }
  ] as const;
  theme = 'imperius';
  readonly menu = [
    { label: 'Dashboard', icon: 'layout-dashboard', route: '/dashboard', permission: null },
    { label: 'Mi perfil', icon: 'user-round', route: '/perfil', permission: null },
    { label: 'Biblioteca', icon: 'book-open', route: '/biblioteca', permission: null },
    { label: 'Tienda', icon: 'shopping-bag', route: '/tienda', permission: null },
    {
      label: 'Rincón',
      icon: 'store',
      route: '/rincon',
      permission: [
        'Rincon:Catalogo',
        'Rincon:Comprar',
        'Rincon:Historial',
        'Rincon:PanelAdmin',
        'Rincon:GestionarProductos',
        'Rincon:GestionarPedidos'
      ]
    },
    { label: 'Alumnos', icon: 'graduation-cap', route: '/alumnos', permission: this.alumnosPermissions },
    {
      label: 'Dracoins',
      icon: 'coins',
      route: '/dracoins',
      permission: [
        'Dracoins:Index',
        'Dracoins:TransferirDracoins',
        'Dracoins:HistorialTransferencias',
        'Dracoins:HistorialGeneral',
        'Dracoins:HistorialPagos',
        'Dracoins:SueldosPorCargo',
        'Dracoins:ActualizarSueldos',
        'Dracoins:PagarSueldosManual'
      ]
    },
    {
      label: 'Dinámicas',
      icon: 'gauge',
      route: '/dinamicas',
      permission: [
        'Dinamicas:Index',
        'Dinamicas:DetallePuntos',
        'Dinamicas:DetalleDracoins',
        'Dinamicas:RegistrarDinámicaPorDracoins',
        'Dinamicas:AgendaIndex',
        'Dinamicas:Eliminar'
      ]
    },
    {
      label: 'Marcadores',
      icon: 'trophy',
      route: '/marcadores',
      permission: [
        'Marcadores:Index',
        'Marcadores:ActualizarMarcador',
        'Marcadores:AjustesPuntos',
        'Marcadores:Historial',
        'Marcadores:MarcadorActual'
      ]
    },
    {
      label: 'Mascotas',
      icon: 'paw-print',
      route: '/mascotas',
      permission: [
        'Mascotas:Index',
        'Mascotas:EstadoPorAlumno',
        'Mascotas:MascotasPorAlumno',
        'Mascotas:AgregarMascotaPorAlumno',
        'Mascotas:EditarMascotaPorAlumno',
        'Mascotas:EliminarMascotaPorAlumno',
        'Mascotas:CambiarEstado',
        'Mascotas:Catalogo',
        'Mascotas:CobroSemanal',
        'Mascotas:ProcesarCobro'
      ]
    },
    {
      label: 'Trabajos',
      icon: 'briefcase-business',
      route: '/trabajos',
      permission: [
        'Trabajos:Index',
        'Trabajos:Crear',
        'Trabajos:Editar',
        'Trabajos:Eliminar',
        'Trabajos:AsignarAlumnos',
        'Trabajos:AsignarPermisos',
        'Permisos:Guardar'
      ]
    },
    {
      label: 'Permisos',
      icon: 'shield-check',
      route: '/permisos',
      permission: ['Permisos:Index', 'Permisos:Guardar']
    },
    {
      label: 'Auditoría',
      icon: 'eye',
      route: '/auditoria',
      permission: ['Auditoria:VerResumen']
    }
  ] as const;

  constructor() {
    this.theme = globalThis.localStorage?.getItem('imperiusdraconis.theme') || 'imperius';
    this.applyTheme(this.theme);
    this.auth.hydrateSession().pipe(takeUntilDestroyed(this.destroyRef)).subscribe();
    this.preferencesService
      .getTheme()
      .pipe(takeUntilDestroyed(this.destroyRef))
      .subscribe({
        next: (preference) => this.applyAndCacheTheme(preference.tema)
      });
  }

  canView(permission: string | readonly string[] | null): boolean {
    if (permission === null) {
      return true;
    }

    if (typeof permission === 'string') {
      return this.auth.hasPermission(permission);
    }

    return this.auth.hasAnyPermission(permission);
  }

  menuOpen = false;

  toggleMenu(): void {
    this.menuOpen = !this.menuOpen;
  }

  logout(): void {
    this.auth.logout();
  }

  setTheme(theme: string): void {
    this.applyAndCacheTheme(theme);
    this.preferencesService
      .saveTheme({ tema: theme })
      .pipe(takeUntilDestroyed(this.destroyRef))
      .subscribe({
        next: (preference) => this.applyAndCacheTheme(preference.tema)
      });
  }

  avatarUrl(path: string | null | undefined): string {
    return resolveProfileAvatarUrl(path, this.runtimeConfig);
  }

  themeAsset(): string {
    return this.themes.find((item) => item.value === this.theme)?.asset ?? this.themes[0].asset;
  }

  private applyTheme(theme: string): void {
    globalThis.document?.documentElement.setAttribute('data-theme', theme);
  }

  private applyAndCacheTheme(theme: string): void {
    this.theme = this.themes.some((item) => item.value === theme) ? theme : 'imperius';
    globalThis.localStorage?.setItem('imperiusdraconis.theme', this.theme);
    this.applyTheme(this.theme);
  }
}
