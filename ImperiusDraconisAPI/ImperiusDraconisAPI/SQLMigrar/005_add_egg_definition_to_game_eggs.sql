-- MySQL 8.0.16+. GO separates connector batches; DDL commits implicitly.
DROP PROCEDURE IF EXISTS migrate_005_add_egg_definition_to_game_eggs;
GO
CREATE PROCEDURE migrate_005_add_egg_definition_to_game_eggs()
migration: BEGIN
DECLARE v_0 INT;
DECLARE v_1 INT;
IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameEggs') THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No existe GameEggs. Ejecute primero la migracion 004.';
END IF;

SET v_0 = CASE WHEN NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'GameEggs' AND column_name = 'EggDefinitionCode') THEN 0 ELSE 1 END;
SET v_1 = CASE WHEN NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND constraint_name = 'CK_GameEggs_EggDefinitionCode_Valid') THEN 0 ELSE 1 END;

IF v_0 = 1 AND v_1 = 1 THEN

    LEAVE migration;

END IF;
IF v_0 <> v_1 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Migracion 005 parcialmente aplicada. Revise GameEggs antes de continuar.';
END IF;

        ALTER TABLE GameEggs
            ADD EggDefinitionCode VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL;

        ALTER TABLE GameEggs
            ADD CONSTRAINT CK_GameEggs_EggDefinitionCode_Valid
            CHECK
            (
                EggDefinitionCode IS NULL
                OR
                (
                    CHAR_LENGTH(EggDefinitionCode) > 0
                    AND EggDefinitionCode = LTRIM(RTRIM(EggDefinitionCode))
                    AND NOT REGEXP_LIKE(EggDefinitionCode, '[^A-Z0-9_]', 'c')
                )
            );
END;
GO
CALL migrate_005_add_egg_definition_to_game_eggs();
GO
DROP PROCEDURE migrate_005_add_egg_definition_to_game_eggs;
GO
