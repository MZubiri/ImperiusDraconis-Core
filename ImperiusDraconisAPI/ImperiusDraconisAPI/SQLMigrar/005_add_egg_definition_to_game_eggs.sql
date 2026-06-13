/*
    Migracion: 005_add_egg_definition_to_game_eggs
    Proposito: Identificar el tipo o definicion de cada huevo sin crear catalogo.
    Fecha: 2026-06-09

    Compatibilidad:
    - Preserva registros existentes usando NULL para huevos legacy sin definicion.
    - No modifica la migracion 004 ni crea claves foraneas a catalogos futuros.
*/

SET NOCOUNT ON;
SET XACT_ABORT ON;
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID(N'dbo.GameEggs', N'U') IS NULL
    THROW 50021, 'No existe dbo.GameEggs. Ejecute primero la migracion 004.', 1;
GO

DECLARE @ColumnExists BIT =
    CASE WHEN COL_LENGTH(N'dbo.GameEggs', N'EggDefinitionCode') IS NULL THEN 0 ELSE 1 END;
DECLARE @ConstraintExists BIT =
    CASE WHEN OBJECT_ID(N'dbo.CK_GameEggs_EggDefinitionCode_Valid', N'C') IS NULL THEN 0 ELSE 1 END;

IF @ColumnExists = 1 AND @ConstraintExists = 1
BEGIN
    PRINT 'Migracion 005_add_egg_definition_to_game_eggs ya aplicada.';
    RETURN;
END;

IF @ColumnExists <> @ConstraintExists
    THROW 50022, 'Migracion 005 parcialmente aplicada. Revise GameEggs antes de continuar.', 1;

BEGIN TRY
    BEGIN TRANSACTION;

    /*
        Cada ALTER se compila por separado. Esto evita que SQL Server intente
        resolver EggDefinitionCode en el CHECK antes de crear la columna.
    */
    EXEC sys.sp_executesql N'
        ALTER TABLE dbo.GameEggs
            ADD EggDefinitionCode NVARCHAR(50) NULL;
    ';

    EXEC sys.sp_executesql N'
        ALTER TABLE dbo.GameEggs WITH CHECK
            ADD CONSTRAINT CK_GameEggs_EggDefinitionCode_Valid
            CHECK
            (
                EggDefinitionCode IS NULL
                OR
                (
                    LEN(EggDefinitionCode) > 0
                    AND EggDefinitionCode = LTRIM(RTRIM(EggDefinitionCode))
                    AND EggDefinitionCode COLLATE Latin1_General_100_BIN2
                        NOT LIKE N''%[^A-Z0-9_]%'' COLLATE Latin1_General_100_BIN2
                )
            );
    ';

    COMMIT TRANSACTION;
    PRINT 'Migracion 005_add_egg_definition_to_game_eggs aplicada correctamente.';
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;
GO
