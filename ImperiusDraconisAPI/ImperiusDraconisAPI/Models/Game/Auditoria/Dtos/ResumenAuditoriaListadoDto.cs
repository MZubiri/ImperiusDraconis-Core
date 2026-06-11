using System;

namespace ImperiusDraconisAPI.Models.Auditoria.Dtos
{
    public class ResumenAuditoriaListadoDto
    {
        public int IdAlumno { get; set; }
        public string NombreAlumno { get; set; } = string.Empty;
        public int RelevanciaAuditoria { get; set; }
        public string MotivosDetalle { get; set; } = string.Empty;
        public string EvidenciasJson { get; set; } = string.Empty;
        public DateTime UltimaEvaluacion { get; set; }
    }
}
