# Persistencia de Huevos Game

Estado: **implementada localmente; migracion pendiente de aplicar**

## Alcance

Este incremento permite que un alumno posea huevos persistidos y que Bootstrap los
devuelva al servidor Roblox. No incluye compra, regalo, endpoints publicos de huevos,
eclosion, dragones ni interfaz Roblox.

## Migracion

Ejecutar despues de `003_create_game_epic1.sql`:

```text
SQLMigrar/004_create_game_eggs.sql
```

La migracion crea exclusivamente `dbo.GameEggs`. Es repetible: si la tabla ya existe,
finaliza sin modificarla.

## Estados

| Estado | Significado | Fechas de incubacion |
|---|---|---|
| `OWNED` | Huevo propiedad del jugador, sin incubar | Nulas |
| `INCUBATING` | Incubacion iniciada | Obligatorias |
| `READY_TO_HATCH` | El tiempo de incubacion termino | Obligatorias |
| `HATCHED` | Reservado para la futura eclosion | Obligatorias |

Cuando un registro persiste como `INCUBATING` y `IncubationEndsAt` ya vencio, el
servicio lo devuelve como `READY_TO_HATCH` sin necesitar Worker ni modificarlo durante
la lectura.

## Rarezas

Valores permitidos:

```text
COMMON
RARE
EPIC
LEGENDARY
MYTHIC
```

La rareza se fija al crear el huevo y el CRUD interno no permite cambiarla.

## Servicio interno

`GameEggService` ofrece:

- `CreateAsync`: crea un huevo `OWNED` si el alumno esta activo y tiene capacidad.
- `GetByIdAsync`: obtiene un huevo.
- `ListByPlayerAsync`: lista huevos y calcula su estado efectivo.
- `UpdateAsync`: actualiza estado y fechas con transiciones controladas.
- `DeleteAsync`: elimina un huevo solamente mientras permanece `OWNED`.

El servicio no se expone mediante controlador. La creación usa una transaccion
serializable para impedir que dos operaciones llenen el mismo ultimo espacio.

`HATCHED` existe en SQL y en el contrato, pero `UpdateAsync` no permite alcanzarlo:
la futura historia de eclosion debera hacerlo de forma transaccional junto con la
creacion del dragon.

## Bootstrap

`GET /api/game/v1/players/by-roblox/{robloxUserId}` devuelve:

```json
"eggs": [
  {
    "id": 42,
    "rarity": "RARE",
    "acquiredAt": "2026-06-09T18:00:00Z",
    "incubationStartedAt": null,
    "incubationEndsAt": null,
    "status": "OWNED"
  }
]
```

`availableSlots` resta huevos con estado `OWNED`, `INCUBATING` o
`READY_TO_HATCH`. Los registros `HATCHED` no ocupan espacio de huevo.

## Pendiente

- Aplicar `004_create_game_eggs.sql`.
- Validar Bootstrap contra SQL Server desplegado.
- Diseñar compra/adquisicion publica e idempotente.
- Diseñar incubacion y eclosion como historias separadas.
