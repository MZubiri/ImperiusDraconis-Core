using System.ComponentModel.DataAnnotations;

namespace ImperiusDraconisAPI.Models.Auth;

public sealed class RecoverPasswordRequest
{
    [Required]
    [EmailAddress]
    [MaxLength(255)]
    public string Correo { get; set; } = string.Empty;
}
