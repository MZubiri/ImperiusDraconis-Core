/*
    Migracion: 003_create_game_epic1
    Proposito: Crear persistencia base para vinculacion Roblox, capacidad,
               ledger de Dracoins e idempotencia de Imperius Dragons.
    Fecha: 2026-06-09

    Requisitos:
    - SQL Server 2016 o superior.
    - La tabla dbo.Alumnos debe existir.
    - Los hashes de codigos y solicitudes usan SHA-256/HMAC-SHA-256 (32 bytes).

    Comportamiento:
    - Si las cinco tablas ya existen, la migracion finaliza sin cambios.
    - Si existe solo una parte de las tablas, la migracion falla para evitar
      completar silenciosamente una instalacion inconsistente.
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
BEGIN
    THROW 50001, 'No existe dbo.Alumnos. No se puede ejecutar la migracion Game Epic 1.', 1;
END;
GO

DECLARE @ExistingGameTables INT =
(
    SELECT COUNT(*)
    FROM sys.tables
    WHERE schema_id = SCHEMA_ID(N'dbo')
      AND name IN
      (
          N'GameLinkCodes',
          N'GameRobloxLinks',
          N'GameDragonCapacity',
          N'GameDracoinLedger',
          N'GameIdempotency'
      )
);

IF @ExistingGameTables = 5
BEGIN
    PRINT 'Migracion 003_create_game_epic1 ya aplicada.';
    RETURN;
END;

IF @ExistingGameTables > 0
BEGIN
    THROW 50002, 'Migracion Game Epic 1 parcialmente aplicada. Revise las tablas existentes antes de continuar.', 1;
END;

BEGIN TRY
    BEGIN TRANSACTION;

    CREATE TABLE dbo.GameLinkCodes
    (
        Id BIGINT IDENTITY(1, 1) NOT NULL,
        IdAlumno INT NOT NULL,
        CodeHash BINARY(32) NOT NULL,
        ExpiresAt DATETIME2(3) NOT NULL,
        UsedAt DATETIME2(3) NULL,
        RevokedAt DATETIME2(3) NULL,
        CreatedAt DATETIME2(3) NOT NULL
            CONSTRAINT DF_GameLinkCodes_CreatedAt DEFAULT SYSUTCDATETIME(),

        CONSTRAINT PK_GameLinkCodes
            PRIMARY KEY CLUSTERED (Id),

        CONSTRAINT FK_GameLinkCodes_Alumnos
            FOREIGN KEY (IdAlumno) REFERENCES dbo.Alumnos (IdAlumno),

        CONSTRAINT CK_GameLinkCodes_ExpiresAfterCreation
            CHECK (ExpiresAt > CreatedAt),

        CONSTRAINT CK_GameLinkCodes_UsedAfterCreation
            CHECK (UsedAt IS NULL OR UsedAt >= CreatedAt),

        CONSTRAINT CK_GameLinkCodes_UsedBeforeExpiration
            CHECK (UsedAt IS NULL OR UsedAt <= ExpiresAt),

        CONSTRAINT CK_GameLinkCodes_RevokedAfterCreation
            CHECK (RevokedAt IS NULL OR RevokedAt >= CreatedAt),

        CONSTRAINT CK_GameLinkCodes_NotUsedAndRevoked
            CHECK (UsedAt IS NULL OR RevokedAt IS NULL)
    );

    CREATE UNIQUE NONCLUSTERED INDEX UX_GameLinkCodes_Active_IdAlumno
        ON dbo.GameLinkCodes (IdAlumno)
        WHERE UsedAt IS NULL AND RevokedAt IS NULL;

    CREATE UNIQUE NONCLUSTERED INDEX UX_GameLinkCodes_Active_CodeHash
        ON dbo.GameLinkCodes (CodeHash)
        WHERE UsedAt IS NULL AND RevokedAt IS NULL;

    CREATE NONCLUSTERED INDEX IX_GameLinkCodes_CodeHash
        ON dbo.GameLinkCodes (CodeHash)
        INCLUDE (IdAlumno, ExpiresAt, UsedAt, RevokedAt, CreatedAt);

    CREATE NONCLUSTERED INDEX IX_GameLinkCodes_IdAlumno_CreatedAt
        ON dbo.GameLinkCodes (IdAlumno, CreatedAt DESC)
        INCLUDE (ExpiresAt, UsedAt, RevokedAt);

    CREATE TABLE dbo.GameRobloxLinks
    (
        Id BIGINT IDENTITY(1, 1) NOT NULL,
        IdAlumno INT NOT NULL,
        RobloxUserId BIGINT NOT NULL,
        LinkedAt DATETIME2(3) NOT NULL
            CONSTRAINT DF_GameRobloxLinks_LinkedAt DEFAULT SYSUTCDATETIME(),
        Active BIT NOT NULL
            CONSTRAINT DF_GameRobloxLinks_Active DEFAULT (1),
        UnlinkedAt DATETIME2(3) NULL,

        CONSTRAINT PK_GameRobloxLinks
            PRIMARY KEY CLUSTERED (Id),

        CONSTRAINT FK_GameRobloxLinks_Alumnos
            FOREIGN KEY (IdAlumno) REFERENCES dbo.Alumnos (IdAlumno),

        CONSTRAINT UQ_GameRobloxLinks_IdAlumno
            UNIQUE NONCLUSTERED (IdAlumno),

        CONSTRAINT UQ_GameRobloxLinks_RobloxUserId
            UNIQUE NONCLUSTERED (RobloxUserId),

        CONSTRAINT CK_GameRobloxLinks_RobloxUserId_Positive
            CHECK (RobloxUserId > 0),

        CONSTRAINT CK_GameRobloxLinks_ActiveState
            CHECK
            (
                (Active = 1 AND UnlinkedAt IS NULL)
                OR
                (Active = 0 AND UnlinkedAt IS NOT NULL)
            ),

        CONSTRAINT CK_GameRobloxLinks_UnlinkedAfterLinked
            CHECK (UnlinkedAt IS NULL OR UnlinkedAt >= LinkedAt)
    );

    CREATE NONCLUSTERED INDEX IX_GameRobloxLinks_Active_RobloxUserId
        ON dbo.GameRobloxLinks (RobloxUserId)
        INCLUDE (IdAlumno, LinkedAt)
        WHERE Active = 1;

    CREATE TABLE dbo.GameDragonCapacity
    (
        IdAlumno INT NOT NULL,
        PurchasedSlots TINYINT NOT NULL
            CONSTRAINT DF_GameDragonCapacity_PurchasedSlots DEFAULT (0),
        MaxCapacity TINYINT NOT NULL
            CONSTRAINT DF_GameDragonCapacity_MaxCapacity DEFAULT (10),
        UpdatedAt DATETIME2(3) NOT NULL
            CONSTRAINT DF_GameDragonCapacity_UpdatedAt DEFAULT SYSUTCDATETIME(),
        RowVersion ROWVERSION,

        CONSTRAINT PK_GameDragonCapacity
            PRIMARY KEY CLUSTERED (IdAlumno),

        CONSTRAINT FK_GameDragonCapacity_Alumnos
            FOREIGN KEY (IdAlumno) REFERENCES dbo.Alumnos (IdAlumno),

        CONSTRAINT CK_GameDragonCapacity_MaxCapacity
            CHECK (MaxCapacity BETWEEN 1 AND 10),

        CONSTRAINT CK_GameDragonCapacity_PurchasedSlots
            CHECK (PurchasedSlots <= 9),

        CONSTRAINT CK_GameDragonCapacity_TotalWithinMaximum
            CHECK ((CONVERT(INT, PurchasedSlots) + 1) <= CONVERT(INT, MaxCapacity))
    );

    CREATE TABLE dbo.GameDracoinLedger
    (
        Id BIGINT IDENTITY(1, 1) NOT NULL,
        IdAlumno INT NOT NULL,
        Amount DECIMAL(18, 2) NOT NULL,
        BalanceAfter DECIMAL(18, 2) NOT NULL,
        Reason NVARCHAR(50) NOT NULL,
        ReferenceType NVARCHAR(50) NOT NULL,
        ReferenceId NVARCHAR(100) NULL,
        CreatedAt DATETIME2(3) NOT NULL
            CONSTRAINT DF_GameDracoinLedger_CreatedAt DEFAULT SYSUTCDATETIME(),

        CONSTRAINT PK_GameDracoinLedger
            PRIMARY KEY CLUSTERED (Id),

        CONSTRAINT FK_GameDracoinLedger_Alumnos
            FOREIGN KEY (IdAlumno) REFERENCES dbo.Alumnos (IdAlumno),

        CONSTRAINT CK_GameDracoinLedger_Amount_NotZero
            CHECK (Amount <> 0),

        CONSTRAINT CK_GameDracoinLedger_Amount_Whole
            CHECK (Amount = ROUND(Amount, 0)),

        CONSTRAINT CK_GameDracoinLedger_BalanceAfter_NonNegative
            CHECK (BalanceAfter >= 0),

        CONSTRAINT CK_GameDracoinLedger_BalanceAfter_Whole
            CHECK (BalanceAfter = ROUND(BalanceAfter, 0)),

        CONSTRAINT CK_GameDracoinLedger_Reason_NotBlank
            CHECK (LEN(LTRIM(RTRIM(Reason))) > 0),

        CONSTRAINT CK_GameDracoinLedger_ReferenceType_NotBlank
            CHECK (LEN(LTRIM(RTRIM(ReferenceType))) > 0),

        CONSTRAINT CK_GameDracoinLedger_ReferenceId_NotBlank
            CHECK (ReferenceId IS NULL OR LEN(LTRIM(RTRIM(ReferenceId))) > 0)
    );

    CREATE NONCLUSTERED INDEX IX_GameDracoinLedger_IdAlumno_CreatedAt
        ON dbo.GameDracoinLedger (IdAlumno, CreatedAt DESC)
        INCLUDE (Amount, BalanceAfter, Reason, ReferenceType, ReferenceId);

    CREATE UNIQUE NONCLUSTERED INDEX UX_GameDracoinLedger_WelcomeLink_IdAlumno
        ON dbo.GameDracoinLedger (IdAlumno)
        WHERE Reason = N'WELCOME_LINK';

    CREATE TABLE dbo.GameIdempotency
    (
        Id BIGINT IDENTITY(1, 1) NOT NULL,
        Operation NVARCHAR(100) NOT NULL,
        IdempotencyKey NVARCHAR(100) NOT NULL,
        RequestHash BINARY(32) NOT NULL,
        Status NVARCHAR(20) NOT NULL
            CONSTRAINT DF_GameIdempotency_Status DEFAULT N'Pending',
        ResponseStatusCode INT NULL,
        ResponseJson NVARCHAR(MAX) NULL,
        CreatedAt DATETIME2(3) NOT NULL
            CONSTRAINT DF_GameIdempotency_CreatedAt DEFAULT SYSUTCDATETIME(),
        CompletedAt DATETIME2(3) NULL,
        ExpiresAt DATETIME2(3) NULL,

        CONSTRAINT PK_GameIdempotency
            PRIMARY KEY CLUSTERED (Id),

        CONSTRAINT UQ_GameIdempotency_Operation_Key
            UNIQUE NONCLUSTERED (Operation, IdempotencyKey),

        CONSTRAINT CK_GameIdempotency_Operation_NotBlank
            CHECK (LEN(LTRIM(RTRIM(Operation))) > 0),

        CONSTRAINT CK_GameIdempotency_Key_NotBlank
            CHECK (LEN(LTRIM(RTRIM(IdempotencyKey))) > 0),

        CONSTRAINT CK_GameIdempotency_Status
            CHECK (Status IN (N'Pending', N'Completed')),

        CONSTRAINT CK_GameIdempotency_ResponseStatusCode
            CHECK (ResponseStatusCode IS NULL OR ResponseStatusCode BETWEEN 100 AND 599),

        CONSTRAINT CK_GameIdempotency_ResponseJson
            CHECK (ResponseJson IS NULL OR ISJSON(ResponseJson) = 1),

        CONSTRAINT CK_GameIdempotency_CompletedState
            CHECK
            (
                (
                    Status = N'Pending'
                    AND CompletedAt IS NULL
                    AND ResponseStatusCode IS NULL
                    AND ResponseJson IS NULL
                )
                OR
                (
                    Status = N'Completed'
                    AND CompletedAt IS NOT NULL
                    AND ResponseStatusCode IS NOT NULL
                    AND ResponseJson IS NOT NULL
                )
            ),

        CONSTRAINT CK_GameIdempotency_CompletedAfterCreation
            CHECK (CompletedAt IS NULL OR CompletedAt >= CreatedAt),

        CONSTRAINT CK_GameIdempotency_ExpiresAfterCreation
            CHECK (ExpiresAt IS NULL OR ExpiresAt > CreatedAt)
    );

    CREATE NONCLUSTERED INDEX IX_GameIdempotency_Status_CreatedAt
        ON dbo.GameIdempotency (Status, CreatedAt)
        INCLUDE (Operation, IdempotencyKey, ExpiresAt);

    CREATE NONCLUSTERED INDEX IX_GameIdempotency_ExpiresAt
        ON dbo.GameIdempotency (ExpiresAt)
        WHERE ExpiresAt IS NOT NULL;

    COMMIT TRANSACTION;
    PRINT 'Migracion 003_create_game_epic1 aplicada correctamente.';
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;
GO
