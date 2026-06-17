IF COL_LENGTH(N'dbo.Alumnos', N'Emojis') IS NULL
BEGIN
    ALTER TABLE dbo.Alumnos
        ADD Emojis NVARCHAR(20) NULL;
END;
GO

DECLARE @AlumnoEmojis TABLE
(
    Codigo NVARCHAR(10) NOT NULL,
    Emojis NVARCHAR(20) NOT NULL
);

INSERT INTO @AlumnoEmojis (Codigo, Emojis)
VALUES
    (N'A1001', N'🐽'),
    (N'A1018', N'🐝'),
    (N'A1004', N'🐶'),
    (N'A1003', N'🐭'),
    (N'G1002', N'🎈'),
    (N'G1003', N'🤦🏻‍♀'),
    (N'G1004', N'🦒'),
    (N'G1009', N'😉'),
    (N'G1084', N'🪼'),
    (N'G1086', N'🦍'),
    (N'G1119', N'🍒'),
    (N'G1146', N'🐹'),
    (N'G1159', N'🤷🏻‍♀'),
    (N'G1174', N'😩'),
    (N'G1194', N'🌮'),
    (N'G1200', N'📿'),
    (N'G1241', N'✨'),
    (N'G1249', N'💅🏻'),
    (N'H1146', N'🌷'),
    (N'H1066', N'🐿️🦭'),
    (N'H1161', N'🏃🏻‍♀️'),
    (N'H1165', N'🦝'),
    (N'H1157', N'🦢'),
    (N'H1187', N'🌱'),
    (N'H1183', N'💧'),
    (N'H1144', N'🌸'),
    (N'H1143', N'❤️‍🔥'),
    (N'H1196', N'🦤💨'),
    (N'H1022', N'🐣'),
    (N'H1177', N'🧸🍧'),
    (N'H1171', N'🐁'),
    (N'H', N'🌺'),
    (N'H1148', N'🩻'),
    (N'R1063', N'💫'),
    (N'R1079', N'🐺'),
    (N'R1218', N'🐞'),
    (N'R1133', N'🍭'),
    (N'R1033', N'⭐'),
    (N'R1167', N'🧜🏾‍♂️'),
    (N'R1066', N'🦘'),
    (N'R1020', N'🪾'),
    (N'R1093', N'🎶'),
    (N'R1215', N'🍿'),
    (N'R1213', N'🪎'),
    (N'R1222', N'🛼'),
    (N'R1062', N'👨🏽‍🚀'),
    (N'R1197', N'🧉'),
    (N'R1198', N'🫰🏻'),
    (N'R1220', N'🍣'),
    (N'R1195', N'🫥'),
    (N'S1002', N'🕷'),
    (N'S1137', N'👑'),
    (N'S1180', N'🗺'),
    (N'S1243', N'💎'),
    (N'S1248', N'🌻'),
    (N'S1246', N'💪🏻'),
    (N'S1245', N'®️'),
    (N'S1221', N'🐨'),
    (N'S1107', N'☄️'),
    (N'S1181', N'🦄'),
    (N'S1108', N'🦦🔱'),
    (N'S1247', N'⚔️'),
    (N'S1189', N'🧣'),
    (N'S1027', N'🙈'),
    (N'S1012', N'🐈‍⬛'),
    (N'S1238', N'🧚🏻'),
    (N'S1193', N'🧜‍♀️'),
    (N'S1201', N'🐼'),
    (N'S1235', N'🧟‍♂️'),
    (N'S1140', N'🧸');

UPDATE A
SET A.Emojis = E.Emojis
FROM dbo.Alumnos A
INNER JOIN @AlumnoEmojis E ON E.Codigo = A.Codigo
WHERE NULLIF(LTRIM(RTRIM(A.Emojis)), N'') IS NULL;
GO
