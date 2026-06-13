/*
    Migracion: 001_create_alumno_preferencias
    Proposito: Guardar preferencias por alumno, inicialmente accesos rapidos del dashboard.
    Fecha: 2026-05-14
*/

IF OBJECT_ID(N'dbo.AlumnoPreferencias', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.AlumnoPreferencias
    (
        IdAlumno INT NOT NULL,
        Clave NVARCHAR(100) NOT NULL,
        Valor NVARCHAR(MAX) NOT NULL,
        FechaActualizacion DATETIME2 NOT NULL
            CONSTRAINT DF_AlumnoPreferencias_FechaActualizacion DEFAULT SYSUTCDATETIME(),
        CONSTRAINT PK_AlumnoPreferencias PRIMARY KEY (IdAlumno, Clave)
    );
END;
GO

