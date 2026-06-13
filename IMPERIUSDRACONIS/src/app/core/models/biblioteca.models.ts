export interface BibliotecaCategoria {
  id: number;
  nombre: string;
  descripcion?: string;
}

export interface BibliotecaLibro {
  id: number;
  titulo: string;
  autor: string;
  sinopsis?: string;
  idCategoria?: number;
  categoriaNombre: string;
  formato: string;
  precioDracoins: number;
  comprado: boolean;
  rutaArchivo?: string;
  activo?: boolean;
}

export interface SaveLibroRequest {
  titulo: string;
  autor: string;
  sinopsis?: string;
  idCategoria?: number | null;
  rutaArchivo: string;
  formato: string;
  precioDracoins: number;
  activo: boolean;
}

export interface SuscripcionStatus {
  activa: boolean;
  fechaVencimiento?: string | Date;
  costoSuscripcion: number;
  descargasRealizadas: number;
  descargasPermitidas: number;
}
