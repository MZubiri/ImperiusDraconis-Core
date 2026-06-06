export interface MascotaSummary {
  totalMascotasCatalogo: number;
  totalAsignaciones: number;
  totalSuscritas: number;
  totalCongeladas: number;
  totalSubsidiadas: number;
  totalNoActivas: number;
  totalEnLibertad: number;
  totalPendientesCobro: number;
}

export interface MascotaCatalogItem {
  idMascota: number;
  nombre: string;
  precioCompra: number;
  precioMantenimiento: number;
  activo: boolean;
}

export interface MascotaAlumnoOption {
  idAlumno: number;
  codigo: string;
  nombre: string;
}

export interface MascotaFormCatalogs {
  alumnos: MascotaAlumnoOption[];
  mascotas: MascotaCatalogItem[];
  estados: string[];
}

export interface MascotaAssignment {
  idMascotaAlumno: number;
  idAlumno: number;
  codigoAlumno: string;
  nombreAlumno: string;
  idMascota: number;
  nombreMascota: string;
  estado: string;
  fechaCompra: string;
  fechaUltimoPago: string | null;
  precioCompra: number;
  precioMantenimiento: number;
  debePagar: boolean;
  subsidiadaPor: string | null;
  observaciones: string | null;
}

export interface SaveMascotaAssignmentRequest {
  idAlumno: number;
  idMascota: number;
  estado: string;
  fechaCompra: string;
  fechaUltimoPago: string | null;
  subsidiadaPor: string | null;
  observaciones: string | null;
}

export interface ChangeMascotaStateRequest {
  nuevoEstado: string;
  subsidiadaPor: string | null;
  observaciones: string | null;
}

export interface MascotaWeeklyChargeCandidate {
  idMascotaAlumno: number;
  idAlumno: number;
  codigoAlumno: string;
  nombreAlumno: string;
  nombreMascota: string;
  estado: string;
  precioMantenimiento: number;
  fechaUltimoPago: string | null;
  dracoinsDisponibles: number;
  debePagar: boolean;
}

export interface ProcessMascotaWeeklyChargeRequest {
  idsSeleccionados: number[];
}

export interface MascotaWeeklyChargeResult {
  totalProcesadas: number;
  totalRechazadas: number;
  alumnosRechazados: string[];
}

export interface MascotaMatrixRow {
  idAlumno: number;
  codigoAlumno: string;
  nombreAlumno: string;
  idMascotaLechuza: number | null;
  estadoLechuza: string;
  idMascotaGato: number | null;
  estadoGato: string;
  idMascotaSapo: number | null;
  estadoSapo: string;
  idMascotaGiratiempo: number | null;
  estadoGiratiempo: string;
}

export interface MascotaAssignmentFilters {
  filtroEstado?: 'todas' | 'vigente' | 'no activa' | 'congelada' | 'subsidiada';
  busqueda?: string;
  soloPendientesCobro?: boolean;
}
