using System.Data;
using System.Security.Cryptography;
using System.Text;
using ImperiusDraconisAPI.Common;
using ImperiusDraconisAPI.Configuration;
using ImperiusDraconisAPI.Data;
using ImperiusDraconisAPI.Models.Game.Links;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Options;

namespace ImperiusDraconisAPI.Services.Game;

public sealed class GameLinkService
{
    private const string LinkCodeAlphabet = "23456789ABCDEFGHJKLMNPQRSTUVWXYZ";
    private const int LinkCodeLength = 8;
    private readonly SqlConnectionFactory _connectionFactory;
    private readonly GameOptions _options;

    public GameLinkService(SqlConnectionFactory connectionFactory, IOptions<GameOptions> options)
    {
        _connectionFactory = connectionFactory;
        _options = options.Value;

        if (_options.LinkCodeExpirationMinutes <= 0)
        {
            throw new InvalidOperationException("Game:LinkCodeExpirationMinutes debe ser mayor a cero.");
        }

        if (string.IsNullOrWhiteSpace(_options.LinkCodePepper))
        {
            throw new InvalidOperationException("Falta configurar Game:LinkCodePepper.");
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

            var createdAt = DateTime.UtcNow;
            var expiresAt = createdAt.AddMinutes(_options.LinkCodeExpirationMinutes);
            var normalizedCode = GenerateNormalizedCode();
            var codeHash = ComputeCodeHash(normalizedCode);

            await RevokePreviousCodesAsync(connection, transaction, idAlumno, createdAt, cancellationToken);
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

    private sealed record AlumnoState(bool Exists, bool Active, bool HasActiveRobloxLink);
}
