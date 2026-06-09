using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;
using System.Text.Encodings.Web;
using ImperiusDraconisAPI.Configuration;
using Microsoft.AspNetCore.Authentication;
using Microsoft.Extensions.Options;

namespace ImperiusDraconisAPI.Security;

public sealed class GameApiKeyAuthenticationHandler : AuthenticationHandler<AuthenticationSchemeOptions>
{
    private readonly GameOptions _gameOptions;

    public GameApiKeyAuthenticationHandler(
        IOptionsMonitor<AuthenticationSchemeOptions> options,
        ILoggerFactory logger,
        UrlEncoder encoder,
        IOptions<GameOptions> gameOptions)
        : base(options, logger, encoder)
    {
        _gameOptions = gameOptions.Value;
    }

    protected override Task<AuthenticateResult> HandleAuthenticateAsync()
    {
        if (!Request.Headers.TryGetValue(GameApiKeyAuthenticationDefaults.HeaderName, out var providedValues)
            || providedValues.Count != 1)
        {
            return Task.FromResult(AuthenticateResult.NoResult());
        }

        if (string.IsNullOrWhiteSpace(_gameOptions.ApiKey))
        {
            return Task.FromResult(AuthenticateResult.Fail("La autenticacion Game API Key no esta configurada."));
        }

        var providedKey = providedValues[0] ?? string.Empty;
        var expectedBytes = SHA256.HashData(Encoding.UTF8.GetBytes(_gameOptions.ApiKey));
        var providedBytes = SHA256.HashData(Encoding.UTF8.GetBytes(providedKey));

        if (!CryptographicOperations.FixedTimeEquals(expectedBytes, providedBytes))
        {
            return Task.FromResult(AuthenticateResult.Fail("Game API Key invalida."));
        }

        var identity = new ClaimsIdentity(
            [new Claim(ClaimTypes.NameIdentifier, "roblox-server")],
            GameApiKeyAuthenticationDefaults.AuthenticationScheme);
        var principal = new ClaimsPrincipal(identity);
        var ticket = new AuthenticationTicket(principal, GameApiKeyAuthenticationDefaults.AuthenticationScheme);

        return Task.FromResult(AuthenticateResult.Success(ticket));
    }
}
