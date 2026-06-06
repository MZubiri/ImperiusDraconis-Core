import { CatalogItem } from './alumnos.models';

export interface TrabajoOption {
  idTrabajo: number;
  nombre: string;
  descripcion: string;
}

export interface SaveTrabajoRequest {
  nombre: string;
  descripcion?: string | null;
}

export interface TrabajoAssignmentItem {
  idTrabajo: number;
  nombre: string;
  descripcion: string;
  asignado: boolean;
}

export interface TrabajoAlumnoAssignments {
  idAlumno: number;
  codigoAlumno: string;
  nombreAlumno: string;
  trabajos: TrabajoAssignmentItem[];
}

export interface TrabajoCatalogs {
  alumnos: CatalogItem[];
  trabajos: TrabajoOption[];
}

export interface SaveTrabajoAssignmentsRequest {
  idsTrabajo: number[];
}

export interface TrabajoPermisoItem {
  idPermisoTrabajo: number;
  controlador: string;
  accion: string;
  tienePermiso: boolean;
}

export interface TrabajoPermisos {
  idTrabajo: number;
  trabajoNombre: string;
  permisos: TrabajoPermisoItem[];
}

export interface UpdateTrabajoPermisosRequest {
  permisos: Array<{
    controlador: string;
    accion: string;
    tienePermiso: boolean;
  }>;
}
