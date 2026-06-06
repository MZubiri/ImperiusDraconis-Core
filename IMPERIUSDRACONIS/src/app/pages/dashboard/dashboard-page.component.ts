import { CommonModule } from '@angular/common';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { ChangeDetectionStrategy, Component, DestroyRef, computed, inject, signal } from '@angular/core';
import { RouterLink } from '@angular/router';
import {
  LucideCalendarDays,
  LucideCoins,
  LucideDynamicIcon,
  LucideGauge,
  LucideMinus,
  LucidePawPrint,
  LucidePlus,
  LucideSettings,
  LucideShieldCheck,
  LucideShoppingBag,
  LucideStore,
  LucideTrophy,
  LucideUserPlus,
  LucideUserRound,
  LucideUsers,
  provideLucideIcons
} from '@lucide/angular';
import { finalize } from 'rxjs';
import { AgendaDinamica } from '../../core/models/dinamicas.models';
import { DracoinSummary, DracoinTransfer } from '../../core/models/dracoins.models';
import { AuthService } from '../../core/services/auth.service';
import { DinamicasService } from '../../core/services/dinamicas.service';
import { DracoinsService } from '../../core/services/dracoins.service';
import { PreferencesService } from '../../core/services/preferences.service';

interface QuickLink {
  label: string;
  route: string;
  description: string;
  icon: string;
  permission: string | readonly string[] | null;
}

@Component({
  selector: 'app-dashboard-page',
  imports: [CommonModule, RouterLink, LucideDynamicIcon],
  providers: [
    provideLucideIcons(
      LucideCalendarDays,
      LucideCoins,
      LucideGauge,
      LucideMinus,
      LucidePawPrint,
      LucidePlus,
      LucideSettings,
      LucideShieldCheck,
      LucideShoppingBag,
      LucideStore,
      LucideTrophy,
      LucideUserPlus,
      LucideUserRound,
      LucideUsers
    )
  ],
  templateUrl: './dashboard-page.component.html',
  styleUrl: './dashboard-page.component.css',
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class DashboardPageComponent {
  private readonly destroyRef = inject(DestroyRef);

  readonly auth = inject(AuthService);
  readonly dracoinsService = inject(DracoinsService);
  readonly dinamicasService = inject(DinamicasService);
  readonly preferencesService = inject(PreferencesService);

  readonly loadingSummary = signal(false);
  readonly loadingAgenda = signal(false);
  readonly errorMessage = signal('');
  readonly summary = signal<DracoinSummary | null>(null);
  readonly todaysAgenda = signal<AgendaDinamica[]>([]);
  readonly customizingQuickLinks = signal(false);
  readonly selectedQuickLinkRoutes = signal<string[]>(this.loadQuickLinkRoutes());

  readonly quickLinks: readonly QuickLink[] = [
    {
      label: 'Alumnos',
      route: '/Alumnos',
      description: 'Lista general y creación rápida de alumnos.',
      icon: 'users',
      permission: ['Alumnos:Index', 'Alumnos:Crear', 'Alumnos:Detalle']
    },
    {
      label: 'Nuevo alumno',
      route: '/Alumnos/Crear',
      description: 'Abre directamente el formulario de alta.',
      icon: 'user-plus',
      permission: 'Alumnos:Crear'
    },
    {
      label: 'Mi perfil',
      route: '/perfil',
      description: 'Perfil personal y cambio de contraseña.',
      icon: 'user-round',
      permission: null
    },
    {
      label: 'Banco',
      route: '/Dracoins',
      description: 'Saldo, transferencias, pagos y sueldos.',
      icon: 'coins',
      permission: ['Dracoins:Index', 'Dracoins:TransferirDracoins']
    },
    {
      label: 'Agenda',
      route: '/Dinamicas/AgendaIndex',
      description: 'Agenda del día y responsables.',
      icon: 'calendar-days',
      permission: 'Dinamicas:AgendaIndex'
    },
    {
      label: 'Dinámicas',
      route: '/Dinamicas',
      description: 'Listado, detalle y registro por Dracoins.',
      icon: 'gauge',
      permission: ['Dinamicas:Index', 'Dinamicas:DetallePuntos', 'Dinamicas:DetalleDracoins']
    },
    {
      label: 'Marcadores',
      route: '/Marcadores',
      description: 'Actualización, historial y marcador actual.',
      icon: 'trophy',
      permission: ['Marcadores:Index', 'Marcadores:MarcadorActual']
    },
    {
      label: 'Emporio',
      route: '/Tienda',
      description: 'Catálogo, historial y panel administrativo.',
      icon: 'shopping-bag',
      permission: ['Productos:Index', 'Tienda:HistorialAdmin', 'Tienda:PanelAdmin']
    },
    {
      label: 'Rincón',
      route: '/Rincon',
      description: 'Pedidos y cola operativa del rincón.',
      icon: 'store',
      permission: [
        'Rincon:Catalogo',
        'Rincon:Comprar',
        'Rincon:Historial',
        'Rincon:PanelAdmin',
        'Rincon:GestionarProductos',
        'Rincon:GestionarPedidos'
      ]
    },
    {
      label: 'Mascotas',
      route: '/Mascotas/Matriz',
      description: 'Matriz, estado y cobro semanal.',
      icon: 'paw-print',
      permission: ['Mascotas:Index', 'Mascotas:MascotasPorAlumno']
    },
    {
      label: 'Permisos',
      route: '/Permisos',
      description: 'Administración de permisos y roles.',
      icon: 'shield-check',
      permission: 'Permisos:Index'
    }
  ];

  readonly availableQuickLinks = computed(() =>
    this.quickLinks.filter((item) => this.canView(item.permission))
  );
  readonly visibleQuickLinks = computed(() =>
    this.availableQuickLinks().filter((item) => this.selectedQuickLinkRoutes().includes(item.route))
  );
  readonly recentTransfers = computed(() => this.summary()?.transferenciasRecientes ?? []);
  readonly visibleBalance = computed(() => this.summary()?.saldoActual ?? this.auth.user()?.dracoins ?? 0);

  constructor() {
    this.loadQuickLinkPreferences();
    this.loadSummary();
    this.loadTodayAgenda();
  }

  loadSummary(): void {
    this.loadingSummary.set(true);
    this.dracoinsService
      .getSummary()
      .pipe(
        finalize(() => this.loadingSummary.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (summary) => this.summary.set(summary),
        error: () => this.errorMessage.set('No se pudo cargar el resumen de Dracoins.')
      });
  }

  loadTodayAgenda(): void {
    this.loadingAgenda.set(true);
    this.dinamicasService
      .getAgenda(this.todayString())
      .pipe(
        finalize(() => this.loadingAgenda.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (agenda) => this.todaysAgenda.set(agenda.slice(0, 5)),
        error: () => this.todaysAgenda.set([])
      });
  }

  trackTransfer(_: number, transfer: DracoinTransfer): number {
    return transfer.idMovimiento;
  }

  trackAgenda(_: number, item: AgendaDinamica): number {
    return item.idAgenda;
  }

  toggleQuickLinkEditor(): void {
    this.customizingQuickLinks.update((value) => !value);
  }

  isQuickLinkSelected(route: string): boolean {
    return this.selectedQuickLinkRoutes().includes(route);
  }

  toggleQuickLink(route: string): void {
    const selected = this.selectedQuickLinkRoutes();
    const next = selected.includes(route)
      ? selected.filter((item) => item !== route)
      : [...selected, route];

    this.selectedQuickLinkRoutes.set(next);
    this.saveQuickLinkRoutes(next);
  }

  loadQuickLinkPreferences(): void {
    this.preferencesService
      .getDashboardQuickLinks()
      .pipe(takeUntilDestroyed(this.destroyRef))
      .subscribe({
        next: (preference) => {
          if (!preference.hasPreference) {
            return;
          }

          this.selectedQuickLinkRoutes.set(preference.routes);
          this.saveQuickLinkRoutesLocally(preference.routes);
        },
        error: () => {
          this.errorMessage.set('No se pudieron cargar tus accesos rápidos guardados.');
        }
      });
  }

  private todayString(): string {
    const date = new Date();
    const offset = date.getTimezoneOffset();
    const localDate = new Date(date.getTime() - offset * 60000);
    return localDate.toISOString().split('T')[0] ?? '';
  }

  private loadQuickLinkRoutes(): string[] {
    const defaultRoutes = [
      '/Alumnos',
      '/Alumnos/Crear',
      '/perfil',
      '/Dinamicas/AgendaIndex',
      '/Dinamicas',
      '/Marcadores',
      '/Tienda',
      '/Rincon'
    ];

    if (typeof localStorage === 'undefined') {
      return defaultRoutes;
    }

    const stored = localStorage.getItem('imperius-dashboard-quick-links');
    if (!stored) {
      return defaultRoutes;
    }

    try {
      const parsed = JSON.parse(stored);
      return Array.isArray(parsed) ? parsed.filter((item): item is string => typeof item === 'string') : defaultRoutes;
    } catch {
      return defaultRoutes;
    }
  }

  private saveQuickLinkRoutes(routes: string[]): void {
    this.saveQuickLinkRoutesLocally(routes);
    this.saveQuickLinkRoutesToDatabase(routes);
  }

  private saveQuickLinkRoutesLocally(routes: string[]): void {
    if (typeof localStorage === 'undefined') {
      return;
    }

    localStorage.setItem('imperius-dashboard-quick-links', JSON.stringify(routes));
  }

  private saveQuickLinkRoutesToDatabase(routes: string[]): void {
    this.preferencesService
      .saveDashboardQuickLinks({ routes })
      .pipe(takeUntilDestroyed(this.destroyRef))
      .subscribe({
        error: () => this.errorMessage.set('No se pudieron guardar tus accesos rápidos en la BD.')
      });
  }

  private canView(permission: string | readonly string[] | null): boolean {
    if (permission === null) {
      return true;
    }

    if (typeof permission === 'string') {
      return this.auth.hasPermission(permission);
    }

    return this.auth.hasAnyPermission(permission);
  }
}
