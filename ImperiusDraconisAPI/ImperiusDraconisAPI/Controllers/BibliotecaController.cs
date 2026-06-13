using System.Security.Claims;
using ImperiusDraconisAPI.Common;
using ImperiusDraconisAPI.Models.Biblioteca;
using ImperiusDraconisAPI.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace ImperiusDraconisAPI.Controllers;

[ApiController]
[Authorize]
[Route("api/[controller]")]
public sealed class BibliotecaController : ControllerBase
{
    private readonly BibliotecaService _bibliotecaService;
    private readonly IWebHostEnvironment _environment;

    public BibliotecaController(BibliotecaService bibliotecaService, IWebHostEnvironment environment)
    {
        _bibliotecaService = bibliotecaService;
        _environment = environment;
    }

    [AllowAnonymous]
    [HttpPost("unlock")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public ActionResult Unlock([FromBody] UnlockBibliotecaRequest request)
    {
        var isValid = _bibliotecaService.ValidarPassword(request.Password);
        if (!isValid)
        {
            return BadRequest(new { success = false, message = "Contraseña de biblioteca incorrecta." });
        }

        return Ok(new { success = true, token = "HermioneAccessGranted" });
    }

    [HttpGet("categorias")]
    [ProducesResponseType(typeof(IReadOnlyList<BibliotecaCategoriaDto>), StatusCodes.Status200OK)]
    public async Task<ActionResult<IReadOnlyList<BibliotecaCategoriaDto>>> GetCategorias(CancellationToken cancellationToken)
    {
        var categorias = await _bibliotecaService.ObtenerCategoriasAsync(cancellationToken);
        return Ok(categorias);
    }

    [HttpGet("libros")]
    [ProducesResponseType(typeof(IReadOnlyList<BibliotecaLibroDto>), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<ActionResult<IReadOnlyList<BibliotecaLibroDto>>> GetLibros(
        [FromQuery] int? categoriaId,
        [FromQuery] string? busqueda,
        [FromQuery] bool soloMisLibros = false,
        CancellationToken cancellationToken = default)
    {
        var idAlumnoClaim = User.Claims.FirstOrDefault(claim => claim.Type == ClaimTypes.NameIdentifier)?.Value;
        if (!int.TryParse(idAlumnoClaim, out var idAlumno))
        {
            return Unauthorized();
        }

        var libros = await _bibliotecaService.ObtenerLibrosAsync(idAlumno, categoriaId, busqueda, soloMisLibros, cancellationToken);
        return Ok(libros);
    }

    [HttpPost("comprar/{id:int}")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<ActionResult> ComprarLibro(int id, CancellationToken cancellationToken)
    {
        var idAlumnoClaim = User.Claims.FirstOrDefault(claim => claim.Type == ClaimTypes.NameIdentifier)?.Value;
        if (!int.TryParse(idAlumnoClaim, out var idAlumno))
        {
            return Unauthorized();
        }

        try
        {
            var success = await _bibliotecaService.ComprarLibroAsync(idAlumno, id, cancellationToken);
            return Ok(new { success, message = "Libro adquirido correctamente." });
        }
        catch (BusinessRuleException exception)
        {
            return BadRequest(new { message = exception.Message });
        }
    }

    [HttpGet("leer/{id:int}")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult> LeerLibro(int id, [FromQuery] string? accessKey, CancellationToken cancellationToken)
    {
        var idAlumnoClaim = User.Claims.FirstOrDefault(claim => claim.Type == ClaimTypes.NameIdentifier)?.Value;
        if (!int.TryParse(idAlumnoClaim, out var idAlumno))
        {
            return Unauthorized();
        }

        if (!EsAdministrador())
        {
            var tieneAcceso = await _bibliotecaService.ValidarAccesoLecturaAsync(idAlumno, id, cancellationToken);
            if (!tieneAcceso)
            {
                return Forbid();
            }
        }

        // Obtener la ruta del archivo relativa
        var rutaRelativa = await _bibliotecaService.ObtenerRutaArchivoLibroAsync(id, cancellationToken);
        if (string.IsNullOrWhiteSpace(rutaRelativa))
        {
            return NotFound(new { message = "El libro no existe o no está activo." });
        }

        // Construir la ruta física completa
        // Los libros están guardados físicamente en: /home/guss/Desktop/Proyectos/IDNUEVO/Biblioteca/Libros/...
        // que equivale a: {RootPath}/Biblioteca/Libros/...
        // El script 013 guarda la ruta como: "PDF/..." o "EPUB/...", por lo que puede faltar el prefijo "Libros".
        var pathSegments = rutaRelativa.Split(new[] { '/', '\\' }, StringSplitOptions.RemoveEmptyEntries);
        var baseDir = Path.Combine(_environment.ContentRootPath, "..", "Biblioteca");
        var absolutePath = Path.Combine(baseDir, Path.Combine(pathSegments));

        if (!System.IO.File.Exists(absolutePath))
        {
            // Intentar buscar dentro de la subcarpeta "Libros" si no está presente en la ruta
            if (pathSegments.Length > 0 && !pathSegments[0].Equals("Libros", StringComparison.OrdinalIgnoreCase))
            {
                var fallbackSegments = new List<string> { "Libros" };
                fallbackSegments.AddRange(pathSegments);
                var fallbackPath = Path.Combine(baseDir, Path.Combine(fallbackSegments.ToArray()));
                if (System.IO.File.Exists(fallbackPath))
                {
                    absolutePath = fallbackPath;
                }
            }
        }

        if (!System.IO.File.Exists(absolutePath))
        {
            // Intentar buscar directamente en Biblioteca/ si el path ya incluye Biblioteca/
            absolutePath = Path.Combine(_environment.ContentRootPath, "..", Path.Combine(pathSegments));
            if (!System.IO.File.Exists(absolutePath))
            {
                return NotFound(new { message = $"El archivo físico del libro no se encuentra en el servidor. Ruta buscada: {absolutePath}" });
            }
        }

        var contentType = Path.GetExtension(absolutePath).ToLowerInvariant() switch
        {
            ".pdf" => "application/pdf",
            ".epub" => "application/epub+zip",
            _ => "application/octet-stream"
        };

        return PhysicalFile(absolutePath, contentType, enableRangeProcessing: true);
    }

    [HttpGet("descargar/{id:int}")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult> DescargarLibro(int id, CancellationToken cancellationToken)
    {
        var idAlumnoClaim = User.Claims.FirstOrDefault(claim => claim.Type == ClaimTypes.NameIdentifier)?.Value;
        if (!int.TryParse(idAlumnoClaim, out var idAlumno))
        {
            return Unauthorized();
        }

        var esAdmin = EsAdministrador();
        var (success, message, rutaRelativa) = await _bibliotecaService.ValidarYObtenerRutaDescargaAsync(idAlumno, id, esAdmin, cancellationToken);
        
        if (!success || string.IsNullOrWhiteSpace(rutaRelativa))
        {
            return BadRequest(new { message });
        }

        // Resolver la ruta física del archivo
        var pathSegments = rutaRelativa.Split(new[] { '/', '\\' }, StringSplitOptions.RemoveEmptyEntries);
        var baseDir = Path.Combine(_environment.ContentRootPath, "..", "Biblioteca");
        var absolutePath = Path.Combine(baseDir, Path.Combine(pathSegments));

        if (!System.IO.File.Exists(absolutePath))
        {
            if (pathSegments.Length > 0 && !pathSegments[0].Equals("Libros", StringComparison.OrdinalIgnoreCase))
            {
                var fallbackSegments = new List<string> { "Libros" };
                fallbackSegments.AddRange(pathSegments);
                var fallbackPath = Path.Combine(baseDir, Path.Combine(fallbackSegments.ToArray()));
                if (System.IO.File.Exists(fallbackPath))
                {
                    absolutePath = fallbackPath;
                }
            }
        }

        if (!System.IO.File.Exists(absolutePath))
        {
            absolutePath = Path.Combine(_environment.ContentRootPath, "..", Path.Combine(pathSegments));
            if (!System.IO.File.Exists(absolutePath))
            {
                return NotFound(new { message = "El archivo físico del libro no se encuentra en el servidor." });
            }
        }

        var contentType = Path.GetExtension(absolutePath).ToLowerInvariant() switch
        {
            ".pdf" => "application/pdf",
            ".epub" => "application/epub+zip",
            _ => "application/octet-stream"
        };

        var fileName = Path.GetFileName(absolutePath);
        return PhysicalFile(absolutePath, contentType, fileName, enableRangeProcessing: true);
    }

    [HttpGet("suscripcion")]
    [ProducesResponseType(typeof(SuscripcionStatusDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<ActionResult<SuscripcionStatusDto>> GetSuscripcion(CancellationToken cancellationToken)
    {
        var idAlumnoClaim = User.Claims.FirstOrDefault(claim => claim.Type == ClaimTypes.NameIdentifier)?.Value;
        if (!int.TryParse(idAlumnoClaim, out var idAlumno))
        {
            return Unauthorized();
        }

        var status = await _bibliotecaService.ObtenerDetalleSuscripcionAsync(idAlumno, cancellationToken);
        return Ok(status);
    }

    [HttpPost("suscribirse")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<ActionResult> Suscribirse(CancellationToken cancellationToken)
    {
        var idAlumnoClaim = User.Claims.FirstOrDefault(claim => claim.Type == ClaimTypes.NameIdentifier)?.Value;
        if (!int.TryParse(idAlumnoClaim, out var idAlumno))
        {
            return Unauthorized();
        }

        try
        {
            var success = await _bibliotecaService.SuscribirseAsync(idAlumno, cancellationToken);
            return Ok(new { success, message = "Te has suscrito correctamente por una semana." });
        }
        catch (BusinessRuleException exception)
        {
            return BadRequest(new { message = exception.Message });
        }
    }

    // --- ENDPOINTS CRUD DE LIBRERÍA (Para Administradores / Maestres) ---

    private bool EsAdministrador()
    {
        return User.Claims.Any(c => c.Type == "permission" && c.Value.Equals("Biblioteca:Admin", StringComparison.OrdinalIgnoreCase)) 
               || User.Claims.Any(c => c.Type == ClaimTypes.Role && c.Value.Equals("Maestre", StringComparison.OrdinalIgnoreCase));
    }

    [HttpPost("libros")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<ActionResult> CrearLibro([FromBody] SaveLibroRequest request, CancellationToken cancellationToken)
    {
        if (!EsAdministrador())
        {
            return Forbid();
        }

        var success = await _bibliotecaService.CrearLibroAsync(request, cancellationToken);
        if (!success)
        {
            return BadRequest(new { message = "No se pudo crear el libro." });
        }

        return Ok(new { success, message = "Libro creado con éxito." });
    }

    [HttpPut("libros/{id:int}")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<ActionResult> ActualizarLibro(int id, [FromBody] SaveLibroRequest request, CancellationToken cancellationToken)
    {
        if (!EsAdministrador())
        {
            return Forbid();
        }

        var success = await _bibliotecaService.ActualizarLibroAsync(id, request, cancellationToken);
        if (!success)
        {
            return BadRequest(new { message = "No se pudo actualizar el libro." });
        }

        return Ok(new { success, message = "Libro actualizado con éxito." });
    }

    [HttpDelete("libros/{id:int}")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<ActionResult> EliminarLibro(int id, CancellationToken cancellationToken)
    {
        if (!EsAdministrador())
        {
            return Forbid();
        }

        var success = await _bibliotecaService.EliminarLibroAsync(id, cancellationToken);
        if (!success)
        {
            return BadRequest(new { message = "No se pudo eliminar el libro." });
        }

        return Ok(new { success, message = "Libro eliminado con éxito." });
    }

    [HttpGet("exportar")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    public async Task<ActionResult> ExportarLibros(CancellationToken cancellationToken)
    {
        if (!EsAdministrador())
        {
            return Forbid();
        }

        var bytes = await _bibliotecaService.ExportarLibrosExcelAsync(cancellationToken);
        return File(
            bytes, 
            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", 
            $"grimorios_exportados_{DateTime.Now:yyyyMMdd_HHmmss}.xlsx");
    }

    [HttpPost("importar")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<ActionResult> ImportarLibros(IFormFile file, CancellationToken cancellationToken)
    {
        if (!EsAdministrador())
        {
            return Forbid();
        }

        if (file == null || file.Length == 0)
        {
            return BadRequest(new { message = "Por favor, sube un archivo de Excel (.xlsx) valido." });
        }

        if (!Path.GetExtension(file.FileName).Equals(".xlsx", StringComparison.OrdinalIgnoreCase))
        {
            return BadRequest(new { message = "El formato de archivo debe ser .xlsx (Excel)." });
        }

        try
        {
            using var stream = file.OpenReadStream();
            var count = await _bibliotecaService.ImportarLibrosExcelAsync(stream, cancellationToken);
            return Ok(new { success = true, count, message = $"Se procesaron {count} libros correctamente (creados/actualizados)." });
        }
        catch (Exception exception)
        {
            return BadRequest(new { message = $"Error al leer el archivo Excel: {exception.Message}" });
        }
    }
}
