/*
    Migracion: 004_create_game_eggs
    Proposito: Crear persistencia minima de huevos de Imperius Dragons.
    Fecha: 2026-06-09

    Requisitos:
    - SQL Server 2016 o superior.
    - Las tablas dbo.Alumnos y dbo.GameDragonCapacity deben existir.
*/

SET NOCOUNT ON;
SET XACT_ABORT ON;
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET ANSI_PADDING ON;
SET ANSI_WARNINGS ON;
SET ARITHABORT ON;
SET CONCAT_NULL_YIELDS_NULL ON;
SET NUMERIC_ROUNDABORT OFF;
GO

IF OBJECT_ID(N'dbo.Alumnos', N'U') IS NULL
    THROW 50011, 'No existe dbo.Alumnos. No se puede crear GameEggs.', 1;
GO

IF OBJECT_ID(N'dbo.GameDragonCapacity', N'U') IS NULL
    THROW 50012, 'No existe dbo.GameDragonCapacity. Ejecute primero la migracion 003.', 1;
GO

IF OBJECT_ID(N'dbo.GameEggs', N'U') IS NOT NULL
BEGIN
    PRINT 'Migracion 004_create_game_eggs ya aplicada.';
    RETURN;
END;

BEGIN TRY
    BEGIN TRANSACTION;

    CREATE TABLE dbo.GameEggs
    (
        Id BIGINT IDENTITY(1, 1) NOT NULL,
        IdAlumno INT NOT NULL,
        Rarity NVARCHAR(20) NOT NULL,
        AcquiredAt DATETIME2(3) NOT NULL
            CONSTRAINT DF_GameEggs_AcquiredAt DEFAULT SYSUTCDATETIME(),
        IncubationStartedAt DATETIME2(3) NULL,
        IncubationEndsAt DATETIME2(3) NULL,
        Status NVARCHAR(20) NOT NULL
            CONSTRAINT DF_GameEggs_Status DEFAULT N'OWNED',
        UpdatedAt DATETIME2(3) NOT NULL
            CONSTRAINT DF_GameEggs_UpdatedAt DEFAULT SYSUTCDATETIME(),
        RowVersion ROWVERSION,

        CONSTRAINT PK_GameEggs
            PRIMARY KEY CLUSTERED (Id),

        CONSTRAINT FK_GameEggs_Alumnos
            FOREIGN KEY (IdAlumno) REFERENCES dbo.Alumnos (IdAlumno),

        CONSTRAINT CK_GameEggs_Rarity
            CHECK (Rarity IN (N'COMMON', N'RARE', N'EPIC', N'LEGENDARY', N'MYTHIC')),

        CONSTRAINT CK_GameEggs_Status
            CHECK (Status IN (N'OWNED', N'INCUBATING', N'READY_TO_HATCH', N'HATCHED')),

        CONSTRAINT CK_GameEggs_IncubationPair
            CHECK
            (
                (IncubationStartedAt IS NULL AND IncubationEndsAt IS NULL)
                OR
                (IncubationStartedAt IS NOT NULL AND IncubationEndsAt IS NOT NULL)
            ),

        CONSTRAINT CK_GameEggs_IncubationDates
            CHECK
            (
                IncubationStartedAt IS NULL
                OR
                (
                    IncubationStartedAt >= AcquiredAt
                    AND IncubationEndsAt > IncubationStartedAt
                )
            ),

        CONSTRAINT CK_GameEggs_StatusDates
            CHECK
            (
                (
                    Status = N'OWNED'
                    AND IncubationStartedAt IS NULL
                    AND IncubationEndsAt IS NULL
                )
                OR
                (
                    Status IN (N'INCUBATING', N'READY_TO_HATCH', N'HATCHED')
                    AND IncubationStartedAt IS NOT NULL
                    AND IncubationEndsAt IS NOT NULL
                )
            ),

        CONSTRAINT CK_GameEggs_UpdatedAfterAcquired
            CHECK (UpdatedAt >= AcquiredAt)
    );

    CREATE NONCLUSTERED INDEX IX_GameEggs_IdAlumno_Status
        ON dbo.GameEggs (IdAlumno, Status)
        INCLUDE (Rarity, AcquiredAt, IncubationStartedAt, IncubationEndsAt, UpdatedAt);

    CREATE NONCLUSTERED INDEX IX_GameEggs_Incubating_EndsAt
        ON dbo.GameEggs (IncubationEndsAt)
        INCLUDE (IdAlumno, Rarity)
        WHERE Status = N'INCUBATING';

    COMMIT TRANSACTION;
    PRINT 'Migracion 004_create_game_eggs aplicada correctamente.';
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;
GO
