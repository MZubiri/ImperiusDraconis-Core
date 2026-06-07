using System.Diagnostics;
using System.Net.Http.Json;
using System.Text.Json;
using ImperiusDraconisAPI.Common;

namespace ImperiusDraconisAPI.Services;

public sealed class GeminiFormatCorrectionService
{
    private const string GeminiModel = "gemini-2.5-flash";
    private static readonly string GeminiGenerateContentUrl =
        $"https://generativelanguage.googleapis.com/v1beta/models/{GeminiModel}:generateContent";

    private readonly IConfiguration _configuration;
    private readonly IHttpClientFactory _httpClientFactory;
    private readonly ILogger<GeminiFormatCorrectionService> _logger;

    public GeminiFormatCorrectionService(
        IConfiguration configuration,
        IHttpClientFactory httpClientFactory,
        ILogger<GeminiFormatCorrectionService> logger)
    {
        _configuration = configuration;
        _httpClientFactory = httpClientFactory;
        _logger = logger;
    }

    public async Task<string> CorrectAsync(
        int userId,
        string tipo,
        string texto,
        CancellationToken cancellationToken)
    {
        var apiKey = _configuration["GEMINI_API_KEY"];
        if (string.IsNullOrWhiteSpace(apiKey))
        {
            _logger.LogWarning("Correccion IA solicitada, pero GEMINI_API_KEY no esta configurada.");
            throw new BusinessRuleException("No fue posible generar una sugerencia en este momento.");
        }

        var normalizedType = tipo.Trim().ToLowerInvariant();
        if (normalizedType is not ("puntos" or "dracoins"))
        {
            throw new BusinessRuleException("El tipo solo puede ser puntos o dracoins.");
        }

        var stopwatch = Stopwatch.StartNew();
        try
        {
            _logger.LogInformation(
                "Solicitud de correccion IA. Usuario={UserId}, Tipo={Tipo}, Longitud={Length}.",
                userId,
                normalizedType,
                texto.Length);

            using var request = new HttpRequestMessage(HttpMethod.Post, GeminiGenerateContentUrl);
            request.Headers.Add("x-goog-api-key", apiKey);
            request.Content = JsonContent.Create(new
            {
                contents = new[]
                {
                    new
                    {
                        parts = new[]
                        {
                            new { text = BuildPrompt(normalizedType, texto) }
                        }
                    }
                },
                generationConfig = new
                {
                    temperature = 0.1,
                    topP = 0.8,
                    maxOutputTokens = 8192
                }
            });

            using var timeoutCts = CancellationTokenSource.CreateLinkedTokenSource(cancellationToken);
            timeoutCts.CancelAfter(TimeSpan.FromSeconds(30));

            using var response = await _httpClientFactory.CreateClient().SendAsync(request, timeoutCts.Token);
            var content = await response.Content.ReadAsStringAsync(cancellationToken);
            _logger.LogInformation(
                "Gemini correccion IA respondio. Usuario={UserId}, Tipo={Tipo}, StatusCode={StatusCode}, TiempoMs={ElapsedMs}.",
                userId,
                normalizedType,
                (int)response.StatusCode,
                stopwatch.ElapsedMilliseconds);

            if (!response.IsSuccessStatusCode)
            {
                _logger.LogWarning(
                    "Gemini fallo en correccion IA. Usuario={UserId}, Tipo={Tipo}, Error={Error}.",
                    userId,
                    normalizedType,
                    ReadGeminiErrorSummary(content));
                throw new BusinessRuleException("No fue posible generar una sugerencia en este momento.");
            }

            if (!TryReadGeminiAnswer(content, out var correctedText) || string.IsNullOrWhiteSpace(correctedText))
            {
                _logger.LogWarning(
                    "Gemini no devolvio texto util para correccion IA. Usuario={UserId}, Tipo={Tipo}.",
                    userId,
                    normalizedType);
                throw new BusinessRuleException("No fue posible generar una sugerencia en este momento.");
            }

            _logger.LogInformation(
                "Correccion IA generada correctamente. Usuario={UserId}, Tipo={Tipo}, TiempoMs={ElapsedMs}, LongitudRespuesta={ResponseLength}.",
                userId,
                normalizedType,
                stopwatch.ElapsedMilliseconds,
                correctedText.Length);

            return CleanModelOutput(correctedText);
        }
        catch (OperationCanceledException) when (cancellationToken.IsCancellationRequested)
        {
            throw;
        }
        catch (BusinessRuleException)
        {
            throw;
        }
        catch (Exception exception)
        {
            _logger.LogError(
                exception,
                "Error generando correccion IA. Usuario={UserId}, Tipo={Tipo}, TiempoMs={ElapsedMs}.",
                userId,
                tipo,
                stopwatch.ElapsedMilliseconds);
            throw new BusinessRuleException("No fue posible generar una sugerencia en este momento.");
        }
    }

    private static string BuildPrompt(string tipo, string texto)
    {
        var specificRules = tipo == "puntos" ? PointsRules : DracoinsRules;
        return $"""
            Tu tarea es normalizar el formato de una dinamica de Imperius Draconis.

            No calcules puntos.
            No calcules Dracoins.
            No inventes rondas.
            No inventes participantes.
            No elimines participantes.
            No cambies nombres.
            No cambies emojis.
            No cambies el orden de los participantes.
            No agregues explicacion.
            No agregues comentarios.
            No agregues markdown.
            No agregues encabezados.
            Devuelve unicamente el texto corregido.
            Si el texto ya es valido, devuelvelo practicamente igual.

            {specificRules}

            TEXTO ORIGINAL:
            {texto}
            """;
    }

    private const string PointsRules = """
        Esta dinamica es de puntos de casas.

        Conserva exactamente estos emojis de casas:
        ❤️
        ❤
        💚
        💙
        💛

        Conserva sapos con formato:
        Casa🐸 Dueño - Nombre

        Conserva lechuzas con formato:
        Casa🦉Dueño - Nombre

        Una lechuza tambien puede quedar como:
        Casa🦉 TextoLechuza

        Regla para lechuzas sin casa antes:
        Si detectas 🦉 sin un emoji de casa inmediatamente antes, busca el primer emoji de casa disponible despues de 🦉 en esa misma ronda.
        Casas validas para esta regla:
        ❤️
        ❤
        💚
        💙
        💛

        Si encuentras una casa despues de 🦉:
        Mueve esa casa antes de 🦉.
        Quita esa misma aparicion de su posicion original.
        No dupliques la casa.
        Conserva el resto de emojis en el mismo orden.
        No inventes casa.
        No cambies el nombre ni el texto de la lechuza.

        Ejemplo:
        9. 🦉 Arquimedez Criiz 💙💙💛💚
        debe convertirse en:
        9. 💙🦉 Arquimedez Criiz 💙💛💚

        Ejemplo:
        9. 🦉 Ale - Piper 💚💙💛❤️
        debe convertirse en:
        9. 💚🦉 Ale - Piper 💙💛❤️

        Si la lechuza ya tiene casa antes, no modifiques esa parte:
        9. 💚🦉 Ale - Piper 💙💛❤️

        Si no hay ninguna casa despues de 🦉 en la misma ronda, deja el texto como esta y no inventes nada.

        Conserva multiplicadores:
        doble
        dobles
        x2
        triple
        triples
        x3

        Conserva rondas anuladas:
        ❌
        //

        Si detectas rondas pegadas o mal separadas, separalas correctamente.
        Si detectas espacios extra o saltos de linea incorrectos, corrigelos.
        No conviertas emojis de casas en texto.
        No cambies el orden de los emojis de casa dentro de cada ronda.
        """;

    private const string DracoinsRules = """
        Esta dinamica es de Dracoins.

        Los participantes son emojis, simbolos o grupos.
        No son casas.
        No son alumnos.
        No intentes identificar personas reales.
        Conserva cualquier emoji o simbolo participante.
        Conserva grupos entre parentesis como una sola unidad.

        Ejemplo:
        (🐶🐭)

        debe mantenerse como:
        (🐶🐭)

        Conserva multiplicadores:
        doble
        dobles
        x2
        *2
        triple
        triples
        x3
        *3

        El formato esperado es:

        Nombre opcional

        1. linea de top 4
           linea de otros participantes

        2. linea de top 4
           linea de otros participantes

        > DOBLES

        3. linea de top 4
           linea de otros participantes

        > TRIPLES

        Reglas:

        Primera linea de cada ronda: top 4.
        Segunda linea de cada ronda: participantes restantes.
        Lineas con notas pueden contener DOBLES/TRIPLES/x2/x3.
        No cambies emojis.
        No cambies grupos entre parentesis.
        No separes un grupo entre parentesis.
        No conviertas emojis en texto.
        No elimines participantes repetidos.
        """;

    private static bool TryReadGeminiAnswer(string content, out string answer)
    {
        answer = string.Empty;
        try
        {
            using var document = JsonDocument.Parse(content);
            if (!document.RootElement.TryGetProperty("candidates", out var candidates) ||
                candidates.ValueKind != JsonValueKind.Array ||
                candidates.GetArrayLength() == 0)
            {
                return false;
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
                        if (!string.IsNullOrWhiteSpace(text))
                        {
                            builder.Add(text);
                        }
                    }
                }
            }

            answer = string.Concat(builder).Trim();
            return !string.IsNullOrWhiteSpace(answer);
        }
        catch (JsonException)
        {
            return false;
        }
    }

    private static string ReadGeminiErrorSummary(string content)
    {
        try
        {
            using var document = JsonDocument.Parse(content);
            if (document.RootElement.TryGetProperty("error", out var error) &&
                error.TryGetProperty("message", out var message))
            {
                return Truncate(message.GetString() ?? "Gemini devolvio un error.", 300);
            }
        }
        catch (JsonException)
        {
            // Fallback below.
        }

        return Truncate(string.IsNullOrWhiteSpace(content) ? "Gemini devolvio un error." : content, 300);
    }

    private static string CleanModelOutput(string value)
    {
        var trimmed = value.Trim();
        if (trimmed.StartsWith("```", StringComparison.Ordinal))
        {
            var firstLineEnd = trimmed.IndexOf('\n');
            if (firstLineEnd >= 0)
            {
                trimmed = trimmed[(firstLineEnd + 1)..];
            }

            if (trimmed.EndsWith("```", StringComparison.Ordinal))
            {
                trimmed = trimmed[..^3];
            }
        }

        return trimmed.Trim();
    }

    private static string Truncate(string value, int maxLength)
    {
        var trimmed = value.Trim();
        return trimmed.Length <= maxLength ? trimmed : $"{trimmed[..maxLength]}...";
    }
}
