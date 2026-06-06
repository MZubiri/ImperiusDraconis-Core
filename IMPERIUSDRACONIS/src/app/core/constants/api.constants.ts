import { environment } from '../../../environments/environment';

export const API_BASE_URL = environment.apiBaseUrl;
export const API_ORIGIN = API_BASE_URL.replace(/\/api$/, '');

export function resolveApiAssetUrl(path: string | null | undefined): string {
  const trimmed = path?.trim();
  if (!trimmed) {
    return '';
  }

  if (/^(https?:\/\/|blob:|data:)/i.test(trimmed)) {
    return trimmed;
  }

  const normalized = trimmed.replaceAll('\\', '/').replace(/^~\//, '/');
  return normalized.startsWith('/') ? `${API_ORIGIN}${normalized}` : `${API_ORIGIN}/${normalized}`;
}
