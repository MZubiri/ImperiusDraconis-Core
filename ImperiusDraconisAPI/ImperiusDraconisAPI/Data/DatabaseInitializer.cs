using System.Text.RegularExpressions;
using MySqlConnector;

namespace ImperiusDraconisAPI.Data;

public static class DatabaseInitializer
{
    public static async Task InitializeAsync(IServiceProvider serviceProvider, IWebHostEnvironment environment)
    {
        var connectionFactory = serviceProvider.GetRequiredService<MySqlConnectionFactory>();
        var logger = serviceProvider.GetRequiredService<ILogger<MySqlConnectionFactory>>();

        // Restablecer imagenes de tienda y rincon respaldadas si hacen falta en el volumen persistente
        RestoreBackupAssets(environment, logger);

        try
        {
            using var connection = connectionFactory.CreateConnection();
            await connection.OpenAsync();

            // 1. Verificar si la tabla BibliotecaLibros ya existe
            using var checkCommand = new MySqlCommand(
                "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'BibliotecaLibros'",
                connection);
            var checkResult = await checkCommand.ExecuteScalarAsync();
            var tableExists = checkResult != DBNull.Value && checkResult != null && Convert.ToInt32(checkResult) > 0;

            string? rootPath = null;
            var currentDir = environment.ContentRootPath;
            for (int i = 0; i < 4; i++)
            {
                var candidate = Path.Combine(currentDir, "SQLMigrar");
                if (Directory.Exists(candidate))
                {
                    rootPath = candidate;
                    break;
                }
                var parent = Directory.GetParent(currentDir);
                if (parent == null) break;
                currentDir = parent.FullName;
            }

            if (rootPath == null)
            {
                logger.LogError("No se pudo localizar la carpeta SQLMigrar subiendo desde {ContentRootPath}.", environment.ContentRootPath);
                return;
            }

            var alumnoEmojisScriptPath = Path.Combine(rootPath, "014_add_alumno_emojis.sql");
            if (File.Exists(alumnoEmojisScriptPath))
            {
                logger.LogInformation("Verificando migracion de emojis de alumnos: 014_add_alumno_emojis.sql");
                var script = await File.ReadAllTextAsync(alumnoEmojisScriptPath);
                await ExecuteSqlScriptAsync(connection, script);
            }

            var alumnoEmojiPermissionScriptPath = Path.Combine(rootPath, "015_create_alumno_emoji_permission.sql");
            if (File.Exists(alumnoEmojiPermissionScriptPath))
            {
                logger.LogInformation("Verificando permiso de emojis de alumnos: 015_create_alumno_emoji_permission.sql");
                var script = await File.ReadAllTextAsync(alumnoEmojiPermissionScriptPath);
                await ExecuteSqlScriptAsync(connection, script);
            }

            var landingScriptPath = Path.Combine(rootPath, "016_create_public_landing.sql");
            if (File.Exists(landingScriptPath))
            {
                logger.LogInformation("Verificando estructura de landing publica: 016_create_public_landing.sql");
                var script = await File.ReadAllTextAsync(landingScriptPath);
                await ExecuteSqlScriptAsync(connection, script);
            }

            if (!tableExists)
            {
                logger.LogInformation("Iniciando creacion de tablas para Biblioteca (012_create_biblioteca_tables.sql)...");
                // Ejecutar 012_create_biblioteca_tables.sql
                var tablesScriptPath = Path.Combine(rootPath, "012_create_biblioteca_tables.sql");
                if (File.Exists(tablesScriptPath))
                {
                    logger.LogInformation("Ejecutando esquema de tablas: 012_create_biblioteca_tables.sql");
                    var script = await File.ReadAllTextAsync(tablesScriptPath);
                    await ExecuteSqlScriptAsync(connection, script);
                }
            }
            else
            {
                logger.LogInformation("Las tablas de biblioteca ya existen. Omitiendo creacion.");
            }

            // 1.5 Verificar/crear tabla AlumnosLibrosDescargados
            using var checkDescargasCommand = new MySqlCommand(
                "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'AlumnosLibrosDescargados'",
                connection);
            var checkDescargasResult = await checkDescargasCommand.ExecuteScalarAsync();
            var descargasTableExists = checkDescargasResult != DBNull.Value && checkDescargasResult != null && Convert.ToInt32(checkDescargasResult) > 0;

            if (!descargasTableExists)
            {
                logger.LogInformation("Creando tabla AlumnosLibrosDescargados...");
                var createDescargasSql = """
                    CREATE TABLE AlumnosLibrosDescargados
                    (
                        Id INT AUTO_INCREMENT NOT NULL,
                        IdAlumno INT NOT NULL,
                        IdLibro INT NOT NULL,
                        FechaDescarga DATETIME NOT NULL DEFAULT NOW(),
                        CONSTRAINT PK_AlumnosLibrosDescargados PRIMARY KEY (Id),
                        CONSTRAINT FK_AlumnosLibrosDescargados_Alumnos FOREIGN KEY (IdAlumno) REFERENCES Alumnos(IdAlumno) ON DELETE CASCADE,
                        CONSTRAINT FK_AlumnosLibrosDescargados_BibliotecaLibros FOREIGN KEY (IdLibro) REFERENCES BibliotecaLibros(Id) ON DELETE CASCADE
                    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
                    """;
                using var createCmd = new MySqlCommand(createDescargasSql, connection);
                await createCmd.ExecuteNonQueryAsync();
            }

            // 1.55 Crear permisos por defecto para Biblioteca
            using (var checkPermisosCommand = new MySqlCommand(
                "SELECT COUNT(*) FROM Permisos WHERE Controlador = 'Biblioteca'",
                connection))
            {
                var permisosCount = Convert.ToInt32(await checkPermisosCommand.ExecuteScalarAsync(), System.Globalization.CultureInfo.InvariantCulture);
                if (permisosCount == 0)
                {
                    logger.LogInformation("Creando permisos por defecto para Biblioteca...");
                    
                    // 1. Insertar para Cargos
                    var createPermisosCargosSql = """
                        INSERT INTO Permisos (IdCargo, Controlador, Accion, TienePermiso)
                        SELECT C.IdCargo, 'Biblioteca', 'Index', 1
                        FROM Cargos C
                        WHERE NOT EXISTS (SELECT 1 FROM Permisos WHERE IdCargo = C.IdCargo AND Controlador = 'Biblioteca' AND Accion = 'Index');

                        INSERT INTO Permisos (IdCargo, Controlador, Accion, TienePermiso)
                        SELECT C.IdCargo, 'Biblioteca', 'Admin', CASE WHEN C.Nombre IN ('Maestre', 'Director', 'Administrador') THEN 1 ELSE 0 END
                        FROM Cargos C
                        WHERE NOT EXISTS (SELECT 1 FROM Permisos WHERE IdCargo = C.IdCargo AND Controlador = 'Biblioteca' AND Accion = 'Admin');
                        """;
                    using (var createCmd = new MySqlCommand(createPermisosCargosSql, connection))
                    {
                        await createCmd.ExecuteNonQueryAsync();
                    }

                    // 2. Insertar para Trabajos (si la tabla existe)
                    using (var checkPTCmd = new MySqlCommand(
                        "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'PermisosTrabajos'",
                        connection))
                    {
                        var ptExists = Convert.ToInt32(await checkPTCmd.ExecuteScalarAsync(), System.Globalization.CultureInfo.InvariantCulture) > 0;
                        if (ptExists)
                        {
                            var createPermisosTrabajosSql = """
                                INSERT INTO PermisosTrabajos (IdTrabajo, Controlador, Accion, TienePermiso)
                                SELECT T.IdTrabajo, 'Biblioteca', 'Index', 1
                                FROM Trabajos T
                                WHERE NOT EXISTS (SELECT 1 FROM PermisosTrabajos WHERE IdTrabajo = T.IdTrabajo AND Controlador = 'Biblioteca' AND Accion = 'Index');

                                INSERT INTO PermisosTrabajos (IdTrabajo, Controlador, Accion, TienePermiso)
                                SELECT T.IdTrabajo, 'Biblioteca', 'Admin', 0
                                FROM Trabajos T
                                WHERE NOT EXISTS (SELECT 1 FROM PermisosTrabajos WHERE IdTrabajo = T.IdTrabajo AND Controlador = 'Biblioteca' AND Accion = 'Admin');
                                """;
                            using (var createCmd = new MySqlCommand(createPermisosTrabajosSql, connection))
                            {
                                await createCmd.ExecuteNonQueryAsync();
                            }
                        }
                    }
                }
            }

            // 1.6 Establecer el costo base de todos los libros a 300 DC
            using var updateCostoCommand = new MySqlCommand(
                "UPDATE BibliotecaLibros SET PrecioDracoins = 300 WHERE PrecioDracoins = 0",
                connection);
            int rowsUpdated = await updateCostoCommand.ExecuteNonQueryAsync();
            if (rowsUpdated > 0)
            {
                logger.LogInformation("Se actualizo el costo base de {Count} libros a 300 Dracoins.", rowsUpdated);
            }

            // 2. Verificar si hay libros sembrados
            int librosCount = 0;
            try
            {
                using var countCommand = new MySqlCommand("SELECT COUNT(*) FROM BibliotecaLibros", connection);
                librosCount = Convert.ToInt32(await countCommand.ExecuteScalarAsync(), System.Globalization.CultureInfo.InvariantCulture);
            }
            catch (Exception ex)
            {
                logger.LogError(ex, "Error al contar libros en BibliotecaLibros.");
            }

            if (librosCount < 500)
            {
                logger.LogInformation("La tabla BibliotecaLibros contiene solo {Count} registros (se esperan mas de 1000). Iniciando siembra de datos...", librosCount);
                // Ejecutar 013_seed_biblioteca_data.sql
                var seedScriptPath = Path.Combine(rootPath, "013_seed_biblioteca_data.sql");
                if (File.Exists(seedScriptPath))
                {
                    logger.LogInformation("Sembrando datos: 013_seed_biblioteca_data.sql (esto puede tardar unos segundos)...");
                    var script = await File.ReadAllTextAsync(seedScriptPath);
                    await ExecuteSqlScriptAsync(connection, script);
                }
            }
            else
            {
                logger.LogInformation("La tabla BibliotecaLibros ya contiene {Count} registros. Omitiendo siembra de datos.", librosCount);
            }

            logger.LogInformation("Migracion de biblioteca finalizada correctamente.");
        }
        catch (Exception exception)
        {
            logger.LogError(exception, "Ocurrio un error al inicializar la base de datos.");
        }
    }

    private static async Task ExecuteSqlScriptAsync(MySqlConnection connection, string script)
    {
        // Dividir el script por la directiva 'GO' (insensible a mayusculas/minusculas)
        var commands = Regex.Split(
            script,
            @"^\s*GO\s*$",
            RegexOptions.Multiline | RegexOptions.IgnoreCase);

        foreach (var commandText in commands)
        {
            if (string.IsNullOrWhiteSpace(commandText))
            {
                continue;
            }

            using var command = new MySqlCommand(commandText, connection);
            command.CommandTimeout = 300; // 5 minutos para evitar timeouts en siembras grandes de datos
            await command.ExecuteNonQueryAsync();
        }
    }

    private static void RestoreBackupAssets(IWebHostEnvironment environment, ILogger logger)
    {
        var backupPath = Path.Combine(AppContext.BaseDirectory, "wwwroot_backup", "Content");
        var targetPath = Path.Combine(environment.WebRootPath ?? Path.Combine(environment.ContentRootPath, "wwwroot"), "Content");

        if (!Directory.Exists(backupPath))
        {
            backupPath = Path.Combine(environment.ContentRootPath, "wwwroot_backup", "Content");
            if (!Directory.Exists(backupPath))
            {
                logger.LogWarning("Directorio de respaldo de assets no encontrado: wwwroot_backup/Content");
                return;
            }
        }

        try
        {
            logger.LogInformation("Restableciendo assets desde respaldo {BackupPath} hacia {TargetPath}...", backupPath, targetPath);
            CopyDirectory(backupPath, targetPath, logger);
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "Error al restablecer assets de respaldo.");
        }
    }

    private static void CopyDirectory(string sourceDir, string destinationDir, ILogger logger)
    {
        Directory.CreateDirectory(destinationDir);

        foreach (var file in Directory.GetFiles(sourceDir))
        {
            var destFile = Path.Combine(destinationDir, Path.GetFileName(file));
            if (!File.Exists(destFile))
            {
                try
                {
                    File.Copy(file, destFile);
                    logger.LogInformation("Asset restablecido en volumen persistente: {FileName}", Path.GetFileName(file));
                }
                catch (Exception ex)
                {
                    logger.LogError(ex, "Error al copiar archivo {File} a {DestFile}.", file, destFile);
                }
            }
        }

        foreach (var subDir in Directory.GetDirectories(sourceDir))
        {
            var destSubDir = Path.Combine(destinationDir, Path.GetFileName(subDir));
            CopyDirectory(subDir, destSubDir, logger);
        }
    }
}
