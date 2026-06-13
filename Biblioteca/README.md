# Módulo de Biblioteca: Contexto de Desarrollo y Estado Actual

Este archivo sirve como punto de partida y documentación de contexto para reanudar el desarrollo del módulo de **Biblioteca** de *Imperius Draconis*.

---

## 📊 Estado del Proyecto

*   **Fase 1 (Metadata y Limpieza):** **Completada.** Los 1,031 libros físicos (PDF/EPUB) fueron descargados de Google Drive a la carpeta local `/Libros`. Se analizaron, se enriquecieron sus sinopsis y categorías usando APIs (Google Books y Wikipedia), y se consolidaron en un Excel de control.
*   **Fase 2 (Base de Datos):** **Preparada.** El esquema de tablas SQL Server y el script de semillas (`INSERT` masivo de libros) se generaron correctamente y están listos para ser aplicados en cuanto termine la revisión del Excel.
*   **Fase 3 (Backend API C#):** **Pendiente.**
*   **Fase 4 (Frontend Angular):** **Pendiente.**

---

## 📁 Archivos Clave en esta Carpeta

*   **[Libros/](file:///home/guss/Desktop/Proyectos/IDNUEVO/Biblioteca/Libros/)**: Directorio local que contiene los 1,031 archivos físicos clasificados en subcarpetas por formato (`PDF`, `EPUB`, `no funca`).
*   **[GELATINA - LIBROS PROCESADOS.xlsx](file:///home/guss/Desktop/Proyectos/IDNUEVO/Biblioteca/GELATINA%20-%20LIBROS%20PROCESADOS.xlsx)**: Excel consolidado entregado a la encargada. Contiene la columna `listo` (con checkboxes pintados en verde/amarillo) para la revisión manual.
*   **[process_metadata.py](file:///home/guss/Desktop/Proyectos/IDNUEVO/Biblioteca/process_metadata.py)**: Script de extracción automática y enriquecimiento de metadatos. *(NO volver a correr tras la revisión manual, para evitar machacar los cambios del Excel)*.
*   **[generate_seed_sql.py](file:///home/guss/Desktop/Proyectos/IDNUEVO/Biblioteca/generate_seed_sql.py)**: Script encargado de leer el Excel actual y regenerar la semilla de inserción SQL.
*   **[plan_trabajo_biblioteca.md](file:///home/guss/Desktop/Proyectos/IDNUEVO/Biblioteca/plan_trabajo_biblioteca.md)**: El plan detallado con el diseño de base de datos, el flujo de suscripciones recurrentes y la arquitectura del frontend/backend.

---

## 🛠️ Próximos Pasos (Cómo retomar la sesión)

### Paso 1: Regeneración del SQL tras la revisión manual
Una vez que la encargada guarde los cambios manuales en el Excel [GELATINA - LIBROS PROCESADOS.xlsx](file:///home/guss/Desktop/Proyectos/IDNUEVO/Biblioteca/GELATINA%20-%20LIBROS%20PROCESADOS.xlsx), ejecuta el siguiente comando en la terminal para sincronizar esos cambios en las semillas de la base de datos:
```bash
cd /home/guss/Desktop/Proyectos/IDNUEVO/Biblioteca
python3 generate_seed_sql.py
```
Esto sobrescribirá `/home/guss/Desktop/Proyectos/IDNUEVO/SQLMigrar/013_seed_biblioteca_data.sql` respetando la activación (`Activo = 1` para los marcados como `TRUE` y `Activo = 0` para los `FALSE`).

### Paso 2: Ejecutar Migraciones SQL Server
Aplica los dos scripts de migración en la base de datos local `ID` (usando SQL Server Management Studio, Azure Data Studio o el cliente SQL correspondiente):
1.  **[012_create_biblioteca_tables.sql](file:///home/guss/Desktop/Proyectos/IDNUEVO/SQLMigrar/012_create_biblioteca_tables.sql)**: Crea las tablas de categorías, libros, compras individuales, suscripciones y el historial de progreso de lectura.
2.  **[013_seed_biblioteca_data.sql](file:///home/guss/Desktop/Proyectos/IDNUEVO/SQLMigrar/013_seed_biblioteca_data.sql)**: Puebla la base de datos con las categorías y los libros corregidos.

### Paso 3: Desarrollo de la API Backend C# (Fase 3)
En el proyecto ASP.NET Core (`ImperiusDraconisAPI`):
1.  Crear los modelos de negocio correspondientes a la base de datos.
2.  Implementar `BibliotecaService.cs` y su correspondiente controlador:
    *   **Secure streaming:** Un endpoint tipo `GET /api/biblioteca/leer/{id}` que verifique la autenticación del alumno, si tiene el libro comprado o si cuenta con una suscripción activa, y devuelva el archivo como un `FileStreamResult` seguro (evitando descargas directas públicas).
    *   **Proceso de Compra:** Validar saldo en Dracoins en la tabla tradicional de movimientos (`CodigoDestinatario = 'COBRO_BIBLIOTECA'`).
    *   **Suscripción Semanal:** Cobro automático recurrente de Dracoins y expiración del acceso.
    *   **Guardado de progreso:** Registrar en la base de datos la última página leída.

### Paso 4: Desarrollo Frontend Angular (Fase 4)
En el proyecto `IMPERIUSDRACONIS`:
1.  Crear `biblioteca.service.ts` para conectar con la API.
2.  Diseñar la interfaz de usuario:
    *   Catálogo de libros con buscadores, filtros por categoría y estado de adquisición.
    *   Banners de suscripción semanal y botón de compra.
    *   Visor de PDF integrado que guarde automáticamente el progreso de lectura del alumno al salir o avanzar de página.
