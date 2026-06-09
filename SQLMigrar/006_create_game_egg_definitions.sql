/*
    Migracion: 006_create_game_egg_definitions
    Proposito: Crear catalogo y definiciones de huevos de Imperius Dragons.
    Fecha: 2026-06-09

    Requisitos:
    - SQL Server 2016 o superior.
    - La tabla dbo.GameEggs debe existir.
*/

SET NOCOUNT ON;
SET XACT_ABORT ON;
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID(N'dbo.GameEggs', N'U') IS NULL
    THROW 50031, 'No existe dbo.GameEggs. Ejecute primero las migraciones anteriores.', 1;
GO

IF OBJECT_ID(N'dbo.GameEggDefinitions', N'U') IS NOT NULL
BEGIN
    PRINT 'Migracion 006_create_game_egg_definitions ya aplicada.';
    RETURN;
END;

BEGIN TRY
    BEGIN TRANSACTION;

    -- 1. Crear tabla de definiciones de huevos
    CREATE TABLE dbo.GameEggDefinitions
    (
        Code NVARCHAR(50) NOT NULL,
        DisplayName NVARCHAR(100) NOT NULL,
        Description NVARCHAR(300) NOT NULL,
        PriceDracoins INT NOT NULL,
        IncubationMinutes INT NOT NULL,
        DefaultRarity NVARCHAR(20) NOT NULL,
        Active BIT NOT NULL CONSTRAINT DF_GameEggDefinitions_Active DEFAULT (1),
        Purchasable BIT NOT NULL CONSTRAINT DF_GameEggDefinitions_Purchasable DEFAULT (1),
        SortOrder INT NOT NULL CONSTRAINT DF_GameEggDefinitions_SortOrder DEFAULT (0),
        CreatedAt DATETIME2(3) NOT NULL CONSTRAINT DF_GameEggDefinitions_CreatedAt DEFAULT SYSUTCDATETIME(),
        UpdatedAt DATETIME2(3) NOT NULL CONSTRAINT DF_GameEggDefinitions_UpdatedAt DEFAULT SYSUTCDATETIME(),

        CONSTRAINT PK_GameEggDefinitions PRIMARY KEY CLUSTERED (Code),
        CONSTRAINT UQ_GameEggDefinitions_DisplayName UNIQUE (DisplayName),
        
        CONSTRAINT CK_GameEggDefinitions_Code_Valid CHECK (
            LEN(Code) > 0
            AND Code = LTRIM(RTRIM(Code))
            AND Code COLLATE Latin1_General_100_BIN2 NOT LIKE '%[^A-Z0-9_]%' COLLATE Latin1_General_100_BIN2
        ),
        CONSTRAINT CK_GameEggDefinitions_DisplayName_NotBlank CHECK (LEN(LTRIM(RTRIM(DisplayName))) > 0),
        CONSTRAINT CK_GameEggDefinitions_Description_NotBlank CHECK (LEN(LTRIM(RTRIM(Description))) > 0),
        CONSTRAINT CK_GameEggDefinitions_PriceDracoins CHECK (PriceDracoins >= 0),
        CONSTRAINT CK_GameEggDefinitions_IncubationMinutes CHECK (IncubationMinutes > 0),
        CONSTRAINT CK_GameEggDefinitions_SortOrder CHECK (SortOrder >= 0),
        CONSTRAINT CK_GameEggDefinitions_DefaultRarity CHECK (DefaultRarity IN (N'COMMON', N'RARE', N'EPIC', N'LEGENDARY', N'MYTHIC')),
        CONSTRAINT CK_GameEggDefinitions_PurchasablePrice CHECK (Purchasable = 0 OR PriceDracoins > 0)
    );

    -- 2. Crear indice recomendado para listar catalogo ordenado
    CREATE NONCLUSTERED INDEX IX_GameEggDefinitions_Active_SortOrder
        ON dbo.GameEggDefinitions (Active, SortOrder)
        INCLUDE (DisplayName, Description, PriceDracoins, IncubationMinutes, DefaultRarity, Purchasable);

    -- 3. Insertar catalogo semilla completo
    INSERT INTO dbo.GameEggDefinitions (Code, DisplayName, Description, PriceDracoins, IncubationMinutes, DefaultRarity, Purchasable, SortOrder)
    VALUES
        (N'HOME', N'Huevo de Hogar', N'Un huevo básico entregado a todos los nuevos estudiantes de la academia.', 300, 30, N'COMMON', 1, 10),
        (N'ELEMENTAL_FIRE', N'Huevo Elemental de Fuego', N'Contiene la esencia de las llamas eternas de la academia.', 650, 120, N'RARE', 1, 20),
        (N'ELEMENTAL_WATER', N'Huevo Elemental de Agua', N'Canaliza el fluir constante y la serenidad de los ríos mágicos.', 650, 120, N'RARE', 1, 30),
        (N'ELEMENTAL_EARTH', N'Huevo Elemental de Tierra', N'Conectado con la fuerza inquebrantable del suelo de la academia.', 650, 120, N'RARE', 1, 40),
        (N'ELEMENTAL_AIR', N'Huevo Elemental de Aire', N'Imbuido de las corrientes de viento de las torres más altas.', 650, 120, N'RARE', 1, 50),
        (N'ELEMENTAL_ICE', N'Huevo Elemental de Hielo', N'Congelado a temperaturas místicas en las profundidades del norte.', 650, 120, N'RARE', 1, 60),
        (N'ELEMENTAL_LIGHT', N'Huevo Elemental de Luz', N'Brilla con la pureza y el resplandor de la magia celestial.', 650, 120, N'RARE', 1, 70),
        (N'ELEMENTAL_SHADOW', N'Huevo Elemental de Sombra', N'Forjado en la penumbra y el misterio de los rincones ocultos.', 650, 120, N'RARE', 1, 80),
        (N'ELEMENTAL_POISON', N'Huevo Elemental de Veneno', N'Cargado de toxinas mágicas y esencias de pantanos arcanos.', 650, 120, N'RARE', 1, 90),
        (N'EMBLEM_GRYFFINDOR', N'Huevo de Gryffindor', N'Representa el valor y el coraje de la casa del león.', 900, 240, N'EPIC', 1, 100),
        (N'EMBLEM_HUFFLEPUFF', N'Huevo de Hufflepuff', N'Celebra la lealtad, la paciencia y el trabajo honesto.', 900, 240, N'EPIC', 1, 110),
        (N'EMBLEM_RAVENCLAW', N'Huevo de Ravenclaw', N'Honra la sabiduría, el ingenio y el aprendizaje constante.', 900, 240, N'EPIC', 1, 120),
        (N'EMBLEM_SLYTHERIN', N'Huevo de Slytherin', N'Refleja la ambición, la astucia y la determinación.', 900, 240, N'EPIC', 1, 130),
        (N'ARCANE', N'Huevo Arcano', N'Imbuido de magia pura y ancestral, sumamente raro y poderoso.', 3000, 1440, N'LEGENDARY', 1, 140),
        (N'CONSTELLATION', N'Huevo de Constelación', N'Un huevo cósmico obtenido únicamente a través de eventos especiales.', 0, 720, N'LEGENDARY', 0, 150);

    -- 4. Establecer integridad referencial
    ALTER TABLE dbo.GameEggs WITH CHECK
        ADD CONSTRAINT FK_GameEggs_GameEggDefinitions
        FOREIGN KEY (EggDefinitionCode) REFERENCES dbo.GameEggDefinitions (Code);

    COMMIT TRANSACTION;
    PRINT 'Migracion 006_create_game_egg_definitions aplicada correctamente.';
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;
GO
