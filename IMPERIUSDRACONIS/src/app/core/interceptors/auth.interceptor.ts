import { HttpInterceptorFn, HttpErrorResponse } from '@angular/common/http';
import { inject } from '@angular/core';
import { AuthService } from '../services/auth.service';
import { RuntimeConfigService } from '../services/runtime-config.service';
import { catchError, of, switchMap, throwError } from 'rxjs';

export const authInterceptor: HttpInterceptorFn = (req, next) => {
  const authService = inject(AuthService);
  const config = inject(RuntimeConfigService);
  const url = new URL(req.url, globalThis.location.origin);
  const api = new URL(config.apiUrl, globalThis.location.origin);
  const apiPath = api.pathname.replace(/\/$/, '');
  const isApi = url.origin === api.origin
    && (url.pathname === apiPath || url.pathname.startsWith(`${apiPath}/`));
  const isAuthRequest = ['login', 'refresh', 'recuperar-contrasena']
    .some((action) => url.pathname === `${apiPath}/auth/${action}`);
  if (!isApi || isAuthRequest) return next(req);

  const token = authService.token();
  const authorized = token ? req.clone({ setHeaders: { Authorization: `Bearer ${token}` } }) : req;
  return next(authorized).pipe(
    catchError((error: unknown) => {
      if (!(error instanceof HttpErrorResponse) || error.status !== 401 || !token) {
        return throwError(() => error);
      }
      // Un 401 tardío puede pertenecer al token anterior a una renovación compartida.
      const latest = authService.session();
      const refresh = latest && latest.token !== token ? of(latest) : authService.refreshToken();
      return refresh.pipe(
        catchError((refreshError: unknown) => {
          if (authService.session()?.refreshToken === latest?.refreshToken) authService.logout();
          return throwError(() => refreshError);
        }),
        switchMap((session) => next(req.clone({
          setHeaders: { Authorization: `Bearer ${session.token}` }
        })).pipe(
          catchError((retryError: unknown) => {
            if (retryError instanceof HttpErrorResponse && retryError.status === 401
                && authService.token() === session.token) authService.logout();
            return throwError(() => retryError);
          })
        ))
      );
    })
  );
};
