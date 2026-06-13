/*
    Migracion: 012_create_biblioteca_tables
    Proposito: Crear las tablas para el módulo de Biblioteca de libros (compras y suscripción semanal).
    Fecha: 2026-06-12
*/

-- 1. Tabla BibliotecaCategorias
IF OBJECT_ID(N'dbo.BibliotecaCategorias', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.BibliotecaCategorias
    (
        Id INT IDENTITY(1,1) NOT NULL,
        Nombre NVARCHAR(255) NOT NULL,
        Descripcion NVARCHAR(MAX) NULL,
        Activo BIT NOT NULL CONSTRAINT DF_BibliotecaCategorias_Activo DEFAULT 1,
        CONSTRAINT PK_BibliotecaCategorias PRIMARY KEY (Id)
    );
END;
GO

-- 2. Tabla BibliotecaLibros
IF OBJECT_ID(N'dbo.BibliotecaLibros', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.BibliotecaLibros
    (
        Id INT IDENTITY(1,1) NOT NULL,
        Titulo NVARCHAR(255) NOT NULL,
        Autor NVARCHAR(255) NOT NULL,
        Sinopsis NVARCHAR(MAX) NULL,
        IdCategoria INT NULL,
        RutaArchivo VARCHAR(2048) NOT NULL,
        Formato VARCHAR(50) NOT NULL, -- Ej: .pdf, .epub, .mobi
        PrecioDracoins DECIMAL(18, 2) NOT NULL CONSTRAINT DF_BibliotecaLibros_PrecioDracoins DEFAULT 0,
        FechaRegistro DATETIME NOT NULL CONSTRAINT DF_BibliotecaLibros_FechaRegistro DEFAULT GETDATE(),
        Activo BIT NOT NULL CONSTRAINT DF_BibliotecaLibros_Activo DEFAULT 1,
        CONSTRAINT PK_BibliotecaLibros PRIMARY KEY (Id),
        CONSTRAINT FK_BibliotecaLibros_BibliotecaCategorias FOREIGN KEY (IdCategoria) REFERENCES dbo.BibliotecaCategorias(Id) ON DELETE SET NULL
    );
END;
GO

-- 3. Tabla AlumnosSuscripciones (Suscripción semanal de biblioteca)
IF OBJECT_ID(N'dbo.AlumnosSuscripciones', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.AlumnosSuscripciones
    (
        Id INT IDENTITY(1,1) NOT NULL,
        IdAlumno INT NOT NULL,
        FechaInicio DATETIME NOT NULL CONSTRAINT DF_AlumnosSuscripciones_FechaInicio DEFAULT GETDATE(),
        FechaVencimiento DATETIME NOT NULL,
        Activa BIT NOT NULL CONSTRAINT DF_AlumnosSuscripciones_Activa DEFAULT 1,
        CONSTRAINT PK_AlumnosSuscripciones PRIMARY KEY (Id),
        CONSTRAINT FK_AlumnosSuscripciones_Alumnos FOREIGN KEY (IdAlumno) REFERENCES dbo.Alumnos(IdAlumno) ON DELETE CASCADE
    );
END;
GO

-- 4. Tabla AlumnosLibrosComprados (Compras de libros individuales)
IF OBJECT_ID(N'dbo.AlumnosLibrosComprados', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.AlumnosLibrosComprados
    (
        Id INT IDENTITY(1,1) NOT NULL,
        IdAlumno INT NOT NULL,
        IdLibro INT NOT NULL,
        FechaCompra DATETIME NOT NULL CONSTRAINT DF_AlumnosLibrosComprados_FechaCompra DEFAULT GETDATE(),
        MontoPagado DECIMAL(18, 2) NOT NULL,
        CONSTRAINT PK_AlumnosLibrosComprados PRIMARY KEY (Id),
        CONSTRAINT FK_AlumnosLibrosComprados_Alumnos FOREIGN KEY (IdAlumno) REFERENCES dbo.Alumnos(IdAlumno) ON DELETE CASCADE,
        CONSTRAINT FK_AlumnosLibrosComprados_BibliotecaLibros FOREIGN KEY (IdLibro) REFERENCES dbo.BibliotecaLibros(Id) ON DELETE CASCADE
    );
END;
GO

-- 5. Tabla BibliotecaHistorialLectura (Marcadores y progreso de lectura)
IF OBJECT_ID(N'dbo.BibliotecaHistorialLectura', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.BibliotecaHistorialLectura
    (
        Id INT IDENTITY(1,1) NOT NULL,
        IdAlumno INT NOT NULL,
        IdLibro INT NOT NULL,
        UltimaPaginaLeida INT NOT NULL CONSTRAINT DF_BibliotecaHistorialLectura_UltimaPaginaLeida DEFAULT 1,
        UltimoAcceso DATETIME NOT NULL CONSTRAINT DF_BibliotecaHistorialLectura_UltimoAcceso DEFAULT GETDATE(),
        CONSTRAINT PK_BibliotecaHistorialLectura PRIMARY KEY (Id),
        CONSTRAINT FK_BibliotecaHistorialLectura_Alumnos FOREIGN KEY (IdAlumno) REFERENCES dbo.Alumnos(IdAlumno) ON DELETE CASCADE,
        CONSTRAINT FK_BibliotecaHistorialLectura_BibliotecaLibros FOREIGN KEY (IdLibro) REFERENCES dbo.BibliotecaLibros(Id) ON DELETE CASCADE,
        CONSTRAINT UQ_BibliotecaHistorialLectura_AlumnoLibro UNIQUE (IdAlumno, IdLibro)
    );
END;
GO
