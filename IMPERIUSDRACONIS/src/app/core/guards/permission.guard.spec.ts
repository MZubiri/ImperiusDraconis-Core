import { TestBed } from '@angular/core/testing';
import { ActivatedRouteSnapshot, Router, RouterStateSnapshot, provideRouter } from '@angular/router';
import { beforeEach, describe, expect, it, vi } from 'vitest';
import { AuthService } from '../services/auth.service';
import { permissionGuard } from './permission.guard';

describe('permissionGuard', () => {
  const hasAnyPermission = vi.fn();
  beforeEach(() => {
    hasAnyPermission.mockReset();
    TestBed.configureTestingModule({ providers: [provideRouter([]),
      { provide: AuthService, useValue: { hasAnyPermission } }
    ] });
  });
  const check = (permission?: string | string[]) => TestBed.runInInjectionContext(() =>
    permissionGuard({ data: { permission } } as unknown as ActivatedRouteSnapshot, {} as RouterStateSnapshot));

  it('allows routes without a required permission', () => {
    expect(check()).toBe(true);
    expect(hasAnyPermission).not.toHaveBeenCalled();
  });
  it('accepts a single permission', () => {
    hasAnyPermission.mockReturnValue(true);
    expect(check('Alumnos:Index')).toBe(true);
    expect(hasAnyPermission).toHaveBeenCalledWith(['Alumnos:Index']);
  });
  it('accepts any permission in a list', () => {
    hasAnyPermission.mockReturnValue(true);
    expect(check(['Permisos:Index', 'Permisos:Guardar'])).toBe(true);
    expect(hasAnyPermission).toHaveBeenCalledWith(['Permisos:Index', 'Permisos:Guardar']);
  });
  it('redirects users without permission to the dashboard', () => {
    hasAnyPermission.mockReturnValue(false);
    expect(check('Alumnos:Index')).toEqual(TestBed.inject(Router).createUrlTree(['/dashboard']));
  });
});
