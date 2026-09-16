-- MySQL 8.0.16+. GO separates connector batches; DDL commits implicitly.
DROP PROCEDURE IF EXISTS migrate_011_create_audit_intelligence_tables;
GO
CREATE PROCEDURE migrate_011_create_audit_intelligence_tables()
migration: BEGIN

IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'HistorialAccesos') THEN
    CREATE TABLE HistorialAccesos (
        Id INT AUTO_INCREMENT PRIMARY KEY,
        IdAlumno INT NOT NULL, FOREIGN KEY (IdAlumno) REFERENCES Alumnos(IdAlumno),
        DireccionIP VARCHAR(45) NOT NULL,
        UserAgent VARCHAR(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
        FingerprintHash VARCHAR(64) NOT NULL,
        TipoDispositivo VARCHAR(50) NOT NULL,
        PaisCodigo VARCHAR(10) NULL,
        Ciudad VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
        ProveedorInternet VARCHAR(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
        Exito TINYINT(1) NOT NULL,
        FechaAcceso DATETIME DEFAULT CURRENT_TIMESTAMP
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

END IF;
IF NOT EXISTS (SELECT 1 FROM information_schema.statistics WHERE table_schema = DATABASE() AND index_name = 'IX_HistorialAccesos_IP' AND table_name = 'HistorialAccesos') THEN
    CREATE INDEX IX_HistorialAccesos_IP ON HistorialAccesos(DireccionIP);

END IF;
IF NOT EXISTS (SELECT 1 FROM information_schema.statistics WHERE table_schema = DATABASE() AND index_name = 'IX_HistorialAccesos_Fingerprint' AND table_name = 'HistorialAccesos') THEN
    CREATE INDEX IX_HistorialAccesos_Fingerprint ON HistorialAccesos(FingerprintHash);

END IF;
IF NOT EXISTS (SELECT 1 FROM information_schema.statistics WHERE table_schema = DATABASE() AND index_name = 'IX_HistorialAccesos_Alumno_Fecha' AND table_name = 'HistorialAccesos') THEN
    CREATE INDEX IX_HistorialAccesos_Alumno_Fecha ON HistorialAccesos(IdAlumno, FechaAcceso DESC);

END IF;
IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'DispositivosAlumno') THEN
    CREATE TABLE DispositivosAlumno (
        IdAlumno INT NOT NULL, FOREIGN KEY (IdAlumno) REFERENCES Alumnos(IdAlumno),
        FingerprintHash VARCHAR(64) NOT NULL,
        UltimoUserAgent VARCHAR(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
        NombreDispositivoManual VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
        FechaPrimerAcceso DATETIME DEFAULT CURRENT_TIMESTAMP,
        FechaUltimoAcceso DATETIME DEFAULT CURRENT_TIMESTAMP,
        PRIMARY KEY (IdAlumno, FingerprintHash)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

END IF;
IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'CuentasEspeciales') THEN
    CREATE TABLE CuentasEspeciales (
        IdAlumno INT PRIMARY KEY, FOREIGN KEY (IdAlumno) REFERENCES Alumnos(IdAlumno),
        TipoCuenta VARCHAR(50) NOT NULL,
        Descripcion VARCHAR(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
        MultiplicadorAuditoria DECIMAL(3,2) NOT NULL DEFAULT 1.00,
        FechaRegistro DATETIME DEFAULT CURRENT_TIMESTAMP
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

END IF;
IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'ExcepcionesAuditoria') THEN
    CREATE TABLE ExcepcionesAuditoria (
        Id INT AUTO_INCREMENT PRIMARY KEY,
        TipoExcepcion VARCHAR(50) NOT NULL,
        ValorA VARCHAR(100) NOT NULL,
        ValorB VARCHAR(100) NULL,
        Motivo VARCHAR(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
        FechaCreado DATETIME DEFAULT CURRENT_TIMESTAMP,
        IdAdministrador INT NOT NULL,
        Activa TINYINT(1) NOT NULL DEFAULT 1
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

END IF;
IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'CuentasVinculadas') THEN
    CREATE TABLE CuentasVinculadas (
        Id INT AUTO_INCREMENT PRIMARY KEY,
        IdAlumnoA INT NOT NULL, FOREIGN KEY (IdAlumnoA) REFERENCES Alumnos(IdAlumno),
        IdAlumnoB INT NOT NULL, FOREIGN KEY (IdAlumnoB) REFERENCES Alumnos(IdAlumno),
        TipoEvidencia VARCHAR(30) NOT NULL,
        FuerzaVinculo INT NOT NULL DEFAULT 1,
        CreadoEn DATETIME DEFAULT CURRENT_TIMESTAMP,
        ActualizadoEn DATETIME DEFAULT CURRENT_TIMESTAMP,
        CONSTRAINT CK_CuentasVinculadas_NoAutoreferencial CHECK (IdAlumnoA < IdAlumnoB),
        CONSTRAINT UQ_CuentasVinculadas_Alumnos_Evidencia UNIQUE (IdAlumnoA, IdAlumnoB, TipoEvidencia)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

END IF;
IF NOT EXISTS (SELECT 1 FROM information_schema.statistics WHERE table_schema = DATABASE() AND index_name = 'IX_CuentasVinculadas_AlumnoA' AND table_name = 'CuentasVinculadas') THEN
    CREATE INDEX IX_CuentasVinculadas_AlumnoA ON CuentasVinculadas(IdAlumnoA);

END IF;
IF NOT EXISTS (SELECT 1 FROM information_schema.statistics WHERE table_schema = DATABASE() AND index_name = 'IX_CuentasVinculadas_AlumnoB' AND table_name = 'CuentasVinculadas') THEN
    CREATE INDEX IX_CuentasVinculadas_AlumnoB ON CuentasVinculadas(IdAlumnoB);

END IF;
IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'ResumenAuditoriaAccesos') THEN
    CREATE TABLE ResumenAuditoriaAccesos (
        IdAlumno INT PRIMARY KEY, FOREIGN KEY (IdAlumno) REFERENCES Alumnos(IdAlumno),
        RelevanciaAuditoria INT NOT NULL DEFAULT 0,
        MotivosDetalle LONGTEXT NOT NULL,
        EvidenciasJson LONGTEXT NOT NULL,
        UltimaEvaluacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

END IF;
IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'DecisionesAdministrativas') THEN
    CREATE TABLE DecisionesAdministrativas (
        Id INT AUTO_INCREMENT PRIMARY KEY,
        IdAlumno INT NOT NULL, FOREIGN KEY (IdAlumno) REFERENCES Alumnos(IdAlumno),
        IdAlumnoRelacionado INT NULL, FOREIGN KEY (IdAlumnoRelacionado) REFERENCES Alumnos(IdAlumno),
        Decision VARCHAR(50) NOT NULL,
        Motivo VARCHAR(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
        NotasInternas LONGTEXT NULL,
        IdAdministrador INT NOT NULL,
        FechaDecision DATETIME DEFAULT CURRENT_TIMESTAMP
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

END IF;
IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'AuditoriaEventos') THEN
    CREATE TABLE AuditoriaEventos (
        Id INT AUTO_INCREMENT PRIMARY KEY,
        TipoEvento VARCHAR(50) NOT NULL,
        OrigenEvento VARCHAR(50) NOT NULL,
        Severidad VARCHAR(20) NOT NULL,
        IdAlumno INT NOT NULL, FOREIGN KEY (IdAlumno) REFERENCES Alumnos(IdAlumno),
        IdAlumnoRelacionado INT NULL, FOREIGN KEY (IdAlumnoRelacionado) REFERENCES Alumnos(IdAlumno),
        ValorAnterior VARCHAR(100) NULL,
        ValorNuevo VARCHAR(100) NULL,
        DetallesJson LONGTEXT NULL,
        FechaEvento DATETIME DEFAULT CURRENT_TIMESTAMP
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

END IF;
IF NOT EXISTS (SELECT 1 FROM information_schema.statistics WHERE table_schema = DATABASE() AND index_name = 'IX_AuditoriaEventos_Alumno_Fecha' AND table_name = 'AuditoriaEventos') THEN
    CREATE INDEX IX_AuditoriaEventos_Alumno_Fecha ON AuditoriaEventos(IdAlumno, FechaEvento DESC);

END IF;
IF NOT EXISTS (SELECT 1 FROM information_schema.statistics WHERE table_schema = DATABASE() AND index_name = 'IX_AuditoriaEventos_Tipo' AND table_name = 'AuditoriaEventos') THEN
    CREATE INDEX IX_AuditoriaEventos_Tipo ON AuditoriaEventos(TipoEvento);

END IF;
IF NOT EXISTS (SELECT 1 FROM information_schema.statistics WHERE table_schema = DATABASE() AND index_name = 'IX_AuditoriaEventos_Severidad' AND table_name = 'AuditoriaEventos') THEN
    CREATE INDEX IX_AuditoriaEventos_Severidad ON AuditoriaEventos(Severidad);

END IF;
END;
GO
CALL migrate_011_create_audit_intelligence_tables();
GO
DROP PROCEDURE migrate_011_create_audit_intelligence_tables;
GO
