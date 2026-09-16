-- MySQL 8.0.16+. GO separates connector batches; DDL commits implicitly.
DROP PROCEDURE IF EXISTS migrate_004_create_game_eggs;
GO
CREATE PROCEDURE migrate_004_create_game_eggs()
migration: BEGIN

IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'Alumnos') THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No existe Alumnos. No se puede crear GameEggs.';
END IF;

IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameDragonCapacity') THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No existe GameDragonCapacity. Ejecute primero la migracion 003.';
END IF;

IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameEggs') THEN

    LEAVE migration;

END IF;
    CREATE TABLE GameEggs
    (
        Id BIGINT AUTO_INCREMENT NOT NULL,
        IdAlumno INT NOT NULL,
        Rarity VARCHAR(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
        AcquiredAt DATETIME(3) NOT NULL
            DEFAULT (UTC_TIMESTAMP(3)),
        IncubationStartedAt DATETIME(3) NULL,
        IncubationEndsAt DATETIME(3) NULL,
        Status VARCHAR(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
            DEFAULT 'OWNED',
        UpdatedAt DATETIME(3) NOT NULL
            DEFAULT (UTC_TIMESTAMP(3)),
        RowVersion TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),

        CONSTRAINT PK_GameEggs
            PRIMARY KEY (Id),

        CONSTRAINT FK_GameEggs_Alumnos
            FOREIGN KEY (IdAlumno) REFERENCES Alumnos (IdAlumno),

        CONSTRAINT CK_GameEggs_Rarity
            CHECK (Rarity IN ('COMMON', 'RARE', 'EPIC', 'LEGENDARY', 'MYTHIC')),

        CONSTRAINT CK_GameEggs_Status
            CHECK (Status IN ('OWNED', 'INCUBATING', 'READY_TO_HATCH', 'HATCHED')),

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
                    Status = 'OWNED'
                    AND IncubationStartedAt IS NULL
                    AND IncubationEndsAt IS NULL
                )
                OR
                (
                    Status IN ('INCUBATING', 'READY_TO_HATCH', 'HATCHED')
                    AND IncubationStartedAt IS NOT NULL
                    AND IncubationEndsAt IS NOT NULL
                )
            ),

        CONSTRAINT CK_GameEggs_UpdatedAfterAcquired
            CHECK (UpdatedAt >= AcquiredAt)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

    CREATE INDEX IX_GameEggs_IdAlumno_Status
        ON GameEggs (IdAlumno, Status);

    CREATE INDEX IX_GameEggs_Incubating_EndsAt ON GameEggs (IncubationEndsAt);
END;
GO
CALL migrate_004_create_game_eggs();
GO
DROP PROCEDURE migrate_004_create_game_eggs;
GO
