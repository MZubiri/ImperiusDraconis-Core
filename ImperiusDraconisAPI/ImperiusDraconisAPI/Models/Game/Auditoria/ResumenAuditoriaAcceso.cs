using System;

namespace ImperiusDraconisAPI.Models.Auditoria
{
    public class ResumenAuditoriaAcceso
    {
        public int IdAlumno { get; set; }
        public int RelevanciaAuditoria { get; set; }
        public string MotivosDetalle { get; set; } = string.Empty;
        public string EvidenciasJson { get; set; } = string.Empty;
        public DateTime UltimaEvaluacion { get; set; }
    }
}
