using System;

namespace ImperiusDraconisAPI.Models.Auditoria
{
    public class DecisionAdministrativa
    {
        public int Id { get; set; }
        public int IdAlumno { get; set; }
        public int? IdAlumnoRelacionado { get; set; }
        public string Decision { get; set; } = string.Empty; // EN_OBSERVACION, PERMITIDA_FAMILIAR, SOSPECHOSA_CONFIRMADA, ACCION_MANUAL
        public string? Motivo { get; set; }
        public string? NotasInternas { get; set; }
        public int IdAdministrador { get; set; }
        public DateTime FechaDecision { get; set; }
    }
}
