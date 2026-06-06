import { Injectable } from '@angular/core';

interface RuntimeConfig {
  apiUrl: string;
}

@Injectable({ providedIn: 'root' })
export class RuntimeConfigService {
  private config: RuntimeConfig | null = null;

  async load(): Promise<void> {
    const response = await fetch('/assets/config/runtime-config.json', { cache: 'no-store' });
    if (!response.ok) {
      throw new Error(`No se pudo cargar runtime-config.json: HTTP ${response.status}`);
    }

    const config = (await response.json()) as Partial<RuntimeConfig>;
    const apiUrl = config.apiUrl?.trim().replace(/\/+$/, '');
    if (!apiUrl) {
      throw new Error('runtime-config.json no contiene un apiUrl valido.');
    }

    this.config = { apiUrl };
  }

  get apiUrl(): string {
    if (!this.config) {
      throw new Error('RuntimeConfigService debe cargarse antes de usar apiUrl.');
    }

    return this.config.apiUrl;
  }

  resolveApiAssetUrl(path: string | null | undefined): string {
    const trimmed = path?.trim();
    if (!trimmed) {
      return '';
    }

    if (/^(https?:\/\/|blob:|data:)/i.test(trimmed)) {
      return trimmed;
    }

    const apiOrigin = this.apiUrl.replace(/\/api$/, '');
    const normalized = trimmed.replaceAll('\\', '/').replace(/^~\//, '/');
    return normalized.startsWith('/') ? `${apiOrigin}${normalized}` : `${apiOrigin}/${normalized}`;
  }
}
