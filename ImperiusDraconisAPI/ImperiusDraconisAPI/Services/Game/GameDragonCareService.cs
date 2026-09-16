using System.Data;
using System.Globalization;
using System.Security.Cryptography;
using System.Text;
using System.Text.Json;
using ImperiusDraconisAPI.Common;
using ImperiusDraconisAPI.Data;
using ImperiusDraconisAPI.Models.Game.Dragons;
using ImperiusDraconisAPI.Models.Game.Players;
using Microsoft.AspNetCore.Http;
using MySqlConnector;

namespace ImperiusDraconisAPI.Services.Game;

public sealed class GameDragonCareService
{
    private static readonly JsonSerializerOptions JsonOptions = new(JsonSerializerDefaults.Web);
    private readonly MySqlConnectionFactory _connectionFactory;
    private readonly GameIdempotencyService _idempotencyService;
    private readonly DracoinGameService _dracoinGameService;

    public GameDragonCareService(
        MySqlConnectionFactory connectionFactory,
        GameIdempotencyService idempotencyService,
        DracoinGameService dracoinGameService)
    {
        _connectionFactory = connectionFactory;
        _idempotencyService = idempotencyService;
        _dracoinGameService = dracoinGameService;
    }

    public async Task<IReadOnlyCollection<GameFoodDefinition>> GetFoodCatalogAsync(CancellationToken cancellationToken)
    {
        await using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);
        await using var command = new MySqlCommand(
            """
            SELECT Code, DisplayName, Description, PriceDracoins, HungerGain, LifeGain, HappinessGain, ExperienceGain
            FROM GameFoodDefinitions WHERE Active = 1 ORDER BY SortOrder, Code;
            """,
            connection);
        var result = new List<GameFoodDefinition>();
        await using var reader = await command.ExecuteReaderAsync(cancellationToken);
        while (await reader.ReadAsync(cancellationToken))
        {
            result.Add(new GameFoodDefinition
            {
                Code = reader.GetString(0), DisplayName = reader.GetString(1), Description = reader.GetString(2),
                PriceDracoins = reader.GetInt32(3), HungerGain = reader.GetInt32(4), LifeGain = reader.GetInt32(5),
                HappinessGain = reader.GetInt32(6), ExperienceGain = reader.GetInt32(7)
            });
        }
        return result;
    }

    public Task<DragonCareResponse> FeedAsync(
        long dragonId,
        string foodCode,
        DragonPlayerRequest request,
        string idempotencyKey,
        CancellationToken cancellationToken) =>
        ExecuteCareAsync(dragonId, request, idempotencyKey, $"FEED:{foodCode.Trim().ToUpperInvariant()}", foodCode, cancellationToken);

    public Task<DragonCareResponse> PetAsync(
        long dragonId,
        DragonPlayerRequest request,
        string idempotencyKey,
        CancellationToken cancellationToken) =>
        ExecuteCareAsync(dragonId, request, idempotencyKey, "PET", null, cancellationToken);

    private async Task<DragonCareResponse> ExecuteCareAsync(
        long dragonId,
        DragonPlayerRequest request,
        string idempotencyKey,
        string operation,
        string? foodCode,
        CancellationToken cancellationToken)
    {
        if (dragonId <= 0 || request.RobloxUserId <= 0)
            throw Rule("BUSINESS_RULE_ERROR", "DragonId y RobloxUserId deben ser mayores a cero.", 400);
        var key = idempotencyKey.Trim();
        if (key.Length is 0 or > 100)
            throw Rule("BUSINESS_RULE_ERROR", "X-Idempotency-Key debe contener entre 1 y 100 caracteres.", 400);

        var normalizedFoodCode = foodCode?.Trim().ToUpperInvariant();
        var hash = SHA256.HashData(Encoding.UTF8.GetBytes($"{dragonId}:{request.RobloxUserId}:{operation}"));
        await using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);
        await using var transaction = (MySqlTransaction)await connection.BeginTransactionAsync(IsolationLevel.Serializable, cancellationToken);
        try
        {
            var reservation = await _idempotencyService.ReserveAsync(connection, transaction, "GAME_DRAGON_CARE_" + operation, key, hash, cancellationToken);
            if (reservation.CompletedResponseJson is not null)
            {
                var replay = JsonSerializer.Deserialize<DragonCareResponse>(reservation.CompletedResponseJson, JsonOptions)
                    ?? throw new InvalidOperationException("La respuesta idempotente almacenada no es valida.");
                await transaction.CommitAsync(cancellationToken);
                return replay;
            }

            await using var dragonCommand = new MySqlCommand(
                """
                SELECT D.IdAlumno, D.Name, D.Rarity, D.Temperament, D.SpeciesCode, D.Level, D.Stage, D.HatchedAt,
                       D.Life, D.Happiness, D.Hunger, D.Experience, D.Status, D.Selected, D.LastNeedsUpdateAt,
                       D.LastPettedAt, COALESCE(C.Nombre, ''), COALESCE(A.Dracoins, 0), CAST(COALESCE(A.Activo, 0) AS UNSIGNED)
                FROM GameDragons D
                INNER JOIN Alumnos A ON A.IdAlumno = D.IdAlumno
                INNER JOIN GameRobloxLinks L ON L.IdAlumno = D.IdAlumno AND L.Active = 1
                LEFT JOIN Casas C ON C.IdCasa = A.IdCasa
                WHERE D.Id = @DragonId AND L.RobloxUserId = @RobloxUserId FOR UPDATE;
                """, connection, transaction);
            dragonCommand.Parameters.Add("@DragonId", MySqlDbType.Int64).Value = dragonId;
            dragonCommand.Parameters.Add("@RobloxUserId", MySqlDbType.Int64).Value = request.RobloxUserId;

            DragonState dragon;
            await using (var reader = await dragonCommand.ExecuteReaderAsync(cancellationToken))
            {
                if (!await reader.ReadAsync(cancellationToken))
                    throw Rule("DRAGON_NOT_FOUND", "El dragon no existe o no pertenece al jugador.", 404);
                if (!reader.GetBoolean(18))
                    throw Rule("PLAYER_INACTIVE", "El jugador vinculado no se encuentra activo.", 403);
                dragon = new DragonState(
                    reader.GetInt32(0), reader.GetString(1), reader.GetString(2), reader.GetString(3), reader.GetString(4),
                    reader.GetInt32(5), reader.GetString(6), AsUtc(reader.GetDateTime(7)), reader.GetInt32(8), reader.GetInt32(9),
                    reader.GetInt32(10), reader.GetInt32(11), reader.GetString(12), reader.GetBoolean(13), AsUtc(reader.GetDateTime(14)),
                    reader.IsDBNull(15) ? null : AsUtc(reader.GetDateTime(15)), reader.GetString(16), reader.GetDecimal(17));
            }

            var now = DateTime.UtcNow;
            var needs = GameDragonNeedsRules.ApplyDecay(dragon.Life, dragon.Happiness, dragon.Hunger, dragon.LastNeedsUpdateAt, now);
            if (needs.Status == "FLED")
                throw Rule("DRAGON_FLED", "El dragon ha huido y debe ser restaurado antes de interactuar.", 400);

            var life = needs.Life;
            var happiness = needs.Happiness;
            var hunger = needs.Hunger;
            var experience = dragon.Experience;
            var balance = dragon.Balance;
            DateTime? lastPettedAt = dragon.LastPettedAt;
            string message;

            if (normalizedFoodCode is not null)
            {
                await using var foodCommand = new MySqlCommand(
                    "SELECT PriceDracoins, HungerGain, LifeGain, HappinessGain, ExperienceGain FROM GameFoodDefinitions WHERE Code = @Code AND Active = 1;",
                    connection, transaction);
                foodCommand.Parameters.Add("@Code", MySqlDbType.VarChar, 50).Value = normalizedFoodCode;
                await using var reader = await foodCommand.ExecuteReaderAsync(cancellationToken);
                if (!await reader.ReadAsync(cancellationToken))
                    throw Rule("FOOD_NOT_FOUND", "El alimento no existe o no esta disponible.", 404);
                var price = reader.GetInt32(0);
                var hungerGain = reader.GetInt32(1);
                var lifeGain = reader.GetInt32(2);
                var happinessGain = reader.GetInt32(3);
                var experienceGain = reader.GetInt32(4);
                await reader.CloseAsync();
                if (dragon.Temperament == "JUGUETON") happinessGain = (int)Math.Ceiling(happinessGain * 1.05m);
                hunger = Math.Clamp(hunger + hungerGain, 0, 100);
                life = Math.Clamp(life + lifeGain, 0, 100);
                happiness = Math.Clamp(happiness + happinessGain, 0, 100);
                experience += experienceGain;
                if (price > 0)
                    balance = await _dracoinGameService.UpdateBalanceAsync(connection, transaction, dragon.IdAlumno, -price, "DRAGON_FEED", "GAME_DRAGON", dragonId.ToString(CultureInfo.InvariantCulture), cancellationToken);
                message = "Tu dragon ha disfrutado su alimento.";
            }
            else
            {
                var nextPetAt = dragon.LastPettedAt?.AddHours(4);
                if (nextPetAt > now)
                    throw Rule("PET_COOLDOWN", $"Podras acariciar nuevamente al dragon a las {nextPetAt.Value:O}.", 409);
                var happinessGain = dragon.HouseName.Equals("Hufflepuff", StringComparison.OrdinalIgnoreCase) ? 7 : 6;
                happiness = Math.Clamp(happiness + happinessGain, 0, 100);
                if (Random.Shared.Next(100) < 15) experience += 3;
                lastPettedAt = now;
                message = dragon.Temperament switch
                {
                    "NOBLE" => "Tu dragon inclina la cabeza con dignidad.",
                    "AGRESIVO" => "Tu dragon resopla, pero acepta la caricia.",
                    "JUGUETON" => "Tu dragon da un salto y pide seguir jugando.",
                    "CURIOSO" => "Tu dragon observa tu mano con mucha atencion.",
                    _ => "Tu dragon bosteza y se acomoda a tu lado."
                };
            }

            var progress = GameDragonNeedsRules.CalculateProgress(experience, dragon.HatchedAt, now);
            await using var update = new MySqlCommand(
                """
                UPDATE GameDragons SET Life=@Life, Happiness=@Happiness, Hunger=@Hunger, Experience=@Experience,
                    Level=@Level, Stage=@Stage, Status='ACTIVE', LastNeedsUpdateAt=@Now, LastPettedAt=@LastPettedAt
                WHERE Id=@DragonId;
                """, connection, transaction);
            update.Parameters.AddWithValue("@Life", life); update.Parameters.AddWithValue("@Happiness", happiness);
            update.Parameters.AddWithValue("@Hunger", hunger); update.Parameters.AddWithValue("@Experience", experience);
            update.Parameters.AddWithValue("@Level", progress.Level); update.Parameters.AddWithValue("@Stage", progress.Stage);
            update.Parameters.AddWithValue("@Now", now); update.Parameters.AddWithValue("@LastPettedAt", (object?)lastPettedAt ?? DBNull.Value);
            update.Parameters.AddWithValue("@DragonId", dragonId);
            await update.ExecuteNonQueryAsync(cancellationToken);

            var response = new DragonCareResponse
            {
                Dragon = new GameBootstrapDragonDto
                {
                    Id = dragonId, Name = dragon.Name, Rarity = dragon.Rarity, Temperament = dragon.Temperament,
                    SpeciesCode = dragon.SpeciesCode, Level = progress.Level, Stage = progress.Stage, HatchedAt = dragon.HatchedAt,
                    Life = life, Happiness = happiness, Hunger = hunger, Experience = experience, Status = "ACTIVE",
                    Selected = dragon.Selected, LastNeedsUpdateAt = now
                },
                BalanceAfter = balance,
                NextPetAt = lastPettedAt?.AddHours(4),
                Message = message
            };
            await _idempotencyService.CompleteAsync(connection, transaction, reservation.Id, JsonSerializer.Serialize(response, JsonOptions), cancellationToken);
            await transaction.CommitAsync(cancellationToken);
            return response;
        }
        catch
        {
            await transaction.RollbackAsync(cancellationToken);
            throw;
        }
    }

    private static GameBusinessRuleException Rule(string code, string message, int status) => new(code, message, status);
    private static DateTime AsUtc(DateTime value) => DateTime.SpecifyKind(value, DateTimeKind.Utc);

    private sealed record DragonState(
        int IdAlumno, string Name, string Rarity, string Temperament, string SpeciesCode, int Level, string Stage,
        DateTime HatchedAt, int Life, int Happiness, int Hunger, int Experience, string Status, bool Selected,
        DateTime LastNeedsUpdateAt, DateTime? LastPettedAt, string HouseName, decimal Balance);
}
