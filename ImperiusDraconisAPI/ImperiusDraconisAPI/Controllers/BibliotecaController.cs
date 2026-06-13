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
        CancellationToken cancellationToken)
    {
        var idAlumnoClaim = User.Claims.FirstOrDefault(claim => claim.Type == ClaimTypes.NameIdentifier)?.Value;
        if (!int.TryParse(idAlumnoClaim, out var idAlumno))
        {
            return Unauthorized();
        }

        var libros = await _bibliotecaService.ObtenerLibrosAsync(idAlumno, categoriaId, busqueda, cancellationToken);
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
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult> LeerLibro(int id, [FromQuery] string? accessKey, CancellationToken cancellationToken)
    {
        var idAlumnoClaim = User.Claims.FirstOrDefault(claim => claim.Type == ClaimTypes.NameIdentifier)?.Value;
        if (!int.TryParse(idAlumnoClaim, out var idAlumno))
        {
            return Unauthorized();
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
        // El script 013 guarda la ruta como: "Libros/PDF/..." o "Libros/EPUB/..."
        var pathSegments = rutaRelativa.Split(new[] { '/', '\\' }, StringSplitOptions.RemoveEmptyEntries);
        var baseDir = Path.Combine(_environment.ContentRootPath, "..", "Biblioteca");
        var absolutePath = Path.Combine(baseDir, Path.Combine(pathSegments));

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
}
