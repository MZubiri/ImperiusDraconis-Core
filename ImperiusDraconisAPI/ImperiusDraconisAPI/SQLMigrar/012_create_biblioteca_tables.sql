-- MySQL 8.0.16+. GO separates connector batches; DDL commits implicitly.
DROP PROCEDURE IF EXISTS migrate_012_create_biblioteca_tables;
GO
CREATE PROCEDURE migrate_012_create_biblioteca_tables()
migration: BEGIN

IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'BibliotecaCategorias') THEN
    CREATE TABLE BibliotecaCategorias
    (
        Id INT AUTO_INCREMENT NOT NULL,
        Nombre VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
        Descripcion LONGTEXT NULL,
        Activo TINYINT(1) NOT NULL DEFAULT 1,
        PRIMARY KEY (Id)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

END IF;
IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'BibliotecaLibros') THEN
    CREATE TABLE BibliotecaLibros
    (
        Id INT AUTO_INCREMENT NOT NULL,
        Titulo VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
        Autor VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
        Sinopsis LONGTEXT NULL,
        IdCategoria INT NULL,
        RutaArchivo VARCHAR(2048) NOT NULL,
        Formato VARCHAR(50) NOT NULL,
        PrecioDracoins DECIMAL(18, 2) NOT NULL DEFAULT 0,
        FechaRegistro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        Activo TINYINT(1) NOT NULL DEFAULT 1,
        PRIMARY KEY (Id),
        CONSTRAINT FK_BibliotecaLibros_BibliotecaCategorias FOREIGN KEY (IdCategoria) REFERENCES BibliotecaCategorias(Id) ON DELETE SET NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

END IF;
IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'AlumnosSuscripciones') THEN
    CREATE TABLE AlumnosSuscripciones
    (
        Id INT AUTO_INCREMENT NOT NULL,
        IdAlumno INT NOT NULL,
        FechaInicio DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        FechaVencimiento DATETIME NOT NULL,
        Activa TINYINT(1) NOT NULL DEFAULT 1,
        PRIMARY KEY (Id),
        CONSTRAINT FK_AlumnosSuscripciones_Alumnos FOREIGN KEY (IdAlumno) REFERENCES Alumnos(IdAlumno) ON DELETE CASCADE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

END IF;
IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'AlumnosLibrosComprados') THEN
    CREATE TABLE AlumnosLibrosComprados
    (
        Id INT AUTO_INCREMENT NOT NULL,
        IdAlumno INT NOT NULL,
        IdLibro INT NOT NULL,
        FechaCompra DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        MontoPagado DECIMAL(18, 2) NOT NULL,
        PRIMARY KEY (Id),
        CONSTRAINT FK_AlumnosLibrosComprados_Alumnos FOREIGN KEY (IdAlumno) REFERENCES Alumnos(IdAlumno) ON DELETE CASCADE,
        CONSTRAINT FK_AlumnosLibrosComprados_BibliotecaLibros FOREIGN KEY (IdLibro) REFERENCES BibliotecaLibros(Id) ON DELETE CASCADE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

END IF;
IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'BibliotecaHistorialLectura') THEN
    CREATE TABLE BibliotecaHistorialLectura
    (
        Id INT AUTO_INCREMENT NOT NULL,
        IdAlumno INT NOT NULL,
        IdLibro INT NOT NULL,
        UltimaPaginaLeida INT NOT NULL DEFAULT 1,
        UltimoAcceso DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        PRIMARY KEY (Id),
        CONSTRAINT FK_BibliotecaHistorialLectura_Alumnos FOREIGN KEY (IdAlumno) REFERENCES Alumnos(IdAlumno) ON DELETE CASCADE,
        CONSTRAINT FK_BibliotecaHistorialLectura_BibliotecaLibros FOREIGN KEY (IdLibro) REFERENCES BibliotecaLibros(Id) ON DELETE CASCADE,
        CONSTRAINT UQ_BibliotecaHistorialLectura_AlumnoLibro UNIQUE (IdAlumno, IdLibro)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

END IF;
END;
GO
CALL migrate_012_create_biblioteca_tables();
GO
DROP PROCEDURE migrate_012_create_biblioteca_tables;
GO
