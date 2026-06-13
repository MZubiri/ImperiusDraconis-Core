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
}
