import { AlumnoDetail } from './alumnos.models';

export type PerfilDetail = AlumnoDetail;

export interface UpdateMyProfileRequest {
  telefono: string | null;
  correoElectronico: string | null;
  cumpleanos: string | null;
  pais: string | null;
  prefijoPais: string | null;
  zonaHoraria: string | null;
  fotoPerfil: string | null;
}

export interface ChangeMyPasswordRequest {
  contrasenaActual: string;
  nuevaContrasena: string;
}

export interface UploadProfileImageResponse {
  fotoPerfil: string;
}
