-- MySQL 8.0.16+. GO separates connector batches; DDL commits implicitly.
DROP PROCEDURE IF EXISTS migrate_015_create_alumno_emoji_permission;
GO
CREATE PROCEDURE migrate_015_create_alumno_emoji_permission()
migration: BEGIN
DECLARE v_0 VARCHAR(100);
DECLARE v_1 VARCHAR(100);
SET v_0 = 'Alumnos';
SET v_1 = 'ModificarEmojis';

INSERT INTO Permisos (IdCargo, Controlador, Accion, TienePermiso)
SELECT C.IdCargo, v_0, v_1, 0
FROM Cargos C
WHERE NOT EXISTS
(
    SELECT 1
    FROM Permisos P
    WHERE P.IdCargo = C.IdCargo
      AND P.Controlador = @Controlador
      AND P.Accion = @Accion
);

IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'PermisosTrabajos') THEN
    INSERT INTO PermisosTrabajos (IdTrabajo, Controlador, Accion, TienePermiso)
    SELECT T.IdTrabajo, v_0, v_1, 0
    FROM Trabajos T
    WHERE NOT EXISTS
    (
        SELECT 1
        FROM PermisosTrabajos P
        WHERE P.IdTrabajo = T.IdTrabajo
          AND P.Controlador = @Controlador
          AND P.Accion = @Accion
    );

END IF;
END;
GO
CALL migrate_015_create_alumno_emoji_permission();
GO
DROP PROCEDURE migrate_015_create_alumno_emoji_permission;
GO
