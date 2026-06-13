-- =========================================================================
-- MIGRACIÓN 011: Tablas de Inteligencia y Auditoría de Accesos
-- Objetivo: Almacenar accesos, dispositivos de alumnos y logs de auditoría
-- =========================================================================

-- 1. Tabla de Historial de Accesos
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HistorialAccesos]') AND type in (N'U'))
BEGIN
    CREATE TABLE dbo.HistorialAccesos (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        IdAlumno INT NOT NULL FOREIGN KEY REFERENCES dbo.Alumnos(IdAlumno),
        DireccionIP VARCHAR(45) NOT NULL,
        UserAgent NVARCHAR(500) NULL,
        FingerprintHash VARCHAR(64) NOT NULL,
        TipoDispositivo VARCHAR(50) NOT NULL,
        PaisCodigo VARCHAR(10) NULL,
        Ciudad NVARCHAR(100) NULL,
        ProveedorInternet NVARCHAR(150) NULL,
        Exito BIT NOT NULL,
        FechaAcceso DATETIME DEFAULT GETDATE()
    );
END;

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_HistorialAccesos_IP' AND object_id = OBJECT_ID(N'[dbo].[HistorialAccesos]'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_HistorialAccesos_IP ON dbo.HistorialAccesos(DireccionIP) INCLUDE (IdAlumno);
END;

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_HistorialAccesos_Fingerprint' AND object_id = OBJECT_ID(N'[dbo].[HistorialAccesos]'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_HistorialAccesos_Fingerprint ON dbo.HistorialAccesos(FingerprintHash) INCLUDE (IdAlumno);
END;

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_HistorialAccesos_Alumno_Fecha' AND object_id = OBJECT_ID(N'[dbo].[HistorialAccesos]'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_HistorialAccesos_Alumno_Fecha ON dbo.HistorialAccesos(IdAlumno, FechaAcceso DESC);
END;

-- 2. Historial de Dispositivos por Alumno
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DispositivosAlumno]') AND type in (N'U'))
BEGIN
    CREATE TABLE dbo.DispositivosAlumno (
        IdAlumno INT NOT NULL FOREIGN KEY REFERENCES dbo.Alumnos(IdAlumno),
        FingerprintHash VARCHAR(64) NOT NULL,
        UltimoUserAgent NVARCHAR(500) NULL,
        NombreDispositivoManual NVARCHAR(100) NULL,
        FechaPrimerAcceso DATETIME DEFAULT GETDATE(),
        FechaUltimoAcceso DATETIME DEFAULT GETDATE(),
        CONSTRAINT PK_DispositivosAlumno PRIMARY KEY (IdAlumno, FingerprintHash)
    );
END;

-- 3. Cuentas Especiales (Multiplicador de Relevancia)
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CuentasEspeciales]') AND type in (N'U'))
BEGIN
    CREATE TABLE dbo.CuentasEspeciales (
        IdAlumno INT PRIMARY KEY FOREIGN KEY REFERENCES dbo.Alumnos(IdAlumno),
        TipoCuenta VARCHAR(50) NOT NULL,              -- CASA, COMPARTIDA_AUTORIZADA, ASISTENTE, INSTITUCIONAL, ADMINISTRATIVA
        Descripcion NVARCHAR(250) NULL,
        MultiplicadorAuditoria DECIMAL(3,2) NOT NULL DEFAULT 1.00,
        FechaRegistro DATETIME DEFAULT GETDATE()
    );
END;

-- 4. Excepciones Permanentes
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ExcepcionesAuditoria]') AND type in (N'U'))
BEGIN
    CREATE TABLE dbo.ExcepcionesAuditoria (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        TipoExcepcion VARCHAR(50) NOT NULL,           -- RELACION_AUTORIZADA, IP_CONFIABLE, DISPOSITIVO_AUTORIZADO
        ValorA VARCHAR(100) NOT NULL,
        ValorB VARCHAR(100) NULL,
        Motivo NVARCHAR(500) NULL,
        FechaCreado DATETIME DEFAULT GETDATE(),
        IdAdministrador INT NOT NULL,
        Activa BIT NOT NULL DEFAULT 1
    );
END;

-- 5. Vinculaciones Implícitas
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CuentasVinculadas]') AND type in (N'U'))
BEGIN
    CREATE TABLE dbo.CuentasVinculadas (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        IdAlumnoA INT NOT NULL FOREIGN KEY REFERENCES dbo.Alumnos(IdAlumno),
        IdAlumnoB INT NOT NULL FOREIGN KEY REFERENCES dbo.Alumnos(IdAlumno),
        TipoEvidencia VARCHAR(30) NOT NULL,
        FuerzaVinculo INT NOT NULL DEFAULT 1,
        CreadoEn DATETIME DEFAULT GETDATE(),
        ActualizadoEn DATETIME DEFAULT GETDATE(),
        CONSTRAINT CK_CuentasVinculadas_NoAutoreferencial CHECK (IdAlumnoA < IdAlumnoB),
        CONSTRAINT UQ_CuentasVinculadas_Alumnos_Evidencia UNIQUE (IdAlumnoA, IdAlumnoB, TipoEvidencia)
    );
END;

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_CuentasVinculadas_AlumnoA' AND object_id = OBJECT_ID(N'[dbo].[CuentasVinculadas]'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_CuentasVinculadas_AlumnoA ON dbo.CuentasVinculadas(IdAlumnoA);
END;

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_CuentasVinculadas_AlumnoB' AND object_id = OBJECT_ID(N'[dbo].[CuentasVinculadas]'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_CuentasVinculadas_AlumnoB ON dbo.CuentasVinculadas(IdAlumnoB);
END;

-- 6. Resumen de Inteligencia y Auditoría
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ResumenAuditoriaAccesos]') AND type in (N'U'))
BEGIN
    CREATE TABLE dbo.ResumenAuditoriaAccesos (
        IdAlumno INT PRIMARY KEY FOREIGN KEY REFERENCES dbo.Alumnos(IdAlumno),
        RelevanciaAuditoria INT NOT NULL DEFAULT 0,
        MotivosDetalle NVARCHAR(MAX) NOT NULL,
        EvidenciasJson NVARCHAR(MAX) NOT NULL,
        UltimaEvaluacion DATETIME NOT NULL DEFAULT GETDATE()
    );
END;

-- 7. Historial de Decisiones Administrativas
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DecisionesAdministrativas]') AND type in (N'U'))
BEGIN
    CREATE TABLE dbo.DecisionesAdministrativas (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        IdAlumno INT NOT NULL FOREIGN KEY REFERENCES dbo.Alumnos(IdAlumno),
        IdAlumnoRelacionado INT NULL FOREIGN KEY REFERENCES dbo.Alumnos(IdAlumno),
        Decision VARCHAR(50) NOT NULL,                -- EN_OBSERVACION, PERMITIDA_FAMILIAR, SOSPECHOSA_CONFIRMADA, ACCION_MANUAL
        Motivo NVARCHAR(500) NULL,
        NotasInternas NVARCHAR(MAX) NULL,
        IdAdministrador INT NOT NULL,
        FechaDecision DATETIME DEFAULT GETDATE()
    );
END;

-- 8. Historial Cronológico de Eventos de Auditoría
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AuditoriaEventos]') AND type in (N'U'))
BEGIN
    CREATE TABLE dbo.AuditoriaEventos (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        TipoEvento VARCHAR(50) NOT NULL,              -- DISPOSITIVO_NUEVO, VINCULO_NUEVO, CAMBIO_RELEVANCIA, EXCEPCION_CREADA, CUENTA_ESPECIAL_REGISTRADA
        OrigenEvento VARCHAR(50) NOT NULL,            -- SISTEMA, LOGIN, TRANSFERENCIA, AUDITORIA, ADMINISTRADOR, EXCEPCION, CUENTA_ESPECIAL
        Severidad VARCHAR(20) NOT NULL,               -- INFO, LOW, MEDIUM, HIGH, CRITICAL
        IdAlumno INT NOT NULL FOREIGN KEY REFERENCES dbo.Alumnos(IdAlumno),
        IdAlumnoRelacionado INT NULL FOREIGN KEY REFERENCES dbo.Alumnos(IdAlumno),
        ValorAnterior VARCHAR(100) NULL,
        ValorNuevo VARCHAR(100) NULL,
        DetallesJson NVARCHAR(MAX) NULL,
        FechaEvento DATETIME DEFAULT GETDATE()
    );
END;

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_AuditoriaEventos_Alumno_Fecha' AND object_id = OBJECT_ID(N'[dbo].[AuditoriaEventos]'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_AuditoriaEventos_Alumno_Fecha ON dbo.AuditoriaEventos(IdAlumno, FechaEvento DESC);
END;

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_AuditoriaEventos_Tipo' AND object_id = OBJECT_ID(N'[dbo].[AuditoriaEventos]'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_AuditoriaEventos_Tipo ON dbo.AuditoriaEventos(TipoEvento);
END;

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_AuditoriaEventos_Severidad' AND object_id = OBJECT_ID(N'[dbo].[AuditoriaEventos]'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_AuditoriaEventos_Severidad ON dbo.AuditoriaEventos(Severidad);
END;
