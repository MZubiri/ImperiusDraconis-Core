import { CommonModule } from '@angular/common';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { ChangeDetectionStrategy, Component, DestroyRef, inject, signal } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import { finalize } from 'rxjs';
import { AuthService } from '../../core/services/auth.service';
import { ActivatedRoute } from '@angular/router';
import { readHttpErrorMessage } from '../../core/utils/http-error.utils';

@Component({
  selector: 'app-login-page',
  imports: [CommonModule, FormsModule],
  templateUrl: './login-page.component.html',
  styleUrl: './login-page.component.css',
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class LoginPageComponent {
  private readonly destroyRef = inject(DestroyRef);
  private readonly route = inject(ActivatedRoute);
  private readonly router = inject(Router);

  readonly auth = inject(AuthService);
  readonly viewMode = signal<'login' | 'recovery'>(this.isRecoveryRoute() ? 'recovery' : 'login');
  readonly loading = signal(false);
  readonly recoveryLoading = signal(false);
  readonly errorMessage = signal('');
  readonly recoveryErrorMessage = signal('');
  readonly recoverySuccessMessage = signal('');
  readonly temporaryPasswordPreview = signal('');
  credentials = {
    codigo: '',
    contrasena: ''
  };
  recovery = {
    correo: ''
  };

  openRecovery(): void {
    this.viewMode.set('recovery');
    this.recoveryErrorMessage.set('');
    this.recoverySuccessMessage.set('');
    this.temporaryPasswordPreview.set('');
  }

  returnToLogin(): void {
    this.viewMode.set('login');
    this.errorMessage.set('');
  }

  submit(): void {
    this.errorMessage.set('');

    if (!this.credentials.codigo.trim() || !this.credentials.contrasena.trim()) {
      this.errorMessage.set('Ingresa tu código y tu contraseña.');
      return;
    }

    this.loading.set(true);
    this.auth
      .login({
        codigo: this.credentials.codigo.trim(),
        contrasena: this.credentials.contrasena
      })
      .pipe(
        finalize(() => {
          this.loading.set(false);
        }),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: () => {
          void this.router.navigateByUrl('/dashboard');
        },
        error: (error) => {
          this.errorMessage.set(
            readHttpErrorMessage(error, 'No se pudo iniciar sesión. Verifica tus credenciales.')
          );
        }
      });
  }

  submitRecovery(): void {
    this.recoveryErrorMessage.set('');
    this.recoverySuccessMessage.set('');
    this.temporaryPasswordPreview.set('');

    if (!this.recovery.correo.trim()) {
      this.recoveryErrorMessage.set('Ingresa el correo registrado en tu perfil.');
      return;
    }

    this.recoveryLoading.set(true);
    this.auth
      .recoverPassword({
        correo: this.recovery.correo.trim()
      })
      .pipe(
        finalize(() => {
          this.recoveryLoading.set(false);
        }),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (response) => {
          this.recoverySuccessMessage.set(response.message);
          this.temporaryPasswordPreview.set(response.temporaryPasswordPreview ?? '');
        },
        error: (error) => {
          this.recoveryErrorMessage.set(
            readHttpErrorMessage(error, 'No se pudo procesar la recuperación de contraseña.')
          );
        }
      });
  }

  private isRecoveryRoute(): boolean {
    const routePath = this.route.snapshot.url.map((segment) => segment.path).join('/').toLowerCase();
    return routePath.includes('recuperarcontraseña');
  }
}
