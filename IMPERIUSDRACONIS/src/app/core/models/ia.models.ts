export type FormatCorrectionType = 'puntos' | 'dracoins';

export interface FormatCorrectionRequest {
  texto: string;
  tipo: FormatCorrectionType;
}

export interface FormatCorrectionResponse {
  textoCorregido: string;
  advertencia: string;
}
