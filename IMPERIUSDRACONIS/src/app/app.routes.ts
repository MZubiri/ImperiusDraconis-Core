import { Routes } from '@angular/router';
import { authGuard } from './core/guards/auth.guard';
import { loginGuard } from './core/guards/login.guard';
import { AppShellComponent } from './layout/app-shell/app-shell.component';

const loadLoginPage = () =>
  import('./pages/login/login-page.component').then((module) => module.LoginPageComponent);
const loadLogoutPage = () =>
  import('./pages/login/logout-page.component').then((module) => module.LogoutPageComponent);
const loadDashboardPage = () =>
  import('./pages/dashboard/dashboard-page.component').then((module) => module.DashboardPageComponent);
const loadPerfilPage = () =>
  import('./pages/perfil/perfil-page.component').then((module) => module.PerfilPageComponent);
const loadAlumnosPage = () =>
  import('./pages/alumnos/alumnos-page.component').then((module) => module.AlumnosPageComponent);
const loadDinamicasPage = () =>
  import('./pages/dinamicas/dinamicas-page.component').then((module) => module.DinamicasPageComponent);
const loadDracoinsPage = () =>
  import('./pages/dracoins/dracoins-page.component').then((module) => module.DracoinsPageComponent);
const loadMarcadoresPage = () =>
  import('./pages/marcadores/marcadores-page.component').then((module) => module.MarcadoresPageComponent);
const loadMascotasPage = () =>
  import('./pages/mascotas/mascotas-page.component').then((module) => module.MascotasPageComponent);
const loadPermisosPage = () =>
  import('./pages/permisos/permisos-page.component').then((module) => module.PermisosPageComponent);
const loadProductosPage = () =>
  import('./pages/productos/productos-page.component').then((module) => module.ProductosPageComponent);
const loadRinconPage = () =>
  import('./pages/rincon/rincon-page.component').then((module) => module.RinconPageComponent);
const loadTiendaPage = () =>
  import('./pages/tienda/tienda-page.component').then((module) => module.TiendaPageComponent);
const loadAuditoriaPage = () =>
  import('./pages/auditoria/auditoria-page.component').then((module) => module.AuditoriaPageComponent);

export const routes: Routes = [
  {
    path: 'login',
    loadComponent: loadLoginPage,
    canActivate: [loginGuard]
  },
  {
    path: 'Login',
    children: [
      {
        path: '',
        pathMatch: 'full',
        redirectTo: 'Index'
      },
      {
        path: 'Index',
        loadComponent: loadLoginPage,
        canActivate: [loginGuard]
      },
      {
        path: 'RecuperarContraseña',
        loadComponent: loadLoginPage,
        canActivate: [loginGuard]
      },
      {
        path: 'Logout',
        loadComponent: loadLogoutPage
      }
    ]
  },
  {
    path: '',
    component: AppShellComponent,
    canActivate: [authGuard],
    children: [
      {
        path: '',
        pathMatch: 'full',
        redirectTo: 'dashboard'
      },
      {
        path: 'dashboard',
        loadComponent: loadDashboardPage
      },
      {
        path: 'Dashboard',
        loadComponent: loadDashboardPage
      },
      {
        path: 'perfil',
        loadComponent: loadPerfilPage
      },
      {
        path: 'alumnos',
        loadComponent: loadAlumnosPage
      },
      {
        path: 'Alumnos',
        children: [
          {
            path: '',
            pathMatch: 'full',
            loadComponent: loadAlumnosPage
          },
          {
            path: 'Crear',
            loadComponent: loadAlumnosPage
          },
          {
            path: 'MiPerfil',
            loadComponent: loadPerfilPage
          }
        ]
      },
      {
        path: 'dracoins',
        loadComponent: loadDracoinsPage
      },
      {
        path: 'Dracoins',
        children: [
          {
            path: '',
            pathMatch: 'full',
            loadComponent: loadDracoinsPage
          },
          {
            path: 'HistorialGeneral',
            loadComponent: loadDracoinsPage
          },
          {
            path: 'HistorialPagos',
            loadComponent: loadDracoinsPage
          },
          {
            path: 'HistorialTransferencias',
            loadComponent: loadDracoinsPage
          },
          {
            path: 'TransferirDracoins',
            loadComponent: loadDracoinsPage
          },
          {
            path: 'PagarSueldosManual',
            loadComponent: loadDracoinsPage
          },
          {
            path: 'SueldosPorCargo',
            loadComponent: loadDracoinsPage
          }
        ]
      },
      {
        path: 'dinamicas',
        loadComponent: loadDinamicasPage
      },
      {
        path: 'Dinamicas',
        children: [
          {
            path: '',
            pathMatch: 'full',
            loadComponent: loadDinamicasPage
          },
          {
            path: 'AgendaIndex',
            loadComponent: loadDinamicasPage
          },
          {
            path: 'RegistrarDinámicaPorDracoins',
            loadComponent: loadDinamicasPage
          }
        ]
      },
      {
        path: 'marcadores',
        loadComponent: loadMarcadoresPage
      },
      {
        path: 'Marcadores',
        children: [
          {
            path: '',
            pathMatch: 'full',
            loadComponent: loadMarcadoresPage
          },
          {
            path: 'ActualizarMarcador',
            loadComponent: loadMarcadoresPage
          },
          {
            path: 'Historial',
            loadComponent: loadMarcadoresPage
          },
          {
            path: 'MarcadorActual',
            loadComponent: loadMarcadoresPage
          },
          {
            path: 'AjustesPuntos',
            loadComponent: loadMarcadoresPage
          }
        ]
      },
      {
        path: 'mascotas',
        loadComponent: loadMascotasPage
      },
      {
        path: 'Mascotas',
        children: [
          {
            path: '',
            pathMatch: 'full',
            loadComponent: loadMascotasPage
          },
          {
            path: 'Matriz',
            loadComponent: loadMascotasPage
          }
        ]
      },
      {
        path: 'permisos',
        loadComponent: loadPermisosPage
      },
      {
        path: 'Permisos',
        loadComponent: loadPermisosPage
      },
      {
        path: 'auditoria',
        loadComponent: loadAuditoriaPage
      },
      {
        path: 'Auditoria',
        loadComponent: loadAuditoriaPage
      },
      {
        path: 'productos',
        loadComponent: loadProductosPage
      },
      {
        path: 'Productos',
        loadComponent: loadProductosPage
      },
      {
        path: 'trabajos',
        loadComponent: () =>
          import('./pages/trabajos/trabajos-page.component').then(
            (module) => module.TrabajosPageComponent
          )
      },
      {
        path: 'tienda',
        loadComponent: loadTiendaPage
      },
      {
        path: 'Tienda',
        children: [
          {
            path: '',
            pathMatch: 'full',
            loadComponent: loadTiendaPage
          },
          {
            path: 'Historial',
            loadComponent: loadTiendaPage
          }
        ]
      },
      {
        path: 'rincon',
        loadComponent: loadRinconPage
      },
      {
        path: 'Rincon',
        loadComponent: loadRinconPage
      },
      {
        path: 'biblioteca',
        loadComponent: () =>
          import('./pages/biblioteca/biblioteca-page.component').then(
            (module) => module.BibliotecaPageComponent
          )
      },
      {
        path: 'Biblioteca',
        loadComponent: () =>
          import('./pages/biblioteca/biblioteca-page.component').then(
            (module) => module.BibliotecaPageComponent
          )
      }
    ]
  },
  {
    path: '**',
    redirectTo: ''
  }
];
