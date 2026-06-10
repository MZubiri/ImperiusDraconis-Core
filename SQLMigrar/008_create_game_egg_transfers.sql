/*
    Migracion: 008_create_game_egg_transfers
    Proposito: Crear persistencia y restricciones para la transferencia de huevos (Regalo).
    Fecha: 2026-06-10

    Requisitos:
    - SQL Server 2016 o superior.
    - La tabla dbo.GameEggs debe existir.
    - La tabla dbo.Alumnos debe existir.
*/

SET NOCOUNT ON;
SET XACT_ABORT ON;
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID(N'dbo.Alumnos', N'U') IS NULL
    THROW 50040, 'No existe la tabla dbo.Alumnos. Ejecute primero las migraciones base.', 1;
GO

IF OBJECT_ID(N'dbo.GameEggs', N'U') IS NULL
    THROW 50041, 'No existe dbo.GameEggs. Ejecute primero las migraciones anteriores.', 1;
GO

IF OBJECT_ID(N'dbo.GameEggTransfers', N'U') IS NOT NULL
BEGIN
    PRINT 'Migracion 008_create_game_egg_transfers ya aplicada.';
    RETURN;
END;

BEGIN TRY
    BEGIN TRANSACTION;

    -- 1. Modificar restricciones de GameEggs para admitir IN_TRANSFER
    -- Primero eliminamos las restricciones check antiguas si existen
    IF EXISTS (SELECT * FROM sys.check_constraints WHERE name = N'CK_GameEggs_Status' AND parent_object_id = OBJECT_ID(N'dbo.GameEggs'))
        ALTER TABLE dbo.GameEggs DROP CONSTRAINT CK_GameEggs_Status;

    IF EXISTS (SELECT * FROM sys.check_constraints WHERE name = N'CK_GameEggs_StatusDates' AND parent_object_id = OBJECT_ID(N'dbo.GameEggs'))
        ALTER TABLE dbo.GameEggs DROP CONSTRAINT CK_GameEggs_StatusDates;

    -- Agregamos las nuevas restricciones check actualizadas
    ALTER TABLE dbo.GameEggs WITH CHECK
        ADD CONSTRAINT CK_GameEggs_Status CHECK (Status IN (N'OWNED', N'INCUBATING', N'READY_TO_HATCH', N'HATCHED', N'IN_TRANSFER'));

    ALTER TABLE dbo.GameEggs WITH CHECK
        ADD CONSTRAINT CK_GameEggs_StatusDates CHECK
        (
            (
                Status IN (N'OWNED', N'IN_TRANSFER')
                AND IncubationStartedAt IS NULL
                AND IncubationEndsAt IS NULL
            )
            OR
            (
                Status IN (N'INCUBATING', N'READY_TO_HATCH', N'HATCHED')
                AND IncubationStartedAt IS NOT NULL
                AND IncubationEndsAt IS NOT NULL
            )
        );

    -- 2. Crear tabla GameEggTransfers
    CREATE TABLE dbo.GameEggTransfers
    (
        Id BIGINT IDENTITY(1, 1) NOT NULL,
        EggId BIGINT NOT NULL,
        SenderIdAlumno INT NOT NULL,
        ReceiverRobloxUserId BIGINT NOT NULL,
        ReceiverIdAlumno INT NULL, -- Se llena al ser aceptado para auditoria
        Status NVARCHAR(20) NOT NULL CONSTRAINT DF_GameEggTransfers_Status DEFAULT (N'PENDING'),
        CreatedAt DATETIME2(3) NOT NULL CONSTRAINT DF_GameEggTransfers_CreatedAt DEFAULT SYSUTCDATETIME(),
        UpdatedAt DATETIME2(3) NOT NULL CONSTRAINT DF_GameEggTransfers_UpdatedAt DEFAULT SYSUTCDATETIME(),

        CONSTRAINT PK_GameEggTransfers PRIMARY KEY CLUSTERED (Id),
        CONSTRAINT FK_GameEggTransfers_GameEggs FOREIGN KEY (EggId) REFERENCES dbo.GameEggs (Id),
        CONSTRAINT FK_GameEggTransfers_Sender FOREIGN KEY (SenderIdAlumno) REFERENCES dbo.Alumnos (IdAlumno),
        CONSTRAINT FK_GameEggTransfers_Receiver FOREIGN KEY (ReceiverIdAlumno) REFERENCES dbo.Alumnos (IdAlumno),
        CONSTRAINT CK_GameEggTransfers_Status CHECK (Status IN (N'PENDING', N'ACCEPTED', N'REJECTED')),
        CONSTRAINT CK_GameEggTransfers_UpdatedAt CHECK (UpdatedAt >= CreatedAt)
    );

    -- 3. Crear indices e indice unico filtrado para evitar multiples transferencias pendientes por huevo
    CREATE NONCLUSTERED INDEX IX_GameEggTransfers_EggId ON dbo.GameEggTransfers (EggId);
    CREATE NONCLUSTERED INDEX IX_GameEggTransfers_Status ON dbo.GameEggTransfers (Status);
    CREATE NONCLUSTERED INDEX IX_GameEggTransfers_ReceiverRobloxUserId ON dbo.GameEggTransfers (ReceiverRobloxUserId);
    CREATE NONCLUSTERED INDEX IX_GameEggTransfers_ReceiverIdAlumno ON dbo.GameEggTransfers (ReceiverIdAlumno);

    -- Evita que el mismo huevo tenga mas de una transferencia PENDING al mismo tiempo
    CREATE UNIQUE NONCLUSTERED INDEX UX_GameEggTransfers_EggId_Pending
        ON dbo.GameEggTransfers (EggId)
        WHERE Status = N'PENDING';

    COMMIT TRANSACTION;
    PRINT 'Migracion 008_create_game_egg_transfers aplicada correctamente.';
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;
GO
