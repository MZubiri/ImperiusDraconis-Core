namespace ImperiusDraconisAPI.Models.Mascotas;

public sealed class MascotaMatrixRowDto
{
    public int IdAlumno { get; init; }

    public string CodigoAlumno { get; init; } = string.Empty;

    public string NombreAlumno { get; init; } = string.Empty;

    public int? IdMascotaLechuza { get; init; }

    public string EstadoLechuza { get; init; } = string.Empty;

    public int? IdMascotaGato { get; init; }

    public string EstadoGato { get; init; } = string.Empty;

    public int? IdMascotaSapo { get; init; }

    public string EstadoSapo { get; init; } = string.Empty;

    public int? IdMascotaGiratiempo { get; init; }

    public string EstadoGiratiempo { get; init; } = string.Empty;
}
