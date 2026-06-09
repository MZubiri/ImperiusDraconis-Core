# Persistencia de Huevos Game

Estado: **migracion 004 aplicada en produccion; migracion 005 pendiente de aplicar**

## Alcance

Este incremento permite que un alumno posea huevos persistidos y que Bootstrap los
devuelva al servidor Roblox. No incluye compra, regalo, endpoints publicos de huevos,
eclosion, dragones ni interfaz Roblox.

## Migracion

Migraciones:

```text
004_create_game_eggs.sql                     Aplicada en produccion
005_add_egg_definition_to_game_eggs.sql      Pendiente de aplicar
```

La migracion `005` agrega `EggDefinitionCode NVARCHAR(50) NULL` sin modificar `004`.
Los registros existentes conservan sus datos y quedan con código nulo.

Aplicar `005` antes de desplegar el backend que lee `EggDefinitionCode`.

## Tipo y rareza

`Rarity` no identifica el tipo del huevo. Huevos Hogar, Arcanos, de casa o
elementales pueden compartir rareza, pero difieren en apariencia, pool futuro,
duracion y origen.

`EggDefinitionCode` conserva esa identidad sin requerir todavía un catalogo:

```text
HOME
ARCANE
HOUSE_GRYFFINDOR
ELEMENTAL_FIRE
ELEMENTAL_WATER
CONSTELLATION
```

El código es nullable exclusivamente para huevos legacy creados antes de `005`.
`GameEggService.CreateAsync` lo exige y normaliza para todos los huevos nuevos.

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
    "eggDefinitionCode": "ELEMENTAL_FIRE",
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

- Aplicar `005_add_egg_definition_to_game_eggs.sql`.
- Validar Bootstrap contra SQL Server desplegado.
- Definir cómo clasificar manualmente huevos legacy con `EggDefinitionCode = NULL`,
  si existen.
- Diseñar compra/adquisicion publica e idempotente.
- Diseñar incubacion y eclosion como historias separadas.
