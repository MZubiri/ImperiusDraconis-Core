using System.Security.Cryptography;
using System.Text;
using ImperiusDraconisAPI.Configuration;
using ImperiusDraconisAPI.Data;
using ImperiusDraconisAPI.Services;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.FileProviders;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Options;
using MySqlConnector;
using Xunit;

public sealed class MySqlIntegrationFactAttribute : FactAttribute
{
    public MySqlIntegrationFactAttribute()
    {
        if (string.IsNullOrEmpty(Environment.GetEnvironmentVariable("ID_TEST_MYSQL")))
            Skip = "Set ID_TEST_MYSQL to an isolated MySQL test server (database remediation_auth).";
    }
}

public sealed class RefreshTokenTests
{
    [MySqlIntegrationFact]
    public async Task RotatesAtomicallyAndRejectsExpiredRevokedAndInactiveTokens()
    {
        var connectionString = Environment.GetEnvironmentVariable("ID_TEST_MYSQL")!;
        Assert.Equal("remediation_auth", new MySqlConnectionStringBuilder(connectionString).Database);
        await using var connection = new MySqlConnection(connectionString);
        await connection.OpenAsync();
        await using var setup = new MySqlCommand("""
            CREATE TABLE IF NOT EXISTS Alumnos (
                IdAlumno INT PRIMARY KEY, Codigo VARCHAR(20), Nombre VARCHAR(100), IdCasa INT NULL,
                IdCargo INT NULL, Categoria VARCHAR(50), Activo TINYINT, Genero VARCHAR(10),
                FotoPerfil VARCHAR(100), Dracoins DECIMAL(18,2));
            CREATE TABLE IF NOT EXISTS Casas (IdCasa INT PRIMARY KEY, Nombre VARCHAR(50));
            CREATE TABLE IF NOT EXISTS Cargos (IdCargo INT PRIMARY KEY, Nombre VARCHAR(50));
            CREATE TABLE IF NOT EXISTS AlumnosTrabajos (IdAlumno INT, IdTrabajo INT);
            DELETE FROM Alumnos;
            INSERT INTO Alumnos VALUES (1, 'TEST', 'Test', NULL, NULL, 'Alumno', 1, '', '', 0);
            """, connection);
        await setup.ExecuteNonQueryAsync();
        var migration = Path.Combine(AppContext.BaseDirectory, "SQLMigrar", "017_create_refresh_tokens.sql");
        setup.CommandText = await File.ReadAllTextAsync(migration);
        await setup.ExecuteNonQueryAsync();
        var config = new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string, string?>
        {
            ["ConnectionStrings:DefaultConnection"] = connectionString
        }).Build();
        var service = new AuthService(new MySqlConnectionFactory(config),
            Options.Create(new JwtOptions { Issuer = "test", Audience = "test", SecretKey = new string('x', 64) }),
            Options.Create(new SmtpOptions()), Options.Create(new AuthRecoveryOptions()), new TestEnvironment());

        async Task<string> Seed(int days, bool revoked = false)
        {
            var token = Convert.ToHexString(RandomNumberGenerator.GetBytes(64));
            await using var cmd = new MySqlCommand("""
                INSERT INTO RefreshTokens (IdAlumno, Token, ExpiresAt, RevokedAt)
                VALUES (1, @Hash, @Expires, @Revoked);
                """, connection);
            cmd.Parameters.AddWithValue("@Hash", Convert.ToHexString(SHA256.HashData(Encoding.UTF8.GetBytes(token))));
            cmd.Parameters.AddWithValue("@Expires", DateTime.UtcNow.AddDays(days));
            cmd.Parameters.AddWithValue("@Revoked", revoked ? DateTime.UtcNow : DBNull.Value);
            await cmd.ExecuteNonQueryAsync();
            return token;
        }

        var original = await Seed(7);
        var results = await Task.WhenAll(service.RefreshAsync(original, default), service.RefreshAsync(original, default));
        var rotated = Assert.Single(results, x => x is not null)!;
        Assert.NotEqual(original, rotated.RefreshToken);
        Assert.InRange(rotated.ExpiresAt, DateTimeOffset.UtcNow.AddMinutes(29), DateTimeOffset.UtcNow.AddMinutes(31));
        Assert.Null(await service.RefreshAsync(original, default));
        Assert.NotNull(await service.RefreshAsync(rotated.RefreshToken, default));
        Assert.Null(await service.RefreshAsync(await Seed(-1), default));
        Assert.Null(await service.RefreshAsync(await Seed(7, true), default));
        var inactive = await Seed(7);
        setup.CommandText = "UPDATE Alumnos SET Activo = 0 WHERE IdAlumno = 1;";
        await setup.ExecuteNonQueryAsync();
        Assert.Null(await service.RefreshAsync(inactive, default));
        Assert.Null(await service.RefreshAsync("invalid", default));
    }

    private sealed class TestEnvironment : IHostEnvironment
    {
        public string EnvironmentName { get; set; } = "Development";
        public string ApplicationName { get; set; } = "Tests";
        public string ContentRootPath { get; set; } = AppContext.BaseDirectory;
        public IFileProvider ContentRootFileProvider { get; set; } = new NullFileProvider();
    }
}
