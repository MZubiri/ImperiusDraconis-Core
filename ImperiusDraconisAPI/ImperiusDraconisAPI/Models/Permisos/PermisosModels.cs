namespace ImperiusDraconisAPI.Models.Permisos;

public sealed class PermisoDetalleDto
{
    public int IdPermiso { get; init; }

    public string Controlador { get; init; } = string.Empty;

    public string Accion { get; init; } = string.Empty;

    public bool TienePermiso { get; init; }
}

public sealed class PermisoCargoDto
{
    public int IdCargo { get; init; }

    public string CargoNombre { get; init; } = string.Empty;

    public IReadOnlyCollection<PermisoDetalleDto> Permisos { get; init; } = Array.Empty<PermisoDetalleDto>();
}

public sealed class UpdatePermisoDetalleRequest
{
    public int IdPermiso { get; init; }

    public bool TienePermiso { get; init; }
}

public sealed class UpdatePermisoCargoRequest
{
    public IReadOnlyCollection<UpdatePermisoDetalleRequest> Permisos { get; init; } =
        Array.Empty<UpdatePermisoDetalleRequest>();
}

public sealed class CreatePermisoRequest
{
    public string Controlador { get; init; } = string.Empty;

    public string Accion { get; init; } = string.Empty;
}
