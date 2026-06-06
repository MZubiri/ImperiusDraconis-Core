namespace ImperiusDraconisAPI.Models.Perfil;

public sealed class ChangeMyPasswordRequest
{
    public string ContrasenaActual { get; init; } = string.Empty;

    public string NuevaContrasena { get; init; } = string.Empty;
}
