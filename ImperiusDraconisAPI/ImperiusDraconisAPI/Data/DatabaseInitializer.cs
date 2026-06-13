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

            if (librosCount == 0)
            {
                logger.LogInformation("La tabla BibliotecaLibros esta vacia. Iniciando siembra de datos...");
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
            await command.ExecuteNonQueryAsync();
        }
    }
}
