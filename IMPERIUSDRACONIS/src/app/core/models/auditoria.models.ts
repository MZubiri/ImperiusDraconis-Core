export interface ResumenAuditoriaListado {
  idAlumno: number;
  nombreAlumno: string;
  relevanciaAuditoria: number;
  motivosDetalle: string;
  evidenciasJson: string;
  ultimaEvaluacion: string;
}

export interface ResumenAuditoriaAcceso {
  idAlumno: number;
  relevanciaAuditoria: number;
  motivosDetalle: string;
  evidenciasJson: string;
  ultimaEvaluacion: string;
}

export interface RelacionAccesoNodo {
  label: string;
  tipo: string; // ALUMNO, IP, DISPOSITIVO, GRUPO, etc.
  valor: string;
  hijos: RelacionAccesoNodo[];
}

export interface DecisionAdministrativa {
  id?: number;
  idAlumno: number;
  idAlumnoRelacionado?: number | null;
  decision: string; // EN_OBSERVACION, PERMITIDA_FAMILIAR, SOSPECHOSA_CONFIRMADA, ACCION_MANUAL
  motivo?: string | null;
  notasInternas?: string | null;
  idAdministrador?: number;
  fechaDecision?: string;
}

export interface ExcepcionAuditoria {
  id?: number;
  tipoExcepcion: string; // RELACION_AUTORIZADA, IP_CONFIABLE, DISPOSITIVO_AUTORIZADO
  valorA: string;
  valorB?: string | null;
  motivo?: string | null;
  fechaCreado?: string;
  idAdministrador?: number;
  activa?: boolean;
}

export interface CuentaEspecial {
  idAlumno: number;
  tipoCuenta: string; // CASA, COMPARTIDA_AUTORIZADA, ASISTENTE, INSTITUCIONAL, ADMINISTRATIVA
  descripcion?: string | null;
  multiplicadorAuditoria: number;
  fechaRegistro?: string;
}
