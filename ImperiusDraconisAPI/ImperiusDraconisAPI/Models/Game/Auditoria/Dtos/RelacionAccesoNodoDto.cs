using System.Collections.Generic;

namespace ImperiusDraconisAPI.Models.Auditoria.Dtos
{
    public class RelacionAccesoNodoDto
    {
        public string Label { get; set; } = string.Empty;   // Nombre o descripción
        public string Tipo { get; set; } = string.Empty;    // ALUMNO, IP, DISPOSITIVO, TRANSFERENCIA, CUENTA_ESPECIAL
        public string Valor { get; set; } = string.Empty;   // Valor de texto o ID
        public List<RelacionAccesoNodoDto> Hijos { get; set; } = new();
    }
}
