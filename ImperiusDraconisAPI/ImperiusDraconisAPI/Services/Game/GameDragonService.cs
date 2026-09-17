using System.Data;
using System.Security.Cryptography;
using System.Text;
using System.Text.Json;
using Microsoft.AspNetCore.Http;
using ImperiusDraconisAPI.Common;
using ImperiusDraconisAPI.Data;
using ImperiusDraconisAPI.Models.Game.Dragons;
using ImperiusDraconisAPI.Models.Game.Players;
using MySqlConnector;

namespace ImperiusDraconisAPI.Services.Game;

public sealed class GameDragonService
{
    private readonly MySqlConnectionFactory _connectionFactory;
    private readonly GameIdempotencyService _idempotencyService;

    public GameDragonService(
        MySqlConnectionFactory connectionFactory,
        GameIdempotencyService idempotencyService)
    {
        _connectionFactory = connectionFactory;
        _idempotencyService = idempotencyService;
    }

    public async Task<SelectDragonResponse> SelectDragonAsync(
        long dragonId,
        SelectDragonRequest request,
        string idempotencyKey,
        CancellationToken cancellationToken)
    {
        if (dragonId <= 0)
        {
            throw new GameBusinessRuleException(
                "BUSINESS_RULE_ERROR",
                "DragonId debe ser mayor a cero.",
                StatusCodes.Status400BadRequest);
        }

        if (request.RobloxUserId <= 0)
        {
            throw new GameBusinessRuleException(
                "BUSINESS_RULE_ERROR",
                "RobloxUserId debe ser mayor a cero.",
                StatusCodes.Status400BadRequest);
        }

        var normalizedIdempotencyKey = idempotencyKey.Trim();
        if (normalizedIdempotencyKey.Length > 100)
        {
            throw new GameBusinessRuleException(
                "BUSINESS_RULE_ERROR",
                "X-Idempotency-Key no puede superar 100 caracteres.",
                StatusCodes.Status400BadRequest);
        }

        var payload = $"{request.RobloxUserId}:{dragonId}";
        var requestHash = SHA256.HashData(Encoding.UTF8.GetBytes(payload));

        await using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);
        await using var transaction = (MySqlTransaction)await connection.BeginTransactionAsync(
            IsolationLevel.Serializable,
            cancellationToken);

        try
        {
            var reservation = await _idempotencyService.ReserveAsync(
                connection,
                transaction,
                "GAME_DRAGON_SELECT",
                normalizedIdempotencyKey,
                requestHash,
                cancellationToken);

            if (reservation.CompletedResponseJson is not null)
            {
                var previousResponse = JsonSerializer.Deserialize<SelectDragonResponse>(
                    reservation.CompletedResponseJson,
                    new JsonSerializerOptions(JsonSerializerDefaults.Web))
                    ?? throw new InvalidOperationException("La respuesta idempotente almacenada no es valida.");

                await transaction.CommitAsync(cancellationToken);
                return previousResponse;
            }

            // 1. Obtener IdAlumno del usuario Roblox que hace la llamada
            await using var linkCommand = new MySqlCommand(
                """
                SELECT L.IdAlumno, CAST(COALESCE(A.Activo, 0) AS UNSIGNED)
                FROM GameRobloxLinks L
                INNER JOIN Alumnos A ON A.IdAlumno = L.IdAlumno
                WHERE L.RobloxUserId = @RobloxUserId AND L.Active = 1;
                """,
                connection,
                transaction);
            linkCommand.Parameters.Add("@RobloxUserId", MySqlDbType.Int64).Value = request.RobloxUserId;

            int callerIdAlumno;
            await using (var reader = await linkCommand.ExecuteReaderAsync(cancellationToken))
            {
                if (!await reader.ReadAsync(cancellationToken))
                {
                    throw new GameBusinessRuleException(
                        "NOT_LINKED",
                        "La cuenta Roblox no se encuentra vinculada.",
                        StatusCodes.Status404NotFound);
                }

                if (!reader.GetBoolean(1))
                {
                    throw new GameBusinessRuleException(
                        "PLAYER_INACTIVE",
                        "El jugador vinculado no se encuentra activo.",
                        StatusCodes.Status403Forbidden);
                }

                callerIdAlumno = reader.GetInt32(0);
            }

            // 2. Obtener dragon con bloqueo
            await using var dragonCommand = new MySqlCommand(
                """
                SELECT IdAlumno, Status, Selected
                FROM GameDragons
                WHERE Id = @Id FOR UPDATE;
                """,
                connection,
                transaction);
            dragonCommand.Parameters.Add("@Id", MySqlDbType.Int64).Value = dragonId;

            int dragonIdAlumno;
            string dragonStatus;
            bool dragonSelected;

            await using (var reader = await dragonCommand.ExecuteReaderAsync(cancellationToken))
            {
                if (!await reader.ReadAsync(cancellationToken))
                {
                    throw new GameBusinessRuleException(
                        "DRAGON_NOT_FOUND",
                        "El dragon no existe.",
                        StatusCodes.Status404NotFound);
                }

                dragonIdAlumno = reader.GetInt32(0);
                dragonStatus = reader.GetString(1);
                dragonSelected = reader.GetBoolean(2);
            }

            // Validar pertenencia
            if (dragonIdAlumno != callerIdAlumno)
            {
                throw new GameBusinessRuleException(
                    "DRAGON_NOT_OWNED",
                    "El dragon especificado no te pertenece.",
                    StatusCodes.Status403Forbidden);
            }

            // Validar si ha huido
            if (dragonStatus == "FLED")
            {
                throw new GameBusinessRuleException(
                    "DRAGON_FLED",
                    "No se puede seleccionar un dragon que ha huido.",
                    StatusCodes.Status400BadRequest);
            }

            // 3. Si no esta seleccionado, marcar como seleccionado y desmarcar los otros
            if (!dragonSelected)
            {
                // Desmarcar todos los demas dragones de este alumno
                await using var deselectCommand = new MySqlCommand(
                    """
                    UPDATE GameDragons
                    SET Selected = 0
                    WHERE IdAlumno = @IdAlumno AND Selected = 1;
                    """,
                    connection,
                    transaction);
                deselectCommand.Parameters.Add("@IdAlumno", MySqlDbType.Int32).Value = callerIdAlumno;
                await deselectCommand.ExecuteNonQueryAsync(cancellationToken);

                // Seleccionar el dragon objetivo
                await using var selectCommand = new MySqlCommand(
                    """
                    UPDATE GameDragons
                    SET Selected = 1
                    WHERE Id = @Id;
                    """,
                    connection,
                    transaction);
                selectCommand.Parameters.Add("@Id", MySqlDbType.Int64).Value = dragonId;
                await selectCommand.ExecuteNonQueryAsync(cancellationToken);
            }

            var response = new SelectDragonResponse
            {
                DragonId = dragonId,
                Selected = true
            };

            var serializedResponse = JsonSerializer.Serialize(response, new JsonSerializerOptions(JsonSerializerDefaults.Web));
            await _idempotencyService.CompleteAsync(connection, transaction, reservation.Id, serializedResponse, cancellationToken);

            await transaction.CommitAsync(cancellationToken);
            return response;
        }
        catch
        {
            await transaction.RollbackAsync(cancellationToken);
            throw;
        }
    }

    public async Task<IReadOnlyCollection<GameBootstrapDragonDto>> ListByPlayerAsync(
        int idAlumno,
        CancellationToken cancellationToken)
    {
        if (idAlumno <= 0)
        {
            throw new GameBusinessRuleException(
                "BUSINESS_RULE_ERROR",
                "IdAlumno debe ser mayor a cero.",
                StatusCodes.Status400BadRequest);
        }

        await using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);
        await using var transaction = (MySqlTransaction)await connection.BeginTransactionAsync(
            IsolationLevel.Serializable,
            cancellationToken);
        await using var command = new MySqlCommand(
            """
            SELECT
                D.Id,
                D.Name,
                D.Rarity,
                D.Temperament,
                D.SpeciesCode,
                D.Level,
                D.Stage,
                D.HatchedAt,
                D.Life,
                D.Happiness,
                D.Hunger,
                D.Experience,
                D.Status,
                D.Selected,
                D.LastNeedsUpdateAt
            FROM GameDragons D
            WHERE D.IdAlumno = @IdAlumno
            ORDER BY D.HatchedAt, D.Id FOR UPDATE;
            """,
            connection,
            transaction);
        command.Parameters.Add("@IdAlumno", MySqlDbType.Int32).Value = idAlumno;

        var dragons = new List<GameBootstrapDragonDto>();
        var now = DateTime.UtcNow;
        await using var reader = await command.ExecuteReaderAsync(cancellationToken);
        while (await reader.ReadAsync(cancellationToken))
        {
            var hatchedAt = AsUtc(reader.GetDateTime(7));
            var experience = reader.GetInt32(11);
            var needs = GameDragonNeedsRules.ApplyDecay(
                reader.GetInt32(8), reader.GetInt32(9), reader.GetInt32(10), AsUtc(reader.GetDateTime(14)), now,
                reader.GetString(3) == "PEREZOSO" ? -5 : 0);
            var progress = GameDragonNeedsRules.CalculateProgress(experience, hatchedAt, now, needs.Life, needs.Happiness);
            dragons.Add(new GameBootstrapDragonDto
            {
                Id = reader.GetInt64(0),
                Name = reader.GetString(1),
                Rarity = reader.GetString(2),
                Temperament = reader.GetString(3),
                SpeciesCode = reader.GetString(4),
                Level = progress.Level,
                Stage = progress.Stage,
                HatchedAt = hatchedAt,
                Life = needs.Life,
                Happiness = needs.Happiness,
                Hunger = needs.Hunger,
                Experience = experience,
                Status = needs.Status,
                Selected = needs.Status != "FLED" && reader.GetBoolean(13),
                LastNeedsUpdateAt = now
            });
        }

        await reader.CloseAsync();
        foreach (var dragon in dragons)
        {
            await using var update = new MySqlCommand(
                """
                UPDATE GameDragons
                SET Life=@Life, Happiness=@Happiness, Hunger=@Hunger, Experience=@Experience,
                    Level=@Level, Stage=@Stage, Status=@Status, Selected=@Selected, LastNeedsUpdateAt=@Now
                WHERE Id=@Id;
                """,
                connection,
                transaction);
            update.Parameters.AddWithValue("@Life", dragon.Life);
            update.Parameters.AddWithValue("@Happiness", dragon.Happiness);
            update.Parameters.AddWithValue("@Hunger", dragon.Hunger);
            update.Parameters.AddWithValue("@Experience", dragon.Experience);
            update.Parameters.AddWithValue("@Level", dragon.Level);
            update.Parameters.AddWithValue("@Stage", dragon.Stage);
            update.Parameters.AddWithValue("@Status", dragon.Status);
            update.Parameters.AddWithValue("@Selected", dragon.Selected);
            update.Parameters.AddWithValue("@Now", now);
            update.Parameters.AddWithValue("@Id", dragon.Id);
            await update.ExecuteNonQueryAsync(cancellationToken);
        }

        await transaction.CommitAsync(cancellationToken);

        return dragons;
    }

    private static DateTime AsUtc(DateTime dateTime) =>
        DateTime.SpecifyKind(dateTime, DateTimeKind.Utc);
}
