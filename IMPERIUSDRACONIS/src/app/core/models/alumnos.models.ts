export interface CatalogItem {
  id: number;
  nombre: string;
}

export interface AlumnoListItem {
  idAlumno: number;
  codigo: string;
  nombre: string;
  emojis: string;
  dracoins: number;
  activo: boolean;
  categoria: string;
  idCasa: number | null;
  casaNombre: string;
  idCargo: number | null;
  nombreCargo: string;
  genero: string;
  telefono: string;
  correoElectronico: string;
}

export interface AlumnoDetail extends AlumnoListItem {
  nivel: string;
  fotoPerfil: string;
  cumpleanos: string | null;
  pais: string;
  prefijoPais: string;
  zonaHoraria: string;
}

export interface AlumnoNote {
  idNota: number;
  idAlumno: number;
  nota: string;
  fecha: string;
}

export interface SaveAlumnoRequest {
  codigo: string;
  nombre: string;
  emojis: string | null;
  telefono: string | null;
  idCasa: number | null;
  nivel: string | null;
  idCargo: number | null;
  dracoins: number;
  activo: boolean;
  genero: string | null;
  cumpleanos: string | null;
  pais: string | null;
  prefijoPais: string | null;
  zonaHoraria: string | null;
  correoElectronico: string | null;
  fotoPerfil: string | null;
  contrasena?: string | null;
}

export interface CreateAlumnoNoteRequest {
  nota: string;
}

export interface ResetAlumnoPasswordRequest {
  nuevaContrasena: string;
}

export interface UpdateAlumnoEmojisRequest {
  emojis: string | null;
}

export interface PagedResult<T> {
  items: T[];
  totalRegistros: number;
  paginaActual: number;
  registrosPorPagina: number;
  totalPaginas: number;
}

export interface AlumnoFilters {
  codigo?: string;
  nombre?: string;
  idCasa?: number | null;
  activo?: boolean | null;
  pagina?: number;
  registrosPorPagina?: number;
  ordenarPor?: string;
  orden?: 'asc' | 'desc';
}

export interface CumpleanosItem {
  idAlumno: number;
  nombre: string;
  fotoPerfil: string;
  categoria: string;
  casaNombre: string;
  mes: number;
  dia: number;
}
