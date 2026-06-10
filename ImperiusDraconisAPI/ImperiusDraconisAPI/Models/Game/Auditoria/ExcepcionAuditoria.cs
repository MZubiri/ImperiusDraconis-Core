using System;

namespace ImperiusDraconisAPI.Models.Auditoria
{
    public class ExcepcionAuditoria
    {
        public int Id { get; set; }
        public string TipoExcepcion { get; set; } = string.Empty; // RELACION_AUTORIZADA, IP_CONFIABLE, DISPOSITIVO_AUTORIZADO
        public string ValorA { get; set; } = string.Empty;
        public string? ValorB { get; set; }
        public string? Motivo { get; set; }
        public DateTime FechaCreado { get; set; }
        public int IdAdministrador { get; set; }
        public bool Activa { get; set; }
    }
}
