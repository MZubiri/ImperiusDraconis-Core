using System.Data;
using ImperiusDraconisAPI.Common;
using ImperiusDraconisAPI.Data;
using ImperiusDraconisAPI.Models.Game.Eggs;
using Microsoft.Data.SqlClient;

namespace ImperiusDraconisAPI.Services.Game;

public sealed class GameEggService
{
    private readonly SqlConnectionFactory _connectionFactory;

    public GameEggService(SqlConnectionFactory connectionFactory)
    {
        _connectionFactory = connectionFactory;
    }

    public async Task<GameEgg> CreateAsync(CreateGameEggCommand request, CancellationToken cancellationToken)
    {
        if (request.IdAlumno <= 0)
        {
            throw Invalid("IdAlumno debe ser mayor a cero.");
        }

        var rarity = GameEggRules.NormalizeRarity(request.Rarity);

        await using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);
        await using var transaction = (SqlTransaction)await connection.BeginTransactionAsync(
            IsolationLevel.Serializable,
            cancellationToken);

        try
        {
            await ValidateAvailableCapacityAsync(connection, transaction, request.IdAlumno, cancellationToken);

            await using var command = new SqlCommand(
                """
                INSERT INTO dbo.GameEggs (IdAlumno, Rarity)
                OUTPUT
                    INSERTED.Id,
                    INSERTED.IdAlumno,
                    INSERTED.Rarity,
                    INSERTED.AcquiredAt,
                    INSERTED.IncubationStartedAt,
                    INSERTED.IncubationEndsAt,
                    INSERTED.Status
                VALUES (@IdAlumno, @Rarity);
                """,
                connection,
                transaction);
            command.Parameters.Add("@IdAlumno", SqlDbType.Int).Value = request.IdAlumno;
            command.Parameters.Add("@Rarity", SqlDbType.NVarChar, 20).Value = rarity;

            await using var reader = await command.ExecuteReaderAsync(cancellationToken);
            await reader.ReadAsync(cancellationToken);
            var egg = ReadEgg(reader, DateTime.UtcNow);
            await reader.CloseAsync();
            await transaction.CommitAsync(cancellationToken);
            return egg;
        }
        catch
        {
            await transaction.RollbackAsync(cancellationToken);
            throw;
        }
    }

    public async Task<GameEgg?> GetByIdAsync(long id, CancellationToken cancellationToken)
    {
        if (id <= 0)
        {
            throw Invalid("El identificador del huevo debe ser mayor a cero.");
        }

        await using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);
        await using var command = CreateSelectCommand(
            connection,
            "WHERE Id = @Id;");
        command.Parameters.Add("@Id", SqlDbType.BigInt).Value = id;

        await using var reader = await command.ExecuteReaderAsync(cancellationToken);
        return await reader.ReadAsync(cancellationToken)
            ? ReadEgg(reader, DateTime.UtcNow)
            : null;
    }

    public async Task<IReadOnlyCollection<GameEgg>> ListByPlayerAsync(
        int idAlumno,
        CancellationToken cancellationToken)
    {
        if (idAlumno <= 0)
        {
            throw Invalid("IdAlumno debe ser mayor a cero.");
        }

        await using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);
        await using var command = CreateSelectCommand(
            connection,
            "WHERE IdAlumno = @IdAlumno ORDER BY AcquiredAt, Id;");
        command.Parameters.Add("@IdAlumno", SqlDbType.Int).Value = idAlumno;

        var utcNow = DateTime.UtcNow;
        var eggs = new List<GameEgg>();
        await using var reader = await command.ExecuteReaderAsync(cancellationToken);
        while (await reader.ReadAsync(cancellationToken))
        {
            eggs.Add(ReadEgg(reader, utcNow));
        }

        return eggs;
    }

    public async Task<GameEgg> UpdateAsync(
        long id,
        UpdateGameEggCommand request,
        CancellationToken cancellationToken)
    {
        var existing = await GetByIdAsync(id, cancellationToken)
            ?? throw new GameBusinessRuleException(
                "EGG_NOT_FOUND",
                "El huevo no existe.",
                StatusCodes.Status404NotFound);
        var status = GameEggRules.NormalizeStatus(request.Status);
        if (status == "HATCHED")
        {
            throw new GameBusinessRuleException(
                "HATCH_NOT_IMPLEMENTED",
                "La eclosion de huevos aun no esta implementada.");
        }

        if (existing.Status == "HATCHED")
        {
            throw new GameBusinessRuleException(
                "EGG_NOT_EDITABLE",
                "Un huevo eclosionado no puede modificarse.");
        }

        GameEggRules.ValidateState(
            status,
            existing.AcquiredAt,
            request.IncubationStartedAt,
            request.IncubationEndsAt);
        GameEggRules.ValidateTransition(
            existing.Status,
            status,
            request.IncubationEndsAt,
            DateTime.UtcNow);

        await using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);
        await using var command = new SqlCommand(
            """
            UPDATE dbo.GameEggs
            SET
                IncubationStartedAt = @IncubationStartedAt,
                IncubationEndsAt = @IncubationEndsAt,
                Status = @Status,
                UpdatedAt = SYSUTCDATETIME()
            OUTPUT
                INSERTED.Id,
                INSERTED.IdAlumno,
                INSERTED.Rarity,
                INSERTED.AcquiredAt,
                INSERTED.IncubationStartedAt,
                INSERTED.IncubationEndsAt,
                INSERTED.Status
            WHERE Id = @Id;
            """,
            connection);
        command.Parameters.Add("@Id", SqlDbType.BigInt).Value = id;
        command.Parameters.Add("@IncubationStartedAt", SqlDbType.DateTime2).Value =
            (object?)request.IncubationStartedAt ?? DBNull.Value;
        command.Parameters.Add("@IncubationEndsAt", SqlDbType.DateTime2).Value =
            (object?)request.IncubationEndsAt ?? DBNull.Value;
        command.Parameters.Add("@Status", SqlDbType.NVarChar, 20).Value = status;

        await using var reader = await command.ExecuteReaderAsync(cancellationToken);
        if (!await reader.ReadAsync(cancellationToken))
        {
            throw new GameBusinessRuleException(
                "EGG_NOT_FOUND",
                "El huevo no existe.",
                StatusCodes.Status404NotFound);
        }

        return ReadEgg(reader, DateTime.UtcNow);
    }

    public async Task DeleteAsync(long id, CancellationToken cancellationToken)
    {
        if (id <= 0)
        {
            throw Invalid("El identificador del huevo debe ser mayor a cero.");
        }

        await using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);
        await using var command = new SqlCommand(
            "DELETE FROM dbo.GameEggs WHERE Id = @Id AND Status = N'OWNED';",
            connection);
        command.Parameters.Add("@Id", SqlDbType.BigInt).Value = id;

        if (await command.ExecuteNonQueryAsync(cancellationToken) == 0)
        {
            throw new GameBusinessRuleException(
                "EGG_NOT_DELETABLE",
                "El huevo no existe o ya inicio su incubacion.");
        }
    }

    private static SqlCommand CreateSelectCommand(SqlConnection connection, string whereClause)
    {
        return new SqlCommand(
            $"""
            SELECT
                Id,
                IdAlumno,
                Rarity,
                AcquiredAt,
                IncubationStartedAt,
                IncubationEndsAt,
                Status
            FROM dbo.GameEggs
            {whereClause}
            """,
            connection);
    }

    private static GameEgg ReadEgg(SqlDataReader reader, DateTime utcNow)
    {
        DateTime? incubationEndsAt = reader.IsDBNull(5) ? null : AsUtc(reader.GetDateTime(5));
        var persistedStatus = reader.GetString(6);

        return new GameEgg
        {
            Id = reader.GetInt64(0),
            IdAlumno = reader.GetInt32(1),
            Rarity = reader.GetString(2),
            AcquiredAt = AsUtc(reader.GetDateTime(3)),
            IncubationStartedAt = reader.IsDBNull(4) ? null : AsUtc(reader.GetDateTime(4)),
            IncubationEndsAt = incubationEndsAt,
            Status = GameEggRules.GetEffectiveStatus(persistedStatus, incubationEndsAt, utcNow)
        };
    }

    private static DateTime AsUtc(DateTime value) => DateTime.SpecifyKind(value, DateTimeKind.Utc);

    private static async Task ValidateAvailableCapacityAsync(
        SqlConnection connection,
        SqlTransaction transaction,
        int idAlumno,
        CancellationToken cancellationToken)
    {
        await using var command = new SqlCommand(
            """
            SELECT
                CONVERT(BIT, ISNULL(A.Activo, 0)) AS Active,
                DC.PurchasedSlots,
                DC.MaxCapacity,
                (
                    SELECT COUNT_BIG(*)
                    FROM dbo.GameEggs E WITH (UPDLOCK, HOLDLOCK)
                    WHERE E.IdAlumno = A.IdAlumno
                      AND E.Status <> N'HATCHED'
                ) AS OccupiedSlots
            FROM dbo.Alumnos A WITH (UPDLOCK, HOLDLOCK)
            LEFT JOIN dbo.GameDragonCapacity DC WITH (UPDLOCK, HOLDLOCK)
                ON DC.IdAlumno = A.IdAlumno
            WHERE A.IdAlumno = @IdAlumno;
            """,
            connection,
            transaction);
        command.Parameters.Add("@IdAlumno", SqlDbType.Int).Value = idAlumno;

        await using var reader = await command.ExecuteReaderAsync(cancellationToken);
        if (!await reader.ReadAsync(cancellationToken) || !reader.GetBoolean(0))
        {
            throw new GameBusinessRuleException(
                "PLAYER_INACTIVE",
                "El jugador no existe o no se encuentra activo.",
                StatusCodes.Status403Forbidden);
        }

        if (reader.IsDBNull(1) || reader.IsDBNull(2))
        {
            throw new GameBusinessRuleException(
                "PLAYER_DATA_INCOMPLETE",
                "La capacidad del jugador no se encuentra inicializada.",
                StatusCodes.Status500InternalServerError);
        }

        var totalSlots = 1 + reader.GetByte(1);
        var maxCapacity = reader.GetByte(2);
        var occupiedSlots = reader.GetInt64(3);
        if (occupiedSlots >= Math.Min(totalSlots, maxCapacity))
        {
            throw new GameBusinessRuleException(
                "DRAGON_CAPACITY_FULL",
                "El jugador no tiene espacios disponibles para otro huevo.");
        }
    }

    private static GameBusinessRuleException Invalid(string message)
    {
        return new GameBusinessRuleException(
            "INVALID_EGG_STATE",
            message,
            StatusCodes.Status400BadRequest);
    }
}
