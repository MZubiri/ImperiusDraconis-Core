import { CatalogItem } from './alumnos.models';

export interface PermisoDetalle {
  idPermiso: number;
  controlador: string;
  accion: string;
  tienePermiso: boolean;
}

export interface PermisoCargo {
  idCargo: number;
  cargoNombre: string;
  permisos: PermisoDetalle[];
}

export interface UpdatePermisoCargoRequest {
  permisos: Array<{
    idPermiso: number;
    tienePermiso: boolean;
  }>;
}

export interface CreatePermisoRequest {
  controlador: string;
  accion: string;
}

export type CargoOption = CatalogItem;
