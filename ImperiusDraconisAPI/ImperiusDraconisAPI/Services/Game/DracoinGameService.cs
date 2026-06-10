using System.Data;
using Microsoft.Data.SqlClient;
using ImperiusDraconisAPI.Common;

namespace ImperiusDraconisAPI.Services.Game;

public sealed class DracoinGameService
{
    public async Task<decimal> CreditWelcomeAsync(
        SqlConnection connection,
        SqlTransaction transaction,
        int idAlumno,
        int amount,
        long gameRobloxLinkId,
        CancellationToken cancellationToken)
    {
        await using var balanceCommand = new SqlCommand(
            """
            UPDATE dbo.Alumnos
            SET Dracoins = ISNULL(Dracoins, 0) + @Amount
            OUTPUT INSERTED.Dracoins
            WHERE IdAlumno = @IdAlumno
              AND Activo = 1;
            """,
            connection,
            transaction);
        balanceCommand.Parameters.Add("@IdAlumno", SqlDbType.Int).Value = idAlumno;
        AddDecimalParameter(balanceCommand, "@Amount", amount);

        var balanceValue = await balanceCommand.ExecuteScalarAsync(cancellationToken);
        if (balanceValue is null || balanceValue == DBNull.Value)
        {
            throw new InvalidOperationException("No se pudo acreditar la recompensa de bienvenida.");
        }

        var balanceAfter = Convert.ToDecimal(balanceValue);

        await using var ledgerCommand = new SqlCommand(
            """
            INSERT INTO dbo.GameDracoinLedger
                (IdAlumno, Amount, BalanceAfter, Reason, ReferenceType, ReferenceId)
            VALUES
                (@IdAlumno, @Amount, @BalanceAfter, N'WELCOME_LINK', N'ROBLOX_LINK', @ReferenceId);
            """,
            connection,
            transaction);
        ledgerCommand.Parameters.Add("@IdAlumno", SqlDbType.Int).Value = idAlumno;
        AddDecimalParameter(ledgerCommand, "@Amount", amount);
        AddDecimalParameter(ledgerCommand, "@BalanceAfter", balanceAfter);
        ledgerCommand.Parameters.Add("@ReferenceId", SqlDbType.NVarChar, 100).Value =
            gameRobloxLinkId.ToString(System.Globalization.CultureInfo.InvariantCulture);
        await ledgerCommand.ExecuteNonQueryAsync(cancellationToken);

        return balanceAfter;
    }

    public async Task<decimal> UpdateBalanceAsync(
        SqlConnection connection,
        SqlTransaction transaction,
        int idAlumno,
        decimal amount,
        string reason,
        string referenceType,
        string? referenceId,
        CancellationToken cancellationToken)
    {
        if (amount == 0)
        {
            throw new ArgumentException("El monto no puede ser cero.", nameof(amount));
        }

        if (amount != Math.Round(amount, 0))
        {
            throw new ArgumentException("El monto debe ser un numero entero.", nameof(amount));
        }

        await using var balanceCommand = new SqlCommand(
            """
            UPDATE dbo.Alumnos
            SET Dracoins = ISNULL(Dracoins, 0) + @Amount
            OUTPUT INSERTED.Dracoins
            WHERE IdAlumno = @IdAlumno
              AND Activo = 1;
            """,
            connection,
            transaction);
        balanceCommand.Parameters.Add("@IdAlumno", SqlDbType.Int).Value = idAlumno;
        AddDecimalParameter(balanceCommand, "@Amount", amount);

        var balanceValue = await balanceCommand.ExecuteScalarAsync(cancellationToken);
        if (balanceValue is null || balanceValue == DBNull.Value)
        {
            throw new InvalidOperationException("No se pudo actualizar el saldo del alumno.");
        }

        var balanceAfter = Convert.ToDecimal(balanceValue);
        if (balanceAfter < 0)
        {
            throw new GameBusinessRuleException(
                "INSUFFICIENT_DRACOINS",
                "El saldo del jugador es insuficiente para esta transaccion.");
        }

        await using var ledgerCommand = new SqlCommand(
            """
            INSERT INTO dbo.GameDracoinLedger
                (IdAlumno, Amount, BalanceAfter, Reason, ReferenceType, ReferenceId)
            VALUES
                (@IdAlumno, @Amount, @BalanceAfter, @Reason, @ReferenceType, @ReferenceId);
            """,
            connection,
            transaction);
        ledgerCommand.Parameters.Add("@IdAlumno", SqlDbType.Int).Value = idAlumno;
        AddDecimalParameter(ledgerCommand, "@Amount", amount);
        AddDecimalParameter(ledgerCommand, "@BalanceAfter", balanceAfter);
        ledgerCommand.Parameters.Add("@Reason", SqlDbType.NVarChar, 50).Value = reason;
        ledgerCommand.Parameters.Add("@ReferenceType", SqlDbType.NVarChar, 50).Value = referenceType;
        ledgerCommand.Parameters.Add("@ReferenceId", SqlDbType.NVarChar, 100).Value = (object?)referenceId ?? DBNull.Value;

        await ledgerCommand.ExecuteNonQueryAsync(cancellationToken);
        return balanceAfter;
    }

    private static void AddDecimalParameter(SqlCommand command, string name, decimal value)
    {
        var parameter = command.Parameters.Add(name, SqlDbType.Decimal);
        parameter.Precision = 18;
        parameter.Scale = 2;
        parameter.Value = value;
    }
}
