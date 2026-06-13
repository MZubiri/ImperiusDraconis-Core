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

            // Verificar si la tabla BibliotecaLibros ya existe
            using var checkCommand = new SqlCommand(
                "SELECT OBJECT_ID(N'dbo.BibliotecaLibros', N'U')",
                connection);
            var result = await checkCommand.ExecuteScalarAsync();

            if (result != DBNull.Value && result != null)
            {
                logger.LogInformation("Las tablas de biblioteca ya existen. Omitiendo migracion.");
                return;
            }

            logger.LogInformation("Iniciando migracion automatica de base de datos para Biblioteca...");

            var rootPath = Path.Combine(environment.ContentRootPath, "..", "SQLMigrar");
            
            // 1. Ejecutar 012_create_biblioteca_tables.sql
            var tablesScriptPath = Path.Combine(rootPath, "012_create_biblioteca_tables.sql");
            if (File.Exists(tablesScriptPath))
            {
                logger.LogInformation("Ejecutando esquema de tablas: 012_create_biblioteca_tables.sql");
                var script = await File.ReadAllTextAsync(tablesScriptPath);
                await ExecuteSqlScriptAsync(connection, script);
            }

            // 2. Ejecutar 013_seed_biblioteca_data.sql
            var seedScriptPath = Path.Combine(rootPath, "013_seed_biblioteca_data.sql");
            if (File.Exists(seedScriptPath))
            {
                logger.LogInformation("Sembrando datos: 013_seed_biblioteca_data.sql (esto puede tardar unos segundos)...");
                var script = await File.ReadAllTextAsync(seedScriptPath);
                await ExecuteSqlScriptAsync(connection, script);
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
