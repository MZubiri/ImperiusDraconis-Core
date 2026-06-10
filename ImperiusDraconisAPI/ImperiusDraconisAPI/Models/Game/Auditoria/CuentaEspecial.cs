using System;

namespace ImperiusDraconisAPI.Models.Auditoria
{
    public class CuentaEspecial
    {
        public int IdAlumno { get; set; }
        public string TipoCuenta { get; set; } = string.Empty; // CASA, COMPARTIDA_AUTORIZADA, ASISTENTE, INSTITUCIONAL, ADMINISTRATIVA
        public string? Descripcion { get; set; }
        public decimal MultiplicadorAuditoria { get; set; } = 1.00m;
        public DateTime FechaRegistro { get; set; }
    }
}
