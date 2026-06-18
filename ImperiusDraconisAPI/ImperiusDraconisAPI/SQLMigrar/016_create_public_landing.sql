IF OBJECT_ID(N'dbo.LandingConfiguracion', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.LandingConfiguracion
    (
        IdConfiguracion INT NOT NULL CONSTRAINT PK_LandingConfiguracion PRIMARY KEY,
        TituloPortada NVARCHAR(160) NOT NULL,
        SubtituloPortada NVARCHAR(500) NULL,
        IdCasaGanadora INT NULL,
        TituloCopa NVARCHAR(160) NULL,
        DescripcionCopa NVARCHAR(500) NULL,
        FechaActualizacion DATETIME2 NOT NULL CONSTRAINT DF_LandingConfiguracion_Fecha DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_LandingConfiguracion_Casas FOREIGN KEY (IdCasaGanadora) REFERENCES dbo.Casas(IdCasa)
    );
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.LandingConfiguracion WHERE IdConfiguracion = 1)
BEGIN
    INSERT INTO dbo.LandingConfiguracion
        (IdConfiguracion, TituloPortada, SubtituloPortada, TituloCopa)
    VALUES
        (1, N'Imperius Draconis', N'La magia en tus manos', N'Casa ganadora de la copa');
END
GO

IF OBJECT_ID(N'dbo.LandingContenido', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.LandingContenido
    (
        IdContenido INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_LandingContenido PRIMARY KEY,
        Tipo NVARCHAR(30) NOT NULL,
        Posicion INT NOT NULL,
        IdAlumno INT NULL,
        Titulo NVARCHAR(160) NULL,
        Descripcion NVARCHAR(600) NULL,
        Meta NVARCHAR(160) NULL,
        ImagenUrl NVARCHAR(500) NULL,
        EnlaceUrl NVARCHAR(1200) NULL,
        Activo BIT NOT NULL CONSTRAINT DF_LandingContenido_Activo DEFAULT 0,
        FechaActualizacion DATETIME2 NOT NULL CONSTRAINT DF_LandingContenido_Fecha DEFAULT SYSUTCDATETIME(),
        CONSTRAINT UQ_LandingContenido_TipoPosicion UNIQUE (Tipo, Posicion),
        CONSTRAINT FK_LandingContenido_Alumnos FOREIGN KEY (IdAlumno) REFERENCES dbo.Alumnos(IdAlumno)
    );
END
GO

IF COL_LENGTH(N'dbo.LandingContenido', N'IdAlumno') IS NULL
BEGIN
    ALTER TABLE dbo.LandingContenido ADD IdAlumno INT NULL;
END
GO

IF NOT EXISTS
(
    SELECT 1
    FROM sys.foreign_keys
    WHERE name = N'FK_LandingContenido_Alumnos'
      AND parent_object_id = OBJECT_ID(N'dbo.LandingContenido')
)
BEGIN
    ALTER TABLE dbo.LandingContenido
    ADD CONSTRAINT FK_LandingContenido_Alumnos
        FOREIGN KEY (IdAlumno) REFERENCES dbo.Alumnos(IdAlumno);
END
GO

;WITH Slots AS
(
    SELECT N'PLATA' AS Tipo, Posicion FROM (VALUES (1), (2), (3), (4)) V(Posicion)
    UNION ALL SELECT N'ORO', 1
    UNION ALL SELECT N'INSTAGRAM', Posicion FROM (VALUES (1), (2)) V(Posicion)
    UNION ALL SELECT N'TIKTOK', Posicion FROM (VALUES (1), (2)) V(Posicion)
    UNION ALL SELECT N'ESCAPE', Posicion FROM (VALUES (1), (2), (3)) V(Posicion)
)
INSERT INTO dbo.LandingContenido (Tipo, Posicion, Activo)
SELECT S.Tipo, S.Posicion, 0
FROM Slots S
WHERE NOT EXISTS
(
    SELECT 1
    FROM dbo.LandingContenido C
    WHERE C.Tipo = S.Tipo AND C.Posicion = S.Posicion
);
GO

INSERT INTO dbo.Permisos (IdCargo, Controlador, Accion, TienePermiso)
SELECT
    C.IdCargo,
    N'Landing',
    N'Administrar',
    CASE WHEN C.Nombre IN (N'Maestre', N'Director', N'Administrador') THEN 1 ELSE 0 END
FROM dbo.Cargos C
WHERE NOT EXISTS
(
    SELECT 1
    FROM dbo.Permisos P
    WHERE P.IdCargo = C.IdCargo
      AND P.Controlador = N'Landing'
      AND P.Accion = N'Administrar'
);
GO

IF OBJECT_ID(N'dbo.PermisosTrabajos', N'U') IS NOT NULL
BEGIN
    INSERT INTO dbo.PermisosTrabajos (IdTrabajo, Controlador, Accion, TienePermiso)
    SELECT T.IdTrabajo, N'Landing', N'Administrar', 0
    FROM dbo.Trabajos T
    WHERE NOT EXISTS
    (
        SELECT 1
        FROM dbo.PermisosTrabajos P
        WHERE P.IdTrabajo = T.IdTrabajo
          AND P.Controlador = N'Landing'
          AND P.Accion = N'Administrar'
    );
END
GO
