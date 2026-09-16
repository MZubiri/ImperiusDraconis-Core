-- MySQL 8.0.16+. GO separates connector batches; DDL commits implicitly.
DROP PROCEDURE IF EXISTS migrate_002_create_rincon_permissions;
GO
CREATE PROCEDURE migrate_002_create_rincon_permissions()
migration: BEGIN

DROP TEMPORARY TABLE IF EXISTS tmp_PermisosRincon;
CREATE TEMPORARY TABLE tmp_PermisosRincon
(
    Controlador VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    Accion VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    HabilitadoPorDefecto TINYINT(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO tmp_PermisosRincon (Controlador, Accion, HabilitadoPorDefecto)
VALUES
    ('Rincon', 'Catalogo', 1),
    ('Rincon', 'Comprar', 1),
    ('Rincon', 'Historial', 1),
    ('Rincon', 'CancelarPedido', 1),
    ('Rincon', 'PanelAdmin', 0),
    ('Rincon', 'GestionarProductos', 0),
    ('Rincon', 'GestionarPedidos', 0);

INSERT INTO Permisos (IdCargo, Controlador, Accion, TienePermiso)
SELECT C.IdCargo, P.Controlador, P.Accion, P.HabilitadoPorDefecto
FROM Cargos C
CROSS JOIN tmp_PermisosRincon P
WHERE NOT EXISTS
(
    SELECT 1
    FROM Permisos E
    WHERE E.IdCargo = C.IdCargo
      AND E.Controlador = P.Controlador
      AND E.Accion = P.Accion
);

IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'PermisosTrabajos') THEN
    INSERT INTO PermisosTrabajos (IdTrabajo, Controlador, Accion, TienePermiso)
    SELECT T.IdTrabajo, P.Controlador, P.Accion, 0
    FROM Trabajos T
    CROSS JOIN tmp_PermisosRincon P
    WHERE NOT EXISTS
    (
        SELECT 1
        FROM PermisosTrabajos E
        WHERE E.IdTrabajo = T.IdTrabajo
          AND E.Controlador = P.Controlador
          AND E.Accion = P.Accion
    );

END IF;
END;
GO
CALL migrate_002_create_rincon_permissions();
GO
DROP PROCEDURE migrate_002_create_rincon_permissions;
GO
