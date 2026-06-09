# Imperius Dragons - Plan técnico Sprint 1 / Epic 1

## 1. Objetivo

Implementar la vinculación segura entre una cuenta existente de Imperius y una cuenta de Roblox, junto con la base económica mínima necesaria para que Roblox pueda consultar al jugador y otorgarle la recompensa inicial.

El alcance mantiene la arquitectura actual:

- Monolito ASP.NET Core 8.
- SQL Server mediante `Microsoft.Data.SqlClient`.
- Autenticación JWT existente para usuarios del portal.
- Una API Key compartida para llamadas servidor Roblox → backend.
- Sin Redis, microservicios, Workers ni infraestructura adicional.

## 2. Alcance de Epic 1

### Incluido

- Generación de un código temporal de ocho caracteres desde una sesión autenticada de Imperius.
- Consumo del código desde el servidor Roblox.
- Vinculación única entre `Alumnos` y `RobloxUserId`.
- Inicialización de capacidad con un espacio gratuito y máximo de diez.
- Recompensa de bienvenida de 400 Dracoins.
- Ledger económico para operaciones del juego.
- Idempotencia para operaciones económicas y de vinculación.
- Endpoint bootstrap para obtener el estado inicial del jugador vinculado.
- Contratos estables para que Roblox pueda integrarse sin depender de épicos futuros.

### Fuera de alcance

- Compra, incubación y transferencia de huevos.
- Creación, cuidado o selección de dragones.
- Combates, misiones y ranking real.
- Compra de espacios adicionales.
- Panel administrativo del juego.
- Desvinculación o cambio de cuenta Roblox.
- Endpoints genéricos para acreditar o debitar Dracoins.

El bootstrap expondrá campos reservados para huevos, dragones y ranking, pero devolverá colecciones vacías o valores nulos hasta implementar sus épicos correspondientes.

## 3. Estado actual relevante

El repositorio no tiene un proyecto separado llamado `Core`. El backend se encuentra en:

`ImperiusDraconisAPI/ImperiusDraconisAPI`

La solución actual ya ofrece piezas reutilizables:

- `Data/SqlConnectionFactory.cs`: creación centralizada de conexiones SQL.
- JWT configurado en `Program.cs`.
- Extracción de `IdAlumno` desde `ClaimTypes.NameIdentifier`.
- `Alumnos` como identidad principal y fuente del saldo `Dracoins`.
- `Casas` para enriquecer el perfil del jugador.
- `BusinessRuleException` para representar reglas de negocio.

No existe Entity Framework ni una capa de repositorios formal. Sprint 1 debe respetar el patrón actual de servicios que ejecutan SQL directamente, evitando introducir una arquitectura nueva solo para Game.

## 4. Ubicación del módulo Game

Game debe crearse como un módulo funcional dentro del proyecto ASP.NET Core existente, no como un proyecto, servicio o solución independiente.

Estructura recomendada:

```text
ImperiusDraconisAPI/ImperiusDraconisAPI/
├── Configuration/
│   └── GameOptions.cs
├── Controllers/
│   └── Game/
│       ├── GameLinksController.cs
│       └── GamePlayersController.cs
├── Models/
│   └── Game/
│       ├── Common/
│       ├── Economy/
│       ├── Links/
│       └── Players/
├── Security/
│   └── GameApiKeyAuthenticationHandler.cs
└── Services/
    └── Game/
        ├── DracoinGameService.cs
        ├── GameIdempotencyService.cs
        ├── GameLinkService.cs
        └── GamePlayerService.cs
```

Archivos complementarios:

```text
ImperiusDraconisAPI/ImperiusDraconisAPI.Tests/Game/
SQLMigrar/003_create_game_epic1.sql
```

### Responsabilidades

| Componente | Responsabilidad |
|---|---|
| `GameLinksController` | Generar y consumir códigos de vinculación. |
| `GamePlayersController` | Entregar el bootstrap por `RobloxUserId`. |
| `GameLinkService` | Reglas y transacción completa de vinculación. |
| `GamePlayerService` | Consultar y construir el estado inicial del jugador. |
| `DracoinGameService` | Modificar `Alumnos.Dracoins` y registrar el ledger dentro de una transacción. |
| `GameIdempotencyService` | Detectar reintentos, conflictos y devolver respuestas exitosas previas. |
| `GameApiKeyAuthenticationHandler` | Validar llamadas servidor a servidor desde Roblox. |
| `GameOptions` | API Key, pepper del código, expiración, recompensa y capacidad inicial. |

No se recomienda crear un `GameEconomyController` en este sprint. La economía debe quedar disponible como servicio interno para reducir la superficie de ataque.

## 5. Tablas SQL necesarias

Sprint 1 necesita cinco tablas nuevas. No debe adelantar las tablas de huevos, dragones, combates ni ranking.

### 5.1 `GameLinkCodes`

Almacena códigos temporales generados desde Imperius.

| Campo | Tipo recomendado | Regla |
|---|---|---|
| `Id` | `bigint identity` | Clave primaria. |
| `IdAlumno` | `int` | FK a `Alumnos`. |
| `CodeHash` | `binary(32)` | HMAC/hash del código; nunca texto plano. |
| `ExpiresAt` | `datetime2(3)` | Expira a los diez minutos. |
| `UsedAt` | `datetime2(3) null` | Fecha de consumo exitoso. |
| `RevokedAt` | `datetime2(3) null` | Invalida un código anterior al generar uno nuevo. |
| `CreatedAt` | `datetime2(3)` | Auditoría. |

Índices y reglas:

- Índice por `CodeHash`.
- FK hacia `Alumnos`.
- Solo un código no usado y no revocado por alumno.
- Al generar un código, revocar cualquier código activo anterior.
- La expiración debe validarse usando hora del servidor/SQL, nunca hora enviada por el cliente.

### 5.2 `GameRobloxLinks`

Representa la vinculación entre Imperius y Roblox.

| Campo | Tipo recomendado | Regla |
|---|---|---|
| `Id` | `bigint identity` | Clave primaria y referencia de la vinculación. |
| `IdAlumno` | `int` | FK a `Alumnos`, único. |
| `RobloxUserId` | `bigint` | Identificador numérico de Roblox, único. |
| `LinkedAt` | `datetime2(3)` | Fecha de vinculación. |
| `Active` | `bit` | Activa por defecto. |
| `UnlinkedAt` | `datetime2(3) null` | Reservado para una futura desvinculación administrativa. |

Reglas:

- Un alumno solo puede vincularse una vez.
- Un `RobloxUserId` solo puede pertenecer a un alumno.
- No se elimina físicamente una vinculación.
- Epic 1 no ofrece operación de desvinculación.

### 5.3 `GameDragonCapacity`

Inicializa la capacidad que usarán los épicos posteriores.

| Campo | Tipo recomendado | Regla |
|---|---|---|
| `IdAlumno` | `int` | PK y FK a `Alumnos`. |
| `PurchasedSlots` | `tinyint` | Inicia en cero. |
| `MaxCapacity` | `tinyint` | Inicia en diez. |
| `UpdatedAt` | `datetime2(3)` | Auditoría. |
| `RowVersion` | `rowversion` | Control optimista para futuras compras. |

Valores derivados:

- Espacios base: `1`.
- Capacidad total: `1 + PurchasedSlots`.
- Espacios disponibles en Sprint 1: capacidad total, porque todavía no existen dragones.

No se debe almacenar `AvailableSlots`, ya que será un valor calculado según dragones activos e incubaciones.

### 5.4 `GameDracoinLedger`

Registra de forma inmutable cada cambio económico ejecutado por el módulo Game.

| Campo | Tipo recomendado | Regla |
|---|---|---|
| `Id` | `bigint identity` | Clave primaria. |
| `IdAlumno` | `int` | FK a `Alumnos`. |
| `Amount` | `decimal(18,2)` | Positivo para crédito y negativo para débito. |
| `BalanceAfter` | `decimal(18,2)` | Saldo después de la operación. |
| `Reason` | `nvarchar(50)` | Motivo estable, por ejemplo `WELCOME_LINK`. |
| `ReferenceType` | `nvarchar(50)` | Tipo de entidad que originó el movimiento. |
| `ReferenceId` | `nvarchar(100) null` | Identificador de la entidad relacionada. |
| `CreatedAt` | `datetime2(3)` | Auditoría. |

Reglas:

- Nunca actualizar ni eliminar registros del ledger.
- El saldo materializado continúa en `Alumnos.Dracoins`.
- Toda modificación económica de Game actualiza saldo y ledger en la misma transacción.
- La recompensa de bienvenida debe tener una restricción semántica que impida duplicarla para un alumno, incluso usando otra clave de idempotencia.
- Aunque la columna existente acepta decimales, el MVP debe operar únicamente con Dracoins enteros.

### 5.5 `GameIdempotency`

Permite reintentar solicitudes sin repetir sus efectos.

| Campo | Tipo recomendado | Regla |
|---|---|---|
| `Id` | `bigint identity` | Clave primaria. |
| `Operation` | `nvarchar(100)` | Identifica el endpoint u operación. |
| `IdempotencyKey` | `nvarchar(100)` | Valor recibido en `X-Idempotency-Key`. |
| `RequestHash` | `binary(32)` | Detecta reutilización de clave con otro payload. |
| `Status` | `nvarchar(20)` | `Pending` o `Completed`. |
| `ResponseStatusCode` | `int null` | Código de respuesta exitosa almacenada. |
| `ResponseJson` | `nvarchar(max) null` | Respuesta que se devolverá en un reintento. |
| `CreatedAt` | `datetime2(3)` | Auditoría. |
| `CompletedAt` | `datetime2(3) null` | Finalización. |
| `ExpiresAt` | `datetime2(3) null` | Limpieza futura opcional; no requiere Worker. |

Reglas:

- Índice único compuesto por `Operation + IdempotencyKey`.
- La misma clave con payload diferente devuelve conflicto.
- El registro `Pending` debe crearse dentro de la misma transacción que protege la operación.
- La vinculación y la recompensa de bienvenida deben ser idempotentes.

## 6. Endpoints de Epic 1

### 6.1 Generar código de vinculación

`POST /api/game/v1/links/code`

Autenticación:

- JWT existente de Imperius.
- `IdAlumno` se obtiene del token; nunca del body.

Comportamiento:

1. Validar que el alumno esté activo.
2. Rechazar si ya tiene cuenta Roblox vinculada.
3. Revocar códigos anteriores no usados.
4. Generar un código criptográficamente aleatorio de ocho caracteres legibles.
5. Guardar únicamente su HMAC/hash.
6. Devolver código y fecha de expiración.

Formato presentado al jugador: `XXXX-XXXX`, por ejemplo `A7F9-K2QX`.

El backend debe normalizar el código removiendo el guion y convirtiéndolo a mayúsculas antes de calcular o comparar su hash. El alfabeto debe excluir caracteres ambiguos como `0`, `O`, `1` e `I`.

Respuesta conceptual:

- `code`
- `expiresAt`
- `expiresInSeconds`

No requiere idempotencia: solicitar un código nuevo invalida intencionalmente el anterior.

### 6.2 Consumir código desde Roblox

`POST /api/game/v1/links/consume`

Autenticación:

- Esquema dedicado mediante `X-Game-Api-Key`.
- Header obligatorio `X-Idempotency-Key`.

Body:

- `code`
- `robloxUserId`

Una única transacción debe:

1. Registrar o recuperar la solicitud idempotente.
2. Buscar y bloquear el código.
3. Validar que exista, no haya expirado, no haya sido usado y no esté revocado.
4. Verificar que alumno y `RobloxUserId` no estén vinculados.
5. Crear `GameRobloxLinks`.
6. Crear `GameDragonCapacity`.
7. Acreditar 400 Dracoins mediante `DracoinGameService`.
8. Insertar el ledger de bienvenida.
9. Marcar el código como usado.
10. Guardar la respuesta idempotente.
11. Confirmar la transacción.

Respuesta conceptual:

- Identidad pública del jugador.
- `robloxUserId`
- Casa.
- Dracoins acreditados.
- Saldo resultante.
- Capacidad inicial.
- Fecha de vinculación.

### 6.3 Obtener bootstrap del jugador

`GET /api/game/v1/players/by-roblox/{robloxUserId}`

Autenticación:

- `X-Game-Api-Key`.

Comportamiento:

- Validar que exista una vinculación activa.
- Validar que `Alumnos.Activo` continúe vigente.
- Consultar perfil, casa, saldo y capacidad.
- Entregar un contrato estable para Roblox.

Respuesta conceptual:

```text
gameVersion
player
  robloxUserId
  code
  displayName
  house
economy
  dracoins
capacity
  baseSlots
  purchasedSlots
  totalSlots
  maxCapacity
  availableSlots
eggs: []
dragons: []
selectedDragon: null
ranking: null
```

`gameVersion` inicia en `1.0.0` y representa la versión del contrato y comportamiento esperado por Roblox. Permitirá detectar incompatibilidades y mostrar un mensaje de actualización controlado antes de cargar la sesión.

No se deben crear tablas anticipadas para rellenar los campos todavía vacíos.

## 7. Autenticación y contrato de errores

### JWT Imperius

La generación de códigos reutiliza el JWT actual y el patrón existente para leer `ClaimTypes.NameIdentifier`.

### API Key Roblox

Se recomienda registrar un esquema de autenticación dedicado, por ejemplo `GameApiKey`, y aplicarlo únicamente a endpoints servidor Roblox → backend.

Configuración de ejecución:

- `Game__ApiKey`
- `Game__LinkCodePepper`
- `Game__LinkCodeExpirationMinutes=10`
- `Game__WelcomeDracoins=400`
- `Game__BaseDragonSlots=1`
- `Game__MaxDragonCapacity=10`
- `Game__Version=1.0.0`

La API Key y el pepper no deben guardarse en `appsettings.json` versionado ni aparecer en logs.

### Errores Game

Los endpoints Game necesitan errores estructurados y estables:

```text
code
message
```

Códigos mínimos:

- `INVALID_LINK_CODE`
- `LINK_CODE_EXPIRED`
- `LINK_CODE_USED`
- `LINK_CODE_REVOKED`
- `ALREADY_LINKED`
- `ROBLOX_ALREADY_LINKED`
- `NOT_LINKED`
- `PLAYER_INACTIVE`
- `IDEMPOTENCY_KEY_REQUIRED`
- `IDEMPOTENCY_CONFLICT`
- `INSUFFICIENT_DRACOINS`

Para evitar afectar controladores existentes, Game puede introducir una excepción específica derivada o paralela a `BusinessRuleException`, mapeada solo en sus controladores o mediante un filtro limitado al módulo.

## 8. Modelos existentes reutilizables

| Elemento actual | Reutilización recomendada |
|---|---|
| `SqlConnectionFactory` | Reutilizar directamente para conexiones y transacciones. |
| `Alumnos` | Identidad principal, estado activo y saldo materializado. |
| `Casas` | Nombre y datos básicos de la casa para bootstrap. |
| JWT actual | Autenticar la generación del código. |
| Patrón `ClaimTypes.NameIdentifier` | Resolver `IdAlumno` sin confiar en parámetros externos. |
| `BusinessRuleException` | Reutilizar su intención; especializar el contrato Game con códigos estables. |
| `AuthenticatedUserDto` | Reutilizar conceptos de perfil, no devolverlo directamente a Roblox. |
| `DracoinSummaryDto` | Reutilizar únicamente la semántica de saldo. |

### Elementos que no deben reutilizarse directamente

- `DracoinsService`: está orientado a transferencias y salarios del portal, y no garantiza ledger Game ni idempotencia.
- `MovimientosDracoins`: su estructura representa transferencias entre códigos y no un ledger económico general.
- Tablas/modelos heredados `Mascotas` o `Dragones`: no representan el nuevo diseño de Imperius Dragons.
- `AuthenticatedUserDto` completo: contiene información y permisos innecesarios para Roblox.
- `HasPermissionAttribute`: la vinculación depende de identidad autenticada, no de permisos administrativos.

## 9. Riesgos y mitigaciones

| Riesgo | Impacto | Mitigación para Sprint 1 |
|---|---|---|
| Doble consumo simultáneo del código | Dos vínculos o dos recompensas | Transacción SQL, bloqueo de fila y restricciones únicas. |
| Recompensa duplicada con distintas claves idempotentes | Inflación y abuso | Restricción semántica única para `WELCOME_LINK` por alumno. |
| Fuerza bruta sobre código de vinculación | Secuestro de vinculación | Ocho caracteres, expiración de diez minutos, HMAC con pepper, alfabeto sin caracteres ambiguos, API Key y límite básico de intentos. |
| API Key filtrada | Suplantación de llamadas Roblox | Secretos en Coolify, rotación documentada, no registrar headers y limitar endpoints protegidos. |
| Una misma clave idempotente con otro payload | Respuesta o efecto incorrecto | Guardar y comparar `RequestHash`. |
| Mutaciones de Dracoins fuera de Game | Ledger Game no reconcilia todo el saldo | Declarar que el ledger audita operaciones Game; centralizar otros movimientos en una fase futura. |
| Diferencia entre Dracoins decimales existentes y economía entera | Saldos inconsistentes | Validar montos enteros dentro de `DracoinGameService`. |
| Alumno desactivado después de vincularse | Acceso no deseado | Verificar `Alumnos.Activo` en cada bootstrap y operación futura. |
| Bootstrap depende de módulos futuros | Bloqueo de integración Roblox | Contrato estable con colecciones vacías y valores nulos. |
| Pruebas actuales sin SQL de integración | Errores transaccionales no detectados | Crear pruebas de integración específicas para SQL Server y concurrencia. |
| Scripts SQL ignorados por `.gitignore` | Migración ausente del repositorio o despliegue | Ajustar seguimiento del script y comprobarlo antes de integrar. |
| Política de desvinculación no definida | Casos de soporte ambiguos | No exponer desvinculación en Epic 1; documentar proceso manual futuro. |

## 10. Orden recomendado de implementación

### Paso 1. Cerrar contratos y decisiones

- Confirmar que la vinculación es permanente en MVP.
- Confirmar Dracoins enteros y recompensa de 400.
- Aprobar estructura del bootstrap con `gameVersion` y campos futuros vacíos.
- Aprobar errores Game y política de API Key.

Resultado: contratos que backend y Roblox pueden implementar sin cambios posteriores inmediatos.

### Paso 2. Crear migración SQL de Epic 1

- Crear las cinco tablas.
- Agregar FKs, checks, índices y restricciones únicas.
- Validar la migración sobre una copia de desarrollo.
- Verificar que el script quede rastreado por Git.

Resultado: persistencia lista antes de exponer endpoints.

### Paso 3. Implementar seguridad y configuración Game

- Crear `GameOptions`.
- Registrar esquema `GameApiKey`.
- Definir respuesta de errores Game.
- Configurar Swagger para JWT y API Key.

Resultado: límites de seguridad listos para los endpoints.

### Paso 4. Implementar economía e idempotencia internas

- Implementar `DracoinGameService`.
- Implementar reserva, conflicto y replay idempotente.
- Probar saldo insuficiente, crédito, rollback y concurrencia.

Resultado: base transaccional reutilizable por todos los épicos posteriores.

### Paso 5. Implementar generación de código

- Generar código criptográficamente aleatorio.
- Guardar HMAC/hash y revocar códigos previos.
- Exponer endpoint JWT.
- Probar expiración, rotación y alumno ya vinculado.

Resultado: el portal puede iniciar el flujo de vinculación.

### Paso 6. Implementar consumo transaccional

- Consumir código con bloqueo de fila.
- Crear vínculo y capacidad.
- Otorgar recompensa y ledger.
- Completar idempotencia.
- Probar solicitudes repetidas y simultáneas.

Resultado: Roblox puede completar la vinculación exactamente una vez.

### Paso 7. Implementar bootstrap

- Consultar jugador por `RobloxUserId`.
- Entregar saldo, casa y capacidad.
- Entregar `gameVersion` para validación de compatibilidad.
- Entregar placeholders estables para funcionalidades futuras.
- Probar `NOT_LINKED` y jugador inactivo.

Resultado: Roblox puede cargar la sesión del jugador.

### Paso 8. Integración de interfaces

En el portal Angular:

- Agregar una acción de vinculación al perfil existente.
- Mostrar código, expiración y opción de generar uno nuevo.

En Roblox Studio:

- Crear entrada del código.
- Llamar al consumo desde scripts de servidor, nunca desde LocalScripts.
- Ejecutar bootstrap al iniciar la sesión.

El proyecto Roblox no está presente en este repositorio; su implementación debe coordinarse como entregable separado.

### Paso 9. Pruebas y despliegue

- Ejecutar pruebas unitarias e integración SQL.
- Realizar prueba completa portal → Roblox → bootstrap.
- Configurar secretos en Coolify.
- Ejecutar migración controlada.
- Realizar smoke tests después del despliegue.

## 11. Estrategia de pruebas

### Pruebas unitarias

- Validación de códigos y fechas.
- Construcción del contrato bootstrap.
- Reglas de montos enteros.
- Mapeo de errores Game.

### Pruebas de integración SQL obligatorias

- Dos consumos simultáneos del mismo código: solo uno puede completar.
- Dos intentos de vincular el mismo `RobloxUserId`.
- Retry con misma clave y mismo payload: devuelve la respuesta previa.
- Misma clave con payload distinto: devuelve conflicto.
- Fallo durante recompensa: revierte vínculo, capacidad, ledger y código usado.
- Recompensa de bienvenida imposible de duplicar.
- Saldo y `BalanceAfter` coinciden.
- Bootstrap de vinculado, no vinculado e inactivo.
- Presencia y formato válido de `gameVersion`.

### Prueba manual de aceptación

1. Usuario autenticado genera código.
2. Roblox consume el código.
3. El usuario recibe exactamente 400 Dracoins.
4. Se crea capacidad total de un espacio.
5. Repetir el consumo no duplica ningún efecto.
6. Bootstrap devuelve `gameVersion`, el perfil correcto y listas futuras vacías.

## 12. Definición de terminado

Epic 1 se considera terminado cuando:

- Los tres endpoints están documentados y protegidos correctamente.
- No se almacena ni registra el código de vinculación en texto plano.
- Un alumno y un `RobloxUserId` no pueden vincularse más de una vez.
- Vínculo, capacidad, recompensa, ledger y consumo ocurren en una sola transacción.
- La recompensa inicial solo puede otorgarse una vez.
- Las operaciones repetibles son idempotentes.
- Roblox obtiene un bootstrap estable.
- El bootstrap informa `gameVersion` desde la primera versión.
- Existen pruebas de integración para rollback y concurrencia.
- Los secretos están configurados en Coolify y ausentes del repositorio.
- No se han creado tablas ni lógica de épicos futuros.

## 13. Decisiones recomendadas antes de programar

1. Mantener `Alumnos.Dracoins` como saldo oficial y usar `GameDracoinLedger` únicamente como historial inmutable de operaciones Game.
2. Tratar la vinculación como permanente durante el MVP; cualquier corrección será administrativa y manual.
3. Usar un esquema de autenticación API Key dedicado, no validaciones repetidas dentro de cada controlador.
4. Usar HMAC con un pepper secreto para localizar códigos sin guardar texto plano.
5. Exigir idempotencia en el consumo del vínculo y en todas las futuras operaciones económicas.
6. No crear endpoints genéricos para sumar Dracoins; cada recompensa futura debe tener una operación de negocio concreta.
7. No adelantar modelos de huevos, dragones ni ranking en Sprint 1.
8. Usar códigos de ocho caracteres con formato visible `XXXX-XXXX`; el guion no forma parte del valor normalizado.
9. Incluir `gameVersion` en el bootstrap y cambiarlo intencionalmente cuando exista una incompatibilidad para Roblox.
