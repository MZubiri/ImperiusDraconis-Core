using System.ComponentModel.DataAnnotations;
using Microsoft.AspNetCore.Http;

namespace ImperiusDraconisAPI.Models.Landing;

public class LandingPageDto
{
    public LandingConfigurationDto Configuracion { get; init; } = new();
    public IReadOnlyCollection<LandingContentItemDto> DragonesPlata { get; init; } = [];
    public LandingContentItemDto? DragonOro { get; init; }
    public IReadOnlyCollection<LandingContentItemDto> Instagram { get; init; } = [];
    public IReadOnlyCollection<LandingContentItemDto> Tiktok { get; init; } = [];
    public IReadOnlyCollection<LandingContentItemDto> Gaceta { get; init; } = [];
    public IReadOnlyCollection<LandingContentItemDto> EscapeRooms { get; init; } = [];
}

public sealed class LandingAdminDto : LandingPageDto
{
    public IReadOnlyCollection<LandingHouseOptionDto> Casas { get; init; } = [];
    public IReadOnlyCollection<LandingStudentOptionDto> AlumnosActivos { get; init; } = [];
}

public sealed class LandingConfigurationDto
{
    public string TituloPortada { get; init; } = string.Empty;
    public string SubtituloPortada { get; init; } = string.Empty;
    public int? IdCasaGanadora { get; init; }
    public string CasaGanadora { get; init; } = string.Empty;
    public string CasaColor { get; init; } = string.Empty;
    public string TituloCopa { get; init; } = string.Empty;
    public string DescripcionCopa { get; init; } = string.Empty;
    public DateTime? FechaActualizacion { get; init; }
}

public sealed class LandingContentItemDto
{
    public int IdContenido { get; init; }
    public string Tipo { get; init; } = string.Empty;
    public int Posicion { get; init; }
    public int? IdAlumno { get; init; }
    public int? IdCasa { get; init; }
    public string CasaNombre { get; init; } = string.Empty;
    public string Titulo { get; init; } = string.Empty;
    public string Descripcion { get; init; } = string.Empty;
    public string Meta { get; init; } = string.Empty;
    public string ImagenUrl { get; init; } = string.Empty;
    public string EnlaceUrl { get; init; } = string.Empty;
    public bool Activo { get; init; }
}

public sealed class LandingHouseOptionDto
{
    public int IdCasa { get; init; }
    public string Nombre { get; init; } = string.Empty;
    public string Color { get; init; } = string.Empty;
}

public sealed class LandingStudentOptionDto
{
    public int IdAlumno { get; init; }
    public string Codigo { get; init; } = string.Empty;
    public string Nombre { get; init; } = string.Empty;
    public string FotoPerfil { get; init; } = string.Empty;
    public int IdCasa { get; init; }
    public string CasaNombre { get; init; } = string.Empty;
}

public sealed class SaveLandingConfigurationRequest
{
    [Required, MaxLength(160)]
    public string TituloPortada { get; set; } = string.Empty;

    [MaxLength(500)]
    public string? SubtituloPortada { get; set; }

    public int? IdCasaGanadora { get; set; }

    [MaxLength(160)]
    public string? TituloCopa { get; set; }

    [MaxLength(500)]
    public string? DescripcionCopa { get; set; }
}

public sealed class SaveLandingContentRequest
{
    public int? IdAlumno { get; set; }

    [MaxLength(160)]
    public string? Titulo { get; set; }

    [MaxLength(600)]
    public string? Descripcion { get; set; }

    [MaxLength(160)]
    public string? Meta { get; set; }

    [MaxLength(500)]
    public string? ImagenUrlActual { get; set; }

    [MaxLength(5000)]
    public string? EnlaceOEmbed { get; set; }

    public bool Activo { get; set; }

    public IFormFile? ImagenFile { get; set; }
}
