-- Token stores a SHA-256 hash; bearer refresh tokens are never persisted.
CREATE TABLE IF NOT EXISTS RefreshTokens (
    Id BIGINT AUTO_INCREMENT PRIMARY KEY,
    IdAlumno INT NOT NULL,
    Token CHAR(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
    ExpiresAt DATETIME(3) NOT NULL,
    CreatedAt DATETIME(3) NOT NULL DEFAULT (UTC_TIMESTAMP(3)),
    RevokedAt DATETIME(3) NULL,
    CONSTRAINT FK_RefreshTokens_Alumnos FOREIGN KEY (IdAlumno)
        REFERENCES Alumnos(IdAlumno) ON DELETE CASCADE,
    UNIQUE INDEX UX_RefreshTokens_Token (Token),
    INDEX IX_RefreshTokens_ExpiresAt (ExpiresAt)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
