-- MySQL 8.0.16+. GO separates connector batches; DDL commits implicitly.
DROP PROCEDURE IF EXISTS migrate_003_create_game_epic1;
GO
CREATE PROCEDURE migrate_003_create_game_epic1()
migration: BEGIN
DECLARE v_0 INT;
IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'Alumnos') THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No existe Alumnos. No se puede ejecutar la migracion Game Epic 1.';
END IF;
SET v_0 = (
    SELECT COUNT(*)
    FROM information_schema.tables
    WHERE table_schema = DATABASE()
      AND table_name IN
      (
          'GameLinkCodes',
          'GameRobloxLinks',
          'GameDragonCapacity',
          'GameDracoinLedger',
          'GameIdempotency'
      )
);

IF v_0 = 5 THEN

    LEAVE migration;

END IF;
IF v_0 > 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Migracion Game Epic 1 parcialmente aplicada. Revise las tablas existentes antes de continuar.';
END IF;
    CREATE TABLE GameLinkCodes
    (
        Id BIGINT AUTO_INCREMENT NOT NULL,
        IdAlumno INT NOT NULL,
        CodeHash BINARY(32) NOT NULL,
        ExpiresAt DATETIME(3) NOT NULL,
        UsedAt DATETIME(3) NULL,
        RevokedAt DATETIME(3) NULL,
        CreatedAt DATETIME(3) NOT NULL
            DEFAULT (UTC_TIMESTAMP(3)),

        CONSTRAINT PK_GameLinkCodes
            PRIMARY KEY (Id),

        CONSTRAINT FK_GameLinkCodes_Alumnos
            FOREIGN KEY (IdAlumno) REFERENCES Alumnos (IdAlumno),

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
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

    ALTER TABLE GameLinkCodes ADD COLUMN Filter_UX_GameLinkCodes_Active_IdAlumno BIGINT GENERATED ALWAYS AS (CASE WHEN UsedAt IS NULL AND RevokedAt IS NULL THEN IdAlumno ELSE NULL END) STORED;
CREATE UNIQUE INDEX UX_GameLinkCodes_Active_IdAlumno ON GameLinkCodes (Filter_UX_GameLinkCodes_Active_IdAlumno);

    ALTER TABLE GameLinkCodes ADD COLUMN Filter_UX_GameLinkCodes_Active_CodeHash BINARY(32) GENERATED ALWAYS AS (CASE WHEN UsedAt IS NULL AND RevokedAt IS NULL THEN CodeHash ELSE NULL END) STORED;
CREATE UNIQUE INDEX UX_GameLinkCodes_Active_CodeHash ON GameLinkCodes (Filter_UX_GameLinkCodes_Active_CodeHash);

    CREATE INDEX IX_GameLinkCodes_CodeHash
        ON GameLinkCodes (CodeHash);

    CREATE INDEX IX_GameLinkCodes_IdAlumno_CreatedAt
        ON GameLinkCodes (IdAlumno, CreatedAt DESC);

    CREATE TABLE GameRobloxLinks
    (
        Id BIGINT AUTO_INCREMENT NOT NULL,
        IdAlumno INT NOT NULL,
        RobloxUserId BIGINT NOT NULL,
        LinkedAt DATETIME(3) NOT NULL
            DEFAULT (UTC_TIMESTAMP(3)),
        Active TINYINT(1) NOT NULL
            DEFAULT (1),
        UnlinkedAt DATETIME(3) NULL,

        CONSTRAINT PK_GameRobloxLinks
            PRIMARY KEY (Id),

        CONSTRAINT FK_GameRobloxLinks_Alumnos
            FOREIGN KEY (IdAlumno) REFERENCES Alumnos (IdAlumno),

        CONSTRAINT UQ_GameRobloxLinks_IdAlumno
            UNIQUE (IdAlumno),

        CONSTRAINT UQ_GameRobloxLinks_RobloxUserId
            UNIQUE (RobloxUserId),

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
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

    CREATE INDEX IX_GameRobloxLinks_Active_RobloxUserId ON GameRobloxLinks (RobloxUserId);

    CREATE TABLE GameDragonCapacity
    (
        IdAlumno INT NOT NULL,
        PurchasedSlots TINYINT UNSIGNED NOT NULL
            DEFAULT (0),
        MaxCapacity TINYINT UNSIGNED NOT NULL
            DEFAULT (10),
        UpdatedAt DATETIME(3) NOT NULL
            DEFAULT (UTC_TIMESTAMP(3)),
        RowVersion TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),

        CONSTRAINT PK_GameDragonCapacity
            PRIMARY KEY (IdAlumno),

        CONSTRAINT FK_GameDragonCapacity_Alumnos
            FOREIGN KEY (IdAlumno) REFERENCES Alumnos (IdAlumno),

        CONSTRAINT CK_GameDragonCapacity_MaxCapacity
            CHECK (MaxCapacity BETWEEN 1 AND 10),

        CONSTRAINT CK_GameDragonCapacity_PurchasedSlots
            CHECK (PurchasedSlots <= 9),

        CONSTRAINT CK_GameDragonCapacity_TotalWithinMaximum
            CHECK ((CAST(PurchasedSlots AS UNSIGNED) + 1) <= CAST(MaxCapacity AS UNSIGNED))
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

    CREATE TABLE GameDracoinLedger
    (
        Id BIGINT AUTO_INCREMENT NOT NULL,
        IdAlumno INT NOT NULL,
        Amount DECIMAL(18, 2) NOT NULL,
        BalanceAfter DECIMAL(18, 2) NOT NULL,
        Reason VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
        ReferenceType VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
        ReferenceId VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
        CreatedAt DATETIME(3) NOT NULL
            DEFAULT (UTC_TIMESTAMP(3)),

        CONSTRAINT PK_GameDracoinLedger
            PRIMARY KEY (Id),

        CONSTRAINT FK_GameDracoinLedger_Alumnos
            FOREIGN KEY (IdAlumno) REFERENCES Alumnos (IdAlumno),

        CONSTRAINT CK_GameDracoinLedger_Amount_NotZero
            CHECK (Amount <> 0),

        CONSTRAINT CK_GameDracoinLedger_Amount_Whole
            CHECK (Amount = ROUND(Amount, 0)),

        CONSTRAINT CK_GameDracoinLedger_BalanceAfter_NonNegative
            CHECK (BalanceAfter >= 0),

        CONSTRAINT CK_GameDracoinLedger_BalanceAfter_Whole
            CHECK (BalanceAfter = ROUND(BalanceAfter, 0)),

        CONSTRAINT CK_GameDracoinLedger_Reason_NotBlank
            CHECK (CHAR_LENGTH(LTRIM(RTRIM(Reason))) > 0),

        CONSTRAINT CK_GameDracoinLedger_ReferenceType_NotBlank
            CHECK (CHAR_LENGTH(LTRIM(RTRIM(ReferenceType))) > 0),

        CONSTRAINT CK_GameDracoinLedger_ReferenceId_NotBlank
            CHECK (ReferenceId IS NULL OR CHAR_LENGTH(LTRIM(RTRIM(ReferenceId))) > 0)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

    CREATE INDEX IX_GameDracoinLedger_IdAlumno_CreatedAt
        ON GameDracoinLedger (IdAlumno, CreatedAt DESC);

    ALTER TABLE GameDracoinLedger ADD COLUMN Filter_UX_GameDracoinLedger_WelcomeLink_IdAlumno BIGINT GENERATED ALWAYS AS (CASE WHEN Reason = 'WELCOME_LINK' THEN IdAlumno ELSE NULL END) STORED;
CREATE UNIQUE INDEX UX_GameDracoinLedger_WelcomeLink_IdAlumno ON GameDracoinLedger (Filter_UX_GameDracoinLedger_WelcomeLink_IdAlumno);

    CREATE TABLE GameIdempotency
    (
        Id BIGINT AUTO_INCREMENT NOT NULL,
        Operation VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
        IdempotencyKey VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
        RequestHash BINARY(32) NOT NULL,
        Status VARCHAR(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
            DEFAULT 'Pending',
        ResponseStatusCode INT NULL,
        ResponseJson LONGTEXT NULL,
        CreatedAt DATETIME(3) NOT NULL
            DEFAULT (UTC_TIMESTAMP(3)),
        CompletedAt DATETIME(3) NULL,
        ExpiresAt DATETIME(3) NULL,

        CONSTRAINT PK_GameIdempotency
            PRIMARY KEY (Id),

        CONSTRAINT UQ_GameIdempotency_Operation_Key
            UNIQUE (Operation, IdempotencyKey),

        CONSTRAINT CK_GameIdempotency_Operation_NotBlank
            CHECK (CHAR_LENGTH(LTRIM(RTRIM(Operation))) > 0),

        CONSTRAINT CK_GameIdempotency_Key_NotBlank
            CHECK (CHAR_LENGTH(LTRIM(RTRIM(IdempotencyKey))) > 0),

        CONSTRAINT CK_GameIdempotency_Status
            CHECK (Status IN ('Pending', 'Completed')),

        CONSTRAINT CK_GameIdempotency_ResponseStatusCode
            CHECK (ResponseStatusCode IS NULL OR ResponseStatusCode BETWEEN 100 AND 599),

        CONSTRAINT CK_GameIdempotency_ResponseJson
            CHECK (ResponseJson IS NULL OR JSON_VALID(ResponseJson) = 1),

        CONSTRAINT CK_GameIdempotency_CompletedState
            CHECK
            (
                (
                    Status = 'Pending'
                    AND CompletedAt IS NULL
                    AND ResponseStatusCode IS NULL
                    AND ResponseJson IS NULL
                )
                OR
                (
                    Status = 'Completed'
                    AND CompletedAt IS NOT NULL
                    AND ResponseStatusCode IS NOT NULL
                    AND ResponseJson IS NOT NULL
                )
            ),

        CONSTRAINT CK_GameIdempotency_CompletedAfterCreation
            CHECK (CompletedAt IS NULL OR CompletedAt >= CreatedAt),

        CONSTRAINT CK_GameIdempotency_ExpiresAfterCreation
            CHECK (ExpiresAt IS NULL OR ExpiresAt > CreatedAt)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

    CREATE INDEX IX_GameIdempotency_Status_CreatedAt
        ON GameIdempotency (Status, CreatedAt);

    CREATE INDEX IX_GameIdempotency_ExpiresAt ON GameIdempotency (ExpiresAt);
END;
GO
CALL migrate_003_create_game_epic1();
GO
DROP PROCEDURE migrate_003_create_game_epic1;
GO
