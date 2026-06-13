using System.Text.RegularExpressions;
using Microsoft.Data.SqlClient;

namespace ImperiusDraconisAPI.Data;

public static class DatabaseInitializer
{
    public static async Task InitializeAsync(IServiceProvider serviceProvider, IWebHostEnvironment environment)
    {
        var connectionFactory = serviceProvider.GetRequiredService<SqlConnectionFactory>();
        var logger = serviceProvider.GetRequiredService<ILogger<SqlConnectionFactory>>();

        try
        {
            using var connection = connectionFactory.CreateConnection();
            await connection.OpenAsync();

            // 1. Verificar si la tabla BibliotecaLibros ya existe
            using var checkCommand = new SqlCommand(
                "SELECT OBJECT_ID(N'dbo.BibliotecaLibros', N'U')",
                connection);
            var checkResult = await checkCommand.ExecuteScalarAsync();
            var tableExists = checkResult != DBNull.Value && checkResult != null;

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
            using var checkDescargasCommand = new SqlCommand(
                "SELECT OBJECT_ID(N'dbo.AlumnosLibrosDescargados', N'U')",
                connection);
            var checkDescargasResult = await checkDescargasCommand.ExecuteScalarAsync();
            var descargasTableExists = checkDescargasResult != DBNull.Value && checkDescargasResult != null;

            if (!descargasTableExists)
            {
                logger.LogInformation("Creando tabla AlumnosLibrosDescargados...");
                var createDescargasSql = """
                    CREATE TABLE dbo.AlumnosLibrosDescargados
                    (
                        Id INT IDENTITY(1,1) NOT NULL,
                        IdAlumno INT NOT NULL,
                        IdLibro INT NOT NULL,
                        FechaDescarga DATETIME NOT NULL CONSTRAINT DF_AlumnosLibrosDescargados_FechaDescarga DEFAULT GETDATE(),
                        CONSTRAINT PK_AlumnosLibrosDescargados PRIMARY KEY (Id),
                        CONSTRAINT FK_AlumnosLibrosDescargados_Alumnos FOREIGN KEY (IdAlumno) REFERENCES dbo.Alumnos(IdAlumno) ON DELETE CASCADE,
                        CONSTRAINT FK_AlumnosLibrosDescargados_BibliotecaLibros FOREIGN KEY (IdLibro) REFERENCES dbo.BibliotecaLibros(Id) ON DELETE CASCADE
                    );
                    """;
                using var createCmd = new SqlCommand(createDescargasSql, connection);
                await createCmd.ExecuteNonQueryAsync();
            }

            // 1.6 Establecer el costo base de todos los libros a 300 DC
            using var updateCostoCommand = new SqlCommand(
                "UPDATE dbo.BibliotecaLibros SET PrecioDracoins = 300 WHERE PrecioDracoins = 0",
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
                using var countCommand = new SqlCommand("SELECT COUNT(*) FROM dbo.BibliotecaLibros", connection);
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

    private static async Task ExecuteSqlScriptAsync(SqlConnection connection, string script)
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

            using var command = new SqlCommand(commandText, connection);
            command.CommandTimeout = 300; // 5 minutos para evitar timeouts en siembras grandes de datos
            await command.ExecuteNonQueryAsync();
        }
    }
}
