export interface Producto {
  idProducto: number;
  nombre: string;
  descripcion: string;
  precio: number;
  imagen: string;
  activo: boolean;
}

export interface SaveProductoRequest {
  nombre: string;
  descripcion?: string | null;
  precio: number;
  activo: boolean;
  imagenActual?: string | null;
  fotoArchivo?: File | null;
}
