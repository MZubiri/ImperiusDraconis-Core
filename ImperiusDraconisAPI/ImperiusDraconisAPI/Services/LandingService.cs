using System.Globalization;
using System.Net;
using System.Text.RegularExpressions;
using ImperiusDraconisAPI.Common;
using ImperiusDraconisAPI.Data;
using ImperiusDraconisAPI.Models.Landing;
using Microsoft.Data.SqlClient;

namespace ImperiusDraconisAPI.Services;

public sealed partial class LandingService
{
    private static readonly Dictionary<string, int> FixedSlotCounts = new(StringComparer.OrdinalIgnoreCase)
    {
        ["PLATA"] = 4,
        ["ORO"] = 1,
        ["INSTAGRAM"] = 2,
        ["TIKTOK"] = 2,
        ["ESCAPE"] = 3
    };

    private readonly SqlConnectionFactory _connectionFactory;
    private readonly LegacyAssetStorage _assetStorage;

    public LandingService(SqlConnectionFactory connectionFactory, LegacyAssetStorage assetStorage)
    {
        _connectionFactory = connectionFactory;
        _assetStorage = assetStorage;
    }

    public async Task<LandingPageDto> GetPublicAsync(CancellationToken cancellationToken)
    {
        var data = await GetDataAsync(includeInactive: false, cancellationToken);
        var houses = await GetMainHousesAsync(cancellationToken);
        return new LandingPageDto
        {
            Configuracion = data.Configuracion,
            DragonesPlata = EnsureSilverSlots(data.DragonesPlata, houses),
            DragonOro = data.DragonOro is { Activo: true } ? data.DragonOro : null,
            Instagram = data.Instagram,
            Tiktok = data.Tiktok,
            Gaceta = data.Gaceta,
            EscapeRooms = data.EscapeRooms
        };
    }

    public async Task<LandingAdminDto> GetAdminAsync(CancellationToken cancellationToken)
    {
        var data = await GetDataAsync(includeInactive: true, cancellationToken);
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        var houses = new List<LandingHouseOptionDto>();
        using var command = new SqlCommand(
            """
            SELECT IdCasa, Nombre, ISNULL(Color, '') AS Color
            FROM Casas
            WHERE LOWER(LTRIM(RTRIM(Nombre))) <> 'id'
            ORDER BY Nombre
            """,
            connection);
        using var reader = await command.ExecuteReaderAsync(cancellationToken);
        while (await reader.ReadAsync(cancellationToken))
        {
            houses.Add(new LandingHouseOptionDto
            {
                IdCasa = GetRequiredInt(reader, "IdCasa"),
                Nombre = GetString(reader, "Nombre"),
                Color = GetString(reader, "Color")
            });
        }
        await reader.CloseAsync();

        var orderedHouses = OrderMainHouses(houses);
        var students = new List<LandingStudentOptionDto>();
        using (var studentCommand = new SqlCommand(
                   """
                   SELECT
                       A.IdAlumno,
                       A.Codigo,
                       A.Nombre,
                       ISNULL(NULLIF(LTRIM(RTRIM(A.FotoPerfil)), ''), '~/Content/FotosPerfil/default.jpg') AS FotoPerfil,
                       A.IdCasa,
                       C.Nombre AS CasaNombre
                   FROM Alumnos A
                   INNER JOIN Casas C ON C.IdCasa = A.IdCasa
                   WHERE A.Activo = 1
                     AND LOWER(LTRIM(RTRIM(C.Nombre))) <> 'id'
                   ORDER BY C.Nombre, A.Nombre
                   """,
                   connection))
        {
            using var studentReader = await studentCommand.ExecuteReaderAsync(cancellationToken);
            while (await studentReader.ReadAsync(cancellationToken))
            {
                students.Add(new LandingStudentOptionDto
                {
                    IdAlumno = GetRequiredInt(studentReader, "IdAlumno"),
                    Codigo = GetString(studentReader, "Codigo"),
                    Nombre = GetString(studentReader, "Nombre"),
                    FotoPerfil = GetString(studentReader, "FotoPerfil"),
                    IdCasa = GetRequiredInt(studentReader, "IdCasa"),
                    CasaNombre = GetString(studentReader, "CasaNombre")
                });
            }
        }

        return new LandingAdminDto
        {
            Configuracion = data.Configuracion,
            DragonesPlata = EnsureSilverSlots(data.DragonesPlata, orderedHouses),
            DragonOro = data.DragonOro ?? EmptyItem("ORO", 1),
            Instagram = EnsureSlots(data.Instagram, "INSTAGRAM", 2),
            Tiktok = EnsureSlots(data.Tiktok, "TIKTOK", 2),
            Gaceta = data.Gaceta,
            EscapeRooms = EnsureSlots(data.EscapeRooms, "ESCAPE", 3),
            Casas = orderedHouses,
            AlumnosActivos = students
        };
    }

    public async Task<LandingConfigurationDto> SaveConfigurationAsync(
        SaveLandingConfigurationRequest request,
        CancellationToken cancellationToken)
    {
        var title = RequireText(request.TituloPortada, "El titulo de portada es obligatorio.", 160);
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        if (request.IdCasaGanadora.HasValue)
        {
            using var houseCommand = new SqlCommand(
                "SELECT COUNT(*) FROM Casas WHERE IdCasa = @IdCasa",
                connection);
            houseCommand.Parameters.AddWithValue("@IdCasa", request.IdCasaGanadora.Value);
            if (Convert.ToInt32(await houseCommand.ExecuteScalarAsync(cancellationToken), CultureInfo.InvariantCulture) == 0)
            {
                throw new BusinessRuleException("La casa ganadora seleccionada no existe.");
            }
        }

        using (var command = new SqlCommand(
                   """
                   UPDATE LandingConfiguracion
                   SET TituloPortada = @TituloPortada,
                       SubtituloPortada = @SubtituloPortada,
                       IdCasaGanadora = @IdCasaGanadora,
                       TituloCopa = @TituloCopa,
                       DescripcionCopa = @DescripcionCopa,
                       FechaActualizacion = SYSUTCDATETIME()
                   WHERE IdConfiguracion = 1
                   """,
                   connection))
        {
            command.Parameters.AddWithValue("@TituloPortada", title);
            command.Parameters.AddWithValue("@SubtituloPortada", DbValue(request.SubtituloPortada));
            command.Parameters.AddWithValue("@IdCasaGanadora", (object?)request.IdCasaGanadora ?? DBNull.Value);
            command.Parameters.AddWithValue("@TituloCopa", DbValue(request.TituloCopa));
            command.Parameters.AddWithValue("@DescripcionCopa", DbValue(request.DescripcionCopa));
            await command.ExecuteNonQueryAsync(cancellationToken);
        }

        return (await GetDataAsync(includeInactive: true, cancellationToken)).Configuracion;
    }

    public async Task<LandingContentItemDto> SaveContentAsync(
        string type,
        int position,
        SaveLandingContentRequest request,
        CancellationToken cancellationToken)
    {
        var normalizedType = NormalizeType(type);
        ValidatePosition(normalizedType, position);

        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        var imageUrl = request.ImagenUrlActual?.Trim() ?? string.Empty;
        if (request.ImagenFile is { Length: > 0 })
        {
            imageUrl = await _assetStorage.SaveImageAsync(
                request.ImagenFile,
                Path.Combine("Content", "landing"),
                cancellationToken);
        }

        var idAlumno = normalizedType == "PLATA" ? request.IdAlumno : null;
        var title = Limit(request.Titulo, 160);
        var description = Limit(request.Descripcion, 600);
        var meta = Limit(request.Meta, 160);
        var link = NormalizeLink(normalizedType, request.EnlaceOEmbed);
        var active = normalizedType == "PLATA" || request.Activo;

        if (normalizedType == "PLATA")
        {
            var houses = await GetMainHousesAsync(connection, cancellationToken);
            var expectedHouse = houses.ElementAtOrDefault(position - 1)
                ?? throw new BusinessRuleException("No se encontro la casa asignada a este lugar.");
            var student = await GetActiveStudentAsync(connection, idAlumno, cancellationToken)
                ?? throw new BusinessRuleException("Selecciona un alumno activo para este lugar.");

            if (student.IdCasa != expectedHouse.IdCasa)
            {
                throw new BusinessRuleException($"El alumno seleccionado debe pertenecer a {expectedHouse.Nombre}.");
            }

            title = student.Nombre;
            imageUrl = student.FotoPerfil;
            meta = student.CasaNombre;
            description = string.Empty;
        }

        if (active)
        {
            ValidateActiveContent(normalizedType, title, imageUrl, link);
        }

        using (var command = new SqlCommand(
                   """
                   MERGE LandingContenido AS Target
                   USING (SELECT @Tipo AS Tipo, @Posicion AS Posicion) AS Source
                   ON Target.Tipo = Source.Tipo AND Target.Posicion = Source.Posicion
                   WHEN MATCHED THEN UPDATE SET
                       Titulo = @Titulo,
                       IdAlumno = @IdAlumno,
                       Descripcion = @Descripcion,
                       Meta = @Meta,
                       ImagenUrl = @ImagenUrl,
                       EnlaceUrl = @EnlaceUrl,
                       Activo = @Activo,
                       FechaActualizacion = SYSUTCDATETIME()
                   WHEN NOT MATCHED THEN INSERT
                       (Tipo, Posicion, IdAlumno, Titulo, Descripcion, Meta, ImagenUrl, EnlaceUrl, Activo)
                       VALUES
                       (@Tipo, @Posicion, @IdAlumno, @Titulo, @Descripcion, @Meta, @ImagenUrl, @EnlaceUrl, @Activo);
                   """,
                   connection))
        {
            command.Parameters.AddWithValue("@Tipo", normalizedType);
            command.Parameters.AddWithValue("@Posicion", position);
            command.Parameters.AddWithValue("@IdAlumno", (object?)idAlumno ?? DBNull.Value);
            command.Parameters.AddWithValue("@Titulo", DbValue(title));
            command.Parameters.AddWithValue("@Descripcion", DbValue(description));
            command.Parameters.AddWithValue("@Meta", DbValue(meta));
            command.Parameters.AddWithValue("@ImagenUrl", DbValue(imageUrl));
            command.Parameters.AddWithValue("@EnlaceUrl", DbValue(link));
            command.Parameters.AddWithValue("@Activo", active);
            await command.ExecuteNonQueryAsync(cancellationToken);
        }

        return await GetItemAsync(connection, normalizedType, position, cancellationToken)
            ?? throw new InvalidOperationException("No se pudo recuperar el contenido guardado.");
    }

    public async Task<bool> DeleteGazetteAsync(int position, CancellationToken cancellationToken)
    {
        if (position <= 0)
        {
            return false;
        }

        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);
        using var command = new SqlCommand(
            "DELETE FROM LandingContenido WHERE Tipo = 'GACETA' AND Posicion = @Posicion",
            connection);
        command.Parameters.AddWithValue("@Posicion", position);
        return await command.ExecuteNonQueryAsync(cancellationToken) > 0;
    }

    private async Task<LandingPageDto> GetDataAsync(bool includeInactive, CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        LandingConfigurationDto configuration;
        using (var command = new SqlCommand(
                   """
                   SELECT
                       L.TituloPortada,
                       ISNULL(L.SubtituloPortada, '') AS SubtituloPortada,
                       L.IdCasaGanadora,
                       ISNULL(C.Nombre, '') AS CasaGanadora,
                       ISNULL(C.Color, '') AS CasaColor,
                       ISNULL(L.TituloCopa, '') AS TituloCopa,
                       ISNULL(L.DescripcionCopa, '') AS DescripcionCopa,
                       L.FechaActualizacion
                   FROM LandingConfiguracion L
                   LEFT JOIN Casas C ON C.IdCasa = L.IdCasaGanadora
                   WHERE L.IdConfiguracion = 1
                   """,
                   connection))
        {
            using var reader = await command.ExecuteReaderAsync(cancellationToken);
            if (!await reader.ReadAsync(cancellationToken))
            {
                throw new InvalidOperationException("La configuracion de la landing no existe.");
            }

            configuration = new LandingConfigurationDto
            {
                TituloPortada = GetString(reader, "TituloPortada"),
                SubtituloPortada = GetString(reader, "SubtituloPortada"),
                IdCasaGanadora = GetNullableInt(reader, "IdCasaGanadora"),
                CasaGanadora = GetString(reader, "CasaGanadora"),
                CasaColor = GetString(reader, "CasaColor"),
                TituloCopa = GetString(reader, "TituloCopa"),
                DescripcionCopa = GetString(reader, "DescripcionCopa"),
                FechaActualizacion = GetNullableDateTime(reader, "FechaActualizacion")
            };
        }

        var items = new List<LandingContentItemDto>();
        using (var command = new SqlCommand(
                   $"""
                   SELECT
                       LC.IdContenido,
                       LC.Tipo,
                       LC.Posicion,
                       LC.IdAlumno,
                       A.IdCasa,
                       ISNULL(C.Nombre, '') AS CasaNombre,
                       CASE WHEN LC.Tipo = 'PLATA' THEN ISNULL(A.Nombre, '') ELSE ISNULL(LC.Titulo, '') END AS Titulo,
                       ISNULL(LC.Descripcion, '') AS Descripcion,
                       CASE WHEN LC.Tipo = 'PLATA' THEN ISNULL(C.Nombre, '') ELSE ISNULL(LC.Meta, '') END AS Meta,
                       CASE WHEN LC.Tipo = 'PLATA' THEN ISNULL(NULLIF(LTRIM(RTRIM(A.FotoPerfil)), ''), '~/Content/FotosPerfil/default.jpg') ELSE ISNULL(LC.ImagenUrl, '') END AS ImagenUrl,
                       ISNULL(LC.EnlaceUrl, '') AS EnlaceUrl,
                       LC.Activo
                   FROM LandingContenido LC
                   LEFT JOIN Alumnos A ON A.IdAlumno = LC.IdAlumno
                   LEFT JOIN Casas C ON C.IdCasa = A.IdCasa
                   {(includeInactive ? string.Empty : "WHERE LC.Activo = 1")}
                   ORDER BY LC.Tipo, LC.Posicion
                   """,
                   connection))
        {
            using var reader = await command.ExecuteReaderAsync(cancellationToken);
            while (await reader.ReadAsync(cancellationToken))
            {
                items.Add(MapItem(reader));
            }
        }

        return BuildPage(configuration, items);
    }

    private static LandingPageDto BuildPage(
        LandingConfigurationDto configuration,
        IReadOnlyCollection<LandingContentItemDto> items)
    {
        var gold = items.FirstOrDefault(item => item.Tipo == "ORO");
        return new LandingPageDto
        {
            Configuracion = configuration,
            DragonesPlata = ByType(items, "PLATA"),
            DragonOro = gold,
            Instagram = ByType(items, "INSTAGRAM"),
            Tiktok = ByType(items, "TIKTOK"),
            Gaceta = ByType(items, "GACETA"),
            EscapeRooms = ByType(items, "ESCAPE")
        };
    }

    private static LandingContentItemDto[] ByType(
        IEnumerable<LandingContentItemDto> items,
        string type) =>
        items.Where(item => item.Tipo == type).OrderBy(item => item.Posicion).ToArray();

    private static IReadOnlyCollection<LandingContentItemDto> EnsureSlots(
        IEnumerable<LandingContentItemDto> items,
        string type,
        int count)
    {
        var lookup = items.ToDictionary(item => item.Posicion);
        return Enumerable.Range(1, count)
            .Select(position => lookup.GetValueOrDefault(position) ?? EmptyItem(type, position))
            .ToArray();
    }

    private static LandingContentItemDto EmptyItem(string type, int position) =>
        new() { Tipo = type, Posicion = position };

    private static IReadOnlyCollection<LandingContentItemDto> EnsureSilverSlots(
        IEnumerable<LandingContentItemDto> items,
        IReadOnlyList<LandingHouseOptionDto> houses)
    {
        var lookup = items.ToDictionary(item => item.Posicion);
        return Enumerable.Range(1, 4)
            .Select(position =>
            {
                var house = houses.ElementAtOrDefault(position - 1);
                var item = lookup.GetValueOrDefault(position);
                return item is null
                    ? new LandingContentItemDto
                    {
                        Tipo = "PLATA",
                        Posicion = position,
                        IdCasa = house?.IdCasa,
                        CasaNombre = house?.Nombre ?? string.Empty,
                        Meta = house?.Nombre ?? string.Empty
                    }
                    : new LandingContentItemDto
                    {
                        IdContenido = item.IdContenido,
                        Tipo = item.Tipo,
                        Posicion = item.Posicion,
                        IdAlumno = item.IdAlumno,
                        IdCasa = house?.IdCasa ?? item.IdCasa,
                        CasaNombre = house?.Nombre ?? item.CasaNombre,
                        Titulo = item.Titulo,
                        Descripcion = item.Descripcion,
                        Meta = house?.Nombre ?? item.Meta,
                        ImagenUrl = item.ImagenUrl,
                        EnlaceUrl = item.EnlaceUrl,
                        Activo = item.Activo
                    };
            })
            .ToArray();
    }

    private static async Task<LandingContentItemDto?> GetItemAsync(
        SqlConnection connection,
        string type,
        int position,
        CancellationToken cancellationToken)
    {
        using var command = new SqlCommand(
            """
            SELECT
                LC.IdContenido,
                LC.Tipo,
                LC.Posicion,
                LC.IdAlumno,
                A.IdCasa,
                ISNULL(C.Nombre, '') AS CasaNombre,
                CASE WHEN LC.Tipo = 'PLATA' THEN ISNULL(A.Nombre, '') ELSE ISNULL(LC.Titulo, '') END AS Titulo,
                ISNULL(LC.Descripcion, '') AS Descripcion,
                CASE WHEN LC.Tipo = 'PLATA' THEN ISNULL(C.Nombre, '') ELSE ISNULL(LC.Meta, '') END AS Meta,
                CASE WHEN LC.Tipo = 'PLATA' THEN ISNULL(NULLIF(LTRIM(RTRIM(A.FotoPerfil)), ''), '~/Content/FotosPerfil/default.jpg') ELSE ISNULL(LC.ImagenUrl, '') END AS ImagenUrl,
                ISNULL(LC.EnlaceUrl, '') AS EnlaceUrl,
                LC.Activo
            FROM LandingContenido LC
            LEFT JOIN Alumnos A ON A.IdAlumno = LC.IdAlumno
            LEFT JOIN Casas C ON C.IdCasa = A.IdCasa
            WHERE LC.Tipo = @Tipo AND LC.Posicion = @Posicion
            """,
            connection);
        command.Parameters.AddWithValue("@Tipo", type);
        command.Parameters.AddWithValue("@Posicion", position);
        using var reader = await command.ExecuteReaderAsync(cancellationToken);
        return await reader.ReadAsync(cancellationToken) ? MapItem(reader) : null;
    }

    private static LandingContentItemDto MapItem(SqlDataReader reader) =>
        new()
        {
            IdContenido = GetRequiredInt(reader, "IdContenido"),
            Tipo = GetString(reader, "Tipo"),
            Posicion = GetRequiredInt(reader, "Posicion"),
            IdAlumno = GetNullableInt(reader, "IdAlumno"),
            IdCasa = GetNullableInt(reader, "IdCasa"),
            CasaNombre = GetString(reader, "CasaNombre"),
            Titulo = GetString(reader, "Titulo"),
            Descripcion = GetString(reader, "Descripcion"),
            Meta = GetString(reader, "Meta"),
            ImagenUrl = GetString(reader, "ImagenUrl"),
            EnlaceUrl = GetString(reader, "EnlaceUrl"),
            Activo = GetBoolean(reader, "Activo")
        };

    private async Task<IReadOnlyList<LandingHouseOptionDto>> GetMainHousesAsync(
        CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);
        return await GetMainHousesAsync(connection, cancellationToken);
    }

    private static async Task<IReadOnlyList<LandingHouseOptionDto>> GetMainHousesAsync(
        SqlConnection connection,
        CancellationToken cancellationToken)
    {
        var houses = new List<LandingHouseOptionDto>();
        using var command = new SqlCommand(
            """
            SELECT IdCasa, Nombre, ISNULL(Color, '') AS Color
            FROM Casas
            WHERE LOWER(LTRIM(RTRIM(Nombre))) <> 'id'
            """,
            connection);
        using var reader = await command.ExecuteReaderAsync(cancellationToken);
        while (await reader.ReadAsync(cancellationToken))
        {
            houses.Add(new LandingHouseOptionDto
            {
                IdCasa = GetRequiredInt(reader, "IdCasa"),
                Nombre = GetString(reader, "Nombre"),
                Color = GetString(reader, "Color")
            });
        }

        return OrderMainHouses(houses);
    }

    private static IReadOnlyList<LandingHouseOptionDto> OrderMainHouses(
        IEnumerable<LandingHouseOptionDto> houses) =>
        houses
            .OrderBy(house => HouseOrder(house.Nombre))
            .ThenBy(house => house.Nombre)
            .Take(4)
            .ToArray();

    private static int HouseOrder(string houseName)
    {
        var normalized = houseName.Trim().ToLowerInvariant();
        if (normalized.Contains("gryffindor", StringComparison.Ordinal)) return 1;
        if (normalized.Contains("slytherin", StringComparison.Ordinal)) return 2;
        if (normalized.Contains("ravenclaw", StringComparison.Ordinal)) return 3;
        if (normalized.Contains("hufflepuff", StringComparison.Ordinal)) return 4;
        return 100;
    }

    private static async Task<LandingStudentLookup?> GetActiveStudentAsync(
        SqlConnection connection,
        int? idAlumno,
        CancellationToken cancellationToken)
    {
        if (!idAlumno.HasValue || idAlumno <= 0)
        {
            return null;
        }

        using var command = new SqlCommand(
            """
            SELECT
                A.IdAlumno,
                A.Nombre,
                ISNULL(NULLIF(LTRIM(RTRIM(A.FotoPerfil)), ''), '~/Content/FotosPerfil/default.jpg') AS FotoPerfil,
                A.IdCasa,
                C.Nombre AS CasaNombre
            FROM Alumnos A
            INNER JOIN Casas C ON C.IdCasa = A.IdCasa
            WHERE A.IdAlumno = @IdAlumno
              AND A.Activo = 1
            """,
            connection);
        command.Parameters.AddWithValue("@IdAlumno", idAlumno.Value);
        using var reader = await command.ExecuteReaderAsync(cancellationToken);
        if (!await reader.ReadAsync(cancellationToken))
        {
            return null;
        }

        return new LandingStudentLookup(
            GetRequiredInt(reader, "IdAlumno"),
            GetString(reader, "Nombre"),
            GetString(reader, "FotoPerfil"),
            GetRequiredInt(reader, "IdCasa"),
            GetString(reader, "CasaNombre"));
    }

    private static string NormalizeType(string type)
    {
        var normalized = type.Trim().ToUpperInvariant();
        if (!FixedSlotCounts.ContainsKey(normalized) && normalized != "GACETA")
        {
            throw new BusinessRuleException("El tipo de contenido no es valido.");
        }

        return normalized;
    }

    private static void ValidatePosition(string type, int position)
    {
        if (position <= 0 || (FixedSlotCounts.TryGetValue(type, out var count) && position > count))
        {
            throw new BusinessRuleException("La posicion indicada no es valida.");
        }

        if (type == "GACETA" && position > 12)
        {
            throw new BusinessRuleException("La gaceta admite hasta 12 imagenes.");
        }
    }

    private static void ValidateActiveContent(string type, string title, string imageUrl, string link)
    {
        if (type is "PLATA" or "ORO" && (string.IsNullOrWhiteSpace(title) || string.IsNullOrWhiteSpace(imageUrl)))
        {
            throw new BusinessRuleException("Los dragones activos necesitan nombre y foto.");
        }

        if (type is "INSTAGRAM" or "TIKTOK" && string.IsNullOrWhiteSpace(link))
        {
            throw new BusinessRuleException("La publicacion activa necesita un enlace o codigo embed valido.");
        }

        if (type == "ESCAPE" &&
            (string.IsNullOrWhiteSpace(title) || string.IsNullOrWhiteSpace(imageUrl) || string.IsNullOrWhiteSpace(link)))
        {
            throw new BusinessRuleException("El escape room activo necesita titulo, imagen y enlace.");
        }

        if (type == "GACETA" && string.IsNullOrWhiteSpace(imageUrl))
        {
            throw new BusinessRuleException("La publicacion de gaceta activa necesita una imagen.");
        }
    }

    private static string NormalizeLink(string type, string? value)
    {
        var raw = WebUtility.HtmlDecode(value?.Trim() ?? string.Empty);
        if (string.IsNullOrWhiteSpace(raw))
        {
            return string.Empty;
        }

        var url = UrlRegex().Match(raw).Value.TrimEnd(')', ']', ',', ';');
        if (!Uri.TryCreate(url, UriKind.Absolute, out var uri) || uri.Scheme is not ("http" or "https"))
        {
            throw new BusinessRuleException("El enlace ingresado no es valido.");
        }

        if (type == "INSTAGRAM")
        {
            if (!uri.Host.EndsWith("instagram.com", StringComparison.OrdinalIgnoreCase))
            {
                throw new BusinessRuleException("El enlace debe pertenecer a Instagram.");
            }

            var match = InstagramPostRegex().Match(uri.AbsolutePath);
            if (!match.Success)
            {
                throw new BusinessRuleException("No se pudo identificar la publicacion de Instagram.");
            }

            return $"https://www.instagram.com/{match.Groups["kind"].Value}/{match.Groups["code"].Value}/embed";
        }

        if (type == "TIKTOK")
        {
            if (!uri.Host.EndsWith("tiktok.com", StringComparison.OrdinalIgnoreCase))
            {
                throw new BusinessRuleException("El enlace debe pertenecer a TikTok.");
            }

            var match = TiktokVideoRegex().Match(uri.AbsolutePath);
            if (!match.Success)
            {
                throw new BusinessRuleException("No se pudo identificar el video de TikTok.");
            }

            return $"https://www.tiktok.com/player/v1/{match.Groups["id"].Value}";
        }

        return uri.ToString();
    }

    private static string RequireText(string? value, string message, int maxLength)
    {
        var normalized = Limit(value, maxLength);
        return string.IsNullOrWhiteSpace(normalized) ? throw new BusinessRuleException(message) : normalized;
    }

    private static string Limit(string? value, int maxLength)
    {
        var normalized = value?.Trim() ?? string.Empty;
        return normalized.Length > maxLength ? normalized[..maxLength] : normalized;
    }

    private static object DbValue(string? value) =>
        string.IsNullOrWhiteSpace(value) ? DBNull.Value : value.Trim();

    private static string GetString(SqlDataReader reader, string columnName) =>
        reader[columnName] == DBNull.Value ? string.Empty : reader[columnName]?.ToString() ?? string.Empty;

    private static int GetRequiredInt(SqlDataReader reader, string columnName) =>
        Convert.ToInt32(reader[columnName], CultureInfo.InvariantCulture);

    private static int? GetNullableInt(SqlDataReader reader, string columnName) =>
        reader[columnName] == DBNull.Value ? null : Convert.ToInt32(reader[columnName], CultureInfo.InvariantCulture);

    private static bool GetBoolean(SqlDataReader reader, string columnName) =>
        reader[columnName] != DBNull.Value && Convert.ToBoolean(reader[columnName], CultureInfo.InvariantCulture);

    private static DateTime? GetNullableDateTime(SqlDataReader reader, string columnName) =>
        reader[columnName] == DBNull.Value
            ? null
            : Convert.ToDateTime(reader[columnName], CultureInfo.InvariantCulture);

    [GeneratedRegex(@"https?://[^\s""'<>]+", RegexOptions.IgnoreCase)]
    private static partial Regex UrlRegex();

    [GeneratedRegex(@"/(?<kind>p|reel|tv)/(?<code>[\w-]+)", RegexOptions.IgnoreCase)]
    private static partial Regex InstagramPostRegex();

    [GeneratedRegex(@"/video/(?<id>\d+)", RegexOptions.IgnoreCase)]
    private static partial Regex TiktokVideoRegex();

    private sealed record LandingStudentLookup(
        int IdAlumno,
        string Nombre,
        string FotoPerfil,
        int IdCasa,
        string CasaNombre);
}
