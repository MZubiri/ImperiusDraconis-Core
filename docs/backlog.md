# Backlog Verificado

Ultima auditoria: **9 de junio de 2026**

## Fuente

Se verificaron las GitHub Issues publicas de:

`https://github.com/MZubiri/ImperiusDraconis-Core`

GitHub Projects v2 no pudo consultarse desde esta sesion porque las herramientas
disponibles no exponen sus items y `gh` no esta instalado. Por ello, este documento
sincroniza con **issues**, codigo, SQL y estado confirmado de produccion.

## Estado de Epic 1

La expresion “Epic 1 completada” es ambigua:

- **Feature 1.1 Vinculacion:** completada y probada en produccion.
- **Epic 1 segun issue #1:** sigue en progreso porque incluye bootstrap y consulta de datos.

| Item | GitHub | Implementacion real | Estado canonico |
|---|---|---|---|
| Issue #1 Epic 1 | Abierta | Feature 1.1 completa; bootstrap implementado localmente | En progreso hasta despliegue |
| Issue #7 US-1.1.1 | Cerrada | Implementada y probada | Completada |
| Issue #8 US-1.1.2 | Cerrada | Implementada y probada | Completada |
| Issue #9 US-1.2.1 | Abierta | Implementada localmente; pendiente de despliegue | En validacion |
| Issue #10 US-1.2.2 | Abierta | Infraestructura usada por consumo; alcance transversal incompleto | Parcial |

## Historias implementadas

### US-1.1.1

- Codigo real de ocho caracteres, no seis.
- Endpoint, tabla, expiracion, HMAC y revocacion implementados.
- La issue cerrada conserva texto obsoleto de seis caracteres.

### US-1.1.2

- Backend de consumo implementado y probado en produccion.
- Vínculo, capacidad, bienvenida, ledger e idempotencia confirmados.
- Las tareas de Roblox Studio mencionadas por la issue no existen en este repositorio.
- La issue esta cerrada aunque sus checkboxes permanecen sin marcar.

## Historias parciales o pendientes

### US-1.2.1 Bootstrap

Endpoint, DTOs, servicio y consulta implementados. Falta desplegar y validar contra
SQL Server de produccion y desde un servidor Roblox.

### US-1.2.2 Ledger e idempotencia

Ya existen:

- Tablas.
- `DracoinGameService`.
- `GameIdempotencyService`.
- Uso transaccional en `links/consume`.

Falta para completar su alcance declarado:

- Aplicar el patron a futuras compras y recompensas.
- Definir si sera servicio explicito o filtro/middleware general.
- Pruebas de integracion SQL automatizadas.
- Resolver que movimientos heredados de `Alumnos.Dracoins` no pasan por el ledger Game.

## Epicos futuros segun GitHub

| Issue | Epic | Estado |
|---|---|---|
| #2 | Huevos e Incubacion | Abierta; persistencia minima y código de definición implementados localmente |
| #3 | Dragon Acompanante | Abierta, no implementada |
| #4 | Necesidades y Crecimiento | Abierta, no implementada |
| #5 | Misiones y Recompensas | Abierta, no implementada |
| #6 | Combate y Ranking | Abierta, no implementada |

La numeracion difiere de `PRODUCT_BACKLOG_IMPERIUS_DRAGONS.md`, que combina o desplaza
algunos epicos e incluye un Epic 6 administrativo que no aparece como issue.

## Sprint 2 recomendado

Objetivo: cerrar la lectura inicial del jugador sin adelantar sistemas futuros.

1. Desplegar y validar US-1.2.1 Bootstrap.
2. Agregar pruebas de integracion SQL para vinculacion y bootstrap.
3. Aclarar/cerrar el alcance restante de US-1.2.2.
4. Actualizar issue #1 cuando bootstrap este desplegado.

La persistencia minima de huevos fue adelantada como incremento tecnico aislado. Aun
no incluye adquisición publica, incubacion, eclosion, dragones ni UI Roblox.

La migracion `004_create_game_eggs.sql` fue aplicada en produccion. La ampliacion
aditiva `005_add_egg_definition_to_game_eggs.sql` queda pendiente de aplicar.
