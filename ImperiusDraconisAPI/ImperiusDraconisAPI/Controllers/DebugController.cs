using System.ComponentModel.DataAnnotations;
using System.Net.Http.Json;
using System.Text.Json;
using Microsoft.AspNetCore.Mvc;

namespace ImperiusDraconisAPI.Controllers;

[ApiController]
[Route("api/debug")]
public sealed class DebugController : ControllerBase
{
    private const string GeminiModel = "gemini-2.5-flash";
    private static readonly string GeminiGenerateContentUrl =
        $"https://generativelanguage.googleapis.com/v1beta/models/{GeminiModel}:generateContent";

    private readonly IConfiguration _configuration;
    private readonly IHttpClientFactory _httpClientFactory;
    private readonly ILogger<DebugController> _logger;

    public DebugController(
        IConfiguration configuration,
        IHttpClientFactory httpClientFactory,
        ILogger<DebugController> logger)
    {
        _configuration = configuration;
        _httpClientFactory = httpClientFactory;
        _logger = logger;
    }

    [HttpGet("gemini")]
    [ProducesResponseType(typeof(object), StatusCodes.Status200OK)]
    public ActionResult<object> GetGeminiConfiguration()
    {
        return Ok(new
        {
            configured = !string.IsNullOrWhiteSpace(_configuration["GEMINI_API_KEY"])
        });
    }

    [HttpPost("gemini-test")]
    [ProducesResponseType(typeof(object), StatusCodes.Status200OK)]
    public async Task<ActionResult<object>> TestGemini(
        [FromBody] GeminiTestRequest request,
        CancellationToken cancellationToken)
    {
        var apiKey = _configuration["GEMINI_API_KEY"];
        if (string.IsNullOrWhiteSpace(apiKey))
        {
            _logger.LogWarning("Gemini test solicitado, pero GEMINI_API_KEY no esta configurada.");
            return BadRequest(new { error = "GEMINI_API_KEY no esta configurada." });
        }

        if (string.IsNullOrWhiteSpace(request.Texto))
        {
            return BadRequest(new { error = "El campo texto es obligatorio." });
        }

        try
        {
            _logger.LogInformation("Probando conectividad con Gemini usando el modelo {Model}.", GeminiModel);

            using var httpRequest = new HttpRequestMessage(HttpMethod.Post, GeminiGenerateContentUrl);
            httpRequest.Headers.Add("x-goog-api-key", apiKey);
            httpRequest.Content = JsonContent.Create(new
            {
                contents = new[]
                {
                    new
                    {
                        parts = new[]
                        {
                            new { text = request.Texto }
                        }
                    }
                }
            });

            using var response = await _httpClientFactory.CreateClient().SendAsync(httpRequest, cancellationToken);
            var content = await response.Content.ReadAsStringAsync(cancellationToken);
            if (!response.IsSuccessStatusCode)
            {
                var error = ReadGeminiErrorSummary(content);
                _logger.LogWarning(
                    "Gemini devolvio error HTTP {StatusCode}: {Error}",
                    (int)response.StatusCode,
                    error);
                return StatusCode(StatusCodes.Status502BadGateway, new { error });
            }

            var answer = ReadGeminiAnswer(content);
            _logger.LogInformation("Gemini respondio correctamente.");
            return Ok(new { respuesta = answer });
        }
        catch (OperationCanceledException) when (cancellationToken.IsCancellationRequested)
        {
            throw;
        }
        catch (Exception exception)
        {
            _logger.LogError(exception, "Error probando conectividad con Gemini.");
            return StatusCode(StatusCodes.Status502BadGateway, new { error = "No se pudo conectar con Gemini." });
        }
    }

    private static string ReadGeminiAnswer(string content)
    {
        using var document = JsonDocument.Parse(content);
        var root = document.RootElement;
        if (!root.TryGetProperty("candidates", out var candidates) ||
            candidates.ValueKind != JsonValueKind.Array ||
            candidates.GetArrayLength() == 0)
        {
            return string.Empty;
        }

        var builder = new List<string>();
        if (candidates[0].TryGetProperty("content", out var candidateContent) &&
            candidateContent.TryGetProperty("parts", out var parts) &&
            parts.ValueKind == JsonValueKind.Array)
        {
            foreach (var part in parts.EnumerateArray())
            {
                if (part.TryGetProperty("text", out var textProperty))
                {
                    var text = textProperty.GetString();
                    if (!string.IsNullOrEmpty(text))
                    {
                        builder.Add(text);
                    }
                }
            }
        }

        return string.Concat(builder).Trim();
    }

    private static string ReadGeminiErrorSummary(string content)
    {
        try
        {
            using var document = JsonDocument.Parse(content);
            if (document.RootElement.TryGetProperty("error", out var error))
            {
                if (error.TryGetProperty("message", out var message))
                {
                    return Truncate(message.GetString() ?? "Gemini devolvio un error.");
                }

                if (error.TryGetProperty("status", out var status))
                {
                    return Truncate(status.GetString() ?? "Gemini devolvio un error.");
                }
            }
        }
        catch (JsonException)
        {
            // Fallback below.
        }

        return Truncate(string.IsNullOrWhiteSpace(content) ? "Gemini devolvio un error." : content);
    }

    private static string Truncate(string value)
    {
        const int maxLength = 300;
        var trimmed = value.Trim();
        return trimmed.Length <= maxLength ? trimmed : $"{trimmed[..maxLength]}...";
    }

    public sealed class GeminiTestRequest
    {
        [Required]
        public string Texto { get; set; } = string.Empty;
    }
}
