using System.ComponentModel.DataAnnotations;

namespace ImperiusDraconisAPI.Models.Marcadores;

public sealed class MarcadorUpdateItemRequest
{
    [Range(1, int.MaxValue)]
    public int IdCasa { get; set; }

    [Range(0, int.MaxValue)]
    public int Puntos { get; set; }
}
