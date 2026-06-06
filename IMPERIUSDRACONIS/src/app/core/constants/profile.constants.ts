import { RuntimeConfigService } from '../services/runtime-config.service';

export interface ProfileCountryOption {
  nombre: string;
  prefijo: string | null;
}

export interface ProfileAvatarOption {
  label: string;
  value: string;
  assetUrl: string;
}

const PROFILE_AVATAR_BASE_PATH = '/profile-avatars';
const profileAvatarFiles = [
  'default.jpg',
  '1.jpg',
  '2.jpg',
  '3.jpg',
  '4.jpg',
  '5.jpg',
  '6.jpg',
  '7.jpg',
  '8.jpg',
  '9.jpg',
  '10.jpg',
  '11.jpg',
  '12.jpg',
  '13.jpg',
  '14.jpg',
  '15.jpg',
  '16.jpg',
  '17.jpg',
  '18.jpg',
  '19.jpg',
  '20.jpg',
  '21.jpg'
] as const;

export const DEFAULT_PROFILE_AVATAR = '~/Content/FotosPerfil/default.jpg';

export const PROFILE_COUNTRIES: readonly ProfileCountryOption[] = [
  { nombre: 'Argentina', prefijo: '+54' },
  { nombre: 'Bolivia', prefijo: '+591' },
  { nombre: 'Brasil', prefijo: '+55' },
  { nombre: 'Chile', prefijo: '+56' },
  { nombre: 'Colombia', prefijo: '+57' },
  { nombre: 'Costa Rica', prefijo: '+506' },
  { nombre: 'Cuba', prefijo: '+53' },
  { nombre: 'Ecuador', prefijo: '+593' },
  { nombre: 'El Salvador', prefijo: '+503' },
  { nombre: 'Estados Unidos', prefijo: '+1' },
  { nombre: 'Guatemala', prefijo: '+502' },
  { nombre: 'Honduras', prefijo: '+504' },
  { nombre: 'Mexico', prefijo: '+52' },
  { nombre: 'Nicaragua', prefijo: '+505' },
  { nombre: 'Panama', prefijo: '+507' },
  { nombre: 'Paraguay', prefijo: '+595' },
  { nombre: 'Peru', prefijo: '+51' },
  { nombre: 'Puerto Rico', prefijo: '+1' },
  { nombre: 'Republica Dominicana', prefijo: '+1' },
  { nombre: 'Uruguay', prefijo: '+598' },
  { nombre: 'Venezuela', prefijo: '+58' },
  { nombre: 'Espana', prefijo: '+34' },
  { nombre: 'Otro', prefijo: null }
];

export const PROFILE_AVATARS: readonly ProfileAvatarOption[] = profileAvatarFiles.map((fileName) => ({
  label: fileName === 'default.jpg' ? 'Predeterminada' : `Avatar ${fileName.replace('.jpg', '')}`,
  value: `~/Content/FotosPerfil/${fileName}`,
  assetUrl: `${PROFILE_AVATAR_BASE_PATH}/${fileName}`
}));

export function resolveProfileAvatarUrl(
  value: string | null | undefined,
  runtimeConfig: RuntimeConfigService
): string {
  const trimmed = value?.trim();
  if (!trimmed) {
    return `${PROFILE_AVATAR_BASE_PATH}/default.jpg`;
  }

  const normalized = trimmed.replaceAll('\\', '/').replace(/^~\//, '');
  const fileName = normalized.split('/').pop();
  if (fileName && profileAvatarFiles.includes(fileName as (typeof profileAvatarFiles)[number])) {
    return `${PROFILE_AVATAR_BASE_PATH}/${fileName}`;
  }

  return runtimeConfig.resolveApiAssetUrl(trimmed) || `${PROFILE_AVATAR_BASE_PATH}/default.jpg`;
}

export function getSuggestedTimezones(): string[] {
  const intlWithSupportedValues = Intl as typeof Intl & {
    supportedValuesOf?: (key: string) => string[];
  };

  const currentTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone;
  const suggested = intlWithSupportedValues.supportedValuesOf?.('timeZone') ?? [];

  return [...new Set([currentTimezone, ...suggested].filter(Boolean))].sort((left, right) =>
    left.localeCompare(right)
  );
}
