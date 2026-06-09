# Imperius Dragons - Documentacion

Ultima auditoria: **9 de junio de 2026**

## Estado actual

Imperius Dragons es un modulo nuevo dentro del monolito existente de Imperius
Draconis. Actualmente esta implementada y probada en produccion la vinculacion
Roblox ↔ Imperius:

- Generar codigo temporal desde una sesion JWT de Imperius.
- Consumir el codigo desde un servidor Roblox autenticado con API Key.
- Crear vinculo, capacidad inicial y recompensa de bienvenida.
- Registrar ledger e idempotencia del consumo.

El bootstrap inicial y la persistencia minima de huevos estan implementados
localmente. La migracion `004_create_game_eggs.sql` esta pendiente de aplicar. No
existen todavia endpoints publicos de huevos ni persistencia Game para dragones,
misiones, combate o ranking.

## Fuente de verdad

Para continuar el proyecto, leer en este orden:

1. [architecture.md](architecture.md): arquitectura implementada.
2. [database.md](database.md): esquema SQL Game existente.
3. [api.md](api.md): endpoints desplegados.
4. [backlog.md](backlog.md): estado verificado contra GitHub Issues.
5. [game-design-document.md](game-design-document.md): diseño del juego y estado real.
6. [audit-report-2026-06-09.md](audit-report-2026-06-09.md): inconsistencias detectadas.
7. [sprint-2-us-1.2.1-design.md](sprint-2-us-1.2.1-design.md): diseño e implementacion de bootstrap.
8. [game-eggs-persistence.md](game-eggs-persistence.md): persistencia minima de huevos.

## Documentos de referencia

Los siguientes documentos contienen diseño amplio y siguen siendo utiles como
referencia, pero **no describen funcionalidad implementada completa**:

- `ARQUITECTURA_TECNICA_IMPERIUS_DRAGONS.md`
- `DISENO_CONTENIDO_IMPERIUS_DRAGONS.md`
- `UX_PANTALLAS_IMPERIUS_DRAGONS.md`
- `PRODUCT_BACKLOG_IMPERIUS_DRAGONS.md`
- `PLAN_TECNICO_SPRINT_1_EPIC_1.md`

Cuando exista una contradiccion, prevalecen el codigo, la migracion aplicada y los
documentos canonicos en minusculas.

## Repositorio y despliegue

- Repositorio: `MZubiri/ImperiusDraconis-Core`
- Rama principal: `main`
- Frontend beta: `https://beta.imperiusdraconis.lat`
- API beta: `https://api-beta.imperiusdraconis.lat`
- Backend interno: ASP.NET Core en puerto `8080`
- Base de datos: SQL Server externo
- Despliegue: Docker + Coolify

## Verificacion rapida

Desde la raiz:

```bash
dotnet build ImperiusDraconisAPI/ImperiusDraconisAPI/ImperiusDraconisAPI.csproj --no-restore
dotnet test ImperiusDraconisAPI/ImperiusDraconisAPI.Tests/ImperiusDraconisAPI.Tests.csproj --no-restore
```

Resultado de la auditoria:

- Build: `0` errores, `0` advertencias.
- Tests existentes: `30/30` aprobados.
- `main` local coincide con `origin/main`.
