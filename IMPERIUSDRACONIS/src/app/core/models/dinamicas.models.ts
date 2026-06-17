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
  emojis: string;
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

export interface AutomaticPointsRoundAdjustment {
  roundNumber: number;
  multiplier: number;
  cancelled: boolean;
}

export interface AutomaticPointsFrogAdjustment {
  index: number;
  startRound: number;
}

export interface AutomaticPointsAnalyzeRequest {
  text: string;
  roundAdjustments: AutomaticPointsRoundAdjustment[];
  frogAdjustments: AutomaticPointsFrogAdjustment[];
}

export interface AutomaticPointsRegisterRequest extends AutomaticPointsAnalyzeRequest {
  name: string;
  subtype: string;
  observation?: string | null;
  clientRequestId: string;
}

export interface AutomaticPointsHouseTotal {
  houseEmoji: string;
  idCasa: number;
  houseName: string;
  points: number;
}

export interface AutomaticPointsFrog {
  index: number;
  houseEmoji: string;
  idCasa: number;
  houseName: string;
  description: string;
  startRound: number;
}

export interface AutomaticPointsOwl {
  index: number;
  emojiCasa: string;
  idCasa: number;
  casa: string;
  duenio: string;
  nombre: string;
  detectedRoundNumber: number;
  ronda: number;
}

export interface AutomaticPointsRound {
  roundNumber: number;
  detectedMultiplier: number;
  multiplier: number;
  detectedCancelled: boolean;
  cancelled: boolean;
  top: string[];
  responses: string[];
  pointsByHouse: AutomaticPointsHouseTotal[];
}

export interface AutomaticPointsAnalysis {
  detectedName: string;
  frogs: AutomaticPointsFrog[];
  lechuzasDetectadas: AutomaticPointsOwl[];
  rounds: AutomaticPointsRound[];
  totals: AutomaticPointsHouseTotal[];
  warnings: string[];
}

export interface AutomaticDracoinsRoundAdjustment {
  roundNumber: number;
  multiplier: number;
}

export interface AutomaticDracoinsAnalyzeRequest {
  text: string;
  roundAdjustments: AutomaticDracoinsRoundAdjustment[];
}

export interface AutomaticDracoinsParticipantResult {
  participant: string;
  dracoins: number;
}

export interface AutomaticDracoinsRound {
  roundNumber: number;
  detectedMultiplier: number;
  multiplier: number;
  topParticipants: string[];
  otherParticipants: string[];
  ignoredParticipants: string[];
  pointsByParticipant: AutomaticDracoinsParticipantResult[];
}

export interface AutomaticDracoinsAnalysis {
  detectedName: string;
  rounds: AutomaticDracoinsRound[];
  totals: AutomaticDracoinsParticipantResult[];
  warnings: string[];
  copyText: string;
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
