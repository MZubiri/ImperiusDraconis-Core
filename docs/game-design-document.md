# Game Design Document - Estado Real

Ultima auditoria: **9 de junio de 2026**

## Vision

Imperius Dragons es un juego Roblox de fantasia escolar magica para sesiones de
5 a 15 minutos. El jugador vincula su identidad Imperius, obtiene y cuida dragones,
completa misiones y participa en combates automaticos.

## Estado jugable actual

La experiencia de juego completa todavia no esta implementada en este repositorio.
La base disponible es:

- Vinculacion Roblox ↔ Imperius.
- Recompensa inicial de 400 Dracoins.
- Capacidad inicial de un espacio, maximo diez.
- Infraestructura minima de ledger e idempotencia.

## Estado por sistema

| Sistema | Diseñado | Backend | SQL Game | Roblox en repo |
|---|---|---|---|---|
| Vinculacion | Si | Si | Si | No |
| Dracoins bienvenida | Si | Si | Si | No |
| Bootstrap | Si | Si, pendiente de despliegue | Usa tablas existentes | No |
| Persistencia de huevos | Si | Si, CRUD interno | Migracion pendiente | No |
| Compra/incubacion/eclosion | Si | No | No adicional | No |
| Dragon acompanante | Si | No | No | No |
| Hambre/felicidad/vida | Si | No | No | No |
| Misiones | Si | No | No | No |
| Combate/ranking | Si | No | No | No |
| Administracion Game | Si | No | No | No |

## MVP previsto

El diseño conceptual mantiene:

- Comprar, regalar e incubar huevos.
- Dragones con especie, rareza y temperamento.
- Dragon acompanante.
- Hambre, felicidad, vida, crecimiento y huida reversible.
- Misiones simples.
- Combate automatico 1 vs 1 y dragones salvajes.
- Ranking simple.

Los detalles de contenido y UX permanecen en:

- `DISENO_CONTENIDO_IMPERIUS_DRAGONS.md`
- `UX_PANTALLAS_IMPERIUS_DRAGONS.md`

Esos documentos describen objetivo futuro, no estado implementado.

## Decisiones vigentes

- Comunidad objetivo: 20 a 100 usuarios diarios y hasta 20 concurrentes.
- Monolito ASP.NET Core + SQL Server.
- Sin Redis, microservicios, Workers ni telemetria avanzada.
- Toda economia se valida en backend.
- Dragones no transferibles; huevos transferibles en fase futura.
- No adelantar tablas ni endpoints de sistemas aun no implementados.

## Siguiente incremento

Tras desplegar y validar US-1.2.1, el siguiente incremento debe cerrar el alcance
pendiente de ledger/idempotencia y preparar Epic 2 sin adelantar tablas ni endpoints
de huevos hasta aprobar su diseño.
