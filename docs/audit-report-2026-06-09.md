# Informe de Auditoria - 9 de junio de 2026

> **Nota posterior:** este informe conserva el snapshot previo a implementar
> US-1.2.1. El bootstrap y `Game__Version` ya existen localmente; consultar
> [`backlog.md`](backlog.md) y [`api.md`](api.md) para el estado vigente.

## Alcance

Se auditaron:

- Rama `main` local y remota.
- Codigo ASP.NET Core Game.
- Migracion `003_create_game_epic1.sql`.
- Documentacion bajo `docs/`.
- GitHub Issues publicas.
- Build y tests existentes.

No se consulto directamente el esquema de SQL Server de produccion ni los items de
GitHub Projects v2.

## Resultado general

| Area | Resultado |
|---|---|
| Git | `main` local = `origin/main` en `118365b` |
| Build backend | Correcto, 0 errores y 0 advertencias |
| Tests | 17/17 aprobados |
| Produccion | US-1.1.1 y US-1.1.2 confirmadas por el usuario |
| SQL Game | Cinco tablas definidas por migracion aplicada |
| Endpoints Game | Dos implementados |
| Bootstrap | No implementado |

## Inconsistencias detectadas

### Criticas de planificacion

1. “Epic 1 completada” contradice GitHub issue #1, que incluye US-1.2.1 y US-1.2.2
   y permanece abierta.
2. US-1.2.2 aparece abierta, aunque su infraestructura principal ya existe y se usa
   en US-1.1.2. Debe aclararse el criterio de cierre.
3. La numeracion de epicos de `PRODUCT_BACKLOG_IMPERIUS_DRAGONS.md` no coincide con
   las issues #2 a #6.

### Documentacion obsoleta

1. Backlog e issue #7 dicen seis caracteres; el codigo real usa ocho.
2. Backlog marca tareas de US-1.1.1 y US-1.1.2 como pendientes.
3. Issue #8 esta cerrada con todos sus checkboxes sin marcar.
4. `PLAN_TECNICO_SPRINT_1_EPIC_1.md` presenta bootstrap dentro del plan de Epic 1,
   pero no esta implementado.
5. `ARQUITECTURA_TECNICA_IMPERIUS_DRAGONS.md` enumera muchas tablas y APIs futuras
   sin distinguir suficientemente el estado real.
6. `Game__Version` aparece propuesto en el plan, pero no existe en `GameOptions`.
7. `README_DEPLOY_ORACLE.md` documenta dominios productivos; beta usa dominios
   separados `beta` y `api-beta`.

### Codigo no documentado antes de esta auditoria

- Esquema de autenticacion `GameApiKey`.
- `AuthorizeOperationFilter`.
- `GameIdempotencyService`.
- `DracoinGameService`.
- Operacion idempotente `GAME_LINK_CONSUME`.
- Restriccion practica de API beta bajo dominio separado.

### Riesgos tecnicos

1. No existen pruebas automatizadas de integracion SQL para transacciones y
   concurrencia.
2. El ledger Game solo cubre operaciones Game; servicios heredados modifican
   `Alumnos.Dracoins` fuera de este ledger.
3. `GameIdempotency` no tiene limpieza automatica; aceptable para MVP, pero debe
   vigilarse crecimiento.
4. Swagger solo esta habilitado en Development.
5. El proyecto Roblox no esta presente, por lo que no puede auditarse su integracion.

## Historias marcadas versus desarrolladas

| Historia | GitHub | Codigo | Produccion |
|---|---|---|---|
| US-1.1.1 | Cerrada | Si | Probada |
| US-1.1.2 | Cerrada | Si | Probada |
| US-1.2.1 | Abierta | No | No |
| US-1.2.2 | Abierta | Parcial/transversal | Usada por consumo |

No se encontraron historias futuras marcadas como completadas sin codigo.

## Recomendaciones

1. Tratar Feature 1.1 como completada y Epic 1 como en progreso hasta cerrar bootstrap.
2. Convertir `docs/README.md` en entrada obligatoria para nuevas sesiones.
3. Mantener documentos extensos como diseño futuro y actualizar primero los canonicos.
4. Crear infraestructura de pruebas SQL antes de agregar compras o recompensas.
5. Implementar US-1.2.1 como Sprint 2.
