using System.Data;
using System.Globalization;
using System.IdentityModel.Tokens.Jwt;
using System.Net;
using System.Net.Mail;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;
using ImperiusDraconisAPI.Common;
using ImperiusDraconisAPI.Configuration;
using ImperiusDraconisAPI.Data;
using ImperiusDraconisAPI.Models.Auth;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;

namespace ImperiusDraconisAPI.Services;

public sealed class AuthService
{
    private const string PasswordColumn = "[Contraseña]";
    private readonly SqlConnectionFactory _connectionFactory;
    private readonly JwtOptions _jwtOptions;
    private readonly SmtpOptions _smtpOptions;
    private readonly AuthRecoveryOptions _authRecoveryOptions;
    private readonly IHostEnvironment _hostEnvironment;

    public AuthService(
        SqlConnectionFactory connectionFactory,
        IOptions<JwtOptions> jwtOptions,
        IOptions<SmtpOptions> smtpOptions,
        IOptions<AuthRecoveryOptions> authRecoveryOptions,
        IHostEnvironment hostEnvironment)
    {
        _connectionFactory = connectionFactory;
        _jwtOptions = jwtOptions.Value;
        _smtpOptions = smtpOptions.Value;
        _authRecoveryOptions = authRecoveryOptions.Value;
        _hostEnvironment = hostEnvironment;
    }

    public async Task<LoginResponse?> LoginAsync(LoginRequest request, CancellationToken cancellationToken)
    {
        var codigo = request.Codigo.Trim();
        var hashedPassword = PasswordHasher.HashPassword(request.Contrasena);

        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        using var command = new SqlCommand("ValidarLogin", connection)
        {
            CommandType = CommandType.StoredProcedure
        };
        command.Parameters.AddWithValue("@Codigo", codigo);
        command.Parameters.AddWithValue("@Contraseña", hashedPassword);

        int? idAlumno = null;
        using (var reader = await command.ExecuteReaderAsync(cancellationToken))
        {
            if (await reader.ReadAsync(cancellationToken))
            {
                idAlumno = GetRequiredInt(reader, "IdAlumno");
            }
        }

        if (!idAlumno.HasValue)
        {
            return null;
        }

        var user = await GetCurrentUserAsync(connection, idAlumno.Value, cancellationToken);
        if (user is null)
        {
            return null;
        }

        var expiresAt = DateTimeOffset.UtcNow.AddMinutes(_jwtOptions.ExpirationMinutes);

        return new LoginResponse
        {
            Token = BuildToken(user, expiresAt),
            ExpiresAt = expiresAt,
            User = user
        };
    }

    public async Task<AuthenticatedUserDto?> GetCurrentUserAsync(int idAlumno, CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);
        return await GetCurrentUserAsync(connection, idAlumno, cancellationToken);
    }

    public async Task<RecoverPasswordResponse> RecoverPasswordAsync(
        RecoverPasswordRequest request,
        CancellationToken cancellationToken)
    {
        var correo = request.Correo.Trim();
        if (string.IsNullOrWhiteSpace(correo))
        {
            throw new BusinessRuleException("Debes ingresar un correo electronico valido.");
        }

        var canExposePreview = CanExposeTemporaryPassword();
        var smtpConfigured = IsSmtpConfigured();

        if (!smtpConfigured && !canExposePreview)
        {
            throw new BusinessRuleException(
                "La recuperacion de contrasena no esta disponible porque el correo no esta configurado.");
        }

        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        RecoveryTargetDto? target = null;
        using (var command = new SqlCommand(
                   """
                   SELECT TOP 1
                       IdAlumno,
                       Codigo,
                       Nombre,
                       CorreoElectronico
                   FROM Alumnos
                   WHERE Activo = 1
                     AND LTRIM(RTRIM(ISNULL(CorreoElectronico, ''))) = @Correo
                   """,
                   connection))
        {
            command.Parameters.AddWithValue("@Correo", correo);

            using var reader = await command.ExecuteReaderAsync(cancellationToken);
            if (await reader.ReadAsync(cancellationToken))
            {
                target = new RecoveryTargetDto
                {
                    IdAlumno = GetRequiredInt(reader, "IdAlumno"),
                    Codigo = GetString(reader, "Codigo"),
                    Nombre = GetString(reader, "Nombre"),
                    Correo = GetString(reader, "CorreoElectronico")
                };
            }
        }

        if (target is null)
        {
            throw new BusinessRuleException("No se encontro un usuario activo con ese correo.");
        }

        var temporaryPassword = GenerateTemporaryPassword();
        using (var updateCommand = new SqlCommand(
                   $"UPDATE Alumnos SET {PasswordColumn} = @Contrasena WHERE IdAlumno = @IdAlumno",
                   connection))
        {
            updateCommand.Parameters.AddWithValue("@Contrasena", PasswordHasher.HashPassword(temporaryPassword));
            updateCommand.Parameters.AddWithValue("@IdAlumno", target.IdAlumno);
            await updateCommand.ExecuteNonQueryAsync(cancellationToken);
        }

        var emailSent = false;
        string message;

        if (smtpConfigured)
        {
            try
            {
                await SendRecoveryEmailAsync(target, temporaryPassword, cancellationToken);
                emailSent = true;
                message = "Se envio una nueva contrasena temporal al correo registrado.";
            }
            catch (Exception exception)
            {
                message =
                    $"La contrasena se actualizo, pero no se pudo enviar el correo: {exception.Message}";
            }
        }
        else
        {
            message =
                "Se genero una contrasena temporal, pero el correo no esta configurado en este entorno.";
        }

        return new RecoverPasswordResponse
        {
            PasswordUpdated = true,
            EmailSent = emailSent,
            Message = message,
            TemporaryPasswordPreview = canExposePreview ? temporaryPassword : null
        };
    }

    private async Task<AuthenticatedUserDto?> GetCurrentUserAsync(
        SqlConnection connection,
        int idAlumno,
        CancellationToken cancellationToken)
    {
        using var command = new SqlCommand(
            """
            SELECT
                A.IdAlumno,
                A.Codigo,
                A.Nombre,
                A.IdCasa,
                C.Nombre AS CasaNombre,
                A.IdCargo,
                ISNULL(CG.Nombre, '') AS CargoNombre,
                ISNULL(A.Categoria, 'Alumno') AS Categoria,
                A.Genero,
                A.FotoPerfil,
                A.Dracoins
            FROM Alumnos A
            LEFT JOIN Casas C ON C.IdCasa = A.IdCasa
            LEFT JOIN Cargos CG ON CG.IdCargo = A.IdCargo
            WHERE A.IdAlumno = @IdAlumno
              AND A.Activo = 1
            """,
            connection);
        command.Parameters.AddWithValue("@IdAlumno", idAlumno);

        AuthenticatedUserDto? baseUser = null;
        using (var reader = await command.ExecuteReaderAsync(cancellationToken))
        {
            if (!await reader.ReadAsync(cancellationToken))
            {
                return null;
            }

            baseUser = new AuthenticatedUserDto
            {
                IdAlumno = GetRequiredInt(reader, "IdAlumno"),
                Codigo = GetString(reader, "Codigo"),
                Nombre = GetString(reader, "Nombre"),
                IdCasa = GetNullableInt(reader, "IdCasa"),
                CasaNombre = GetString(reader, "CasaNombre"),
                IdCargo = GetNullableInt(reader, "IdCargo"),
                CargoNombre = GetString(reader, "CargoNombre"),
                Categoria = GetString(reader, "Categoria"),
                Genero = GetString(reader, "Genero"),
                FotoPerfil = GetString(reader, "FotoPerfil"),
                Dracoins = GetDecimal(reader, "Dracoins")
            };
        }

        var trabajos = await GetTrabajosAsync(connection, baseUser.IdAlumno, cancellationToken);
        var permisos = await GetPermisosAsync(connection, baseUser.IdCargo, trabajos, cancellationToken);

        return new AuthenticatedUserDto
        {
            IdAlumno = baseUser.IdAlumno,
            Codigo = baseUser.Codigo,
            Nombre = baseUser.Nombre,
            IdCasa = baseUser.IdCasa,
            CasaNombre = baseUser.CasaNombre,
            IdCargo = baseUser.IdCargo,
            CargoNombre = baseUser.CargoNombre,
            Categoria = baseUser.Categoria,
            Genero = baseUser.Genero,
            FotoPerfil = baseUser.FotoPerfil,
            Dracoins = baseUser.Dracoins,
            Trabajos = trabajos.ToArray(),
            Permisos = permisos.ToArray()
        };
    }

    private async Task<IReadOnlyList<int>> GetTrabajosAsync(
        SqlConnection connection,
        int idAlumno,
        CancellationToken cancellationToken)
    {
        var trabajos = new List<int>();
        using var command = new SqlCommand(
            "SELECT IdTrabajo FROM AlumnosTrabajos WHERE IdAlumno = @IdAlumno",
            connection);
        command.Parameters.AddWithValue("@IdAlumno", idAlumno);

        using var reader = await command.ExecuteReaderAsync(cancellationToken);
        while (await reader.ReadAsync(cancellationToken))
        {
            trabajos.Add(GetRequiredInt(reader, "IdTrabajo"));
        }

        return trabajos;
    }

    private async Task<IReadOnlyList<string>> GetPermisosAsync(
        SqlConnection connection,
        int? idCargo,
        IReadOnlyCollection<int> trabajos,
        CancellationToken cancellationToken)
    {
        var permisos = new HashSet<string>(StringComparer.OrdinalIgnoreCase)
        {
            "Dracoins:Index",
            "Dracoins:TransferirDracoins",
            "Dracoins:HistorialTransferencias"
        };

        if (idCargo.HasValue)
        {
            using var cargoCommand = new SqlCommand(
                """
                SELECT DISTINCT Controlador + ':' + Accion AS Permiso
                FROM Permisos
                WHERE IdCargo = @IdCargo AND TienePermiso = 1
                """,
                connection);
            cargoCommand.Parameters.AddWithValue("@IdCargo", idCargo.Value);

            using var cargoReader = await cargoCommand.ExecuteReaderAsync(cancellationToken);
            while (await cargoReader.ReadAsync(cancellationToken))
            {
                permisos.Add(GetString(cargoReader, "Permiso"));
            }
        }

        if (trabajos.Count > 0)
        {
            var parameterNames = trabajos
                .Select((_, index) => $"@Trabajo{index}")
                .ToArray();

            var sql =
                $"""
                SELECT DISTINCT Controlador + ':' + Accion AS Permiso
                FROM PermisosTrabajos
                WHERE TienePermiso = 1
                  AND IdTrabajo IN ({string.Join(", ", parameterNames)})
                """;

            using var trabajosCommand = new SqlCommand(sql, connection);
            for (var index = 0; index < trabajos.Count; index++)
            {
                trabajosCommand.Parameters.AddWithValue(parameterNames[index], trabajos.ElementAt(index));
            }

            using var trabajosReader = await trabajosCommand.ExecuteReaderAsync(cancellationToken);
            while (await trabajosReader.ReadAsync(cancellationToken))
            {
                permisos.Add(GetString(trabajosReader, "Permiso"));
            }
        }

        return permisos.OrderBy(value => value).ToArray();
    }

    private bool IsSmtpConfigured() =>
        !string.IsNullOrWhiteSpace(_smtpOptions.Host) &&
        _smtpOptions.Port > 0 &&
        !string.IsNullOrWhiteSpace(_smtpOptions.Username) &&
        !string.IsNullOrWhiteSpace(_smtpOptions.Password) &&
        !string.IsNullOrWhiteSpace(_smtpOptions.FromEmail);

    private bool CanExposeTemporaryPassword() =>
        _hostEnvironment.IsDevelopment() && _authRecoveryOptions.ExposeTemporaryPasswordInDevelopment;

    private async Task SendRecoveryEmailAsync(
        RecoveryTargetDto target,
        string temporaryPassword,
        CancellationToken cancellationToken)
    {
        using var message = new MailMessage
        {
            From = new MailAddress(_smtpOptions.FromEmail, _smtpOptions.FromName),
            Subject = "Recuperacion de contrasena - Imperius Draconis",
            Body = BuildRecoveryEmailBody(target.Nombre, temporaryPassword),
            IsBodyHtml = true
        };
        message.To.Add(target.Correo);

        using var client = new SmtpClient(_smtpOptions.Host, _smtpOptions.Port)
        {
            Credentials = new NetworkCredential(_smtpOptions.Username, _smtpOptions.Password),
            EnableSsl = _smtpOptions.EnableSsl,
            Timeout = 10000
        };

        cancellationToken.ThrowIfCancellationRequested();
        await client.SendMailAsync(message, cancellationToken);
    }

    private static string BuildRecoveryEmailBody(string nombre, string temporaryPassword) =>
        $"""
        <html>
        <body style="font-family: Georgia, serif; background: #fdf8f2; color: #2e2c29; line-height: 1.6;">
          <div style="max-width: 600px; margin: 20px auto; padding: 24px; background: #fffaf3; border: 2px solid #bfa046; border-radius: 12px;">
            <h2 style="margin-top: 0; color: #7f0909; text-align: center;">Recuperacion de contrasena</h2>
            <p>Hola <strong>{WebUtility.HtmlEncode(nombre)}</strong>,</p>
            <p>Generamos una nueva contrasena temporal para tu acceso a Imperius Draconis.</p>
            <div style="margin: 20px 0; padding: 12px; text-align: center; border: 2px dashed #bfa046; background: #ffffff; color: #1a472a; font-size: 20px; font-weight: bold;">
              {WebUtility.HtmlEncode(temporaryPassword)}
            </div>
            <p>Ingresa lo antes posible y cambiala desde tu perfil.</p>
            <p style="font-size: 12px; color: #555; text-align: center; margin-top: 24px;">
              Imperius Draconis<br />
              Este mensaje fue generado automaticamente.
            </p>
          </div>
        </body>
        </html>
        """;

    private static string GenerateTemporaryPassword()
    {
        const string alphabet = "ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz23456789";
        Span<byte> buffer = stackalloc byte[10];
        RandomNumberGenerator.Fill(buffer);

        var result = new char[10];
        for (var index = 0; index < result.Length; index++)
        {
            result[index] = alphabet[buffer[index] % alphabet.Length];
        }

        return new string(result);
    }

    private string BuildToken(AuthenticatedUserDto user, DateTimeOffset expiresAt)
    {
        var claims = new List<Claim>
        {
            new(JwtRegisteredClaimNames.Sub, user.IdAlumno.ToString(CultureInfo.InvariantCulture)),
            new(JwtRegisteredClaimNames.UniqueName, user.Codigo),
            new(ClaimTypes.NameIdentifier, user.IdAlumno.ToString(CultureInfo.InvariantCulture)),
            new(ClaimTypes.Name, user.Nombre),
            new("codigo", user.Codigo),
            new("categoria", user.Categoria),
            new("casa_nombre", user.CasaNombre),
            new("cargo_nombre", user.CargoNombre),
            new("genero", user.Genero),
            new("foto_perfil", user.FotoPerfil),
            new("dracoins", user.Dracoins.ToString(CultureInfo.InvariantCulture))
        };

        if (user.IdCasa.HasValue)
        {
            claims.Add(new Claim("id_casa", user.IdCasa.Value.ToString(CultureInfo.InvariantCulture)));
        }

        if (user.IdCargo.HasValue)
        {
            claims.Add(new Claim("id_cargo", user.IdCargo.Value.ToString(CultureInfo.InvariantCulture)));
        }

        if (!string.IsNullOrWhiteSpace(user.CargoNombre))
        {
            claims.Add(new Claim(ClaimTypes.Role, user.CargoNombre));
        }

        claims.AddRange(
            user.Trabajos.Select(trabajo =>
                new Claim("trabajo", trabajo.ToString(CultureInfo.InvariantCulture))));
        claims.AddRange(user.Permisos.Select(permiso => new Claim("permission", permiso)));

        var signingCredentials = new SigningCredentials(
            new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_jwtOptions.SecretKey)),
            SecurityAlgorithms.HmacSha256);

        var token = new JwtSecurityToken(
            issuer: _jwtOptions.Issuer,
            audience: _jwtOptions.Audience,
            claims: claims,
            notBefore: DateTime.UtcNow,
            expires: expiresAt.UtcDateTime,
            signingCredentials: signingCredentials);

        return new JwtSecurityTokenHandler().WriteToken(token);
    }

    private static string GetString(SqlDataReader reader, string columnName) =>
        reader[columnName] == DBNull.Value ? string.Empty : reader[columnName]?.ToString() ?? string.Empty;

    private static int GetRequiredInt(SqlDataReader reader, string columnName) =>
        Convert.ToInt32(reader[columnName], CultureInfo.InvariantCulture);

    private static int? GetNullableInt(SqlDataReader reader, string columnName) =>
        reader[columnName] == DBNull.Value
            ? null
            : Convert.ToInt32(reader[columnName], CultureInfo.InvariantCulture);

    private static decimal GetDecimal(SqlDataReader reader, string columnName) =>
        reader[columnName] == DBNull.Value
            ? 0m
            : Convert.ToDecimal(reader[columnName], CultureInfo.InvariantCulture);

    private sealed class RecoveryTargetDto
    {
        public int IdAlumno { get; init; }

        public string Codigo { get; init; } = string.Empty;

        public string Nombre { get; init; } = string.Empty;

        public string Correo { get; init; } = string.Empty;
    }
}
