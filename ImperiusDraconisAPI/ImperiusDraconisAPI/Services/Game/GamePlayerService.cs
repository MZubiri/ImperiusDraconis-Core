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
    private readonly GameEggService _gameEggService;
    private readonly GameOptions _options;

    public GamePlayerService(
        SqlConnectionFactory connectionFactory,
        GameEggService gameEggService,
        IOptions<GameOptions> options)
    {
        _connectionFactory = connectionFactory;
        _gameEggService = gameEggService;
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
}
