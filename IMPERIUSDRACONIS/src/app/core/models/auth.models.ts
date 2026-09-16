export interface AuthenticatedUser {
  idAlumno: number;
  codigo: string;
  nombre: string;
  idCasa: number | null;
  casaNombre: string;
  idCargo: number | null;
  cargoNombre: string;
  categoria: string;
  genero: string;
  fotoPerfil: string;
  dracoins: number;
  trabajos: number[];
  permisos: string[];
}

export interface LoginRequest {
  codigo: string;
  contrasena: string;
  fingerprintHash?: string;
}

export interface RecoverPasswordRequest {
  correo: string;
}

export interface RecoverPasswordResponse {
  passwordUpdated: boolean;
  emailSent: boolean;
  message: string;
  temporaryPasswordPreview: string | null;
}

export interface TokenResponse {
  accessToken: string;
  refreshToken: string;
  expiresAt: string;
  user: AuthenticatedUser;
}

export interface AuthSession {
  refreshToken?: string;
  token: string;
  expiresAt: string;
  user: AuthenticatedUser;
}
