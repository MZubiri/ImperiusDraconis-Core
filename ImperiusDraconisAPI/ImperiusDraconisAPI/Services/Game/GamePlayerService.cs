using System.Data;
using System.Security.Cryptography;
using System.Text;
using System.Globalization;
using System.Text.Json;
using Microsoft.AspNetCore.Http;
using ImperiusDraconisAPI.Common;
using ImperiusDraconisAPI.Configuration;
using ImperiusDraconisAPI.Data;
using ImperiusDraconisAPI.Models.Game.Players;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Options;

namespace ImperiusDraconisAPI.Services.Game;

public sealed class GamePlayerService
{
    private readonly SqlConnectionFactory _connectionFactory;
    private readonly GameEggService _gameEggService;
    private readonly GameIdempotencyService _idempotencyService;
    private readonly DracoinGameService _dracoinGameService;
    private readonly GameOptions _options;

    public GamePlayerService(
        SqlConnectionFactory connectionFactory,
        GameEggService gameEggService,
        GameIdempotencyService idempotencyService,
        DracoinGameService dracoinGameService,
        IOptions<GameOptions> options)
    {
        _connectionFactory = connectionFactory;
        _gameEggService = gameEggService;
        _idempotencyService = idempotencyService;
        _dracoinGameService = dracoinGameService;
        _options = options.Value;

        if (string.IsNullOrWhiteSpace(_options.Version))
        {
            throw new InvalidOperationException("Falta configurar Game:Version.");
        }

        if (_options.BaseDragonSlots != 1)
        {
            throw new InvalidOperationException("Game:BaseDragonSlots debe ser igual a uno en el MVP.");
        }
    }

    public async Task<GamePlayerBootstrapResponse> GetBootstrapAsync(
        long robloxUserId,
        CancellationToken cancellationToken)
    {
        if (robloxUserId <= 0)
        {
            throw new GameBusinessRuleException(
                "BUSINESS_RULE_ERROR",
                "RobloxUserId debe ser mayor a cero.",
                StatusCodes.Status400BadRequest);
        }

        await using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        await using var command = new SqlCommand(
            """
            SELECT
                L.IdAlumno,
                L.RobloxUserId,
                A.Nombre AS DisplayName,
                ISNULL(C.Nombre, N'') AS HouseName,
                ISNULL(A.Dracoins, 0) AS Dracoins,
                CONVERT(BIT, ISNULL(A.Activo, 0)) AS Active,
                DC.PurchasedSlots,
                DC.MaxCapacity
            FROM dbo.GameRobloxLinks L
            INNER JOIN dbo.Alumnos A ON A.IdAlumno = L.IdAlumno
            LEFT JOIN dbo.Casas C ON C.IdCasa = A.IdCasa
            LEFT JOIN dbo.GameDragonCapacity DC ON DC.IdAlumno = A.IdAlumno
            WHERE L.RobloxUserId = @RobloxUserId
              AND L.Active = 1;
            """,
            connection);
        command.Parameters.Add("@RobloxUserId", SqlDbType.BigInt).Value = robloxUserId;

        await using var reader = await command.ExecuteReaderAsync(cancellationToken);
        if (!await reader.ReadAsync(cancellationToken))
        {
            throw new GameBusinessRuleException(
                "NOT_LINKED",
                "La cuenta Roblox no se encuentra vinculada.",
                StatusCodes.Status404NotFound);
        }

        if (!reader.GetBoolean(5))
        {
            throw new GameBusinessRuleException(
                "PLAYER_INACTIVE",
                "El jugador vinculado no se encuentra activo.",
                StatusCodes.Status403Forbidden);
        }

        if (reader.IsDBNull(6) || reader.IsDBNull(7))
        {
            throw new GameBusinessRuleException(
                "PLAYER_DATA_INCOMPLETE",
                "La capacidad del jugador vinculado no se encuentra inicializada.",
                StatusCodes.Status500InternalServerError);
        }

        var idAlumno = reader.GetInt32(0);
        var robloxId = reader.GetInt64(1);
        var displayName = reader.GetString(2);
        var houseName = reader.GetString(3);
        var dracoins = reader.GetDecimal(4);
        var purchasedSlots = reader.GetByte(6);
        var maxCapacity = reader.GetByte(7);
        await reader.CloseAsync();

        var eggs = await _gameEggService.ListByPlayerAsync(idAlumno, cancellationToken);

        return GamePlayerBootstrapMapper.Map(
            _options.Version,
            _options.BaseDragonSlots,
            robloxId,
            displayName,
            houseName,
            dracoins,
            purchasedSlots,
            maxCapacity,
            eggs);
    }

    public async Task<PurchaseDragonCapacityResponse> PurchaseCapacityAsync(
        long robloxUserId,
        string idempotencyKey,
        CancellationToken cancellationToken)
    {
        if (robloxUserId <= 0)
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

        var payload = robloxUserId.ToString(CultureInfo.InvariantCulture);
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
                "GAME_DRAGON_CAPACITY_PURCHASE",
                normalizedIdempotencyKey,
                requestHash,
                cancellationToken);

            if (reservation.CompletedResponseJson is not null)
            {
                var previousResponse = JsonSerializer.Deserialize<PurchaseDragonCapacityResponse>(
                    reservation.CompletedResponseJson,
                    new JsonSerializerOptions(JsonSerializerDefaults.Web))
                    ?? throw new InvalidOperationException("La respuesta idempotente almacenada no es valida.");

                await transaction.CommitAsync(cancellationToken);
                return previousResponse;
            }

            // 1. Obtener datos de capacidad y vinculacion
            await using var capCommand = new SqlCommand(
                """
                SELECT
                    L.IdAlumno,
                    CONVERT(BIT, ISNULL(A.Activo, 0)) AS Active,
                    DC.PurchasedSlots,
                    DC.MaxCapacity
                FROM dbo.GameRobloxLinks L WITH (UPDLOCK, HOLDLOCK)
                INNER JOIN dbo.Alumnos A WITH (UPDLOCK, HOLDLOCK) ON A.IdAlumno = L.IdAlumno
                LEFT JOIN dbo.GameDragonCapacity DC WITH (UPDLOCK, HOLDLOCK) ON DC.IdAlumno = A.IdAlumno
                WHERE L.RobloxUserId = @RobloxUserId AND L.Active = 1;
                """,
                connection,
                transaction);
            capCommand.Parameters.Add("@RobloxUserId", SqlDbType.BigInt).Value = robloxUserId;

            int idAlumno;
            byte purchasedSlots;
            byte maxCapacity;

            await using (var reader = await capCommand.ExecuteReaderAsync(cancellationToken))
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

                if (reader.IsDBNull(2) || reader.IsDBNull(3))
                {
                    throw new GameBusinessRuleException(
                        "PLAYER_DATA_INCOMPLETE",
                        "La capacidad del jugador no se encuentra inicializada.",
                        StatusCodes.Status500InternalServerError);
                }

                idAlumno = reader.GetInt32(0);
                purchasedSlots = reader.GetByte(2);
                maxCapacity = reader.GetByte(3);
            }

            // 2. Comprobar si ya se alcanzo el maximo
            var totalSlots = 1 + purchasedSlots;
            if (totalSlots >= maxCapacity)
            {
                throw new GameBusinessRuleException(
                    "CAPACITY_LIMIT_REACHED",
                    "El jugador ha alcanzado la capacidad máxima de dragones permitida.",
                    StatusCodes.Status400BadRequest);
            }

            // 3. Calcular costo
            var price = _options.BaseSlotPrice * (purchasedSlots + 1);

            // 4. Descontar saldo y registrar en ledger
            var balanceAfter = await _dracoinGameService.UpdateBalanceAsync(
                connection,
                transaction,
                idAlumno,
                -price,
                "CAPACITY_PURCHASE",
                "GAME_CAPACITY",
                (purchasedSlots + 1).ToString(CultureInfo.InvariantCulture),
                cancellationToken);

            // 5. Incrementar PurchasedSlots
            await using var updateCommand = new SqlCommand(
                """
                UPDATE dbo.GameDragonCapacity
                SET PurchasedSlots = PurchasedSlots + 1,
                    UpdatedAt = SYSUTCDATETIME()
                WHERE IdAlumno = @IdAlumno;
                """,
                connection,
                transaction);
            updateCommand.Parameters.Add("@IdAlumno", SqlDbType.Int).Value = idAlumno;
            await updateCommand.ExecuteNonQueryAsync(cancellationToken);

            var response = new PurchaseDragonCapacityResponse
            {
                RobloxUserId = robloxUserId,
                PurchasedSlots = purchasedSlots + 1,
                MaxCapacity = maxCapacity,
                PricePaid = price,
                BalanceAfter = balanceAfter
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
}
