# Verificación aislada de MySQL

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
