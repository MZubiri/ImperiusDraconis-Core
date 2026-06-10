/*
    Migracion: 007_create_game_dragons
    Proposito: Crear persistencia minima de dragones nacidos de Imperius Dragons.
    Fecha: 2026-06-10

    Requisitos:
    - SQL Server 2016 o superior.
    - Las tablas dbo.Alumnos y dbo.GameEggs deben existir.
*/

SET NOCOUNT ON;
SET XACT_ABORT ON;
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID(N'dbo.Alumnos', N'U') IS NULL
    THROW 50030, 'No existe la tabla dbo.Alumnos. Ejecute primero las migraciones base.', 1;
GO

IF OBJECT_ID(N'dbo.GameEggs', N'U') IS NULL
    THROW 50031, 'No existe dbo.GameEggs. Ejecute primero las migraciones anteriores.', 1;
GO

IF OBJECT_ID(N'dbo.GameDragons', N'U') IS NOT NULL
BEGIN
    PRINT 'Migracion 007_create_game_dragons ya aplicada.';
    RETURN;
END;

BEGIN TRY
    BEGIN TRANSACTION;

    -- 1. Crear tabla de dragones
    CREATE TABLE dbo.GameDragons
    (
        Id BIGINT IDENTITY(1, 1) NOT NULL,
        IdAlumno INT NOT NULL,
        Name NVARCHAR(100) NOT NULL,
        Rarity NVARCHAR(20) NOT NULL,
        Temperament NVARCHAR(50) NOT NULL,
        Level INT NOT NULL CONSTRAINT DF_GameDragons_Level DEFAULT (1),
        Stage NVARCHAR(20) NOT NULL CONSTRAINT DF_GameDragons_Stage DEFAULT (N'BABY'),
        HatchedAt DATETIME2(3) NOT NULL CONSTRAINT DF_GameDragons_HatchedAt DEFAULT SYSUTCDATETIME(),

        CONSTRAINT PK_GameDragons PRIMARY KEY CLUSTERED (Id),
        CONSTRAINT FK_GameDragons_Alumnos FOREIGN KEY (IdAlumno) REFERENCES dbo.Alumnos (IdAlumno),
        CONSTRAINT CK_GameDragons_Name_NotBlank CHECK (LEN(LTRIM(RTRIM(Name))) > 0),
        CONSTRAINT CK_GameDragons_Rarity CHECK (Rarity IN (N'COMMON', N'RARE', N'EPIC', N'LEGENDARY', N'MYTHIC')),
        CONSTRAINT CK_GameDragons_Temperament CHECK (Temperament IN (N'NOBLE', N'AGRESIVO', N'JUGUETON', N'CURIOSO', N'PEREZOSO')),
        CONSTRAINT CK_GameDragons_Level CHECK (Level >= 1),
        CONSTRAINT CK_GameDragons_Stage CHECK (Stage IN (N'BABY', N'YOUNG', N'ADULT'))
    );

    -- 2. Crear indice en IdAlumno para optimizar consultas de dragones del jugador
    CREATE NONCLUSTERED INDEX IX_GameDragons_IdAlumno ON dbo.GameDragons (IdAlumno);

    -- 3. Alterar GameEggs para registrar el ID del dragon eclosionado
    IF COL_LENGTH(N'dbo.GameEggs', N'HatchedDragonId') IS NULL
    BEGIN
        ALTER TABLE dbo.GameEggs ADD HatchedDragonId BIGINT NULL;

        ALTER TABLE dbo.GameEggs WITH CHECK
            ADD CONSTRAINT FK_GameEggs_GameDragons
            FOREIGN KEY (HatchedDragonId) REFERENCES dbo.GameDragons (Id);
    END;

    COMMIT TRANSACTION;
    PRINT 'Migracion 007_create_game_dragons aplicada correctamente.';
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;
GO
