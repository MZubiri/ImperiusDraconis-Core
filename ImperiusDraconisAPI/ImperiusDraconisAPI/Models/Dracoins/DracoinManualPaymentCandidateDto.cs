namespace ImperiusDraconisAPI.Models.Dracoins;

public sealed class DracoinManualPaymentCandidateDto
{
    public int IdAlumno { get; init; }

    public string CodigoAlumno { get; init; } = string.Empty;

    public string NombreAlumno { get; init; } = string.Empty;

    public string Cargo { get; init; } = string.Empty;

    public string Genero { get; init; } = string.Empty;

    public decimal MontoSugerido { get; init; }

    public decimal DracoinsActuales { get; init; }
}
