using ImperiusDraconisAPI.Common;

namespace ImperiusDraconisAPI.Models.Trabajos;

public sealed class TrabajoOptionDto
{
    public int IdTrabajo { get; init; }

    public string Nombre { get; init; } = string.Empty;

    public string Descripcion { get; init; } = string.Empty;
}

public sealed class SaveTrabajoRequest
{
    public string Nombre { get; init; } = string.Empty;

    public string? Descripcion { get; init; }
}

public sealed class TrabajoAssignmentItemDto
{
    public int IdTrabajo { get; init; }

    public string Nombre { get; init; } = string.Empty;

    public string Descripcion { get; init; } = string.Empty;

    public bool Asignado { get; init; }
}

public sealed class TrabajoAlumnoAssignmentsDto
{
    public int IdAlumno { get; init; }

    public string CodigoAlumno { get; init; } = string.Empty;

    public string NombreAlumno { get; init; } = string.Empty;

    public IReadOnlyCollection<TrabajoAssignmentItemDto> Trabajos { get; init; } =
        Array.Empty<TrabajoAssignmentItemDto>();
}

public sealed class TrabajoCatalogsDto
{
    public IReadOnlyCollection<CatalogItemDto> Alumnos { get; init; } = Array.Empty<CatalogItemDto>();

    public IReadOnlyCollection<TrabajoOptionDto> Trabajos { get; init; } = Array.Empty<TrabajoOptionDto>();
}

public sealed class SaveTrabajoAssignmentsRequest
{
    public IReadOnlyCollection<int> IdsTrabajo { get; init; } = Array.Empty<int>();
}

public sealed class TrabajoPermisoItemDto
{
    public int IdPermisoTrabajo { get; init; }

    public string Controlador { get; init; } = string.Empty;

    public string Accion { get; init; } = string.Empty;

    public bool TienePermiso { get; init; }
}

public sealed class TrabajoPermisosDto
{
    public int IdTrabajo { get; init; }

    public string TrabajoNombre { get; init; } = string.Empty;

    public IReadOnlyCollection<TrabajoPermisoItemDto> Permisos { get; init; } =
        Array.Empty<TrabajoPermisoItemDto>();
}

public sealed class UpdateTrabajoPermisoRequest
{
    public string Controlador { get; init; } = string.Empty;

    public string Accion { get; init; } = string.Empty;

    public bool TienePermiso { get; init; }
}

public sealed class UpdateTrabajoPermisosRequest
{
    public IReadOnlyCollection<UpdateTrabajoPermisoRequest> Permisos { get; init; } =
        Array.Empty<UpdateTrabajoPermisoRequest>();
}
