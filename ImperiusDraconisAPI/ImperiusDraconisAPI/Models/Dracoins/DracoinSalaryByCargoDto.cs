namespace ImperiusDraconisAPI.Models.Dracoins;

public sealed class DracoinSalaryByCargoDto
{
    public int IdSueldo { get; init; }

    public string Cargo { get; init; } = string.Empty;

    public decimal SueldoFijo { get; init; }
}
