/*
    Migracion: 015_create_cumpleanos_permission
    Proposito: Registrar permiso Alumnos:Cumpleanos para todos los cargos y trabajos.
               El permiso viene deshabilitado por defecto; se activa desde el panel de permisos.
    Fecha: 2026-06-17
*/

DECLARE @NuevosPermisos TABLE
(
    Controlador NVARCHAR(100) NOT NULL,
    Accion NVARCHAR(100) NOT NULL,
    HabilitadoPorDefecto BIT NOT NULL
);

INSERT INTO @NuevosPermisos (Controlador, Accion, HabilitadoPorDefecto)
VALUES
    (N'Alumnos', N'Cumpleanos', 0);

-- Cargos
INSERT INTO dbo.Permisos (IdCargo, Controlador, Accion, TienePermiso)
SELECT C.IdCargo, P.Controlador, P.Accion, P.HabilitadoPorDefecto
FROM dbo.Cargos C
CROSS JOIN @NuevosPermisos P
WHERE NOT EXISTS
(
    SELECT 1
    FROM dbo.Permisos E
    WHERE E.IdCargo = C.IdCargo
      AND E.Controlador = P.Controlador
      AND E.Accion = P.Accion
);

-- Trabajos
IF OBJECT_ID(N'dbo.PermisosTrabajos', N'U') IS NOT NULL
BEGIN
    INSERT INTO dbo.PermisosTrabajos (IdTrabajo, Controlador, Accion, TienePermiso)
    SELECT T.IdTrabajo, P.Controlador, P.Accion, 0
    FROM dbo.Trabajos T
    CROSS JOIN @NuevosPermisos P
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
