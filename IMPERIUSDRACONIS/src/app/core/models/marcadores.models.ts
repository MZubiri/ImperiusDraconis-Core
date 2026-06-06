export interface MarcadorCasa {
  idCasa: number;
  nombreCasa: string;
  color: string;
  puntosAcumulados: number;
}

export interface HistorialMarcador {
  idHistorial: number;
  idCasa: number;
  nombreCasa: string;
  puntosAcumulados: number;
  fechaCierre: string;
}

export interface MarcadorUpdateItemRequest {
  idCasa: number;
  puntos: number;
}

export interface SaveMarcadorUpdateRequest {
  nombreDinamica: string;
  subtipoDinamica: string;
  observacion?: string | null;
  puntosPorCasa: MarcadorUpdateItemRequest[];
}

export interface MarcadorUpdateResult {
  idDinamica: number;
  nombreDinamica: string;
  subtipoDinamica: string;
  totalPuntosOtorgados: number;
  marcadorActual: MarcadorCasa[];
}

export interface SaveMarcadorAdjustmentRequest {
  idCasa: number;
  puntos: number;
  observacion: string;
}

export interface MarcadorAdjustmentResult {
  idDinamica: number;
  idCasa: number;
  puntosAjustados: number;
  marcadorActual: MarcadorCasa[];
}

export interface MarcadorCloseResult {
  fechaCierre: string;
  registrosGenerados: number;
  marcadorActual: MarcadorCasa[];
}
