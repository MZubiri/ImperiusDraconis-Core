-- MySQL 8.0.16+. Adds the dragon care catalog and state required by the playable MVP.
DROP PROCEDURE IF EXISTS migrate_019_create_game_care_loop;
GO
CREATE PROCEDURE migrate_019_create_game_care_loop()
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameDragons') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No existe GameDragons. Ejecute primero las migraciones anteriores.';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'GameDragons' AND column_name = 'SpeciesCode') THEN
        ALTER TABLE GameDragons ADD SpeciesCode VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'BRASALOMA' AFTER Temperament;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'GameDragons' AND column_name = 'LastPettedAt') THEN
        ALTER TABLE GameDragons ADD LastPettedAt DATETIME(3) NULL AFTER LastNeedsUpdateAt;
    END IF;

    CREATE TABLE IF NOT EXISTS GameDragonDefinitions
    (
        Code VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
        DisplayName VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
        ElementCode VARCHAR(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
        BaseLife INT NOT NULL DEFAULT 100,
        BaseAttack INT NOT NULL,
        BaseDefense INT NOT NULL,
        Active TINYINT(1) NOT NULL DEFAULT 1,
        PRIMARY KEY (Code),
        CONSTRAINT CK_GameDragonDefinitions_Stats CHECK (BaseLife > 0 AND BaseAttack > 0 AND BaseDefense > 0)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

    CREATE TABLE IF NOT EXISTS GameTemperamentDefinitions
    (
        Code VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
        DisplayName VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
        AttackModifierPct INT NOT NULL DEFAULT 0,
        DefenseModifierPct INT NOT NULL DEFAULT 0,
        HungerDecayModifierPct INT NOT NULL DEFAULT 0,
        HappinessGainModifierPct INT NOT NULL DEFAULT 0,
        ExperienceModifierPct INT NOT NULL DEFAULT 0,
        BehaviorText VARCHAR(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
        Active TINYINT(1) NOT NULL DEFAULT 1,
        PRIMARY KEY (Code),
        CONSTRAINT CK_GameTemperamentDefinitions_Modifiers CHECK (
            AttackModifierPct BETWEEN -5 AND 5 AND DefenseModifierPct BETWEEN -5 AND 5
            AND HungerDecayModifierPct BETWEEN -5 AND 5 AND HappinessGainModifierPct BETWEEN -5 AND 5
            AND ExperienceModifierPct BETWEEN -5 AND 5)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

    CREATE TABLE IF NOT EXISTS GameFoodDefinitions
    (
        Code VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
        DisplayName VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
        Description VARCHAR(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
        PriceDracoins INT NOT NULL,
        HungerGain INT NOT NULL DEFAULT 0,
        LifeGain INT NOT NULL DEFAULT 0,
        HappinessGain INT NOT NULL DEFAULT 0,
        ExperienceGain INT NOT NULL DEFAULT 0,
        Active TINYINT(1) NOT NULL DEFAULT 1,
        SortOrder INT NOT NULL DEFAULT 0,
        PRIMARY KEY (Code),
        CONSTRAINT CK_GameFoodDefinitions_Values CHECK (
            PriceDracoins >= 0 AND HungerGain >= 0 AND LifeGain >= 0
            AND HappinessGain >= 0 AND ExperienceGain >= 0)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

    INSERT INTO GameDragonDefinitions (Code, DisplayName, ElementCode, BaseAttack, BaseDefense) VALUES
        ('BRASALOMA', 'Brasaloma', 'FIRE', 12, 8),
        ('ROCAMUSGO', 'Rocamusgo', 'EARTH', 8, 12),
        ('MAREALUNA', 'Marealuna', 'WATER', 10, 10),
        ('CIERZOAZUL', 'Cierzoazul', 'AIR', 11, 9),
        ('ESCARCHALETA', 'Escarchaleta', 'ICE', 10, 11),
        ('LEONIS_RUBRA', 'Leonis Rubra', 'FIRE', 13, 10),
        ('MELIDOR_AUREO', 'Melidor Aureo', 'EARTH', 10, 13),
        ('VIPERUMBRA', 'Viperumbra Esmeralda', 'SHADOW', 13, 9),
        ('ORACULO_ZAFIRO', 'Oraculo Zafiro', 'ARCANE', 11, 12),
        ('ECLIPSE_PRIMORDIAL', 'Eclipse Primordial', 'ARCANE', 14, 14)
    ON DUPLICATE KEY UPDATE DisplayName = VALUES(DisplayName), ElementCode = VALUES(ElementCode), BaseAttack = VALUES(BaseAttack), BaseDefense = VALUES(BaseDefense);

    INSERT INTO GameTemperamentDefinitions
        (Code, DisplayName, AttackModifierPct, DefenseModifierPct, HungerDecayModifierPct, HappinessGainModifierPct, ExperienceModifierPct, BehaviorText) VALUES
        ('NOBLE', 'Noble', 0, 3, 0, 0, 0, 'Tu dragon inclina la cabeza con dignidad.'),
        ('AGRESIVO', 'Agresivo', 5, -3, 0, 0, 0, 'Tu dragon ruge con energia desafiante.'),
        ('JUGUETON', 'Jugueton', 0, 0, 0, 5, 0, 'Tu dragon da un salto y pide seguir jugando.'),
        ('CURIOSO', 'Curioso', 0, 0, 0, 0, 3, 'Tu dragon observa todo con mucha atencion.'),
        ('PEREZOSO', 'Perezoso', -2, 0, -5, 0, 0, 'Tu dragon bosteza y se acomoda a tu lado.')
    ON DUPLICATE KEY UPDATE DisplayName = VALUES(DisplayName), AttackModifierPct=VALUES(AttackModifierPct), DefenseModifierPct=VALUES(DefenseModifierPct), HungerDecayModifierPct=VALUES(HungerDecayModifierPct), HappinessGainModifierPct=VALUES(HappinessGainModifierPct), ExperienceModifierPct=VALUES(ExperienceModifierPct), BehaviorText = VALUES(BehaviorText);

    INSERT INTO GameFoodDefinitions
        (Code, DisplayName, Description, PriceDracoins, HungerGain, LifeGain, HappinessGain, ExperienceGain, SortOrder) VALUES
        ('BARN_BITE', 'Bocado de Granero', 'Mezcla sencilla para cuidado diario.', 8, 20, 0, 0, 0, 10),
        ('SILVER_FISH', 'Pez Plateado', 'Favorito de dragones de Agua y Hielo.', 12, 30, 0, 0, 0, 20),
        ('SUN_FRUIT', 'Fruta Solar', 'Fruta tibia que mejora el animo.', 15, 20, 0, 5, 0, 30),
        ('CRUNCHY_ROOT', 'Raiz Crujiente', 'Alimento abundante de los jardines magicos.', 18, 35, 0, 3, 0, 40),
        ('DRACONIC_FEAST', 'Banquete Draconico', 'Recuperacion completa tras varios dias.', 35, 60, 5, 10, 0, 50),
        ('HONEY_CRYSTAL', 'Cristal de Miel', 'Recupera especialmente la felicidad.', 45, 10, 0, 25, 0, 60),
        ('VITAL_ELIXIR', 'Elixir Vital', 'Ayuda a un dragon debilitado.', 70, 5, 25, 5, 0, 70),
        ('STAR_BERRY', 'Baya Estelar', 'Apoya el crecimiento y la experiencia.', 90, 20, 0, 10, 10, 80)
    ON DUPLICATE KEY UPDATE DisplayName = VALUES(DisplayName), Description = VALUES(Description), PriceDracoins = VALUES(PriceDracoins), HungerGain = VALUES(HungerGain), LifeGain = VALUES(LifeGain), HappinessGain = VALUES(HappinessGain), ExperienceGain = VALUES(ExperienceGain), SortOrder = VALUES(SortOrder);
END;
GO
CALL migrate_019_create_game_care_loop();
GO
DROP PROCEDURE migrate_019_create_game_care_loop;
GO
