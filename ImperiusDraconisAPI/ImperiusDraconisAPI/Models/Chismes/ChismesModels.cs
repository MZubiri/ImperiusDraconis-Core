using Microsoft.AspNetCore.Http;

namespace ImperiusDraconisAPI.Models.Chismes;

public sealed class ChismeDto
{
    public int IdChisme { get; init; }

    public int IdAlumno { get; init; }

    public string CodigoAlumno { get; init; } = string.Empty;

    public string AlumnoNombre { get; init; } = string.Empty;

    public string Texto { get; init; } = string.Empty;

    public DateTime FechaEnvio { get; init; }

    public string[] Imagenes { get; init; } = Array.Empty<string>();
}

public sealed class ChismeQuery
{
    public DateTime? FechaInicio { get; init; }

    public DateTime? FechaFin { get; init; }

    public int Pagina { get; init; } = 1;

    public int RegistrosPorPagina { get; init; } = 30;
}

public sealed class CreateChismeRequest
{
    public string Texto { get; init; } = string.Empty;

    public IReadOnlyList<IFormFile> Imagenes { get; init; } = Array.Empty<IFormFile>();
}

public sealed class ChismeCreateResultDto
{
    public int IdChisme { get; init; }

    public DateTime FechaEnvio { get; init; }

    public int DracoinsOtorgados { get; init; }

    public string Message { get; init; } = string.Empty;

    public string[] Imagenes { get; init; } = Array.Empty<string>();
}
