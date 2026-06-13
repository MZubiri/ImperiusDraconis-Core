# Reporte de Limpieza de Base de Datos - Proyecto ID

Este análisis compara las tablas declaradas en el script de base de datos `IDporLimpiar.sql` contra el código activo del proyecto `IDNUEVO` (tanto en la API de C# .NET como en el frontend de Angular). El objetivo es identificar qué tablas están en desuso y pueden ser eliminadas de forma segura.

---

## Resumen del Análisis

- **Base de Datos Analizada:** SQL Server (`db_abc489_id`)
- **Total de tablas encontradas en el script:** 83
- **Tablas en uso activo:** 49
- **Tablas sin uso (candidatas a eliminación):** 34

---

## 🚫 Tablas sin Uso Activo (Candidatas a Eliminación)

Estas tablas no tienen ninguna referencia en el código C# de la API ni en el frontend de Angular (los únicos aciertos fueron falsos positivos en comentarios o nombres de clases de iconos).

### 1. Tablas del Sistema de Membresía de ASP.NET Legacy (SmartASP)
Estas tablas suelen ser generadas automáticamente por SmartASP o por el asistente de configuración de membresía antigua (`aspnet_regsql.exe`). Dado que el proyecto actual utiliza autenticación moderna basada en JWT y tablas personalizadas, todas son prescindibles.

- `aspnet_Applications`
- `aspnet_Membership`
- `aspnet_Paths`
- `aspnet_PersonalizationAllUsers`
- `aspnet_PersonalizationPerUser`
- `aspnet_Profile`
- `aspnet_Roles`
- `aspnet_SchemaVersions`
- `aspnet_Users`
- `aspnet_UsersInRoles`
- `aspnet_WebEvent_Events`

### 2. Tablas Obsoletas de Usuarios y Roles
En la API actual, los datos de los usuarios se manejan en `Alumnos`, y la seguridad en `Permisos` / `PermisosTrabajos`. Las siguientes tablas genéricas de usuarios y roles están inactivas:

- `Users`
- `Usuarios`
- `Roles`
- `UserRoles`

### 3. Módulos y Funcionalidades en Desuso
Tablas de características que no se encuentran implementadas en el código de la API actual (posibles experimentos pasados, tutoriales o funcionalidades eliminadas):

- **Libros / Exámenes / Investigaciones:**
  - `Books`
  - `BookCategories`
  - `Exams`
  - `ExamCategories`
  - `Researches`
  - `ResearchCategories`
- **Pagos y Finanzas antiguos:**
  - `PagosMascotas`
  - `PagosMensuales`
  - `Impuestos anuales` (tabla residual en español con espacio)
- **Otros remanentes / Respaldos:**
  - `Alumnos_Backup_Codigos` (tabla de respaldo manual)
  - `BoardMembers`
  - `ComidasDragon`
  - `Comisiones`
  - `ContactMessages`
  - `Events` (no confundir con eventos de UI o logs de auditoría)
  - `FormasDragon`
  - `HistorialDragon`
  - `JuegosPartidas`
  - `Servicios`

---

## 🛠️ Tablas en Uso Activo (No Eliminar)

Estas 49 tablas tienen referencias directas en el backend de C# y controlan la lógica de negocio actual del juego, auditoría y tienda.

| Tabla | Referencias C# | Archivo Principal de Control |
|---|---|---|
| `Alumnos` | 140 | [AlumnosService.cs](file:///home/guss/Desktop/Proyectos/IDNUEVO/ImperiusDraconisAPI/ImperiusDraconisAPI/Services/AlumnosService.cs) |
| `Mascotas` | 54 | [MascotasService.cs](file:///home/guss/Desktop/Proyectos/IDNUEVO/ImperiusDraconisAPI/ImperiusDraconisAPI/Services/MascotasService.cs) |
| `Permisos` | 46 | [PermisosService.cs](file:///home/guss/Desktop/Proyectos/IDNUEVO/ImperiusDraconisAPI/ImperiusDraconisAPI/Services/PermisosService.cs) |
| `Trabajos` | 41 | [TrabajosService.cs](file:///home/guss/Desktop/Proyectos/IDNUEVO/ImperiusDraconisAPI/ImperiusDraconisAPI/Services/TrabajosService.cs) |
| `Dinamicas` | 37 | [DinamicasService.cs](file:///home/guss/Desktop/Proyectos/IDNUEVO/ImperiusDraconisAPI/ImperiusDraconisAPI/Services/DinamicasService.cs) |
| `Productos` | 31 | [ProductosService.cs](file:///home/guss/Desktop/Proyectos/IDNUEVO/ImperiusDraconisAPI/ImperiusDraconisAPI/Services/ProductosService.cs) |
| `Pedidos` | 28 | [TiendaService.cs](file:///home/guss/Desktop/Proyectos/IDNUEVO/ImperiusDraconisAPI/ImperiusDraconisAPI/Services/TiendaService.cs) |
| `Asignaciones` | 18 | [DinamicasService.cs](file:///home/guss/Desktop/Proyectos/IDNUEVO/ImperiusDraconisAPI/ImperiusDraconisAPI/Services/DinamicasService.cs) |
| `Casas` | 18 | [AlumnosService.cs](file:///home/guss/Desktop/Proyectos/IDNUEVO/ImperiusDraconisAPI/ImperiusDraconisAPI/Services/AlumnosService.cs) |
| `MascotasPorAlumno` | 17 | [MascotasService.cs](file:///home/guss/Desktop/Proyectos/IDNUEVO/ImperiusDraconisAPI/ImperiusDraconisAPI/Services/MascotasService.cs) |
| `Cargos` | 16 | [AlumnosService.cs](file:///home/guss/Desktop/Proyectos/IDNUEVO/ImperiusDraconisAPI/ImperiusDraconisAPI/Services/AlumnosService.cs) |
| `GameEggs` | 15 | [GameEggService.cs](file:///home/guss/Desktop/Proyectos/IDNUEVO/ImperiusDraconisAPI/ImperiusDraconisAPI/Services/Game/GameEggService.cs) |
| `GameRobloxLinks` | 14 | [GameEggService.cs](file:///home/guss/Desktop/Proyectos/IDNUEVO/ImperiusDraconisAPI/ImperiusDraconisAPI/Services/Game/GameEggService.cs) |
| `MarcadorActual` | 14 | [MarcadoresController.cs](file:///home/guss/Desktop/Proyectos/IDNUEVO/ImperiusDraconisAPI/ImperiusDraconisAPI/Controllers/MarcadoresController.cs) |
| `ProductosRincon` | 11 | [RinconService.cs](file:///home/guss/Desktop/Proyectos/IDNUEVO/ImperiusDraconisAPI/ImperiusDraconisAPI/Services/RinconService.cs) |
| `HistorialAccesos` | 9 | [AuditoriaService.cs](file:///home/guss/Desktop/Proyectos/IDNUEVO/ImperiusDraconisAPI/ImperiusDraconisAPI/Services/Auditoria/AuditoriaService.cs) |
| `PedidosRincon` | 9 | [RinconService.cs](file:///home/guss/Desktop/Proyectos/IDNUEVO/ImperiusDraconisAPI/ImperiusDraconisAPI/Services/RinconService.cs) |
| `PermisosTrabajos` | 9 | [TrabajosService.cs](file:///home/guss/Desktop/Proyectos/IDNUEVO/ImperiusDraconisAPI/ImperiusDraconisAPI/Services/TrabajosService.cs) |
| `AlumnoPreferencias` | 8 | [UserPreferencesService.cs](file:///home/guss/Desktop/Proyectos/IDNUEVO/ImperiusDraconisAPI/ImperiusDraconisAPI/Services/UserPreferencesService.cs) |
| `Chismes` | 7 | [ChismesService.cs](file:///home/guss/Desktop/Proyectos/IDNUEVO/ImperiusDraconisAPI/ImperiusDraconisAPI/Services/ChismesService.cs) |
| `MovimientosDracoins` | 7 | [DracoinsService.cs](file:///home/guss/Desktop/Proyectos/IDNUEVO/ImperiusDraconisAPI/ImperiusDraconisAPI/Services/DracoinsService.cs) |
| `AgendaDinamicas` | 6 | [DinamicasService.cs](file:///home/guss/Desktop/Proyectos/IDNUEVO/ImperiusDraconisAPI/ImperiusDraconisAPI/Services/DinamicasService.cs) |
| `AlumnosTrabajos` | 6 | [TrabajosService.cs](file:///home/guss/Desktop/Proyectos/IDNUEVO/ImperiusDraconisAPI/ImperiusDraconisAPI/Services/TrabajosService.cs) |
| `AuditoriaEventos` | 6 | [AuditoriaService.cs](file:///home/guss/Desktop/Proyectos/IDNUEVO/ImperiusDraconisAPI/ImperiusDraconisAPI/Services/Auditoria/AuditoriaService.cs) |
| `DracoinsDinamica` | 6 | [DinamicasService.cs](file:///home/guss/Desktop/Proyectos/IDNUEVO/ImperiusDraconisAPI/ImperiusDraconisAPI/Services/DinamicasService.cs) |
| `ResultadosPorCasa` | 6 | [DinamicasService.cs](file:///home/guss/Desktop/Proyectos/IDNUEVO/ImperiusDraconisAPI/ImperiusDraconisAPI/Services/DinamicasService.cs) |
| `GameDragonCapacity` | 5 | [GamePlayerService.cs](file:///home/guss/Desktop/Proyectos/IDNUEVO/ImperiusDraconisAPI/ImperiusDraconisAPI/Services/Game/GamePlayerService.cs) |
| `GameDragons` | 5 | [GameDragonService.cs](file:///home/guss/Desktop/Proyectos/IDNUEVO/ImperiusDraconisAPI/ImperiusDraconisAPI/Services/Game/GameDragonService.cs) |
| `GameEggTransfers` | 5 | [GameEggService.cs](file:///home/guss/Desktop/Proyectos/IDNUEVO/ImperiusDraconisAPI/ImperiusDraconisAPI/Services/Game/GameEggService.cs) |
| `DetallePedidos` | 4 | [TiendaService.cs](file:///home/guss/Desktop/Proyectos/IDNUEVO/ImperiusDraconisAPI/ImperiusDraconisAPI/Services/TiendaService.cs) |
| `DispositivosAlumno` | 4 | [AuditoriaService.cs](file:///home/guss/Desktop/Proyectos/IDNUEVO/ImperiusDraconisAPI/ImperiusDraconisAPI/Services/Auditoria/AuditoriaService.cs) |
| `Dragones` | 4 | [GamePlayersController.cs](file:///home/guss/Desktop/Proyectos/IDNUEVO/ImperiusDraconisAPI/ImperiusDraconisAPI/Controllers/Game/GamePlayersController.cs) |
| `GameEggDefinitions` | 4 | [GameEggService.cs](file:///home/guss/Desktop/Proyectos/IDNUEVO/ImperiusDraconisAPI/ImperiusDraconisAPI/Services/Game/GameEggService.cs) |
| `GameLinkCodes` | 4 | [GameLinkService.cs](file:///home/guss/Desktop/Proyectos/IDNUEVO/ImperiusDraconisAPI/ImperiusDraconisAPI/Services/Game/GameLinkService.cs) |
| `ResumenAuditoriaAccesos` | 4 | [AuditoriaService.cs](file:///home/guss/Desktop/Proyectos/IDNUEVO/ImperiusDraconisAPI/ImperiusDraconisAPI/Services/Auditoria/AuditoriaService.cs) |
| `DetallesPedidoRincon` | 3 | [RinconService.cs](file:///home/guss/Desktop/Proyectos/IDNUEVO/ImperiusDraconisAPI/ImperiusDraconisAPI/Services/RinconService.cs) |
| `EstadosPedido` | 3 | [TiendaService.cs](file:///home/guss/Desktop/Proyectos/IDNUEVO/ImperiusDraconisAPI/ImperiusDraconisAPI/Services/TiendaService.cs) |
| `ExcepcionesAuditoria` | 3 | [AuditoriaService.cs](file:///home/guss/Desktop/Proyectos/IDNUEVO/ImperiusDraconisAPI/ImperiusDraconisAPI/Services/Auditoria/AuditoriaService.cs) |
| `GameIdempotency` | 3 | [GameIdempotencyService.cs](file:///home/guss/Desktop/Proyectos/IDNUEVO/ImperiusDraconisAPI/ImperiusDraconisAPI/Services/Game/GameIdempotencyService.cs) |
| `HistorialEstadosPedido` | 1 | [TiendaService.cs](file:///home/guss/Desktop/Proyectos/IDNUEVO/ImperiusDraconisAPI/ImperiusDraconisAPI/Services/TiendaService.cs) |
| `HistorialMarcadores` | 3 | [MarcadoresService.cs](file:///home/guss/Desktop/Proyectos/IDNUEVO/ImperiusDraconisAPI/ImperiusDraconisAPI/Services/MarcadoresService.cs) |
| `NotasAlumno` | 3 | [AlumnosService.cs](file:///home/guss/Desktop/Proyectos/IDNUEVO/ImperiusDraconisAPI/ImperiusDraconisAPI/Services/AlumnosService.cs) |
| `PagosAdministrativos` | 3 | [DracoinsService.cs](file:///home/guss/Desktop/Proyectos/IDNUEVO/ImperiusDraconisAPI/ImperiusDraconisAPI/Services/DracoinsService.cs) |
| `SueldosCargo` | 3 | [DracoinsService.cs](file:///home/guss/Desktop/Proyectos/IDNUEVO/ImperiusDraconisAPI/ImperiusDraconisAPI/Services/DracoinsService.cs) |
| `ChismeImagenes` | 2 | [ChismesService.cs](file:///home/guss/Desktop/Proyectos/IDNUEVO/ImperiusDraconisAPI/ImperiusDraconisAPI/Services/ChismesService.cs) |
| `CuentasEspeciales` | 2 | [AuditoriaService.cs](file:///home/guss/Desktop/Proyectos/IDNUEVO/ImperiusDraconisAPI/ImperiusDraconisAPI/Services/Auditoria/AuditoriaService.cs) |
| `CuentasVinculadas` | 2 | [AuditoriaService.cs](file:///home/guss/Desktop/Proyectos/IDNUEVO/ImperiusDraconisAPI/ImperiusDraconisAPI/Services/Auditoria/AuditoriaService.cs) |
| `DecisionesAdministrativas` | 2 | [AuditoriaService.cs](file:///home/guss/Desktop/Proyectos/IDNUEVO/ImperiusDraconisAPI/ImperiusDraconisAPI/Services/Auditoria/AuditoriaService.cs) |
| `GameDracoinLedger` | 2 | [DracoinGameService.cs](file:///home/guss/Desktop/Proyectos/IDNUEVO/ImperiusDraconisAPI/ImperiusDraconisAPI/Services/Game/DracoinGameService.cs) |

---

## 🚀 Plan Recomendado para la Limpieza

> [!WARNING]
> Nunca elimines tablas directamente en producción sin antes realizar respaldos completos y verificar la integridad de la aplicación en desarrollo.

### Paso 1: Generar un respaldo completo
Antes de ejecutar cualquier cambio, obtén un respaldo completo (`.bak` o exportación en script de estructura + datos) de la base de datos de producción.

### Paso 2: Generar y Ejecutar el Script de Eliminación en Desarrollo/Staging
Aplica la eliminación de las 34 tablas inactivas en tu entorno de pruebas usando este script SQL:

```sql
-- 1. Eliminar tablas de membresia aspnet
DROP TABLE IF EXISTS [dbo].[aspnet_UsersInRoles];
DROP TABLE IF EXISTS [dbo].[aspnet_Membership];
DROP TABLE IF EXISTS [dbo].[aspnet_Profile];
DROP TABLE IF EXISTS [dbo].[aspnet_Roles];
DROP TABLE IF EXISTS [dbo].[aspnet_PersonalizationPerUser];
DROP TABLE IF EXISTS [dbo].[aspnet_PersonalizationAllUsers];
DROP TABLE IF EXISTS [dbo].[aspnet_Paths];
DROP TABLE IF EXISTS [dbo].[aspnet_SchemaVersions];
DROP TABLE IF EXISTS [dbo].[aspnet_WebEvent_Events];
DROP TABLE IF EXISTS [dbo].[aspnet_Users];
DROP TABLE IF EXISTS [dbo].[aspnet_Applications];

-- 2. Eliminar tablas obsoletas de usuarios y roles
DROP TABLE IF EXISTS [dbo].[UserRoles];
DROP TABLE IF EXISTS [dbo].[Users];
DROP TABLE IF EXISTS [dbo].[Usuarios];
DROP TABLE IF EXISTS [dbo].[Roles];

-- 3. Eliminar tablas de caracteristicas en desuso
DROP TABLE IF EXISTS [dbo].[Alumnos_Backup_Codigos];
DROP TABLE IF EXISTS [dbo].[BoardMembers];
DROP TABLE IF EXISTS [dbo].[BookCategories];
DROP TABLE IF EXISTS [dbo].[Books];
DROP TABLE IF EXISTS [dbo].[ComidasDragon];
DROP TABLE IF EXISTS [dbo].[Comisiones];
DROP TABLE IF EXISTS [dbo].[ContactMessages];
DROP TABLE IF EXISTS [dbo].[Events];
DROP TABLE IF EXISTS [dbo].[ExamCategories];
DROP TABLE IF EXISTS [dbo].[Exams];
DROP TABLE IF EXISTS [dbo].[FormasDragon];
DROP TABLE IF EXISTS [dbo].[HistorialDragon];
DROP TABLE IF EXISTS [dbo].[Impuestos anuales];
DROP TABLE IF EXISTS [dbo].[JuegosPartidas];
DROP TABLE IF EXISTS [dbo].[PagosMascotas];
DROP TABLE IF EXISTS [dbo].[PagosMensuales];
DROP TABLE IF EXISTS [dbo].[ResearchCategories];
DROP TABLE IF EXISTS [dbo].[Researches];
DROP TABLE IF EXISTS [dbo].[Servicios];
```

### Paso 3: Probar la aplicación localmente
1. Levanta la API (`dotnet run`) y el Frontend Angular (`npm start` o `ng serve`).
2. Realiza flujos básicos (registro, inicio de sesión, juego de dragones, compras en la tienda, etc.) para asegurarte de que no existan dependencias ocultas o dinámicas.

### Paso 4: Aplicar en Producción
Una vez comprobado que no hay fallos locales, ejecuta el script de eliminación en producción.
