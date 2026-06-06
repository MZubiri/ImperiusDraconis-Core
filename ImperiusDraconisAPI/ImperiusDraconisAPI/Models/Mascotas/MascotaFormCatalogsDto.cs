namespace ImperiusDraconisAPI.Models.Mascotas;

public sealed class MascotaFormCatalogsDto
{
    public IReadOnlyCollection<MascotaAlumnoOptionDto> Alumnos { get; init; } = Array.Empty<MascotaAlumnoOptionDto>();

    public IReadOnlyCollection<MascotaCatalogItemDto> Mascotas { get; init; } = Array.Empty<MascotaCatalogItemDto>();

    public IReadOnlyCollection<string> Estados { get; init; } = Array.Empty<string>();
}
