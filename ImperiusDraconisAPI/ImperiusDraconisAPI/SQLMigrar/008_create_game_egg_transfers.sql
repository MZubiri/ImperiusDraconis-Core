-- MySQL 8.0.16+. GO separates connector batches; DDL commits implicitly.
DROP PROCEDURE IF EXISTS migrate_008_create_game_egg_transfers;
GO
CREATE PROCEDURE migrate_008_create_game_egg_transfers()
migration: BEGIN

IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'Alumnos') THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No existe la tabla Alumnos. Ejecute primero las migraciones base.';
END IF;

IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameEggs') THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No existe GameEggs. Ejecute primero las migraciones anteriores.';
END IF;

IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameEggTransfers') THEN

    LEAVE migration;

END IF;
    IF EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND constraint_name = 'CK_GameEggs_Status' AND table_name = 'GameEggs') THEN
        ALTER TABLE GameEggs DROP CHECK CK_GameEggs_Status;
END IF;

    IF EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND constraint_name = 'CK_GameEggs_StatusDates' AND table_name = 'GameEggs') THEN
        ALTER TABLE GameEggs DROP CHECK CK_GameEggs_StatusDates;
END IF;

    ALTER TABLE GameEggs
        ADD CONSTRAINT CK_GameEggs_Status CHECK (Status IN ('OWNED', 'INCUBATING', 'READY_TO_HATCH', 'HATCHED', 'IN_TRANSFER'));

    ALTER TABLE GameEggs
        ADD CONSTRAINT CK_GameEggs_StatusDates CHECK
        (
            (
                Status IN ('OWNED', 'IN_TRANSFER')
                AND IncubationStartedAt IS NULL
                AND IncubationEndsAt IS NULL
            )
            OR
            (
                Status IN ('INCUBATING', 'READY_TO_HATCH', 'HATCHED')
                AND IncubationStartedAt IS NOT NULL
                AND IncubationEndsAt IS NOT NULL
            )
        );

    CREATE TABLE GameEggTransfers
    (
        Id BIGINT AUTO_INCREMENT NOT NULL,
        EggId BIGINT NOT NULL,
        SenderIdAlumno INT NOT NULL,
        ReceiverRobloxUserId BIGINT NOT NULL,
        ReceiverIdAlumno INT NULL,
        Status VARCHAR(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT ('PENDING'),
        CreatedAt DATETIME(3) NOT NULL DEFAULT (UTC_TIMESTAMP(3)),
        UpdatedAt DATETIME(3) NOT NULL DEFAULT (UTC_TIMESTAMP(3)),

        PRIMARY KEY (Id),
        CONSTRAINT FK_GameEggTransfers_GameEggs FOREIGN KEY (EggId) REFERENCES GameEggs (Id),
        CONSTRAINT FK_GameEggTransfers_Sender FOREIGN KEY (SenderIdAlumno) REFERENCES Alumnos (IdAlumno),
        CONSTRAINT FK_GameEggTransfers_Receiver FOREIGN KEY (ReceiverIdAlumno) REFERENCES Alumnos (IdAlumno),
        CONSTRAINT CK_GameEggTransfers_Status CHECK (Status IN ('PENDING', 'ACCEPTED', 'REJECTED')),
        CONSTRAINT CK_GameEggTransfers_UpdatedAt CHECK (UpdatedAt >= CreatedAt)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

    CREATE INDEX IX_GameEggTransfers_EggId ON GameEggTransfers (EggId);
    CREATE INDEX IX_GameEggTransfers_Status ON GameEggTransfers (Status);
    CREATE INDEX IX_GameEggTransfers_ReceiverRobloxUserId ON GameEggTransfers (ReceiverRobloxUserId);
    CREATE INDEX IX_GameEggTransfers_ReceiverIdAlumno ON GameEggTransfers (ReceiverIdAlumno);

    ALTER TABLE GameEggTransfers ADD COLUMN Filter_UX_GameEggTransfers_EggId_Pending BIGINT GENERATED ALWAYS AS (CASE WHEN Status = 'PENDING' THEN EggId ELSE NULL END) STORED;
CREATE UNIQUE INDEX UX_GameEggTransfers_EggId_Pending ON GameEggTransfers (Filter_UX_GameEggTransfers_EggId_Pending);
END;
GO
CALL migrate_008_create_game_egg_transfers();
GO
DROP PROCEDURE migrate_008_create_game_egg_transfers;
GO
