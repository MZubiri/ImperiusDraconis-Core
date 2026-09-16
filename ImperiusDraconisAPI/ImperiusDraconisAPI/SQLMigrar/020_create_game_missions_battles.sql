-- MySQL 8.0.16+. Daily missions, automatic battles and weighted ranking.
DROP PROCEDURE IF EXISTS migrate_020_create_game_missions_battles;
GO
CREATE PROCEDURE migrate_020_create_game_missions_battles()
BEGIN
    CREATE TABLE IF NOT EXISTS GameMissionDefinitions
    (
        Id INT AUTO_INCREMENT NOT NULL,
        Code VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
        DisplayName VARCHAR(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
        Description VARCHAR(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
        MissionType VARCHAR(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
        TargetAmount INT NOT NULL,
        RewardDracoins INT NOT NULL,
        RewardExperience INT NOT NULL,
        Active TINYINT(1) NOT NULL DEFAULT 1,
        SortOrder INT NOT NULL DEFAULT 0,
        PRIMARY KEY (Id), UNIQUE KEY UX_GameMissionDefinitions_Code (Code),
        CONSTRAINT CK_GameMissionDefinitions_Values CHECK (TargetAmount > 0 AND RewardDracoins >= 0 AND RewardExperience >= 0)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

    CREATE TABLE IF NOT EXISTS GamePlayerMissions
    (
        Id BIGINT AUTO_INCREMENT NOT NULL,
        IdAlumno INT NOT NULL,
        MissionDefinitionId INT NOT NULL,
        ProgressAmount INT NOT NULL DEFAULT 0,
        Status VARCHAR(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ACTIVE',
        AssignedDate DATE NOT NULL,
        ClaimedAt DATETIME(3) NULL,
        PRIMARY KEY (Id),
        UNIQUE KEY UX_GamePlayerMissions_Daily (IdAlumno, MissionDefinitionId, AssignedDate),
        KEY IX_GamePlayerMissions_PlayerDate (IdAlumno, AssignedDate),
        CONSTRAINT FK_GamePlayerMissions_Alumnos FOREIGN KEY (IdAlumno) REFERENCES Alumnos(IdAlumno) ON DELETE CASCADE,
        CONSTRAINT FK_GamePlayerMissions_Definitions FOREIGN KEY (MissionDefinitionId) REFERENCES GameMissionDefinitions(Id),
        CONSTRAINT CK_GamePlayerMissions_Status CHECK (Status IN ('ACTIVE', 'COMPLETED', 'CLAIMED')),
        CONSTRAINT CK_GamePlayerMissions_Progress CHECK (ProgressAmount >= 0)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

    CREATE TABLE IF NOT EXISTS GameWildDragonDefinitions
    (
        Code VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
        DisplayName VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
        SpeciesCode VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
        Rarity VARCHAR(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
        MinLevel INT NOT NULL,
        MaxLevel INT NOT NULL,
        BaseLife INT NOT NULL,
        BaseAttack INT NOT NULL,
        BaseDefense INT NOT NULL,
        Active TINYINT(1) NOT NULL DEFAULT 1,
        PRIMARY KEY (Code),
        CONSTRAINT CK_GameWildDragonDefinitions_Values CHECK (MinLevel > 0 AND MaxLevel >= MinLevel AND BaseLife > 0 AND BaseAttack > 0 AND BaseDefense > 0)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

    CREATE TABLE IF NOT EXISTS GameBattles
    (
        Id BIGINT AUTO_INCREMENT NOT NULL,
        IdAlumno INT NOT NULL,
        PlayerDragonId BIGINT NOT NULL,
        OpponentAlumnoId INT NULL,
        OpponentDragonId BIGINT NULL,
        WildDragonCode VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
        OpponentSnapshotJson JSON NOT NULL,
        RoundsJson JSON NOT NULL,
        Result VARCHAR(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
        RankingPoints INT NOT NULL DEFAULT 0,
        RewardDracoins INT NOT NULL DEFAULT 0,
        RewardExperience INT NOT NULL DEFAULT 0,
        CreatedAt DATETIME(3) NOT NULL DEFAULT (UTC_TIMESTAMP(3)),
        PRIMARY KEY (Id), KEY IX_GameBattles_PlayerCreated (IdAlumno, CreatedAt),
        CONSTRAINT FK_GameBattles_Alumnos FOREIGN KEY (IdAlumno) REFERENCES Alumnos(IdAlumno) ON DELETE CASCADE,
        CONSTRAINT FK_GameBattles_PlayerDragon FOREIGN KEY (PlayerDragonId) REFERENCES GameDragons(Id),
        CONSTRAINT CK_GameBattles_Result CHECK (Result IN ('WIN', 'DRAW', 'LOSS')),
        CONSTRAINT CK_GameBattles_Rewards CHECK (RankingPoints >= 0 AND RewardDracoins >= 0 AND RewardExperience >= 0)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

    INSERT INTO GameMissionDefinitions (Code, DisplayName, Description, MissionType, TargetAmount, RewardDracoins, RewardExperience, SortOrder) VALUES
        ('FEED_ONE', 'Buen cuidador', 'Alimenta a un dragon.', 'FEED_DRAGON', 1, 35, 5, 10),
        ('PET_ONE', 'Un poco de afecto', 'Acaricia a un dragon.', 'PET_DRAGON', 1, 25, 5, 20),
        ('BATTLE_ONE', 'Entrenamiento diario', 'Completa un duelo automatico.', 'COMPLETE_BATTLE', 1, 50, 10, 30)
    ON DUPLICATE KEY UPDATE DisplayName=VALUES(DisplayName), Description=VALUES(Description), TargetAmount=VALUES(TargetAmount), RewardDracoins=VALUES(RewardDracoins), RewardExperience=VALUES(RewardExperience), SortOrder=VALUES(SortOrder);

    INSERT INTO GameWildDragonDefinitions (Code, DisplayName, SpeciesCode, Rarity, MinLevel, MaxLevel, BaseLife, BaseAttack, BaseDefense) VALUES
        ('WILD_BRASALOMA', 'Brasaloma salvaje', 'BRASALOMA', 'COMMON', 1, 8, 90, 10, 7),
        ('WILD_ROCAMUSGO', 'Rocamusgo salvaje', 'ROCAMUSGO', 'RARE', 4, 14, 110, 9, 12),
        ('WILD_ORACLE', 'Oraculo errante', 'ORACULO_ZAFIRO', 'EPIC', 10, 20, 120, 13, 13)
    ON DUPLICATE KEY UPDATE DisplayName=VALUES(DisplayName), MinLevel=VALUES(MinLevel), MaxLevel=VALUES(MaxLevel), BaseLife=VALUES(BaseLife), BaseAttack=VALUES(BaseAttack), BaseDefense=VALUES(BaseDefense);
END;
GO
CALL migrate_020_create_game_missions_battles();
GO
DROP PROCEDURE migrate_020_create_game_missions_battles;
GO
