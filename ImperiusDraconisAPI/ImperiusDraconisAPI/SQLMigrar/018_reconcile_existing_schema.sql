-- Upgrade existing MySQL installations without replacing tables or changing rows.
-- Apply 017 then 018 explicitly after a verified full backup; do not replay seed scripts.
-- Requires MySQL 8.0.16+. GO is the application/tool batch separator.
-- DDL commits implicitly. Preflight every rule before any table alteration.
-- Historical RowVersion DATETIME columns are intentionally retained: services do not use them.
DROP PROCEDURE IF EXISTS migrate_018_reconcile_existing_schema;
GO
CREATE PROCEDURE migrate_018_reconcile_existing_schema()
BEGIN

    IF EXISTS (SELECT 1 FROM GameDragonCapacity WHERE PurchasedSlots < 0 OR MaxCapacity < 0) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '018: negative dragon capacity; no table altered';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'CuentasVinculadas') THEN
        IF EXISTS (SELECT 1 FROM `CuentasVinculadas` WHERE NOT ((`IdAlumnoA` < `IdAlumnoB`))) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '018: invalid rows for CK_CuentasVinculadas_NoAutoreferencial';
        END IF;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameDracoinLedger') THEN
        IF EXISTS (SELECT 1 FROM `GameDracoinLedger` WHERE NOT ((`Amount` <> 0))) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '018: invalid rows for CK_GameDracoinLedger_Amount_NotZero';
        END IF;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameDracoinLedger') THEN
        IF EXISTS (SELECT 1 FROM `GameDracoinLedger` WHERE NOT ((`Amount` = round(`Amount`,0)))) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '018: invalid rows for CK_GameDracoinLedger_Amount_Whole';
        END IF;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameDracoinLedger') THEN
        IF EXISTS (SELECT 1 FROM `GameDracoinLedger` WHERE NOT ((`BalanceAfter` >= 0))) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '018: invalid rows for CK_GameDracoinLedger_BalanceAfter_NonNegative';
        END IF;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameDracoinLedger') THEN
        IF EXISTS (SELECT 1 FROM `GameDracoinLedger` WHERE NOT ((`BalanceAfter` = round(`BalanceAfter`,0)))) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '018: invalid rows for CK_GameDracoinLedger_BalanceAfter_Whole';
        END IF;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameDracoinLedger') THEN
        IF EXISTS (SELECT 1 FROM `GameDracoinLedger` WHERE NOT ((char_length(ltrim(rtrim(`Reason`))) > 0))) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '018: invalid rows for CK_GameDracoinLedger_Reason_NotBlank';
        END IF;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameDracoinLedger') THEN
        IF EXISTS (SELECT 1 FROM `GameDracoinLedger` WHERE NOT (((`ReferenceId` is null) or (char_length(ltrim(rtrim(`ReferenceId`))) > 0)))) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '018: invalid rows for CK_GameDracoinLedger_ReferenceId_NotBlank';
        END IF;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameDracoinLedger') THEN
        IF EXISTS (SELECT 1 FROM `GameDracoinLedger` WHERE NOT ((char_length(ltrim(rtrim(`ReferenceType`))) > 0))) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '018: invalid rows for CK_GameDracoinLedger_ReferenceType_NotBlank';
        END IF;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameDragonCapacity') THEN
        IF EXISTS (SELECT 1 FROM `GameDragonCapacity` WHERE NOT ((`MaxCapacity` between 1 and 10))) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '018: invalid rows for CK_GameDragonCapacity_MaxCapacity';
        END IF;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameDragonCapacity') THEN
        IF EXISTS (SELECT 1 FROM `GameDragonCapacity` WHERE NOT ((`PurchasedSlots` <= 9))) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '018: invalid rows for CK_GameDragonCapacity_PurchasedSlots';
        END IF;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameDragonCapacity') THEN
        IF EXISTS (SELECT 1 FROM `GameDragonCapacity` WHERE NOT (((cast(`PurchasedSlots` as unsigned) + 1) <= cast(`MaxCapacity` as unsigned)))) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '018: invalid rows for CK_GameDragonCapacity_TotalWithinMaximum';
        END IF;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameDragons') THEN
        IF EXISTS (SELECT 1 FROM `GameDragons` WHERE NOT ((`Experience` >= 0))) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '018: invalid rows for CK_GameDragons_Experience';
        END IF;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameDragons') THEN
        IF EXISTS (SELECT 1 FROM `GameDragons` WHERE NOT (((`Happiness` >= 0) and (`Happiness` <= 100)))) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '018: invalid rows for CK_GameDragons_Happiness';
        END IF;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameDragons') THEN
        IF EXISTS (SELECT 1 FROM `GameDragons` WHERE NOT (((`Hunger` >= 0) and (`Hunger` <= 100)))) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '018: invalid rows for CK_GameDragons_Hunger';
        END IF;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameDragons') THEN
        IF EXISTS (SELECT 1 FROM `GameDragons` WHERE NOT ((`Level` >= 1))) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '018: invalid rows for CK_GameDragons_Level';
        END IF;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameDragons') THEN
        IF EXISTS (SELECT 1 FROM `GameDragons` WHERE NOT (((`Life` >= 0) and (`Life` <= 100)))) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '018: invalid rows for CK_GameDragons_Life';
        END IF;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameDragons') THEN
        IF EXISTS (SELECT 1 FROM `GameDragons` WHERE NOT ((char_length(ltrim(rtrim(`Name`))) > 0))) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '018: invalid rows for CK_GameDragons_Name_NotBlank';
        END IF;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameDragons') THEN
        IF EXISTS (SELECT 1 FROM `GameDragons` WHERE NOT ((`Rarity` in (_utf8mb4'COMMON',_utf8mb4'RARE',_utf8mb4'EPIC',_utf8mb4'LEGENDARY',_utf8mb4'MYTHIC')))) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '018: invalid rows for CK_GameDragons_Rarity';
        END IF;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameDragons') THEN
        IF EXISTS (SELECT 1 FROM `GameDragons` WHERE NOT ((`Stage` in (_utf8mb4'BABY',_utf8mb4'YOUNG',_utf8mb4'ADULT')))) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '018: invalid rows for CK_GameDragons_Stage';
        END IF;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameDragons') THEN
        IF EXISTS (SELECT 1 FROM `GameDragons` WHERE NOT ((`Status` in (_utf8mb4'ACTIVE',_utf8mb4'FLED')))) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '018: invalid rows for CK_GameDragons_Status';
        END IF;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameDragons') THEN
        IF EXISTS (SELECT 1 FROM `GameDragons` WHERE NOT ((`Temperament` in (_utf8mb4'NOBLE',_utf8mb4'AGRESIVO',_utf8mb4'JUGUETON',_utf8mb4'CURIOSO',_utf8mb4'PEREZOSO')))) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '018: invalid rows for CK_GameDragons_Temperament';
        END IF;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameEggDefinitions') THEN
        IF EXISTS (SELECT 1 FROM `GameEggDefinitions` WHERE NOT (((char_length(`Code`) > 0) and (`Code` = ltrim(rtrim(`Code`))) and (not(regexp_like(`Code`,_utf8mb4'[^A-Z0-9_]',_latin1'c')))))) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '018: invalid rows for CK_GameEggDefinitions_Code_Valid';
        END IF;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameEggDefinitions') THEN
        IF EXISTS (SELECT 1 FROM `GameEggDefinitions` WHERE NOT ((`DefaultRarity` in (_utf8mb4'COMMON',_utf8mb4'RARE',_utf8mb4'EPIC',_utf8mb4'LEGENDARY',_utf8mb4'MYTHIC')))) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '018: invalid rows for CK_GameEggDefinitions_DefaultRarity';
        END IF;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameEggDefinitions') THEN
        IF EXISTS (SELECT 1 FROM `GameEggDefinitions` WHERE NOT ((char_length(ltrim(rtrim(`Description`))) > 0))) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '018: invalid rows for CK_GameEggDefinitions_Description_NotBlank';
        END IF;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameEggDefinitions') THEN
        IF EXISTS (SELECT 1 FROM `GameEggDefinitions` WHERE NOT ((char_length(ltrim(rtrim(`DisplayName`))) > 0))) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '018: invalid rows for CK_GameEggDefinitions_DisplayName_NotBlank';
        END IF;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameEggDefinitions') THEN
        IF EXISTS (SELECT 1 FROM `GameEggDefinitions` WHERE NOT ((`IncubationMinutes` > 0))) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '018: invalid rows for CK_GameEggDefinitions_IncubationMinutes';
        END IF;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameEggDefinitions') THEN
        IF EXISTS (SELECT 1 FROM `GameEggDefinitions` WHERE NOT ((`PriceDracoins` >= 0))) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '018: invalid rows for CK_GameEggDefinitions_PriceDracoins';
        END IF;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameEggDefinitions') THEN
        IF EXISTS (SELECT 1 FROM `GameEggDefinitions` WHERE NOT (((`Purchasable` = 0) or (`PriceDracoins` > 0)))) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '018: invalid rows for CK_GameEggDefinitions_PurchasablePrice';
        END IF;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameEggDefinitions') THEN
        IF EXISTS (SELECT 1 FROM `GameEggDefinitions` WHERE NOT ((`SortOrder` >= 0))) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '018: invalid rows for CK_GameEggDefinitions_SortOrder';
        END IF;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameEggTransfers') THEN
        IF EXISTS (SELECT 1 FROM `GameEggTransfers` WHERE NOT ((`Status` in (_utf8mb4'PENDING',_utf8mb4'ACCEPTED',_utf8mb4'REJECTED')))) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '018: invalid rows for CK_GameEggTransfers_Status';
        END IF;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameEggTransfers') THEN
        IF EXISTS (SELECT 1 FROM `GameEggTransfers` WHERE NOT ((`UpdatedAt` >= `CreatedAt`))) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '018: invalid rows for CK_GameEggTransfers_UpdatedAt';
        END IF;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameEggs') THEN
        IF EXISTS (SELECT 1 FROM `GameEggs` WHERE NOT (((`EggDefinitionCode` is null) or ((char_length(`EggDefinitionCode`) > 0) and (`EggDefinitionCode` = ltrim(rtrim(`EggDefinitionCode`))) and (not(regexp_like(`EggDefinitionCode`,_utf8mb4'[^A-Z0-9_]',_latin1'c'))))))) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '018: invalid rows for CK_GameEggs_EggDefinitionCode_Valid';
        END IF;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameEggs') THEN
        IF EXISTS (SELECT 1 FROM `GameEggs` WHERE NOT (((`IncubationStartedAt` is null) or ((`IncubationStartedAt` >= `AcquiredAt`) and (`IncubationEndsAt` > `IncubationStartedAt`))))) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '018: invalid rows for CK_GameEggs_IncubationDates';
        END IF;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameEggs') THEN
        IF EXISTS (SELECT 1 FROM `GameEggs` WHERE NOT ((((`IncubationStartedAt` is null) and (`IncubationEndsAt` is null)) or ((`IncubationStartedAt` is not null) and (`IncubationEndsAt` is not null))))) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '018: invalid rows for CK_GameEggs_IncubationPair';
        END IF;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameEggs') THEN
        IF EXISTS (SELECT 1 FROM `GameEggs` WHERE NOT ((`Rarity` in (_utf8mb4'COMMON',_utf8mb4'RARE',_utf8mb4'EPIC',_utf8mb4'LEGENDARY',_utf8mb4'MYTHIC')))) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '018: invalid rows for CK_GameEggs_Rarity';
        END IF;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameEggs') THEN
        IF EXISTS (SELECT 1 FROM `GameEggs` WHERE NOT ((`Status` in (_utf8mb4'OWNED',_utf8mb4'INCUBATING',_utf8mb4'READY_TO_HATCH',_utf8mb4'HATCHED',_utf8mb4'IN_TRANSFER')))) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '018: invalid rows for CK_GameEggs_Status';
        END IF;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameEggs') THEN
        IF EXISTS (SELECT 1 FROM `GameEggs` WHERE NOT ((((`Status` in (_latin1'OWNED',_latin1'IN_TRANSFER')) and (`IncubationStartedAt` is null) and (`IncubationEndsAt` is null)) or ((`Status` in (_latin1'INCUBATING',_latin1'READY_TO_HATCH',_latin1'HATCHED')) and (`IncubationStartedAt` is not null) and (`IncubationEndsAt` is not null))))) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '018: invalid rows for CK_GameEggs_StatusDates';
        END IF;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameEggs') THEN
        IF EXISTS (SELECT 1 FROM `GameEggs` WHERE NOT ((`UpdatedAt` >= `AcquiredAt`))) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '018: invalid rows for CK_GameEggs_UpdatedAfterAcquired';
        END IF;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameIdempotency') THEN
        IF EXISTS (SELECT 1 FROM `GameIdempotency` WHERE NOT (((`CompletedAt` is null) or (`CompletedAt` >= `CreatedAt`)))) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '018: invalid rows for CK_GameIdempotency_CompletedAfterCreation';
        END IF;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameIdempotency') THEN
        IF EXISTS (SELECT 1 FROM `GameIdempotency` WHERE NOT ((((`Status` = _utf8mb4'Pending') and (`CompletedAt` is null) and (`ResponseStatusCode` is null) and (`ResponseJson` is null)) or ((`Status` = _utf8mb4'Completed') and (`CompletedAt` is not null) and (`ResponseStatusCode` is not null) and (`ResponseJson` is not null))))) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '018: invalid rows for CK_GameIdempotency_CompletedState';
        END IF;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameIdempotency') THEN
        IF EXISTS (SELECT 1 FROM `GameIdempotency` WHERE NOT (((`ExpiresAt` is null) or (`ExpiresAt` > `CreatedAt`)))) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '018: invalid rows for CK_GameIdempotency_ExpiresAfterCreation';
        END IF;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameIdempotency') THEN
        IF EXISTS (SELECT 1 FROM `GameIdempotency` WHERE NOT ((char_length(ltrim(rtrim(`IdempotencyKey`))) > 0))) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '018: invalid rows for CK_GameIdempotency_Key_NotBlank';
        END IF;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameIdempotency') THEN
        IF EXISTS (SELECT 1 FROM `GameIdempotency` WHERE NOT ((char_length(ltrim(rtrim(`Operation`))) > 0))) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '018: invalid rows for CK_GameIdempotency_Operation_NotBlank';
        END IF;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameIdempotency') THEN
        IF EXISTS (SELECT 1 FROM `GameIdempotency` WHERE NOT (((`ResponseJson` is null) or (json_valid(`ResponseJson`) = 1)))) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '018: invalid rows for CK_GameIdempotency_ResponseJson';
        END IF;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameIdempotency') THEN
        IF EXISTS (SELECT 1 FROM `GameIdempotency` WHERE NOT (((`ResponseStatusCode` is null) or (`ResponseStatusCode` between 100 and 599)))) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '018: invalid rows for CK_GameIdempotency_ResponseStatusCode';
        END IF;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameIdempotency') THEN
        IF EXISTS (SELECT 1 FROM `GameIdempotency` WHERE NOT ((`Status` in (_utf8mb4'Pending',_utf8mb4'Completed')))) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '018: invalid rows for CK_GameIdempotency_Status';
        END IF;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameLinkCodes') THEN
        IF EXISTS (SELECT 1 FROM `GameLinkCodes` WHERE NOT ((`ExpiresAt` > `CreatedAt`))) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '018: invalid rows for CK_GameLinkCodes_ExpiresAfterCreation';
        END IF;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameLinkCodes') THEN
        IF EXISTS (SELECT 1 FROM `GameLinkCodes` WHERE NOT (((`UsedAt` is null) or (`RevokedAt` is null)))) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '018: invalid rows for CK_GameLinkCodes_NotUsedAndRevoked';
        END IF;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameLinkCodes') THEN
        IF EXISTS (SELECT 1 FROM `GameLinkCodes` WHERE NOT (((`RevokedAt` is null) or (`RevokedAt` >= `CreatedAt`)))) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '018: invalid rows for CK_GameLinkCodes_RevokedAfterCreation';
        END IF;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameLinkCodes') THEN
        IF EXISTS (SELECT 1 FROM `GameLinkCodes` WHERE NOT (((`UsedAt` is null) or (`UsedAt` >= `CreatedAt`)))) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '018: invalid rows for CK_GameLinkCodes_UsedAfterCreation';
        END IF;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameLinkCodes') THEN
        IF EXISTS (SELECT 1 FROM `GameLinkCodes` WHERE NOT (((`UsedAt` is null) or (`UsedAt` <= `ExpiresAt`)))) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '018: invalid rows for CK_GameLinkCodes_UsedBeforeExpiration';
        END IF;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameRobloxLinks') THEN
        IF EXISTS (SELECT 1 FROM `GameRobloxLinks` WHERE NOT ((((`Active` = 1) and (`UnlinkedAt` is null)) or ((`Active` = 0) and (`UnlinkedAt` is not null))))) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '018: invalid rows for CK_GameRobloxLinks_ActiveState';
        END IF;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameRobloxLinks') THEN
        IF EXISTS (SELECT 1 FROM `GameRobloxLinks` WHERE NOT ((`RobloxUserId` > 0))) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '018: invalid rows for CK_GameRobloxLinks_RobloxUserId_Positive';
        END IF;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameRobloxLinks') THEN
        IF EXISTS (SELECT 1 FROM `GameRobloxLinks` WHERE NOT (((`UnlinkedAt` is null) or (`UnlinkedAt` >= `LinkedAt`)))) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '018: invalid rows for CK_GameRobloxLinks_UnlinkedAfterLinked';
        END IF;
    END IF;

    IF EXISTS (SELECT `IdAlumno` FROM `GameLinkCodes` WHERE UsedAt IS NULL AND RevokedAt IS NULL GROUP BY `IdAlumno` HAVING COUNT(*) > 1) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '018: duplicates for UX_GameLinkCodes_Active_IdAlumno';
    END IF;

    IF EXISTS (SELECT `CodeHash` FROM `GameLinkCodes` WHERE UsedAt IS NULL AND RevokedAt IS NULL GROUP BY `CodeHash` HAVING COUNT(*) > 1) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '018: duplicates for UX_GameLinkCodes_Active_CodeHash';
    END IF;

    IF EXISTS (SELECT `IdAlumno` FROM `GameDracoinLedger` WHERE Reason = 'WELCOME_LINK' GROUP BY `IdAlumno` HAVING COUNT(*) > 1) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '018: duplicates for UX_GameDracoinLedger_WelcomeLink_IdAlumno';
    END IF;

    IF EXISTS (SELECT `IdAlumno` FROM `GameDragons` WHERE Selected = 1 GROUP BY `IdAlumno` HAVING COUNT(*) > 1) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '018: duplicates for UX_GameDragons_IdAlumno_Selected';
    END IF;

    IF EXISTS (SELECT `EggId` FROM `GameEggTransfers` WHERE Status = 'PENDING' GROUP BY `EggId` HAVING COUNT(*) > 1) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '018: duplicates for UX_GameEggTransfers_EggId_Pending';
    END IF;


    -- Defaults and widening conversions only. Preserve row data and identifiers.

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'AlumnoPreferencias' AND column_name = 'Valor' AND (column_type <> 'longtext')) THEN
        ALTER TABLE `AlumnoPreferencias` MODIFY COLUMN `Valor` LONGTEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'AlumnoPreferencias' AND column_name = 'FechaActualizacion' AND (column_type <> 'datetime' OR column_default IS NULL OR column_default <> 'utc_timestamp(3)')) THEN
        ALTER TABLE `AlumnoPreferencias` MODIFY COLUMN `FechaActualizacion` DATETIME NOT NULL DEFAULT (UTC_TIMESTAMP(3));
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'Alumnos' AND column_name = 'Activo' AND (column_type <> 'tinyint' OR column_default IS NULL OR column_default <> '1')) THEN
        ALTER TABLE `Alumnos` MODIFY COLUMN `Activo` TINYINT NULL DEFAULT 1;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'Alumnos' AND column_name = 'Dracoins' AND (column_type <> 'decimal(18,2)' OR column_default IS NULL OR column_default <> '0.00')) THEN
        ALTER TABLE `Alumnos` MODIFY COLUMN `Dracoins` DECIMAL(18,2) NULL DEFAULT 0.00;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'AlumnosLibrosComprados' AND column_name = 'FechaCompra' AND (column_type <> 'datetime' OR column_default IS NULL OR column_default <> 'CURRENT_TIMESTAMP')) THEN
        ALTER TABLE `AlumnosLibrosComprados` MODIFY COLUMN `FechaCompra` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'AlumnosSuscripciones' AND column_name = 'FechaInicio' AND (column_type <> 'datetime' OR column_default IS NULL OR column_default <> 'CURRENT_TIMESTAMP')) THEN
        ALTER TABLE `AlumnosSuscripciones` MODIFY COLUMN `FechaInicio` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'AlumnosSuscripciones' AND column_name = 'Activa' AND (column_type <> 'tinyint(1)' OR column_default IS NULL OR column_default <> '1')) THEN
        ALTER TABLE `AlumnosSuscripciones` MODIFY COLUMN `Activa` TINYINT(1) NOT NULL DEFAULT 1;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'AuditoriaEventos' AND column_name = 'DetallesJson' AND (column_type <> 'longtext')) THEN
        ALTER TABLE `AuditoriaEventos` MODIFY COLUMN `DetallesJson` LONGTEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'AuditoriaEventos' AND column_name = 'FechaEvento' AND (column_type <> 'datetime' OR column_default IS NULL OR column_default <> 'CURRENT_TIMESTAMP')) THEN
        ALTER TABLE `AuditoriaEventos` MODIFY COLUMN `FechaEvento` DATETIME NULL DEFAULT CURRENT_TIMESTAMP;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'BibliotecaCategorias' AND column_name = 'Descripcion' AND (column_type <> 'longtext')) THEN
        ALTER TABLE `BibliotecaCategorias` MODIFY COLUMN `Descripcion` LONGTEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'BibliotecaCategorias' AND column_name = 'Activo' AND (column_type <> 'tinyint(1)' OR column_default IS NULL OR column_default <> '1')) THEN
        ALTER TABLE `BibliotecaCategorias` MODIFY COLUMN `Activo` TINYINT(1) NOT NULL DEFAULT 1;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'BibliotecaHistorialLectura' AND column_name = 'UltimaPaginaLeida' AND (column_type <> 'int' OR column_default IS NULL OR column_default <> '1')) THEN
        ALTER TABLE `BibliotecaHistorialLectura` MODIFY COLUMN `UltimaPaginaLeida` INT NOT NULL DEFAULT 1;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'BibliotecaHistorialLectura' AND column_name = 'UltimoAcceso' AND (column_type <> 'datetime' OR column_default IS NULL OR column_default <> 'CURRENT_TIMESTAMP')) THEN
        ALTER TABLE `BibliotecaHistorialLectura` MODIFY COLUMN `UltimoAcceso` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'BibliotecaLibros' AND column_name = 'Sinopsis' AND (column_type <> 'longtext')) THEN
        ALTER TABLE `BibliotecaLibros` MODIFY COLUMN `Sinopsis` LONGTEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'BibliotecaLibros' AND column_name = 'PrecioDracoins' AND (column_type <> 'decimal(18,2)' OR column_default IS NULL OR column_default <> '0.00')) THEN
        ALTER TABLE `BibliotecaLibros` MODIFY COLUMN `PrecioDracoins` DECIMAL(18,2) NOT NULL DEFAULT 0.00;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'BibliotecaLibros' AND column_name = 'FechaRegistro' AND (column_type <> 'datetime' OR column_default IS NULL OR column_default <> 'CURRENT_TIMESTAMP')) THEN
        ALTER TABLE `BibliotecaLibros` MODIFY COLUMN `FechaRegistro` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'BibliotecaLibros' AND column_name = 'Activo' AND (column_type <> 'tinyint(1)' OR column_default IS NULL OR column_default <> '1')) THEN
        ALTER TABLE `BibliotecaLibros` MODIFY COLUMN `Activo` TINYINT(1) NOT NULL DEFAULT 1;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'CuentasEspeciales' AND column_name = 'MultiplicadorAuditoria' AND (column_type <> 'decimal(3,2)' OR column_default IS NULL OR column_default <> '1.00')) THEN
        ALTER TABLE `CuentasEspeciales` MODIFY COLUMN `MultiplicadorAuditoria` DECIMAL(3,2) NOT NULL DEFAULT 1.00;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'CuentasEspeciales' AND column_name = 'FechaRegistro' AND (column_type <> 'datetime' OR column_default IS NULL OR column_default <> 'CURRENT_TIMESTAMP')) THEN
        ALTER TABLE `CuentasEspeciales` MODIFY COLUMN `FechaRegistro` DATETIME NULL DEFAULT CURRENT_TIMESTAMP;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'CuentasVinculadas' AND column_name = 'FuerzaVinculo' AND (column_type <> 'int' OR column_default IS NULL OR column_default <> '1')) THEN
        ALTER TABLE `CuentasVinculadas` MODIFY COLUMN `FuerzaVinculo` INT NOT NULL DEFAULT 1;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'CuentasVinculadas' AND column_name = 'CreadoEn' AND (column_type <> 'datetime' OR column_default IS NULL OR column_default <> 'CURRENT_TIMESTAMP')) THEN
        ALTER TABLE `CuentasVinculadas` MODIFY COLUMN `CreadoEn` DATETIME NULL DEFAULT CURRENT_TIMESTAMP;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'CuentasVinculadas' AND column_name = 'ActualizadoEn' AND (column_type <> 'datetime' OR column_default IS NULL OR column_default <> 'CURRENT_TIMESTAMP')) THEN
        ALTER TABLE `CuentasVinculadas` MODIFY COLUMN `ActualizadoEn` DATETIME NULL DEFAULT CURRENT_TIMESTAMP;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'DecisionesAdministrativas' AND column_name = 'NotasInternas' AND (column_type <> 'longtext')) THEN
        ALTER TABLE `DecisionesAdministrativas` MODIFY COLUMN `NotasInternas` LONGTEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'DecisionesAdministrativas' AND column_name = 'FechaDecision' AND (column_type <> 'datetime' OR column_default IS NULL OR column_default <> 'CURRENT_TIMESTAMP')) THEN
        ALTER TABLE `DecisionesAdministrativas` MODIFY COLUMN `FechaDecision` DATETIME NULL DEFAULT CURRENT_TIMESTAMP;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'DispositivosAlumno' AND column_name = 'FechaPrimerAcceso' AND (column_type <> 'datetime' OR column_default IS NULL OR column_default <> 'CURRENT_TIMESTAMP')) THEN
        ALTER TABLE `DispositivosAlumno` MODIFY COLUMN `FechaPrimerAcceso` DATETIME NULL DEFAULT CURRENT_TIMESTAMP;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'DispositivosAlumno' AND column_name = 'FechaUltimoAcceso' AND (column_type <> 'datetime' OR column_default IS NULL OR column_default <> 'CURRENT_TIMESTAMP')) THEN
        ALTER TABLE `DispositivosAlumno` MODIFY COLUMN `FechaUltimoAcceso` DATETIME NULL DEFAULT CURRENT_TIMESTAMP;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'ExcepcionesAuditoria' AND column_name = 'FechaCreado' AND (column_type <> 'datetime' OR column_default IS NULL OR column_default <> 'CURRENT_TIMESTAMP')) THEN
        ALTER TABLE `ExcepcionesAuditoria` MODIFY COLUMN `FechaCreado` DATETIME NULL DEFAULT CURRENT_TIMESTAMP;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'ExcepcionesAuditoria' AND column_name = 'Activa' AND (column_type <> 'tinyint(1)' OR column_default IS NULL OR column_default <> '1')) THEN
        ALTER TABLE `ExcepcionesAuditoria` MODIFY COLUMN `Activa` TINYINT(1) NOT NULL DEFAULT 1;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'GameDracoinLedger' AND column_name = 'CreatedAt' AND (column_type <> 'datetime(3)' OR column_default IS NULL OR column_default <> 'utc_timestamp(3)')) THEN
        ALTER TABLE `GameDracoinLedger` MODIFY COLUMN `CreatedAt` DATETIME(3) NOT NULL DEFAULT (UTC_TIMESTAMP(3));
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'GameDragonCapacity' AND column_name = 'PurchasedSlots' AND (column_type <> 'tinyint unsigned' OR column_default IS NULL OR column_default <> '0')) THEN
        ALTER TABLE `GameDragonCapacity` MODIFY COLUMN `PurchasedSlots` TINYINT UNSIGNED NOT NULL DEFAULT 0;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'GameDragonCapacity' AND column_name = 'MaxCapacity' AND (column_type <> 'tinyint unsigned' OR column_default IS NULL OR column_default <> '10')) THEN
        ALTER TABLE `GameDragonCapacity` MODIFY COLUMN `MaxCapacity` TINYINT UNSIGNED NOT NULL DEFAULT 10;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'GameDragonCapacity' AND column_name = 'UpdatedAt' AND (column_type <> 'datetime(3)' OR column_default IS NULL OR column_default <> 'utc_timestamp(3)')) THEN
        ALTER TABLE `GameDragonCapacity` MODIFY COLUMN `UpdatedAt` DATETIME(3) NOT NULL DEFAULT (UTC_TIMESTAMP(3));
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'GameDragons' AND column_name = 'Level' AND (column_type <> 'int' OR column_default IS NULL OR column_default <> '1')) THEN
        ALTER TABLE `GameDragons` MODIFY COLUMN `Level` INT NOT NULL DEFAULT 1;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'GameDragons' AND column_name = 'Stage' AND (column_type <> 'varchar(20)' OR column_default IS NULL OR column_default <> 'BABY')) THEN
        ALTER TABLE `GameDragons` MODIFY COLUMN `Stage` VARCHAR(20) NOT NULL DEFAULT 'BABY';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'GameDragons' AND column_name = 'HatchedAt' AND (column_type <> 'datetime(3)' OR column_default IS NULL OR column_default <> 'utc_timestamp(3)')) THEN
        ALTER TABLE `GameDragons` MODIFY COLUMN `HatchedAt` DATETIME(3) NOT NULL DEFAULT (UTC_TIMESTAMP(3));
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'GameDragons' AND column_name = 'Selected' AND (column_type <> 'tinyint(1)' OR column_default IS NULL OR column_default <> '0')) THEN
        ALTER TABLE `GameDragons` MODIFY COLUMN `Selected` TINYINT(1) NOT NULL DEFAULT 0;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'GameDragons' AND column_name = 'Status' AND (column_type <> 'varchar(20)' OR column_default IS NULL OR column_default <> 'ACTIVE')) THEN
        ALTER TABLE `GameDragons` MODIFY COLUMN `Status` VARCHAR(20) NOT NULL DEFAULT 'ACTIVE';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'GameDragons' AND column_name = 'Life' AND (column_type <> 'int' OR column_default IS NULL OR column_default <> '100')) THEN
        ALTER TABLE `GameDragons` MODIFY COLUMN `Life` INT NOT NULL DEFAULT 100;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'GameDragons' AND column_name = 'Happiness' AND (column_type <> 'int' OR column_default IS NULL OR column_default <> '100')) THEN
        ALTER TABLE `GameDragons` MODIFY COLUMN `Happiness` INT NOT NULL DEFAULT 100;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'GameDragons' AND column_name = 'Hunger' AND (column_type <> 'int' OR column_default IS NULL OR column_default <> '100')) THEN
        ALTER TABLE `GameDragons` MODIFY COLUMN `Hunger` INT NOT NULL DEFAULT 100;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'GameDragons' AND column_name = 'Experience' AND (column_type <> 'int' OR column_default IS NULL OR column_default <> '0')) THEN
        ALTER TABLE `GameDragons` MODIFY COLUMN `Experience` INT NOT NULL DEFAULT 0;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'GameDragons' AND column_name = 'LastNeedsUpdateAt' AND (column_type <> 'datetime(3)' OR column_default IS NULL OR column_default <> 'utc_timestamp(3)')) THEN
        ALTER TABLE `GameDragons` MODIFY COLUMN `LastNeedsUpdateAt` DATETIME(3) NOT NULL DEFAULT (UTC_TIMESTAMP(3));
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'GameEggDefinitions' AND column_name = 'Active' AND (column_type <> 'tinyint(1)' OR column_default IS NULL OR column_default <> '1')) THEN
        ALTER TABLE `GameEggDefinitions` MODIFY COLUMN `Active` TINYINT(1) NOT NULL DEFAULT 1;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'GameEggDefinitions' AND column_name = 'Purchasable' AND (column_type <> 'tinyint(1)' OR column_default IS NULL OR column_default <> '1')) THEN
        ALTER TABLE `GameEggDefinitions` MODIFY COLUMN `Purchasable` TINYINT(1) NOT NULL DEFAULT 1;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'GameEggDefinitions' AND column_name = 'SortOrder' AND (column_type <> 'int' OR column_default IS NULL OR column_default <> '0')) THEN
        ALTER TABLE `GameEggDefinitions` MODIFY COLUMN `SortOrder` INT NOT NULL DEFAULT 0;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'GameEggDefinitions' AND column_name = 'CreatedAt' AND (column_type <> 'datetime(3)' OR column_default IS NULL OR column_default <> 'utc_timestamp(3)')) THEN
        ALTER TABLE `GameEggDefinitions` MODIFY COLUMN `CreatedAt` DATETIME(3) NOT NULL DEFAULT (UTC_TIMESTAMP(3));
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'GameEggDefinitions' AND column_name = 'UpdatedAt' AND (column_type <> 'datetime(3)' OR column_default IS NULL OR column_default <> 'utc_timestamp(3)')) THEN
        ALTER TABLE `GameEggDefinitions` MODIFY COLUMN `UpdatedAt` DATETIME(3) NOT NULL DEFAULT (UTC_TIMESTAMP(3));
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'GameEggTransfers' AND column_name = 'Status' AND (column_type <> 'varchar(20)' OR column_default IS NULL OR column_default <> 'PENDING')) THEN
        ALTER TABLE `GameEggTransfers` MODIFY COLUMN `Status` VARCHAR(20) NOT NULL DEFAULT 'PENDING';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'GameEggTransfers' AND column_name = 'CreatedAt' AND (column_type <> 'datetime(3)' OR column_default IS NULL OR column_default <> 'utc_timestamp(3)')) THEN
        ALTER TABLE `GameEggTransfers` MODIFY COLUMN `CreatedAt` DATETIME(3) NOT NULL DEFAULT (UTC_TIMESTAMP(3));
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'GameEggTransfers' AND column_name = 'UpdatedAt' AND (column_type <> 'datetime(3)' OR column_default IS NULL OR column_default <> 'utc_timestamp(3)')) THEN
        ALTER TABLE `GameEggTransfers` MODIFY COLUMN `UpdatedAt` DATETIME(3) NOT NULL DEFAULT (UTC_TIMESTAMP(3));
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'GameEggs' AND column_name = 'AcquiredAt' AND (column_type <> 'datetime(3)' OR column_default IS NULL OR column_default <> 'utc_timestamp(3)')) THEN
        ALTER TABLE `GameEggs` MODIFY COLUMN `AcquiredAt` DATETIME(3) NOT NULL DEFAULT (UTC_TIMESTAMP(3));
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'GameEggs' AND column_name = 'IncubationStartedAt' AND (column_type <> 'datetime(3)')) THEN
        ALTER TABLE `GameEggs` MODIFY COLUMN `IncubationStartedAt` DATETIME(3) NULL;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'GameEggs' AND column_name = 'IncubationEndsAt' AND (column_type <> 'datetime(3)')) THEN
        ALTER TABLE `GameEggs` MODIFY COLUMN `IncubationEndsAt` DATETIME(3) NULL;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'GameEggs' AND column_name = 'Status' AND (column_type <> 'varchar(20)' OR column_default IS NULL OR column_default <> 'OWNED')) THEN
        ALTER TABLE `GameEggs` MODIFY COLUMN `Status` VARCHAR(20) NOT NULL DEFAULT 'OWNED';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'GameEggs' AND column_name = 'UpdatedAt' AND (column_type <> 'datetime(3)' OR column_default IS NULL OR column_default <> 'utc_timestamp(3)')) THEN
        ALTER TABLE `GameEggs` MODIFY COLUMN `UpdatedAt` DATETIME(3) NOT NULL DEFAULT (UTC_TIMESTAMP(3));
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'GameIdempotency' AND column_name = 'Status' AND (column_type <> 'varchar(20)' OR column_default IS NULL OR column_default <> 'Pending')) THEN
        ALTER TABLE `GameIdempotency` MODIFY COLUMN `Status` VARCHAR(20) NOT NULL DEFAULT 'Pending';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'GameIdempotency' AND column_name = 'ResponseJson' AND (column_type <> 'longtext')) THEN
        ALTER TABLE `GameIdempotency` MODIFY COLUMN `ResponseJson` LONGTEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'GameIdempotency' AND column_name = 'CreatedAt' AND (column_type <> 'datetime(3)' OR column_default IS NULL OR column_default <> 'utc_timestamp(3)')) THEN
        ALTER TABLE `GameIdempotency` MODIFY COLUMN `CreatedAt` DATETIME(3) NOT NULL DEFAULT (UTC_TIMESTAMP(3));
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'GameIdempotency' AND column_name = 'CompletedAt' AND (column_type <> 'datetime(3)')) THEN
        ALTER TABLE `GameIdempotency` MODIFY COLUMN `CompletedAt` DATETIME(3) NULL;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'GameIdempotency' AND column_name = 'ExpiresAt' AND (column_type <> 'datetime(3)')) THEN
        ALTER TABLE `GameIdempotency` MODIFY COLUMN `ExpiresAt` DATETIME(3) NULL;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'GameLinkCodes' AND column_name = 'ExpiresAt' AND (column_type <> 'datetime(3)')) THEN
        ALTER TABLE `GameLinkCodes` MODIFY COLUMN `ExpiresAt` DATETIME(3) NOT NULL;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'GameLinkCodes' AND column_name = 'UsedAt' AND (column_type <> 'datetime(3)')) THEN
        ALTER TABLE `GameLinkCodes` MODIFY COLUMN `UsedAt` DATETIME(3) NULL;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'GameLinkCodes' AND column_name = 'RevokedAt' AND (column_type <> 'datetime(3)')) THEN
        ALTER TABLE `GameLinkCodes` MODIFY COLUMN `RevokedAt` DATETIME(3) NULL;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'GameLinkCodes' AND column_name = 'CreatedAt' AND (column_type <> 'datetime(3)' OR column_default IS NULL OR column_default <> 'utc_timestamp(3)')) THEN
        ALTER TABLE `GameLinkCodes` MODIFY COLUMN `CreatedAt` DATETIME(3) NOT NULL DEFAULT (UTC_TIMESTAMP(3));
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'GameRobloxLinks' AND column_name = 'LinkedAt' AND (column_type <> 'datetime(3)' OR column_default IS NULL OR column_default <> 'utc_timestamp(3)')) THEN
        ALTER TABLE `GameRobloxLinks` MODIFY COLUMN `LinkedAt` DATETIME(3) NOT NULL DEFAULT (UTC_TIMESTAMP(3));
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'GameRobloxLinks' AND column_name = 'Active' AND (column_type <> 'tinyint(1)' OR column_default IS NULL OR column_default <> '1')) THEN
        ALTER TABLE `GameRobloxLinks` MODIFY COLUMN `Active` TINYINT(1) NOT NULL DEFAULT 1;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'GameRobloxLinks' AND column_name = 'UnlinkedAt' AND (column_type <> 'datetime(3)')) THEN
        ALTER TABLE `GameRobloxLinks` MODIFY COLUMN `UnlinkedAt` DATETIME(3) NULL;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'HistorialAccesos' AND column_name = 'FechaAcceso' AND (column_type <> 'datetime' OR column_default IS NULL OR column_default <> 'CURRENT_TIMESTAMP')) THEN
        ALTER TABLE `HistorialAccesos` MODIFY COLUMN `FechaAcceso` DATETIME NULL DEFAULT CURRENT_TIMESTAMP;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'LandingConfiguracion' AND column_name = 'FechaActualizacion' AND (column_type <> 'datetime' OR column_default IS NULL OR column_default <> 'utc_timestamp(3)')) THEN
        ALTER TABLE `LandingConfiguracion` MODIFY COLUMN `FechaActualizacion` DATETIME NOT NULL DEFAULT (UTC_TIMESTAMP(3));
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'LandingContenido' AND column_name = 'Activo' AND (column_type <> 'tinyint(1)' OR column_default IS NULL OR column_default <> '0')) THEN
        ALTER TABLE `LandingContenido` MODIFY COLUMN `Activo` TINYINT(1) NOT NULL DEFAULT 0;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'LandingContenido' AND column_name = 'FechaActualizacion' AND (column_type <> 'datetime' OR column_default IS NULL OR column_default <> 'utc_timestamp(3)')) THEN
        ALTER TABLE `LandingContenido` MODIFY COLUMN `FechaActualizacion` DATETIME NOT NULL DEFAULT (UTC_TIMESTAMP(3));
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'ResumenAuditoriaAccesos' AND column_name = 'RelevanciaAuditoria' AND (column_type <> 'int' OR column_default IS NULL OR column_default <> '0')) THEN
        ALTER TABLE `ResumenAuditoriaAccesos` MODIFY COLUMN `RelevanciaAuditoria` INT NOT NULL DEFAULT 0;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'ResumenAuditoriaAccesos' AND column_name = 'MotivosDetalle' AND (column_type <> 'longtext')) THEN
        ALTER TABLE `ResumenAuditoriaAccesos` MODIFY COLUMN `MotivosDetalle` LONGTEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'ResumenAuditoriaAccesos' AND column_name = 'EvidenciasJson' AND (column_type <> 'longtext')) THEN
        ALTER TABLE `ResumenAuditoriaAccesos` MODIFY COLUMN `EvidenciasJson` LONGTEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'ResumenAuditoriaAccesos' AND column_name = 'UltimaEvaluacion' AND (column_type <> 'datetime' OR column_default IS NULL OR column_default <> 'CURRENT_TIMESTAMP')) THEN
        ALTER TABLE `ResumenAuditoriaAccesos` MODIFY COLUMN `UltimaEvaluacion` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'Chismes' AND column_name = 'FechaEnvio' AND (column_type <> 'datetime' OR column_default IS NULL OR column_default <> 'CURRENT_TIMESTAMP')) THEN
        ALTER TABLE `Chismes` MODIFY COLUMN `FechaEnvio` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'NotasAlumno' AND column_name = 'Fecha' AND (column_type <> 'datetime' OR column_default IS NULL OR column_default <> 'CURRENT_TIMESTAMP')) THEN
        ALTER TABLE `NotasAlumno` MODIFY COLUMN `Fecha` DATETIME NULL DEFAULT CURRENT_TIMESTAMP;
    END IF;


    -- Conditional unique indexes are represented with nullable generated columns.

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'GameLinkCodes' AND column_name = 'Filter_UX_GameLinkCodes_Active_IdAlumno') THEN
        ALTER TABLE `GameLinkCodes` ADD COLUMN `Filter_UX_GameLinkCodes_Active_IdAlumno` BIGINT GENERATED ALWAYS AS (CASE WHEN UsedAt IS NULL AND RevokedAt IS NULL THEN `IdAlumno` ELSE NULL END) STORED;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.statistics WHERE table_schema = DATABASE() AND table_name = 'GameLinkCodes' AND index_name = 'UX_GameLinkCodes_Active_IdAlumno') THEN
        CREATE UNIQUE INDEX `UX_GameLinkCodes_Active_IdAlumno` ON `GameLinkCodes` (`Filter_UX_GameLinkCodes_Active_IdAlumno`);
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'GameLinkCodes' AND column_name = 'Filter_UX_GameLinkCodes_Active_CodeHash') THEN
        ALTER TABLE `GameLinkCodes` ADD COLUMN `Filter_UX_GameLinkCodes_Active_CodeHash` BINARY(32) GENERATED ALWAYS AS (CASE WHEN UsedAt IS NULL AND RevokedAt IS NULL THEN `CodeHash` ELSE NULL END) STORED;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.statistics WHERE table_schema = DATABASE() AND table_name = 'GameLinkCodes' AND index_name = 'UX_GameLinkCodes_Active_CodeHash') THEN
        CREATE UNIQUE INDEX `UX_GameLinkCodes_Active_CodeHash` ON `GameLinkCodes` (`Filter_UX_GameLinkCodes_Active_CodeHash`);
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'GameDracoinLedger' AND column_name = 'Filter_UX_GameDracoinLedger_WelcomeLink_IdAlumno') THEN
        ALTER TABLE `GameDracoinLedger` ADD COLUMN `Filter_UX_GameDracoinLedger_WelcomeLink_IdAlumno` BIGINT GENERATED ALWAYS AS (CASE WHEN Reason = 'WELCOME_LINK' THEN `IdAlumno` ELSE NULL END) STORED;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.statistics WHERE table_schema = DATABASE() AND table_name = 'GameDracoinLedger' AND index_name = 'UX_GameDracoinLedger_WelcomeLink_IdAlumno') THEN
        CREATE UNIQUE INDEX `UX_GameDracoinLedger_WelcomeLink_IdAlumno` ON `GameDracoinLedger` (`Filter_UX_GameDracoinLedger_WelcomeLink_IdAlumno`);
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'GameDragons' AND column_name = 'Filter_UX_GameDragons_IdAlumno_Selected') THEN
        ALTER TABLE `GameDragons` ADD COLUMN `Filter_UX_GameDragons_IdAlumno_Selected` BIGINT GENERATED ALWAYS AS (CASE WHEN Selected = 1 THEN `IdAlumno` ELSE NULL END) STORED;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.statistics WHERE table_schema = DATABASE() AND table_name = 'GameDragons' AND index_name = 'UX_GameDragons_IdAlumno_Selected') THEN
        CREATE UNIQUE INDEX `UX_GameDragons_IdAlumno_Selected` ON `GameDragons` (`Filter_UX_GameDragons_IdAlumno_Selected`);
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'GameEggTransfers' AND column_name = 'Filter_UX_GameEggTransfers_EggId_Pending') THEN
        ALTER TABLE `GameEggTransfers` ADD COLUMN `Filter_UX_GameEggTransfers_EggId_Pending` BIGINT GENERATED ALWAYS AS (CASE WHEN Status = 'PENDING' THEN `EggId` ELSE NULL END) STORED;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.statistics WHERE table_schema = DATABASE() AND table_name = 'GameEggTransfers' AND index_name = 'UX_GameEggTransfers_EggId_Pending') THEN
        CREATE UNIQUE INDEX `UX_GameEggTransfers_EggId_Pending` ON `GameEggTransfers` (`Filter_UX_GameEggTransfers_EggId_Pending`);
    END IF;


    -- Existing data passed the same expressions above before any ALTER TABLE.

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'CuentasVinculadas') AND NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND table_name = 'CuentasVinculadas' AND constraint_name = 'CK_CuentasVinculadas_NoAutoreferencial') THEN
        ALTER TABLE `CuentasVinculadas` ADD CONSTRAINT `CK_CuentasVinculadas_NoAutoreferencial` CHECK ((`IdAlumnoA` < `IdAlumnoB`));
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameDracoinLedger') AND NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND table_name = 'GameDracoinLedger' AND constraint_name = 'CK_GameDracoinLedger_Amount_NotZero') THEN
        ALTER TABLE `GameDracoinLedger` ADD CONSTRAINT `CK_GameDracoinLedger_Amount_NotZero` CHECK ((`Amount` <> 0));
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameDracoinLedger') AND NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND table_name = 'GameDracoinLedger' AND constraint_name = 'CK_GameDracoinLedger_Amount_Whole') THEN
        ALTER TABLE `GameDracoinLedger` ADD CONSTRAINT `CK_GameDracoinLedger_Amount_Whole` CHECK ((`Amount` = round(`Amount`,0)));
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameDracoinLedger') AND NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND table_name = 'GameDracoinLedger' AND constraint_name = 'CK_GameDracoinLedger_BalanceAfter_NonNegative') THEN
        ALTER TABLE `GameDracoinLedger` ADD CONSTRAINT `CK_GameDracoinLedger_BalanceAfter_NonNegative` CHECK ((`BalanceAfter` >= 0));
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameDracoinLedger') AND NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND table_name = 'GameDracoinLedger' AND constraint_name = 'CK_GameDracoinLedger_BalanceAfter_Whole') THEN
        ALTER TABLE `GameDracoinLedger` ADD CONSTRAINT `CK_GameDracoinLedger_BalanceAfter_Whole` CHECK ((`BalanceAfter` = round(`BalanceAfter`,0)));
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameDracoinLedger') AND NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND table_name = 'GameDracoinLedger' AND constraint_name = 'CK_GameDracoinLedger_Reason_NotBlank') THEN
        ALTER TABLE `GameDracoinLedger` ADD CONSTRAINT `CK_GameDracoinLedger_Reason_NotBlank` CHECK ((char_length(ltrim(rtrim(`Reason`))) > 0));
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameDracoinLedger') AND NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND table_name = 'GameDracoinLedger' AND constraint_name = 'CK_GameDracoinLedger_ReferenceId_NotBlank') THEN
        ALTER TABLE `GameDracoinLedger` ADD CONSTRAINT `CK_GameDracoinLedger_ReferenceId_NotBlank` CHECK (((`ReferenceId` is null) or (char_length(ltrim(rtrim(`ReferenceId`))) > 0)));
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameDracoinLedger') AND NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND table_name = 'GameDracoinLedger' AND constraint_name = 'CK_GameDracoinLedger_ReferenceType_NotBlank') THEN
        ALTER TABLE `GameDracoinLedger` ADD CONSTRAINT `CK_GameDracoinLedger_ReferenceType_NotBlank` CHECK ((char_length(ltrim(rtrim(`ReferenceType`))) > 0));
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameDragonCapacity') AND NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND table_name = 'GameDragonCapacity' AND constraint_name = 'CK_GameDragonCapacity_MaxCapacity') THEN
        ALTER TABLE `GameDragonCapacity` ADD CONSTRAINT `CK_GameDragonCapacity_MaxCapacity` CHECK ((`MaxCapacity` between 1 and 10));
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameDragonCapacity') AND NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND table_name = 'GameDragonCapacity' AND constraint_name = 'CK_GameDragonCapacity_PurchasedSlots') THEN
        ALTER TABLE `GameDragonCapacity` ADD CONSTRAINT `CK_GameDragonCapacity_PurchasedSlots` CHECK ((`PurchasedSlots` <= 9));
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameDragonCapacity') AND NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND table_name = 'GameDragonCapacity' AND constraint_name = 'CK_GameDragonCapacity_TotalWithinMaximum') THEN
        ALTER TABLE `GameDragonCapacity` ADD CONSTRAINT `CK_GameDragonCapacity_TotalWithinMaximum` CHECK (((cast(`PurchasedSlots` as unsigned) + 1) <= cast(`MaxCapacity` as unsigned)));
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameDragons') AND NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND table_name = 'GameDragons' AND constraint_name = 'CK_GameDragons_Experience') THEN
        ALTER TABLE `GameDragons` ADD CONSTRAINT `CK_GameDragons_Experience` CHECK ((`Experience` >= 0));
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameDragons') AND NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND table_name = 'GameDragons' AND constraint_name = 'CK_GameDragons_Happiness') THEN
        ALTER TABLE `GameDragons` ADD CONSTRAINT `CK_GameDragons_Happiness` CHECK (((`Happiness` >= 0) and (`Happiness` <= 100)));
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameDragons') AND NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND table_name = 'GameDragons' AND constraint_name = 'CK_GameDragons_Hunger') THEN
        ALTER TABLE `GameDragons` ADD CONSTRAINT `CK_GameDragons_Hunger` CHECK (((`Hunger` >= 0) and (`Hunger` <= 100)));
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameDragons') AND NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND table_name = 'GameDragons' AND constraint_name = 'CK_GameDragons_Level') THEN
        ALTER TABLE `GameDragons` ADD CONSTRAINT `CK_GameDragons_Level` CHECK ((`Level` >= 1));
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameDragons') AND NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND table_name = 'GameDragons' AND constraint_name = 'CK_GameDragons_Life') THEN
        ALTER TABLE `GameDragons` ADD CONSTRAINT `CK_GameDragons_Life` CHECK (((`Life` >= 0) and (`Life` <= 100)));
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameDragons') AND NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND table_name = 'GameDragons' AND constraint_name = 'CK_GameDragons_Name_NotBlank') THEN
        ALTER TABLE `GameDragons` ADD CONSTRAINT `CK_GameDragons_Name_NotBlank` CHECK ((char_length(ltrim(rtrim(`Name`))) > 0));
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameDragons') AND NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND table_name = 'GameDragons' AND constraint_name = 'CK_GameDragons_Rarity') THEN
        ALTER TABLE `GameDragons` ADD CONSTRAINT `CK_GameDragons_Rarity` CHECK ((`Rarity` in (_utf8mb4'COMMON',_utf8mb4'RARE',_utf8mb4'EPIC',_utf8mb4'LEGENDARY',_utf8mb4'MYTHIC')));
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameDragons') AND NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND table_name = 'GameDragons' AND constraint_name = 'CK_GameDragons_Stage') THEN
        ALTER TABLE `GameDragons` ADD CONSTRAINT `CK_GameDragons_Stage` CHECK ((`Stage` in (_utf8mb4'BABY',_utf8mb4'YOUNG',_utf8mb4'ADULT')));
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameDragons') AND NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND table_name = 'GameDragons' AND constraint_name = 'CK_GameDragons_Status') THEN
        ALTER TABLE `GameDragons` ADD CONSTRAINT `CK_GameDragons_Status` CHECK ((`Status` in (_utf8mb4'ACTIVE',_utf8mb4'FLED')));
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameDragons') AND NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND table_name = 'GameDragons' AND constraint_name = 'CK_GameDragons_Temperament') THEN
        ALTER TABLE `GameDragons` ADD CONSTRAINT `CK_GameDragons_Temperament` CHECK ((`Temperament` in (_utf8mb4'NOBLE',_utf8mb4'AGRESIVO',_utf8mb4'JUGUETON',_utf8mb4'CURIOSO',_utf8mb4'PEREZOSO')));
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameEggDefinitions') AND NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND table_name = 'GameEggDefinitions' AND constraint_name = 'CK_GameEggDefinitions_Code_Valid') THEN
        ALTER TABLE `GameEggDefinitions` ADD CONSTRAINT `CK_GameEggDefinitions_Code_Valid` CHECK (((char_length(`Code`) > 0) and (`Code` = ltrim(rtrim(`Code`))) and (not(regexp_like(`Code`,_utf8mb4'[^A-Z0-9_]',_latin1'c')))));
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameEggDefinitions') AND NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND table_name = 'GameEggDefinitions' AND constraint_name = 'CK_GameEggDefinitions_DefaultRarity') THEN
        ALTER TABLE `GameEggDefinitions` ADD CONSTRAINT `CK_GameEggDefinitions_DefaultRarity` CHECK ((`DefaultRarity` in (_utf8mb4'COMMON',_utf8mb4'RARE',_utf8mb4'EPIC',_utf8mb4'LEGENDARY',_utf8mb4'MYTHIC')));
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameEggDefinitions') AND NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND table_name = 'GameEggDefinitions' AND constraint_name = 'CK_GameEggDefinitions_Description_NotBlank') THEN
        ALTER TABLE `GameEggDefinitions` ADD CONSTRAINT `CK_GameEggDefinitions_Description_NotBlank` CHECK ((char_length(ltrim(rtrim(`Description`))) > 0));
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameEggDefinitions') AND NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND table_name = 'GameEggDefinitions' AND constraint_name = 'CK_GameEggDefinitions_DisplayName_NotBlank') THEN
        ALTER TABLE `GameEggDefinitions` ADD CONSTRAINT `CK_GameEggDefinitions_DisplayName_NotBlank` CHECK ((char_length(ltrim(rtrim(`DisplayName`))) > 0));
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameEggDefinitions') AND NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND table_name = 'GameEggDefinitions' AND constraint_name = 'CK_GameEggDefinitions_IncubationMinutes') THEN
        ALTER TABLE `GameEggDefinitions` ADD CONSTRAINT `CK_GameEggDefinitions_IncubationMinutes` CHECK ((`IncubationMinutes` > 0));
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameEggDefinitions') AND NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND table_name = 'GameEggDefinitions' AND constraint_name = 'CK_GameEggDefinitions_PriceDracoins') THEN
        ALTER TABLE `GameEggDefinitions` ADD CONSTRAINT `CK_GameEggDefinitions_PriceDracoins` CHECK ((`PriceDracoins` >= 0));
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameEggDefinitions') AND NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND table_name = 'GameEggDefinitions' AND constraint_name = 'CK_GameEggDefinitions_PurchasablePrice') THEN
        ALTER TABLE `GameEggDefinitions` ADD CONSTRAINT `CK_GameEggDefinitions_PurchasablePrice` CHECK (((`Purchasable` = 0) or (`PriceDracoins` > 0)));
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameEggDefinitions') AND NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND table_name = 'GameEggDefinitions' AND constraint_name = 'CK_GameEggDefinitions_SortOrder') THEN
        ALTER TABLE `GameEggDefinitions` ADD CONSTRAINT `CK_GameEggDefinitions_SortOrder` CHECK ((`SortOrder` >= 0));
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameEggTransfers') AND NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND table_name = 'GameEggTransfers' AND constraint_name = 'CK_GameEggTransfers_Status') THEN
        ALTER TABLE `GameEggTransfers` ADD CONSTRAINT `CK_GameEggTransfers_Status` CHECK ((`Status` in (_utf8mb4'PENDING',_utf8mb4'ACCEPTED',_utf8mb4'REJECTED')));
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameEggTransfers') AND NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND table_name = 'GameEggTransfers' AND constraint_name = 'CK_GameEggTransfers_UpdatedAt') THEN
        ALTER TABLE `GameEggTransfers` ADD CONSTRAINT `CK_GameEggTransfers_UpdatedAt` CHECK ((`UpdatedAt` >= `CreatedAt`));
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameEggs') AND NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND table_name = 'GameEggs' AND constraint_name = 'CK_GameEggs_EggDefinitionCode_Valid') THEN
        ALTER TABLE `GameEggs` ADD CONSTRAINT `CK_GameEggs_EggDefinitionCode_Valid` CHECK (((`EggDefinitionCode` is null) or ((char_length(`EggDefinitionCode`) > 0) and (`EggDefinitionCode` = ltrim(rtrim(`EggDefinitionCode`))) and (not(regexp_like(`EggDefinitionCode`,_utf8mb4'[^A-Z0-9_]',_latin1'c'))))));
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameEggs') AND NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND table_name = 'GameEggs' AND constraint_name = 'CK_GameEggs_IncubationDates') THEN
        ALTER TABLE `GameEggs` ADD CONSTRAINT `CK_GameEggs_IncubationDates` CHECK (((`IncubationStartedAt` is null) or ((`IncubationStartedAt` >= `AcquiredAt`) and (`IncubationEndsAt` > `IncubationStartedAt`))));
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameEggs') AND NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND table_name = 'GameEggs' AND constraint_name = 'CK_GameEggs_IncubationPair') THEN
        ALTER TABLE `GameEggs` ADD CONSTRAINT `CK_GameEggs_IncubationPair` CHECK ((((`IncubationStartedAt` is null) and (`IncubationEndsAt` is null)) or ((`IncubationStartedAt` is not null) and (`IncubationEndsAt` is not null))));
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameEggs') AND NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND table_name = 'GameEggs' AND constraint_name = 'CK_GameEggs_Rarity') THEN
        ALTER TABLE `GameEggs` ADD CONSTRAINT `CK_GameEggs_Rarity` CHECK ((`Rarity` in (_utf8mb4'COMMON',_utf8mb4'RARE',_utf8mb4'EPIC',_utf8mb4'LEGENDARY',_utf8mb4'MYTHIC')));
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameEggs') AND NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND table_name = 'GameEggs' AND constraint_name = 'CK_GameEggs_Status') THEN
        ALTER TABLE `GameEggs` ADD CONSTRAINT `CK_GameEggs_Status` CHECK ((`Status` in (_utf8mb4'OWNED',_utf8mb4'INCUBATING',_utf8mb4'READY_TO_HATCH',_utf8mb4'HATCHED',_utf8mb4'IN_TRANSFER')));
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameEggs') AND NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND table_name = 'GameEggs' AND constraint_name = 'CK_GameEggs_StatusDates') THEN
        ALTER TABLE `GameEggs` ADD CONSTRAINT `CK_GameEggs_StatusDates` CHECK ((((`Status` in (_latin1'OWNED',_latin1'IN_TRANSFER')) and (`IncubationStartedAt` is null) and (`IncubationEndsAt` is null)) or ((`Status` in (_latin1'INCUBATING',_latin1'READY_TO_HATCH',_latin1'HATCHED')) and (`IncubationStartedAt` is not null) and (`IncubationEndsAt` is not null))));
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameEggs') AND NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND table_name = 'GameEggs' AND constraint_name = 'CK_GameEggs_UpdatedAfterAcquired') THEN
        ALTER TABLE `GameEggs` ADD CONSTRAINT `CK_GameEggs_UpdatedAfterAcquired` CHECK ((`UpdatedAt` >= `AcquiredAt`));
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameIdempotency') AND NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND table_name = 'GameIdempotency' AND constraint_name = 'CK_GameIdempotency_CompletedAfterCreation') THEN
        ALTER TABLE `GameIdempotency` ADD CONSTRAINT `CK_GameIdempotency_CompletedAfterCreation` CHECK (((`CompletedAt` is null) or (`CompletedAt` >= `CreatedAt`)));
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameIdempotency') AND NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND table_name = 'GameIdempotency' AND constraint_name = 'CK_GameIdempotency_CompletedState') THEN
        ALTER TABLE `GameIdempotency` ADD CONSTRAINT `CK_GameIdempotency_CompletedState` CHECK ((((`Status` = _utf8mb4'Pending') and (`CompletedAt` is null) and (`ResponseStatusCode` is null) and (`ResponseJson` is null)) or ((`Status` = _utf8mb4'Completed') and (`CompletedAt` is not null) and (`ResponseStatusCode` is not null) and (`ResponseJson` is not null))));
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameIdempotency') AND NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND table_name = 'GameIdempotency' AND constraint_name = 'CK_GameIdempotency_ExpiresAfterCreation') THEN
        ALTER TABLE `GameIdempotency` ADD CONSTRAINT `CK_GameIdempotency_ExpiresAfterCreation` CHECK (((`ExpiresAt` is null) or (`ExpiresAt` > `CreatedAt`)));
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameIdempotency') AND NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND table_name = 'GameIdempotency' AND constraint_name = 'CK_GameIdempotency_Key_NotBlank') THEN
        ALTER TABLE `GameIdempotency` ADD CONSTRAINT `CK_GameIdempotency_Key_NotBlank` CHECK ((char_length(ltrim(rtrim(`IdempotencyKey`))) > 0));
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameIdempotency') AND NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND table_name = 'GameIdempotency' AND constraint_name = 'CK_GameIdempotency_Operation_NotBlank') THEN
        ALTER TABLE `GameIdempotency` ADD CONSTRAINT `CK_GameIdempotency_Operation_NotBlank` CHECK ((char_length(ltrim(rtrim(`Operation`))) > 0));
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameIdempotency') AND NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND table_name = 'GameIdempotency' AND constraint_name = 'CK_GameIdempotency_ResponseJson') THEN
        ALTER TABLE `GameIdempotency` ADD CONSTRAINT `CK_GameIdempotency_ResponseJson` CHECK (((`ResponseJson` is null) or (json_valid(`ResponseJson`) = 1)));
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameIdempotency') AND NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND table_name = 'GameIdempotency' AND constraint_name = 'CK_GameIdempotency_ResponseStatusCode') THEN
        ALTER TABLE `GameIdempotency` ADD CONSTRAINT `CK_GameIdempotency_ResponseStatusCode` CHECK (((`ResponseStatusCode` is null) or (`ResponseStatusCode` between 100 and 599)));
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameIdempotency') AND NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND table_name = 'GameIdempotency' AND constraint_name = 'CK_GameIdempotency_Status') THEN
        ALTER TABLE `GameIdempotency` ADD CONSTRAINT `CK_GameIdempotency_Status` CHECK ((`Status` in (_utf8mb4'Pending',_utf8mb4'Completed')));
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameLinkCodes') AND NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND table_name = 'GameLinkCodes' AND constraint_name = 'CK_GameLinkCodes_ExpiresAfterCreation') THEN
        ALTER TABLE `GameLinkCodes` ADD CONSTRAINT `CK_GameLinkCodes_ExpiresAfterCreation` CHECK ((`ExpiresAt` > `CreatedAt`));
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameLinkCodes') AND NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND table_name = 'GameLinkCodes' AND constraint_name = 'CK_GameLinkCodes_NotUsedAndRevoked') THEN
        ALTER TABLE `GameLinkCodes` ADD CONSTRAINT `CK_GameLinkCodes_NotUsedAndRevoked` CHECK (((`UsedAt` is null) or (`RevokedAt` is null)));
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameLinkCodes') AND NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND table_name = 'GameLinkCodes' AND constraint_name = 'CK_GameLinkCodes_RevokedAfterCreation') THEN
        ALTER TABLE `GameLinkCodes` ADD CONSTRAINT `CK_GameLinkCodes_RevokedAfterCreation` CHECK (((`RevokedAt` is null) or (`RevokedAt` >= `CreatedAt`)));
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameLinkCodes') AND NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND table_name = 'GameLinkCodes' AND constraint_name = 'CK_GameLinkCodes_UsedAfterCreation') THEN
        ALTER TABLE `GameLinkCodes` ADD CONSTRAINT `CK_GameLinkCodes_UsedAfterCreation` CHECK (((`UsedAt` is null) or (`UsedAt` >= `CreatedAt`)));
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameLinkCodes') AND NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND table_name = 'GameLinkCodes' AND constraint_name = 'CK_GameLinkCodes_UsedBeforeExpiration') THEN
        ALTER TABLE `GameLinkCodes` ADD CONSTRAINT `CK_GameLinkCodes_UsedBeforeExpiration` CHECK (((`UsedAt` is null) or (`UsedAt` <= `ExpiresAt`)));
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameRobloxLinks') AND NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND table_name = 'GameRobloxLinks' AND constraint_name = 'CK_GameRobloxLinks_ActiveState') THEN
        ALTER TABLE `GameRobloxLinks` ADD CONSTRAINT `CK_GameRobloxLinks_ActiveState` CHECK ((((`Active` = 1) and (`UnlinkedAt` is null)) or ((`Active` = 0) and (`UnlinkedAt` is not null))));
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameRobloxLinks') AND NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND table_name = 'GameRobloxLinks' AND constraint_name = 'CK_GameRobloxLinks_RobloxUserId_Positive') THEN
        ALTER TABLE `GameRobloxLinks` ADD CONSTRAINT `CK_GameRobloxLinks_RobloxUserId_Positive` CHECK ((`RobloxUserId` > 0));
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'GameRobloxLinks') AND NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND table_name = 'GameRobloxLinks' AND constraint_name = 'CK_GameRobloxLinks_UnlinkedAfterLinked') THEN
        ALTER TABLE `GameRobloxLinks` ADD CONSTRAINT `CK_GameRobloxLinks_UnlinkedAfterLinked` CHECK (((`UnlinkedAt` is null) or (`UnlinkedAt` >= `LinkedAt`)));
    END IF;

END;
GO
CALL migrate_018_reconcile_existing_schema();
GO
DROP PROCEDURE migrate_018_reconcile_existing_schema;
GO
