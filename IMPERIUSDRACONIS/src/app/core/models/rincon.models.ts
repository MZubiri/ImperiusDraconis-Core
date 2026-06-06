export interface RinconProductoFilters {
  categoria?: string | null;
  soloDisponibles?: boolean | null;
}

export interface RinconProducto {
  idProducto: number;
  nombre: string;
  descripcion: string;
  precio: number;
  stock: number;
  imagenUrl: string;
  categoria: string;
  fechaRegistro: string | null;
}

export interface RinconPedidoDetalle {
  idProducto: number;
  nombre: string;
  cantidad: number;
  precioUnitario: number;
  subtotal: number;
}

export interface RinconPedido {
  idPedido: number;
  idAlumno: number;
  nombreAlumno: string;
  fechaPedido: string;
  total: number;
  estado: number;
  estadoNombre: string;
  detalles: RinconPedidoDetalle[];
}

export interface RinconResumenAdmin {
  totalProductos: number;
  productosSinStock: number;
  pedidosPendientes: number;
  pedidosEntregados: number;
}

export interface SaveRinconProductoRequest {
  nombre: string;
  descripcion?: string | null;
  precio: number;
  stock: number;
  categoria?: string | null;
  imagenUrlActual?: string | null;
  imagenFile?: File | null;
}

export interface CreateRinconPedidoItemRequest {
  idProducto: number;
  cantidad: number;
}

export interface CreateRinconPedidoRequest {
  items: CreateRinconPedidoItemRequest[];
}
