import { HttpClient } from '@angular/common/http';
import { computed, inject, Injectable, signal } from '@angular/core';
import { Router } from '@angular/router';
import { catchError, finalize, map, Observable, of, shareReplay, tap, throwError } from 'rxjs';
import { RuntimeConfigService } from './runtime-config.service';
import {
  AuthenticatedUser,
  TokenResponse,
  AuthSession,
  LoginRequest,
  RecoverPasswordRequest,
  RecoverPasswordResponse
} from '../models/auth.models';

const STORAGE_KEY = 'imperiusdraconis.session';

@Injectable({ providedIn: 'root' })
export class AuthService {
  private readonly http = inject(HttpClient);
  private readonly runtimeConfig = inject(RuntimeConfigService);
  private readonly router = inject(Router);
  private readonly sessionState = signal<AuthSession | null>(this.readSession());

  private refreshInFlight: Observable<AuthSession> | null = null;

  readonly session = this.sessionState.asReadonly();
  readonly token = computed(() => this.sessionState()?.token ?? null);
  readonly user = computed(() => this.sessionState()?.user ?? null);
  readonly isAuthenticated = computed(() => !!this.sessionState()?.token);
  readonly permissions = computed(() => this.user()?.permisos ?? []);

  login(payload: LoginRequest): Observable<AuthSession> {
    return this.http.post<AuthSession>(`${this.runtimeConfig.apiUrl}/auth/login`, payload).pipe(
      tap((session) => this.persistSession(session))
    );
  }

  refreshToken(): Observable<AuthSession> {
    if (this.refreshInFlight) return this.refreshInFlight;
    const current = this.sessionState();
    if (!current?.refreshToken) return throwError(() => new Error('La sesión no puede renovarse.'));

    this.refreshInFlight = this.http.post<TokenResponse>(`${this.runtimeConfig.apiUrl}/auth/refresh`, {
      refreshToken: current.refreshToken
    }).pipe(
      map((response): AuthSession => ({
        token: response.accessToken,
        refreshToken: response.refreshToken,
        expiresAt: response.expiresAt,
        user: response.user
      })),
      tap((session) => {
        // No restaurar una sesión cerrada o reemplazada durante la petición.
        if (this.sessionState()?.refreshToken !== current.refreshToken) {
          throw new Error('La sesión ha cambiado.');
        }
        this.persistSession(session);
      }),
      finalize(() => { this.refreshInFlight = null; }),
      shareReplay({ bufferSize: 1, refCount: false })
    );
    return this.refreshInFlight;
  }

  recoverPassword(payload: RecoverPasswordRequest): Observable<RecoverPasswordResponse> {
    return this.http.post<RecoverPasswordResponse>(`${this.runtimeConfig.apiUrl}/auth/recuperar-contrasena`, payload);
  }

  hydrateSession(): Observable<AuthenticatedUser | null> {
    if (!this.isAuthenticated()) {
      return of(null);
    }

    return this.http.get<AuthenticatedUser>(`${this.runtimeConfig.apiUrl}/auth/me`).pipe(
      tap((user) => {
        const current = this.sessionState();
        if (!current) {
          return;
        }

        this.persistSession({
          ...current,
          user
        });
      }),
      catchError(() => {
        this.clearSession();
        return of(null);
      })
    );
  }

  logout(): void {
    this.clearSession();
    void this.router.navigate(['/login']);
  }

  hasPermission(permission: string): boolean {
    return this.permissions().some((current) => current.toLowerCase() === permission.toLowerCase());
  }

  hasAnyPermission(permissions: readonly string[]): boolean {
    return permissions.some((permission) => this.hasPermission(permission));
  }

  private persistSession(session: AuthSession): void {
    this.sessionState.set(session);
    globalThis.localStorage.setItem(STORAGE_KEY, JSON.stringify(session));
  }

  private clearSession(): void {
    this.sessionState.set(null);
    globalThis.localStorage.removeItem(STORAGE_KEY);
  }

  private readSession(): AuthSession | null {
    const raw = globalThis.localStorage.getItem(STORAGE_KEY);
    if (!raw) {
      return null;
    }

    try {
      return JSON.parse(raw) as AuthSession;
    } catch {
      globalThis.localStorage.removeItem(STORAGE_KEY);
      return null;
    }
  }
}
