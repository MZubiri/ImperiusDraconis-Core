using System;

namespace ImperiusDraconisAPI.Models.Auditoria
{
    public class AuditoriaEvento
    {
        public int Id { get; set; }
        public string TipoEvento { get; set; } = string.Empty; // DISPOSITIVO_NUEVO, VINCULO_NUEVO, CAMBIO_RELEVANCIA, EXCEPCION_CREADA, CUENTA_ESPECIAL_REGISTRADA
        public string OrigenEvento { get; set; } = string.Empty; // SISTEMA, LOGIN, TRANSFERENCIA, AUDITORIA, ADMINISTRADOR, EXCEPCION, CUENTA_ESPECIAL
        public string Severidad { get; set; } = string.Empty; // INFO, LOW, MEDIUM, HIGH, CRITICAL
        public int IdAlumno { get; set; }
        public int? IdAlumnoRelacionado { get; set; }
        public string? ValorAnterior { get; set; }
        public string? ValorNuevo { get; set; }
        public string? DetallesJson { get; set; }
        public DateTime FechaEvento { get; set; }
    }
}
