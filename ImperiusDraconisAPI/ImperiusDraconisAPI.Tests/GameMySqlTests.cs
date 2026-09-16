using ImperiusDraconisAPI.Data;
using ImperiusDraconisAPI.Models.Game.Eggs;
using ImperiusDraconisAPI.Services.Game;
using Microsoft.Extensions.Configuration;
using MySqlConnector;
using Xunit;

public sealed class GameMySqlFactAttribute : FactAttribute
{
    public GameMySqlFactAttribute()
    {
        if (string.IsNullOrEmpty(Environment.GetEnvironmentVariable("ID_TEST_GAME_MYSQL")))
            Skip = "Set ID_TEST_GAME_MYSQL to the isolated remediation schema after applying migrations.";
    }
}

public sealed class GameMySqlTests
{
    [GameMySqlFact]
    public async Task ReturnsInsertedAndUpdatedEggsAndBalances()
    {
        var connectionString = Environment.GetEnvironmentVariable("ID_TEST_GAME_MYSQL")!;
        Assert.Equal("remediation", new MySqlConnectionStringBuilder(connectionString).Database);
        await using var connection = new MySqlConnection(connectionString);
        await connection.OpenAsync();
        var idAlumno = Random.Shared.Next(10000, int.MaxValue);
        await using var setup = new MySqlCommand("""
            INSERT INTO Alumnos (IdAlumno, Activo, Dracoins) VALUES (@IdAlumno, 1, 1000);
            INSERT INTO GameDragonCapacity (IdAlumno, PurchasedSlots, MaxCapacity) VALUES (@IdAlumno, 1, 10);
            """, connection);
        setup.Parameters.AddWithValue("@IdAlumno", idAlumno);
        await setup.ExecuteNonQueryAsync();
        var config = new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string, string?>
        {
            ["ConnectionStrings:DefaultConnection"] = connectionString
        }).Build();
        var idempotency = new GameIdempotencyService();
        var dracoins = new DracoinGameService();
        var eggs = new GameEggService(new MySqlConnectionFactory(config), idempotency, dracoins);
        var egg = await eggs.CreateAsync(new CreateGameEggCommand
        {
            IdAlumno = idAlumno, EggDefinitionCode = "HOME", Rarity = "COMMON"
        }, default);
        Assert.True(egg.Id > 0);
        Assert.Equal(idAlumno, egg.IdAlumno);
        Assert.Equal("OWNED", egg.Status);
        Assert.Equal("OWNED", (await eggs.UpdateAsync(egg.Id, new UpdateGameEggCommand { Status = "OWNED" }, default)).Status);
        var incubating = await eggs.IncubateAsync(egg.Id, default);
        Assert.Equal(egg.Id, incubating.Id);
        Assert.Equal("INCUBATING", incubating.Status);
        Assert.NotNull(incubating.IncubationEndsAt);

        await using var transaction = await connection.BeginTransactionAsync();
        Assert.Equal(1020m, await dracoins.UpdateBalanceAsync(connection, transaction, idAlumno, 20, "TEST", "TEST", null, default));
        var reservation = await idempotency.ReserveAsync(connection, transaction, "TEST", Guid.NewGuid().ToString(), new byte[32], default);
        Assert.True(reservation.Id > 0);
        await idempotency.CompleteAsync(connection, transaction, reservation.Id, "{}", default);
        await transaction.RollbackAsync();
    }
}
