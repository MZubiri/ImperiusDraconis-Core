-- MySQL 8.0.16+. GO separates connector batches; DDL commits implicitly.
DROP PROCEDURE IF EXISTS migrate_009_add_selected_to_game_dragons;
GO
CREATE PROCEDURE migrate_009_add_selected_to_game_dragons()
migration: BEGIN

IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameDragons') THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No existe la tabla GameDragons. Ejecute primero las migraciones anteriores.';
END IF;

IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'GameDragons' AND column_name = 'Selected') THEN

    LEAVE migration;

END IF;
    ALTER TABLE GameDragons ADD
        Selected TINYINT(1) NOT NULL DEFAULT (0),
        ADD Status VARCHAR(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT ('ACTIVE'),
        ADD Life INT NOT NULL DEFAULT (100),
        ADD Happiness INT NOT NULL DEFAULT (100),
        ADD Hunger INT NOT NULL DEFAULT (100),
        ADD Experience INT NOT NULL DEFAULT (0),
        ADD LastNeedsUpdateAt DATETIME(3) NOT NULL DEFAULT (UTC_TIMESTAMP(3));

    ALTER TABLE GameDragons ADD
        CONSTRAINT CK_GameDragons_Status CHECK (Status IN ('ACTIVE', 'FLED')),
        ADD CONSTRAINT CK_GameDragons_Life CHECK (Life >= 0 AND Life <= 100),
        ADD CONSTRAINT CK_GameDragons_Happiness CHECK (Happiness >= 0 AND Happiness <= 100),
        ADD CONSTRAINT CK_GameDragons_Hunger CHECK (Hunger >= 0 AND Hunger <= 100),
        ADD CONSTRAINT CK_GameDragons_Experience CHECK (Experience >= 0);

    ALTER TABLE GameDragons ADD COLUMN Filter_UX_GameDragons_IdAlumno_Selected BIGINT GENERATED ALWAYS AS (CASE WHEN Selected = 1 THEN IdAlumno ELSE NULL END) STORED;
CREATE UNIQUE INDEX UX_GameDragons_IdAlumno_Selected ON GameDragons (Filter_UX_GameDragons_IdAlumno_Selected);
END;
GO
CALL migrate_009_add_selected_to_game_dragons();
GO
DROP PROCEDURE migrate_009_add_selected_to_game_dragons;
GO
