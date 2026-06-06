namespace ImperiusDraconisAPI.Models.Dinamicas;

public sealed class DracoinDinamicaDetalleItemDto
{
    public int IdAlumno { get; init; }

    public string CodigoAlumno { get; init; } = string.Empty;

    public string NombreAlumno { get; init; } = string.Empty;

    public int DracoinsOtorgados { get; init; }

    public string Observacion { get; init; } = string.Empty;
}
