import { CommonModule } from '@angular/common';
import { ChangeDetectionStrategy, Component, inject } from '@angular/core';
import { AuthService } from '../../core/services/auth.service';

@Component({
  selector: 'app-logout-page',
  imports: [CommonModule],
  template: `
    <section class="logout-screen panel">
      <span class="pill success">Sesión</span>
      <h1>Cerrando sesión</h1>
      <p>Redirigiendo al acceso principal...</p>
    </section>
  `,
  styles: [
    `
      .logout-screen {
        display: grid;
        gap: 0.9rem;
        max-width: 520px;
        margin: 10vh auto;
        padding: 2rem;
        text-align: center;
      }

      .logout-screen p {
        margin: 0;
        color: var(--text-soft);
      }
    `
  ],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class LogoutPageComponent {
  private readonly auth = inject(AuthService);

  constructor() {
    this.auth.logout();
  }
}