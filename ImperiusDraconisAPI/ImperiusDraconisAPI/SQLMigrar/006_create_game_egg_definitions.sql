-- MySQL 8.0.16+. GO separates connector batches; DDL commits implicitly.
DROP PROCEDURE IF EXISTS migrate_006_create_game_egg_definitions;
GO
CREATE PROCEDURE migrate_006_create_game_egg_definitions()
migration: BEGIN

IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameEggs') THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No existe GameEggs. Ejecute primero las migraciones anteriores.';
END IF;

IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameEggDefinitions') THEN

    LEAVE migration;

END IF;
    CREATE TABLE GameEggDefinitions
    (
        Code VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
        DisplayName VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
        Description VARCHAR(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
        PriceDracoins INT NOT NULL,
        IncubationMinutes INT NOT NULL,
        DefaultRarity VARCHAR(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
        Active TINYINT(1) NOT NULL DEFAULT (1),
        Purchasable TINYINT(1) NOT NULL DEFAULT (1),
        SortOrder INT NOT NULL DEFAULT (0),
        CreatedAt DATETIME(3) NOT NULL DEFAULT (UTC_TIMESTAMP(3)),
        UpdatedAt DATETIME(3) NOT NULL DEFAULT (UTC_TIMESTAMP(3)),

        PRIMARY KEY (Code),
        CONSTRAINT UQ_GameEggDefinitions_DisplayName UNIQUE (DisplayName),

        CONSTRAINT CK_GameEggDefinitions_Code_Valid CHECK (
            CHAR_LENGTH(Code) > 0
            AND Code = LTRIM(RTRIM(Code))
            AND NOT REGEXP_LIKE(Code, '[^A-Z0-9_]', 'c')
        ),
        CONSTRAINT CK_GameEggDefinitions_DisplayName_NotBlank CHECK (CHAR_LENGTH(LTRIM(RTRIM(DisplayName))) > 0),
        CONSTRAINT CK_GameEggDefinitions_Description_NotBlank CHECK (CHAR_LENGTH(LTRIM(RTRIM(Description))) > 0),
        CONSTRAINT CK_GameEggDefinitions_PriceDracoins CHECK (PriceDracoins >= 0),
        CONSTRAINT CK_GameEggDefinitions_IncubationMinutes CHECK (IncubationMinutes > 0),
        CONSTRAINT CK_GameEggDefinitions_SortOrder CHECK (SortOrder >= 0),
        CONSTRAINT CK_GameEggDefinitions_DefaultRarity CHECK (DefaultRarity IN ('COMMON', 'RARE', 'EPIC', 'LEGENDARY', 'MYTHIC')),
        CONSTRAINT CK_GameEggDefinitions_PurchasablePrice CHECK (Purchasable = 0 OR PriceDracoins > 0)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

    CREATE INDEX IX_GameEggDefinitions_Active_SortOrder
        ON GameEggDefinitions (Active, SortOrder);

    INSERT INTO GameEggDefinitions (Code, DisplayName, Description, PriceDracoins, IncubationMinutes, DefaultRarity, Purchasable, SortOrder)
    VALUES
        ('HOME', 'Huevo de Hogar', 'Un huevo básico entregado a todos los nuevos estudiantes de la academia.', 300, 30, 'COMMON', 1, 10),
        ('ELEMENTAL_FIRE', 'Huevo Elemental de Fuego', 'Contiene la esencia de las llamas eternas de la academia.', 650, 120, 'RARE', 1, 20),
        ('ELEMENTAL_WATER', 'Huevo Elemental de Agua', 'Canaliza el fluir constante y la serenidad de los ríos mágicos.', 650, 120, 'RARE', 1, 30),
        ('ELEMENTAL_EARTH', 'Huevo Elemental de Tierra', 'Conectado con la fuerza inquebrantable del suelo de la academia.', 650, 120, 'RARE', 1, 40),
        ('ELEMENTAL_AIR', 'Huevo Elemental de Aire', 'Imbuido de las corrientes de viento de las torres más altas.', 650, 120, 'RARE', 1, 50),
        ('ELEMENTAL_ICE', 'Huevo Elemental de Hielo', 'Congelado a temperaturas místicas en las profundidades del norte.', 650, 120, 'RARE', 1, 60),
        ('ELEMENTAL_LIGHT', 'Huevo Elemental de Luz', 'Brilla con la pureza y el resplandor de la magia celestial.', 650, 120, 'RARE', 1, 70),
        ('ELEMENTAL_SHADOW', 'Huevo Elemental de Sombra', 'Forjado en la penumbra y el misterio de los rincones ocultos.', 650, 120, 'RARE', 1, 80),
        ('ELEMENTAL_POISON', 'Huevo Elemental de Veneno', 'Cargado de toxinas mágicas y esencias de pantanos arcanos.', 650, 120, 'RARE', 1, 90),
        ('EMBLEM_GRYFFINDOR', 'Huevo de Gryffindor', 'Representa el valor y el coraje de la casa del león.', 900, 240, 'EPIC', 1, 100),
        ('EMBLEM_HUFFLEPUFF', 'Huevo de Hufflepuff', 'Celebra la lealtad, la paciencia y el trabajo honesto.', 900, 240, 'EPIC', 1, 110),
        ('EMBLEM_RAVENCLAW', 'Huevo de Ravenclaw', 'Honra la sabiduría, el ingenio y el aprendizaje constante.', 900, 240, 'EPIC', 1, 120),
        ('EMBLEM_SLYTHERIN', 'Huevo de Slytherin', 'Refleja la ambición, la astucia y la determinación.', 900, 240, 'EPIC', 1, 130),
        ('ARCANE', 'Huevo Arcano', 'Imbuido de magia pura y ancestral, sumamente raro y poderoso.', 3000, 1440, 'LEGENDARY', 1, 140),
        ('CONSTELLATION', 'Huevo de Constelación', 'Un huevo cósmico obtenido únicamente a través de eventos especiales.', 0, 720, 'LEGENDARY', 0, 150);

    ALTER TABLE GameEggs
        ADD CONSTRAINT FK_GameEggs_GameEggDefinitions
        FOREIGN KEY (EggDefinitionCode) REFERENCES GameEggDefinitions (Code);
END;
GO
CALL migrate_006_create_game_egg_definitions();
GO
DROP PROCEDURE migrate_006_create_game_egg_definitions;
GO
