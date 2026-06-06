/*
    Migracion: 002_create_rincon_permissions
    Proposito: Registrar permisos de Rincon para cargos y trabajos.
    Fecha: 2026-06-05
*/

DECLARE @PermisosRincon TABLE
(
    Controlador NVARCHAR(100) NOT NULL,
    Accion NVARCHAR(100) NOT NULL,
    HabilitadoPorDefecto BIT NOT NULL
);

INSERT INTO @PermisosRincon (Controlador, Accion, HabilitadoPorDefecto)
VALUES
    (N'Rincon', N'Catalogo', 1),
    (N'Rincon', N'Comprar', 1),
    (N'Rincon', N'Historial', 1),
    (N'Rincon', N'CancelarPedido', 1),
    (N'Rincon', N'PanelAdmin', 0),
    (N'Rincon', N'GestionarProductos', 0),
    (N'Rincon', N'GestionarPedidos', 0);

INSERT INTO dbo.Permisos (IdCargo, Controlador, Accion, TienePermiso)
SELECT C.IdCargo, P.Controlador, P.Accion, P.HabilitadoPorDefecto
FROM dbo.Cargos C
CROSS JOIN @PermisosRincon P
WHERE NOT EXISTS
(
    SELECT 1
    FROM dbo.Permisos E
    WHERE E.IdCargo = C.IdCargo
      AND E.Controlador = P.Controlador
      AND E.Accion = P.Accion
);

IF OBJECT_ID(N'dbo.PermisosTrabajos', N'U') IS NOT NULL
BEGIN
    INSERT INTO dbo.PermisosTrabajos (IdTrabajo, Controlador, Accion, TienePermiso)
    SELECT T.IdTrabajo, P.Controlador, P.Accion, 0
    FROM dbo.Trabajos T
    CROSS JOIN @PermisosRincon P
    WHERE NOT EXISTS
    (
        SELECT 1
        FROM dbo.PermisosTrabajos E
        WHERE E.IdTrabajo = T.IdTrabajo
          AND E.Controlador = P.Controlador
          AND E.Accion = P.Accion
    );
END;
GO
