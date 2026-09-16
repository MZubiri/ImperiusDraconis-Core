-- MySQL 8.0.16+. GO separates connector batches; DDL commits implicitly.
DROP PROCEDURE IF EXISTS migrate_001_create_alumno_preferencias;
GO
CREATE PROCEDURE migrate_001_create_alumno_preferencias()
migration: BEGIN

IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'AlumnoPreferencias') THEN
    CREATE TABLE AlumnoPreferencias
    (
        IdAlumno INT NOT NULL,
        Clave VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
        Valor LONGTEXT NOT NULL,
        FechaActualizacion DATETIME NOT NULL
            DEFAULT (UTC_TIMESTAMP(3)),
        PRIMARY KEY (IdAlumno, Clave)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

END IF;
END;
GO
CALL migrate_001_create_alumno_preferencias();
GO
DROP PROCEDURE migrate_001_create_alumno_preferencias;
GO
