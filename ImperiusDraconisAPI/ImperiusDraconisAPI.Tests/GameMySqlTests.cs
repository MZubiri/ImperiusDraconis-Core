using ImperiusDraconisAPI.Data;
using ImperiusDraconisAPI.Models.Game.Eggs;
using ImperiusDraconisAPI.Models.Game.Dragons;
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
        var robloxUserId = (long)int.MaxValue + idAlumno;
        await using var setup = new MySqlCommand("""
            INSERT INTO Alumnos (IdAlumno, Activo, Dracoins) VALUES (@IdAlumno, 1, 1000);
            INSERT INTO GameDragonCapacity (IdAlumno, PurchasedSlots, MaxCapacity) VALUES (@IdAlumno, 1, 10);
            INSERT INTO GameRobloxLinks (IdAlumno, RobloxUserId) VALUES (@IdAlumno, @RobloxUserId);
            """, connection);
        setup.Parameters.AddWithValue("@IdAlumno", idAlumno);
        setup.Parameters.AddWithValue("@RobloxUserId", robloxUserId);
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
        var incubating = await eggs.IncubateAsync(
            egg.Id,
            new IncubateGameEggRequest { RobloxUserId = robloxUserId },
            Guid.NewGuid().ToString(),
            default);
        Assert.Equal(egg.Id, incubating.Id);
        Assert.Equal("INCUBATING", incubating.Status);
        Assert.NotNull(incubating.IncubationEndsAt);

        await using var createDragon = new MySqlCommand("""
            INSERT INTO GameDragons
                (IdAlumno, Name, Rarity, Temperament, SpeciesCode, LastNeedsUpdateAt)
            VALUES
                (@IdAlumno, 'Care test', 'COMMON', 'JUGUETON', 'BRASALOMA', UTC_TIMESTAMP(3) - INTERVAL 12 HOUR);
            SELECT LAST_INSERT_ID();
            """, connection);
        createDragon.Parameters.AddWithValue("@IdAlumno", idAlumno);
        var dragonId = Convert.ToInt64(await createDragon.ExecuteScalarAsync());
        var care = new GameDragonCareService(new MySqlConnectionFactory(config), idempotency, dracoins);
        var feedKey = Guid.NewGuid().ToString();
        var fed = await care.FeedAsync(
            dragonId,
            "MOON_BERRY",
            new DragonPlayerRequest { RobloxUserId = robloxUserId },
            feedKey,
            default);
        Assert.Equal(970m, fed.BalanceAfter);
        Assert.Equal(100, fed.Dragon.Hunger);
        Assert.Equal(fed.Dragon.Hunger, (await care.FeedAsync(
            dragonId,
            "MOON_BERRY",
            new DragonPlayerRequest { RobloxUserId = robloxUserId },
            feedKey,
            default)).Dragon.Hunger);

        var petted = await care.PetAsync(
            dragonId,
            new DragonPlayerRequest { RobloxUserId = robloxUserId },
            Guid.NewGuid().ToString(),
            default);
        Assert.NotNull(petted.NextPetAt);
        await Assert.ThrowsAsync<ImperiusDraconisAPI.Common.GameBusinessRuleException>(() => care.PetAsync(
            dragonId,
            new DragonPlayerRequest { RobloxUserId = robloxUserId },
            Guid.NewGuid().ToString(),
            default));
        var listedDragons = await new GameDragonService(new MySqlConnectionFactory(config), idempotency)
            .ListByPlayerAsync(idAlumno, default);
        Assert.Contains(listedDragons, item => item.Id == dragonId && item.SpeciesCode == "BRASALOMA");

        await using var transaction = await connection.BeginTransactionAsync();
        Assert.Equal(990m, await dracoins.UpdateBalanceAsync(connection, transaction, idAlumno, 20, "TEST", "TEST", null, default));
        var reservation = await idempotency.ReserveAsync(connection, transaction, "TEST", Guid.NewGuid().ToString(), new byte[32], default);
        Assert.True(reservation.Id > 0);
        await idempotency.CompleteAsync(connection, transaction, reservation.Id, "{}", default);
        await transaction.RollbackAsync();
    }
}
