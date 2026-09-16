using System.Security.Cryptography;
using ImperiusDraconisAPI.Common;
using ImperiusDraconisAPI.Configuration;
using ImperiusDraconisAPI.Data;
using ImperiusDraconisAPI.Models.Auth;
using ImperiusDraconisAPI.Models.Biblioteca;
using ImperiusDraconisAPI.Models.Game.Eggs;
using ImperiusDraconisAPI.Models.Game.Dragons;
using ImperiusDraconisAPI.Services;
using ImperiusDraconisAPI.Services.Game;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.FileProviders;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Options;
using MiniExcelLibs;
using MySqlConnector;
using Xunit;

public sealed class ProductionUpgradeFactAttribute : FactAttribute
{
    public ProductionUpgradeFactAttribute()
    {
        if (string.IsNullOrWhiteSpace(Environment.GetEnvironmentVariable("ID_TEST_UPGRADE_MYSQL")))
            Skip = "Requires a disposable restored database named production_upgrade_test with migrations 017 and 018.";
    }
}

public sealed class ProductionUpgradeTests
{
    [ProductionUpgradeFact]
    public async Task ExistingSchemaSupportsLoginRotationEggLifecycleLedgerAndBookImport()
    {
        var cs = Environment.GetEnvironmentVariable("ID_TEST_UPGRADE_MYSQL")!;
        Assert.Equal("production_upgrade_test", new MySqlConnectionStringBuilder(cs).Database);
        var config = new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string, string?>
        {
            ["ConnectionStrings:DefaultConnection"] = cs
        }).Build();
        var factory = new MySqlConnectionFactory(config);
        await using var connection = factory.CreateConnection();
        await connection.OpenAsync();
        var code = "T" + Convert.ToHexString(RandomNumberGenerator.GetBytes(4));
        var password = Guid.NewGuid().ToString();
        await using var command = new MySqlCommand("""
            INSERT INTO Alumnos (Codigo, Nombre, Contrasena, Activo, Dracoins)
            VALUES (@Code, 'Upgrade smoke test', @Password, 1, 5000);
            SELECT LAST_INSERT_ID();
            """, connection);
        command.Parameters.AddWithValue("@Code", code);
        command.Parameters.AddWithValue("@Password", PasswordHasher.HashPassword(password));
        var id = Convert.ToInt32(await command.ExecuteScalarAsync());
        var robloxId = (long)int.MaxValue + id;
        command.Parameters.Clear();
        command.Parameters.AddWithValue("@Id", id);
        command.Parameters.AddWithValue("@Roblox", robloxId);
        command.CommandText = """
            INSERT INTO GameDragonCapacity (IdAlumno, PurchasedSlots, MaxCapacity) VALUES (@Id, 3, 10);
            INSERT INTO GameRobloxLinks (IdAlumno, RobloxUserId) VALUES (@Id, @Roblox);
            INSERT INTO Chismes (IdAlumno, Texto) VALUES (@Id, 'Upgrade smoke test');
            INSERT INTO NotasAlumno (IdAlumno, Nota) VALUES (@Id, 'Upgrade smoke test');
            """;
        await command.ExecuteNonQueryAsync();

        var auth = new AuthService(factory, Options.Create(new JwtOptions
        {
            Issuer = "upgrade-test", Audience = "upgrade-test", SecretKey = new string('x', 64)
        }), Options.Create(new SmtpOptions()), Options.Create(new AuthRecoveryOptions()), new TestEnvironment());
        var login = await auth.LoginAsync(new LoginRequest { Codigo = code, Contrasena = password }, default);
        Assert.NotNull(login);
        Assert.NotEmpty(login.RefreshToken);
        var rotated = await auth.RefreshAsync(login.RefreshToken, default);
        Assert.NotNull(rotated);
        Assert.Null(await auth.RefreshAsync(login.RefreshToken, default));

        var eggs = new GameEggService(factory, new GameIdempotencyService(), new DracoinGameService());
        var purchased = await eggs.PurchaseAsync(new PurchaseGameEggRequest
        {
            RobloxUserId = robloxId, EggDefinitionCode = "HOME"
        }, Guid.NewGuid().ToString(), default);
        Assert.True(purchased.Id > 0);
        var egg = await eggs.IncubateAsync(purchased.Id, default);
        Assert.Equal("INCUBATING", egg.Status);
        command.Parameters.AddWithValue("@Egg", egg.Id);
        command.CommandText = """
            UPDATE GameEggs SET AcquiredAt = UTC_TIMESTAMP(3) - INTERVAL 2 HOUR,
                IncubationStartedAt = UTC_TIMESTAMP(3) - INTERVAL 1 HOUR,
                IncubationEndsAt = UTC_TIMESTAMP(3) - INTERVAL 1 MINUTE,
                UpdatedAt = UTC_TIMESTAMP(3) WHERE Id = @Egg;
            """;
        await command.ExecuteNonQueryAsync();
        var dragon = await eggs.HatchAsync(egg.Id, new HatchGameEggRequest { RobloxUserId = robloxId, Name = "Upgrade test" }, default);
        Assert.NotNull(dragon);
        Assert.Equal("HATCHED", (await eggs.GetByIdAsync(egg.Id, default))!.Status);

        var books = new BibliotecaService(factory, null!);
        using var excel = new MemoryStream();
        excel.SaveAs(Enumerable.Range(1, 105).Select(i => new BookExcelRow
        {
            Titulo = $"{code} book {i}", Autor = "Upgrade test", Categoria = code,
            RutaArchivo = "Libros/test.pdf", Formato = ".pdf", Activo = false
        }).ToList());
        excel.Position = 0;
        Assert.Equal(105, await books.ImportarLibrosExcelAsync(excel, default));
    }

    private sealed class TestEnvironment : IHostEnvironment
    {
        public string EnvironmentName { get; set; } = "Development";
        public string ApplicationName { get; set; } = "Tests";
        public string ContentRootPath { get; set; } = AppContext.BaseDirectory;
        public IFileProvider ContentRootFileProvider { get; set; } = new NullFileProvider();
    }
}
