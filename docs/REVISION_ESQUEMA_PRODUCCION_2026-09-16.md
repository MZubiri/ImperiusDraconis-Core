# Revisión del esquema de producción — 2026-09-16

**Estado de la revisión inicial (antes de preparar 018):** la remediación no estaba validada para desplegar sobre la base existente. Las pruebas anteriores verificaron una instalación nueva con las migraciones convertidas. La inspección de producción y su reproducción local muestran diferencias que requieren una migración correctiva para bases ya existentes.

## Origen verificado y alcance

- Se verificó el proyecto y entorno del [enlace de Coolify proporcionado](http://147.15.100.230:8000/project/tzz6i0hapls1d88xf3umutrq/environment/gto9j4abu2blvipdj6w6c8dc): `My first project`, entorno `production`.
- La configuración de la API apunta al contenedor `imperius-mysql`, base `db_abc489_id`.
- Motor: MySQL **8.0.46**, InnoDB, `utf8mb4_unicode_ci`, zona horaria del sistema UTC y modo estricto habilitado.
- API desplegada: `9219efc`; frontend desplegado: `d8de8b6`. La remediación local no está desplegada.
- Los dominios configurados en el proxy son `api.imperiusdraconis.online` e `imperiusdraconis.online`.
- Se consultaron metadatos y conteos agregados. No se descargaron filas de alumnos ni credenciales. No se ejecutaron migraciones, escrituras, reinicios o despliegues en producción.

La carpeta `VPS ORACLE` contiene los accesos usados para identificar el servicio. Se exportó únicamente el esquema, sin datos, a archivos temporales locales con acceso restringido. Todas las pruebas de escritura se hicieron en un contenedor local desechable.

## Qué coincide y qué difiere

Producción contiene **59 tablas y 377 columnas**. Las 377 columnas coinciden con las de [`esquema_mysql.sql`](../esquema_mysql.sql) en nombre, tipo, nulabilidad, valor por defecto y atributos adicionales. Esta comprobación de columnas no implica igualdad de todos los objetos de la base.

Al compararla con una instalación nueva generada por `SQLMigrar`:

| Diferencia | Resultado | Consecuencia |
|---|---|---|
| Valores por defecto | 59 defaults del esquema nuevo no existen en columnas presentes en producción | Los INSERT que omiten esos campos pueden fallar; el total incluye las nuevas definiciones de RowVersion |
| Tipos | 33 diferencias | Entre ellas DATETIME frente a DATETIME(3), TEXT frente a LONGTEXT y tipos de RowVersion |
| Restricciones CHECK | Producción no tiene CHECK; las migraciones definen 54 | Las reglas no quedan protegidas por la base actual |
| Unicidad condicional Game | Faltan cinco índices únicos y sus columnas generadas | Falta protección ante duplicados de códigos activos, recompensa de bienvenida, dragón seleccionado y transferencia pendiente |
| RefreshTokens | No existe en producción | La migración 017 sí crea correctamente la tabla en la copia del esquema real |

Los cinco índices ausentes son:

- `UX_GameLinkCodes_Active_IdAlumno`
- `UX_GameLinkCodes_Active_CodeHash`
- `UX_GameDracoinLedger_WelcomeLink_IdAlumno`
- `UX_GameDragons_IdAlumno_Selected`
- `UX_GameEggTransfers_EggId_Pending`

El repositorio `esquema_mysql.sql` ya refleja la ausencia de defaults. Convertir sintaxis en los servicios o modificar scripts de creación no corrige por sí solo esas tablas existentes.

## Fallos reproducidos localmente

Se restauró el esquema real **sin datos**. Para aislar la ausencia de defaults en los INSERT de prueba se deshabilitaron las claves foráneas solo en la sesión de esa copia local; las escrituras de prueba se envolvieron en transacciones.

| Operación | Error MySQL reproducido |
|---|---|
| Reservar idempotencia | 1364: `CreatedAt` no tiene default |
| Crear huevo | 1364: `AcquiredAt` no tiene default |
| Crear dragón | 1364: `Selected` no tiene default |
| Crear transferencia de huevo | 1364: `CreatedAt` no tiene default |
| Insertar movimiento de Dracoins | 1364: `CreatedAt` no tiene default |
| Crear chisme | 1364: `FechaEnvio` no tiene default |

Son errores reproducidos en la copia, no afirmaciones obtenidas de logs de solicitudes reales. Pueden existir otros fallos: cada INSERT se detiene ante el primer campo obligatorio omitido.

También se ejecutaron los scripts actuales sobre esa copia:

| Script | Resultado |
|---|---|
| 005 — definición de huevo | Error 1644: detecta aplicación parcial; existe la columna pero falta el CHECK |
| 013 — siembra de Biblioteca | Error 1364: `FechaRegistro` no tiene default |
| 016 — portada pública | Error 1364: `FechaActualizacion` no tiene default |
| 017 — refresh tokens | Creación correcta |
| Restantes scripts | Finalizan, pero las ramas que omiten tablas existentes no reparan los defaults ni las restricciones faltantes |

Los fallos de siembra se reprodujeron en una copia sin filas. En producción esas ramas pueden depender de qué registros ya existen; el error 005 depende del esquema y sí es directamente aplicable.

## Datos existentes: comprobación agregada

Las consultas de comprobación se ejecutaron con transacciones de solo lectura y límite de tiempo por consulta. Hay datos reales en Game: 5 códigos, 1 vínculo Roblox, 1 capacidad, 3 movimientos, 3 registros de idempotencia, 2 huevos, 15 definiciones, 1 dragón y 0 transferencias. Biblioteca contiene 907 libros.

- Ninguna fila viola las 54 expresiones CHECK propuestas, en el momento de la revisión.
- No se detectaron grupos duplicados en las cinco reglas de unicidad condicional anteriores.
- No se copió el contenido de esos registros.

Estos conteos no garantizan que los datos sigan cumpliendo las reglas al momento de una futura migración; debe repetirse la comprobación inmediatamente antes de aplicarla.

## Ajuste necesario al plan

1. Usar la copia del esquema real como base de las pruebas de actualización, además de conservar las pruebas de instalación nueva.
2. Preparar una migración de reconciliación para tablas existentes: defaults que usan los INSERT, tipos que realmente necesiten cambiar, CHECKs e índices únicos faltantes. Revisar también `Chismes`, cuya fecha no está cubierta por los scripts de creación remediados.
3. Evitar ejecutar indiscriminadamente 001–016 como procedimiento de actualización. Varias migraciones solo crean objetos ausentes o rechazan instalaciones parciales.
4. Probar en la copia tanto la reconciliación como la migración 017, su repetibilidad y los flujos afectados. La creación correcta de 017 por sí sola no valida todo el sistema de autenticación en producción.
5. Considerar que el inicializador de la API ejecuta una selección de scripts; no aplica todas las migraciones Game. La reconciliación necesita un paso explícito de despliegue, con respaldo y recuperación definidos.

Durante esta revisión inicial aún no se había creado ni aplicado esa migración correctiva. Los 16 commits existentes conservan su validación de compilación, pruebas y esquema nuevo; esos resultados no equivalen a validar la actualización del esquema de producción.

## Validación posterior a la autorización de despliegue

Se descargó un respaldo completo y se verificó su restauración con 59 tablas, 726 alumnos y 907 libros. La nueva migración 018, junto con 017, pasó dos ejecuciones sobre la copia restaurada. Los hashes normalizados de todas las filas de las 59 tablas originales coincidieron antes y después. Las pruebas funcionales sobre otra copia desechable cubren autenticación, rotación, compra e incubación de huevos, eclosión, saldos, chismes, notas e importación de libros.

Las instrucciones de actualización están en [scripts/README.md](../ImperiusDraconisAPI/scripts/README.md). Esta sección acredita la validación local; el estado efectivo del despliegue se registra por separado.
