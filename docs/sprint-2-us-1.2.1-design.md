# Sprint 2 - Diseño Técnico US-1.2.1 Bootstrap

Estado: **implementado localmente; pendiente de despliegue y prueba en produccion**

> **Nota posterior:** la persistencia minima de huevos se agrego en un incremento
> separado. Bootstrap ya no devuelve siempre `eggs: []`; consultar
> [`game-eggs-persistence.md`](game-eggs-persistence.md).

## Objetivo

Permitir que el servidor Roblox cargue en una sola llamada el estado persistente
actual de un jugador vinculado.

## Alcance recomendado

El Sprint 2 debe reflejar exclusivamente datos existentes:

- Version del contrato.
- Perfil basico vinculado.
- Saldo de Dracoins.
- Capacidad inicial.
- Placeholders estables para sistemas futuros.

No debe crear tablas de huevos, dragones, misiones o ranking.

## Endpoint

```text
GET /api/game/v1/players/by-roblox/{robloxUserId}
X-Game-Api-Key: <secret>
```

Autenticacion: esquema existente `GameApiKey`.

## Contrato propuesto

```json
{
  "gameVersion": "1.0.0",
  "player": {
    "robloxUserId": 123456789,
    "displayName": "Nombre del alumno",
    "houseName": "Nombre de casa"
  },
  "economy": {
    "dracoins": 84885
  },
  "capacity": {
    "baseSlots": 1,
    "purchasedSlots": 0,
    "totalSlots": 1,
    "maxCapacity": 10,
    "availableSlots": 1
  },
  "eggs": [],
  "dragons": [],
  "selectedDragon": null,
  "ranking": null
}
```

No exponer `IdAlumno` salvo que exista una necesidad real del cliente Roblox.

## DTOs

```text
GamePlayerBootstrapResponse
GameBootstrapPlayerDto
GameBootstrapEconomyDto
GameBootstrapCapacityDto
GameBootstrapEggDto
GameBootstrapDragonDto
GameBootstrapRankingDto
```

Estructura recomendada:

| DTO | Propiedades |
|---|---|
| `GamePlayerBootstrapResponse` | `GameVersion`, `Player`, `Economy`, `Capacity`, `Eggs`, `Dragons`, `SelectedDragon`, `Ranking` |
| `GameBootstrapPlayerDto` | `RobloxUserId`, `DisplayName`, `HouseName` |
| `GameBootstrapEconomyDto` | `Dracoins` |
| `GameBootstrapCapacityDto` | `BaseSlots`, `PurchasedSlots`, `TotalSlots`, `MaxCapacity`, `AvailableSlots` |
| `GameBootstrapEggDto` | `Id`, `EggDefinitionCode`, `Rarity`, `AcquiredAt`, `IncubationStartedAt`, `IncubationEndsAt`, `Status` |
| `GameBootstrapDragonDto` | Reservado para Epic 2/3; Sprint 2 devuelve lista vacia |
| `GameBootstrapRankingDto` | Reservado para Epic 6; Sprint 2 devuelve `null` |

Las propiedades todavía reservadas deben ser tipos nominales, no `object` ni
diccionarios. `GameBootstrapEggDto` fue ampliado posteriormente por la persistencia
de huevos. Agregar propiedades JSON es compatible con clientes que ignoran campos
desconocidos.

## Configuracion

Agregar a `GameOptions`:

```text
Version = "1.0.0"
```

Variable:

```text
Game__Version=1.0.0
```

## Servicio y controlador

Crear:

```text
Controllers/Game/GamePlayersController.cs
Services/Game/GamePlayerService.cs
Models/Game/Players/
```

No agregar repositorio ni capa nueva.

## Flujo de datos

1. Validar API Key mediante esquema existente.
2. Validar `robloxUserId > 0`.
3. Consultar vínculo activo.
4. Consultar alumno activo y casa.
5. Consultar capacidad.
6. Construir respuesta con saldo y placeholders.
7. Devolver `404 NOT_LINKED` si no existe vínculo activo.
8. Devolver `403 PLAYER_INACTIVE` si el alumno fue desactivado.

## Consulta SQL necesaria

Una sola consulta es suficiente:

```sql
SELECT
    L.IdAlumno,
    L.RobloxUserId,
    A.Nombre AS DisplayName,
    ISNULL(C.Nombre, N'') AS HouseName,
    ISNULL(A.Dracoins, 0) AS Dracoins,
    CONVERT(BIT, ISNULL(A.Activo, 0)) AS Active,
    DC.PurchasedSlots,
    DC.MaxCapacity
FROM dbo.GameRobloxLinks L
INNER JOIN dbo.Alumnos A ON A.IdAlumno = L.IdAlumno
LEFT JOIN dbo.Casas C ON C.IdCasa = A.IdCasa
LEFT JOIN dbo.GameDragonCapacity DC ON DC.IdAlumno = A.IdAlumno
WHERE L.RobloxUserId = @RobloxUserId
  AND L.Active = 1;
```

El servicio debe distinguir:

- Sin vínculo activo: `NOT_LINKED`.
- Vínculo existente con alumno inactivo: `PLAYER_INACTIVE`.
- Capacidad ausente por inconsistencia: error interno controlado y alerta operativa.

Para distinguir alumno inactivo sin una segunda consulta, no filtrar `A.Activo` en
el SQL principal; leerlo como columna y validarlo en el servicio. Si
`PurchasedSlots` o `MaxCapacity` llegan nulos, devolver un error interno controlado:
el vínculo existe, pero sus datos de capacidad estan incompletos.

## Calculo de capacidad

Mientras no existan huevos ni dragones:

```text
baseSlots = Game__BaseDragonSlots
totalSlots = baseSlots + PurchasedSlots
availableSlots = totalSlots
```

Cuando existan huevos/dragones, `availableSlots` debera restar ocupacion real.

## Errores

| Codigo | HTTP | Caso |
|---|---:|---|
| `BUSINESS_RULE_ERROR` | 400 | `robloxUserId <= 0` |
| `NOT_LINKED` | 404 | No existe vínculo activo |
| `PLAYER_INACTIVE` | 403 | Alumno vinculado desactivado |

## Riesgos

1. Contrato prematuro para huevos/dragones puede requerir cambios futuros.
2. Un registro de capacidad ausente indicaria vínculo parcial o datos manualmente
   alterados.
3. `Alumnos.Dracoins` puede contener decimales heredados, aunque Game opera enteros.
4. `gameVersion` debe representar compatibilidad del contrato, no version de contenido.
5. No debe confiarse en un `RobloxUserId` enviado desde LocalScript; la llamada debe
   originarse en servidor Roblox.

## Dependencias

- US-1.1.2 desplegada.
- `GameApiKey` configurada.
- Tablas `GameRobloxLinks` y `GameDragonCapacity`.
- Tablas existentes `Alumnos` y `Casas`.

## Pruebas requeridas

- Jugador vinculado activo.
- Jugador no vinculado.
- Alumno vinculado pero inactivo.
- Capacidad con espacios comprados.
- Saldo `NULL` tratado como cero.
- API Key faltante o incorrecta.
- Contrato incluye `gameVersion` y placeholders estables.

## Definicion de terminado

- Endpoint implementado y documentado.
- No se crean tablas nuevas.
- No se adelantan sistemas futuros.
- Pruebas unitarias cubren mapeo, capacidad y contrato JSON.
- La validacion de integracion SQL queda pendiente del entorno desplegado.
- Roblox puede cargar una sesion vinculada con una unica llamada.

## Implementacion resultante

```text
Controllers/Game/GamePlayersController.cs
Models/Game/Players/GamePlayerBootstrapResponse.cs
Services/Game/GamePlayerService.cs
Services/Game/GamePlayerBootstrapMapper.cs
```

El endpoint usa una unica consulta SQL de lectura y el esquema existente
`GameApiKey`. No crea datos, no modifica tablas y no incluye sistemas futuros.
