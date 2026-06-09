using System.Data;
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
    private readonly GameOptions _options;

    public GamePlayerService(SqlConnectionFactory connectionFactory, IOptions<GameOptions> options)
    {
        _connectionFactory = connectionFactory;
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

        if (!reader.GetBoolean(4))
        {
            throw new GameBusinessRuleException(
                "PLAYER_INACTIVE",
                "El jugador vinculado no se encuentra activo.",
                StatusCodes.Status403Forbidden);
        }

        if (reader.IsDBNull(5) || reader.IsDBNull(6))
        {
            throw new GameBusinessRuleException(
                "PLAYER_DATA_INCOMPLETE",
                "La capacidad del jugador vinculado no se encuentra inicializada.",
                StatusCodes.Status500InternalServerError);
        }

        return GamePlayerBootstrapMapper.Map(
            _options.Version,
            _options.BaseDragonSlots,
            reader.GetInt64(0),
            reader.GetString(1),
            reader.GetString(2),
            reader.GetDecimal(3),
            reader.GetByte(5),
            reader.GetByte(6));
    }
}
