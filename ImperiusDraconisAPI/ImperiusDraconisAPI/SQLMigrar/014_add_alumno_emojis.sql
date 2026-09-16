-- MySQL 8.0.16+. GO separates connector batches; DDL commits implicitly.
DROP PROCEDURE IF EXISTS migrate_014_add_alumno_emojis;
GO
CREATE PROCEDURE migrate_014_add_alumno_emojis()
migration: BEGIN

IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'Alumnos' AND column_name = 'Emojis') THEN
    ALTER TABLE Alumnos
        ADD Emojis VARCHAR(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL;
END IF;
DROP TEMPORARY TABLE IF EXISTS tmp_AlumnoEmojis;
CREATE TEMPORARY TABLE tmp_AlumnoEmojis
(
    Codigo VARCHAR(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    Emojis VARCHAR(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO tmp_AlumnoEmojis (Codigo, Emojis)
VALUES
    ('A1001', '🐽'),
    ('A1018', '🐝'),
    ('A1004', '🐶'),
    ('A1003', '🐭'),
    ('G1002', '🎈'),
    ('G1003', '🤦🏻‍♀'),
    ('G1004', '🦒'),
    ('G1009', '😉'),
    ('G1084', '🪼'),
    ('G1086', '🦍'),
    ('G1119', '🍒'),
    ('G1146', '🐹'),
    ('G1159', '🤷🏻‍♀'),
    ('G1174', '😩'),
    ('G1194', '🌮'),
    ('G1200', '📿'),
    ('G1241', '✨'),
    ('G1249', '💅🏻'),
    ('H1146', '🌷'),
    ('H1066', '🐿️🦭'),
    ('H1161', '🏃🏻‍♀️'),
    ('H1165', '🦝'),
    ('H1157', '🦢'),
    ('H1187', '🌱'),
    ('H1183', '💧'),
    ('H1144', '🌸'),
    ('H1143', '❤️‍🔥'),
    ('H1196', '🦤💨'),
    ('H1022', '🐣'),
    ('H1177', '🧸🍧'),
    ('H1171', '🐁'),
    ('H', '🌺'),
    ('H1148', '🩻'),
    ('R1063', '💫'),
    ('R1079', '🐺'),
    ('R1218', '🐞'),
    ('R1133', '🍭'),
    ('R1033', '⭐'),
    ('R1167', '🧜🏾‍♂️'),
    ('R1066', '🦘'),
    ('R1020', '🪾'),
    ('R1093', '🎶'),
    ('R1215', '🍿'),
    ('R1213', '🪎'),
    ('R1222', '🛼'),
    ('R1062', '👨🏽‍🚀'),
    ('R1197', '🧉'),
    ('R1198', '🫰🏻'),
    ('R1220', '🍣'),
    ('R1195', '🫥'),
    ('S1002', '🕷'),
    ('S1137', '👑'),
    ('S1180', '🗺'),
    ('S1243', '💎'),
    ('S1248', '🌻'),
    ('S1246', '💪🏻'),
    ('S1245', '®️'),
    ('S1221', '🐨'),
    ('S1107', '☄️'),
    ('S1181', '🦄'),
    ('S1108', '🦦🔱'),
    ('S1247', '⚔️'),
    ('S1189', '🧣'),
    ('S1027', '🙈'),
    ('S1012', '🐈‍⬛'),
    ('S1238', '🧚🏻'),
    ('S1193', '🧜‍♀️'),
    ('S1201', '🐼'),
    ('S1235', '🧟‍♂️'),
    ('S1140', '🧸');

UPDATE Alumnos A
INNER JOIN tmp_AlumnoEmojis E ON E.Codigo = A.Codigo
SET A.Emojis = E.Emojis
WHERE NULLIF(LTRIM(RTRIM(A.Emojis)), '') IS NULL;
END;
GO
CALL migrate_014_add_alumno_emojis();
GO
DROP PROCEDURE migrate_014_add_alumno_emojis;
GO
