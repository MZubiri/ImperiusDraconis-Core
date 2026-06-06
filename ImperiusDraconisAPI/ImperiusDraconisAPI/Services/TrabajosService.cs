using System.Globalization;
using ImperiusDraconisAPI.Common;
using ImperiusDraconisAPI.Data;
using ImperiusDraconisAPI.Models.Trabajos;
using Microsoft.Data.SqlClient;

namespace ImperiusDraconisAPI.Services;

public sealed class TrabajosService
{
    private readonly SqlConnectionFactory _connectionFactory;

    public TrabajosService(SqlConnectionFactory connectionFactory)
    {
        _connectionFactory = connectionFactory;
    }

    public async Task<TrabajoCatalogsDto> GetCatalogsAsync(CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        return new TrabajoCatalogsDto
        {
            Alumnos = await GetAlumnosActivosAsync(connection, transaction: null, cancellationToken),
            Trabajos = await GetTrabajosAsync(connection, transaction: null, cancellationToken)
        };
    }

    public async Task<IReadOnlyCollection<TrabajoOptionDto>> GetAllAsync(CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);
        return await GetTrabajosAsync(connection, transaction: null, cancellationToken);
    }

    public async Task<TrabajoOptionDto> CreateAsync(SaveTrabajoRequest request, CancellationToken cancellationToken)
    {
        var nombre = NormalizeRequired(request.Nombre, "El nombre del trabajo es obligatorio.", maxLength: 100);
        var descripcion = NormalizeOptional(request.Descripcion, maxLength: 255);

        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        using var command = new SqlCommand(
            """
            INSERT INTO Trabajos (Nombre, Descripcion)
            VALUES (@Nombre, @Descripcion);
            SELECT CAST(SCOPE_IDENTITY() AS int);
            """,
            connection);
        command.Parameters.AddWithValue("@Nombre", nombre);
        command.Parameters.AddWithValue("@Descripcion", (object?)descripcion ?? DBNull.Value);

        var idTrabajo = Convert.ToInt32(await command.ExecuteScalarAsync(cancellationToken), CultureInfo.InvariantCulture);
        await EnsureTrabajoPermissionRowsAsync(connection, transaction: null, idTrabajo, cancellationToken);
        return (await GetTrabajoByIdAsync(connection, transaction: null, idTrabajo, cancellationToken))!;
    }

    public async Task<TrabajoOptionDto?> UpdateAsync(
        int idTrabajo,
        SaveTrabajoRequest request,
        CancellationToken cancellationToken)
    {
        var nombre = NormalizeRequired(request.Nombre, "El nombre del trabajo es obligatorio.", maxLength: 100);
        var descripcion = NormalizeOptional(request.Descripcion, maxLength: 255);

        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        using var command = new SqlCommand(
            """
            UPDATE Trabajos
            SET Nombre = @Nombre,
                Descripcion = @Descripcion
            WHERE IdTrabajo = @IdTrabajo
            """,
            connection);
        command.Parameters.AddWithValue("@IdTrabajo", idTrabajo);
        command.Parameters.AddWithValue("@Nombre", nombre);
        command.Parameters.AddWithValue("@Descripcion", (object?)descripcion ?? DBNull.Value);

        var affected = await command.ExecuteNonQueryAsync(cancellationToken);
        return affected == 0
            ? null
            : await GetTrabajoByIdAsync(connection, transaction: null, idTrabajo, cancellationToken);
    }

    public async Task<bool> DeleteAsync(int idTrabajo, CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);
        await using var transaction = await connection.BeginTransactionAsync(cancellationToken);

        try
        {
            using (var deleteAssignments = new SqlCommand(
                       "DELETE FROM AlumnosTrabajos WHERE IdTrabajo = @IdTrabajo",
                       connection,
                       (SqlTransaction)transaction))
            {
                deleteAssignments.Parameters.AddWithValue("@IdTrabajo", idTrabajo);
                await deleteAssignments.ExecuteNonQueryAsync(cancellationToken);
            }

            using (var deletePermissions = new SqlCommand(
                       "DELETE FROM PermisosTrabajos WHERE IdTrabajo = @IdTrabajo",
                       connection,
                       (SqlTransaction)transaction))
            {
                deletePermissions.Parameters.AddWithValue("@IdTrabajo", idTrabajo);
                await deletePermissions.ExecuteNonQueryAsync(cancellationToken);
            }

            int affected;
            using (var deleteTrabajo = new SqlCommand(
                       "DELETE FROM Trabajos WHERE IdTrabajo = @IdTrabajo",
                       connection,
                       (SqlTransaction)transaction))
            {
                deleteTrabajo.Parameters.AddWithValue("@IdTrabajo", idTrabajo);
                affected = await deleteTrabajo.ExecuteNonQueryAsync(cancellationToken);
            }

            await transaction.CommitAsync(cancellationToken);
            return affected > 0;
        }
        catch
        {
            await transaction.RollbackAsync(cancellationToken);
            throw;
        }
    }

    public async Task<TrabajoAlumnoAssignmentsDto?> GetAssignmentsAsync(
        int idAlumno,
        CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);
        return await GetAssignmentsInternalAsync(connection, transaction: null, idAlumno, cancellationToken);
    }

    public async Task<TrabajoAlumnoAssignmentsDto?> UpdateAssignmentsAsync(
        int idAlumno,
        SaveTrabajoAssignmentsRequest request,
        CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        if (!await AlumnoExistsAsync(connection, transaction: null, idAlumno, cancellationToken))
        {
            return null;
        }

        var trabajoIds = request.IdsTrabajo
            .Where(id => id > 0)
            .Distinct()
            .ToArray();

        var validTrabajoIds = (await GetTrabajosAsync(connection, transaction: null, cancellationToken))
            .Select(item => item.IdTrabajo)
            .ToHashSet();

        if (trabajoIds.Any(id => !validTrabajoIds.Contains(id)))
        {
            throw new BusinessRuleException("Se recibio un trabajo invalido en la asignacion.");
        }

        await using var transaction = await connection.BeginTransactionAsync(cancellationToken);

        try
        {
            using (var deleteCommand = new SqlCommand(
                       "DELETE FROM AlumnosTrabajos WHERE IdAlumno = @IdAlumno",
                       connection,
                       (SqlTransaction)transaction))
            {
                deleteCommand.Parameters.AddWithValue("@IdAlumno", idAlumno);
                await deleteCommand.ExecuteNonQueryAsync(cancellationToken);
            }

            foreach (var trabajoId in trabajoIds)
            {
                using var insertCommand = new SqlCommand(
                    """
                    INSERT INTO AlumnosTrabajos (IdAlumno, IdTrabajo, FechaAsignacion)
                    VALUES (@IdAlumno, @IdTrabajo, @FechaAsignacion)
                    """,
                    connection,
                    (SqlTransaction)transaction);
                insertCommand.Parameters.AddWithValue("@IdAlumno", idAlumno);
                insertCommand.Parameters.AddWithValue("@IdTrabajo", trabajoId);
                insertCommand.Parameters.AddWithValue("@FechaAsignacion", DateTime.Now);
                await insertCommand.ExecuteNonQueryAsync(cancellationToken);
            }

            await transaction.CommitAsync(cancellationToken);
        }
        catch
        {
            await transaction.RollbackAsync(cancellationToken);
            throw;
        }

        return await GetAssignmentsInternalAsync(connection, transaction: null, idAlumno, cancellationToken);
    }

    public async Task<TrabajoPermisosDto?> GetPermissionsAsync(int idTrabajo, CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        if (!await TrabajoExistsAsync(connection, transaction: null, idTrabajo, cancellationToken))
        {
            return null;
        }

        await EnsureTrabajoPermissionRowsAsync(connection, transaction: null, idTrabajo, cancellationToken);
        return await GetPermissionsInternalAsync(connection, transaction: null, idTrabajo, cancellationToken);
    }

    public async Task<TrabajoPermisosDto?> UpdatePermissionsAsync(
        int idTrabajo,
        UpdateTrabajoPermisosRequest request,
        CancellationToken cancellationToken)
    {
        var items = request.Permisos
            .Select(item => new
            {
                Controlador = NormalizeRequired(item.Controlador, "El controlador es obligatorio.", maxLength: 100),
                Accion = NormalizeRequired(item.Accion, "La accion es obligatoria.", maxLength: 100),
                item.TienePermiso
            })
            .DistinctBy(item => $"{item.Controlador}:{item.Accion}", StringComparer.OrdinalIgnoreCase)
            .ToArray();

        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        if (!await TrabajoExistsAsync(connection, transaction: null, idTrabajo, cancellationToken))
        {
            return null;
        }

        await using var transaction = await connection.BeginTransactionAsync(cancellationToken);

        try
        {
            await EnsureTrabajoPermissionRowsAsync(connection, (SqlTransaction)transaction, idTrabajo, cancellationToken);

            foreach (var item in items)
            {
                using var command = new SqlCommand(
                    """
                    UPDATE PermisosTrabajos
                    SET TienePermiso = @TienePermiso
                    WHERE IdTrabajo = @IdTrabajo
                      AND Controlador = @Controlador
                      AND Accion = @Accion
                    """,
                    connection,
                    (SqlTransaction)transaction);
                command.Parameters.AddWithValue("@TienePermiso", item.TienePermiso);
                command.Parameters.AddWithValue("@IdTrabajo", idTrabajo);
                command.Parameters.AddWithValue("@Controlador", item.Controlador);
                command.Parameters.AddWithValue("@Accion", item.Accion);
                await command.ExecuteNonQueryAsync(cancellationToken);
            }

            await transaction.CommitAsync(cancellationToken);
        }
        catch
        {
            await transaction.RollbackAsync(cancellationToken);
            throw;
        }

        return await GetPermissionsInternalAsync(connection, transaction: null, idTrabajo, cancellationToken);
    }

    private static async Task<IReadOnlyCollection<CatalogItemDto>> GetAlumnosActivosAsync(
        SqlConnection connection,
        SqlTransaction? transaction,
        CancellationToken cancellationToken)
    {
        var items = new List<CatalogItemDto>();
        using var command = new SqlCommand(
            """
            SELECT IdAlumno, Codigo, Nombre
            FROM Alumnos
            WHERE Activo = 1
            ORDER BY Codigo
            """,
            connection,
            transaction);
        using var reader = await command.ExecuteReaderAsync(cancellationToken);
        while (await reader.ReadAsync(cancellationToken))
        {
            items.Add(new CatalogItemDto
            {
                Id = GetRequiredInt(reader, "IdAlumno"),
                Nombre = $"{GetString(reader, "Codigo")} - {GetString(reader, "Nombre")}"
            });
        }

        return items;
    }

    private static async Task<IReadOnlyCollection<TrabajoOptionDto>> GetTrabajosAsync(
        SqlConnection connection,
        SqlTransaction? transaction,
        CancellationToken cancellationToken)
    {
        var items = new List<TrabajoOptionDto>();
        using var command = new SqlCommand(
            """
            SELECT IdTrabajo, Nombre, Descripcion
            FROM Trabajos
            ORDER BY Nombre
            """,
            connection,
            transaction);
        using var reader = await command.ExecuteReaderAsync(cancellationToken);
        while (await reader.ReadAsync(cancellationToken))
        {
            items.Add(new TrabajoOptionDto
            {
                IdTrabajo = GetRequiredInt(reader, "IdTrabajo"),
                Nombre = GetString(reader, "Nombre"),
                Descripcion = GetString(reader, "Descripcion")
            });
        }

        return items;
    }

    private static async Task<TrabajoOptionDto?> GetTrabajoByIdAsync(
        SqlConnection connection,
        SqlTransaction? transaction,
        int idTrabajo,
        CancellationToken cancellationToken)
    {
        using var command = new SqlCommand(
            """
            SELECT IdTrabajo, Nombre, Descripcion
            FROM Trabajos
            WHERE IdTrabajo = @IdTrabajo
            """,
            connection,
            transaction);
        command.Parameters.AddWithValue("@IdTrabajo", idTrabajo);

        using var reader = await command.ExecuteReaderAsync(cancellationToken);
        if (!await reader.ReadAsync(cancellationToken))
        {
            return null;
        }

        return new TrabajoOptionDto
        {
            IdTrabajo = GetRequiredInt(reader, "IdTrabajo"),
            Nombre = GetString(reader, "Nombre"),
            Descripcion = GetString(reader, "Descripcion")
        };
    }

    private static async Task<bool> TrabajoExistsAsync(
        SqlConnection connection,
        SqlTransaction? transaction,
        int idTrabajo,
        CancellationToken cancellationToken)
    {
        using var command = new SqlCommand(
            "SELECT COUNT(*) FROM Trabajos WHERE IdTrabajo = @IdTrabajo",
            connection,
            transaction);
        command.Parameters.AddWithValue("@IdTrabajo", idTrabajo);
        return Convert.ToInt32(await command.ExecuteScalarAsync(cancellationToken), CultureInfo.InvariantCulture) > 0;
    }

    private static async Task EnsureTrabajoPermissionRowsAsync(
        SqlConnection connection,
        SqlTransaction? transaction,
        int idTrabajo,
        CancellationToken cancellationToken)
    {
        using var command = new SqlCommand(
            """
            INSERT INTO PermisosTrabajos (IdTrabajo, Controlador, Accion, TienePermiso)
            SELECT @IdTrabajo, P.Controlador, P.Accion, 0
            FROM (
                SELECT DISTINCT Controlador, Accion FROM Permisos
                UNION
                SELECT DISTINCT Controlador, Accion FROM PermisosTrabajos
            ) P
            WHERE NOT EXISTS (
                SELECT 1
                FROM PermisosTrabajos PT
                WHERE PT.IdTrabajo = @IdTrabajo
                  AND PT.Controlador = P.Controlador
                  AND PT.Accion = P.Accion
            )
            """,
            connection,
            transaction);
        command.Parameters.AddWithValue("@IdTrabajo", idTrabajo);
        await command.ExecuteNonQueryAsync(cancellationToken);
    }

    private static async Task<TrabajoPermisosDto?> GetPermissionsInternalAsync(
        SqlConnection connection,
        SqlTransaction? transaction,
        int idTrabajo,
        CancellationToken cancellationToken)
    {
        var trabajo = await GetTrabajoByIdAsync(connection, transaction, idTrabajo, cancellationToken);
        if (trabajo is null)
        {
            return null;
        }

        var items = new List<TrabajoPermisoItemDto>();
        using var command = new SqlCommand(
            """
            SELECT IdPermisoTrabajo, Controlador, Accion, TienePermiso
            FROM PermisosTrabajos
            WHERE IdTrabajo = @IdTrabajo
            ORDER BY Controlador, Accion
            """,
            connection,
            transaction);
        command.Parameters.AddWithValue("@IdTrabajo", idTrabajo);

        using var reader = await command.ExecuteReaderAsync(cancellationToken);
        while (await reader.ReadAsync(cancellationToken))
        {
            items.Add(new TrabajoPermisoItemDto
            {
                IdPermisoTrabajo = GetRequiredInt(reader, "IdPermisoTrabajo"),
                Controlador = GetString(reader, "Controlador"),
                Accion = GetString(reader, "Accion"),
                TienePermiso = GetBoolean(reader, "TienePermiso")
            });
        }

        return new TrabajoPermisosDto
        {
            IdTrabajo = idTrabajo,
            TrabajoNombre = trabajo.Nombre,
            Permisos = items
        };
    }

    private static async Task<bool> AlumnoExistsAsync(
        SqlConnection connection,
        SqlTransaction? transaction,
        int idAlumno,
        CancellationToken cancellationToken)
    {
        using var command = new SqlCommand(
            "SELECT COUNT(*) FROM Alumnos WHERE IdAlumno = @IdAlumno AND Activo = 1",
            connection,
            transaction);
        command.Parameters.AddWithValue("@IdAlumno", idAlumno);

        return Convert.ToInt32(await command.ExecuteScalarAsync(cancellationToken), CultureInfo.InvariantCulture) > 0;
    }

    private static async Task<TrabajoAlumnoAssignmentsDto?> GetAssignmentsInternalAsync(
        SqlConnection connection,
        SqlTransaction? transaction,
        int idAlumno,
        CancellationToken cancellationToken)
    {
        string codigoAlumno;
        string nombreAlumno;
        using (var alumnoCommand = new SqlCommand(
                   """
                   SELECT TOP 1 Codigo, Nombre
                   FROM Alumnos
                   WHERE IdAlumno = @IdAlumno
                     AND Activo = 1
                   """,
                   connection,
                   transaction))
        {
            alumnoCommand.Parameters.AddWithValue("@IdAlumno", idAlumno);
            using var alumnoReader = await alumnoCommand.ExecuteReaderAsync(cancellationToken);
            if (!await alumnoReader.ReadAsync(cancellationToken))
            {
                return null;
            }

            codigoAlumno = GetString(alumnoReader, "Codigo");
            nombreAlumno = GetString(alumnoReader, "Nombre");
        }

        var items = new List<TrabajoAssignmentItemDto>();
        using (var command = new SqlCommand(
                   """
                   SELECT
                       T.IdTrabajo,
                       T.Nombre,
                       T.Descripcion,
                       CASE WHEN AT.IdAlumno IS NULL THEN 0 ELSE 1 END AS Asignado
                   FROM Trabajos T
                   LEFT JOIN AlumnosTrabajos AT
                       ON AT.IdTrabajo = T.IdTrabajo
                      AND AT.IdAlumno = @IdAlumno
                   ORDER BY T.Nombre
                   """,
                   connection,
                   transaction))
        {
            command.Parameters.AddWithValue("@IdAlumno", idAlumno);
            using var reader = await command.ExecuteReaderAsync(cancellationToken);
            while (await reader.ReadAsync(cancellationToken))
            {
                items.Add(new TrabajoAssignmentItemDto
                {
                    IdTrabajo = GetRequiredInt(reader, "IdTrabajo"),
                    Nombre = GetString(reader, "Nombre"),
                    Descripcion = GetString(reader, "Descripcion"),
                    Asignado = GetRequiredInt(reader, "Asignado") == 1
                });
            }
        }

        return new TrabajoAlumnoAssignmentsDto
        {
            IdAlumno = idAlumno,
            CodigoAlumno = codigoAlumno,
            NombreAlumno = nombreAlumno,
            Trabajos = items
        };
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

    private static string? NormalizeOptional(string? value, int maxLength)
    {
        var normalized = value?.Trim();
        if (string.IsNullOrWhiteSpace(normalized))
        {
            return null;
        }

        return normalized.Length > maxLength ? normalized[..maxLength] : normalized;
    }
}
