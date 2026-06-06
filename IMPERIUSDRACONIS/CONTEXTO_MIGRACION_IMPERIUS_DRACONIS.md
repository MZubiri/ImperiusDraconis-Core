# Contexto De Migracion Imperius Draconis

Actualizado: 10 de marzo de 2026

## Objetivo

Migrar el sistema legado `Gestion_Grupo` hacia una arquitectura separada:

- Backend: ASP.NET Core Web API
- Frontend: Angular
- Base de datos: SQL Server local

La referencia funcional y estructural del sistema legado sigue siendo:

- `C:\Users\user\Desktop\Gestion_Grupo`

Los proyectos activos y correctos para continuar son:

- Backend: `C:\Users\user\Desktop\ImperiusDraconisAPI\ImperiusDraconisAPI`
- Frontend: `C:\Users\user\Desktop\IMPERIUSDRACONIS`

## Restricciones Importantes

- `Apocalipsis` no tiene relacion con este proyecto.
- No usar `Apocalipsis` como base funcional ni modificarlo.
- `Gestion_Grupo` se usa solo como referencia de logica, vistas y consultas SQL.
- El script original `IDULTIMO.sql` no debe sobrescribirse.

## Estado Actual

### Base de datos

Script original:

- `C:\Users\user\Desktop\IMPERIUSDRACONIS\IDULTIMO.sql`

Script adaptado para restauracion local:

- `C:\Users\user\Desktop\IMPERIUSDRACONIS\IDULTIMO.imperiusdraconis.sql`

Log de ejecucion:

- `C:\Users\user\Desktop\IMPERIUSDRACONIS\IDULTIMO.imperiusdraconis.log`

Base creada en SQL Server local:

- Nombre: `imperiusdraconis`
- Servidor: `DESKTOP-ACSKJNH`
- Usuario SQL: `sa`

Verificacion realizada:

- La base existe
- Hay `65` tablas
- Hay `675` registros en `dbo.Alumnos`
- Existe el procedimiento `dbo.ValidarLogin`

Advertencia conocida del script:

- Quedaron procedimientos legacy de `aspnet_Membership` con dependencias faltantes (`dbo.aspnet_Users_CreateUser`, `dbo.aspnet_Users_DeleteUser`)
- Eso no bloquea la API nueva actual

### Backend API

Proyecto:

- `C:\Users\user\Desktop\ImperiusDraconisAPI\ImperiusDraconisAPI`

Configuracion clave:

- `appsettings.Development.json` ya apunta a `imperiusdraconis`
- JWT configurado
- CORS configurado para `http://localhost:4200`

Archivos importantes:

- [Program.cs](C:/Users/user/Desktop/ImperiusDraconisAPI/ImperiusDraconisAPI/Program.cs)
- [appsettings.Development.json](C:/Users/user/Desktop/ImperiusDraconisAPI/ImperiusDraconisAPI/appsettings.Development.json)
- [AuthController.cs](C:/Users/user/Desktop/ImperiusDraconisAPI/ImperiusDraconisAPI/Controllers/AuthController.cs)
- [PerfilController.cs](C:/Users/user/Desktop/ImperiusDraconisAPI/ImperiusDraconisAPI/Controllers/PerfilController.cs)
- [AlumnosController.cs](C:/Users/user/Desktop/ImperiusDraconisAPI/ImperiusDraconisAPI/Controllers/AlumnosController.cs)
- [DracoinsController.cs](C:/Users/user/Desktop/ImperiusDraconisAPI/ImperiusDraconisAPI/Controllers/DracoinsController.cs)
- [MarcadoresController.cs](C:/Users/user/Desktop/ImperiusDraconisAPI/ImperiusDraconisAPI/Controllers/MarcadoresController.cs)
- [DinamicasController.cs](C:/Users/user/Desktop/ImperiusDraconisAPI/ImperiusDraconisAPI/Controllers/DinamicasController.cs)
- [MascotasController.cs](C:/Users/user/Desktop/ImperiusDraconisAPI/ImperiusDraconisAPI/Controllers/MascotasController.cs)
- [AuthService.cs](C:/Users/user/Desktop/ImperiusDraconisAPI/ImperiusDraconisAPI/Services/AuthService.cs)
- [AlumnosService.cs](C:/Users/user/Desktop/ImperiusDraconisAPI/ImperiusDraconisAPI/Services/AlumnosService.cs)
- [DracoinsService.cs](C:/Users/user/Desktop/ImperiusDraconisAPI/ImperiusDraconisAPI/Services/DracoinsService.cs)
- [MarcadoresService.cs](C:/Users/user/Desktop/ImperiusDraconisAPI/ImperiusDraconisAPI/Services/MarcadoresService.cs)
- [DinamicasService.cs](C:/Users/user/Desktop/ImperiusDraconisAPI/ImperiusDraconisAPI/Services/DinamicasService.cs)
- [MascotasService.cs](C:/Users/user/Desktop/ImperiusDraconisAPI/ImperiusDraconisAPI/Services/MascotasService.cs)

Endpoints ya implementados:

- `POST /api/auth/login`
- `GET /api/auth/me`
- `POST /api/auth/recuperar-contrasena`
- `GET /api/perfil`
- `PUT /api/perfil`
- `PUT /api/perfil/contrasena`
- `GET /api/alumnos`
- `GET /api/alumnos/{id}`
- `POST /api/alumnos`
- `PUT /api/alumnos/{id}`
- `PATCH /api/alumnos/{id}/estado`
- `DELETE /api/alumnos/{id}`
- `GET /api/alumnos/{id}/notas`
- `POST /api/alumnos/{id}/notas`
- `PUT /api/alumnos/{id}/contrasena`
- `GET /api/alumnos/casas`
- `GET /api/alumnos/cargos`
- `GET /api/alumnos/siguiente-codigo/{idCasa}`
- `GET /api/dracoins/resumen`
- `POST /api/dracoins/transferencias`
- `GET /api/dracoins/transferencias`
- `GET /api/dracoins/transferencias/{id}`
- `GET /api/dracoins/historial-general`
- `GET /api/dracoins/historial-pagos`
- `GET /api/dracoins/sueldos-por-cargo`
- `PUT /api/dracoins/sueldos-por-cargo`
- `GET /api/dracoins/pagos-manuales`
- `POST /api/dracoins/pagos-manuales`
- `GET /api/marcadores/actual`
- `GET /api/marcadores/casas`
- `GET /api/marcadores/historial`
- `POST /api/marcadores/actualizaciones`
- `POST /api/marcadores/ajustes-puntos`
- `POST /api/marcadores/cierres`
- `GET /api/dinamicas`
- `GET /api/dinamicas/alumnos-activos`
- `GET /api/dinamicas/{id}/detalle-puntos`
- `GET /api/dinamicas/{id}/detalle-dracoins`
- `POST /api/dinamicas/dracoins`
- `GET /api/dinamicas/agenda`
- `GET /api/dinamicas/agenda/responsables`
- `GET /api/dinamicas/agenda/{id}`
- `POST /api/dinamicas/agenda/lotes`
- `PUT /api/dinamicas/agenda/{id}`
- `DELETE /api/dinamicas/agenda/{id}`
- `DELETE /api/dinamicas/agenda`
- `DELETE /api/dinamicas/{id}`
- `GET /api/mascotas/resumen`
- `GET /api/mascotas/catalogo`
- `GET /api/mascotas/catalogos-formulario`
- `GET /api/mascotas/asignaciones`
- `GET /api/mascotas/asignaciones/{idMascotaAlumno}`
- `POST /api/mascotas/asignaciones`
- `PUT /api/mascotas/asignaciones/{idMascotaAlumno}`
- `PATCH /api/mascotas/asignaciones/{idMascotaAlumno}/estado`
- `DELETE /api/mascotas/asignaciones/{idMascotaAlumno}`
- `GET /api/mascotas/cobro-semanal`
- `POST /api/mascotas/cobro-semanal`
- `GET /api/mascotas/matriz`

Estado del backend:

- Compila correctamente con `dotnet build`
- Compilacion alternativa verificada en:
  - `dotnet build -o C:\Users\user\Desktop\ImperiusDraconisAPI\build-temp`
- Corre en:
  - `https://localhost:7076`
  - `http://localhost:5176`
- Swagger:
  - `https://localhost:7076/swagger`

Logs de ejecucion:

- `C:\Users\user\Desktop\ImperiusDraconisAPI\ImperiusDraconisAPI\api.stdout.log`
- `C:\Users\user\Desktop\ImperiusDraconisAPI\ImperiusDraconisAPI\api.stderr.log`

### Frontend Angular

Proyecto:

- `C:\Users\user\Desktop\IMPERIUSDRACONIS`

Archivos importantes:

- [src/app/app.routes.ts](C:/Users/user/Desktop/IMPERIUSDRACONIS/src/app/app.routes.ts)
- [src/app/core/constants/api.constants.ts](C:/Users/user/Desktop/IMPERIUSDRACONIS/src/app/core/constants/api.constants.ts)
- [src/app/core/services/auth.service.ts](C:/Users/user/Desktop/IMPERIUSDRACONIS/src/app/core/services/auth.service.ts)
- [src/app/core/services/perfil.service.ts](C:/Users/user/Desktop/IMPERIUSDRACONIS/src/app/core/services/perfil.service.ts)
- [src/app/core/services/alumnos.service.ts](C:/Users/user/Desktop/IMPERIUSDRACONIS/src/app/core/services/alumnos.service.ts)
- [src/app/core/services/dracoins.service.ts](C:/Users/user/Desktop/IMPERIUSDRACONIS/src/app/core/services/dracoins.service.ts)
- [src/app/core/services/marcadores.service.ts](C:/Users/user/Desktop/IMPERIUSDRACONIS/src/app/core/services/marcadores.service.ts)
- [src/app/core/services/dinamicas.service.ts](C:/Users/user/Desktop/IMPERIUSDRACONIS/src/app/core/services/dinamicas.service.ts)
- [src/app/core/services/mascotas.service.ts](C:/Users/user/Desktop/IMPERIUSDRACONIS/src/app/core/services/mascotas.service.ts)
- [src/app/layout/app-shell/app-shell.component.ts](C:/Users/user/Desktop/IMPERIUSDRACONIS/src/app/layout/app-shell/app-shell.component.ts)
- [src/app/pages/login/login-page.component.ts](C:/Users/user/Desktop/IMPERIUSDRACONIS/src/app/pages/login/login-page.component.ts)
- [src/app/pages/dashboard/dashboard-page.component.ts](C:/Users/user/Desktop/IMPERIUSDRACONIS/src/app/pages/dashboard/dashboard-page.component.ts)
- [src/app/pages/perfil/perfil-page.component.ts](C:/Users/user/Desktop/IMPERIUSDRACONIS/src/app/pages/perfil/perfil-page.component.ts)
- [src/app/pages/alumnos/alumnos-page.component.ts](C:/Users/user/Desktop/IMPERIUSDRACONIS/src/app/pages/alumnos/alumnos-page.component.ts)
- [src/app/pages/dracoins/dracoins-page.component.ts](C:/Users/user/Desktop/IMPERIUSDRACONIS/src/app/pages/dracoins/dracoins-page.component.ts)
- [src/app/pages/marcadores/marcadores-page.component.ts](C:/Users/user/Desktop/IMPERIUSDRACONIS/src/app/pages/marcadores/marcadores-page.component.ts)
- [src/app/pages/dinamicas/dinamicas-page.component.ts](C:/Users/user/Desktop/IMPERIUSDRACONIS/src/app/pages/dinamicas/dinamicas-page.component.ts)
- [src/app/pages/mascotas/mascotas-page.component.ts](C:/Users/user/Desktop/IMPERIUSDRACONIS/src/app/pages/mascotas/mascotas-page.component.ts)

Pantallas ya creadas:

- Login con recuperacion de contrasena integrada
- Shell principal
- Dashboard base
- Modulo de mi perfil con datos personales, seleccion de avatar y cambio de contrasena
- Modulo de alumnos con listado, detalle, alta, edicion, notas y reset administrativo de contrasena
- Modulo de dracoins con resumen, transferencia, historial personal, historial general, sueldos y pagos manuales
- Modulo de marcadores con tablero actual, carga manual, ajustes administrativos e historial por permiso
- Modulo de dinamicas con listado, detalle, registro por dracoins, agenda administrativa y eliminacion
- Modulo de mascotas con catalogo, asignaciones por alumno, cambio de estado, cobro semanal y matriz

Estado del frontend:

- Compila correctamente con `npm run build`
- El bundle inicial quedo reducido con lazy loading de rutas
- Corre en:
  - `http://localhost:4200`
- Avatares legacy reutilizados en Angular desde:
  - `C:\Users\user\Desktop\IMPERIUSDRACONIS\public\profile-avatars`

Validacion operativa reciente:

- `2026-03-10`: `Mascotas` validado contra API real con `X4 / 123456`
- `2026-03-10`: `Login/Recuperacion` validado contra API real con login `X4 / 123456` y recuperacion reversible de `X2`
- Flujo probado por API:
  - `GET /api/mascotas/resumen`
  - `GET /api/mascotas/catalogo`
  - `GET /api/mascotas/catalogos-formulario`
  - `POST /api/mascotas/asignaciones`
  - `PUT /api/mascotas/asignaciones/{idMascotaAlumno}`
  - `PATCH /api/mascotas/asignaciones/{idMascotaAlumno}/estado`
  - `GET /api/mascotas/cobro-semanal`
  - `POST /api/mascotas/cobro-semanal`
  - `GET /api/mascotas/matriz`
- La validacion de cobro semanal se limpio al final:
  - asignacion temporal eliminada
  - dracoins restaurados
  - movimiento de cobro de prueba eliminado
- Flujo probado por API para auth:
  - `POST /api/auth/login`
  - `GET /api/auth/me`
  - `POST /api/auth/recuperar-contrasena`
- En desarrollo, recuperacion expone una contrasena temporal solo para validacion local si SMTP no esta configurado

Logs de ejecucion:

- `C:\Users\user\Desktop\IMPERIUSDRACONIS\frontend.stdout.log`
- `C:\Users\user\Desktop\IMPERIUSDRACONIS\frontend.stderr.log`

## Credenciales De Prueba Confirmadas

Credencial validada contra la base real y la API:

- Codigo: `G1009`
- Contrasena: `123456`

Resultado confirmado:

- `POST /api/auth/login`: OK
- `GET /api/auth/me`: OK
- `GET /api/perfil`: OK por API
- `PUT /api/perfil`: OK por API con cambio reversible de avatar `1.jpg -> 2.jpg -> 1.jpg`
- `PUT /api/perfil/contrasena`: OK por API con cambio reversible `123456 -> TmpPerf2026! -> 123456`
- `GET /api/alumnos`: OK
- `GET /api/dracoins/resumen`: OK
- `GET /api/dracoins/transferencias`: OK
- `POST /api/dracoins/transferencias`: OK
- `GET /api/dracoins/historial-general`: OK
- `GET /api/marcadores/actual`: OK
- `GET /api/marcadores/casas`: OK
- `POST /api/marcadores/actualizaciones`: OK
- `POST /api/marcadores/ajustes-puntos`: OK
- `POST /api/marcadores/cierres`: OK
- `GET /api/dinamicas`: OK
- `GET /api/dinamicas/alumnos-activos`: OK
- `GET /api/dinamicas/{id}/detalle-puntos`: OK
- `GET /api/dinamicas/{id}/detalle-dracoins`: OK
- `POST /api/dinamicas/dracoins`: OK
- `GET /api/dinamicas/agenda`: OK
- `GET /api/dinamicas/agenda/responsables`: OK
- `POST /api/dinamicas/agenda/lotes`: OK
- `PUT /api/dinamicas/agenda/{id}`: OK
- `DELETE /api/dinamicas/agenda/{id}`: OK
- `DELETE /api/dinamicas/{id}`: OK
- `GET /api/dracoins/sueldos-por-cargo`: OK
- `PUT /api/dracoins/sueldos-por-cargo`: OK
- `GET /api/dracoins/pagos-manuales`: OK
- `POST /api/dracoins/pagos-manuales`: OK
- `GET /api/alumnos/{id}/notas`: OK
- `POST /api/alumnos/{id}/notas`: OK
- `PUT /api/alumnos/{id}/contrasena`: OK

Observacion:

- No todas las cuentas con `123456` tienen los mismos permisos
- `G1009` tiene al menos `Alumnos:Index`, `Dracoins:Index`, `Dracoins:TransferirDracoins` y `Dracoins:HistorialTransferencias`
- `G1009` tambien tiene `Marcadores:Index`, `Marcadores:ActualizarMarcador` y `Marcadores:MarcadorActual`
- `G1009` tambien tiene `Dinamicas:Index`, `Dinamicas:DetallePuntos`, `Dinamicas:DetalleDracoins` y `Dinamicas:RegistrarDinámicaPorDracoins`
- Se probo una transferencia real `G1009 -> G1010` por `1` DC y luego rollback `G1010 -> G1009`
- Movimientos de prueba registrados:
  - `#21117` prueba directa
  - `#21118` rollback
- Se probo una actualizacion real de `Marcadores` sobre la casa `ID` con la dinamica `#3171` y rollback SQL inmediato
- La credencial `X4 / 123456` si pudo validar `GET /api/marcadores/historial`
- `X4 / 123456` tambien valido `Marcadores:AjustesPuntos`
- Se probo `Marcadores` administrativo real:
  - `5` casas visibles en marcador/casas
  - ajuste `#3175` sobre `Gryffindor`: `98110 -> 98111 -> 98110`
  - cierre con `5` registros generados y rollback SQL inmediato
- Reversion verificada del cierre:
  - historial maximo restaurado a `82`
  - `MarcadorActual` restaurado a los puntajes previos
- `X4 / 123456` tambien valido `Dracoins:HistorialGeneral`, `Dracoins:SueldosPorCargo`, `Dracoins:ActualizarSueldos` y `Dracoins:PagarSueldosManual`
- Se probo `Dracoins` administrativo real:
  - historial general: `21097` registros
  - catalogo de sueldos: `8` cargos
  - bandeja de pagos manuales: `24` candidatos
- Se probo actualizacion reversible de sueldos:
  - `700.00 -> 701.00 -> 700.00`
- Se probo un pago manual real a `R1033` por `507` DC y se hizo cleanup SQL inmediato
- Reversion verificada en saldo de `R1033`:
  - `1714.40 -> 2221.40 -> 1714.40`
- Se probo una dinamica real por dracoins `#3172` para `G1004` por `1` DC y rollback SQL inmediato
- `X4 / 123456` tambien valido `Dinamicas:AgendaIndex` y `Dinamicas:Eliminar`
- Se probo agenda administrativa real:
  - alta `#722`
  - actualizacion a `23:40` con titulo `Actividad por Dracoins`
  - eliminacion correcta
- Se probo una dinamica real por dracoins `#3173` para `G1004` por `1` DC y luego eliminacion administrativa
- Reversion verificada en saldo de `G1004`:
  - `41.00 -> 42.00 -> 41.00`
- `X4 / 123456` tambien valido `Alumnos:Crear`, `Alumnos:Editar`, `Alumnos:Eliminar`, `Alumnos:Notas` y `Alumnos:CambiarContraseña`
- Se probo el flujo administrativo real de `Alumnos` con un alumno temporal:
  - alta de `G1210`
  - login inicial con `Temp123`
  - nota `#43`
  - edicion de nombre, telefono, puntos y dracoins
  - cambio de estado `activo -> inactivo -> activo`
  - reset de contrasena a `Temp456`
  - login exitoso con la nueva contrasena
  - eliminacion final y verificacion SQL:
    - `NotasAlumno = 0`
    - `Alumnos = 0`

## Decisiones Tecnicas Tomadas

- Se usa ADO.NET puro en la API para migrar sin meter un ORM nuevo todavia
- Se replico el hash del sistema legado:
  - SHA-256
  - salida Base64
- La autorizacion nueva usa JWT
- Los permisos se cargan desde:
  - `Permisos`
  - `PermisosTrabajos`
- `GET /api/auth/me` recompone el usuario real desde base y no depende solo del JWT inicial
- Se dejaron permisos semilla para destrabar el modulo migrado:
  - `Dracoins:Index`
  - `Dracoins:TransferirDracoins`
  - `Dracoins:HistorialTransferencias`
- En `Dracoins`, las transferencias ya no aceptan destinatarios inactivos
- En `Dracoins`, sueldos y pagos manuales se validan como montos enteros para no desalinear el historial de movimientos
- `Marcadores` se apoya solo en permisos reales de base, sin semillas nuevas
- `HasPermission` ahora acepta multiples permisos y resuelve por OR dentro del mismo atributo
- `Dinamicas` tambien se apoya en permisos reales de base
- `Alumnos` ya quedo cubierto en CRUD administrativo, notas y reset de contrasena
- En `Alumnos`, el nombre SQL de `Contraseña` se normalizo con escape Unicode para evitar corrupcion de codificacion
- En `Alumnos`, la eliminacion ahora limpia `NotasAlumno` en la misma transaccion para evitar residuos del modulo
- `Perfil/MiPerfil` se resolvio como autoservicio del alumno autenticado, sin depender de permisos administrativos
- `Perfil/MiPerfil` reutiliza los avatares legacy desde `public/profile-avatars` y persiste la ruta legacy en base
- El frontend consume la API desde:
  - `https://localhost:7076/api`

## Comandos Utiles

### Backend

```powershell
cd C:\Users\user\Desktop\ImperiusDraconisAPI\ImperiusDraconisAPI
dotnet build
dotnet run --launch-profile https
```

### Frontend

```powershell
cd C:\Users\user\Desktop\IMPERIUSDRACONIS
npm install
npm run start -- --host localhost --port 4200
```

Si `ng serve` no queda estable en segundo plano, dejar operativo el frontend con la build validada:

```powershell
cd C:\Users\user\Desktop\IMPERIUSDRACONIS
npm run build
node scripts/serve-spa.mjs
```

### SQL

Para volver a restaurar desde cero:

```powershell
sqlcmd -S DESKTOP-ACSKJNH -U sa -P sql -b -f 65001 -i "C:\Users\user\Desktop\IMPERIUSDRACONIS\IDULTIMO.imperiusdraconis.sql"
```

## Lo Que Falta Hacer

### Prioridad Alta

1. Endurecer la seguridad:
   - mover secretos fuera de `appsettings`
   - usar una `Jwt:SecretKey` definitiva
2. Normalizar textos con tildes y nombres de permisos
3. Probar desde la UI el flujo completo de `Alumnos`
4. Probar desde la UI el flujo completo de agenda y eliminacion de dinamicas
5. Probar desde la UI el flujo completo de `Dracoins` administrativo
6. Probar desde la UI el flujo completo de `Marcadores` administrativo
7. Probar desde la UI el flujo completo de transferencia, marcador actual y dinamicas por dracoins
8. Probar desde la UI el flujo completo de `Mi Perfil`, incluyendo avatar y cambio de contrasena
9. Probar desde la UI el flujo completo de `Mascotas`
10. Probar desde la UI el flujo completo de `Login/Recuperacion`

### Estado De Migracion

No quedan modulos grandes pendientes de migrar dentro del alcance identificado en el sistema legado principal.

Lo pendiente ahora es de cierre operativo, endurecimiento tecnico y pruebas manuales integrales.

Recomendacion:

- `Alumnos` ya quedo cubierto en su parte operativa y administrativa base
- `Chismes` ya quedo migrado y validado a nivel API
- `Dinamicas` ya quedo cubierto en su parte funcional y administrativa base
- `Dracoins` ya quedo cubierto en su parte personal y administrativa base
- `Permisos` ya quedo migrado y validado a nivel API
- `Productos` ya quedo migrado y validado junto con `Tienda`
- `Marcadores` ya quedo cubierto en su parte operativa y administrativa base
- `Mi Perfil` ya quedo cubierto en su parte base de autoservicio
- `Mascotas` ya quedo cubierto en su parte operativa, administrativa y de cobro semanal a nivel API + Angular
- `Login/Recuperacion` ya quedo cubierto en su parte de acceso y recuperacion a nivel API + Angular
- `Rincon` ya quedo migrado y validado a nivel API
- `Tienda` ya quedo migrado y validado a nivel API
- `Trabajos` ya quedo migrado y validado a nivel API

### Mejoras Tecnicas Pendientes

- Crear una capa comun para consultas repetidas
- Agregar DTOs y validaciones mas estrictas
- Agregar manejo global de errores en la API
- Agregar refresh de sesion o expiracion visible en Angular
- Agregar guards por permiso en el frontend, no solo guard de autenticacion
- Incorporar pruebas automatizadas basicas

## Regla Para Retomar Contexto En Otra Sesion

Si se pierde contexto, revisar en este orden:

1. Este documento
2. [Program.cs](C:/Users/user/Desktop/ImperiusDraconisAPI/ImperiusDraconisAPI/Program.cs)
3. [AuthService.cs](C:/Users/user/Desktop/ImperiusDraconisAPI/ImperiusDraconisAPI/Services/AuthService.cs)
4. [DinamicasService.cs](C:/Users/user/Desktop/ImperiusDraconisAPI/ImperiusDraconisAPI/Services/DinamicasService.cs)
5. [app.routes.ts](C:/Users/user/Desktop/IMPERIUSDRACONIS/src/app/app.routes.ts)
6. [perfil-page.component.ts](C:/Users/user/Desktop/IMPERIUSDRACONIS/src/app/pages/perfil/perfil-page.component.ts)
7. [dinamicas-page.component.ts](C:/Users/user/Desktop/IMPERIUSDRACONIS/src/app/pages/dinamicas/dinamicas-page.component.ts)
8. [marcadores-page.component.ts](C:/Users/user/Desktop/IMPERIUSDRACONIS/src/app/pages/marcadores/marcadores-page.component.ts)
9. [dracoins-page.component.ts](C:/Users/user/Desktop/IMPERIUSDRACONIS/src/app/pages/dracoins/dracoins-page.component.ts)
10. [alumnos-page.component.ts](C:/Users/user/Desktop/IMPERIUSDRACONIS/src/app/pages/alumnos/alumnos-page.component.ts)

## Nota Final

El sistema ya esta en una etapa usable de arranque:

- Base restaurada
- API funcionando
- Frontend funcionando
- Login real probado
- Recuperacion de contrasena migrada y validada en entorno local
- Modulo de mi perfil agregado sobre la API nueva
- Modulo de alumnos conectado y probado en flujo administrativo completo
- Modulo de chismes conectado y probado en envio + revision administrativa
- Modulo de dracoins personal y administrativo conectado y probado
- Modulo de permisos conectado y probado
- Modulo de productos conectado y probado
- Modulo de marcadores operativo y administrativo conectado y probado
- Modulo de dinamicas conectado y probado, incluyendo agenda y eliminacion administrativa
- Modulo de mascotas conectado y probado
- Modulo de tienda conectado y probado en compra, toma y entrega
- Modulo de rincon conectado y probado en compra y entrega
- Modulo de trabajos conectado y probado
- El frontend puede servirse desde la build en `http://127.0.0.1:4200` con `node scripts/serve-spa.mjs`

El punto correcto para continuar es cerrar pruebas manuales completas y endurecer la base tecnica, sin volver a tocar `Apocalipsis`.
