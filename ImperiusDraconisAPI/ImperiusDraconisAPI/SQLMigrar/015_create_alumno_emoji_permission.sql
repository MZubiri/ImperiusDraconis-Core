DECLARE @Controlador NVARCHAR(100) = N'Alumnos';
DECLARE @Accion NVARCHAR(100) = N'ModificarEmojis';

INSERT INTO dbo.Permisos (IdCargo, Controlador, Accion, TienePermiso)
SELECT C.IdCargo, @Controlador, @Accion, 0
FROM dbo.Cargos C
WHERE NOT EXISTS
(
    SELECT 1
    FROM dbo.Permisos P
    WHERE P.IdCargo = C.IdCargo
      AND P.Controlador = @Controlador
      AND P.Accion = @Accion
);

IF OBJECT_ID(N'dbo.PermisosTrabajos', N'U') IS NOT NULL
BEGIN
    INSERT INTO dbo.PermisosTrabajos (IdTrabajo, Controlador, Accion, TienePermiso)
    SELECT T.IdTrabajo, @Controlador, @Accion, 0
    FROM dbo.Trabajos T
    WHERE NOT EXISTS
    (
        SELECT 1
        FROM dbo.PermisosTrabajos P
        WHERE P.IdTrabajo = T.IdTrabajo
          AND P.Controlador = @Controlador
          AND P.Accion = @Accion
    );
END;
GO

