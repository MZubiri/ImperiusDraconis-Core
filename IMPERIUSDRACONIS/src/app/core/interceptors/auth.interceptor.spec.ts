import { TestBed } from '@angular/core/testing';
import { HttpClient, provideHttpClient, withInterceptors } from '@angular/common/http';
import { HttpTestingController, provideHttpClientTesting } from '@angular/common/http/testing';
import { provideRouter } from '@angular/router';
import { afterEach, beforeEach, describe, expect, it } from 'vitest';
import { AuthService } from '../services/auth.service';
import { RuntimeConfigService } from '../services/runtime-config.service';
import { authInterceptor } from './auth.interceptor';

const user = { idAlumno: 1, permisos: [] };
const initial = { token: 'old-access', refreshToken: 'old-refresh', expiresAt: '', user };

describe('authInterceptor refresh', () => {
  let http: HttpClient;
  let mock: HttpTestingController;
  let auth: AuthService;
  beforeEach(() => {
    localStorage.setItem('imperiusdraconis.session', JSON.stringify(initial));
    TestBed.configureTestingModule({ providers: [
      provideRouter([]), provideHttpClient(withInterceptors([authInterceptor])), provideHttpClientTesting(),
      { provide: RuntimeConfigService, useValue: { apiUrl: '/api' } }
    ] });
    http = TestBed.inject(HttpClient);
    mock = TestBed.inject(HttpTestingController);
    auth = TestBed.inject(AuthService);
  });
  afterEach(() => { mock.verify(); localStorage.clear(); });

  it('shares one refresh across concurrent 401 responses and retries both requests', () => {
    http.get('/api/one').subscribe();
    http.get('/api/two').subscribe();
    mock.expectOne('/api/one').flush({}, { status: 401, statusText: 'Unauthorized' });
    mock.expectOne('/api/two').flush({}, { status: 401, statusText: 'Unauthorized' });
    const refresh = mock.expectOne('/api/auth/refresh');
    expect(refresh.request.headers.has('Authorization')).toBe(false);
    expect(refresh.request.body.refreshToken).toBe('old-refresh');
    refresh.flush({ accessToken: 'new-access', refreshToken: 'new-refresh', expiresAt: '', user });
    for (const path of ['/api/one', '/api/two']) {
      const retry = mock.expectOne(path);
      expect(retry.request.headers.get('Authorization')).toBe('Bearer new-access');
      retry.flush({});
    }
    expect(auth.session()?.refreshToken).toBe('new-refresh');
  });

  it('clears the session if refresh is rejected without refreshing recursively', () => {
    http.get('/api/one').subscribe({ error: () => {} });
    mock.expectOne('/api/one').flush({}, { status: 401, statusText: 'Unauthorized' });
    mock.expectOne('/api/auth/refresh').flush({}, { status: 401, statusText: 'Unauthorized' });
    expect(auth.session()).toBeNull();
  });

  it('never sends credentials to another origin', () => {
    http.get('https://example.test/api/one').subscribe();
    const request = mock.expectOne('https://example.test/api/one');
    expect(request.request.headers.has('Authorization')).toBe(false);
    request.flush({});
  });

  it('does not restore a session after logout while refresh is in flight', () => {
    http.get('/api/one').subscribe({ error: () => {} });
    mock.expectOne('/api/one').flush({}, { status: 401, statusText: 'Unauthorized' });
    const refresh = mock.expectOne('/api/auth/refresh');
    auth.logout();
    refresh.flush({ accessToken: 'new', refreshToken: 'new', expiresAt: '', user });
    expect(auth.session()).toBeNull();
    mock.expectNone('/api/one');
  });
});
