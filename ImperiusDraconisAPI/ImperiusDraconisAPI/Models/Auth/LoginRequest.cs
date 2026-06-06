using System.ComponentModel.DataAnnotations;

namespace ImperiusDraconisAPI.Models.Auth;

public sealed class LoginRequest
{
    [Required]
    public string Codigo { get; set; } = string.Empty;

    [Required]
    public string Contrasena { get; set; } = string.Empty;
}
