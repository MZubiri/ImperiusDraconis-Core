using System.Data;
using System.Globalization;
using System.Security.Cryptography;
using System.Text;
using System.Text.Json;
using ImperiusDraconisAPI.Common;
using ImperiusDraconisAPI.Configuration;
using ImperiusDraconisAPI.Data;
using ImperiusDraconisAPI.Models.Game.Links;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Options;

namespace ImperiusDraconisAPI.Services.Game;

public sealed class GameLinkService
{
    private const string ConsumeOperation = "GAME_LINK_CONSUME";
    private const string LinkCodeAlphabet = "23456789ABCDEFGHJKLMNPQRSTUVWXYZ";
    private const int LinkCodeLength = 8;
    private static readonly JsonSerializerOptions WebJsonOptions = new(JsonSerializerDefaults.Web);
    private readonly SqlConnectionFactory _connectionFactory;
    private readonly DracoinGameService _dracoinGameService;
    private readonly GameIdempotencyService _idempotencyService;
    private readonly GameOptions _options;

    public GameLinkService(
        SqlConnectionFactory connectionFactory,
        GameIdempotencyService idempotencyService,
        DracoinGameService dracoinGameService,
        IOptions<GameOptions> options)
    {
        _connectionFactory = connectionFactory;
        _idempotencyService = idempotencyService;
        _dracoinGameService = dracoinGameService;
        _options = options.Value;

        if (_options.LinkCodeExpirationMinutes <= 0)
        {
            throw new InvalidOperationException("Game:LinkCodeExpirationMinutes debe ser mayor a cero.");
        }

        if (string.IsNullOrWhiteSpace(_options.LinkCodePepper))
        {
            throw new InvalidOperationException("Falta configurar Game:LinkCodePepper.");
        }

        if (_options.WelcomeDracoins <= 0)
        {
            throw new InvalidOperationException("Game:WelcomeDracoins debe ser mayor a cero.");
        }

        if (_options.BaseDragonSlots != 1)
        {
            throw new InvalidOperationException("Game:BaseDragonSlots debe ser igual a uno en el MVP.");
        }

        if (_options.MaxDragonCapacity is < 1 or > 10)
        {
            throw new InvalidOperationException("Game:MaxDragonCapacity debe estar entre uno y diez.");
        }
    }

    public async Task<CreateGameLinkCodeResponse> CreateLinkCodeAsync(
        int idAlumno,
        CancellationToken cancellationToken)
    {
        await using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);
        await using var transaction = (SqlTransaction)await connection.BeginTransactionAsync(
            IsolationLevel.Serializable,
            cancellationToken);

        try
        {
            var createdAt = DateTime.UtcNow;
            var expiresAt = createdAt.AddMinutes(_options.LinkCodeExpirationMinutes);
            var normalizedCode = GenerateNormalizedCode();
            var codeHash = ComputeCodeHash(normalizedCode);

            await RevokePreviousCodesAsync(connection, transaction, idAlumno, createdAt, cancellationToken);

            var alumnoState = await GetAlumnoStateAsync(connection, transaction, idAlumno, cancellationToken);
            if (!alumnoState.Exists || !alumnoState.Active)
            {
                throw new GameBusinessRuleException(
                    "PLAYER_INACTIVE",
                    "El jugador no existe o no se encuentra activo.");
            }

            if (alumnoState.HasActiveRobloxLink)
            {
                throw new GameBusinessRuleException(
                    "ALREADY_LINKED",
                    "El jugador ya tiene una cuenta Roblox vinculada.");
            }

            await InsertCodeAsync(
                connection,
                transaction,
                idAlumno,
                codeHash,
                createdAt,
                expiresAt,
                cancellationToken);

            await transaction.CommitAsync(cancellationToken);

            return new CreateGameLinkCodeResponse
            {
                Code = FormatCode(normalizedCode),
                ExpiresAt = expiresAt,
                ExpiresInSeconds = checked(_options.LinkCodeExpirationMinutes * 60)
            };
        }
        catch
        {
            await transaction.RollbackAsync(cancellationToken);
            throw;
        }
    }

    public async Task<ConsumeGameLinkCodeResponse> ConsumeAsync(
        ConsumeGameLinkCodeRequest request,
        string idempotencyKey,
        CancellationToken cancellationToken)
    {
        var normalizedCode = NormalizeCode(request.Code);
        if (!IsValidNormalizedCode(normalizedCode))
        {
            throw new GameBusinessRuleException(
                "INVALID_LINK_CODE",
                "El codigo de vinculacion no es valido.",
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

        var requestHash = ComputeRequestHash(normalizedCode, request.RobloxUserId);

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
                ConsumeOperation,
                normalizedIdempotencyKey,
                requestHash,
                cancellationToken);

            if (reservation.CompletedResponseJson is not null)
            {
                var previousResponse = JsonSerializer.Deserialize<ConsumeGameLinkCodeResponse>(
                    reservation.CompletedResponseJson,
                    WebJsonOptions)
                    ?? throw new InvalidOperationException("La respuesta idempotente almacenada no es valida.");

                await transaction.CommitAsync(cancellationToken);
                return previousResponse;
            }

            var databaseUtcNow = await GetDatabaseUtcNowAsync(connection, transaction, cancellationToken);
            var linkCode = await GetLinkCodeAsync(
                connection,
                transaction,
                ComputeCodeHash(normalizedCode),
                cancellationToken);

            ValidateLinkCode(linkCode, databaseUtcNow);

            var player = await GetPlayerForConsumeAsync(
                connection,
                transaction,
                linkCode!.IdAlumno,
                cancellationToken);
            if (player is null || !player.Active)
            {
                throw new GameBusinessRuleException(
                    "PLAYER_INACTIVE",
                    "El jugador no existe o no se encuentra activo.",
                    StatusCodes.Status403Forbidden);
            }

            if (await HasAlumnoLinkAsync(connection, transaction, player.IdAlumno, cancellationToken))
            {
                throw new GameBusinessRuleException(
                    "ALREADY_LINKED",
                    "El jugador ya tiene una cuenta Roblox vinculada.");
            }

            if (await HasRobloxLinkAsync(connection, transaction, request.RobloxUserId, cancellationToken))
            {
                throw new GameBusinessRuleException(
                    "ROBLOX_ALREADY_LINKED",
                    "La cuenta Roblox ya se encuentra vinculada.");
            }

            var gameRobloxLinkId = await InsertRobloxLinkAsync(
                connection,
                transaction,
                player.IdAlumno,
                request.RobloxUserId,
                databaseUtcNow,
                cancellationToken);
            await InsertDragonCapacityAsync(
                connection,
                transaction,
                player.IdAlumno,
                databaseUtcNow,
                cancellationToken);
            var balanceAfter = await _dracoinGameService.CreditWelcomeAsync(
                connection,
                transaction,
                player.IdAlumno,
                _options.WelcomeDracoins,
                gameRobloxLinkId,
                cancellationToken);
            await MarkCodeUsedAsync(
                connection,
                transaction,
                linkCode.Id,
                databaseUtcNow,
                cancellationToken);

            var response = new ConsumeGameLinkCodeResponse
            {
                IdAlumno = player.IdAlumno,
                RobloxUserId = request.RobloxUserId,
                DisplayName = player.DisplayName,
                HouseName = player.HouseName,
                WelcomeDracoins = _options.WelcomeDracoins,
                BalanceAfter = balanceAfter,
                BaseSlots = _options.BaseDragonSlots,
                PurchasedSlots = 0,
                TotalSlots = _options.BaseDragonSlots,
                MaxCapacity = _options.MaxDragonCapacity,
                LinkedAt = databaseUtcNow
            };

            var responseJson = JsonSerializer.Serialize(response, WebJsonOptions);
            await _idempotencyService.CompleteAsync(
                connection,
                transaction,
                reservation.Id,
                responseJson,
                cancellationToken);

            await transaction.CommitAsync(cancellationToken);
            return response;
        }
        catch
        {
            await transaction.RollbackAsync(cancellationToken);
            throw;
        }
    }

    private static async Task<AlumnoState> GetAlumnoStateAsync(
        SqlConnection connection,
        SqlTransaction transaction,
        int idAlumno,
        CancellationToken cancellationToken)
    {
        await using var command = new SqlCommand(
            """
            SELECT
                CONVERT(BIT, ISNULL(A.Activo, 0)) AS Active,
                CONVERT(BIT, CASE WHEN EXISTS
                (
                    SELECT 1
                    FROM dbo.GameRobloxLinks L WITH (UPDLOCK, HOLDLOCK)
                    WHERE L.IdAlumno = A.IdAlumno
                      AND L.Active = 1
                )
                THEN 1 ELSE 0 END) AS HasActiveRobloxLink
            FROM dbo.Alumnos A WITH (UPDLOCK, HOLDLOCK)
            WHERE A.IdAlumno = @IdAlumno;
            """,
            connection,
            transaction);
        command.Parameters.Add("@IdAlumno", SqlDbType.Int).Value = idAlumno;

        await using var reader = await command.ExecuteReaderAsync(cancellationToken);
        if (!await reader.ReadAsync(cancellationToken))
        {
            return new AlumnoState(false, false, false);
        }

        return new AlumnoState(
            true,
            reader.GetBoolean(0),
            reader.GetBoolean(1));
    }

    private static async Task RevokePreviousCodesAsync(
        SqlConnection connection,
        SqlTransaction transaction,
        int idAlumno,
        DateTime revokedAt,
        CancellationToken cancellationToken)
    {
        await using var command = new SqlCommand(
            """
            UPDATE dbo.GameLinkCodes
            SET RevokedAt = @RevokedAt
            WHERE IdAlumno = @IdAlumno
              AND UsedAt IS NULL
              AND RevokedAt IS NULL;
            """,
            connection,
            transaction);
        command.Parameters.Add("@IdAlumno", SqlDbType.Int).Value = idAlumno;
        command.Parameters.Add("@RevokedAt", SqlDbType.DateTime2).Value = revokedAt;

        await command.ExecuteNonQueryAsync(cancellationToken);
    }

    private static async Task InsertCodeAsync(
        SqlConnection connection,
        SqlTransaction transaction,
        int idAlumno,
        byte[] codeHash,
        DateTime createdAt,
        DateTime expiresAt,
        CancellationToken cancellationToken)
    {
        await using var command = new SqlCommand(
            """
            INSERT INTO dbo.GameLinkCodes
                (IdAlumno, CodeHash, ExpiresAt, CreatedAt)
            VALUES
                (@IdAlumno, @CodeHash, @ExpiresAt, @CreatedAt);
            """,
            connection,
            transaction);
        command.Parameters.Add("@IdAlumno", SqlDbType.Int).Value = idAlumno;
        command.Parameters.Add("@CodeHash", SqlDbType.Binary, 32).Value = codeHash;
        command.Parameters.Add("@ExpiresAt", SqlDbType.DateTime2).Value = expiresAt;
        command.Parameters.Add("@CreatedAt", SqlDbType.DateTime2).Value = createdAt;

        await command.ExecuteNonQueryAsync(cancellationToken);
    }

    private static async Task<DateTime> GetDatabaseUtcNowAsync(
        SqlConnection connection,
        SqlTransaction transaction,
        CancellationToken cancellationToken)
    {
        await using var command = new SqlCommand(
            "SELECT CONVERT(DATETIME2(3), SYSUTCDATETIME());",
            connection,
            transaction);
        var value = Convert.ToDateTime(
            await command.ExecuteScalarAsync(cancellationToken),
            CultureInfo.InvariantCulture);
        return DateTime.SpecifyKind(value, DateTimeKind.Utc);
    }

    private static async Task<LinkCodeState?> GetLinkCodeAsync(
        SqlConnection connection,
        SqlTransaction transaction,
        byte[] codeHash,
        CancellationToken cancellationToken)
    {
        await using var command = new SqlCommand(
            """
            SELECT TOP (1)
                Id,
                IdAlumno,
                ExpiresAt,
                UsedAt,
                RevokedAt
            FROM dbo.GameLinkCodes WITH (UPDLOCK, HOLDLOCK)
            WHERE CodeHash = @CodeHash
            ORDER BY CreatedAt DESC, Id DESC;
            """,
            connection,
            transaction);
        command.Parameters.Add("@CodeHash", SqlDbType.Binary, 32).Value = codeHash;

        await using var reader = await command.ExecuteReaderAsync(cancellationToken);
        if (!await reader.ReadAsync(cancellationToken))
        {
            return null;
        }

        return new LinkCodeState(
            reader.GetInt64(0),
            reader.GetInt32(1),
            reader.GetDateTime(2),
            reader.IsDBNull(3) ? null : reader.GetDateTime(3),
            reader.IsDBNull(4) ? null : reader.GetDateTime(4));
    }

    private static void ValidateLinkCode(LinkCodeState? linkCode, DateTime databaseUtcNow)
    {
        if (linkCode is null)
        {
            throw new GameBusinessRuleException(
                "INVALID_LINK_CODE",
                "El codigo de vinculacion no es valido.",
                StatusCodes.Status400BadRequest);
        }

        if (linkCode.UsedAt.HasValue)
        {
            throw new GameBusinessRuleException(
                "LINK_CODE_USED",
                "El codigo de vinculacion ya fue utilizado.");
        }

        if (linkCode.RevokedAt.HasValue)
        {
            throw new GameBusinessRuleException(
                "LINK_CODE_REVOKED",
                "El codigo de vinculacion fue revocado.");
        }

        if (linkCode.ExpiresAt <= databaseUtcNow)
        {
            throw new GameBusinessRuleException(
                "LINK_CODE_EXPIRED",
                "El codigo de vinculacion ha expirado.");
        }
    }

    private static async Task<PlayerState?> GetPlayerForConsumeAsync(
        SqlConnection connection,
        SqlTransaction transaction,
        int idAlumno,
        CancellationToken cancellationToken)
    {
        await using var command = new SqlCommand(
            """
            SELECT
                A.IdAlumno,
                A.Nombre,
                ISNULL(C.Nombre, N'') AS HouseName,
                CONVERT(BIT, ISNULL(A.Activo, 0)) AS Active
            FROM dbo.Alumnos A WITH (UPDLOCK, HOLDLOCK)
            LEFT JOIN dbo.Casas C ON C.IdCasa = A.IdCasa
            WHERE A.IdAlumno = @IdAlumno;
            """,
            connection,
            transaction);
        command.Parameters.Add("@IdAlumno", SqlDbType.Int).Value = idAlumno;

        await using var reader = await command.ExecuteReaderAsync(cancellationToken);
        if (!await reader.ReadAsync(cancellationToken))
        {
            return null;
        }

        return new PlayerState(
            reader.GetInt32(0),
            reader.GetString(1),
            reader.GetString(2),
            reader.GetBoolean(3));
    }

    private static async Task<bool> HasAlumnoLinkAsync(
        SqlConnection connection,
        SqlTransaction transaction,
        int idAlumno,
        CancellationToken cancellationToken)
    {
        await using var command = new SqlCommand(
            """
            SELECT TOP (1) 1
            FROM dbo.GameRobloxLinks WITH (UPDLOCK, HOLDLOCK)
            WHERE IdAlumno = @IdAlumno;
            """,
            connection,
            transaction);
        command.Parameters.Add("@IdAlumno", SqlDbType.Int).Value = idAlumno;
        return await command.ExecuteScalarAsync(cancellationToken) is not null;
    }

    private static async Task<bool> HasRobloxLinkAsync(
        SqlConnection connection,
        SqlTransaction transaction,
        long robloxUserId,
        CancellationToken cancellationToken)
    {
        await using var command = new SqlCommand(
            """
            SELECT TOP (1) 1
            FROM dbo.GameRobloxLinks WITH (UPDLOCK, HOLDLOCK)
            WHERE RobloxUserId = @RobloxUserId;
            """,
            connection,
            transaction);
        command.Parameters.Add("@RobloxUserId", SqlDbType.BigInt).Value = robloxUserId;
        return await command.ExecuteScalarAsync(cancellationToken) is not null;
    }

    private static async Task<long> InsertRobloxLinkAsync(
        SqlConnection connection,
        SqlTransaction transaction,
        int idAlumno,
        long robloxUserId,
        DateTime linkedAt,
        CancellationToken cancellationToken)
    {
        await using var command = new SqlCommand(
            """
            INSERT INTO dbo.GameRobloxLinks
                (IdAlumno, RobloxUserId, LinkedAt, Active)
            OUTPUT INSERTED.Id
            VALUES
                (@IdAlumno, @RobloxUserId, @LinkedAt, 1);
            """,
            connection,
            transaction);
        command.Parameters.Add("@IdAlumno", SqlDbType.Int).Value = idAlumno;
        command.Parameters.Add("@RobloxUserId", SqlDbType.BigInt).Value = robloxUserId;
        command.Parameters.Add("@LinkedAt", SqlDbType.DateTime2).Value = linkedAt;
        return Convert.ToInt64(await command.ExecuteScalarAsync(cancellationToken), CultureInfo.InvariantCulture);
    }

    private async Task InsertDragonCapacityAsync(
        SqlConnection connection,
        SqlTransaction transaction,
        int idAlumno,
        DateTime updatedAt,
        CancellationToken cancellationToken)
    {
        await using var command = new SqlCommand(
            """
            INSERT INTO dbo.GameDragonCapacity
                (IdAlumno, PurchasedSlots, MaxCapacity, UpdatedAt)
            VALUES
                (@IdAlumno, 0, @MaxCapacity, @UpdatedAt);
            """,
            connection,
            transaction);
        command.Parameters.Add("@IdAlumno", SqlDbType.Int).Value = idAlumno;
        command.Parameters.Add("@MaxCapacity", SqlDbType.TinyInt).Value = _options.MaxDragonCapacity;
        command.Parameters.Add("@UpdatedAt", SqlDbType.DateTime2).Value = updatedAt;
        await command.ExecuteNonQueryAsync(cancellationToken);
    }

    private static async Task MarkCodeUsedAsync(
        SqlConnection connection,
        SqlTransaction transaction,
        long linkCodeId,
        DateTime usedAt,
        CancellationToken cancellationToken)
    {
        await using var command = new SqlCommand(
            """
            UPDATE dbo.GameLinkCodes
            SET UsedAt = @UsedAt
            WHERE Id = @Id
              AND UsedAt IS NULL
              AND RevokedAt IS NULL
              AND ExpiresAt > @UsedAt;
            """,
            connection,
            transaction);
        command.Parameters.Add("@Id", SqlDbType.BigInt).Value = linkCodeId;
        command.Parameters.Add("@UsedAt", SqlDbType.DateTime2).Value = usedAt;

        if (await command.ExecuteNonQueryAsync(cancellationToken) != 1)
        {
            throw new GameBusinessRuleException(
                "INVALID_LINK_CODE",
                "El codigo de vinculacion ya no se encuentra disponible.");
        }
    }

    private byte[] ComputeCodeHash(string normalizedCode)
    {
        using var hmac = new HMACSHA256(Encoding.UTF8.GetBytes(_options.LinkCodePepper));
        return hmac.ComputeHash(Encoding.UTF8.GetBytes(normalizedCode));
    }

    private static string GenerateNormalizedCode()
    {
        Span<char> code = stackalloc char[LinkCodeLength];
        for (var index = 0; index < code.Length; index++)
        {
            code[index] = LinkCodeAlphabet[RandomNumberGenerator.GetInt32(LinkCodeAlphabet.Length)];
        }

        return new string(code);
    }

    private static string FormatCode(string normalizedCode) =>
        $"{normalizedCode[..4]}-{normalizedCode[4..]}";

    private static string NormalizeCode(string? code) =>
        new((code ?? string.Empty)
            .Where(character => !char.IsWhiteSpace(character) && character != '-')
            .Select(char.ToUpperInvariant)
            .ToArray());

    private static bool IsValidNormalizedCode(string normalizedCode) =>
        normalizedCode.Length == LinkCodeLength
        && normalizedCode.All(LinkCodeAlphabet.Contains);

    private static byte[] ComputeRequestHash(string normalizedCode, long robloxUserId)
    {
        var normalizedPayload = $"{normalizedCode}:{robloxUserId.ToString(CultureInfo.InvariantCulture)}";
        return SHA256.HashData(Encoding.UTF8.GetBytes(normalizedPayload));
    }

    private sealed record AlumnoState(bool Exists, bool Active, bool HasActiveRobloxLink);

    private sealed record LinkCodeState(
        long Id,
        int IdAlumno,
        DateTime ExpiresAt,
        DateTime? UsedAt,
        DateTime? RevokedAt);

    private sealed record PlayerState(int IdAlumno, string DisplayName, string HouseName, bool Active);
}
