# API Game Implementada

Ultima auditoria: **9 de junio de 2026**

## Base URL beta

```text
https://api-beta.imperiusdraconis.lat/api/game/v1
```

`https://beta.imperiusdraconis.lat` corresponde al frontend Angular y no enruta
`/api` al backend.

## Contrato de error Game

```json
{
  "code": "ERROR_CODE",
  "message": "Descripcion controlada"
}
```

## POST `/links/code`

Estado: **implementado y probado en produccion**.

Autenticacion: JWT Bearer de Imperius.

Body: ninguno. `IdAlumno` se obtiene de `ClaimTypes.NameIdentifier`.

Respuesta:

```json
{
  "code": "A7F9-K2QX",
  "expiresAt": "2026-06-09T20:30:00Z",
  "expiresInSeconds": 600
}
```

Comportamiento:

- Genera ocho caracteres con formato visible `XXXX-XXXX`.
- Guarda solo HMAC-SHA256.
- Revoca codigo pendiente anterior.
- Rechaza alumno inactivo o ya vinculado.

Errores relevantes: `PLAYER_INACTIVE`, `ALREADY_LINKED`.

## POST `/links/consume`

Estado: **implementado y probado en produccion**.

Headers:

```text
X-Game-Api-Key: <secret>
X-Idempotency-Key: <unique-value>
Content-Type: application/json
```

Request:

```json
{
  "code": "A7F9-K2QX",
  "robloxUserId": 123456789
}
```

Response:

```json
{
  "idAlumno": 3,
  "robloxUserId": 123456789,
  "displayName": "Nombre del alumno",
  "houseName": "Nombre de casa",
  "welcomeDracoins": 400,
  "balanceAfter": 84885,
  "baseSlots": 1,
  "purchasedSlots": 0,
  "totalSlots": 1,
  "maxCapacity": 10,
  "linkedAt": "2026-06-09T20:30:00Z"
}
```

Errores relevantes:

- `IDEMPOTENCY_KEY_REQUIRED`
- `IDEMPOTENCY_CONFLICT`
- `INVALID_LINK_CODE`
- `LINK_CODE_EXPIRED`
- `LINK_CODE_USED`
- `LINK_CODE_REVOKED`
- `ALREADY_LINKED`
- `ROBLOX_ALREADY_LINKED`
- `PLAYER_INACTIVE`

## GET `/players/by-roblox/{robloxUserId}`

Estado: **implementado localmente; pendiente de despliegue y prueba en produccion**.

Header:

```text
X-Game-Api-Key: <secret>
```

Respuesta:

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

Errores relevantes: `BUSINESS_RULE_ERROR`, `NOT_LINKED`, `PLAYER_INACTIVE`,
`PLAYER_DATA_INCOMPLETE`.

## Endpoints no implementados

No existen endpoints de huevos, dragones, capacidad comprable, misiones, combate o
ranking.

## Prueba manual

```bash
curl -X POST \
  "https://api-beta.imperiusdraconis.lat/api/game/v1/links/consume" \
  -H "Content-Type: application/json" \
  -H "X-Game-Api-Key: <API_KEY>" \
  -H "X-Idempotency-Key: <UNIQUE_KEY>" \
  -d '{"code":"A7F9-K2QX","robloxUserId":123456789}'
```

No usar `GET` y no usar el dominio del frontend.

Bootstrap:

```bash
curl \
  "https://api-beta.imperiusdraconis.lat/api/game/v1/players/by-roblox/123456789" \
  -H "X-Game-Api-Key: <API_KEY>"
```
