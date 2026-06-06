import { CatalogItem, PagedResult } from './alumnos.models';

export interface TiendaProducto {
  idProducto: number;
  nombre: string;
  descripcion: string;
  precio: number;
  imagen: string;
  activo: boolean;
}

export interface TiendaCompraCatalogos {
  destinatarios: CatalogItem[];
}

export interface TiendaPanelResumen {
  totalProductosActivos: number;
  totalPedidosPendientes: number;
  totalPedidosTomados: number;
  totalPedidosEntregados: number;
  totalPedidosCancelados: number;
}

export interface TiendaHistorialFilters {
  estado?: string;
  nombre?: string;
  desde?: string | null;
  hasta?: string | null;
  pagina?: number;
  registrosPorPagina?: number;
}

export interface TiendaHistorialAdminFilters {
  codigo?: string;
  idVendedor?: number | null;
  estado?: number | null;
  pagina?: number;
  registrosPorPagina?: number;
}

export interface TiendaPedido {
  idPedido: number;
  fechaPedido: string;
  total: number;
  idEstado: number;
  estado: string;
  idComprador: number;
  codigoComprador: string;
  nombreComprador: string;
  idDestinatario: number | null;
  codigoDestinatario: string;
  nombreDestinatario: string;
  idVendedor: number | null;
  nombreVendedor: string;
  producto: string;
  imagen: string;
  comentario: string;
  puedeCancelar: boolean;
}

export interface TiendaComprobante {
  idPedido: number;
  fechaPedido: string;
  total: number;
  producto: string;
  imagen: string;
  precio: number;
  comprador: string;
  destinatario: string;
  estado: string;
  comentario: string;
}

export interface TiendaAdminCatalogos {
  vendedores: CatalogItem[];
  estados: CatalogItem[];
}

export interface CreateTiendaCompraRequest {
  idProducto: number;
  idDestinatario?: number | null;
  comentario?: string | null;
}

export interface UpdateTiendaPedidoEstadoRequest {
  nuevoEstado: number;
  observacion?: string | null;
}

export type TiendaHistorialResult = PagedResult<TiendaPedido>;
