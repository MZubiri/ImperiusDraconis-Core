# Verificación aislada de MySQL

**Dos escenarios de prueba:** instalación nueva y actualización de una copia restaurada de producción. El [informe inicial](../../docs/REVISION_ESQUEMA_PRODUCCION_2026-09-16.md) documenta por qué las pruebas de instalación nueva por sí solas no certifican un despliegue. La migración `018_reconcile_existing_schema.sql` corrige las tablas existentes sin reemplazarlas y `019_create_game_care_loop.sql` incorpora especies, temperamentos, alimentos y el estado de caricias del MVP.

Ejecutar desde la raíz del repositorio, con Docker disponible. No usar una base de datos real:

```bash
docker run -d --rm --name id-remediation-mysql -e MYSQL_ALLOW_EMPTY_PASSWORD=yes mysql:8.0 --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci
# Esperar a que mysqladmin ping responda antes de continuar.
docker exec id-remediation-mysql mysqladmin ping -uroot
python3 ImperiusDraconisAPI/scripts/verify_mysql_migrations.py
python3 ImperiusDraconisAPI/scripts/verify_mysql_migrations.py
python3 ImperiusDraconisAPI/scripts/verify_game_sql.py
```

El primer script crea un esquema de prueba `remediation` con las tablas base mínimas y ejecuta todas las migraciones. La segunda ejecución comprueba su repetibilidad. El segundo script valida con `EXPLAIN` las consultas SQL estáticas de los servicios Game; no ejecuta sus escrituras.

Para las pruebas de integración .NET, crear también `remediation_auth` y `remediation_bulk` en ese contenedor. Configurar `ID_TEST_MYSQL` con la conexión a `remediation_auth` e `ID_TEST_GAME_MYSQL` con la conexión a `remediation`, usando la IP obtenida con `docker inspect`. Ejecutar `dotnet test ImperiusDraconisAPI/ImperiusDraconisAPI.Tests`. Sin estas variables, las pruebas de integración se omiten explícitamente.

Al terminar: `docker stop id-remediation-mysql`.

Los scripts de la API requieren MySQL 8.0.16 o superior. `GO` es un separador de lotes del ejecutor .NET y de estos verificadores; no se envía al servidor. Para ejecutarlos en otro cliente hay que separar esos lotes o adaptar su delimitador. No dividir por `;` porque los procedimientos incluyen sentencias internas.

MySQL confirma DDL implícitamente: revertir un commit Git no revierte tablas ni datos ya migrados. Respaldar la base antes de aplicar migraciones fuera de este entorno aislado. Las migraciones Game conservan la detección de instalaciones parciales, que requieren revisión antes de reintentarse.

## Actualización de una instalación existente

1. Generar un dump completo con `mysqldump --single-transaction --quick --routines --events --triggers --hex-blob --set-gtid-purged=OFF --no-tablespaces`. Comprimir, descargar y comparar SHA-256. Mantener respaldo y credenciales fuera del repositorio.
2. Restaurar el dump en un MySQL aislado. No usar las tablas mínimas del verificador de instalación nueva como sustituto.
3. Aplicar **017, 018 y 019**, en ese orden, con el renderizador y comprobar una segunda ejecución:

```bash
python3 ImperiusDraconisAPI/scripts/render_mysql_batches.py \
  ImperiusDraconisAPI/ImperiusDraconisAPI/SQLMigrar/017_create_refresh_tokens.sql \
  ImperiusDraconisAPI/ImperiusDraconisAPI/SQLMigrar/018_reconcile_existing_schema.sql \
  ImperiusDraconisAPI/ImperiusDraconisAPI/SQLMigrar/019_create_game_care_loop.sql
```

El comando imprime SQL listo para el cliente `mysql`; no conecta ni modifica ninguna base por sí mismo. No volver a ejecutar las siembras históricas sobre producción.

4. Comparar los datos antes y después. En la validación de 2026-09-16 coincidieron los hashes normalizados de todas las filas de las 59 tablas originales. Las ampliaciones de precisión temporal representan los segundos existentes con fracciones cero. Se conservan las columnas históricas `RowVersion`, que los servicios no utilizan.
5. Para la prueba funcional, usar otra copia desechable llamada `production_upgrade_test` y configurar `ID_TEST_UPGRADE_MYSQL` con su conexión. `dotnet test ImperiusDraconisAPI/ImperiusDraconisAPI.Tests` prueba login, rotación, compra/incubación/eclosión, ledger, chismes, notas e importación de 105 libros. **La prueba inserta datos sintéticos y no se ejecuta contra la base real.**
6. Aplicar 017, 018 y 019 a producción tras validar el respaldo y las pruebas; después desplegar API y frontend. El inicializador crea 017, pero **018 y 019 requieren ejecución explícita previa al despliegue**.

018 comprueba las reglas y duplicados antes del primer ALTER TABLE. No borra tablas ni filas; añade defaults, amplía tipos, incorpora columnas calculadas e índices y restaura CHECKs. MySQL confirma cada DDL por separado: si surge un error, conservar la aplicación anterior, revisar el error y reintentar una vez corregido. No restaurar automáticamente el dump sobre una base que siga recibiendo escrituras.
