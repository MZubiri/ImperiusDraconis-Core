namespace ImperiusDraconisAPI.Models.Auth;

public sealed class RecoverPasswordResponse
{
    public bool PasswordUpdated { get; init; }

    public bool EmailSent { get; init; }

    public string Message { get; init; } = string.Empty;

    public string? TemporaryPasswordPreview { get; init; }
}
