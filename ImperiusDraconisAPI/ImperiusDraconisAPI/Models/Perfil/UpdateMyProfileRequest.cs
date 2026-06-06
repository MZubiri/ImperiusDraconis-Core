namespace ImperiusDraconisAPI.Models.Perfil;

using Microsoft.AspNetCore.Http;

public sealed class UpdateMyProfileRequest
{
    public string? Telefono { get; init; }

    public string? CorreoElectronico { get; init; }

    public DateTime? Cumpleanos { get; init; }

    public string? Pais { get; init; }

    public string? PrefijoPais { get; init; }

    public string? ZonaHoraria { get; init; }

    public string? FotoPerfil { get; init; }
}

public sealed class UploadProfileImageRequest
{
    public IFormFile? FotoArchivo { get; init; }
}

public sealed class UploadProfileImageResponse
{
    public string FotoPerfil { get; init; } = string.Empty;
}
