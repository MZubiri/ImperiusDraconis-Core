-- MySQL 8.0.16+. GO separates connector batches; DDL commits implicitly.
DROP PROCEDURE IF EXISTS migrate_007_create_game_dragons;
GO
CREATE PROCEDURE migrate_007_create_game_dragons()
migration: BEGIN

IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'Alumnos') THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No existe la tabla Alumnos. Ejecute primero las migraciones base.';
END IF;

IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameEggs') THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No existe GameEggs. Ejecute primero las migraciones anteriores.';
END IF;

IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameDragons') THEN

    LEAVE migration;

END IF;
    CREATE TABLE GameDragons
    (
        Id BIGINT AUTO_INCREMENT NOT NULL,
        IdAlumno INT NOT NULL,
        Name VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
        Rarity VARCHAR(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
        Temperament VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
        Level INT NOT NULL DEFAULT (1),
        Stage VARCHAR(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT ('BABY'),
        HatchedAt DATETIME(3) NOT NULL DEFAULT (UTC_TIMESTAMP(3)),

        PRIMARY KEY (Id),
        CONSTRAINT FK_GameDragons_Alumnos FOREIGN KEY (IdAlumno) REFERENCES Alumnos (IdAlumno),
        CONSTRAINT CK_GameDragons_Name_NotBlank CHECK (CHAR_LENGTH(LTRIM(RTRIM(Name))) > 0),
        CONSTRAINT CK_GameDragons_Rarity CHECK (Rarity IN ('COMMON', 'RARE', 'EPIC', 'LEGENDARY', 'MYTHIC')),
        CONSTRAINT CK_GameDragons_Temperament CHECK (Temperament IN ('NOBLE', 'AGRESIVO', 'JUGUETON', 'CURIOSO', 'PEREZOSO')),
        CONSTRAINT CK_GameDragons_Level CHECK (Level >= 1),
        CONSTRAINT CK_GameDragons_Stage CHECK (Stage IN ('BABY', 'YOUNG', 'ADULT'))
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

    CREATE INDEX IX_GameDragons_IdAlumno ON GameDragons (IdAlumno);

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'GameEggs' AND column_name = 'HatchedDragonId') THEN
        ALTER TABLE GameEggs ADD HatchedDragonId BIGINT NULL;

        ALTER TABLE GameEggs
            ADD CONSTRAINT FK_GameEggs_GameDragons
            FOREIGN KEY (HatchedDragonId) REFERENCES GameDragons (Id);

END IF;
END;
GO
CALL migrate_007_create_game_dragons();
GO
DROP PROCEDURE migrate_007_create_game_dragons;
GO
