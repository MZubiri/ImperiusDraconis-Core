using System.Globalization;
using ImperiusDraconisAPI.Common;
using ImperiusDraconisAPI.Data;
using ImperiusDraconisAPI.Models.Permisos;
using Microsoft.Data.SqlClient;

namespace ImperiusDraconisAPI.Services;

public sealed class PermisosService
{
    private readonly SqlConnectionFactory _connectionFactory;

    public PermisosService(SqlConnectionFactory connectionFactory)
    {
        _connectionFactory = connectionFactory;
    }

    public async Task<IReadOnlyCollection<CatalogItemDto>> GetCargosAsync(CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        var items = new List<CatalogItemDto>();
        using var command = new SqlCommand(
            "SELECT IdCargo, Nombre FROM Cargos ORDER BY Nombre",
            connection);
        using var reader = await command.ExecuteReaderAsync(cancellationToken);
        while (await reader.ReadAsync(cancellationToken))
        {
            items.Add(new CatalogItemDto
            {
                Id = GetRequiredInt(reader, "IdCargo"),
                Nombre = GetString(reader, "Nombre")
            });
        }

        return items;
    }

    public async Task<PermisoCargoDto?> GetByCargoAsync(int idCargo, CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        var cargoNombre = string.Empty;
        using (var cargoCommand = new SqlCommand(
                   "SELECT TOP 1 Nombre FROM Cargos WHERE IdCargo = @IdCargo",
                   connection))
        {
            cargoCommand.Parameters.AddWithValue("@IdCargo", idCargo);
            cargoNombre = Convert.ToString(
                    await cargoCommand.ExecuteScalarAsync(cancellationToken),
                    CultureInfo.InvariantCulture)
                ?? string.Empty;
        }

        if (string.IsNullOrWhiteSpace(cargoNombre))
        {
            return null;
        }

        var permisos = new List<PermisoDetalleDto>();
        using (var command = new SqlCommand(
                   """
                   SELECT IdPermiso, Controlador, Accion, TienePermiso
                   FROM Permisos
                   WHERE IdCargo = @IdCargo
                   ORDER BY Controlador, Accion
                   """,
                   connection))
        {
            command.Parameters.AddWithValue("@IdCargo", idCargo);
            using var reader = await command.ExecuteReaderAsync(cancellationToken);
            while (await reader.ReadAsync(cancellationToken))
            {
                permisos.Add(new PermisoDetalleDto
                {
                    IdPermiso = GetRequiredInt(reader, "IdPermiso"),
                    Controlador = GetString(reader, "Controlador"),
                    Accion = GetString(reader, "Accion"),
                    TienePermiso = GetBoolean(reader, "TienePermiso")
                });
            }
        }

        return new PermisoCargoDto
        {
            IdCargo = idCargo,
            CargoNombre = cargoNombre,
            Permisos = permisos
        };
    }

    public async Task<PermisoCargoDto?> UpdateAsync(
        int idCargo,
        UpdatePermisoCargoRequest request,
        CancellationToken cancellationToken)
    {
        var items = request.Permisos
            .Where(item => item.IdPermiso > 0)
            .DistinctBy(item => item.IdPermiso)
            .ToArray();

        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);
        await using var transaction = await connection.BeginTransactionAsync(cancellationToken);

        try
        {
            foreach (var item in items)
            {
                using var command = new SqlCommand(
                    """
                    UPDATE Permisos
                    SET TienePermiso = @TienePermiso
                    WHERE IdPermiso = @IdPermiso
                      AND IdCargo = @IdCargo
                    """,
                    connection,
                    (SqlTransaction)transaction);
                command.Parameters.AddWithValue("@TienePermiso", item.TienePermiso);
                command.Parameters.AddWithValue("@IdPermiso", item.IdPermiso);
                command.Parameters.AddWithValue("@IdCargo", idCargo);
                await command.ExecuteNonQueryAsync(cancellationToken);
            }

            await transaction.CommitAsync(cancellationToken);
        }
        catch
        {
            await transaction.RollbackAsync(cancellationToken);
            throw;
        }

        return await GetByCargoAsync(idCargo, cancellationToken);
    }

    public async Task CreateAsync(CreatePermisoRequest request, CancellationToken cancellationToken)
    {
        var controlador = NormalizeRequired(request.Controlador, "El controlador es obligatorio.", maxLength: 100);
        var accion = NormalizeRequired(request.Accion, "La accion es obligatoria.", maxLength: 100);

        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);
        await using var transaction = await connection.BeginTransactionAsync(cancellationToken);

        try
        {
            using (var cargoCommand = new SqlCommand(
                       """
                       INSERT INTO Permisos (IdCargo, Controlador, Accion, TienePermiso)
                       SELECT C.IdCargo, @Controlador, @Accion, 0
                       FROM Cargos C
                       WHERE NOT EXISTS (
                           SELECT 1
                           FROM Permisos P
                           WHERE P.IdCargo = C.IdCargo
                             AND P.Controlador = @Controlador
                             AND P.Accion = @Accion
                       )
                       """,
                       connection,
                       (SqlTransaction)transaction))
            {
                cargoCommand.Parameters.AddWithValue("@Controlador", controlador);
                cargoCommand.Parameters.AddWithValue("@Accion", accion);
                await cargoCommand.ExecuteNonQueryAsync(cancellationToken);
            }

            using (var trabajoCommand = new SqlCommand(
                       """
                       INSERT INTO PermisosTrabajos (IdTrabajo, Controlador, Accion, TienePermiso)
                       SELECT T.IdTrabajo, @Controlador, @Accion, 0
                       FROM Trabajos T
                       WHERE NOT EXISTS (
                           SELECT 1
                           FROM PermisosTrabajos PT
                           WHERE PT.IdTrabajo = T.IdTrabajo
                             AND PT.Controlador = @Controlador
                             AND PT.Accion = @Accion
                       )
                       """,
                       connection,
                       (SqlTransaction)transaction))
            {
                trabajoCommand.Parameters.AddWithValue("@Controlador", controlador);
                trabajoCommand.Parameters.AddWithValue("@Accion", accion);
                await trabajoCommand.ExecuteNonQueryAsync(cancellationToken);
            }

            await transaction.CommitAsync(cancellationToken);
        }
        catch
        {
            await transaction.RollbackAsync(cancellationToken);
            throw;
        }
    }

    private static string GetString(SqlDataReader reader, string columnName) =>
        reader[columnName] == DBNull.Value ? string.Empty : reader[columnName]?.ToString() ?? string.Empty;

    private static int GetRequiredInt(SqlDataReader reader, string columnName) =>
        Convert.ToInt32(reader[columnName], CultureInfo.InvariantCulture);

    private static bool GetBoolean(SqlDataReader reader, string columnName) =>
        reader[columnName] != DBNull.Value && Convert.ToBoolean(reader[columnName], CultureInfo.InvariantCulture);

    private static string NormalizeRequired(string? value, string message, int maxLength)
    {
        var normalized = value?.Trim() ?? string.Empty;
        if (string.IsNullOrWhiteSpace(normalized))
        {
            throw new BusinessRuleException(message);
        }

        return normalized.Length > maxLength ? normalized[..maxLength] : normalized;
    }
}
