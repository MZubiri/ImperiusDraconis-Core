export interface LandingConfiguration {
  tituloPortada: string;
  subtituloPortada: string;
  idCasaGanadora: number | null;
  casaGanadora: string;
  casaColor: string;
  tituloCopa: string;
  descripcionCopa: string;
  fechaActualizacion: string | null;
}

export interface LandingContentItem {
  idContenido: number;
  tipo: string;
  posicion: number;
  idAlumno: number | null;
  idCasa: number | null;
  casaNombre: string;
  titulo: string;
  descripcion: string;
  meta: string;
  imagenUrl: string;
  enlaceUrl: string;
  activo: boolean;
}

export interface LandingPage {
  configuracion: LandingConfiguration;
  dragonesPlata: LandingContentItem[];
  dragonOro: LandingContentItem | null;
  instagram: LandingContentItem[];
  tiktok: LandingContentItem[];
  gaceta: LandingContentItem[];
  escapeRooms: LandingContentItem[];
}

export interface LandingHouseOption {
  idCasa: number;
  nombre: string;
  color: string;
}

export interface LandingAdmin extends LandingPage {
  casas: LandingHouseOption[];
  alumnosActivos: LandingStudentOption[];
}

export interface LandingStudentOption {
  idAlumno: number;
  codigo: string;
  nombre: string;
  fotoPerfil: string;
  idCasa: number;
  casaNombre: string;
}

export interface SaveLandingConfiguration {
  tituloPortada: string;
  subtituloPortada: string | null;
  idCasaGanadora: number | null;
  tituloCopa: string | null;
  descripcionCopa: string | null;
}

export interface SaveLandingContent {
  idAlumno: number | null;
  titulo: string;
  descripcion: string;
  meta: string;
  imagenUrlActual: string;
  enlaceOEmbed: string;
  activo: boolean;
  imagenFile: File | null;
}
