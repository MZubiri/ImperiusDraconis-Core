export interface DracoinTransfer {
  idMovimiento: number;
  codigoRemitente: string;
  nombreRemitente: string;
  codigoDestinatario: string;
  nombreDestinatario: string;
  monto: number;
  fechaTransferencia: string;
  observacion: string;
  esRecibido: boolean;
}

export interface DracoinSummary {
  idAlumno: number;
  codigo: string;
  nombre: string;
  saldoActual: number;
  totalTransferenciasEnviadas: number;
  totalTransferenciasRecibidas: number;
  montoEnviadoTotal: number;
  montoRecibidoTotal: number;
  transferenciasRecientes: DracoinTransfer[];
}

export interface SaveDracoinTransferRequest {
  codigoDestinatario: string;
  monto: number;
  observacion?: string | null;
}

export interface DracoinAdministrativePayment {
  idPago: number;
  idAlumno: number;
  codigoAlumno: string;
  nombreAlumno: string;
  cargo: string;
  montoPagado: number;
  fechaPago: string;
  pagadoPor: string;
  genero: string;
}

export interface DracoinGeneralMovement {
  idMovimiento: number;
  codigoRemitente: string;
  nombreRemitente: string;
  codigoDestinatario: string;
  nombreDestinatario: string;
  monto: number;
  fechaTransferencia: string;
  observacion: string;
}

export interface DracoinGeneralHistoryFilters {
  remitente?: string;
  destinatario?: string;
  montoMin?: number | null;
  montoMax?: number | null;
  observacion?: string;
  desde?: string | null;
  hasta?: string | null;
  pagina?: number;
  registrosPorPagina?: number;
}

export interface DracoinSalaryByCargo {
  idSueldo: number;
  cargo: string;
  sueldoFijo: number;
}

export interface UpdateDracoinSalaryItemRequest {
  idSueldo: number;
  sueldoFijo: number;
}

export interface UpdateDracoinSalaryCatalogRequest {
  items: UpdateDracoinSalaryItemRequest[];
}

export interface DracoinManualPaymentCandidate {
  idAlumno: number;
  codigoAlumno: string;
  nombreAlumno: string;
  cargo: string;
  genero: string;
  montoSugerido: number;
  dracoinsActuales: number;
}

export interface CreateDracoinManualPaymentItemRequest {
  idAlumno: number;
  montoPagado: number;
}

export interface CreateDracoinManualPaymentsRequest {
  items: CreateDracoinManualPaymentItemRequest[];
}

export interface DracoinManualPaymentsResult {
  totalPagosProcesados: number;
  totalMontoPagado: number;
  pagos: DracoinAdministrativePayment[];
}
