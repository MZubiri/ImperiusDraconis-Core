using System.Data;
using System.Security.Cryptography;
using System.Text;
using System.Text.Json;
using Microsoft.AspNetCore.Http;
using ImperiusDraconisAPI.Common;
using ImperiusDraconisAPI.Data;
using ImperiusDraconisAPI.Models.Game.Dragons;
using ImperiusDraconisAPI.Models.Game.Players;
using Microsoft.Data.SqlClient;

namespace ImperiusDraconisAPI.Services.Game;

public sealed class GameDragonService
{
    private readonly SqlConnectionFactory _connectionFactory;
    private readonly GameIdempotencyService _idempotencyService;

    public GameDragonService(
        SqlConnectionFactory connectionFactory,
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
        await using var transaction = (SqlTransaction)await connection.BeginTransactionAsync(
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
            await using var linkCommand = new SqlCommand(
                """
                SELECT L.IdAlumno, CONVERT(BIT, ISNULL(A.Activo, 0))
                FROM dbo.GameRobloxLinks L
                INNER JOIN dbo.Alumnos A ON A.IdAlumno = L.IdAlumno
                WHERE L.RobloxUserId = @RobloxUserId AND L.Active = 1;
                """,
                connection,
                transaction);
            linkCommand.Parameters.Add("@RobloxUserId", SqlDbType.BigInt).Value = request.RobloxUserId;

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
            await using var dragonCommand = new SqlCommand(
                """
                SELECT IdAlumno, Status, Selected
                FROM dbo.GameDragons WITH (UPDLOCK, HOLDLOCK)
                WHERE Id = @Id;
                """,
                connection,
                transaction);
            dragonCommand.Parameters.Add("@Id", SqlDbType.BigInt).Value = dragonId;

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
                await using var deselectCommand = new SqlCommand(
                    """
                    UPDATE dbo.GameDragons
                    SET Selected = 0
                    WHERE IdAlumno = @IdAlumno AND Selected = 1;
                    """,
                    connection,
                    transaction);
                deselectCommand.Parameters.Add("@IdAlumno", SqlDbType.Int).Value = callerIdAlumno;
                await deselectCommand.ExecuteNonQueryAsync(cancellationToken);

                // Seleccionar el dragon objetivo
                await using var selectCommand = new SqlCommand(
                    """
                    UPDATE dbo.GameDragons
                    SET Selected = 1
                    WHERE Id = @Id;
                    """,
                    connection,
                    transaction);
                selectCommand.Parameters.Add("@Id", SqlDbType.BigInt).Value = dragonId;
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
        await using var command = new SqlCommand(
            """
            SELECT 
                D.Id,
                D.Name,
                D.Rarity,
                D.Temperament,
                ISNULL(E.EggDefinitionCode, N'') AS SpeciesCode,
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
            FROM dbo.GameDragons D
            LEFT JOIN dbo.GameEggs E ON E.HatchedDragonId = D.Id
            WHERE D.IdAlumno = @IdAlumno
            ORDER BY D.HatchedAt, D.Id;
            """,
            connection);
        command.Parameters.Add("@IdAlumno", SqlDbType.Int).Value = idAlumno;

        var dragons = new List<GameBootstrapDragonDto>();
        await using var reader = await command.ExecuteReaderAsync(cancellationToken);
        while (await reader.ReadAsync(cancellationToken))
        {
            dragons.Add(new GameBootstrapDragonDto
            {
                Id = reader.GetInt64(0),
                Name = reader.GetString(1),
                Rarity = reader.GetString(2),
                Temperament = reader.GetString(3),
                SpeciesCode = reader.GetString(4),
                Level = reader.GetInt32(5),
                Stage = reader.GetString(6),
                HatchedAt = AsUtc(reader.GetDateTime(7)),
                Life = reader.GetInt32(8),
                Happiness = reader.GetInt32(9),
                Hunger = reader.GetInt32(10),
                Experience = reader.GetInt32(11),
                Status = reader.GetString(12),
                Selected = reader.GetBoolean(13),
                LastNeedsUpdateAt = AsUtc(reader.GetDateTime(14))
            });
        }

        return dragons;
    }

    private static DateTime AsUtc(DateTime dateTime) =>
        DateTime.SpecifyKind(dateTime, DateTimeKind.Utc);
}

