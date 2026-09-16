import { inject } from '@angular/core';
import { CanActivateFn, Router } from '@angular/router';
import { AuthService } from '../services/auth.service';

export const permissionGuard: CanActivateFn = (route) => {
  const authService = inject(AuthService);
  const router = inject(Router);
  const required = route.data?.['permission'] as string | string[] | undefined;
  if (!required) return true;
  const permissions = Array.isArray(required) ? required : [required];
  return authService.hasAnyPermission(permissions)
    ? true
    : router.createUrlTree(['/dashboard']);
};
