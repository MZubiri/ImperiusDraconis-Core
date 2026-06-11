using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using ImperiusDraconisAPI.Models.Auditoria;
using ImperiusDraconisAPI.Models.Auditoria.Dtos;
using ImperiusDraconisAPI.Services.Auditoria;
using System.Security.Claims;
using System.Threading.Tasks;
using System.Collections.Generic;

namespace ImperiusDraconisAPI.Controllers.Auditoria
{
    [Authorize]
    [Route("api/admin/auditoria")]
    [ApiController]
    public class AuditoriaController : ControllerBase
    {
        private readonly IAuditoriaService _auditoriaService;

        public AuditoriaController(IAuditoriaService auditoriaService)
        {
            _auditoriaService = auditoriaService;
        }

        [HttpGet("alumno/{idAlumno}/resumen")]
        public async Task<IActionResult> GetResumen(int idAlumno)
        {
            // Validar permiso del administrador
            if (!User.HasClaim("permission", "Auditoria:VerResumen"))
            {
                return Forbid();
            }

            var resumen = await _auditoriaService.ObtenerResumenAsync(idAlumno);
            if (resumen == null)
            {
                return NotFound(new { Message = "No hay resumen de auditoría calculado para este alumno." });
            }

            return Ok(resumen);
        }

        [HttpGet("resumenes")]
        public async Task<IActionResult> GetResumenes()
        {
            if (!User.HasClaim("permission", "Auditoria:VerResumen"))
            {
                return Forbid();
            }

            var resumenes = await _auditoriaService.ObtenerTodosResumenesAsync();
            return Ok(resumenes);
        }

        [HttpPost("alumno/{idAlumno}/recalcular")]
        public async Task<IActionResult> Recalcular(int idAlumno)
        {
            if (!User.HasClaim("permission", "Auditoria:Recalcular"))
            {
                return Forbid();
            }

            await _auditoriaService.EvaluarAuditoriaAlumnoAsync(idAlumno);
            return Ok(new { Message = "Cálculo de relevancia completado exitosamente." });
        }

        [HttpPost("decisiones")]
        public async Task<IActionResult> RegistrarDecision([FromBody] DecisionAdministrativa model)
        {
            if (!User.HasClaim("permission", "Auditoria:GestionarDecisiones"))
            {
                return Forbid();
            }

            var adminIdClaim = User.FindFirst(ClaimTypes.NameIdentifier);
            if (adminIdClaim == null) return Unauthorized();

            model.IdAdministrador = int.Parse(adminIdClaim.Value);

            await _auditoriaService.RegistrarDecisionAsync(model);
            return Ok(new { Message = "Decisión registrada exitosamente y relevancia recalculada." });
        }

        [HttpGet("alumno/{idAlumno}/decisiones")]
        public async Task<IActionResult> GetDecisiones(int idAlumno)
        {
            if (!User.HasClaim("permission", "Auditoria:VerResumen"))
            {
                return Forbid();
            }

            var decisiones = await _auditoriaService.ObtenerHistorialDecisionesAsync(idAlumno);
            return Ok(decisiones);
        }

        [HttpPost("excepciones")]
        public async Task<IActionResult> RegistrarExcepcion([FromBody] ExcepcionAuditoria model)
        {
            if (!User.HasClaim("permission", "Auditoria:GestionarExcepciones"))
            {
                return Forbid();
            }

            var adminIdClaim = User.FindFirst(ClaimTypes.NameIdentifier);
            if (adminIdClaim == null) return Unauthorized();

            model.IdAdministrador = int.Parse(adminIdClaim.Value);

            await _auditoriaService.RegistrarExcepcionAsync(model);
            return Ok(new { Message = "Excepción permanente creada exitosamente." });
        }

        [HttpGet("excepciones")]
        public async Task<IActionResult> GetExcepciones()
        {
            if (!User.HasClaim("permission", "Auditoria:VerResumen"))
            {
                return Forbid();
            }

            var excepciones = await _auditoriaService.ObtenerExcepcionesAsync();
            return Ok(excepciones);
        }

        [HttpPost("especiales")]
        public async Task<IActionResult> RegistrarCuentaEspecial([FromBody] CuentaEspecial model)
        {
            if (!User.HasClaim("permission", "Auditoria:GestionarCuentasEspeciales"))
            {
                return Forbid();
            }

            await _auditoriaService.RegistrarCuentaEspecialAsync(model);
            return Ok(new { Message = "Cuenta especial registrada o actualizada exitosamente." });
        }

        [HttpGet("alumno/{idAlumno}/arbol")]
        public async Task<IActionResult> GetArbol(int idAlumno)
        {
            if (!User.HasClaim("permission", "Auditoria:VerResumen"))
            {
                return Forbid();
            }

            var arbol = await _auditoriaService.ObtenerArbolRelacionesAsync(idAlumno);
            return Ok(arbol);
        }
    }
}
