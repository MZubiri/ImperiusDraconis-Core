/*
    Migracion: 009_add_selected_to_game_dragons
    Proposito: Agregar columnas de seleccion, estado y necesidades a dbo.GameDragons para el Dragon Acompañante.
    Fecha: 2026-06-10

    Requisitos:
    - SQL Server 2016 o superior.
    - La tabla dbo.GameDragons debe existir.
*/

SET NOCOUNT ON;
SET XACT_ABORT ON;
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID(N'dbo.GameDragons', N'U') IS NULL
    THROW 50050, 'No existe la tabla dbo.GameDragons. Ejecute primero las migraciones anteriores.', 1;
GO

-- Validar si la columna Selected ya existe para evitar errores si se ejecuta multiples veces
IF COL_LENGTH(N'dbo.GameDragons', N'Selected') IS NOT NULL
BEGIN
    PRINT 'Migracion 009_add_selected_to_game_dragons ya aplicada o columnas ya existen.';
    RETURN;
END;

BEGIN TRY
    BEGIN TRANSACTION;

    -- 1. Agregar columnas a GameDragons
    ALTER TABLE dbo.GameDragons ADD
        Selected BIT NOT NULL CONSTRAINT DF_GameDragons_Selected DEFAULT (0),
        Status NVARCHAR(20) NOT NULL CONSTRAINT DF_GameDragons_Status DEFAULT (N'ACTIVE'),
        Life INT NOT NULL CONSTRAINT DF_GameDragons_Life DEFAULT (100),
        Happiness INT NOT NULL CONSTRAINT DF_GameDragons_Happiness DEFAULT (100),
        Hunger INT NOT NULL CONSTRAINT DF_GameDragons_Hunger DEFAULT (100),
        Experience INT NOT NULL CONSTRAINT DF_GameDragons_Experience DEFAULT (0),
        LastNeedsUpdateAt DATETIME2(3) NOT NULL CONSTRAINT DF_GameDragons_LastNeedsUpdateAt DEFAULT SYSUTCDATETIME();

    -- 2. Agregar restricciones CHECK usando SQL Dinamico para evitar errores de compilacion de columnas nuevas
    EXEC sp_executesql N'
    ALTER TABLE dbo.GameDragons WITH CHECK ADD
        CONSTRAINT CK_GameDragons_Status CHECK (Status IN (N''ACTIVE'', N''FLED'')),
        CONSTRAINT CK_GameDragons_Life CHECK (Life >= 0 AND Life <= 100),
        CONSTRAINT CK_GameDragons_Happiness CHECK (Happiness >= 0 AND Happiness <= 100),
        CONSTRAINT CK_GameDragons_Hunger CHECK (Hunger >= 0 AND Hunger <= 100),
        CONSTRAINT CK_GameDragons_Experience CHECK (Experience >= 0);
    ';

    -- 3. Crear indice unico filtrado usando SQL Dinamico
    EXEC sp_executesql N'
    CREATE UNIQUE NONCLUSTERED INDEX UX_GameDragons_IdAlumno_Selected
    ON dbo.GameDragons (IdAlumno)
    WHERE Selected = 1;
    ';

    COMMIT TRANSACTION;
    PRINT 'Migracion 009_add_selected_to_game_dragons aplicada correctamente.';
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;
GO
