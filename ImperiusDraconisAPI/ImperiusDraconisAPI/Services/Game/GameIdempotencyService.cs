using System.Data;
using System.Security.Cryptography;
using ImperiusDraconisAPI.Common;
using Microsoft.Data.SqlClient;

namespace ImperiusDraconisAPI.Services.Game;

public sealed class GameIdempotencyService
{
    public async Task<IdempotencyReservation> ReserveAsync(
        SqlConnection connection,
        SqlTransaction transaction,
        string operation,
        string idempotencyKey,
        byte[] requestHash,
        CancellationToken cancellationToken)
    {
        await using var selectCommand = new SqlCommand(
            """
            SELECT Id, RequestHash, Status, ResponseJson
            FROM dbo.GameIdempotency WITH (UPDLOCK, HOLDLOCK)
            WHERE Operation = @Operation
              AND IdempotencyKey = @IdempotencyKey;
            """,
            connection,
            transaction);
        selectCommand.Parameters.Add("@Operation", SqlDbType.NVarChar, 100).Value = operation;
        selectCommand.Parameters.Add("@IdempotencyKey", SqlDbType.NVarChar, 100).Value = idempotencyKey;

        await using (var reader = await selectCommand.ExecuteReaderAsync(cancellationToken))
        {
            if (await reader.ReadAsync(cancellationToken))
            {
                var storedHash = (byte[])reader["RequestHash"];
                if (!CryptographicOperations.FixedTimeEquals(storedHash, requestHash))
                {
                    throw new GameBusinessRuleException(
                        "IDEMPOTENCY_CONFLICT",
                        "La clave de idempotencia ya fue utilizada con una solicitud diferente.");
                }

                var status = reader.GetString(2);
                var responseJson = reader.IsDBNull(3) ? null : reader.GetString(3);
                if (status == "Completed" && responseJson is not null)
                {
                    return new IdempotencyReservation(reader.GetInt64(0), responseJson);
                }

                throw new GameBusinessRuleException(
                    "IDEMPOTENCY_CONFLICT",
                    "La solicitud con esta clave de idempotencia todavia esta en proceso.");
            }
        }

        await using var insertCommand = new SqlCommand(
            """
            INSERT INTO dbo.GameIdempotency
                (Operation, IdempotencyKey, RequestHash, Status)
            OUTPUT INSERTED.Id
            VALUES
                (@Operation, @IdempotencyKey, @RequestHash, N'Pending');
            """,
            connection,
            transaction);
        insertCommand.Parameters.Add("@Operation", SqlDbType.NVarChar, 100).Value = operation;
        insertCommand.Parameters.Add("@IdempotencyKey", SqlDbType.NVarChar, 100).Value = idempotencyKey;
        insertCommand.Parameters.Add("@RequestHash", SqlDbType.Binary, 32).Value = requestHash;

        var id = Convert.ToInt64(await insertCommand.ExecuteScalarAsync(cancellationToken));
        return new IdempotencyReservation(id, null);
    }

    public async Task CompleteAsync(
        SqlConnection connection,
        SqlTransaction transaction,
        long id,
        string responseJson,
        CancellationToken cancellationToken)
    {
        await using var command = new SqlCommand(
            """
            UPDATE dbo.GameIdempotency
            SET Status = N'Completed',
                ResponseStatusCode = 200,
                ResponseJson = @ResponseJson,
                CompletedAt = SYSUTCDATETIME()
            WHERE Id = @Id
              AND Status = N'Pending';
            """,
            connection,
            transaction);
        command.Parameters.Add("@Id", SqlDbType.BigInt).Value = id;
        command.Parameters.Add("@ResponseJson", SqlDbType.NVarChar, -1).Value = responseJson;

        if (await command.ExecuteNonQueryAsync(cancellationToken) != 1)
        {
            throw new InvalidOperationException("No se pudo completar el registro de idempotencia.");
        }
    }

    public sealed record IdempotencyReservation(long Id, string? CompletedResponseJson);
}
