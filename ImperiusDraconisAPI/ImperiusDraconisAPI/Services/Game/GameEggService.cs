using System.Data;
using System.Security.Cryptography;
using System.Text;
using System.Globalization;
using System.Text.Json;
using Microsoft.AspNetCore.Http;
using ImperiusDraconisAPI.Common;
using ImperiusDraconisAPI.Data;
using ImperiusDraconisAPI.Models.Game.Eggs;
using ImperiusDraconisAPI.Models.Game.Dragons;
using Microsoft.Data.SqlClient;

namespace ImperiusDraconisAPI.Services.Game;

public sealed class GameEggService
{
    private static readonly string[] Temperaments = ["NOBLE", "AGRESIVO", "JUGUETON", "CURIOSO", "PEREZOSO"];

    private readonly SqlConnectionFactory _connectionFactory;
    private readonly GameIdempotencyService _idempotencyService;
    private readonly DracoinGameService _dracoinGameService;

    public GameEggService(
        SqlConnectionFactory connectionFactory,
        GameIdempotencyService idempotencyService,
        DracoinGameService dracoinGameService)
    {
        _connectionFactory = connectionFactory;
        _idempotencyService = idempotencyService;
        _dracoinGameService = dracoinGameService;
    }

    public async Task<GameEgg> CreateAsync(CreateGameEggCommand request, CancellationToken cancellationToken)
    {
        if (request.IdAlumno <= 0)
        {
            throw Invalid("IdAlumno debe ser mayor a cero.");
        }

        var definitionCode = GameEggRules.NormalizeDefinitionCode(request.EggDefinitionCode);
        var rarity = GameEggRules.NormalizeRarity(request.Rarity);

        await using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);
        await using var transaction = (SqlTransaction)await connection.BeginTransactionAsync(
            IsolationLevel.Serializable,
            cancellationToken);

        try
        {
            // Validar definicion de huevo
            await using var defCommand = new SqlCommand(
                "SELECT Active FROM dbo.GameEggDefinitions WHERE Code = @Code;",
                connection,
                transaction);
            defCommand.Parameters.Add("@Code", SqlDbType.NVarChar, 50).Value = definitionCode;

            await using var defReader = await defCommand.ExecuteReaderAsync(cancellationToken);
            if (!await defReader.ReadAsync(cancellationToken))
            {
                throw new GameBusinessRuleException(
                    "EGG_DEFINITION_NOT_FOUND",
                    "La definicion de huevo especificada no existe.",
                    StatusCodes.Status404NotFound);
            }

            var isActive = defReader.GetBoolean(0);
            await defReader.CloseAsync();

            if (!isActive)
            {
                throw new GameBusinessRuleException(
                    "EGG_DEFINITION_INACTIVE",
                    "La definicion de huevo especificada no esta activa.",
                    StatusCodes.Status400BadRequest);
            }

            await ValidateAvailableCapacityAsync(connection, transaction, request.IdAlumno, cancellationToken);

            await using var command = new SqlCommand(
                """
                INSERT INTO dbo.GameEggs (IdAlumno, EggDefinitionCode, Rarity)
                OUTPUT
                    INSERTED.Id,
                    INSERTED.IdAlumno,
                    INSERTED.Rarity,
                    INSERTED.AcquiredAt,
                    INSERTED.IncubationStartedAt,
                    INSERTED.IncubationEndsAt,
                    INSERTED.Status,
                    INSERTED.EggDefinitionCode
                VALUES (@IdAlumno, @EggDefinitionCode, @Rarity);
                """,
                connection,
                transaction);
            command.Parameters.Add("@IdAlumno", SqlDbType.Int).Value = request.IdAlumno;
            command.Parameters.Add("@EggDefinitionCode", SqlDbType.NVarChar, 50).Value = definitionCode;
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
                INSERTED.Status,
                INSERTED.EggDefinitionCode
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
                Status,
                EggDefinitionCode
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
            EggDefinitionCode = reader.IsDBNull(7) ? null : reader.GetString(7),
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

    public async Task<IReadOnlyCollection<GameEggDefinition>> GetActiveDefinitionsAsync(CancellationToken cancellationToken)
    {
        await using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);
        await using var command = new SqlCommand(
            """
            SELECT
                Code,
                DisplayName,
                Description,
                PriceDracoins,
                IncubationMinutes,
                DefaultRarity,
                Active,
                Purchasable,
                SortOrder
            FROM dbo.GameEggDefinitions
            WHERE Active = 1
            ORDER BY SortOrder;
            """,
            connection);

        var definitions = new List<GameEggDefinition>();
        await using var reader = await command.ExecuteReaderAsync(cancellationToken);
        while (await reader.ReadAsync(cancellationToken))
        {
            definitions.Add(new GameEggDefinition
            {
                Code = reader.GetString(0),
                DisplayName = reader.GetString(1),
                Description = reader.GetString(2),
                PriceDracoins = reader.GetInt32(3),
                IncubationMinutes = reader.GetInt32(4),
                DefaultRarity = reader.GetString(5),
                Active = reader.GetBoolean(6),
                Purchasable = reader.GetBoolean(7),
                SortOrder = reader.GetInt32(8)
            });
        }

        return definitions;
    }

    public async Task<GameEgg> IncubateAsync(long eggId, CancellationToken cancellationToken)
    {
        if (eggId <= 0)
        {
            throw Invalid("El identificador del huevo debe ser mayor a cero.");
        }

        await using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);
        await using var transaction = (SqlTransaction)await connection.BeginTransactionAsync(
            IsolationLevel.Serializable,
            cancellationToken);

        try
        {
            // 1. Obtener huevo y comprobar estado
            await using var eggCommand = new SqlCommand(
                """
                SELECT IdAlumno, EggDefinitionCode, Status, AcquiredAt
                FROM dbo.GameEggs WITH (UPDLOCK, HOLDLOCK)
                WHERE Id = @Id;
                """,
                connection,
                transaction);
            eggCommand.Parameters.Add("@Id", SqlDbType.BigInt).Value = eggId;

            int idAlumno;
            string? eggDefinitionCode;
            string status;
            DateTime acquiredAt;

            await using (var reader = await eggCommand.ExecuteReaderAsync(cancellationToken))
            {
                if (!await reader.ReadAsync(cancellationToken))
                {
                    throw new GameBusinessRuleException(
                        "EGG_NOT_FOUND",
                        "El huevo no existe.",
                        StatusCodes.Status404NotFound);
                }

                idAlumno = reader.GetInt32(0);
                eggDefinitionCode = reader.IsDBNull(1) ? null : reader.GetString(1);
                status = reader.GetString(2);
                acquiredAt = reader.GetDateTime(3);
            }

            var effectiveStatus = GameEggRules.GetEffectiveStatus(status, null, DateTime.UtcNow);
            if (effectiveStatus != "OWNED")
            {
                throw new GameBusinessRuleException(
                    "INVALID_EGG_STATE",
                    "Solo se puede iniciar la incubacion de huevos en estado OWNED.");
            }

            // 2. Obtener minutos de la definicion
            int incubationMinutes = 30; // valor por defecto para legacy
            if (eggDefinitionCode is not null)
            {
                await using var defCommand = new SqlCommand(
                    "SELECT IncubationMinutes FROM dbo.GameEggDefinitions WHERE Code = @Code;",
                    connection,
                    transaction);
                defCommand.Parameters.Add("@Code", SqlDbType.NVarChar, 50).Value = eggDefinitionCode;

                var minutesValue = await defCommand.ExecuteScalarAsync(cancellationToken);
                if (minutesValue is not null && minutesValue != DBNull.Value)
                {
                    incubationMinutes = Convert.ToInt32(minutesValue);
                }
            }

            var startedAt = DateTime.UtcNow;
            var endsAt = startedAt.AddMinutes(incubationMinutes);

            // 3. Actualizar huevo
            await using var updateCommand = new SqlCommand(
                """
                UPDATE dbo.GameEggs
                SET Status = N'INCUBATING',
                    IncubationStartedAt = @StartedAt,
                    IncubationEndsAt = @EndsAt,
                    UpdatedAt = SYSUTCDATETIME()
                OUTPUT
                    INSERTED.Id,
                    INSERTED.IdAlumno,
                    INSERTED.Rarity,
                    INSERTED.AcquiredAt,
                    INSERTED.IncubationStartedAt,
                    INSERTED.IncubationEndsAt,
                    INSERTED.Status,
                    INSERTED.EggDefinitionCode
                WHERE Id = @Id AND Status = N'OWNED';
                """,
                connection,
                transaction);
            updateCommand.Parameters.Add("@Id", SqlDbType.BigInt).Value = eggId;
            updateCommand.Parameters.Add("@StartedAt", SqlDbType.DateTime2).Value = startedAt;
            updateCommand.Parameters.Add("@EndsAt", SqlDbType.DateTime2).Value = endsAt;

            await using var readerUpdate = await updateCommand.ExecuteReaderAsync(cancellationToken);
            if (!await readerUpdate.ReadAsync(cancellationToken))
            {
                throw new GameBusinessRuleException(
                    "INVALID_EGG_STATE",
                    "El huevo ya no se encuentra en estado OWNED.");
            }

            var updatedEgg = ReadEgg(readerUpdate, DateTime.UtcNow);
            await readerUpdate.CloseAsync();

            await transaction.CommitAsync(cancellationToken);
            return updatedEgg;
        }
        catch
        {
            await transaction.RollbackAsync(cancellationToken);
            throw;
        }
    }

    public async Task<PurchaseGameEggResponse> PurchaseAsync(
        PurchaseGameEggRequest request,
        string idempotencyKey,
        CancellationToken cancellationToken)
    {
        if (request.RobloxUserId <= 0)
        {
            throw new GameBusinessRuleException(
                "BUSINESS_RULE_ERROR",
                "RobloxUserId debe ser mayor a cero.",
                StatusCodes.Status400BadRequest);
        }

        var normalizedCode = GameEggRules.NormalizeDefinitionCode(request.EggDefinitionCode);
        var normalizedIdempotencyKey = idempotencyKey.Trim();
        if (normalizedIdempotencyKey.Length > 100)
        {
            throw new GameBusinessRuleException(
                "BUSINESS_RULE_ERROR",
                "X-Idempotency-Key no puede superar 100 caracteres.",
                StatusCodes.Status400BadRequest);
        }

        var payload = $"{request.RobloxUserId}:{normalizedCode}";
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
                "GAME_EGG_PURCHASE",
                normalizedIdempotencyKey,
                requestHash,
                cancellationToken);

            if (reservation.CompletedResponseJson is not null)
            {
                var previousResponse = JsonSerializer.Deserialize<PurchaseGameEggResponse>(
                    reservation.CompletedResponseJson,
                    new JsonSerializerOptions(JsonSerializerDefaults.Web))
                    ?? throw new InvalidOperationException("La respuesta idempotente almacenada no es valida.");

                await transaction.CommitAsync(cancellationToken);
                return previousResponse;
            }

            // 1. Obtener datos del jugador vinculado
            await using var playerCommand = new SqlCommand(
                """
                SELECT L.IdAlumno, CONVERT(BIT, ISNULL(A.Activo, 0)) AS Active
                FROM dbo.GameRobloxLinks L
                INNER JOIN dbo.Alumnos A ON A.IdAlumno = L.IdAlumno
                WHERE L.RobloxUserId = @RobloxUserId AND L.Active = 1;
                """,
                connection,
                transaction);
            playerCommand.Parameters.Add("@RobloxUserId", SqlDbType.BigInt).Value = request.RobloxUserId;

            int idAlumno;
            await using (var playerReader = await playerCommand.ExecuteReaderAsync(cancellationToken))
            {
                if (!await playerReader.ReadAsync(cancellationToken))
                {
                    throw new GameBusinessRuleException(
                        "NOT_LINKED",
                        "La cuenta Roblox no se encuentra vinculada.",
                        StatusCodes.Status404NotFound);
                }

                if (!playerReader.GetBoolean(1))
                {
                    throw new GameBusinessRuleException(
                        "PLAYER_INACTIVE",
                        "El jugador vinculado no se encuentra activo.",
                        StatusCodes.Status403Forbidden);
                }

                idAlumno = playerReader.GetInt32(0);
            }

            // 2. Obtener definicion del huevo
            await using var defCommand = new SqlCommand(
                """
                SELECT DisplayName, PriceDracoins, DefaultRarity, Active, Purchasable
                FROM dbo.GameEggDefinitions
                WHERE Code = @Code;
                """,
                connection,
                transaction);
            defCommand.Parameters.Add("@Code", SqlDbType.NVarChar, 50).Value = normalizedCode;

            string rarity;
            int price;
            await using (var defReader = await defCommand.ExecuteReaderAsync(cancellationToken))
            {
                if (!await defReader.ReadAsync(cancellationToken))
                {
                    throw new GameBusinessRuleException(
                        "EGG_DEFINITION_NOT_FOUND",
                        "La definicion de huevo especificada no existe.",
                        StatusCodes.Status404NotFound);
                }

                if (!defReader.GetBoolean(3))
                {
                    throw new GameBusinessRuleException(
                        "EGG_DEFINITION_INACTIVE",
                        "La definicion de huevo especificada no esta activa.",
                        StatusCodes.Status400BadRequest);
                }

                if (!defReader.GetBoolean(4))
                {
                    throw new GameBusinessRuleException(
                        "EGG_NOT_PURCHASABLE",
                        "El huevo especificado no esta disponible para compra.",
                        StatusCodes.Status400BadRequest);
                }

                price = defReader.GetInt32(1);
                rarity = defReader.GetString(2);
            }

            // 3. Validar capacidad
            await ValidateAvailableCapacityAsync(connection, transaction, idAlumno, cancellationToken);

            // 4. Crear el huevo (en estado OWNED por defecto)
            await using var insertEggCommand = new SqlCommand(
                """
                INSERT INTO dbo.GameEggs (IdAlumno, EggDefinitionCode, Rarity, Status)
                OUTPUT INSERTED.Id
                VALUES (@IdAlumno, @EggDefinitionCode, @Rarity, N'OWNED');
                """,
                connection,
                transaction);
            insertEggCommand.Parameters.Add("@IdAlumno", SqlDbType.Int).Value = idAlumno;
            insertEggCommand.Parameters.Add("@EggDefinitionCode", SqlDbType.NVarChar, 50).Value = normalizedCode;
            insertEggCommand.Parameters.Add("@Rarity", SqlDbType.NVarChar, 20).Value = rarity;

            var eggId = Convert.ToInt64(await insertEggCommand.ExecuteScalarAsync(cancellationToken));

            // 5. Descontar saldo y registrar en ledger
            var balanceAfter = await _dracoinGameService.UpdateBalanceAsync(
                connection,
                transaction,
                idAlumno,
                -price,
                "EGG_PURCHASE",
                "GAME_EGG",
                eggId.ToString(CultureInfo.InvariantCulture),
                cancellationToken);

            var response = new PurchaseGameEggResponse
            {
                Id = eggId,
                EggDefinitionCode = normalizedCode,
                Rarity = rarity,
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

    public async Task<HatchGameEggResponse> HatchAsync(
        long eggId,
        HatchGameEggRequest request,
        CancellationToken cancellationToken)
    {
        if (eggId <= 0)
        {
            throw Invalid("El identificador del huevo debe ser mayor a cero.");
        }

        if (request.RobloxUserId <= 0)
        {
            throw new GameBusinessRuleException(
                "BUSINESS_RULE_ERROR",
                "RobloxUserId debe ser mayor a cero.",
                StatusCodes.Status400BadRequest);
        }

        if (string.IsNullOrWhiteSpace(request.Name))
        {
            throw new GameBusinessRuleException(
                "INVALID_DRAGON_NAME",
                "El nombre del dragon no puede estar vacio.",
                StatusCodes.Status400BadRequest);
        }

        var trimmedName = request.Name.Trim();
        if (trimmedName.Length > 100)
        {
            throw new GameBusinessRuleException(
                "INVALID_DRAGON_NAME",
                "El nombre del dragon no puede superar los 100 caracteres.",
                StatusCodes.Status400BadRequest);
        }

        await using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);
        await using var transaction = (SqlTransaction)await connection.BeginTransactionAsync(
            IsolationLevel.Serializable,
            cancellationToken);

        try
        {
            // 0. Validar vinculación del usuario que eclosiona
            await using var linkCommand = new SqlCommand(
                "SELECT L.IdAlumno, CONVERT(BIT, ISNULL(A.Activo, 0)) FROM dbo.GameRobloxLinks L INNER JOIN dbo.Alumnos A ON A.IdAlumno = L.IdAlumno WHERE L.RobloxUserId = @RobloxUserId AND L.Active = 1;",
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

            // 1. Obtener huevo con UPDLOCK, HOLDLOCK
            await using var eggCommand = new SqlCommand(
                """
                SELECT E.IdAlumno, E.Rarity, E.Status, E.IncubationEndsAt
                FROM dbo.GameEggs E WITH (UPDLOCK, HOLDLOCK)
                WHERE E.Id = @Id;
                """,
                connection,
                transaction);
            eggCommand.Parameters.Add("@Id", SqlDbType.BigInt).Value = eggId;

            int idAlumno;
            string rarity;
            string status;
            DateTime? incubationEndsAt;

            await using (var reader = await eggCommand.ExecuteReaderAsync(cancellationToken))
            {
                if (!await reader.ReadAsync(cancellationToken))
                {
                    throw new GameBusinessRuleException(
                        "EGG_NOT_FOUND",
                        "El huevo no existe.",
                        StatusCodes.Status404NotFound);
                }

                idAlumno = reader.GetInt32(0);
                rarity = reader.GetString(1);
                status = reader.GetString(2);
                incubationEndsAt = reader.IsDBNull(3) ? null : (DateTime?)reader.GetDateTime(3);
            }

            if (callerIdAlumno != idAlumno)
            {
                throw new GameBusinessRuleException(
                    "EGG_NOT_OWNED",
                    "El huevo especificado no te pertenece.",
                    StatusCodes.Status403Forbidden);
            }

            var effectiveStatus = GameEggRules.GetEffectiveStatus(status, incubationEndsAt, DateTime.UtcNow);
            if (effectiveStatus != "READY_TO_HATCH")
            {
                throw new GameBusinessRuleException(
                    "INVALID_EGG_STATE",
                    "El huevo no está listo para eclosionar.",
                    StatusCodes.Status400BadRequest);
            }

            // 2. Elegir temperamento aleatorio
            var temperament = Temperaments[Random.Shared.Next(Temperaments.Length)];

            // 3. Crear dragon
            await using var dragonCommand = new SqlCommand(
                """
                INSERT INTO dbo.GameDragons (IdAlumno, Name, Rarity, Temperament, Level, Stage, HatchedAt)
                OUTPUT INSERTED.Id, INSERTED.HatchedAt
                VALUES (@IdAlumno, @Name, @Rarity, @Temperament, 1, N'BABY', SYSUTCDATETIME());
                """,
                connection,
                transaction);
            dragonCommand.Parameters.Add("@IdAlumno", SqlDbType.Int).Value = idAlumno;
            dragonCommand.Parameters.Add("@Name", SqlDbType.NVarChar, 100).Value = trimmedName;
            dragonCommand.Parameters.Add("@Rarity", SqlDbType.NVarChar, 20).Value = rarity;
            dragonCommand.Parameters.Add("@Temperament", SqlDbType.NVarChar, 50).Value = temperament;

            long dragonId;
            DateTime hatchedAt;
            await using (var reader = await dragonCommand.ExecuteReaderAsync(cancellationToken))
            {
                await reader.ReadAsync(cancellationToken);
                dragonId = reader.GetInt64(0);
                hatchedAt = AsUtc(reader.GetDateTime(1));
            }

            // 4. Actualizar huevo
            await using var updateEggCommand = new SqlCommand(
                """
                UPDATE dbo.GameEggs
                SET Status = N'HATCHED',
                    HatchedDragonId = @HatchedDragonId,
                    UpdatedAt = SYSUTCDATETIME()
                WHERE Id = @Id;
                """,
                connection,
                transaction);
            updateEggCommand.Parameters.Add("@Id", SqlDbType.BigInt).Value = eggId;
            updateEggCommand.Parameters.Add("@HatchedDragonId", SqlDbType.BigInt).Value = dragonId;
            await updateEggCommand.ExecuteNonQueryAsync(cancellationToken);

            await transaction.CommitAsync(cancellationToken);

            return new HatchGameEggResponse
            {
                EggId = eggId,
                EggStatus = "HATCHED",
                Dragon = new GameDragon
                {
                    Id = dragonId,
                    IdAlumno = idAlumno,
                    Name = trimmedName,
                    Rarity = rarity,
                    Temperament = temperament,
                    Level = 1,
                    Stage = "BABY",
                    HatchedAt = hatchedAt
                }
            };
        }
        catch
        {
            await transaction.RollbackAsync(cancellationToken);
            throw;
        }
    }

    public async Task<GiftGameEggResponse> GiftEggAsync(
        long eggId,
        GiftGameEggRequest request,
        string idempotencyKey,
        CancellationToken cancellationToken)
    {
        if (eggId <= 0)
        {
            throw Invalid("El identificador del huevo debe ser mayor a cero.");
        }

        if (request.SenderRobloxUserId <= 0 || request.ReceiverRobloxUserId <= 0)
        {
            throw new GameBusinessRuleException(
                "BUSINESS_RULE_ERROR",
                "Los identificadores de usuario de Roblox deben ser mayores a cero.",
                StatusCodes.Status400BadRequest);
        }

        if (request.SenderRobloxUserId == request.ReceiverRobloxUserId)
        {
            throw new GameBusinessRuleException(
                "CANNOT_GIFT_TO_SELF",
                "No puedes regalarte un huevo a ti mismo.",
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

        var payload = $"{eggId}:{request.SenderRobloxUserId}:{request.ReceiverRobloxUserId}";
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
                "GAME_EGG_GIFT",
                normalizedIdempotencyKey,
                requestHash,
                cancellationToken);

            if (reservation.CompletedResponseJson is not null)
            {
                var previousResponse = JsonSerializer.Deserialize<GiftGameEggResponse>(
                    reservation.CompletedResponseJson,
                    new JsonSerializerOptions(JsonSerializerDefaults.Web))
                    ?? throw new InvalidOperationException("La respuesta idempotente almacenada no es valida.");

                await transaction.CommitAsync(cancellationToken);
                return previousResponse;
            }

            // 1. Validar remitente y obtener su IdAlumno
            await using var senderCommand = new SqlCommand(
                """
                SELECT L.IdAlumno, CONVERT(BIT, ISNULL(A.Activo, 0))
                FROM dbo.GameRobloxLinks L
                INNER JOIN dbo.Alumnos A ON A.IdAlumno = L.IdAlumno
                WHERE L.RobloxUserId = @SenderRobloxUserId AND L.Active = 1;
                """,
                connection,
                transaction);
            senderCommand.Parameters.Add("@SenderRobloxUserId", SqlDbType.BigInt).Value = request.SenderRobloxUserId;

            int senderIdAlumno;
            await using (var reader = await senderCommand.ExecuteReaderAsync(cancellationToken))
            {
                if (!await reader.ReadAsync(cancellationToken))
                {
                    throw new GameBusinessRuleException(
                        "NOT_LINKED",
                        "Tu cuenta de Roblox no está vinculada.",
                        StatusCodes.Status404NotFound);
                }

                if (!reader.GetBoolean(1))
                {
                    throw new GameBusinessRuleException(
                        "PLAYER_INACTIVE",
                        "Tu cuenta de jugador vinculada no está activa.",
                        StatusCodes.Status403Forbidden);
                }

                senderIdAlumno = reader.GetInt32(0);
            }

            // 2. Validar receptor y obtener su IdAlumno
            await using var receiverCommand = new SqlCommand(
                """
                SELECT L.IdAlumno, CONVERT(BIT, ISNULL(A.Activo, 0))
                FROM dbo.GameRobloxLinks L
                INNER JOIN dbo.Alumnos A ON A.IdAlumno = L.IdAlumno
                WHERE L.RobloxUserId = @ReceiverRobloxUserId AND L.Active = 1;
                """,
                connection,
                transaction);
            receiverCommand.Parameters.Add("@ReceiverRobloxUserId", SqlDbType.BigInt).Value = request.ReceiverRobloxUserId;

            await using (var reader = await receiverCommand.ExecuteReaderAsync(cancellationToken))
            {
                if (!await reader.ReadAsync(cancellationToken))
                {
                    throw new GameBusinessRuleException(
                        "RECEIVER_NOT_LINKED",
                        "La cuenta del receptor no está vinculada a un jugador activo.",
                        StatusCodes.Status400BadRequest);
                }

                if (!reader.GetBoolean(1))
                {
                    throw new GameBusinessRuleException(
                        "RECEIVER_INACTIVE",
                        "La cuenta de jugador del receptor no se encuentra activa.",
                        StatusCodes.Status400BadRequest);
                }
            }

            // 3. Validar huevo y propiedad
            await using var eggCommand = new SqlCommand(
                "SELECT IdAlumno, Status FROM dbo.GameEggs WITH (UPDLOCK, HOLDLOCK) WHERE Id = @Id;",
                connection,
                transaction);
            eggCommand.Parameters.Add("@Id", SqlDbType.BigInt).Value = eggId;

            int eggOwnerId;
            string eggStatus;
            await using (var reader = await eggCommand.ExecuteReaderAsync(cancellationToken))
            {
                if (!await reader.ReadAsync(cancellationToken))
                {
                    throw new GameBusinessRuleException(
                        "EGG_NOT_FOUND",
                        "El huevo especificado no existe.",
                        StatusCodes.Status404NotFound);
                }

                eggOwnerId = reader.GetInt32(0);
                eggStatus = reader.GetString(1);
            }

            if (eggOwnerId != senderIdAlumno)
            {
                throw new GameBusinessRuleException(
                    "EGG_NOT_OWNED",
                    "El huevo especificado no te pertenece.",
                    StatusCodes.Status403Forbidden);
            }

            if (eggStatus != "OWNED")
            {
                throw new GameBusinessRuleException(
                    "INVALID_EGG_STATE",
                    "Solo se pueden regalar huevos en estado OWNED.",
                    StatusCodes.Status400BadRequest);
            }

            // 4. Actualizar estado del huevo a IN_TRANSFER
            await using var updateEggCommand = new SqlCommand(
                "UPDATE dbo.GameEggs SET Status = N'IN_TRANSFER', UpdatedAt = SYSUTCDATETIME() WHERE Id = @Id;",
                connection,
                transaction);
            updateEggCommand.Parameters.Add("@Id", SqlDbType.BigInt).Value = eggId;
            await updateEggCommand.ExecuteNonQueryAsync(cancellationToken);

            // 5. Registrar transferencia
            await using var insertTransferCommand = new SqlCommand(
                """
                INSERT INTO dbo.GameEggTransfers (EggId, SenderIdAlumno, ReceiverRobloxUserId, Status)
                OUTPUT INSERTED.Id
                VALUES (@EggId, @SenderIdAlumno, @ReceiverRobloxUserId, N'PENDING');
                """,
                connection,
                transaction);
            insertTransferCommand.Parameters.Add("@EggId", SqlDbType.BigInt).Value = eggId;
            insertTransferCommand.Parameters.Add("@SenderIdAlumno", SqlDbType.Int).Value = senderIdAlumno;
            insertTransferCommand.Parameters.Add("@ReceiverRobloxUserId", SqlDbType.BigInt).Value = request.ReceiverRobloxUserId;

            var transferId = Convert.ToInt64(await insertTransferCommand.ExecuteScalarAsync(cancellationToken));

            var response = new GiftGameEggResponse
            {
                TransferId = transferId,
                EggId = eggId,
                SenderRobloxUserId = request.SenderRobloxUserId,
                ReceiverRobloxUserId = request.ReceiverRobloxUserId,
                Status = "PENDING"
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

    public async Task<GiftGameEggResponse> AcceptGiftAsync(
        long transferId,
        ProcessGiftTransferRequest request,
        string idempotencyKey,
        CancellationToken cancellationToken)
    {
        if (transferId <= 0)
        {
            throw new GameBusinessRuleException(
                "BUSINESS_RULE_ERROR",
                "El identificador de transferencia debe ser mayor a cero.",
                StatusCodes.Status400BadRequest);
        }

        if (request.ReceiverRobloxUserId <= 0)
        {
            throw new GameBusinessRuleException(
                "BUSINESS_RULE_ERROR",
                "ReceiverRobloxUserId debe ser mayor a cero.",
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

        var payload = $"{transferId}:{request.ReceiverRobloxUserId}";
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
                "GAME_EGG_GIFT_ACCEPT",
                normalizedIdempotencyKey,
                requestHash,
                cancellationToken);

            if (reservation.CompletedResponseJson is not null)
            {
                var previousResponse = JsonSerializer.Deserialize<GiftGameEggResponse>(
                    reservation.CompletedResponseJson,
                    new JsonSerializerOptions(JsonSerializerDefaults.Web))
                    ?? throw new InvalidOperationException("La respuesta idempotente almacenada no es valida.");

                await transaction.CommitAsync(cancellationToken);
                return previousResponse;
            }

            // 1. Obtener transferencia bajo lock
            await using var transferCommand = new SqlCommand(
                "SELECT EggId, SenderIdAlumno, ReceiverRobloxUserId, Status FROM dbo.GameEggTransfers WITH (UPDLOCK, HOLDLOCK) WHERE Id = @Id;",
                connection,
                transaction);
            transferCommand.Parameters.Add("@Id", SqlDbType.BigInt).Value = transferId;

            long eggId;
            int senderIdAlumno;
            long receiverRobloxUserId;
            string transferStatus;

            await using (var reader = await transferCommand.ExecuteReaderAsync(cancellationToken))
            {
                if (!await reader.ReadAsync(cancellationToken))
                {
                    throw new GameBusinessRuleException(
                        "TRANSFER_NOT_FOUND",
                        "La transferencia especificada no existe.",
                        StatusCodes.Status404NotFound);
                }

                eggId = reader.GetInt64(0);
                senderIdAlumno = reader.GetInt32(1);
                receiverRobloxUserId = reader.GetInt64(2);
                transferStatus = reader.GetString(3);
            }

            if (transferStatus != "PENDING")
            {
                throw new GameBusinessRuleException(
                    "INVALID_TRANSFER_STATE",
                    "Esta transferencia ya ha sido procesada.",
                    StatusCodes.Status400BadRequest);
            }

            // Validar que el receptor que llama es el receptor asignado en la transferencia
            if (receiverRobloxUserId != request.ReceiverRobloxUserId)
            {
                throw new GameBusinessRuleException(
                    "TRANSFER_NOT_AUTHORIZED",
                    "No estás autorizado para procesar esta transferencia.",
                    StatusCodes.Status403Forbidden);
            }

            // 2. Obtener IdAlumno del receptor y validar su estado y capacidad
            await using var receiverCommand = new SqlCommand(
                """
                SELECT L.IdAlumno, CONVERT(BIT, ISNULL(A.Activo, 0))
                FROM dbo.GameRobloxLinks L
                INNER JOIN dbo.Alumnos A ON A.IdAlumno = L.IdAlumno
                WHERE L.RobloxUserId = @ReceiverRobloxUserId AND L.Active = 1;
                """,
                connection,
                transaction);
            receiverCommand.Parameters.Add("@ReceiverRobloxUserId", SqlDbType.BigInt).Value = receiverRobloxUserId;

            int receiverIdAlumno;
            await using (var reader = await receiverCommand.ExecuteReaderAsync(cancellationToken))
            {
                if (!await reader.ReadAsync(cancellationToken))
                {
                    throw new GameBusinessRuleException(
                        "RECEIVER_NOT_LINKED",
                        "La cuenta del receptor no está vinculada a un jugador activo.",
                        StatusCodes.Status400BadRequest);
                }

                if (!reader.GetBoolean(1))
                {
                    throw new GameBusinessRuleException(
                        "RECEIVER_INACTIVE",
                        "La cuenta de jugador del receptor no se encuentra activa.",
                        StatusCodes.Status400BadRequest);
                }

                receiverIdAlumno = reader.GetInt32(0);
            }

            // Validar capacidad
            await ValidateAvailableCapacityAsync(connection, transaction, receiverIdAlumno, cancellationToken);

            // 3. Obtener RobloxUserId del remitente
            await using var senderRobloxCommand = new SqlCommand(
                "SELECT RobloxUserId FROM dbo.GameRobloxLinks WHERE IdAlumno = @SenderIdAlumno AND Active = 1;",
                connection,
                transaction);
            senderRobloxCommand.Parameters.Add("@SenderIdAlumno", SqlDbType.Int).Value = senderIdAlumno;
            var senderRobloxUserIdVal = await senderRobloxCommand.ExecuteScalarAsync(cancellationToken);
            long senderRobloxUserId = senderRobloxUserIdVal != null ? Convert.ToInt64(senderRobloxUserIdVal) : 0;

            // 4. Actualizar dueño del huevo y estado a OWNED
            await using var updateEggCommand = new SqlCommand(
                "UPDATE dbo.GameEggs SET IdAlumno = @ReceiverIdAlumno, Status = N'OWNED', UpdatedAt = SYSUTCDATETIME() WHERE Id = @Id;",
                connection,
                transaction);
            updateEggCommand.Parameters.Add("@ReceiverIdAlumno", SqlDbType.Int).Value = receiverIdAlumno;
            updateEggCommand.Parameters.Add("@Id", SqlDbType.BigInt).Value = eggId;
            await updateEggCommand.ExecuteNonQueryAsync(cancellationToken);

            // 5. Actualizar transferencia a ACCEPTED y registrar ReceiverIdAlumno
            await using var updateTransferCommand = new SqlCommand(
                "UPDATE dbo.GameEggTransfers SET Status = N'ACCEPTED', ReceiverIdAlumno = @ReceiverIdAlumno, UpdatedAt = SYSUTCDATETIME() WHERE Id = @Id;",
                connection,
                transaction);
            updateTransferCommand.Parameters.Add("@Id", SqlDbType.BigInt).Value = transferId;
            updateTransferCommand.Parameters.Add("@ReceiverIdAlumno", SqlDbType.Int).Value = receiverIdAlumno;
            await updateTransferCommand.ExecuteNonQueryAsync(cancellationToken);

            var response = new GiftGameEggResponse
            {
                TransferId = transferId,
                EggId = eggId,
                SenderRobloxUserId = senderRobloxUserId,
                ReceiverRobloxUserId = receiverRobloxUserId,
                Status = "ACCEPTED"
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

    public async Task<GiftGameEggResponse> RejectGiftAsync(
        long transferId,
        ProcessGiftTransferRequest request,
        string idempotencyKey,
        CancellationToken cancellationToken)
    {
        if (transferId <= 0)
        {
            throw new GameBusinessRuleException(
                "BUSINESS_RULE_ERROR",
                "El identificador de transferencia debe ser mayor a cero.",
                StatusCodes.Status400BadRequest);
        }

        if (request.ReceiverRobloxUserId <= 0)
        {
            throw new GameBusinessRuleException(
                "BUSINESS_RULE_ERROR",
                "ReceiverRobloxUserId debe ser mayor a cero.",
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

        var payload = $"{transferId}:{request.ReceiverRobloxUserId}";
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
                "GAME_EGG_GIFT_REJECT",
                normalizedIdempotencyKey,
                requestHash,
                cancellationToken);

            if (reservation.CompletedResponseJson is not null)
            {
                var previousResponse = JsonSerializer.Deserialize<GiftGameEggResponse>(
                    reservation.CompletedResponseJson,
                    new JsonSerializerOptions(JsonSerializerDefaults.Web))
                    ?? throw new InvalidOperationException("La respuesta idempotente almacenada no es valida.");

                await transaction.CommitAsync(cancellationToken);
                return previousResponse;
            }

            // 1. Obtener transferencia bajo lock
            await using var transferCommand = new SqlCommand(
                "SELECT EggId, SenderIdAlumno, ReceiverRobloxUserId, Status FROM dbo.GameEggTransfers WITH (UPDLOCK, HOLDLOCK) WHERE Id = @Id;",
                connection,
                transaction);
            transferCommand.Parameters.Add("@Id", SqlDbType.BigInt).Value = transferId;

            long eggId;
            int senderIdAlumno;
            long receiverRobloxUserId;
            string transferStatus;

            await using (var reader = await transferCommand.ExecuteReaderAsync(cancellationToken))
            {
                if (!await reader.ReadAsync(cancellationToken))
                {
                    throw new GameBusinessRuleException(
                        "TRANSFER_NOT_FOUND",
                        "La transferencia especificada no existe.",
                        StatusCodes.Status404NotFound);
                }

                eggId = reader.GetInt64(0);
                senderIdAlumno = reader.GetInt32(1);
                receiverRobloxUserId = reader.GetInt64(2);
                transferStatus = reader.GetString(3);
            }

            if (transferStatus != "PENDING")
            {
                throw new GameBusinessRuleException(
                    "INVALID_TRANSFER_STATE",
                    "Esta transferencia ya ha sido procesada.",
                    StatusCodes.Status400BadRequest);
            }

            // Validar que el receptor que llama es el receptor asignado en la transferencia
            if (receiverRobloxUserId != request.ReceiverRobloxUserId)
            {
                throw new GameBusinessRuleException(
                    "TRANSFER_NOT_AUTHORIZED",
                    "No estás autorizado para procesar esta transferencia.",
                    StatusCodes.Status403Forbidden);
            }

            // 2. Obtener RobloxUserId del remitente
            await using var senderRobloxCommand = new SqlCommand(
                "SELECT RobloxUserId FROM dbo.GameRobloxLinks WHERE IdAlumno = @SenderIdAlumno AND Active = 1;",
                connection,
                transaction);
            senderRobloxCommand.Parameters.Add("@SenderIdAlumno", SqlDbType.Int).Value = senderIdAlumno;
            var senderRobloxUserIdVal = await senderRobloxCommand.ExecuteScalarAsync(cancellationToken);
            long senderRobloxUserId = senderRobloxUserIdVal != null ? Convert.ToInt64(senderRobloxUserIdVal) : 0;

            // 3. Devolver huevo a estado OWNED
            await using var updateEggCommand = new SqlCommand(
                "UPDATE dbo.GameEggs SET Status = N'OWNED', UpdatedAt = SYSUTCDATETIME() WHERE Id = @Id;",
                connection,
                transaction);
            updateEggCommand.Parameters.Add("@Id", SqlDbType.BigInt).Value = eggId;
            await updateEggCommand.ExecuteNonQueryAsync(cancellationToken);

            // 4. Actualizar transferencia a REJECTED
            await using var updateTransferCommand = new SqlCommand(
                "UPDATE dbo.GameEggTransfers SET Status = N'REJECTED', UpdatedAt = SYSUTCDATETIME() WHERE Id = @Id;",
                connection,
                transaction);
            updateTransferCommand.Parameters.Add("@Id", SqlDbType.BigInt).Value = transferId;
            await updateTransferCommand.ExecuteNonQueryAsync(cancellationToken);

            var response = new GiftGameEggResponse
            {
                TransferId = transferId,
                EggId = eggId,
                SenderRobloxUserId = senderRobloxUserId,
                ReceiverRobloxUserId = receiverRobloxUserId,
                Status = "REJECTED"
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
