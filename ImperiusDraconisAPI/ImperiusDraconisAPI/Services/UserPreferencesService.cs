using System.Text.Json;
using ImperiusDraconisAPI.Data;
using ImperiusDraconisAPI.Models.Preferences;
using Microsoft.Data.SqlClient;

namespace ImperiusDraconisAPI.Services;

public sealed class UserPreferencesService
{
    private const string DashboardQuickLinksKey = "DashboardQuickLinks";
    private const string DracoinTransferFavoritesKey = "DracoinsTransferFavorites";
    private const string ThemeKey = "AppearanceTheme";
    private const int MaxDracoinTransferFavorites = 12;
    private static readonly HashSet<string> AllowedThemes = new(StringComparer.OrdinalIgnoreCase)
    {
        "imperius",
        "gryffindor",
        "hufflepuff",
        "ravenclaw",
        "slytherin",
        "dark",
        "corporate",
        "kawaii"
    };
    private readonly SqlConnectionFactory _connectionFactory;

    public UserPreferencesService(SqlConnectionFactory connectionFactory)
    {
        _connectionFactory = connectionFactory;
    }

    public async Task<DashboardQuickLinksPreferenceDto> GetDashboardQuickLinksAsync(
        int idAlumno,
        CancellationToken cancellationToken)
    {
        await using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        await using var command = new SqlCommand(
            """
            SELECT Valor
            FROM AlumnoPreferencias
            WHERE IdAlumno = @IdAlumno AND Clave = @Clave
            """,
            connection);
        command.Parameters.AddWithValue("@IdAlumno", idAlumno);
        command.Parameters.AddWithValue("@Clave", DashboardQuickLinksKey);

        var value = await command.ExecuteScalarAsync(cancellationToken) as string;
        if (string.IsNullOrWhiteSpace(value))
        {
            return new DashboardQuickLinksPreferenceDto();
        }

        try
        {
            var routes = JsonSerializer.Deserialize<IReadOnlyList<string>>(value) ?? [];
            return new DashboardQuickLinksPreferenceDto
            {
                HasPreference = true,
                Routes = routes.Where(route => !string.IsNullOrWhiteSpace(route)).Distinct().ToArray()
            };
        }
        catch (JsonException)
        {
            return new DashboardQuickLinksPreferenceDto();
        }
    }

    public async Task SaveDashboardQuickLinksAsync(
        int idAlumno,
        UpdateDashboardQuickLinksPreferenceRequest request,
        CancellationToken cancellationToken)
    {
        var routes = request.Routes
            .Where(route => !string.IsNullOrWhiteSpace(route))
            .Select(route => route.Trim())
            .Distinct(StringComparer.OrdinalIgnoreCase)
            .ToArray();
        var value = JsonSerializer.Serialize(routes);

        await using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        await using var command = new SqlCommand(
            """
            MERGE AlumnoPreferencias AS target
            USING (SELECT @IdAlumno AS IdAlumno, @Clave AS Clave) AS source
              ON target.IdAlumno = source.IdAlumno AND target.Clave = source.Clave
            WHEN MATCHED THEN
              UPDATE SET Valor = @Valor, FechaActualizacion = SYSUTCDATETIME()
            WHEN NOT MATCHED THEN
              INSERT (IdAlumno, Clave, Valor, FechaActualizacion)
              VALUES (@IdAlumno, @Clave, @Valor, SYSUTCDATETIME());
            """,
            connection);
        command.Parameters.AddWithValue("@IdAlumno", idAlumno);
        command.Parameters.AddWithValue("@Clave", DashboardQuickLinksKey);
        command.Parameters.AddWithValue("@Valor", value);

        await command.ExecuteNonQueryAsync(cancellationToken);
    }

    public async Task<DracoinTransferFavoritesPreferenceDto> GetDracoinTransferFavoritesAsync(
        int idAlumno,
        CancellationToken cancellationToken)
    {
        await using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        await using var command = new SqlCommand(
            """
            SELECT Valor
            FROM AlumnoPreferencias
            WHERE IdAlumno = @IdAlumno AND Clave = @Clave
            """,
            connection);
        command.Parameters.AddWithValue("@IdAlumno", idAlumno);
        command.Parameters.AddWithValue("@Clave", DracoinTransferFavoritesKey);

        var value = await command.ExecuteScalarAsync(cancellationToken) as string;
        if (string.IsNullOrWhiteSpace(value))
        {
            return new DracoinTransferFavoritesPreferenceDto();
        }

        try
        {
            var favorites = JsonSerializer.Deserialize<IReadOnlyList<DracoinTransferFavoriteDto>>(value) ?? [];
            return new DracoinTransferFavoritesPreferenceDto
            {
                Favoritos = favorites
                    .Where(favorite => !string.IsNullOrWhiteSpace(favorite.Codigo))
                    .Select(favorite => new DracoinTransferFavoriteDto
                    {
                        Codigo = NormalizeCode(favorite.Codigo),
                        Nombre = favorite.Nombre.Trim()
                    })
                    .DistinctBy(favorite => favorite.Codigo)
                    .Take(MaxDracoinTransferFavorites)
                    .ToArray()
            };
        }
        catch (JsonException)
        {
            return new DracoinTransferFavoritesPreferenceDto();
        }
    }

    public async Task<DracoinTransferFavoritesPreferenceDto> SaveDracoinTransferFavoritesAsync(
        int idAlumno,
        UpdateDracoinTransferFavoritesPreferenceRequest request,
        CancellationToken cancellationToken)
    {
        await using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        var currentUserCode = await GetCurrentUserCodeAsync(connection, idAlumno, cancellationToken);
        var requestedCodes = request.Favoritos
            .Select(favorite => NormalizeCode(favorite.Codigo))
            .Where(codigo => !string.IsNullOrWhiteSpace(codigo))
            .Where(codigo => !string.Equals(codigo, currentUserCode, StringComparison.OrdinalIgnoreCase))
            .Distinct(StringComparer.OrdinalIgnoreCase)
            .Take(MaxDracoinTransferFavorites)
            .ToArray();

        var alumnosByCode = await GetActiveAlumnosByCodeAsync(connection, requestedCodes, cancellationToken);
        var favorites = requestedCodes
            .Where(alumnosByCode.ContainsKey)
            .Select(codigo =>
            {
                var alumno = alumnosByCode[codigo];
                return new DracoinTransferFavoriteDto
                {
                    Codigo = alumno.Codigo,
                    Nombre = alumno.Nombre
                };
            })
            .ToArray();

        await using var command = new SqlCommand(
            """
            MERGE AlumnoPreferencias AS target
            USING (SELECT @IdAlumno AS IdAlumno, @Clave AS Clave) AS source
              ON target.IdAlumno = source.IdAlumno AND target.Clave = source.Clave
            WHEN MATCHED THEN
              UPDATE SET Valor = @Valor, FechaActualizacion = SYSUTCDATETIME()
            WHEN NOT MATCHED THEN
              INSERT (IdAlumno, Clave, Valor, FechaActualizacion)
              VALUES (@IdAlumno, @Clave, @Valor, SYSUTCDATETIME());
            """,
            connection);
        command.Parameters.AddWithValue("@IdAlumno", idAlumno);
        command.Parameters.AddWithValue("@Clave", DracoinTransferFavoritesKey);
        command.Parameters.AddWithValue("@Valor", JsonSerializer.Serialize(favorites));

        await command.ExecuteNonQueryAsync(cancellationToken);

        return new DracoinTransferFavoritesPreferenceDto
        {
            Favoritos = favorites
        };
    }

    public async Task<ThemePreferenceDto> GetThemeAsync(int idAlumno, CancellationToken cancellationToken)
    {
        await using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        await using var command = new SqlCommand(
            """
            SELECT Valor
            FROM AlumnoPreferencias
            WHERE IdAlumno = @IdAlumno AND Clave = @Clave
            """,
            connection);
        command.Parameters.AddWithValue("@IdAlumno", idAlumno);
        command.Parameters.AddWithValue("@Clave", ThemeKey);

        var value = await command.ExecuteScalarAsync(cancellationToken) as string;
        return new ThemePreferenceDto { Tema = NormalizeTheme(value) };
    }

    public async Task<ThemePreferenceDto> SaveThemeAsync(
        int idAlumno,
        UpdateThemePreferenceRequest request,
        CancellationToken cancellationToken)
    {
        var theme = NormalizeTheme(request.Tema);

        await using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        await using var command = new SqlCommand(
            """
            MERGE AlumnoPreferencias AS target
            USING (SELECT @IdAlumno AS IdAlumno, @Clave AS Clave) AS source
              ON target.IdAlumno = source.IdAlumno AND target.Clave = source.Clave
            WHEN MATCHED THEN
              UPDATE SET Valor = @Valor, FechaActualizacion = SYSUTCDATETIME()
            WHEN NOT MATCHED THEN
              INSERT (IdAlumno, Clave, Valor, FechaActualizacion)
              VALUES (@IdAlumno, @Clave, @Valor, SYSUTCDATETIME());
            """,
            connection);
        command.Parameters.AddWithValue("@IdAlumno", idAlumno);
        command.Parameters.AddWithValue("@Clave", ThemeKey);
        command.Parameters.AddWithValue("@Valor", theme);
        await command.ExecuteNonQueryAsync(cancellationToken);

        return new ThemePreferenceDto { Tema = theme };
    }



    private static async Task<string> GetCurrentUserCodeAsync(
        SqlConnection connection,
        int idAlumno,
        CancellationToken cancellationToken)
    {
        await using var command = new SqlCommand(
            """
            SELECT TOP 1 Codigo
            FROM Alumnos
            WHERE IdAlumno = @IdAlumno
            """,
            connection);
        command.Parameters.AddWithValue("@IdAlumno", idAlumno);

        var value = await command.ExecuteScalarAsync(cancellationToken) as string;
        return NormalizeCode(value ?? string.Empty);
    }

    private static async Task<Dictionary<string, (string Codigo, string Nombre)>> GetActiveAlumnosByCodeAsync(
        SqlConnection connection,
        IReadOnlyList<string> codigos,
        CancellationToken cancellationToken)
    {
        var alumnosByCode = new Dictionary<string, (string Codigo, string Nombre)>(StringComparer.OrdinalIgnoreCase);
        if (codigos.Count == 0)
        {
            return alumnosByCode;
        }

        var parameterNames = codigos
            .Select((_, index) => $"@Codigo{index}")
            .ToArray();

        await using var command = new SqlCommand(
            $"""
            SELECT Codigo, Nombre
            FROM Alumnos
            WHERE Activo = 1
              AND UPPER(LTRIM(RTRIM(Codigo))) IN ({string.Join(", ", parameterNames)})
            """,
            connection);

        for (var index = 0; index < codigos.Count; index++)
        {
            command.Parameters.AddWithValue(parameterNames[index], codigos[index]);
        }

        await using var reader = await command.ExecuteReaderAsync(cancellationToken);
        while (await reader.ReadAsync(cancellationToken))
        {
            var codigo = reader["Codigo"]?.ToString() ?? string.Empty;
            var nombre = reader["Nombre"]?.ToString() ?? string.Empty;
            alumnosByCode[NormalizeCode(codigo)] = (codigo.Trim(), nombre.Trim());
        }

        return alumnosByCode;
    }

    private static string NormalizeCode(string value) => value.Trim().ToUpperInvariant();

    private static string NormalizeTheme(string? value)
    {
        var theme = value?.Trim().ToLowerInvariant() ?? string.Empty;
        return AllowedThemes.Contains(theme) ? theme : "imperius";
    }
}
