export interface DinamicaListItem {
  idDinamica: number;
  fecha: string | null;
  nombre: string;
  tipo: string;
  subtipo: string;
  idResponsable: number | null;
  nombreResponsable: string;
  observacion: string;
}

export interface DinamicasFilters {
  nombre?: string;
  tipo?: string;
  subtipo?: string;
  responsable?: string;
  desde?: string | null;
  hasta?: string | null;
  pagina?: number;
  registrosPorPagina?: number;
}

export interface PuntosCasaDetalle {
  idCasa: number;
  nombreCasa: string;
  puntosOtorgados: number;
}

export interface DinamicaPuntosDetail {
  idDinamica: number;
  fecha: string | null;
  nombre: string;
  tipo: string;
  subtipo: string;
  idResponsable: number | null;
  nombreResponsable: string;
  observacion: string;
  resultados: PuntosCasaDetalle[];
}

export interface DracoinDinamicaDetalleItem {
  idAlumno: number;
  codigoAlumno: string;
  nombreAlumno: string;
  dracoinsOtorgados: number;
  observacion: string;
}

export interface DinamicaDracoinsDetail {
  idDinamica: number;
  fecha: string | null;
  nombre: string;
  tipo: string;
  subtipo: string;
  idResponsable: number | null;
  nombreResponsable: string;
  observacion: string;
  totalDracoinsOtorgados: number;
  resultados: DracoinDinamicaDetalleItem[];
}

export interface AlumnoActivo {
  idAlumno: number;
  codigo: string;
  nombre: string;
  dracoins: number;
}

export interface RegistrarDinamicaDracoinsItemRequest {
  idAlumno: number;
  dracoinsOtorgados: number;
  observacion?: string | null;
}

export interface RegistrarDinamicaDracoinsRequest {
  nombre: string;
  observacion?: string | null;
  asignaciones: RegistrarDinamicaDracoinsItemRequest[];
}

export interface AgendaDinamica {
  idAgenda: number;
  fecha: string;
  hora: string;
  idAlumno: number;
  nombreAlumno: string;
  cargo: string;
  genero: string;
  titulo: string;
}

export interface AgendaResponsable {
  idAlumno: number;
  nombre: string;
  cargo: string;
  genero: string;
}

export interface AgendaCreateItemRequest {
  hora: string;
  idAlumno: number;
  titulo: string;
}

export interface AgendaCreateBatchRequest {
  fecha: string | null;
  items: AgendaCreateItemRequest[];
}

export interface AgendaUpdateRequest {
  fecha: string | null;
  hora: string;
  idAlumno: number;
  titulo: string;
}
