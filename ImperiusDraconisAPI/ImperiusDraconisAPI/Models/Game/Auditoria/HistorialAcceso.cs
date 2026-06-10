using System;

namespace ImperiusDraconisAPI.Models.Auditoria
{
    public class HistorialAcceso
    {
        public int Id { get; set; }
        public int IdAlumno { get; set; }
        public string DireccionIP { get; set; } = string.Empty;
        public string? UserAgent { get; set; }
        public string FingerprintHash { get; set; } = string.Empty;
        public string TipoDispositivo { get; set; } = string.Empty;
        public string? PaisCodigo { get; set; }
        public string? Ciudad { get; set; }
        public string? ProveedorInternet { get; set; }
        public bool Exito { get; set; }
        public DateTime FechaAcceso { get; set; }
    }
}
