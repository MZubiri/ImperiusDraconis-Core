-- MySQL 8.0.16+. GO separates connector batches; DDL commits implicitly.
DROP PROCEDURE IF EXISTS migrate_016_create_public_landing;
GO
CREATE PROCEDURE migrate_016_create_public_landing()
migration: BEGIN

IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'LandingConfiguracion') THEN
    CREATE TABLE LandingConfiguracion
    (
        IdConfiguracion INT NOT NULL PRIMARY KEY,
        TituloPortada VARCHAR(160) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
        SubtituloPortada VARCHAR(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
        IdCasaGanadora INT NULL,
        TituloCopa VARCHAR(160) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
        DescripcionCopa VARCHAR(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
        FechaActualizacion DATETIME NOT NULL DEFAULT (UTC_TIMESTAMP(3)),
        CONSTRAINT FK_LandingConfiguracion_Casas FOREIGN KEY (IdCasaGanadora) REFERENCES Casas(IdCasa)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

END IF;
IF NOT EXISTS (SELECT 1 FROM LandingConfiguracion WHERE IdConfiguracion = 1) THEN
    INSERT INTO LandingConfiguracion
        (IdConfiguracion, TituloPortada, SubtituloPortada, TituloCopa)
    VALUES
        (1, 'Imperius Draconis', 'La magia en tus manos', 'Casa ganadora de la copa');

END IF;
IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'LandingContenido') THEN
    CREATE TABLE LandingContenido
    (
        IdContenido INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
        Tipo VARCHAR(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
        Posicion INT NOT NULL,
        IdAlumno INT NULL,
        Titulo VARCHAR(160) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
        Descripcion VARCHAR(600) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
        Meta VARCHAR(160) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
        ImagenUrl VARCHAR(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
        EnlaceUrl VARCHAR(1200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
        Activo TINYINT(1) NOT NULL DEFAULT 0,
        FechaActualizacion DATETIME NOT NULL DEFAULT (UTC_TIMESTAMP(3)),
        CONSTRAINT UQ_LandingContenido_TipoPosicion UNIQUE (Tipo, Posicion),
        CONSTRAINT FK_LandingContenido_Alumnos FOREIGN KEY (IdAlumno) REFERENCES Alumnos(IdAlumno)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

END IF;
IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'LandingContenido' AND column_name = 'IdAlumno') THEN
    ALTER TABLE LandingContenido ADD IdAlumno INT NULL;
END IF;
IF NOT EXISTS
(
    SELECT 1
    FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND constraint_name = 'FK_LandingContenido_Alumnos' AND table_name = 'LandingContenido'
) THEN
    ALTER TABLE LandingContenido
    ADD CONSTRAINT FK_LandingContenido_Alumnos
        FOREIGN KEY (IdAlumno) REFERENCES Alumnos(IdAlumno);

END IF;
INSERT INTO LandingContenido (Tipo, Posicion, Activo) SELECT 'PLATA', 1, 0 WHERE NOT EXISTS (SELECT 1 FROM LandingContenido WHERE Tipo = 'PLATA' AND Posicion = 1);
INSERT INTO LandingContenido (Tipo, Posicion, Activo) SELECT 'PLATA', 2, 0 WHERE NOT EXISTS (SELECT 1 FROM LandingContenido WHERE Tipo = 'PLATA' AND Posicion = 2);
INSERT INTO LandingContenido (Tipo, Posicion, Activo) SELECT 'PLATA', 3, 0 WHERE NOT EXISTS (SELECT 1 FROM LandingContenido WHERE Tipo = 'PLATA' AND Posicion = 3);
INSERT INTO LandingContenido (Tipo, Posicion, Activo) SELECT 'PLATA', 4, 0 WHERE NOT EXISTS (SELECT 1 FROM LandingContenido WHERE Tipo = 'PLATA' AND Posicion = 4);
INSERT INTO LandingContenido (Tipo, Posicion, Activo) SELECT 'ORO', 1, 0 WHERE NOT EXISTS (SELECT 1 FROM LandingContenido WHERE Tipo = 'ORO' AND Posicion = 1);
INSERT INTO LandingContenido (Tipo, Posicion, Activo) SELECT 'INSTAGRAM', 1, 0 WHERE NOT EXISTS (SELECT 1 FROM LandingContenido WHERE Tipo = 'INSTAGRAM' AND Posicion = 1);
INSERT INTO LandingContenido (Tipo, Posicion, Activo) SELECT 'INSTAGRAM', 2, 0 WHERE NOT EXISTS (SELECT 1 FROM LandingContenido WHERE Tipo = 'INSTAGRAM' AND Posicion = 2);
INSERT INTO LandingContenido (Tipo, Posicion, Activo) SELECT 'TIKTOK', 1, 0 WHERE NOT EXISTS (SELECT 1 FROM LandingContenido WHERE Tipo = 'TIKTOK' AND Posicion = 1);
INSERT INTO LandingContenido (Tipo, Posicion, Activo) SELECT 'TIKTOK', 2, 0 WHERE NOT EXISTS (SELECT 1 FROM LandingContenido WHERE Tipo = 'TIKTOK' AND Posicion = 2);
INSERT INTO LandingContenido (Tipo, Posicion, Activo) SELECT 'ESCAPE', 1, 0 WHERE NOT EXISTS (SELECT 1 FROM LandingContenido WHERE Tipo = 'ESCAPE' AND Posicion = 1);
INSERT INTO LandingContenido (Tipo, Posicion, Activo) SELECT 'ESCAPE', 2, 0 WHERE NOT EXISTS (SELECT 1 FROM LandingContenido WHERE Tipo = 'ESCAPE' AND Posicion = 2);
INSERT INTO LandingContenido (Tipo, Posicion, Activo) SELECT 'ESCAPE', 3, 0 WHERE NOT EXISTS (SELECT 1 FROM LandingContenido WHERE Tipo = 'ESCAPE' AND Posicion = 3);
INSERT INTO Permisos (IdCargo, Controlador, Accion, TienePermiso)
SELECT
    C.IdCargo,
    'Landing',
    'Administrar',
    CASE WHEN C.Nombre IN ('Maestre', 'Director', 'Administrador') THEN 1 ELSE 0 END
FROM Cargos C
WHERE NOT EXISTS
(
    SELECT 1
    FROM Permisos P
    WHERE P.IdCargo = C.IdCargo
      AND P.Controlador = 'Landing'
      AND P.Accion = 'Administrar'
);

IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'PermisosTrabajos') THEN
    INSERT INTO PermisosTrabajos (IdTrabajo, Controlador, Accion, TienePermiso)
    SELECT T.IdTrabajo, 'Landing', 'Administrar', 0
    FROM Trabajos T
    WHERE NOT EXISTS
    (
        SELECT 1
        FROM PermisosTrabajos P
        WHERE P.IdTrabajo = T.IdTrabajo
          AND P.Controlador = 'Landing'
          AND P.Accion = 'Administrar'
    );

END IF;
END;
GO
CALL migrate_016_create_public_landing();
GO
DROP PROCEDURE migrate_016_create_public_landing;
GO
