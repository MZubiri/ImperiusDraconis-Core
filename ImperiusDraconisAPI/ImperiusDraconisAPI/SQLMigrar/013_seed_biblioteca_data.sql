-- MySQL 8.0.16+. GO separates connector batches.
DROP PROCEDURE IF EXISTS migrate_013_seed_biblioteca_data;
GO
CREATE PROCEDURE migrate_013_seed_biblioteca_data()
migration: BEGIN
DECLARE v_0 INT;
DECLARE v_1 INT;
DECLARE v_2 INT;
DECLARE v_3 INT;
DECLARE v_4 INT;
DECLARE v_5 INT;
DECLARE v_6 INT;
DECLARE v_7 INT;
DECLARE v_8 INT;
DECLARE v_9 INT;
DECLARE v_10 INT;
DECLARE v_11 INT;
DECLARE v_12 INT;
DECLARE v_13 INT;
DECLARE v_14 INT;
DECLARE v_15 INT;
DECLARE v_16 INT;
DECLARE v_17 INT;
DECLARE v_18 INT;
DECLARE v_19 INT;
DECLARE v_20 INT;
DECLARE v_21 INT;
DECLARE v_22 INT;
DECLARE v_23 INT;
DECLARE v_24 INT;
DECLARE v_25 INT;
DECLARE v_26 INT;
DECLARE v_27 INT;
DECLARE v_28 INT;
DECLARE v_29 INT;
DECLARE v_30 INT;
DECLARE v_31 INT;
DECLARE v_32 INT;
DECLARE v_33 INT;
DECLARE v_34 INT;
DECLARE v_35 INT;
DECLARE v_36 INT;
DECLARE v_37 INT;
DECLARE v_38 INT;
DECLARE v_39 INT;
DECLARE v_40 INT;
DECLARE v_41 INT;
DECLARE v_42 INT;
DECLARE v_43 INT;
DECLARE v_44 INT;
DECLARE v_45 INT;
DECLARE v_46 INT;
DECLARE v_47 INT;
DECLARE v_48 INT;
DECLARE v_49 INT;
DECLARE v_50 INT;
DECLARE v_51 INT;
DECLARE v_52 INT;
DECLARE v_53 INT;
DECLARE v_54 INT;
DECLARE v_55 INT;
DECLARE v_56 INT;
DECLARE v_57 INT;
DECLARE v_58 INT;
DECLARE v_59 INT;
DECLARE v_60 INT;
DECLARE v_61 INT;
DECLARE v_62 INT;
DECLARE v_63 INT;
DECLARE v_64 INT;
DECLARE v_65 INT;
DECLARE v_66 INT;
DECLARE v_67 INT;
DECLARE v_68 INT;
DECLARE v_69 INT;
DECLARE v_70 INT;
DECLARE v_71 INT;
DECLARE v_72 INT;
DECLARE v_73 INT;
DECLARE v_74 INT;
DECLARE v_75 INT;
DECLARE v_76 INT;
DECLARE v_77 INT;
DECLARE v_78 INT;
DECLARE v_79 INT;
DECLARE v_80 INT;
DECLARE v_81 INT;
DECLARE v_82 INT;
DECLARE v_83 INT;
DECLARE v_84 INT;
DECLARE v_85 INT;
DECLARE v_86 INT;
DECLARE v_87 INT;
DECLARE v_88 INT;
DECLARE v_89 INT;
DECLARE v_90 INT;
DECLARE v_91 INT;
DECLARE v_92 INT;
DECLARE v_93 INT;
DECLARE v_94 INT;
DECLARE v_95 INT;
DECLARE v_96 INT;
DECLARE v_97 INT;
DECLARE v_98 INT;
DECLARE v_99 INT;
DECLARE v_100 INT;
DECLARE v_101 INT;
DECLARE v_102 INT;
DECLARE v_103 INT;
DECLARE v_104 INT;
DECLARE v_105 INT;
DECLARE v_106 INT;
DECLARE v_107 INT;
DECLARE v_108 INT;
DECLARE v_109 INT;
DECLARE v_110 INT;
DECLARE v_111 INT;
DECLARE v_112 INT;
DECLARE v_113 INT;
DECLARE v_114 INT;
DECLARE v_115 INT;
DECLARE v_116 INT;
DECLARE v_117 INT;
DECLARE v_118 INT;
DECLARE v_119 INT;
DECLARE v_120 INT;
DECLARE v_121 INT;
DECLARE v_122 INT;
DECLARE v_123 INT;
DECLARE v_124 INT;
DECLARE v_125 INT;
DECLARE v_126 INT;
DECLARE v_127 INT;
DECLARE v_128 INT;
DECLARE v_129 INT;
DECLARE v_130 INT;
DECLARE v_131 INT;
DECLARE v_132 INT;
DECLARE v_133 INT;
DECLARE v_134 INT;
DECLARE v_135 INT;
DECLARE v_136 INT;
DECLARE v_137 INT;
DECLARE v_138 INT;
DECLARE v_139 INT;
DECLARE v_140 INT;
DECLARE v_141 INT;
DECLARE v_142 INT;
DECLARE v_143 INT;
DECLARE v_144 INT;
DECLARE v_145 INT;
DECLARE v_146 INT;
DECLARE v_147 INT;
DECLARE v_148 INT;
DECLARE v_149 INT;
DECLARE v_150 INT;
DECLARE v_151 INT;
DECLARE v_152 INT;
DECLARE v_153 INT;
DECLARE v_154 INT;
DECLARE v_155 INT;
DECLARE v_156 INT;
DECLARE v_157 INT;
DECLARE v_158 INT;
DECLARE v_159 INT;
DECLARE v_160 INT;
DECLARE v_161 INT;
DECLARE v_162 INT;
DECLARE v_163 INT;
DECLARE v_164 INT;
DECLARE v_165 INT;
DECLARE v_166 INT;
DECLARE v_167 INT;
DECLARE v_168 INT;
DECLARE v_169 INT;
DECLARE v_170 INT;
DECLARE v_171 INT;
DECLARE v_172 INT;
DECLARE v_173 INT;
DECLARE v_174 INT;
DECLARE v_175 INT;
DECLARE v_176 INT;
DECLARE v_177 INT;
DECLARE v_178 INT;
DECLARE v_179 INT;
DECLARE v_180 INT;
DECLARE v_181 INT;
DECLARE v_182 INT;
DECLARE v_183 INT;
DECLARE v_184 INT;
DECLARE v_185 INT;
DECLARE v_186 INT;
DECLARE v_187 INT;
DECLARE v_188 INT;
DECLARE v_189 INT;
DECLARE v_190 INT;
DECLARE v_191 INT;
DECLARE v_192 INT;
DECLARE v_193 INT;
DECLARE v_194 INT;
DECLARE v_195 INT;
DECLARE v_196 INT;
DECLARE v_197 INT;
DECLARE v_198 INT;
DECLARE v_199 INT;
DECLARE v_200 INT;
DECLARE v_201 INT;
DECLARE v_202 INT;
DECLARE v_203 INT;
DECLARE v_204 INT;
DECLARE v_205 INT;
DECLARE v_206 INT;
DECLARE v_207 INT;
DECLARE v_208 INT;
DECLARE v_209 INT;
DECLARE v_210 INT;
DECLARE v_211 INT;
DECLARE v_212 INT;
DECLARE v_213 INT;
DECLARE v_214 INT;
DECLARE v_215 INT;
DECLARE v_216 INT;
DECLARE v_217 INT;
DECLARE v_218 INT;
DECLARE v_219 INT;
DECLARE v_220 INT;
DECLARE v_221 INT;
DECLARE v_222 INT;
DECLARE v_223 INT;
DECLARE v_224 INT;
DECLARE v_225 INT;
DECLARE v_226 INT;
DECLARE v_227 INT;
DECLARE v_228 INT;
DECLARE v_229 INT;
DECLARE v_230 INT;
DECLARE v_231 INT;
DECLARE v_232 INT;
DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;











































































































































































































































IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Autoayuda / espiritualidad') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Autoayuda / espiritualidad', 'Categoría Autoayuda / espiritualidad', 1);
END IF;
SELECT Id INTO v_0 FROM BibliotecaCategorias WHERE Nombre = 'Autoayuda / espiritualidad';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Académico / educación') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Académico / educación', 'Categoría Académico / educación', 1);
END IF;
SELECT Id INTO v_1 FROM BibliotecaCategorias WHERE Nombre = 'Académico / educación';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Guías pedagógica y de evaluación') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Guías pedagógica y de evaluación', 'Categoría Guías pedagógica y de evaluación', 1);
END IF;
SELECT Id INTO v_2 FROM BibliotecaCategorias WHERE Nombre = 'Guías pedagógica y de evaluación';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Novela erótica / romance') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Novela erótica / romance', 'Categoría Novela erótica / romance', 1);
END IF;
SELECT Id INTO v_3 FROM BibliotecaCategorias WHERE Nombre = 'Novela erótica / romance';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Emprendimiento') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Emprendimiento', 'Categoría Emprendimiento', 1);
END IF;
SELECT Id INTO v_4 FROM BibliotecaCategorias WHERE Nombre = 'Emprendimiento';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Novela erótica') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Novela erótica', 'Categoría Novela erótica', 1);
END IF;
SELECT Id INTO v_5 FROM BibliotecaCategorias WHERE Nombre = 'Novela erótica';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Salud / Fisioterapia') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Salud / Fisioterapia', 'Categoría Salud / Fisioterapia', 1);
END IF;
SELECT Id INTO v_6 FROM BibliotecaCategorias WHERE Nombre = 'Salud / Fisioterapia';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Man-woman relationships') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Man-woman relationships', 'Categoría Man-woman relationships', 1);
END IF;
SELECT Id INTO v_7 FROM BibliotecaCategorias WHERE Nombre = 'Man-woman relationships';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Pop latino') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Pop latino', 'Categoría Pop latino', 1);
END IF;
SELECT Id INTO v_8 FROM BibliotecaCategorias WHERE Nombre = 'Pop latino';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Psicología / Comunicación no verbal') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Psicología / Comunicación no verbal', 'Categoría Psicología / Comunicación no verbal', 1);
END IF;
SELECT Id INTO v_9 FROM BibliotecaCategorias WHERE Nombre = 'Psicología / Comunicación no verbal';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Fantástico / juvenil') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Fantástico / juvenil', 'Categoría Fantástico / juvenil', 1);
END IF;
SELECT Id INTO v_10 FROM BibliotecaCategorias WHERE Nombre = 'Fantástico / juvenil';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Mathematics') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Mathematics', 'Categoría Mathematics', 1);
END IF;
SELECT Id INTO v_11 FROM BibliotecaCategorias WHERE Nombre = 'Mathematics';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Terror juvenil') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Terror juvenil', 'Categoría Terror juvenil', 1);
END IF;
SELECT Id INTO v_12 FROM BibliotecaCategorias WHERE Nombre = 'Terror juvenil';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Cine de ciencia ficción, cine de aventuras, cine de fantasía') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Cine de ciencia ficción, cine de aventuras, cine de fantasía', 'Categoría Cine de ciencia ficción, cine de aventuras, cine de fantasía', 1);
END IF;
SELECT Id INTO v_13 FROM BibliotecaCategorias WHERE Nombre = 'Cine de ciencia ficción, cine de aventuras, cine de fantasía';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Educación / Idiomas') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Educación / Idiomas', 'Categoría Educación / Idiomas', 1);
END IF;
SELECT Id INTO v_14 FROM BibliotecaCategorias WHERE Nombre = 'Educación / Idiomas';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Romance juvenil') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Romance juvenil', 'Categoría Romance juvenil', 1);
END IF;
SELECT Id INTO v_15 FROM BibliotecaCategorias WHERE Nombre = 'Romance juvenil';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Romance / suspense') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Romance / suspense', 'Categoría Romance / suspense', 1);
END IF;
SELECT Id INTO v_16 FROM BibliotecaCategorias WHERE Nombre = 'Romance / suspense';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Intriga, Otros') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Intriga, Otros', 'Categoría Intriga, Otros', 1);
END IF;
SELECT Id INTO v_17 FROM BibliotecaCategorias WHERE Nombre = 'Intriga, Otros';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Misterio / relato policial') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Misterio / relato policial', 'Categoría Misterio / relato policial', 1);
END IF;
SELECT Id INTO v_18 FROM BibliotecaCategorias WHERE Nombre = 'Misterio / relato policial';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Bienestar / autoayuda') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Bienestar / autoayuda', 'Categoría Bienestar / autoayuda', 1);
END IF;
SELECT Id INTO v_19 FROM BibliotecaCategorias WHERE Nombre = 'Bienestar / autoayuda';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Distopía / Ciencia ficción juvenil') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Distopía / Ciencia ficción juvenil', 'Categoría Distopía / Ciencia ficción juvenil', 1);
END IF;
SELECT Id INTO v_20 FROM BibliotecaCategorias WHERE Nombre = 'Distopía / Ciencia ficción juvenil';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Fantasía') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Fantasía', 'Categoría Fantasía', 1);
END IF;
SELECT Id INTO v_21 FROM BibliotecaCategorias WHERE Nombre = 'Fantasía';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Salud / medicina natural') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Salud / medicina natural', 'Categoría Salud / medicina natural', 1);
END IF;
SELECT Id INTO v_22 FROM BibliotecaCategorias WHERE Nombre = 'Salud / medicina natural';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Fantasía, narrativa') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Fantasía, narrativa', 'Categoría Fantasía, narrativa', 1);
END IF;
SELECT Id INTO v_23 FROM BibliotecaCategorias WHERE Nombre = 'Fantasía, narrativa';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Ciencia ficción, terror') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Ciencia ficción, terror', 'Categoría Ciencia ficción, terror', 1);
END IF;
SELECT Id INTO v_24 FROM BibliotecaCategorias WHERE Nombre = 'Ciencia ficción, terror';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Ensayo, Autoayuda') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Ensayo, Autoayuda', 'Categoría Ensayo, Autoayuda', 1);
END IF;
SELECT Id INTO v_25 FROM BibliotecaCategorias WHERE Nombre = 'Ensayo, Autoayuda';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Histórico') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Histórico', 'Categoría Histórico', 1);
END IF;
SELECT Id INTO v_26 FROM BibliotecaCategorias WHERE Nombre = 'Histórico';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Novela, Intriga') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Novela, Intriga', 'Categoría Novela, Intriga', 1);
END IF;
SELECT Id INTO v_27 FROM BibliotecaCategorias WHERE Nombre = 'Novela, Intriga';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Cine de ciencia ficción, cine de aventuras, cine de acción') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Cine de ciencia ficción, cine de aventuras, cine de acción', 'Categoría Cine de ciencia ficción, cine de aventuras, cine de acción', 1);
END IF;
SELECT Id INTO v_28 FROM BibliotecaCategorias WHERE Nombre = 'Cine de ciencia ficción, cine de aventuras, cine de acción';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Emprendimiento / motivación') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Emprendimiento / motivación', 'Categoría Emprendimiento / motivación', 1);
END IF;
SELECT Id INTO v_29 FROM BibliotecaCategorias WHERE Nombre = 'Emprendimiento / motivación';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Fantasía histórica') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Fantasía histórica', 'Categoría Fantasía histórica', 1);
END IF;
SELECT Id INTO v_30 FROM BibliotecaCategorias WHERE Nombre = 'Fantasía histórica';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Ficción distópica') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Ficción distópica', 'Categoría Ficción distópica', 1);
END IF;
SELECT Id INTO v_31 FROM BibliotecaCategorias WHERE Nombre = 'Ficción distópica';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Teosofía / espiritualidad') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Teosofía / espiritualidad', 'Categoría Teosofía / espiritualidad', 1);
END IF;
SELECT Id INTO v_32 FROM BibliotecaCategorias WHERE Nombre = 'Teosofía / espiritualidad';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Masonería / Ensayo') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Masonería / Ensayo', 'Categoría Masonería / Ensayo', 1);
END IF;
SELECT Id INTO v_33 FROM BibliotecaCategorias WHERE Nombre = 'Masonería / Ensayo';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Romántico, Novela') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Romántico, Novela', 'Categoría Romántico, Novela', 1);
END IF;
SELECT Id INTO v_34 FROM BibliotecaCategorias WHERE Nombre = 'Romántico, Novela';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Ficción moderna') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Ficción moderna', 'Categoría Ficción moderna', 1);
END IF;
SELECT Id INTO v_35 FROM BibliotecaCategorias WHERE Nombre = 'Ficción moderna';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Fantasía paranormal') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Fantasía paranormal', 'Categoría Fantasía paranormal', 1);
END IF;
SELECT Id INTO v_36 FROM BibliotecaCategorias WHERE Nombre = 'Fantasía paranormal';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Romántico') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Romántico', 'Categoría Romántico', 1);
END IF;
SELECT Id INTO v_37 FROM BibliotecaCategorias WHERE Nombre = 'Romántico';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Romance / erótico') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Romance / erótico', 'Categoría Romance / erótico', 1);
END IF;
SELECT Id INTO v_38 FROM BibliotecaCategorias WHERE Nombre = 'Romance / erótico';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Novela negra / thriller nórdico') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Novela negra / thriller nórdico', 'Categoría Novela negra / thriller nórdico', 1);
END IF;
SELECT Id INTO v_39 FROM BibliotecaCategorias WHERE Nombre = 'Novela negra / thriller nórdico';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Música house, música disco') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Música house, música disco', 'Categoría Música house, música disco', 1);
END IF;
SELECT Id INTO v_40 FROM BibliotecaCategorias WHERE Nombre = 'Música house, música disco';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Juvenil, Otros') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Juvenil, Otros', 'Categoría Juvenil, Otros', 1);
END IF;
SELECT Id INTO v_41 FROM BibliotecaCategorias WHERE Nombre = 'Juvenil, Otros';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'No especificado') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('No especificado', 'Categoría No especificado', 1);
END IF;
SELECT Id INTO v_42 FROM BibliotecaCategorias WHERE Nombre = 'No especificado';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'NO ABREN') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('NO ABREN', 'Categoría NO ABREN', 1);
END IF;
SELECT Id INTO v_43 FROM BibliotecaCategorias WHERE Nombre = 'NO ABREN';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Cine de terror, drama') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Cine de terror, drama', 'Categoría Cine de terror, drama', 1);
END IF;
SELECT Id INTO v_44 FROM BibliotecaCategorias WHERE Nombre = 'Cine de terror, drama';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Como dibujar ropa') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Como dibujar ropa', 'Categoría Como dibujar ropa', 1);
END IF;
SELECT Id INTO v_45 FROM BibliotecaCategorias WHERE Nombre = 'Como dibujar ropa';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Ensayo, Espiritualidad, Historia') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Ensayo, Espiritualidad, Historia', 'Categoría Ensayo, Espiritualidad, Historia', 1);
END IF;
SELECT Id INTO v_46 FROM BibliotecaCategorias WHERE Nombre = 'Ensayo, Espiritualidad, Historia';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Thriller policial') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Thriller policial', 'Categoría Thriller policial', 1);
END IF;
SELECT Id INTO v_47 FROM BibliotecaCategorias WHERE Nombre = 'Thriller policial';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Terror / ciencia ficción') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Terror / ciencia ficción', 'Categoría Terror / ciencia ficción', 1);
END IF;
SELECT Id INTO v_48 FROM BibliotecaCategorias WHERE Nombre = 'Terror / ciencia ficción';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Fiction, Romance, Historical, General, Regency') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Fiction, Romance, Historical, General, Regency', 'Categoría Fiction, Romance, Historical, General, Regency', 1);
END IF;
SELECT Id INTO v_49 FROM BibliotecaCategorias WHERE Nombre = 'Fiction, Romance, Historical, General, Regency';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Romántico / histórico') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Romántico / histórico', 'Categoría Romántico / histórico', 1);
END IF;
SELECT Id INTO v_50 FROM BibliotecaCategorias WHERE Nombre = 'Romántico / histórico';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Drama, Histórico') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Drama, Histórico', 'Categoría Drama, Histórico', 1);
END IF;
SELECT Id INTO v_51 FROM BibliotecaCategorias WHERE Nombre = 'Drama, Histórico';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Comedia romántica, melodrama, cine de comedia') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Comedia romántica, melodrama, cine de comedia', 'Categoría Comedia romántica, melodrama, cine de comedia', 1);
END IF;
SELECT Id INTO v_52 FROM BibliotecaCategorias WHERE Nombre = 'Comedia romántica, melodrama, cine de comedia';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Romance Histórica') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Romance Histórica', 'Categoría Romance Histórica', 1);
END IF;
SELECT Id INTO v_53 FROM BibliotecaCategorias WHERE Nombre = 'Romance Histórica';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Saga familiar / ficción histórica') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Saga familiar / ficción histórica', 'Categoría Saga familiar / ficción histórica', 1);
END IF;
SELECT Id INTO v_54 FROM BibliotecaCategorias WHERE Nombre = 'Saga familiar / ficción histórica';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Ensayo / ufología') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Ensayo / ufología', 'Categoría Ensayo / ufología', 1);
END IF;
SELECT Id INTO v_55 FROM BibliotecaCategorias WHERE Nombre = 'Ensayo / ufología';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Www.universidaddemillonarios.com') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Www.universidaddemillonarios.com', 'Categoría Www.universidaddemillonarios.com', 1);
END IF;
SELECT Id INTO v_56 FROM BibliotecaCategorias WHERE Nombre = 'Www.universidaddemillonarios.com';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Libro escaneado') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Libro escaneado', 'Categoría Libro escaneado', 1);
END IF;
SELECT Id INTO v_57 FROM BibliotecaCategorias WHERE Nombre = 'Libro escaneado';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Humor') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Humor', 'Categoría Humor', 1);
END IF;
SELECT Id INTO v_58 FROM BibliotecaCategorias WHERE Nombre = 'Humor';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Ciencia / Evolución humana') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Ciencia / Evolución humana', 'Categoría Ciencia / Evolución humana', 1);
END IF;
SELECT Id INTO v_59 FROM BibliotecaCategorias WHERE Nombre = 'Ciencia / Evolución humana';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Religion') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Religion', 'Categoría Religion', 1);
END IF;
SELECT Id INTO v_60 FROM BibliotecaCategorias WHERE Nombre = 'Religion';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Policial, detective') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Policial, detective', 'Categoría Policial, detective', 1);
END IF;
SELECT Id INTO v_61 FROM BibliotecaCategorias WHERE Nombre = 'Policial, detective';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Ficción para niños') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Ficción para niños', 'Categoría Ficción para niños', 1);
END IF;
SELECT Id INTO v_62 FROM BibliotecaCategorias WHERE Nombre = 'Ficción para niños';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Drama romántico, coming-of-age, cine adolescente') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Drama romántico, coming-of-age, cine adolescente', 'Categoría Drama romántico, coming-of-age, cine adolescente', 1);
END IF;
SELECT Id INTO v_63 FROM BibliotecaCategorias WHERE Nombre = 'Drama romántico, coming-of-age, cine adolescente';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Biografía / negocios') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Biografía / negocios', 'Categoría Biografía / negocios', 1);
END IF;
SELECT Id INTO v_64 FROM BibliotecaCategorias WHERE Nombre = 'Biografía / negocios';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Filosofía, ficción, ensayo') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Filosofía, ficción, ensayo', 'Categoría Filosofía, ficción, ensayo', 1);
END IF;
SELECT Id INTO v_65 FROM BibliotecaCategorias WHERE Nombre = 'Filosofía, ficción, ensayo';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Erótica') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Erótica', 'Categoría Erótica', 1);
END IF;
SELECT Id INTO v_66 FROM BibliotecaCategorias WHERE Nombre = 'Erótica';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Innovación / emprendimiento') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Innovación / emprendimiento', 'Categoría Innovación / emprendimiento', 1);
END IF;
SELECT Id INTO v_67 FROM BibliotecaCategorias WHERE Nombre = 'Innovación / emprendimiento';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Romance juvenil / fantasía paranormal') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Romance juvenil / fantasía paranormal', 'Categoría Romance juvenil / fantasía paranormal', 1);
END IF;
SELECT Id INTO v_68 FROM BibliotecaCategorias WHERE Nombre = 'Romance juvenil / fantasía paranormal';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Policiaca') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Policiaca', 'Categoría Policiaca', 1);
END IF;
SELECT Id INTO v_69 FROM BibliotecaCategorias WHERE Nombre = 'Policiaca';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Espiritualidad / Autoayuda') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Espiritualidad / Autoayuda', 'Categoría Espiritualidad / Autoayuda', 1);
END IF;
SELECT Id INTO v_70 FROM BibliotecaCategorias WHERE Nombre = 'Espiritualidad / Autoayuda';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Misterio') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Misterio', 'Categoría Misterio', 1);
END IF;
SELECT Id INTO v_71 FROM BibliotecaCategorias WHERE Nombre = 'Misterio';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Finanzas personales') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Finanzas personales', 'Categoría Finanzas personales', 1);
END IF;
SELECT Id INTO v_72 FROM BibliotecaCategorias WHERE Nombre = 'Finanzas personales';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Humor / ficción contemporánea') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Humor / ficción contemporánea', 'Categoría Humor / ficción contemporánea', 1);
END IF;
SELECT Id INTO v_73 FROM BibliotecaCategorias WHERE Nombre = 'Humor / ficción contemporánea';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Fantasía paranormal / romance juvenil') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Fantasía paranormal / romance juvenil', 'Categoría Fantasía paranormal / romance juvenil', 1);
END IF;
SELECT Id INTO v_74 FROM BibliotecaCategorias WHERE Nombre = 'Fantasía paranormal / romance juvenil';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Desarrollo personal / memoria') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Desarrollo personal / memoria', 'Categoría Desarrollo personal / memoria', 1);
END IF;
SELECT Id INTO v_75 FROM BibliotecaCategorias WHERE Nombre = 'Desarrollo personal / memoria';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Misticismo / Kábala') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Misticismo / Kábala', 'Categoría Misticismo / Kábala', 1);
END IF;
SELECT Id INTO v_76 FROM BibliotecaCategorias WHERE Nombre = 'Misticismo / Kábala';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Thriller psicológico / suspense') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Thriller psicológico / suspense', 'Categoría Thriller psicológico / suspense', 1);
END IF;
SELECT Id INTO v_77 FROM BibliotecaCategorias WHERE Nombre = 'Thriller psicológico / suspense';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Filosofía / Lógica') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Filosofía / Lógica', 'Categoría Filosofía / Lógica', 1);
END IF;
SELECT Id INTO v_78 FROM BibliotecaCategorias WHERE Nombre = 'Filosofía / Lógica';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Terror, ficción gótica') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Terror, ficción gótica', 'Categoría Terror, ficción gótica', 1);
END IF;
SELECT Id INTO v_79 FROM BibliotecaCategorias WHERE Nombre = 'Terror, ficción gótica';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Cine de ciencia ficción') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Cine de ciencia ficción', 'Categoría Cine de ciencia ficción', 1);
END IF;
SELECT Id INTO v_80 FROM BibliotecaCategorias WHERE Nombre = 'Cine de ciencia ficción';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Infantil / misterio') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Infantil / misterio', 'Categoría Infantil / misterio', 1);
END IF;
SELECT Id INTO v_81 FROM BibliotecaCategorias WHERE Nombre = 'Infantil / misterio';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Cine de comedia') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Cine de comedia', 'Categoría Cine de comedia', 1);
END IF;
SELECT Id INTO v_82 FROM BibliotecaCategorias WHERE Nombre = 'Cine de comedia';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Ficción contemporánea') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Ficción contemporánea', 'Categoría Ficción contemporánea', 1);
END IF;
SELECT Id INTO v_83 FROM BibliotecaCategorias WHERE Nombre = 'Ficción contemporánea';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Romance paranormal / ciencia ficción juvenil') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Romance paranormal / ciencia ficción juvenil', 'Categoría Romance paranormal / ciencia ficción juvenil', 1);
END IF;
SELECT Id INTO v_84 FROM BibliotecaCategorias WHERE Nombre = 'Romance paranormal / ciencia ficción juvenil';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Western / novela negra') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Western / novela negra', 'Categoría Western / novela negra', 1);
END IF;
SELECT Id INTO v_85 FROM BibliotecaCategorias WHERE Nombre = 'Western / novela negra';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Romántica') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Romántica', 'Categoría Romántica', 1);
END IF;
SELECT Id INTO v_86 FROM BibliotecaCategorias WHERE Nombre = 'Romántica';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Administración / negocios') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Administración / negocios', 'Categoría Administración / negocios', 1);
END IF;
SELECT Id INTO v_87 FROM BibliotecaCategorias WHERE Nombre = 'Administración / negocios';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Novela, Romántico, Histórico') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Novela, Romántico, Histórico', 'Categoría Novela, Romántico, Histórico', 1);
END IF;
SELECT Id INTO v_88 FROM BibliotecaCategorias WHERE Nombre = 'Novela, Romántico, Histórico';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Narrativa') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Narrativa', 'Categoría Narrativa', 1);
END IF;
SELECT Id INTO v_89 FROM BibliotecaCategorias WHERE Nombre = 'Narrativa';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Desarrollo personal / persuasión') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Desarrollo personal / persuasión', 'Categoría Desarrollo personal / persuasión', 1);
END IF;
SELECT Id INTO v_90 FROM BibliotecaCategorias WHERE Nombre = 'Desarrollo personal / persuasión';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Educación, Didáctica, Investigación') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Educación, Didáctica, Investigación', 'Categoría Educación, Didáctica, Investigación', 1);
END IF;
SELECT Id INTO v_91 FROM BibliotecaCategorias WHERE Nombre = 'Educación, Didáctica, Investigación';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Misterio / humor negro') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Misterio / humor negro', 'Categoría Misterio / humor negro', 1);
END IF;
SELECT Id INTO v_92 FROM BibliotecaCategorias WHERE Nombre = 'Misterio / humor negro';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Romance paranormal') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Romance paranormal', 'Categoría Romance paranormal', 1);
END IF;
SELECT Id INTO v_93 FROM BibliotecaCategorias WHERE Nombre = 'Romance paranormal';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Educación financiera') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Educación financiera', 'Categoría Educación financiera', 1);
END IF;
SELECT Id INTO v_94 FROM BibliotecaCategorias WHERE Nombre = 'Educación financiera';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Ficción, Histórica, General, Narrativa femenina, Romance, Contemporánea') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Ficción, Histórica, General, Narrativa femenina, Romance, Contemporánea', 'Categoría Ficción, Histórica, General, Narrativa femenina, Romance, Contemporánea', 1);
END IF;
SELECT Id INTO v_95 FROM BibliotecaCategorias WHERE Nombre = 'Ficción, Histórica, General, Narrativa femenina, Romance, Contemporánea';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Divulgación científica / neurociencia') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Divulgación científica / neurociencia', 'Categoría Divulgación científica / neurociencia', 1);
END IF;
SELECT Id INTO v_96 FROM BibliotecaCategorias WHERE Nombre = 'Divulgación científica / neurociencia';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Misterio juvenil') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Misterio juvenil', 'Categoría Misterio juvenil', 1);
END IF;
SELECT Id INTO v_97 FROM BibliotecaCategorias WHERE Nombre = 'Misterio juvenil';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Romance contemporáneo') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Romance contemporáneo', 'Categoría Romance contemporáneo', 1);
END IF;
SELECT Id INTO v_98 FROM BibliotecaCategorias WHERE Nombre = 'Romance contemporáneo';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Romance / mafia') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Romance / mafia', 'Categoría Romance / mafia', 1);
END IF;
SELECT Id INTO v_99 FROM BibliotecaCategorias WHERE Nombre = 'Romance / mafia';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Romance contemporáneo / drama') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Romance contemporáneo / drama', 'Categoría Romance contemporáneo / drama', 1);
END IF;
SELECT Id INTO v_100 FROM BibliotecaCategorias WHERE Nombre = 'Romance contemporáneo / drama';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Sexualidad') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Sexualidad', 'Categoría Sexualidad', 1);
END IF;
SELECT Id INTO v_101 FROM BibliotecaCategorias WHERE Nombre = 'Sexualidad';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Novela, Policial') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Novela, Policial', 'Categoría Novela, Policial', 1);
END IF;
SELECT Id INTO v_102 FROM BibliotecaCategorias WHERE Nombre = 'Novela, Policial';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Acción, Aventuras, Suspense') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Acción, Aventuras, Suspense', 'Categoría Acción, Aventuras, Suspense', 1);
END IF;
SELECT Id INTO v_103 FROM BibliotecaCategorias WHERE Nombre = 'Acción, Aventuras, Suspense';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Desarrollo personal / comunicación') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Desarrollo personal / comunicación', 'Categoría Desarrollo personal / comunicación', 1);
END IF;
SELECT Id INTO v_104 FROM BibliotecaCategorias WHERE Nombre = 'Desarrollo personal / comunicación';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'No ficción / tecnología y empleo') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('No ficción / tecnología y empleo', 'Categoría No ficción / tecnología y empleo', 1);
END IF;
SELECT Id INTO v_105 FROM BibliotecaCategorias WHERE Nombre = 'No ficción / tecnología y empleo';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Otros') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Otros', 'Categoría Otros', 1);
END IF;
SELECT Id INTO v_106 FROM BibliotecaCategorias WHERE Nombre = 'Otros';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Distopía / ciencia ficción juvenil') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Distopía / ciencia ficción juvenil', 'Categoría Distopía / ciencia ficción juvenil', 1);
END IF;
SELECT @Cat_Distopacienciaficcinjuvenil = Id FROM BibliotecaCategorias WHERE Nombre = 'Distopía / ciencia ficción juvenil';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Juvenil / romance') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Juvenil / romance', 'Categoría Juvenil / romance', 1);
END IF;
SELECT Id INTO v_107 FROM BibliotecaCategorias WHERE Nombre = 'Juvenil / romance';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Cocina / recetario') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Cocina / recetario', 'Categoría Cocina / recetario', 1);
END IF;
SELECT Id INTO v_108 FROM BibliotecaCategorias WHERE Nombre = 'Cocina / recetario';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Desarrollo personal / relaciones humanas') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Desarrollo personal / relaciones humanas', 'Categoría Desarrollo personal / relaciones humanas', 1);
END IF;
SELECT Id INTO v_109 FROM BibliotecaCategorias WHERE Nombre = 'Desarrollo personal / relaciones humanas';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Cine de terror, cine de supervivencia') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Cine de terror, cine de supervivencia', 'Categoría Cine de terror, cine de supervivencia', 1);
END IF;
SELECT Id INTO v_110 FROM BibliotecaCategorias WHERE Nombre = 'Cine de terror, cine de supervivencia';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Policíaco') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Policíaco', 'Categoría Policíaco', 1);
END IF;
SELECT Id INTO v_111 FROM BibliotecaCategorias WHERE Nombre = 'Policíaco';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Novela, Aventuras, Fantástico') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Novela, Aventuras, Fantástico', 'Categoría Novela, Aventuras, Fantástico', 1);
END IF;
SELECT Id INTO v_112 FROM BibliotecaCategorias WHERE Nombre = 'Novela, Aventuras, Fantástico';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Novela, Ciencia ficción') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Novela, Ciencia ficción', 'Categoría Novela, Ciencia ficción', 1);
END IF;
SELECT Id INTO v_113 FROM BibliotecaCategorias WHERE Nombre = 'Novela, Ciencia ficción';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Fantástico, Juvenil') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Fantástico, Juvenil', 'Categoría Fantástico, Juvenil', 1);
END IF;
SELECT @Cat_FantsticoJuvenil = Id FROM BibliotecaCategorias WHERE Nombre = 'Fantástico, Juvenil';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Ficción') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Ficción', 'Categoría Ficción', 1);
END IF;
SELECT Id INTO v_114 FROM BibliotecaCategorias WHERE Nombre = 'Ficción';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'enseñar a investigar; didáctica de la investigación; ciencias sociales y humanidades; generación de conocimiento; investigación social y humanística;') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('enseñar a investigar; didáctica de la investigación; ciencias sociales y humanidades; generación de conocimiento; investigación social y humanística;', 'Categoría enseñar a investigar; didáctica de la investigación; ciencias sociales y humanidades; generación de conocimiento; investigación social y humanística;', 1);
END IF;
SELECT Id INTO v_115 FROM BibliotecaCategorias WHERE Nombre = 'enseñar a investigar; didáctica de la investigación; ciencias sociales y humanidades; generación de conocimiento; investigación social y humanística;';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = '52° mult. matrimonio forzoso') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('52° mult. matrimonio forzoso', 'Categoría 52° mult. matrimonio forzoso', 1);
END IF;
SELECT Id INTO v_116 FROM BibliotecaCategorias WHERE Nombre = '52° mult. matrimonio forzoso';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Ciencia ficción / historia alternativa') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Ciencia ficción / historia alternativa', 'Categoría Ciencia ficción / historia alternativa', 1);
END IF;
SELECT Id INTO v_117 FROM BibliotecaCategorias WHERE Nombre = 'Ciencia ficción / historia alternativa';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Fantasía paranormal juvenil') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Fantasía paranormal juvenil', 'Categoría Fantasía paranormal juvenil', 1);
END IF;
SELECT Id INTO v_118 FROM BibliotecaCategorias WHERE Nombre = 'Fantasía paranormal juvenil';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Arte / dibujo y pintura') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Arte / dibujo y pintura', 'Categoría Arte / dibujo y pintura', 1);
END IF;
SELECT Id INTO v_119 FROM BibliotecaCategorias WHERE Nombre = 'Arte / dibujo y pintura';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Novela negra / policial') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Novela negra / policial', 'Categoría Novela negra / policial', 1);
END IF;
SELECT Id INTO v_120 FROM BibliotecaCategorias WHERE Nombre = 'Novela negra / policial';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Novela histórica') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Novela histórica', 'Categoría Novela histórica', 1);
END IF;
SELECT Id INTO v_121 FROM BibliotecaCategorias WHERE Nombre = 'Novela histórica';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Romance') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Romance', 'Categoría Romance', 1);
END IF;
SELECT Id INTO v_122 FROM BibliotecaCategorias WHERE Nombre = 'Romance';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Ventas / negocios') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Ventas / negocios', 'Categoría Ventas / negocios', 1);
END IF;
SELECT Id INTO v_123 FROM BibliotecaCategorias WHERE Nombre = 'Ventas / negocios';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Autobiografía') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Autobiografía', 'Categoría Autobiografía', 1);
END IF;
SELECT Id INTO v_124 FROM BibliotecaCategorias WHERE Nombre = 'Autobiografía';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Family & relationships') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Family & relationships', 'Categoría Family & relationships', 1);
END IF;
SELECT Id INTO v_125 FROM BibliotecaCategorias WHERE Nombre = 'Family & relationships';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Erótico / romance') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Erótico / romance', 'Categoría Erótico / romance', 1);
END IF;
SELECT Id INTO v_126 FROM BibliotecaCategorias WHERE Nombre = 'Erótico / romance';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Psicologia, Sociologia') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Psicologia, Sociologia', 'Categoría Psicologia, Sociologia', 1);
END IF;
SELECT Id INTO v_127 FROM BibliotecaCategorias WHERE Nombre = 'Psicologia, Sociologia';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Fantástico') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Fantástico', 'Categoría Fantástico', 1);
END IF;
SELECT Id INTO v_128 FROM BibliotecaCategorias WHERE Nombre = 'Fantástico';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Romance erótico') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Romance erótico', 'Categoría Romance erótico', 1);
END IF;
SELECT Id INTO v_38 FROM BibliotecaCategorias WHERE Nombre = 'Romance erótico';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Romance mafia') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Romance mafia', 'Categoría Romance mafia', 1);
END IF;
SELECT Id INTO v_99 FROM BibliotecaCategorias WHERE Nombre = 'Romance mafia';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Terror') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Terror', 'Categoría Terror', 1);
END IF;
SELECT Id INTO v_129 FROM BibliotecaCategorias WHERE Nombre = 'Terror';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Art') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Art', 'Categoría Art', 1);
END IF;
SELECT Id INTO v_130 FROM BibliotecaCategorias WHERE Nombre = 'Art';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Pop') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Pop', 'Categoría Pop', 1);
END IF;
SELECT Id INTO v_131 FROM BibliotecaCategorias WHERE Nombre = 'Pop';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Romance paranormal juvenil') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Romance paranormal juvenil', 'Categoría Romance paranormal juvenil', 1);
END IF;
SELECT Id INTO v_132 FROM BibliotecaCategorias WHERE Nombre = 'Romance paranormal juvenil';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Misterio / thriller juvenil') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Misterio / thriller juvenil', 'Categoría Misterio / thriller juvenil', 1);
END IF;
SELECT Id INTO v_133 FROM BibliotecaCategorias WHERE Nombre = 'Misterio / thriller juvenil';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Romance erótico / contemporáneo') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Romance erótico / contemporáneo', 'Categoría Romance erótico / contemporáneo', 1);
END IF;
SELECT Id INTO v_134 FROM BibliotecaCategorias WHERE Nombre = 'Romance erótico / contemporáneo';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Comedia fantástica, ficción de aventuras, cuento amoroso') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Comedia fantástica, ficción de aventuras, cuento amoroso', 'Categoría Comedia fantástica, ficción de aventuras, cuento amoroso', 1);
END IF;
SELECT Id INTO v_135 FROM BibliotecaCategorias WHERE Nombre = 'Comedia fantástica, ficción de aventuras, cuento amoroso';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Thriller / suspense') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Thriller / suspense', 'Categoría Thriller / suspense', 1);
END IF;
SELECT Id INTO v_136 FROM BibliotecaCategorias WHERE Nombre = 'Thriller / suspense';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Distopía juvenil') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Distopía juvenil', 'Categoría Distopía juvenil', 1);
END IF;
SELECT Id INTO v_137 FROM BibliotecaCategorias WHERE Nombre = 'Distopía juvenil';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Histórica, Suspense') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Histórica, Suspense', 'Categoría Histórica, Suspense', 1);
END IF;
SELECT Id INTO v_138 FROM BibliotecaCategorias WHERE Nombre = 'Histórica, Suspense';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Intriga, Policial') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Intriga, Policial', 'Categoría Intriga, Policial', 1);
END IF;
SELECT Id INTO v_139 FROM BibliotecaCategorias WHERE Nombre = 'Intriga, Policial';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Ficción de aventuras, ficción para jóvenes, fantasía') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Ficción de aventuras, ficción para jóvenes, fantasía', 'Categoría Ficción de aventuras, ficción para jóvenes, fantasía', 1);
END IF;
SELECT Id INTO v_140 FROM BibliotecaCategorias WHERE Nombre = 'Ficción de aventuras, ficción para jóvenes, fantasía';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Espiritualidad / Judaísmo') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Espiritualidad / Judaísmo', 'Categoría Espiritualidad / Judaísmo', 1);
END IF;
SELECT Id INTO v_141 FROM BibliotecaCategorias WHERE Nombre = 'Espiritualidad / Judaísmo';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Psychopaths') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Psychopaths', 'Categoría Psychopaths', 1);
END IF;
SELECT Id INTO v_142 FROM BibliotecaCategorias WHERE Nombre = 'Psychopaths';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Escena de género') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Escena de género', 'Categoría Escena de género', 1);
END IF;
SELECT Id INTO v_143 FROM BibliotecaCategorias WHERE Nombre = 'Escena de género';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Erótico') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Erótico', 'Categoría Erótico', 1);
END IF;
SELECT Id INTO v_144 FROM BibliotecaCategorias WHERE Nombre = 'Erótico';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Cocina / gastronomía') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Cocina / gastronomía', 'Categoría Cocina / gastronomía', 1);
END IF;
SELECT Id INTO v_145 FROM BibliotecaCategorias WHERE Nombre = 'Cocina / gastronomía';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Fantasía / romance paranormal') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Fantasía / romance paranormal', 'Categoría Fantasía / romance paranormal', 1);
END IF;
SELECT Id INTO v_146 FROM BibliotecaCategorias WHERE Nombre = 'Fantasía / romance paranormal';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Novela, Intriga, Policial') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Novela, Intriga, Policial', 'Categoría Novela, Intriga, Policial', 1);
END IF;
SELECT Id INTO v_147 FROM BibliotecaCategorias WHERE Nombre = 'Novela, Intriga, Policial';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Autoayuda / imagen personal') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Autoayuda / imagen personal', 'Categoría Autoayuda / imagen personal', 1);
END IF;
SELECT Id INTO v_148 FROM BibliotecaCategorias WHERE Nombre = 'Autoayuda / imagen personal';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Fantasía romántica / Juvenil') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Fantasía romántica / Juvenil', 'Categoría Fantasía romántica / Juvenil', 1);
END IF;
SELECT Id INTO v_149 FROM BibliotecaCategorias WHERE Nombre = 'Fantasía romántica / Juvenil';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Espiritualidad') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Espiritualidad', 'Categoría Espiritualidad', 1);
END IF;
SELECT Id INTO v_150 FROM BibliotecaCategorias WHERE Nombre = 'Espiritualidad';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Novela de desarrollo, ficción para niños') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Novela de desarrollo, ficción para niños', 'Categoría Novela de desarrollo, ficción para niños', 1);
END IF;
SELECT Id INTO v_151 FROM BibliotecaCategorias WHERE Nombre = 'Novela de desarrollo, ficción para niños';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Gastronomía / Panadería') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Gastronomía / Panadería', 'Categoría Gastronomía / Panadería', 1);
END IF;
SELECT Id INTO v_152 FROM BibliotecaCategorias WHERE Nombre = 'Gastronomía / Panadería';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'love_erotica') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('love_erotica', 'Categoría love_erotica', 1);
END IF;
SELECT Id INTO v_153 FROM BibliotecaCategorias WHERE Nombre = 'love_erotica';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Psicológico, Novela, Narrativa, Misterio, orígenes, Policíaco, familiar') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Psicológico, Novela, Narrativa, Misterio, orígenes, Policíaco, familiar', 'Categoría Psicológico, Novela, Narrativa, Misterio, orígenes, Policíaco, familiar', 1);
END IF;
SELECT Id INTO v_154 FROM BibliotecaCategorias WHERE Nombre = 'Psicológico, Novela, Narrativa, Misterio, orígenes, Policíaco, familiar';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Detective, Policial') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Detective, Policial', 'Categoría Detective, Policial', 1);
END IF;
SELECT Id INTO v_155 FROM BibliotecaCategorias WHERE Nombre = 'Detective, Policial';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Terror infantil / juvenil') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Terror infantil / juvenil', 'Categoría Terror infantil / juvenil', 1);
END IF;
SELECT Id INTO v_156 FROM BibliotecaCategorias WHERE Nombre = 'Terror infantil / juvenil';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Drill, afro trap, hip hop español') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Drill, afro trap, hip hop español', 'Categoría Drill, afro trap, hip hop español', 1);
END IF;
SELECT Id INTO v_157 FROM BibliotecaCategorias WHERE Nombre = 'Drill, afro trap, hip hop español';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Ciencia ficción / distopía juvenil') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Ciencia ficción / distopía juvenil', 'Categoría Ciencia ficción / distopía juvenil', 1);
END IF;
SELECT Id INTO v_158 FROM BibliotecaCategorias WHERE Nombre = 'Ciencia ficción / distopía juvenil';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Ficción romántica') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Ficción romántica', 'Categoría Ficción romántica', 1);
END IF;
SELECT Id INTO v_159 FROM BibliotecaCategorias WHERE Nombre = 'Ficción romántica';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Romance paranormal / fantasía') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Romance paranormal / fantasía', 'Categoría Romance paranormal / fantasía', 1);
END IF;
SELECT Id INTO v_160 FROM BibliotecaCategorias WHERE Nombre = 'Romance paranormal / fantasía';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Fotos para inspirarse.') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Fotos para inspirarse.', 'Categoría Fotos para inspirarse.', 1);
END IF;
SELECT Id INTO v_161 FROM BibliotecaCategorias WHERE Nombre = 'Fotos para inspirarse.';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Cine educativo') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Cine educativo', 'Categoría Cine educativo', 1);
END IF;
SELECT Id INTO v_162 FROM BibliotecaCategorias WHERE Nombre = 'Cine educativo';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Psicología / Persuasión') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Psicología / Persuasión', 'Categoría Psicología / Persuasión', 1);
END IF;
SELECT Id INTO v_163 FROM BibliotecaCategorias WHERE Nombre = 'Psicología / Persuasión';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Cine de misterio') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Cine de misterio', 'Categoría Cine de misterio', 1);
END IF;
SELECT Id INTO v_164 FROM BibliotecaCategorias WHERE Nombre = 'Cine de misterio';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Romance contemporáneo / erótico') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Romance contemporáneo / erótico', 'Categoría Romance contemporáneo / erótico', 1);
END IF;
SELECT Id INTO v_165 FROM BibliotecaCategorias WHERE Nombre = 'Romance contemporáneo / erótico';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Salud y bienestar') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Salud y bienestar', 'Categoría Salud y bienestar', 1);
END IF;
SELECT Id INTO v_166 FROM BibliotecaCategorias WHERE Nombre = 'Salud y bienestar';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Novela, Aventuras, Fantástico, Terror, Romántico') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Novela, Aventuras, Fantástico, Terror, Romántico', 'Categoría Novela, Aventuras, Fantástico, Terror, Romántico', 1);
END IF;
SELECT Id INTO v_167 FROM BibliotecaCategorias WHERE Nombre = 'Novela, Aventuras, Fantástico, Terror, Romántico';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Novela, Juvenil, Fantástico') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Novela, Juvenil, Fantástico', 'Categoría Novela, Juvenil, Fantástico', 1);
END IF;
SELECT Id INTO v_168 FROM BibliotecaCategorias WHERE Nombre = 'Novela, Juvenil, Fantástico';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Ensayo político') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Ensayo político', 'Categoría Ensayo político', 1);
END IF;
SELECT Id INTO v_169 FROM BibliotecaCategorias WHERE Nombre = 'Ensayo político';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Novela, Intriga, Juvenil') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Novela, Intriga, Juvenil', 'Categoría Novela, Intriga, Juvenil', 1);
END IF;
SELECT Id INTO v_170 FROM BibliotecaCategorias WHERE Nombre = 'Novela, Intriga, Juvenil';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Drawing hands style ;v') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Drawing hands style ;v', 'Categoría Drawing hands style ;v', 1);
END IF;
SELECT Id INTO v_171 FROM BibliotecaCategorias WHERE Nombre = 'Drawing hands style ;v';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Ficción para jóvenes') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Ficción para jóvenes', 'Categoría Ficción para jóvenes', 1);
END IF;
SELECT Id INTO v_172 FROM BibliotecaCategorias WHERE Nombre = 'Ficción para jóvenes';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Autoayuda') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Autoayuda', 'Categoría Autoayuda', 1);
END IF;
SELECT Id INTO v_173 FROM BibliotecaCategorias WHERE Nombre = 'Autoayuda';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Desarrollo personal / liderazgo') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Desarrollo personal / liderazgo', 'Categoría Desarrollo personal / liderazgo', 1);
END IF;
SELECT Id INTO v_174 FROM BibliotecaCategorias WHERE Nombre = 'Desarrollo personal / liderazgo';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Novela epistolar, ficción para niños') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Novela epistolar, ficción para niños', 'Categoría Novela epistolar, ficción para niños', 1);
END IF;
SELECT Id INTO v_175 FROM BibliotecaCategorias WHERE Nombre = 'Novela epistolar, ficción para niños';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Ciencia / Genética') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Ciencia / Genética', 'Categoría Ciencia / Genética', 1);
END IF;
SELECT Id INTO v_176 FROM BibliotecaCategorias WHERE Nombre = 'Ciencia / Genética';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Género policíaco') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Género policíaco', 'Categoría Género policíaco', 1);
END IF;
SELECT Id INTO v_177 FROM BibliotecaCategorias WHERE Nombre = 'Género policíaco';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Esoterismo / Filosofía oculta') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Esoterismo / Filosofía oculta', 'Categoría Esoterismo / Filosofía oculta', 1);
END IF;
SELECT Id INTO v_178 FROM BibliotecaCategorias WHERE Nombre = 'Esoterismo / Filosofía oculta';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Romance contemporáneo / juvenil') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Romance contemporáneo / juvenil', 'Categoría Romance contemporáneo / juvenil', 1);
END IF;
SELECT Id INTO v_179 FROM BibliotecaCategorias WHERE Nombre = 'Romance contemporáneo / juvenil';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Comedia romántica, cine musical') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Comedia romántica, cine musical', 'Categoría Comedia romántica, cine musical', 1);
END IF;
SELECT Id INTO v_180 FROM BibliotecaCategorias WHERE Nombre = 'Comedia romántica, cine musical';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Autoayuda / Salud') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Autoayuda / Salud', 'Categoría Autoayuda / Salud', 1);
END IF;
SELECT Id INTO v_181 FROM BibliotecaCategorias WHERE Nombre = 'Autoayuda / Salud';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Tratado') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Tratado', 'Categoría Tratado', 1);
END IF;
SELECT Id INTO v_182 FROM BibliotecaCategorias WHERE Nombre = 'Tratado';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Cyborgs') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Cyborgs', 'Categoría Cyborgs', 1);
END IF;
SELECT Id INTO v_183 FROM BibliotecaCategorias WHERE Nombre = 'Cyborgs';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Música country') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Música country', 'Categoría Música country', 1);
END IF;
SELECT Id INTO v_184 FROM BibliotecaCategorias WHERE Nombre = 'Música country';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Intriga / policial') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Intriga / policial', 'Categoría Intriga / policial', 1);
END IF;
SELECT @Cat_Intrigapolicial = Id FROM BibliotecaCategorias WHERE Nombre = 'Intriga / policial';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Ciencia ficción') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Ciencia ficción', 'Categoría Ciencia ficción', 1);
END IF;
SELECT Id INTO v_185 FROM BibliotecaCategorias WHERE Nombre = 'Ciencia ficción';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Fantasía urbana juvenil') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Fantasía urbana juvenil', 'Categoría Fantasía urbana juvenil', 1);
END IF;
SELECT Id INTO v_186 FROM BibliotecaCategorias WHERE Nombre = 'Fantasía urbana juvenil';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Fantástica') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Fantástica', 'Categoría Fantástica', 1);
END IF;
SELECT Id INTO v_187 FROM BibliotecaCategorias WHERE Nombre = 'Fantástica';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Romance oscuro / suspense') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Romance oscuro / suspense', 'Categoría Romance oscuro / suspense', 1);
END IF;
SELECT Id INTO v_188 FROM BibliotecaCategorias WHERE Nombre = 'Romance oscuro / suspense';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Fantasía / ciencia ficción juvenil') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Fantasía / ciencia ficción juvenil', 'Categoría Fantasía / ciencia ficción juvenil', 1);
END IF;
SELECT Id INTO v_189 FROM BibliotecaCategorias WHERE Nombre = 'Fantasía / ciencia ficción juvenil';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Psicología / Desarrollo personal') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Psicología / Desarrollo personal', 'Categoría Psicología / Desarrollo personal', 1);
END IF;
SELECT Id INTO v_190 FROM BibliotecaCategorias WHERE Nombre = 'Psicología / Desarrollo personal';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Oeste / novela pulp') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Oeste / novela pulp', 'Categoría Oeste / novela pulp', 1);
END IF;
SELECT Id INTO v_191 FROM BibliotecaCategorias WHERE Nombre = 'Oeste / novela pulp';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Romántico, Erótico') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Romántico, Erótico', 'Categoría Romántico, Erótico', 1);
END IF;
SELECT Id INTO v_192 FROM BibliotecaCategorias WHERE Nombre = 'Romántico, Erótico';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Romance oscuro') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Romance oscuro', 'Categoría Romance oscuro', 1);
END IF;
SELECT Id INTO v_193 FROM BibliotecaCategorias WHERE Nombre = 'Romance oscuro';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Autoayuda / reflexión') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Autoayuda / reflexión', 'Categoría Autoayuda / reflexión', 1);
END IF;
SELECT Id INTO v_194 FROM BibliotecaCategorias WHERE Nombre = 'Autoayuda / reflexión';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Manual') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Manual', 'Categoría Manual', 1);
END IF;
SELECT Id INTO v_195 FROM BibliotecaCategorias WHERE Nombre = 'Manual';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Gastronomía / Repostería') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Gastronomía / Repostería', 'Categoría Gastronomía / Repostería', 1);
END IF;
SELECT Id INTO v_196 FROM BibliotecaCategorias WHERE Nombre = 'Gastronomía / Repostería';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Mindfulness / meditación') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Mindfulness / meditación', 'Categoría Mindfulness / meditación', 1);
END IF;
SELECT Id INTO v_197 FROM BibliotecaCategorias WHERE Nombre = 'Mindfulness / meditación';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Erótico, Novela') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Erótico, Novela', 'Categoría Erótico, Novela', 1);
END IF;
SELECT Id INTO v_198 FROM BibliotecaCategorias WHERE Nombre = 'Erótico, Novela';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'narrativa') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('narrativa', 'Categoría narrativa', 1);
END IF;
SELECT @Cat_narrativa = Id FROM BibliotecaCategorias WHERE Nombre = 'narrativa';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Yoga / espiritualidad') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Yoga / espiritualidad', 'Categoría Yoga / espiritualidad', 1);
END IF;
SELECT Id INTO v_199 FROM BibliotecaCategorias WHERE Nombre = 'Yoga / espiritualidad';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Crianza / salud infantil') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Crianza / salud infantil', 'Categoría Crianza / salud infantil', 1);
END IF;
SELECT Id INTO v_200 FROM BibliotecaCategorias WHERE Nombre = 'Crianza / salud infantil';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Romance erótico / ciencia ficción') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Romance erótico / ciencia ficción', 'Categoría Romance erótico / ciencia ficción', 1);
END IF;
SELECT Id INTO v_201 FROM BibliotecaCategorias WHERE Nombre = 'Romance erótico / ciencia ficción';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Romance de ciencia ficción') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Romance de ciencia ficción', 'Categoría Romance de ciencia ficción', 1);
END IF;
SELECT Id INTO v_202 FROM BibliotecaCategorias WHERE Nombre = 'Romance de ciencia ficción';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Erótica / Romance') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Erótica / Romance', 'Categoría Erótica / Romance', 1);
END IF;
SELECT Id INTO v_203 FROM BibliotecaCategorias WHERE Nombre = 'Erótica / Romance';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Ensayo / Filosofía') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Ensayo / Filosofía', 'Categoría Ensayo / Filosofía', 1);
END IF;
SELECT Id INTO v_204 FROM BibliotecaCategorias WHERE Nombre = 'Ensayo / Filosofía';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Ensayo / antropología') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Ensayo / antropología', 'Categoría Ensayo / antropología', 1);
END IF;
SELECT Id INTO v_205 FROM BibliotecaCategorias WHERE Nombre = 'Ensayo / antropología';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Fantasía juvenil / aventura') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Fantasía juvenil / aventura', 'Categoría Fantasía juvenil / aventura', 1);
END IF;
SELECT Id INTO v_206 FROM BibliotecaCategorias WHERE Nombre = 'Fantasía juvenil / aventura';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Law') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Law', 'Categoría Law', 1);
END IF;
SELECT Id INTO v_207 FROM BibliotecaCategorias WHERE Nombre = 'Law';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Anti-folk') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Anti-folk', 'Categoría Anti-folk', 1);
END IF;
SELECT Id INTO v_208 FROM BibliotecaCategorias WHERE Nombre = 'Anti-folk';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Literatura de temática lgbt, novela de aprendizaje, ficción para jóvenes') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Literatura de temática lgbt, novela de aprendizaje, ficción para jóvenes', 'Categoría Literatura de temática lgbt, novela de aprendizaje, ficción para jóvenes', 1);
END IF;
SELECT Id INTO v_209 FROM BibliotecaCategorias WHERE Nombre = 'Literatura de temática lgbt, novela de aprendizaje, ficción para jóvenes';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Fiction') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Fiction', 'Categoría Fiction', 1);
END IF;
SELECT Id INTO v_210 FROM BibliotecaCategorias WHERE Nombre = 'Fiction';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Psicología / Diseño') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Psicología / Diseño', 'Categoría Psicología / Diseño', 1);
END IF;
SELECT Id INTO v_211 FROM BibliotecaCategorias WHERE Nombre = 'Psicología / Diseño';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Western / thriller') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Western / thriller', 'Categoría Western / thriller', 1);
END IF;
SELECT Id INTO v_212 FROM BibliotecaCategorias WHERE Nombre = 'Western / thriller';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Relatos, Romántica') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Relatos, Romántica', 'Categoría Relatos, Romántica', 1);
END IF;
SELECT Id INTO v_213 FROM BibliotecaCategorias WHERE Nombre = 'Relatos, Romántica';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Autoayuda / Éxito personal') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Autoayuda / Éxito personal', 'Categoría Autoayuda / Éxito personal', 1);
END IF;
SELECT Id INTO v_214 FROM BibliotecaCategorias WHERE Nombre = 'Autoayuda / Éxito personal';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Fantasía juvenil') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Fantasía juvenil', 'Categoría Fantasía juvenil', 1);
END IF;
SELECT Id INTO v_215 FROM BibliotecaCategorias WHERE Nombre = 'Fantasía juvenil';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Misterio histórico') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Misterio histórico', 'Categoría Misterio histórico', 1);
END IF;
SELECT Id INTO v_216 FROM BibliotecaCategorias WHERE Nombre = 'Misterio histórico';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Drama') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Drama', 'Categoría Drama', 1);
END IF;
SELECT Id INTO v_217 FROM BibliotecaCategorias WHERE Nombre = 'Drama';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Policial / misterio') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Policial / misterio', 'Categoría Policial / misterio', 1);
END IF;
SELECT Id INTO v_218 FROM BibliotecaCategorias WHERE Nombre = 'Policial / misterio';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'S2') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('S2', 'Categoría S2', 1);
END IF;
SELECT Id INTO v_219 FROM BibliotecaCategorias WHERE Nombre = 'S2';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Novela, Romántico') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Novela, Romántico', 'Categoría Novela, Romántico', 1);
END IF;
SELECT Id INTO v_220 FROM BibliotecaCategorias WHERE Nombre = 'Novela, Romántico';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Fantasía juvenil / romance') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Fantasía juvenil / romance', 'Categoría Fantasía juvenil / romance', 1);
END IF;
SELECT Id INTO v_221 FROM BibliotecaCategorias WHERE Nombre = 'Fantasía juvenil / romance';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Comics & graphic novels') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Comics & graphic novels', 'Categoría Comics & graphic novels', 1);
END IF;
SELECT Id INTO v_222 FROM BibliotecaCategorias WHERE Nombre = 'Comics & graphic novels';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Ficción psicológica, novela existencialista') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Ficción psicológica, novela existencialista', 'Categoría Ficción psicológica, novela existencialista', 1);
END IF;
SELECT Id INTO v_223 FROM BibliotecaCategorias WHERE Nombre = 'Ficción psicológica, novela existencialista';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Telenovela') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Telenovela', 'Categoría Telenovela', 1);
END IF;
SELECT Id INTO v_224 FROM BibliotecaCategorias WHERE Nombre = 'Telenovela';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Trip hop') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Trip hop', 'Categoría Trip hop', 1);
END IF;
SELECT Id INTO v_225 FROM BibliotecaCategorias WHERE Nombre = 'Trip hop';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Comedia romántica') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Comedia romántica', 'Categoría Comedia romántica', 1);
END IF;
SELECT Id INTO v_226 FROM BibliotecaCategorias WHERE Nombre = 'Comedia romántica';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Romance histórico / paranormal') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Romance histórico / paranormal', 'Categoría Romance histórico / paranormal', 1);
END IF;
SELECT Id INTO v_227 FROM BibliotecaCategorias WHERE Nombre = 'Romance histórico / paranormal';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Policial') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Policial', 'Categoría Policial', 1);
END IF;
SELECT Id INTO v_228 FROM BibliotecaCategorias WHERE Nombre = 'Policial';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Mónica lópez') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Mónica lópez', 'Categoría Mónica lópez', 1);
END IF;
SELECT Id INTO v_229 FROM BibliotecaCategorias WHERE Nombre = 'Mónica lópez';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Policial / detective') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Policial / detective', 'Categoría Policial / detective', 1);
END IF;
SELECT Id INTO v_61 FROM BibliotecaCategorias WHERE Nombre = 'Policial / detective';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Autoayuda / desarrollo personal') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Autoayuda / desarrollo personal', 'Categoría Autoayuda / desarrollo personal', 1);
END IF;
SELECT Id INTO v_230 FROM BibliotecaCategorias WHERE Nombre = 'Autoayuda / desarrollo personal';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Romance histórico') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Romance histórico', 'Categoría Romance histórico', 1);
END IF;
SELECT Id INTO v_231 FROM BibliotecaCategorias WHERE Nombre = 'Romance histórico';

IF NOT EXISTS (SELECT 1 FROM BibliotecaCategorias WHERE Nombre = 'Ebooket') THEN
    INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ('Ebooket', 'Categoría Ebooket', 1);
END IF;
SELECT Id INTO v_232 FROM BibliotecaCategorias WHERE Nombre = 'Ebooket';

START TRANSACTION;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'EJERCICIOS DE SANACION' AND Autor = 'USUARIO') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('EJERCICIOS DE SANACION', 'USUARIO', 'Esta información ha sido recopilada de diversas fuentes y algunos de mi autorìa con el propósito de proporcionarte algunas herramientas terapéuticas para tu sanación a todos los niveles a modo personal y de tu linaje. Recuerda Todos somos uno Si Sano yo, todo a mi alrededor sana.', v_42, '1_4992293569088717180.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El Tercer Ojo' AND Autor = 'Tuesday Lobsang Rampa') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El Tercer Ojo', 'Tuesday Lobsang Rampa', 'El tercer ojo es un libro publicado originalmente por Secker & Warburg en noviembre de 1956. Originalmente se afirmó que el libro había sido escrito por un monje tibetano llamado Lobsang Rampa. Investigaciones posteriores descubrieron  que el autor era en realidad un hombre británico llamado Cyril Henry Hoskin (1910-1981), hijo de un plomero, quién afirmaba que su cuerpo había sido ocupado por el espíritu de un monje tibetano llamado Tuesday Lobsang Rampa. El libro se considera una farsa o engaño.​​', v_124, '01- El Tercer Ojo.pdf.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Lulu' AND Autor = 'Mircea Cărtărescu') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Lulu', 'Mircea Cărtărescu', NULL, v_42, '1_5006073911528390848.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Una espina en mi costado' AND Autor = 'Karin Slaughter') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Una espina en mi costado', 'Karin Slaughter', NULL, v_42, '4_5823266120483735656.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El / la niñ@ interior' AND Autor = 'Shakti') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El / la niñ@ interior', 'Shakti', NULL, v_42, '1.3.El niño interior.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¿Qué es la filosofía?' AND Autor = 'Martin Heidegger') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¿Qué es la filosofía?', 'Martin Heidegger', '¿Qué es la filosofía? es el texto de una conferencia que Heidegger impartió en la ciudad normanda de Cerisy-la Salle en el año 1955. El texto gira en torno al papel que puede jugar la filosofía en una sociedad dominada por la tecnología y amenazada constantemente por el riesgo de una destrucción atómica del planeta. Por tanto, nos hallamos ante una conferencia que contiene los elementos esenciales del pensamiento maduro del autor: desde la implacable crítica a la técnica y el supuesto final de la filosofía, hasta la fragmentación de la identidad humana, el gradual debilitamiento de los valores del humanismo o las aportaciones de la poesía. En sintonía con Adorno, Horkheimer o Marcuse, Heidegger busca una alternativa a un tipo de dominación instrumental que, en forma de un enorme y complejo engranaje tecnológico, se ha impuesto en amplios sectores de la sociedad contemporánea. En este contexto se plantea la pregunta fundamental de la función de la filosofía. Por un lado, alertar sobre los riesgos de esta maquinación y, por otro, intentar restablecer los lazos perdidos con la naturaleza y la realidad inmediata. Sólo una actitud serena y meditativa, una actitud propia de la filosofía, permite a los individuos liberarse de la servidumbre técnica y pensar sobre la proximidad de las cosas de la vida cotidiana. He ahí el camino que traza Heidegger en esta conferencia para volver sobre esa misteriosa y ancestral correspondencia entre el ser y el hombre. La claridad del texto facilita un primer acceso a las ideas básicas del autor y reflexionar en torno a un problema que todavía goza de plena vigencia. De interés Filósofos y estudiantes de filosofía.', v_204, '_Qué es la filosofía_ - Martin Heidegger.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Memorias de una puta' AND Autor = 'Mari Cielo Pajares') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Memorias de una puta', 'Mari Cielo Pajares', NULL, v_42, '_Memorias_de_una_puta.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Lo que desea' AND Autor = 'Violet Haze') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Lo que desea', 'Violet Haze', NULL, v_180, '2.Trilogía Luna - Violet Haze🐬🥀🍀🍂🐬.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Domina tu voluntad (Palmyra) (Spanish Edition)' AND Autor = 'Cadarso, Victoria') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Domina tu voluntad (Palmyra) (Spanish Edition)', 'Cadarso, Victoria', NULL, v_42, '_domina-tu-voluntad-1-1.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '5026138577101127901' AND Autor = 'Desconocido') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('5026138577101127901', 'Desconocido', NULL, v_42, '1_5026138577101127901.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Más dulce que el café' AND Autor = 'Miki Russo') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Más dulce que el café', 'Miki Russo', 'Kari es una chica que está por cumplir treinta años. Tiene un trabajo un tanto particular, gusta de usar Converse, beber lattes de vainilla y salir con sus amigos. Lleva una vida común y corriente, hasta que tras un curioso incidente conoce a Roberto, un hombre mayor, demasiado elegante y correcto para ella. Kari y Roberto no tienen nada en común pero ¿Y qué importa eso? ¿Qué podría salir mal? Probablemente todo... El café por definición es amargo, pero si le pones suficiente azúcar puede quedar muy dulce ¿Existirá algo más dulce que el café? Kari descubrirá que el amor, al igual que el café, puede ser dulce y amargo a la vez. LA AUTORA: Miki Russo Miki Russo es el alias literario de Marisol Ortiz, nacida en octubre de 1991 en la ciudad de Santiago de Chile. Desde que aprendió a leer manifestó interés en los libros. Su sueño, a partir de entonces sería convertirse en escritora. A los catorce años comienza a escribir y de ahí en adelante ya no se detendría. Sus primeras publicaciones fueron fanfictions, los cuales tuvieron un buen recibimiento por parte de los lectores, lo que la animaría a aventurarse con sus historias originales. En el año 2011 ingresa a estudiar comunicación audiovisual, donde adquiere valiosos conocimientos que le ayudarían muchísimo con su pasión por la escritura. En 2015 obtiene su título profesional. En febrero de 2018 iniciaría la publicación en la plataforma Wattpad de "Más dulce que el café" su primera obra original en conseguir reconocimiento por parte de los lectores de la App, alcanzando en menos de seis meses 20 mil lecturas. Sin embargo, pronto la novela fue retirada de la web para poder llevarla a Amazon e incursionar en otros escenarios más amplios. Posteriormente a principios de 2019 su segunda historia titulada "Mala coincidencia" fue aceptada para ser publicada por una editorial independiente, pero lamentablemente por temas administrativos aquello debió ser cancelado. Actualmente Miki se encuentra a la espera de encontrar la manera de lanzar la segunda parte de "Más dulce que el café", además de estar sumamente concentrada en su nueva obra, donde continúa trabajando el género romántico. Todas las novedades sobre la autora y sus historias se pueden encontrar en su cuenta de Instagram @russo.miki', v_42, '1. Mas dulce que el cafe - Miki Russo.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Dungeon Vol. 14' AND Autor = 'Ilium L1120') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Dungeon Vol. 14', 'Ilium L1120', NULL, v_42, '[K-VT] Dungeon Vol. 14.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Homer For Christmas' AND Autor = 'usuario') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Homer For Christmas', 'usuario', NULL, v_42, '02. Homer For Christmas.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¿En qué creen los que no creen?' AND Autor = 'Varios autores') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¿En qué creen los que no creen?', 'Varios autores', NULL, v_42, '_En que creen los que no creen_ - Varios autores.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Mi error fue confiar en ti. Parte I (Spanish Edition)' AND Autor = 'Moruena Estríngana') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Mi error fue confiar en ti. Parte I (Spanish Edition)', 'Moruena Estríngana', NULL, v_42, '3.1.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Ahsoka' AND Autor = 'Emile Kate Johnston') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Ahsoka', 'Emile Kate Johnston', 'Ahsoka Tano es un personaje ficticio que aparece en la franquicia Star Wars. Presentada como la padawan jedi de Anakin Skywalker, es un personaje principal en la película animada de 2008 Star Wars: The Clone Wars y la serie de televisión posterior. Ahsoka reaparece en Star Wars Rebels, como cameo de voz en la película de acción en vivo de 2019 Star Wars: The Rise of Skywalker y como protagonista de la miniserie Tales of the Jedi. En estas producciones es interpretada por Ashley Eckstein.
Ahsoka es además la protagonista principal de la novela homónima que tiene a Eckstein narrando la versión de audiolibro. Ahsoka hizo su debut en imagen real en la segunda temporada de la serie de Disney+ The Mandalorian, interpretada por Rosario Dawson. Dawson repitió el papel en la serie derivada, The Book of Boba Fett y protagoniza su propia serie limitada, Ahsoka, en 2023.
Aunque inicialmente no gustó tanto a los fanáticos como a los críticos, Ahsoka se convirtió en un personaje más complejo y completo y finalmente llegó a ser uno de los personajes favoritos de los fanáticos. Sirviendo como contraste para Anakin Skywalker, ha sido destacada como un "personaje femenino fuerte" de la franquicia.', v_42, '3.4.Star Wars.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Desgarrada 05' AND Autor = 'Sky Corgan') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Desgarrada 05', 'Sky Corgan', NULL, v_42, '5 - Sky Corgan.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Julia Quinn El Duque y yo-- serie bridgerton' AND Autor = 'ALICIA') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Julia Quinn El Duque y yo-- serie bridgerton', 'ALICIA', NULL, v_42, '001 Julia Quinn El Duque y yo-- serie bridgerton.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '4 - Kyle' AND Autor = 'Emma Madden') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('4 - Kyle', 'Emma Madden', NULL, v_42, '4 - Kyle - Emma Madden.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Dungeon ni Deai wo Motomeru no wa Machigatteiru Darou ka' AND Autor = 'carlos') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Dungeon ni Deai wo Motomeru no wa Machigatteiru Darou ka', 'carlos', 'Dungeon ni Deai o Motomeru no wa Machigatteiru Darō ka (ダンジョンに出会いを求めるのは間違っているだろうか, lit. ¿Está mal querer tener un encuentro en una mazmorra??), también conocido como ¿Está mal seducir chicas en un calabozo? o  ¿Qué tiene de malo intentar ligar en una mazmorra? y varias veces abreviado como DanMachi (ダンまち, ''''DanMachi''''?), es una serie de novelas ligeras escritas por Fujino Ōmori e ilustradas por Suzuhito Yasuda. SB Creative ha publicado veintiuno volúmenes desde enero de 2013 bajo el sello de GA Bunko. Ha recibido una serie de spin-offs de la novela ligera y tres adaptaciones al manga. Una adaptación al anime, a cargo del estudio J.C.Staff, salió al aire desde el 4 de abril hasta el 27 de junio de 2015.
Ha sido la novela ligera más votada por los fanes en los premios Sugoi Japan Awards de la edición de 2016. En estos premios, los fanáticos deciden qué anime, manga, novela es la más indicada para ser comercializada en el mercado internacional.​', v_135, '[K-VT] Dungeon Vol. 11.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Double Breasted' AND Autor = 'Sotelo') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Double Breasted', 'Sotelo', NULL, v_42, '5. Double Breasted.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Invocacion' AND Autor = 'Chachii') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Invocacion', 'Chachii', 'Una invocación (del verbo latino invocare, "invocar", "llamar", "demandar") es una técnica de magia o religión que puede tomar las formas, siguientes, no mutuamente excluyentes:

Súplica, oración o hechizo.
Una forma de posesión espiritual.
Mandato o conjuro.
Autoidentificación con ciertos espíritus.
Documentos puestos bajo la protección divina.', v_42, '4 Invocacion.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Música de cañerías' AND Autor = 'Charles Bukowski') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Música de cañerías', 'Charles Bukowski', NULL, v_42, '♠️ Música De Cañerias. Charles Bukowski.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¿Dónde descansan las almas?' AND Autor = 'Enrique Laso') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¿Dónde descansan las almas?', 'Enrique Laso', NULL, v_42, '_Donde descansan las almas_ - Enrique Laso (3).pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '5062446538404397363' AND Autor = 'Bebel') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('5062446538404397363', 'Bebel', NULL, v_42, '1_5062446538404397363.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Mi error 2 - Mi error fue buscarte en otros brazos. Parte II (Spanish Edition)' AND Autor = 'Moruena Estríngana') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Mi error 2 - Mi error fue buscarte en otros brazos. Parte II (Spanish Edition)', 'Moruena Estríngana', NULL, v_42, '2.2. Mi error fue buscarte en otros brazos .pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Frenesí' AND Autor = 'Dylan Martins') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Frenesí', 'Dylan Martins', NULL, v_42, '3- Frenesí - Dylan Martins.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Sutton' AND Autor = 'MACARUBE') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Sutton', 'MACARUBE', NULL, v_42, '04. Sutton.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Persuasión (Placeres prohibidos nº 2) (Spanish Edition)' AND Autor = 'Adrian Blake') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Persuasión (Placeres prohibidos nº 2) (Spanish Edition)', 'Adrian Blake', NULL, v_42, '2. Persuación.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'La sangre de los elfos' AND Autor = 'Andrzej Sapkowski') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('La sangre de los elfos', 'Andrzej Sapkowski', 'La sangre de los elfos (en polaco:Krew elfów) es la primera novela en La saga del brujo escrita por Andrzej Sapkowski. Es una secuela a los cuentos cortos recolectados en los libros El último deseo y La espada del destino y le sigue Tiempo de odio (Czas pogardy).', v_21, '3.La sangre de los elfos - Andrzej Sapkowski.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Suya, cuerpo y alma' AND Autor = 'Olivia Dean') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Suya, cuerpo y alma', 'Olivia Dean', NULL, v_42, '3 - Suya, cuerpo y alma - Olivia Dean.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Dungeon ni Deai wo Motomeru no wa Machigatteiru Darou ka' AND Autor = 'carlos') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Dungeon ni Deai wo Motomeru no wa Machigatteiru Darou ka', 'carlos', 'Dungeon ni Deai o Motomeru no wa Machigatteiru Darō ka (ダンジョンに出会いを求めるのは間違っているだろうか, lit. ¿Está mal querer tener un encuentro en una mazmorra??), también conocido como ¿Está mal seducir chicas en un calabozo? o  ¿Qué tiene de malo intentar ligar en una mazmorra? y varias veces abreviado como DanMachi (ダンまち, ''''DanMachi''''?), es una serie de novelas ligeras escritas por Fujino Ōmori e ilustradas por Suzuhito Yasuda. SB Creative ha publicado veintiuno volúmenes desde enero de 2013 bajo el sello de GA Bunko. Ha recibido una serie de spin-offs de la novela ligera y tres adaptaciones al manga. Una adaptación al anime, a cargo del estudio J.C.Staff, salió al aire desde el 4 de abril hasta el 27 de junio de 2015.
Ha sido la novela ligera más votada por los fanes en los premios Sugoi Japan Awards de la edición de 2016. En estos premios, los fanáticos deciden qué anime, manga, novela es la más indicada para ser comercializada en el mercado internacional.​', v_135, '[K-VT] Dungeon Vol. 08.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¡Y tenía que ser mi jefe! 3' AND Autor = 'Norah Carter') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¡Y tenía que ser mi jefe! 3', 'Norah Carter', NULL, v_42, '3  ¡Y tenia que ser mi Jefe!.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'La durmiente' AND Autor = 'Edgar Allan Poe') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('La durmiente', 'Edgar Allan Poe', NULL, v_232, '1_5006304388063428860.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Domina tu voluntad (Palmyra) (Spanish Edition)' AND Autor = 'Cadarso, Victoria') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Domina tu voluntad (Palmyra) (Spanish Edition)', 'Cadarso, Victoria', NULL, v_42, '_domina-tu-voluntad.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'CONTRA TODO PRONOSTICO' AND Autor = 'LISA KLEYPAS') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('CONTRA TODO PRONOSTICO', 'LISA KLEYPAS', NULL, v_42, '3. Donde esta mi heroe.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El Arte del Terror - Volumen 4' AND Autor = 'Vários Autores') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El Arte del Terror - Volumen 4', 'Vários Autores', NULL, v_42, '_Arte_del_Terror_-_Volumen_4_-_VVAA.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '5066842918468190409' AND Autor = 'Desconocido') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('5066842918468190409', 'Desconocido', NULL, v_42, '1_5066842918468190409.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Navidad... ¡menudo desmadre!' AND Autor = 'Sarah Rusell') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Navidad... ¡menudo desmadre!', 'Sarah Rusell', NULL, v_42, '1 Navidad_. !menudo desmadre! - Sarah Rusell.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Dibujando Ojos 1' AND Autor = 'Desconocido') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Dibujando Ojos 1', 'Desconocido', 'En este tutorial, te mostraré cómo dibujar un ojo fotorrealista con lápices de grafito. Te mostraré cómo crear un boceto proporcional completamente desde cero, cómo resaltar y sombrear para darle profundidad a tu dibujo, y cómo dibujar la textura suave de la piel. Entonces, ¡dibujemos!', v_130, '▪︎Dibujando Ojos 1.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'PSICO-6 2-3.indd' AND Autor = 'Desconocido') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('PSICO-6 2-3.indd', 'Desconocido', NULL, v_42, '_psicooncología infantil y adolescente1.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '03' AND Autor = 'juan yañez nava') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('03', 'juan yañez nava', NULL, v_42, '0.03 - Dawn_s desire.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '5059811468594118968' AND Autor = 'Desconocido') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('5059811468594118968', 'Desconocido', NULL, v_42, '1_5059811468594118968.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'La noche de la momia' AND Autor = 'Curtis Garland') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('La noche de la momia', 'Curtis Garland', NULL, v_42, '✮Terror 29 - Garland, Curtis - La noche de la momia.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Los arcos del agua' AND Autor = 'Desconocido') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Los arcos del agua', 'Desconocido', NULL, v_42, '4_5816837692607957544.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'M N Forgy - Ley De La Omerta 1' AND Autor = 'Hermosa Criminal') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('M N Forgy - Ley De La Omerta 1', 'Hermosa Criminal', NULL, v_42, '1. Beautiful Criminal.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Juegos entre jefes' AND Autor = 'Victoria Quinn') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Juegos entre jefes', 'Victoria Quinn', NULL, v_98, '♋♋Juegos entre Jefes 07.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¡Deja de chingarte! (Spanish Edition)' AND Autor = 'Gary John Bishop') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¡Deja de chingarte! (Spanish Edition)', 'Gary John Bishop', NULL, v_42, '¡Deja de chingarte! Preocúpate menos, vive más.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Cronicas Vampiricas 02-Conflicto' AND Autor = 'Desconocido') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Cronicas Vampiricas 02-Conflicto', 'Desconocido', NULL, v_42, '2 Conflicto.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '4918483435120492805' AND Autor = 'José Manuel N P') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('4918483435120492805', 'José Manuel N P', NULL, v_42, '1_4918483435120492805.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Ana y la Casa de sus Sueños' AND Autor = 'Administrador') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Ana y la Casa de sus Sueños', 'Administrador', 'Anne y la casa de sus sueños es una novela de la escritora canadiense Lucy Maud Montgomery y fue publicada por primera vez en 1917.
El libro forma parte de una serie de novelas escritas por la autora sobre la vida de Anne Shirley, una huérfana que vive en la Isla del Príncipe Eduardo, donde la autora vivió su infancia y gran parte de su juventud.
Anne y la Casa de sus sueños es el quinto libro de la serie, y relata los comienzos de su nueva vida como esposa, del amor de su vida, Gilbert Blythe.', v_62, '5-Ana y la Casa de sus Sueños.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Una decisión dolorosa' AND Autor = 'Lola Barnon') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Una decisión dolorosa', 'Lola Barnon', 'Luis e Isabel son una pareja de muy buena posición social y dos hijos. Se casaron jóvenes, recién terminada la universidad, trabajaron y poco a poco fueron cayendo en la rutina y la monotonía. Una noche, Isabel en un arranque de sinceridad, le confiesa a su marido que quiere tener sexo con otros hombres. Y que, además, es una decisión que, a pesar de ser dolorosa, va a llevarla a cabo...Esa dolorosa decisión abrirá una tormenta de celos, rabia, lágrimas y venganza, muy complicada de asumir y superar.Pero un desagradable hecho, trastocará todo... Absolutamente todo.Mamen, la protagonista de "Nuevas Experiencias", "Nuevas sensaciones" y "Nuevas reglas", (Serie Juegos arriesgados), aparecerá en estas páginas... ¿Sabremos algo más de lo que pasó entre ella y Nico?', v_42, '1 Una decision dolorosa - Lola Barnon.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Reina' AND Autor = 'Fernández, Bebi') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Reina', 'Fernández, Bebi', 'Reina, el esperado desenlace de Memorias de una salvaje, es más que un thriller. Es un desafío a toda la sociedad. España, año 2020. La vida de Kassandra Fernández transcurre entre libros e intentos por superar su pasado, pero todo se tambalea cuando su mayor enemigo hace acto de presencia de la peor forma posible, dando lugar a una cruenta guerra fría donde la estrategia, los negocios criminales y los límites entre el bien y el mal se difuminan, y en la cual la protagonista se debatirá internamente entre la venganza y la justicia, librando también una batalla interna donde tendrá que averiguar quién es en realidad. Mientras todo ocurre, el amor y la amistad parecen ser más difíciles de comprender que nunca. Abrir el cajón donde guardaba las piezas de ajedrez no será fácil, pero Kassandra Fernández ya no es solo una joven valiente y necesitada de conocer su destino, sino una salvaje mujer dispuesta a ganar la partida —o quizás no. Reina, el esperado desenlace de Memorias de una salvaje, es más que un thriller. Es un desafío a toda la sociedad. Bebi Fernández, el despertar de una generación SALVAJE. Más de 200.000 lectores.', v_42, '_El hada Reina de los dientes de William Edward Joyce (1).pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Guia de Segmentacion Avanzada YouTube' AND Autor = 'Desconocido') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Guia de Segmentacion Avanzada YouTube', 'Desconocido', NULL, v_42, '__Guia+de+Segmentacion+Avanzada+YouTube(1).pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'EL DEVORADOR DE FANTASMAS' AND Autor = 'TOMY') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('EL DEVORADOR DE FANTASMAS', 'TOMY', NULL, v_42, '1_5024155560635794101.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Cyborg Seduction' AND Autor = 'Alumno') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Cyborg Seduction', 'Alumno', NULL, v_42, '3. Cyborg Seduction.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Por siempre solo tú (Spanish Edition)' AND Autor = 'Moruena Estríngana') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Por siempre solo tú (Spanish Edition)', 'Moruena Estríngana', NULL, v_42, '2.5.Por siempre solo tu-Morena Estringana.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¿Me guardas el secreto?' AND Autor = 'Larrú') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¿Me guardas el secreto?', 'Larrú', NULL, v_42, '_Me guardas el secreto_ - Larru.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Ríndete a los Cyborgs' AND Autor = 'Alumno') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Ríndete a los Cyborgs', 'Alumno', NULL, v_42, '1. Ríndete a los Cyborgs.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Enola Holmes-El caso delos extraños ramos flores' AND Autor = 'Desconocido') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Enola Holmes-El caso delos extraños ramos flores', 'Desconocido', 'Enola Holmes, la hermana menor de Sherlock Holmes, vuelve con otro apasionante misterio. Ante la sorpresa de todos, el célebre doctor Watson, mano derecha de Sherlock Holmes, ha desaparecido sin dejar rastro. Y ni siquiera el famoso detective es capaz de hallar una sola pista que pueda conducir a su paradero. El caso despierta la curiosidad de Enola y decide implicarse. Sabe que debe actuar, y rápido, si quiere hallar al doctor Watson a tiempo. ¿Lo conseguirá?', v_215, '3.Enola Holmes-El caso delos extraños ramos flores.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '3. Mia Para Siempre - Scott J. S.' AND Autor = 'Carmen') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('3. Mia Para Siempre - Scott J. S.', 'Carmen', NULL, v_42, '3.Mía Para Siempre 3 - J. S. Scott.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Como dibujar ropa' AND Autor = 'Desconocido') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Como dibujar ropa', 'Desconocido', NULL, v_45, '▪︎ Dibujar Ropa.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Enola Holmes-El caso de la dama zurda' AND Autor = 'Desconocido') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Enola Holmes-El caso de la dama zurda', 'Desconocido', '¡Vuelve Enola Holmes! En la ciudad más sucia, oscura y grande del mundo, alguien está buscando a Enola Holmes: el detective más famoso del mundo, su propio hermano, Sherlock Holmes. Pero si quiere luchar por la libertad, la suya y la de su madre, deberá escapar de él y seguir probando que su madre estaba en lo cierto cuando decidió llamarla Enola, leído al revés, alone (sola). En su huída, descubre unos dibujos al carboncillo ocultos y se pregunta si la chica que los creó será como ella; su alma gemela. Pero esa chica, Lady Cecily, ha desaparecido sin dejar rastro. Enola tendrá que adentrarse de noche por las calles de Londres para encontrarla y descifrar las claves que la conducirán a la dama zurda; pero en su intento por salvarla, se arriesga a revelar más cosas de las que debería. ¿Será capaz de mantener su identidad secreta y de encontrar a Lady Cecily, o perderá para siempre lo único que intenta salvar, su libertad?', v_215, '2. Enola Holmes-El caso de la dama zurda.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '4933803424551534904' AND Autor = 'Desconocido') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('4933803424551534904', 'Desconocido', NULL, v_42, '1_4933803424551534904.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Antes De Ser Tuya' AND Autor = 'Amaya Evans') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Antes De Ser Tuya', 'Amaya Evans', 'Lady Camille sabe que su futuro no es ni parecido al de sus amigas, o al de sus primas, que han encontrado el amor aunque sean un poco mayores. Su caso es muy distinto porque tiene un defecto, y sabe que no hay nada que ahuyente más a la sociedad, que lo que no es normal. Con más de veintitrés, sabe con certeza que su destino es ser una solterona. Sin embargo, cuando conoce a lord Darius, un apuesto conde que no la mira con lástima, sino que por el contrario es amable y busca su compañía, ella ve que su corazón puede estar en peligro de enamorarse. Lord Darius Morley conde de Landbrook, solo asiste a las temporadas para coquetear con las nuevas palomas que debutan ese año, pero esto se ha convertido en una pesadilla desde que su madre quiere que una de ellas, se convierta en la futura condesa de Landbrook. Aburrido de su horrible persecución, jamás se imaginó que una visita a su buen amigo, el conde de Woodbridge, le permitiría conocer a la mujer que cambiaría su vida. Desde que la vio lo cautivó con su belleza, pero también con su timidez e inteligencia. Sin embargo, ella está convencida de que un pequeño defecto del que padece, es algo tan terrible, que nadie en sus cinco sentidos podría fijarse en ella. Y será Darius quien le demuestre con besos y caricias, que está muy equivocada.', v_210, '4 Antes De Ser Tuya - Amaya Evans.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Quiéreme y te daré mi vida (Quiéreme 1)' AND Autor = 'Karenina Bequer') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Quiéreme y te daré mi vida (Quiéreme 1)', 'Karenina Bequer', NULL, v_42, '1 (Quiereme) y te daré mi vida - kerenina bequer.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'GUARDIANES OCULTOS' AND Autor = 'www') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('GUARDIANES OCULTOS', 'www', NULL, v_42, '1 - GUARDIANES OCULTOS - Luz de Luna - Rachel Hawthorne.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Educar las emociones en la primera infancia.: Teoría y guía práctica para niños de 3 a 6 años: Descubre todo lo necesario para aplicar la educación emocional en educación infantil' AND Autor = 'Belén Piñeiro') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Educar las emociones en la primera infancia.: Teoría y guía práctica para niños de 3 a 6 años: Descubre todo lo necesario para aplicar la educación emocional en educación infantil', 'Belén Piñeiro', NULL, v_42, '. Educar emociones 3 a 6 años-1.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'ya se quién tiene tu queso' AND Autor = 'Desconocido') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('ya se quién tiene tu queso', 'Desconocido', 'Las cosas se pueden hacer bien o como siempre ... el autor afirma en esta obra que el esfuerzo para hacer las cosas "como Dios manda" es como máximo igual que el que empleamos habitualmente, pero, una vez y otra, nos empecinamos en hacerlas de la manera más complicada posible, muchas veces bajo el pretexto de conseguir acabarlas antes, cosa que, por otro lado, no acostumbra a ocurrir. Este libro, pese a ser la primera novela empresarial de aventuras, y a su tono humorístico y socarrón, encierra un certero y agudo retrato de la forma en que realizamos los proyectos en nuestras empresas, y propone las pautas a seguir para evitar seguir "como siempre."', v_42, '__ya se quién tiene tu queso.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'La historia de Ander' AND Autor = 'Lauren Kate') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('La historia de Ander', 'Lauren Kate', NULL, v_42, '0.5 La historia de Ander - Lauren Kate.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'la caricia del infierno' AND Autor = 'Usuario') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('la caricia del infierno', 'Usuario', NULL, v_42, '_2_la caricia del infierno.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¿Por qué ellos sueñan con ser futbolistas y ellas princesas? Todas las claves para entender a tu pareja' AND Autor = 'Patricia Ramírez Loeffler') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¿Por qué ellos sueñan con ser futbolistas y ellas princesas? Todas las claves para entender a tu pareja', 'Patricia Ramírez Loeffler', NULL, v_42, '¿por que ellos sueñan ser futbolistas y ellas princesas.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'edc7051-2db9-4307-8fc1-be0384644ee1' AND Autor = 'usuario') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('edc7051-2db9-4307-8fc1-be0384644ee1', 'usuario', NULL, v_42, '3edc7051-2db9-4307-8fc1-be0384644ee1.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Amar o depender: Como superar el apego afectivo y hacer del amor una experiencia plena y saludable (Spanish Edition)' AND Autor = 'Walter Riso') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Amar o depender: Como superar el apego afectivo y hacer del amor una experiencia plena y saludable (Spanish Edition)', 'Walter Riso', NULL, v_42, '_Amar o depender_ - Walter Riso-1.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Comenzando a vivir (Spanish Edition)' AND Autor = 'Adrian Blake') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Comenzando a vivir (Spanish Edition)', 'Adrian Blake', NULL, v_42, '4.5 Comenzando a vivir.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Samson' AND Autor = 'Usuario de Windows') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Samson', 'Usuario de Windows', NULL, v_42, '03 Samson - Callie Rhodes.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Días sin ti' AND Autor = 'Elvira Sastre') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Días sin ti', 'Elvira Sastre', NULL, v_42, '1_5059811468594119023.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '5-Beautiful Bombshell (The Beautiful Serie 2.5) de Christina Lauren' AND Autor = 'Desconocido') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('5-Beautiful Bombshell (The Beautiful Serie 2.5) de Christina Lauren', 'Desconocido', NULL, v_210, '2.5-Beautiful Bombshell (The Beautiful Serie 2.5) de Christina Lauren.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Muñecos diabólicos' AND Autor = 'Joe Mogar') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Muñecos diabólicos', 'Joe Mogar', NULL, v_42, '✮Terror 27 - Mogar, Joe - Munecos diabolicos.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Romance entre jefes' AND Autor = 'Victoria Quinn') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Romance entre jefes', 'Victoria Quinn', NULL, v_98, '♋♋Romance entre jefes Los jefes 06- Victoria Quinn.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Una locura contigo' AND Autor = 'Mayeda Laurens') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Una locura contigo', 'Mayeda Laurens', 'Raúl es fotógrafo y está empeñado en capturar el lado bueno de Inés... si se deja... Mayeda Laurens vuelve con otra historia fresca, llena de romance y humor en esta cuarta entrega de la serie «Cinco chicos con suerte». Raúl se ha empeñado en encontrar el lado bueno de Inés, una chica cuya apariencia fría y dura e imagen de sobrada y mujer fatal resultar ser... justo eso. Y aunque captar lo bueno y agradable de cada persona es fácil para un gran fotógrafo, y sin duda Raúl lo es, ha decidido dejarlo por imposible y no intentarlo más. Las citas a cuatro siempre salen mal, pero a Inés no le queda otro remedio que aceptarlas cada vez que el novio de su amiga aparece con Raúl. Para ella, él es el graciosillo de turno, un tipo de hombre del que siempre huye como de la peste. Tener que hacer de tripas corazón cuando se ven es algo que la supera. Sin embargo, lo que ocurre entre ellos de forma inesperada en una sesión de fotos pone patas arriba las convicciones de ambos... aunque los dos se esfuercen en negarlo. Los lectores han dicho: «La historia es un despertar hacia un mundo nuevo, un empezar a ser una misma. Si por el camino, además, te encuentras con un hombre que no solo te entiende, sino que te apoya... el romance es completo». Blog Criticas, reseñas y opiniones de libros «Mayeda Laurens vuelve, una vez más, a demostrarnos que el amor es la mejor cura que puede existir. Aquí, nos encontramos con unos protagonistas un tanto descreídos del amor que una vez caigan en sus redes no sabrán cómo afrontar la situación [...] Destacar la prosa de la autora, fresca, dinámica y sencilla, toda una delicia de leer». Blog Promesas de amor «Estos dos recorren un largo camino para llegar a un punto donde los sentimientos no se pueden ocultar. Pero es precisamente en ese camino donde se conocerán a sÍ mismos e Inés comprenderá que ser ella misma y luchar por lo que quiere la hace feliz. Tan feliz que compartirá esa felicidad con Raúl». mecaienunlibro «La historia de Inés y Raúl es mucho más intimista, más de sentimientos, en definitiva más introspectiva (...) Siempre es un placer comprobar varios registros de los autores, está claro que los protagonistas mandan, pero detrás hay una pluma que los dirige». Blog Las historias de Miss Smile «Uno de los aspectos más destacables es cómo la autora crea la relación entre Inés y Raúl, sin caer en clichés demasiado trillados. A pesar de ser el clásico cliché de los polos opuestos que se atraen, la historia resulta real y bien desarrollada, con personajes que evolucionan y van mostrando sus verdaderas personalidades sin perder su esencia» @eldesvandelasdelicias (vía Instagram).', v_210, '4 Una locura contigo - Mayeda Laurens.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Rosa negra' AND Autor = 'Nora Roberts') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Rosa negra', 'Nora Roberts', 'Karagül (en español: Rosa negra) es una serie de televisión turca de 2013, producida por Avşar Film y emitida por Fox Turquía.​
La serie fue en parte grabada en Halfeti, un pequeño poblado situado a orillas del río Éufrates. El nombre de la serie se debe a las rosas negras, las cuales sólo crecen naturalmente en esa zona del sureste de Turquía.​​', v_217, '(Trilogía del jardín 02) Rosa negra - Nora Roberts.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Secuestrada (Spanish Edition)' AND Autor = 'Anna Zaires & Dima Zales') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Secuestrada (Spanish Edition)', 'Anna Zaires & Dima Zales', NULL, v_42, '01.Secuestrada.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Mi jefe ya no es un amor' AND Autor = 'Aitor Ferrer') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Mi jefe ya no es un amor', 'Aitor Ferrer', NULL, v_42, '2 Mi jefe ya no es un amor - Aitor Ferrer.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El Club: Una historia erótica' AND Autor = 'Nina Klein') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El Club: Una historia erótica', 'Nina Klein', 'Este libro es una recopilación de las tres primeras historias pertenecientes a la serie "El Club", la historia completa de Mark y Caroline: "El Club", "Una noche más" y "Todos tus deseos"....Caroline está harta de citas cutres en Tinder y de desperdiciar sábados por la noche en tipos que no merecen la pena.Cuando le cuenta su último desastre a Chloe, su compañera de oficina, ésta le da una tarjeta misteriosa, con un palabra grabada en ella: Poison.La tarjeta es de un club de sexo, donde todos sus deseos pueden hacerse realidad...El sábado siguiente, con un vestido nuevo, unos zapatos de ensueño y hecha un manojo de nervios, Caroline se planta enfrente de la puerta del club.¿Se decidirá a entrar?¿Será lo que ella esperaba, o será otro sábado por la noche desperdiciado...?Más de 130 páginas llenas de erotismo, romance y humor....Atención: este libro contiene escenas de sexo explícito, aptas solo para mayores de 18 años.', v_42, '1.El Club_ Una historia erotica - Nina Klein.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Mi error fue amarte (Parte I)' AND Autor = 'Moruena Estríngana') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Mi error fue amarte (Parte I)', 'Moruena Estríngana', NULL, v_42, '5. Mi error fue amarte .pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Enola Holmes' AND Autor = 'El caso del adiós gitano') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Enola Holmes', 'El caso del adiós gitano', 'Enola Holmes es una película de misterio, romance, aventura y acción de 2020 protagonizada por Millie Bobby Brown como el personaje principal, la hermana adolescente del ya famoso detective de la época victoriana Sherlock Holmes. La película está dirigida por Hary Bradbeer a partir de un guion de Jack Thorne que adapta la primera novela de la serie Las aventuras de Enola Holmes de Nancy Springer. En la película, Enola viaja a Londres para encontrar a su madre desaparecida, pero termina en una emocionante aventura, formando pareja con un lord fugitivo mientras intentan resolver un misterio que amenaza a todo el país. Además de Brown, la película también está protagonizada por Sam Claflin, Henry Cavill y Helena Bonham Carter.
El rodaje comenzó en julio de 2019. Originalmente planeada para un estreno en cines por Warner Bros. Pictures, los derechos de distribución de la película fueron adquiridos por Netflix debido a la pandemia de COVID-19. Enola Holmes se estrenó el 23 de septiembre de 2020. La película recibió críticas positivas de los críticos, quienes elogiaron la actuación de Brown. Se convirtió en uno de los estrenos de películas originales de Netflix más vistos, con un estimado de 76 millones de hogares viendo la película durante sus primeras cuatro semanas. Una secuela, Enola Holmes 2, se estrenó en Netflix el 4 de noviembre de 2022.', v_164, '6. Enola Holmes - El caso del adiós gitano.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El túnel' AND Autor = 'Ernesto Sábato') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El túnel', 'Ernesto Sábato', 'El túnel es una novela corta de Ernesto Sabato publicada en 1948. Juan Pablo Castel, personaje principal y narrador, cuenta desde la cárcel los motivos que lo llevaron a asesinar a su amante María Iribarne.', v_223, '☆El tunel - Ernesto Sabato.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Mi error fue amar al príncipe (Parte 2)' AND Autor = 'Moruena Estríngana') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Mi error fue amar al príncipe (Parte 2)', 'Moruena Estríngana', NULL, v_42, '1.2. Mi error fue amar al príncipe .pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '5059811468594118962' AND Autor = 'Desconocido') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('5059811468594118962', 'Desconocido', NULL, v_42, '1_5059811468594118962.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¿Qué es la justicia?' AND Autor = 'Hans Kelsen') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¿Qué es la justicia?', 'Hans Kelsen', NULL, v_42, '_Qué es la Justicia- Hans Kelsen.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Riding Rough' AND Autor = 'user') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Riding Rough', 'user', NULL, v_42, '2. Riding Rough.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'EL MAGO QUE OLVIDÓ SU PODER: Frases y cuentos para sanar el alma (Spanish Edition)' AND Autor = 'Marco Navarro') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('EL MAGO QUE OLVIDÓ SU PODER: Frases y cuentos para sanar el alma (Spanish Edition)', 'Marco Navarro', NULL, v_42, '1_4994500151486710092.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Culpa mía' AND Autor = 'Mercedes Ron') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Culpa mía', 'Mercedes Ron', 'Culpa mía es una película romántica española de 2023 dirigida por Domingo González, basada en el libro superventas homónimo de Mercedes Ron.​', v_63, '01.- Culpa mía - Mercedes Ron.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'La caída' AND Autor = 'Amanda Hocking') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('La caída', 'Amanda Hocking', 'Al descubrir su verdadera identidad, Wendy cae entre dos destinos: el amor y la lealtad. Wendy parece estar más conectada a sus rivales, los Vittra, de lo que jamás imaginó, y estos intentan convencerla de que luche junto a ellos. Con una guerra a punto de estallar, la única esperanza de salvar a los suyos está en desarrollar su fuerza y casarse con un poderoso noble. Dividida entre los dictados de su corazón y la llamada del deber, Wendy tendrá que decidir, y si se equivoca, podría perder todo loque ama.', v_215, '_01_La Caida De Los Reinos.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Elaboración de Jabones Ar' AND Autor = 'DORELIRA') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Elaboración de Jabones Ar', 'DORELIRA', NULL, v_161, '02 - Elaboración - Lámparas de Lava.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El universo oye lo que sientes: Una conversación entre dos maestros sobre la Ley de la Atracción (Spanish Edition)' AND Autor = 'Dyer, Wayne W. & Hicks, Esther') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El universo oye lo que sientes: Una conversación entre dos maestros sobre la Ley de la Atracción (Spanish Edition)', 'Dyer, Wayne W. & Hicks, Esther', NULL, v_42, '4_5882240496813737920.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'La abadía de Northanger' AND Autor = 'Desconocido') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('La abadía de Northanger', 'Desconocido', 'Northanger Abbey fue la primera de las novelas de Jane Austen que estuvo preparada para su publicación, aunque antes había comenzado a trabajar en Sentido y sensibilidad y Orgullo y prejuicio. De acuerdo con el memorándum de Cassandra Austen, Susan (como fue llamado en principio) se escribió alrededor de los años 1798-1799.
Northanger Abbey se escribió en 1798, fue revisado para la imprenta en 1803, y vendido ese mismo año por diez libras (£10) a un vendedor de libros de Bath, Crosbie & Co. quien después de dejarlo durante varios años en sus baldas, lo revendió al hermano de la novelista, Henry Austen, por la misma suma que él había pagado al principio, desconociendo que la escritora era ya la autora de cuatro populares novelas. La novela fue revisada de nuevo antes de publicarse póstumamente a finales de diciembre de 1817 (1818 se dice en su página inicial) como los dos primeros volúmenes de un conjunto de cuatro, siguiéndole Persuasión.

', v_159, '2_5202179386664552747.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El jefe' AND Autor = 'Victoria Quinn') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El jefe', 'Victoria Quinn', 'Emanuel Herrera Batista (Bajos de Haina, Provincia de San Cristóbal, 18 de diciembre de 1990) conocido artísticamente como el Alfa, es un cantante dominicano.​ Su música principalmente es dembow dominicano, aunque también hace y utiliza otros ritmos urbanos latinos.​​', v_98, '♋♋Normas del Jefe 08.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¿Puede Pensar una Máquina?' AND Autor = 'Alan M. Turing') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¿Puede Pensar una Máquina?', 'Alan M. Turing', 'En 1947 Alan M. Turing pronunció una conferencia ante un auditorio compuesto en su mayor parte por miembros del National Physical Laboratory de Londres en la que intentaba responder a la vieja y controvertida pregunta ¿Puede pensar una máquina''.', v_42, '_Puede Pensar una Maquina_ - Alan M. Turing.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Pulse' AND Autor = 'Deborah Bladon') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Pulse', 'Deborah Bladon', 'Pulse - Part Three: Jessica wanted to believe Nathan was a changed man. The lust filled promises he made in bed are no match for the reality that she''s now holding in the palm of her hand. Sex drives men like Nathan Moore. She suspected it, then experienced it and now there''s absolutely no denying it. She knows what the right thing to do is. He knows that he''s never met anyone like her. Jessica struggles to forget him as Nathan''s desire for her consumes him. His compulsive need to possess her pushes him in ways that will change them both forever. Just how far is Nathan Moore willing to go to have the one woman he claims he can''t live without?', v_38, '03 Pulse - Deborah Bladon.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El regreso de ¡Y tenía que ser mi jefe! (Spanish Edition)' AND Autor = 'Norah Carter & Monika Hoff') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El regreso de ¡Y tenía que ser mi jefe! (Spanish Edition)', 'Norah Carter & Monika Hoff', NULL, v_42, '5 Y tenia que ser mi jefe.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Dibujar Nariz' AND Autor = 'Desconocido') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Dibujar Nariz', 'Desconocido', 'Antes de comenzar a dibujar una cabeza humana debemos saber dibujar correctamente las diferentes partes del rostro. Cada una de las partes de un rostro presenta caracter�sticas muy �nicas seg�n el sexo y la composici�n racial. Un ojo de una persona oriental es muy diferente al de una anglosajona as� como se diferencian tambi�n el resto de sus partes.En este libro aprender�s a dibujar la estructura b�sica de cada una de las partes del rostro humano y a caracterizar diferentes razas, sexo y expresiones faciales.Podr�s dibujar los ojos, la nariz, la boca y las orejas de personas, aprender�s gradualmente ciertos fundamentos y t�cnicas b�sicas de laanatom�a de la cabeza humana para realizar tus propios dibujos.Identificar�s las diferencias entre el rostro masculino y uno femenino y otras caracter�sticas anat�micas siguiendo los ejemplos y modelos que te presentamos en este libro.', v_42, '▪︎Dibujar Nariz.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¿Es Usted un psicópata?' AND Autor = 'Jon Ronson') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¿Es Usted un psicópata?', 'Jon Ronson', 'Traces an investigation of an alleged hoax that led to the mental health industry, explaining how a psychologist revealed the psychopathic profiles of top CEOs and politicians while imparting strategies for recognizing psychopathic behavior.', v_142, '_Es usted un psicopata_ - Jon Ronson.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'La vida mentirosa de los adultos' AND Autor = 'Desconocido') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('La vida mentirosa de los adultos', 'Desconocido', NULL, v_42, '1_4916082088840528182.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Dalia azul' AND Autor = 'Nora Roberts') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Dalia azul', 'Nora Roberts', 'La primera entrega de la «Trilogía del jardín», la historia de tres mujeres que lucharán por conquistar la felicidad. Huyendo de los fantasmas del pasado, Stella Rotchild, una joven viuda con dos hijos pequeños, ha regresado al viejo Sur y a sus raíces. Tiene ante ella un trabajo, un hogar, dos grandes amigas y la posibilidad de un nuevo amor... si por fin decide aceptar que a veces hay que tomar riesgos. TRILOGÍA DEL JARDÍN Tres mujeres se conocen en un momento crucial de sus vidas: cuando es necesario dejar atrás el pasado, pero el futuro todavía parece incierto. Para Stella, Rosalind y Hayley, la mansión Harper -una vieja casa sureña a las afueras de Memphis- se convierte en un puerto seguro y un auténtico hogar. El pequeño y próspero negocio de un vivero de flores y plantas, en el que todas han depositado sus esperanzas, se erige en el símbolo de su independencia. Juntas encontrarán el valor para rehacer sus vidas y aceptar el amor cuando aparezca... aunque un misterio anclado en la centenaria casa solariega puede ponerlas a ellas y a quienes más aman en peligro. Reseña: «El inicio prometedor de una nueva serie». Publishers Weekly', v_210, '(Trilogía del jardín 01) Dalia azul - Nora Roberts.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¡El amor me ha estafado!' AND Autor = 'Kris Buendia') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¡El amor me ha estafado!', 'Kris Buendia', NULL, v_42, '_El Amor me ha estafado!.pdf-1.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Juegos insolentes 4' AND Autor = 'Emma Green') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Juegos insolentes 4', 'Emma Green', NULL, v_42, '0 Juegos_insolentes_4_Emma_Green38a4.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Solo anhelo tu aroma' AND Autor = 'Priscila Serrano') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Solo anhelo tu aroma', 'Priscila Serrano', 'Lo más difícil del mundo es dejar marchar a la persona amada, pero a veces no queda más remedio... y siempre queda la esperanza de que la vida te brinde una segunda oportunidad.', v_210, '3 Solo anhelo tu aroma - Priscila Serrano.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Solo recuerdo tu voz' AND Autor = 'Priscila Serrano') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Solo recuerdo tu voz', 'Priscila Serrano', 'Dicen que su amor es prohibido. Dicen que es mejor separarlos. Dicen, dicen.. . Todos hablan, todos opinan... Pero ningún amor, cuando es real, debe ser negado y destruido. La vida puede cambiar en un segundo. Puedes decir «nos vemos mañana» y no estar al siguiente día. Ni siquiera pudieron despedirse, ocurrió tan rápido... La vida de Elsa cambió y ese hueco que creía vacío se llenó de un amor del que no podría escapar por mucho que se negara. Y se enamoró, lo hizo de la persona que menos pensaba y de la que no debería sentir nada más que un simple cariño. Pero ¿qué pasa si él siente exactamente lo mismo que ella? ¿Qué pasa cuando sus corazones comienzan a latir con tanta fuerza que incluso podrían lastimar a otros?', v_210, '1 Solo recuerdo tu voz - Priscila Serrano.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¡Y tenía que ser mi jefe! 6 (Spanish Edition)' AND Autor = 'Norah Carter & Monika Hoff') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¡Y tenía que ser mi jefe! 6 (Spanish Edition)', 'Norah Carter & Monika Hoff', NULL, v_42, '6 Y tenia que ser mi jefe.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Cinder. Marissa Meyer, Cronicas Lunares' AND Autor = 'Desconocido') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Cinder. Marissa Meyer, Cronicas Lunares', 'Desconocido', 'Cinder tiene 16 años y trabaja como mecánica. Hasta que su camino se cruza con el del príncipe Kai, y se ve en medio de un conflicto intergaláctico y de un amor imposible.', v_183, '01. Cinder. Marissa Meyer, Cronicas Lunares.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Ceniza, somos ceniza…' AND Autor = 'Clark Carrados') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Ceniza, somos ceniza…', 'Clark Carrados', NULL, v_42, '✮Terror 28 - Carrados, Clark - Ceniza, somos ceniza__.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El caballero de la armadura oxidada' AND Autor = 'Robert Fisher') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El caballero de la armadura oxidada', 'Robert Fisher', 'El caballero de la armadura oxidada (en inglés, The Knight in Rusty Armor) es una novela del escritor y guionista estadounidense Robert Fisher. Publicada en 1989, la obra se caracteriza por su estilo alegórico y está inspirada libremente en el clásico El progreso del peregrino de John Bunyan. Es ampliamente considerada dentro del género de autoayuda, gracias a su enfoque en el desarrollo personal y la superación emocional.
La novela ha sido traducida a numerosos idiomas y es considerada un superventas internacional. Su popularidad ha trascendido generaciones, consolidándose como un clásico contemporáneo del crecimiento personal. La obra aborda temas universales como la autenticidad, el autoconocimiento y el perdón, convirtiéndose en un recurso frecuente en contextos educativos, terapéuticos y talleres de desarrollo humano.
Robert Fisher, reconocido por su trabajo como guionista para figuras emblemáticas de Hollywood como Groucho Marx y Lucille Ball, encontró en esta obra una forma de transmitir reflexiones profundas sobre las emociones y los conflictos internos desde una perspectiva accesible y universal.', v_23, '1_5017302399149146350.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'No me ames (Spanish Edition)' AND Autor = 'Norah Carter & Monika Hoff & Patrick Norton') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('No me ames (Spanish Edition)', 'Norah Carter & Monika Hoff & Patrick Norton', NULL, v_42, '01 NO ME AMES_NORAH CARTER.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '4972089037905985875' AND Autor = 'Gilda') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('4972089037905985875', 'Gilda', NULL, v_42, '1_4972089037905985875.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Furia' AND Autor = 'Chachii') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Furia', 'Chachii', NULL, v_42, '3 Furia.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¡Mi hermanastro es un highlander!' AND Autor = 'Olivia Kiss') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¡Mi hermanastro es un highlander!', 'Olivia Kiss', NULL, v_42, '¡Mi hermanastro es un highlander! - Olivia Kiss  .pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Domada por la bestia (Programa de Novias Interestelares® nº 7) (Spanish Edition)' AND Autor = 'Grace Goodwin') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Domada por la bestia (Programa de Novias Interestelares® nº 7) (Spanish Edition)', 'Grace Goodwin', NULL, v_42, '5a3b2d62-4dac-43ac-9c12-3a1900ab1964.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Mi error fue enamorarme del novio de mi hermana 2' AND Autor = 'Moruena Estríngana') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Mi error fue enamorarme del novio de mi hermana 2', 'Moruena Estríngana', NULL, v_42, '4.2. Mi error fue enamorarme del novio de mi hermana .pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Ana la de Avonlea' AND Autor = 'Lucy Maud Montgomery') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Ana la de Avonlea', 'Lucy Maud Montgomery', 'Ana, la de Avonlea (en inglés, Anne of Avonlea) es una novela de Lucy Maud Montgomery, fue publicada por primera vez en 1909, como L. M. Montgomery.
Siguiendo al libro Ana de las Tejas Verdes publicado en 1908, el libro es el segundo capítulo de la vida de Ana. La novela nos relata la vida de Ana durante los dos siguientes años, desde los 16 hasta los 18, tiempo durante el cual es la maestra de la escuela de Avonlea. Aunque en el libro aparecen la mayoría de los personajes del primer libro, también incluye nuevos personajes, como el señor Harrison, la señorita Lavendar Lewis, los mellizos Dora y Davy y Paul Irving.', v_62, '2.- ana_la_de_avonlea.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El Libro de los Cuentos Perdidos II' AND Autor = 'J. R. R. Tolkien') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El Libro de los Cuentos Perdidos II', 'J. R. R. Tolkien', 'El principio de toda la concepción de la Tierra Media El Libro de los Cuentos Perdidos fue la primera gran obra de imaginación de J.R.R. Tolkien, comenzada en 1916-1917, cuando tenía veinticinco años, y abandonada varios años después. Es en realidad el principio de toda la concepción de la Tierra Media y Valinor, y el primer esbozo de los mitos y leyendas que constituirían El Silmarillion. El marco narrativo es el largo viaje hacia el Oeste que emprende un marinero llamado Eriol (Aelfwíne) a Tol Eressëa, la isla solitaria donde habitan los Elfos. Allí conoce los Cuentos Perdidos de Elfenesse, en los que aparecen las ideas y concepciones más tempranas sobre los Dioses y los Elfos, los Enanos, los Balrogs y los Orcos, los Silmarils, los dos árboles de Valinor, Nargothrond y Gondolin, y la geografía y la cosmología de la Tierra Media. El libro de los Cuentos Perdidos se publica en dos volúmenes. Este segundo volumen incluye Beren y Lúthien, Túrin y el Dragón, y las historias del Collar de los Enanos y la Caída de Gondolin. Cada cuento es seguido de un comentario -un ensayo breve-, y de algún poema relacionado con el texto, y en cada uno de los volúmenes hay abundante información sobre el vocabulario y los nombres de las primeras lenguas élficas.', v_210, '[Historia de la Tierra Media 02]  El libro de los cuentos perdidos II - J. R. R. Tolkien.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¿De qué putas madres estás hablando? (Spanish Edition)' AND Autor = 'Renèe Palma') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¿De qué putas madres estás hablando? (Spanish Edition)', 'Renèe Palma', NULL, v_42, '_De que putas madres estas habl - Renee Palma-1-1.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¿Amor o Dinero?' AND Autor = 'Helen Bianchin') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¿Amor o Dinero?', 'Helen Bianchin', NULL, v_116, '1_5062446538404397364.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¿Cuánta tierra necesita un hombre?' AND Autor = 'Tolstói') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¿Cuánta tierra necesita un hombre?', 'Tolstói', 'Cuánta tierra necesita un hombre ​ es un cuento del escritor ruso León Tolstói publicado en 1886.​ Narra las aventuras del campesino Pajom, quien impulsado por la codicia, emprende un viaje en búsqueda de propiedades.
Al igual que Pajom, Tolstói compró tierras en Baskiria a precios sumamente bajos.​La historia dramatiza los remordimientos por ser dueño de esta tierra que lo acosaron a principios de la década de 1880.​
James Joyce lo consideró como «el mejor cuento escrito jamás».​', v_42, '_Cuanta tierra necesita un homb - Tolstoi.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '(Serie Taking The Fall 4) Falling In' AND Autor = 'Alexa Riley') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('(Serie Taking The Fall 4) Falling In', 'Alexa Riley', NULL, v_42, '4. Taking The Fall.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Cuando has tocado fondo' AND Autor = 'Desconocido') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Cuando has tocado fondo', 'Desconocido', 'Sobre el escenario, bajo las luces y frente a su público, Pastora Soler sintió el silencio y la sombra de la inseguridad. Sin embargo, ese oscuro momento se convirtió en el inicio de una historia de fuerza y superación inspiradora . En este conmovedor relato, Pastora Soler abre su corazón y nos lleva por aquellos momentos que han marcado su vida. Con humildad, valentía y gran honestidad, la autora comparte en estas páginas cómo, a pesar de la angustia y los miedos, aprendió a amarse a sí misma y encontró su auténtica melodía. Este libro es un testimonio de resiliencia, una reflexión sobre cómo encontrar el equilibrio más allá de los aplausos y un recordatorio de que, a veces, hay que detenerse y parar para volver a empezar. Si alguna vez has sentido el peso de la perfección o el temor a fracasar, recuerda que cuando todo parece apagarse es precisamente cuando las estrellas empiezan a brillar.', v_64, '_Cuando has tocado fondo.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El Instituto' AND Autor = 'Stephen King') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El Instituto', 'Stephen King', 'El instituto (título original: The Institute) es una novela del escritor estadounidense Stephen King, publicada el 10 de septiembre de 2019.​​ La novela, de estilo similar a Ojos de fuego de 1980,​ relata la historia de Luke Ellis, un niño con poderes psíquicos que es reclutado por una oscura organización conocida por los niños como "El instituto".​', v_24, '______King__Stephen_______El_Instituto__Plaza__amp.pdf · versión 1.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Dibujar Capas' AND Autor = 'Desconocido') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Dibujar Capas', 'Desconocido', '★ 55% OFF For Bookstores! Discounted Retail Price NOW at $21,99 Instead of $ 29,79! ★ Pick up your pencil, embrace your inner artist, and learn how to draw in 40 days. Your Customers Will Never Stop To Use This Awesome Book! Drawing is an acquired skill, not a talent, anyone can learn to draw! All you need is a pencil, a piece of paper, and the willingness to tap into your hidden artistic abilities. helpful resource begins with a thorough introduction to the essential tools and materials you need to get started, including different types of pencils, sketchbooks, papers, and other tools. Then learn the fundamentals of drawing, as well as a variety of drawing techniques, including rendering realistic textures, creating volume, and capturing perspective. Simple Step-by-Step Instructions Make Drawing Easy! Artists will learn the fundamentals of drawing, as well as a variety of techniques, including rendering realistic textures, capturing perspective, and creating dynamic portraits and compositions. With helpful tips and step-by-step artwork to inspire, this book is the perfect resource for practiced beginning to intermediate artists looking to hone their drawing skills and techniques. Book details: Material and tools for drawing Types of drawing What is the memory drawing What is the drawing from imagination Techniques for drawing Top tips Different Types of Shades Adding Depth to Images Drawing the Eyes and more! Buy it NOW and let your costumers get addicted to this amazing book', v_42, '▪︎Dibujar Capas.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Rough Rider' AND Autor = 'user') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Rough Rider', 'user', NULL, v_184, '1. Rough Rider.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Pasión (Tentación nº 2)' AND Autor = 'Dylan Martins') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Pasión (Tentación nº 2)', 'Dylan Martins', NULL, v_42, '2- Pasion (Tentacion no) - Dylan Martins _.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'La bella y el barón' AND Autor = 'Larissa de Silva') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('La bella y el barón', 'Larissa de Silva', NULL, v_42, '1 La bella y el barón (ritmo cardíaco) - Larissa de Silva.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'el-codigo-de-las-mentes-extraordinarias-jkhpdf' AND Autor = 'Desconocido') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('el-codigo-de-las-mentes-extraordinarias-jkhpdf', 'Desconocido', NULL, v_42, '_el-codigo-de-las-mentes-extraordinarias-jkhpdf.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Ana la de Álamos Ventosos' AND Autor = 'Lucy Maud Montgomery') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Ana la de Álamos Ventosos', 'Lucy Maud Montgomery', 'Ana, la de Álamos Ventosos es una novela en forma epistolar de la escritora canadiense Lucy Maud Montgomery. Publicado por primera vez en 1936, detalla las experiencias de Ana Shirley durante los tres años que pasa dando clases en el Instituto Summerside de Enseñanza Media, en la Isla del Príncipe Eduardo.
La novela la forman una serie de cartas que Ana le envía a su prometido, Gilbert Blythe, quien está estudiando para ser médico. Siguiendo la línea cronológica este libro es el cuarto en la historia de Anne Shirley, sin embargo fue el séptimo libro en escribirse.', v_175, '4.- ana_la_de_Álamos_ventosos.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¡ Y tenía que ser mi jefe ! 4: El desenlace' AND Autor = 'Norah Carter') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¡ Y tenía que ser mi jefe ! 4: El desenlace', 'Norah Carter', NULL, v_42, '4  ¡Y tenia que ser mi Jefe!.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El mar de los monstruos' AND Autor = 'Rick Riordan') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El mar de los monstruos', 'Rick Riordan', 'El mar de los monstruos (título original en inglés: The Sea of Monsters) es una novela fantástica de aventuras basada en la mitología griega. Está escrita por el autor Rick Riordan y fue publicada el 1 de abril de 2006 en Estados Unidos, y en junio de 2008 en España,​ por la editorial Salamandra, dentro de su línea Narrativa Juvenil. Es el segundo libro de la saga Percy Jackson y los dioses del Olimpo y la secuela de El ladrón del rayo. Este libro narra las aventuras del semidiós (hijo de un dios y una mortal) Percy Jackson, y trata de como él y su amiga Annabeth —otra semidiosa— van a rescatar al sátiro Grover del cíclope Polifemo y salvar el campamento de los ataques de los monstruos, por lo que tienen que traer el vellocino de oro para curar de envenenamiento el árbol de Thalía.', v_140, '2-El mar de los monstruos.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'J. P. Sartre versus Merleau-Ponty' AND Autor = 'Simone de Beauvoir') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('J. P. Sartre versus Merleau-Ponty', 'Simone de Beauvoir', NULL, v_42, '_Beauvoir, Simone - Sartre Versus Merleau-Ponty.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Querida Katty' AND Autor = 'Silver Kane') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Querida Katty', 'Silver Kane', NULL, v_42, '✮Terror 09 - Kane, Silver - Querida Katty.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'La madre de las serpientes' AND Autor = 'Clark Carrados') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('La madre de las serpientes', 'Clark Carrados', NULL, v_42, '✮Terror 100 - Carrados, Clark - La madre de las serpientes.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '5026138577101127888' AND Autor = 'Desconocido') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('5026138577101127888', 'Desconocido', NULL, v_42, '1_5026138577101127888.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Puedo superarme (Spanish Edition)' AND Autor = 'Bernardo Stamateas') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Puedo superarme (Spanish Edition)', 'Bernardo Stamateas', NULL, v_42, '¡Puedo superarme! Cómo seguir adelante y crecer interiormente.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El Arte del Terror - Volumen 1' AND Autor = 'Donnefar Skedar, Faby Crystall, E. N. Andrade, JC King') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El Arte del Terror - Volumen 1', 'Donnefar Skedar, Faby Crystall, E. N. Andrade, JC King', NULL, v_42, '_Arte_del_Terror_-_Volumen_1_-_VVAA.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'His Everything' AND Autor = 'user') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('His Everything', 'user', NULL, v_42, '1. His Everything.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¿Y si el amor existe de verdad? (Spanish Edition)' AND Autor = 'Mariló Lafuente') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¿Y si el amor existe de verdad? (Spanish Edition)', 'Mariló Lafuente', NULL, v_42, '_¿y si el amor existe deverdad--1.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¿Quiéres casarte conmigo? (Mundo y Cristianismo) (Spanish Edition)' AND Autor = 'Fernando Alberca') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¿Quiéres casarte conmigo? (Mundo y Cristianismo) (Spanish Edition)', 'Fernando Alberca', NULL, v_42, '¿Quiéres casarte conmigo.pdf · versión 1.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Diablo' AND Autor = 'Stephanie Laurens') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Diablo', 'Stephanie Laurens', 'Las fans de la serie Cynster disfrutarán de esta apasionate novela, que como las demás se puede leer de forma independiente. Primera entrega de la saga romántica «Cynster». ¿Era el marido que siempre había soñado, o un verdadero demonio? Honoria Wetherby es institutriz, pero tiene otros proyectos: vivir aventuras, conocer mundo... aunque lo inesperado puede cambiar drásticamente hasta los mejores planes. Su intento de ayudar a un moribundo la lleva a pasar la noche en una cabaña solitaria en compañía del miembro más denostado de los Cynster, a quien llaman Diablo. Cuando esto sale a la luz, él no tiene otro remedio que pedir su mano. La familia Cynster está encantada de que el famoso libertino finalmente decida casarse, pero lo que menos desea la rebelde joven es un marido que la controle, y enamorarse no está en sus planes.', v_37, '_Al_diablo_con_el_amor_.__-_Vanessa_Lorrenz.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'ESTRATEGIAS PARA AUMENTAR SU RIQUEZA' AND Autor = 'RICHA & DAD') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('ESTRATEGIAS PARA AUMENTAR SU RIQUEZA', 'RICHA & DAD', NULL, v_42, '5 ESTRATEGIAS PARA AUMENTAR SU RIQUEZA - RICHA & DAD - 7 PAGINAS.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Mi error fue confiar en ti. Parte I (Spanish Edition)' AND Autor = 'Moruena Estríngana') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Mi error fue confiar en ti. Parte I (Spanish Edition)', 'Moruena Estríngana', NULL, v_42, '3. Mi error fue confiar en ti .pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Solo me pierdo en tus ojos' AND Autor = 'Priscila Serrano') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Solo me pierdo en tus ojos', 'Priscila Serrano', '¿Puede haber amor entre notas musicales? Estos relatos demuestran que la música y el amor van de la mano. Y es que cuando el sentimiento es experimentado entre roces, miradas y una bonita canción de fondo, todo fluye con más intensidad. Cuatro historias llenas de amor. Cuatro parejas amándose al compás de la música. Cuatro amores inesperados. Ven, adéntrate entre estas líneas y enamórate.', v_210, '2 Solo me pierdo en tus ojos - Priscila Serrano.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El jefe' AND Autor = 'Victoria Quinn') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El jefe', 'Victoria Quinn', 'Emanuel Herrera Batista (Bajos de Haina, Provincia de San Cristóbal, 18 de diciembre de 1990) conocido artísticamente como el Alfa, es un cantante dominicano.​ Su música principalmente es dembow dominicano, aunque también hace y utiliza otros ritmos urbanos latinos.​​', v_98, '♋♋El jefe supremo (Los jefes no 5 - Victoria Quinn.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Amor, bienvenido a bordo' AND Autor = 'Elsa Jenner') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Amor, bienvenido a bordo', 'Elsa Jenner', NULL, v_42, '1. AMOR, BIENVENIDO A BORDO - TRILOGÍA ABORDO I - Elsa Jenner.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Quiéreme y no te detengas (Quiéreme 2)' AND Autor = 'Karenina Bequer') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Quiéreme y no te detengas (Quiéreme 2)', 'Karenina Bequer', NULL, v_42, '2 (Quiéreme) y no te detengas - kerenina bequer.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El corazón delator' AND Autor = 'Edgar Allan Poe') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El corazón delator', 'Edgar Allan Poe', 'El corazón delator —en inglés original The Tell-Tale Heart— es un cuento del escritor estadounidense Edgar Allan Poe clasificado en la narrativa gótica, publicado por primera vez en el periódico literario The Pioneer, del amigo de Poe, James Russell Lowell, en enero de 1843.​ Poe lo republicó más tarde en su periódico el Broadway Journal en la edición del 23 de agosto de 1845.​ Ha sido adaptado o servido de inspiración en numerosas ocasiones y en distintos medios.
La historia presenta a un narrador anónimo obsesionado con el ojo enfermo (que llama "ojo de buitre") de un anciano con el cual convive. Finalmente decide asesinarlo. El crimen es planeado cuidadosamente y, tras ser perpetrado, el cadáver es despedazado y escondido bajo las tablas del suelo de la casa. La policía acude a la misma y el asesino acaba delatándose a sí mismo, imaginando alucinadamente que el corazón del viejo se ha puesto a latir bajo la tarima.
No se sabe cuál es la relación entre víctima y asesino. Se ha sugerido que el anciano representa en el cuento a la figura paterna, y que su "ojo de buitre" puede sugerir algún secreto inconfesable. La ambigüedad y la falta de detalles acerca de los dos personajes principales están en agudo contraste con el detallismo con que se recrea el crimen.', v_79, '1_5006304388063428859.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Unknown' AND Autor = 'Annabeth Berkley') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Unknown', 'Annabeth Berkley', NULL, v_42, '1_5059811468594119027.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Revividos' AND Autor = 'Ralph Barby') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Revividos', 'Ralph Barby', NULL, v_42, '✮Terror 14 - Barby, Ralph - Revividos.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '[Gutenberg 58049] • El Marqués de Bradomín: Coloquios Románticos' AND Autor = 'Valle-Inclán, Ramón del') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('[Gutenberg 58049] • El Marqués de Bradomín: Coloquios Románticos', 'Valle-Inclán, Ramón del', NULL, v_42, '[Gutenberg 58049] _ El Marques - Valle-Inclan, Ramon del.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¿Dormí con mis Jefes?' AND Autor = 'Angie Rossi') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¿Dormí con mis Jefes?', 'Angie Rossi', NULL, v_42, '_Dormi con mis Jefes_ - Angie Rossi.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'La mansión de los pantanos' AND Autor = 'Ralph Barby') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('La mansión de los pantanos', 'Ralph Barby', NULL, v_42, '✮Terror 30 - Barby, Ralph - La mansion de los pantanos.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '5024155560635794119' AND Autor = 'Marina Cruz') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('5024155560635794119', 'Marina Cruz', NULL, v_42, '1_5024155560635794119.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Préstame a tu hermano (Spanish Edition)' AND Autor = 'Iris Boo') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Préstame a tu hermano (Spanish Edition)', 'Iris Boo', NULL, v_42, '¡Préstame a tu hermano! - Iris Boo(Préstame 3).pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Déjame ahora' AND Autor = 'Dylan Martins & Janis Sandgrouse') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Déjame ahora', 'Dylan Martins & Janis Sandgrouse', NULL, v_42, '01. Déjame Ahora - Dylan Martins.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'No soy yo, eres tú' AND Autor = 'Ebony Clark') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('No soy yo, eres tú', 'Ebony Clark', 'Una historia sobre corazones rotos, citas a ciegas y... ¡gatos y ratones! La segunda entrega de la bilogía «Tal para cual». ¡No te la pierdas! Daniela es abogada. Trabaja en un despacho especializado en divorcios. Después de la ruptura de sus padres, del que su madre la culpa, y enamorada de Lucas, compañero de trabajo y hombre perfecto, inaccesible y casado, Daniela decide pedir una excedencia en el trabajo y tomarse un respiro. Su compañera de piso, Mimi, tiene un proyecto. Mimi es pura energía positiva, el yan de Daniela, un terremoto andante llena de ideas e iniciativas. Mimi cree en el amor y se mueve como pez en el agua en las redes sociales. Con estos dos ingredientes ha puesto en marcha una aplicación de citas a ciegas, TalparaCual, que está resultando un éxito. Daniela siente mucha curiosidad. Le intrigan los motivos de la gente para iniciar lo que ella termina rompiendo en su profesión. ¿Qué hace que todas esas personas se empeñen en aventurarse en algo abocado al fracaso? ¿Existe el flechazo, existe realmente el amor? Alex es bombero. Su trabajo es su pasión. Sobre todo, ahora que Silvia, su novia de toda la vida, le ha dejado por un representante de perfumes y pretende quedarse con el piso de ambos. Alex se muda a un edificio de apartamentos cerca de la playa. A Alex le gusta entrenar cada mañana en su terraza, escuchando su música favorita. Solo hay un inconveniente, su vecina de enfrente. Una bruja con mala leche a la que no le gusta madrugar. Si el amor no existe. Si es una gran mentira. Si duele y saca de cada uno lo peor... ¿Cómo es que seguimos tentando la suerte?', v_210, '2 No soy yo, eres tu - Ebony Clark.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¿Eres para mí?' AND Autor = 'C. Marcelmor') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¿Eres para mí?', 'C. Marcelmor', NULL, v_42, '_Eres para mi_ - C. Marcelmor (1) (1).pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¡El amor me ha estafado!' AND Autor = 'Kris Buendia') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¡El amor me ha estafado!', 'Kris Buendia', NULL, v_42, '_El_amor_me_ha_estafado_-_Kris_Buendia.pdf_filename= UTF-8_!El amor me ha estafado! - Kris Buendia.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '4940553489643208897' AND Autor = 'Desconocido') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('4940553489643208897', 'Desconocido', NULL, v_42, '1_4940553489643208897.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'La cita perfecta (Spanish Edition)' AND Autor = 'Melita Joy') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('La cita perfecta (Spanish Edition)', 'Melita Joy', NULL, v_42, '_CitaPerfecta.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Siete besos' AND Autor = 'Kate Danon') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Siete besos', 'Kate Danon', NULL, v_42, '1_5048553032166408441.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '5990299730792416951' AND Autor = 'Lora') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('5990299730792416951', 'Lora', NULL, v_42, '4_5990299730792416951.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Mía por completo (La obsesión de un millonario IV)' AND Autor = 'J. S. Scott') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Mía por completo (La obsesión de un millonario IV)', 'J. S. Scott', NULL, v_42, '4.Mía Por Completo 4 - J. S. Scott.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Love at First Sight' AND Autor = 'yeimi paola de avila vanegas') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Love at First Sight', 'yeimi paola de avila vanegas', '«Love at First Sight» (esp. Amor a primera vista) es una canción pop dance de la australiana Kylie Minogue de su octavo álbum de estudio Fever. La canción fue lanzada como el tercer sencillo del álbum el 3 de junio de 2002, donde se transformó en su #24 top 10 en las listas de UK. La canción también fue nominada a los premios Grammy del 2002 en la categoría "Mejor Grabación Bailable, siendo su primera nominación a estos premios. También ganó los premios MTV europeo por "Mejor canción pop" en el 2002.
Esta canción no debe ser relacionada con su anterior canción de Love at First Sight de su álbum debut, Kylie (1988).
La canción y el video musical fueron usados en el 2003 en el videojuego musical Dance Dance Revolution.
En diciembre del 2008, la canción fue posicionada en el #634 por VH1 de Australia en el top 1000 canciones para una fiesta.', v_40, '2 Love at First Sight - Olivia T. Turner (1).pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Diapositiva 1' AND Autor = 'raquel') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Diapositiva 1', 'raquel', NULL, v_42, '_A_la_cama_monstruitos_1_.pdf_filename_= UTF-8_C2_A1A_20la_20cama_20monstruitos_21_20_281_29.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Momoko y la gata' AND Autor = 'Mariko Koike') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Momoko y la gata', 'Mariko Koike', NULL, v_42, '1_5006073911528390860.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El día que se perdió la cordura' AND Autor = 'Javier Castillo') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El día que se perdió la cordura', 'Javier Castillo', NULL, v_42, '1. el dia que se perdio la cordura. javier castillo-1-2-1.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El Arte de la Sexualidad' AND Autor = 'Desconocido') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El Arte de la Sexualidad', 'Desconocido', NULL, v_101, '4_5942536391631046335.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Cuffed' AND Autor = 'Full name') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Cuffed', 'Full name', 'Kaufdorf es una comuna suiza del cantón de Berna, situada en el distrito administrativo de Berna-Mittelland. Limita al norte con la comuna de Toffen, al este con Gelterfingen, al sur con Rümligen, y al oeste con Rüeggisberg.
Hasta el 31 de diciembre de 2009 situada en el distrito de Seftigen.', v_42, '_01 - Cuffed.pdf · versión 1.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Suya, cuerpo y alma - Volumen 4' AND Autor = 'Olivia Dean') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Suya, cuerpo y alma - Volumen 4', 'Olivia Dean', NULL, v_42, '4 - Suya, cuerpo y alma - Olivia Dean.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Pulse' AND Autor = 'Deborah Bladon') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Pulse', 'Deborah Bladon', 'Pulse - Part Three: Jessica wanted to believe Nathan was a changed man. The lust filled promises he made in bed are no match for the reality that she''s now holding in the palm of her hand. Sex drives men like Nathan Moore. She suspected it, then experienced it and now there''s absolutely no denying it. She knows what the right thing to do is. He knows that he''s never met anyone like her. Jessica struggles to forget him as Nathan''s desire for her consumes him. His compulsive need to possess her pushes him in ways that will change them both forever. Just how far is Nathan Moore willing to go to have the one woman he claims he can''t live without?', v_38, '04 Pulse - Deborah Bladon.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Juegos insolentes 5' AND Autor = 'Emma Green') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Juegos insolentes 5', 'Emma Green', NULL, v_42, '0 Juegos_insolentes_5_Emma_Greenc539.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Cinco conceptos propuestos al psicoanÃ¡lisis' AND Autor = 'Jullien, FranÃ§ois(Author)') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Cinco conceptos propuestos al psicoanÃ¡lisis', 'Jullien, FranÃ§ois(Author)', NULL, v_42, '_cinco-conceptos-propuestos-al-psicoanalisis.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '1' AND Autor = 'Mew Rincone') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('1', 'Mew Rincone', NULL, v_42, '2.1 - Una corte de niebla y furia - Capítulo extra.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Elaboración de Inciensos' AND Autor = 'Dorelira') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Elaboración de Inciensos', 'Dorelira', NULL, v_42, '03 - Introducción de Inciensos.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '5 hábitos que ayudan a desarrollar tu mente' AND Autor = 'Autor desconocido') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('5 hábitos que ayudan a desarrollar tu mente', 'Autor desconocido', NULL, v_230, '5  Habitos Que Ayudan a Desarrollar Tu Mente.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Habitos Que Ayudan a Desarrol' AND Autor = 'Silva de Vida') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Habitos Que Ayudan a Desarrol', 'Silva de Vida', 'The world-famous Silva Method has already helped millions to make positive, dynamic changes in their lives. Now you can discover how to enrich your personal and business life in every area, with techniques that will enable you to: "See" answers to seemingly insoluble problems. Rid yourself of fatigue - and turn blahs to pep. Say good-bye to stress - learn to really relax. Communicate more effectively - at work and at home. Conquer loss and fears - triumph over trouble... When you see both hemispheres of your brain, you will get touch with your higher self - which will connect you to an even more powerful creative reality. And as you follow the easy, step-by-step instructions contained in The Silva Mind Method for Getting Help from the Other Side, you will put the powers of your higher intelligence to work - for a fuller, richer, ever more successful life!', v_230, '5 Habitos Que Ayudan a Desarrol - Silva de Vida.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '3 - Ewan' AND Autor = 'Emma Madden') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('3 - Ewan', 'Emma Madden', NULL, v_42, '3 - Ewan - Emma Madden.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Educar sin gritar (Psicologia Y Salud (esfera)) (Spanish Edition)' AND Autor = 'Guillermo Ballenato') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Educar sin gritar (Psicologia Y Salud (esfera)) (Spanish Edition)', 'Guillermo Ballenato', NULL, v_42, '_Educar sin Gritar.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¿Cómo emprender en pareja?... y no matarse en el intento (Spanish Edition)' AND Autor = 'Miriam Gallegos & Roberto Peña') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¿Cómo emprender en pareja?... y no matarse en el intento (Spanish Edition)', 'Miriam Gallegos & Roberto Peña', NULL, v_42, '¿Cómo emprender en pareja y no matarse en el intento.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El libro de los Cuentos Perdidos I' AND Autor = 'J. R. R. Tolkien') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El libro de los Cuentos Perdidos I', 'J. R. R. Tolkien', 'Reedición de la Historia de la Tierra Media. El Libro de los Cuentos perdidos fue la primera gran obra de imaginación de J.R.R. Tolkien, comenzada en 1916-1917, cuando tenía veinticinco años, y abandonada varios años después. Es en realidad el principio de toda la concepción de la Tierra Media y Valinor, y el primer esbozo de los mitos y leyendas que constituirían El Silmarillion. El marco narrativo es el largo viaje hacia el Oeste que emprende un marinero llamado Eriol (Ælfwine) a Tol Eressëa, la isla solitaria donde habitan los Elfos. Allí conoce los Cuentos Perdidos de Elfinesse, en los que aparecen las ideas y concepciones más tempranas sobre los Dioses y los Elfos, los Enanos, los Balrogs y los Orcos, los Silmarils, los dos Árboles de Valinor, Nargothrond y Gondolin, y la geografía y la cosmología de la Tierra Media. El libro de los Cuentos Perdidos se publica en dos volúmenes. El primero contiene los cuentos de Valinor, y el segundo incluye Beren y Lúthien, Túrin y el Dragón, y las historias del Collar de los Enanos y la Caída de Gondolin. Cada cuento es seguido de un comentario —un ensayo breve— , y de algún poema relacionado con el texto, y en cada uno de los volúmenes hay abundante información sobre el vocabulario y los nombres de las primeras lenguas élficas. El Libro de los Cuentos perdidos es el germen de la Tierra Media de Tolkien y de toda su producción literaria.', v_210, '[Historia de la Tierra Media 01]  El libro de los cuentos perdidos I - J. R. R. Tolkien.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El antídoto que nos une' AND Autor = 'Irene Hall') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El antídoto que nos une', 'Irene Hall', NULL, v_42, '(Veneno. 02) El antídoto que nos une - Irene Hall.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¿Qué le pasa a mi cuerpo? Chicas' AND Autor = 'Manuel Díaz') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¿Qué le pasa a mi cuerpo? Chicas', 'Manuel Díaz', NULL, v_42, '¿Qué le pasa a mi cuerpo. Para muchachas(1).pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Justin' AND Autor = 'MACARUBE') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Justin', 'MACARUBE', NULL, v_42, '02. Justin.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Diario de una «chirli»' AND Autor = 'Megan Maxwell') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Diario de una «chirli»', 'Megan Maxwell', 'Eva y Merche son gemelas, y aunque físicamente son dos gotas de agua, en todo lo demás no se parecen en nada. Cuando Merche decide irse de vacaciones con su novio una semana, le pide a su hermana un gran favor: que en su ausencia se haga cargo de su trabajo y de su perra Plufy. Eva, aunque se queda horrorizada ante tal petición, no puede decirle que no... A pesar de que al principio resulta un incordio asumir la identidad de Merche, poco a poco descubrirá que existe algo más aparte de lo que ella había considerado hasta entonces su vida. ¿Quieres divertirte? ¿Quieres reír? Entonces no lo dudes y lee Diario de una chirli.', v_210, '3. Diario de una chirli - Megan Maxwell.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Conservación y resguardo en el servicio del vino' AND Autor = 'CONALEP') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Conservación y resguardo en el servicio del vino', 'CONALEP', NULL, v_2, '04 GuiaConservResgServVino 02.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'H. P. Lovecraft - El misterio del cementerio' AND Autor = 'TOMY') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('H. P. Lovecraft - El misterio del cementerio', 'TOMY', NULL, v_42, '1_5024155560635794123.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Ana de las Tejas Verdes' AND Autor = 'Lucy Maud Montgomery') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Ana de las Tejas Verdes', 'Lucy Maud Montgomery', 'Ana la de Tejas Verdes, Anne la de Tejados Verdes o en inglés Anne of Green Gables es un libro escrito por la canadiense Lucy Maud Montgomery y publicado por primera vez en 1908. En principio se escribió para todas las edades, pero en décadas posteriores se lo consideró un libro para niños. La obra narra la vida de Anne Shirley, una niña huérfana que gracias a su carácter imaginativo y despierto logra encandilar a todos los habitantes de Avonlea, un pequeño pueblo ficticio ubicado en la Isla del Príncipe Eduardo, lugar donde se desarrolla la historia a finales del siglo XIX.
Supuestamente, Montgomery se inspiró en un artículo periodístico sobre el caso de una pareja canadiense que solicitó la adopción de un niño huérfano pero acabaron recibiendo a una niña en su lugar. En lo referido a la Casa de las Tejas Verdes, la escritora quiso homenajear la casa de Green Gables donde vivían sus primos, situada en la Isla del Príncipe Eduardo.​', v_151, '1.-ana_de_las_tejas_verdes.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Invítame a soñar de nuevo 2' AND Autor = 'Noah Evans') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Invítame a soñar de nuevo 2', 'Noah Evans', NULL, v_42, '2 Invitame-a-sonar-de-nuevo-Noah-Evans (1).pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Algunas princesas no buscamos príncipe azul' AND Autor = 'Lina Galán') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Algunas princesas no buscamos príncipe azul', 'Lina Galán', NULL, v_42, '_algunas princesas no.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Tú y yo en la Gran Manzana' AND Autor = 'Estrella Correa') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Tú y yo en la Gran Manzana', 'Estrella Correa', NULL, v_42, '1 Tu y yo en la Gran Manzana - Estrella Correa.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¿Cuentos de princesas o princesas de cuentos? (Spanish Edition)' AND Autor = 'Carolina Ortigosa') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¿Cuentos de princesas o princesas de cuentos? (Spanish Edition)', 'Carolina Ortigosa', NULL, v_42, '_Cuentos de princesas o princesas de cuentos_ (Spanish Edition) - Carolina Ortigosa.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Existe Dios 1.0' AND Autor = 'Peter Eddington') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Existe Dios 1.0', 'Peter Eddington', NULL, v_42, '¿Existe-Dios.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Ghostgirl' AND Autor = 'Serie GhostGirl') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Ghostgirl', 'Serie GhostGirl', 'Ghostgirl es un libro de la autora estadounidense Tonya Hurley, escrito durante 2008 y publicado por primera vez a principios de 2009. Narra la historia de Charlotte Usher, la chica más ignorada en su escuela, quien moría por el chico de sus sueños llamado Damen Dylan hasta que ella murió por culpa de un osito de goma que accidentalmente se le atoró en la garganta. Ghostgirl está compuesta por una trilogía y dos libros más que son sobre festividades.', v_172, '1 GhostGirl - Serie GhostGirl.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Administración del tiempo (La biblioteca del éxito) (Spanish Edition)' AND Autor = 'Brian Tracy') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Administración del tiempo (La biblioteca del éxito) (Spanish Edition)', 'Brian Tracy', NULL, v_42, '1_5010588549221712121.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Viviendo el eneagrama: integrando la sabiduría de la vida' AND Autor = 'María Elena Villaseca') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Viviendo el eneagrama: integrando la sabiduría de la vida', 'María Elena Villaseca', NULL, v_42, '1_5026138577101127896.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El líder que no tenía cargo' AND Autor = 'Robin Sharma') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El líder que no tenía cargo', 'Robin Sharma', NULL, v_42, '_El lider que no tenia cargo-1-1.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Protegida: Romance, Acción y Pasión con el Militar (Novela Romántica y Erótica en Español: Mafia Rusa) (Spanish Edition)' AND Autor = 'Alena Garcia') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Protegida: Romance, Acción y Pasión con el Militar (Novela Romántica y Erótica en Español: Mafia Rusa) (Spanish Edition)', 'Alena Garcia', NULL, v_42, '✩✿Protegida_ Romance, Accion y Pa - Alena Garcia★M🌸.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Double the D' AND Autor = 'Jimena Castillo') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Double the D', 'Jimena Castillo', NULL, v_98, '2. Double the D.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El ?xtasis de Gabriel' AND Autor = 'Sylvain Reynard') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El ?xtasis de Gabriel', 'Sylvain Reynard', NULL, v_42, '_2_El_extasis_de_Gabriel_-_Sylvain_Reynard.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Deseo' AND Autor = 'Adrian Blake') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Deseo', 'Adrian Blake', 'Deseo es el undécimo álbum de estudio de la cantante mexicana Paulina Rubio. Fue lanzado el 14 de septiembre de 2018​ por Universal Spain, marcando su última producción con el sello discográfico Universal Music Group y el primero a siete años de editar Brava! (2011). Colaboró con una multitud de productores y músicos para el disco, entre ellos Mauricio Rengifo, Andrés Torres, los Julca Brothers, Antonio "Toy Selectah" Hernández, Joey Montana, Morat, Nacho, Juan Magán, Xabier San Martin y Alexis & Fido. Deseo es un álbum pop latino con una fuerte vibra del género urbano, aunque mantiene el característico estilo pop rock de la cantante en algunas canciones.
Paulina Rubio empezó a trabajar en un disco inédito a finales de 2014, pero por varias situaciones desconocidas Universal retrasó sus proyectos al grado de publicar sencillos independientes a lo largo de los siguientes dos años. Además, se involucró en su faceta como jueza en diferentes shows de televisión incluyendo la versión mexicana de La Voz, La Voz Kids, la versión estadounidense de The X Factor y La Apuesta.
Inicialmente se lanzaron dos sencillos del álbum: «Desire (Me Tienes Loquita)», una colaboración con Nacho, estrenada el 28 de mayo de 2018, y «Suave y Sutil», lanzada cuatro meses más tarde. El 15 de abril de 2019 se lanzó una edición especial de Deseo que incluía cuatro canciones inéditas, incluyendo el sencillo «Ya No Me Engañas», estrenado solo unos días antes del lanzamiento de la reedición.​ El disco también contiene los sencillos independientes  —lanzados entre 2015 y 2016— «Mi Nuevo Vicio», «Si Te Vas» y «Me Quema».
Tras su lanzamiento, Deseo recibió críticas mixtas por parte de los críticos de música, quienes elogiaron la «energía» de la cantante y su capacidad de adaptarse a los nuevos géneros musicales, pero sintieron que el flujo de las canciones en el disco no tenía ningún sentido ya que la mitad de los temas ya habían sido publicados, por lo que sostuvieron que se trataba más de una «compilación» poco sorprendente. Comercialmente, Deseo tuvo poco impacto en las listas musicales, alcanzando la posición número trece de la lista de Billboard Latin Pop Albums. Pese a ello, obtuvo una certificación de disco de oro en Chile,​ y se embarcó en una gira de conciertos en los Estados Unidos.', v_38, '2.El ultimo deseo - Andrzej Sapkowski.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Secrets' AND Autor = 'Usuario') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Secrets', 'Usuario', NULL, v_42, '01 Secrets - H.M. Ward.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '5026138577101127904' AND Autor = 'Desconocido') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('5026138577101127904', 'Desconocido', NULL, v_42, '1_5026138577101127904.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Niebla en Withechapel' AND Autor = 'Cutis Garland') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Niebla en Withechapel', 'Cutis Garland', NULL, v_42, '✮Terror 15 - Garland, Cutis - Niebla en Withechapel.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'My Father_s Rival' AND Autor = 'Desconocido') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('My Father_s Rival', 'Desconocido', NULL, v_42, '1. My Father_s Rival.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Sutil persuasión' AND Autor = 'Nerea Vara') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Sutil persuasión', 'Nerea Vara', NULL, v_42, '_2.Sutil•Persuasión(M.M.)-Nerea_Vara.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '1. Mia Esta Noche - Scott J. S.' AND Autor = 'Carmen') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('1. Mia Esta Noche - Scott J. S.', 'Carmen', NULL, v_42, '1.Mía Esta Noche 1 - J. S. Scott.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'el-codigo-de-las-mentes-extraordinarias-jkhpdf' AND Autor = 'Desconocido') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('el-codigo-de-las-mentes-extraordinarias-jkhpdf', 'Desconocido', NULL, v_42, '_el-codigo-de-las-mentes-extraordinarias-jkhpdf-1.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'It' AND Autor = 'Stephen King') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('It', 'Stephen King', NULL, v_42, '_2017-Stephen_King-It.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'de Velas Artesanales' AND Autor = 'Dorelira') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('de Velas Artesanales', 'Dorelira', NULL, v_42, '05 -Elaboración de Velas-01.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '5150082197868249240' AND Autor = 'Desconocido') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('5150082197868249240', 'Desconocido', NULL, v_42, '1_5150082197868249240.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El buque del horror' AND Autor = 'Silver Kane') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El buque del horror', 'Silver Kane', NULL, v_42, '✮Terror 04 - Kane, Silver - El buque del horror.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '01' AND Autor = 'juan yañez nava') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('01', 'juan yañez nava', NULL, v_42, '0.01 - Dark Craving.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Introducción' AND Autor = 'ZOILO') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Introducción', 'ZOILO', 'En un ensayo, artículo o libro, la introducción es una sección inicial cuyo propósito principal es contextualizar el texto fuente o reseñado y que está expuesto a continuación, en general en forma de cuerpo o desarrollo del tema, y posteriormente conclusiones.​
En la introducción normalmente se escribe el tema del documento, y se ofrece un breve resumen del mismo. También puede explicar algunos antecedentes que se consideren importantes para el posterior desarrollo del tema central. Un lector al leer la introducción debería poder hacerse una idea sobre el contenido del texto, antes de comenzar su lectura propiamente dicha.', v_42, '1_5059811468594118960.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Desgarrada: Parte Tres (Spanish Edition)' AND Autor = 'Sky Corgan') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Desgarrada: Parte Tres (Spanish Edition)', 'Sky Corgan', NULL, v_42, '3 - Desgarrada.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Novio Alquilado' AND Autor = 'Desconocido') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Novio Alquilado', 'Desconocido', 'Después de un divorcio que acabó con su confianza e interés por los hombres, María Paula intenta recoger los pedazos de vida que dejó tras de sí su ex. Pero, cuando este le avisa que volverá para vender parte del negocio que tienen en común, peor aún, cuando le comunica que regresará felizmente casado, María Paula suda frío. Ella necesita demostrar que sí pudo superarlo. Ella, debe enseñarle que ahora es una empresaria exitosa y que también tiene a alguien en su vida. El problema, es que no tiene a nadie, y lo tendrá que contratar. ¿Quién necesita un novio real cuando se puede tener uno por alquiler?', v_210, '02Novio Alquilado.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El misterio del rodaje' AND Autor = 'Margotte Channing') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El misterio del rodaje', 'Margotte Channing', NULL, v_42, '4.El misterio del rodaje-Serie De Germán Cortéz e Isabel Martín_Margotte Channing.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Sofa King Hard' AND Autor = 'dcvillacortes@outlook.es') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Sofa King Hard', 'dcvillacortes@outlook.es', NULL, v_42, '1. Sofa King Hard.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Acerca del alma' AND Autor = 'Aristóteles') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Acerca del alma', 'Aristóteles', 'Acerca del alma o Sobre el alma (griego Περὶ Ψυχῆς, Peri Psychēs; latín De Anima; abr.: De an)​ es un importante tratado escrito por Aristóteles alrededor del 350 a. C.​ Aunque su tema es el alma, se puede describir como una biopsicología: una descripción del tema de la psicología dentro de un marco biológico.​​ Su discusión se centra en los tipos de almas que poseen los diferentes tipos de seres vivos, que se distinguen por sus diferentes operaciones. Por lo tanto, las plantas tienen la capacidad de alimentarse y reproducirse, el mínimo que debe poseer cualquier tipo de organismo vivo. Los animales inferiores tienen, además, los poderes de percepción sensorial y movimiento propio (acción). Los humanos tienen todo esto así como también el intelecto.
Aristóteles sostiene que el alma (psique, ψυχή) es la forma o esencia de cualquier cosa viviente; no es una sustancia distinta del cuerpo en el que está. Es la posesión de un alma (de un tipo específico) lo que hace que un organismo sea un organismo, y por lo tanto la noción de un cuerpo sin alma, o de un alma en el tipo equivocado de cuerpo, es simplemente ininteligible. (Argumenta que algunas partes del alma, el intelecto, pueden existir sin el cuerpo, pero la mayoría no puede). Es difícil reconciliar estos puntos con la imagen popular de un alma como una especie de sustancia espiritual que "habita" en un cuerpo. Algunos comentaristas han sugerido que el término alma de Aristóteles se traduce mejor como fuerza vital.[¿quién?]
En 1855, Charles Collier publicó una traducción titulada Sobre el principio vital (On the Vital Principle). George Henry Lewes, sin embargo, encontró esta descripción también deficiente.​', v_182, '_Biblioteca_Clasica_Gredos_014_Aristoteles_-_Acerc.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Adicta a mi hermanastro' AND Autor = 'Irene Díaz') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Adicta a mi hermanastro', 'Irene Díaz', NULL, v_42, '02-Adicta_a_mi_hermanastro.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Manual Del Futuro Millonario' AND Autor = 'Usuario') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Manual Del Futuro Millonario', 'Usuario', NULL, v_42, ',   Manual del Futuro Millonario-1.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Las muertes concéntricas' AND Autor = 'Jack London') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Las muertes concéntricas', 'Jack London', NULL, v_42, '01 Jack London - Las muertes concéntricas .pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'PNL para el éxito: Cómo persuadir, influenciar y tener éxito usando patrones de lenguaje y técnicas de PNL (Spanish Edition)' AND Autor = 'Ediciones, Áurea & Wolf, Adam') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('PNL para el éxito: Cómo persuadir, influenciar y tener éxito usando patrones de lenguaje y técnicas de PNL (Spanish Edition)', 'Ediciones, Áurea & Wolf, Adam', NULL, v_42, '1_4972512659120324912.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Ethan' AND Autor = 'Diana Palmer') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Ethan', 'Diana Palmer', NULL, v_57, '05. Ethan.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Amor, te quiero' AND Autor = 'Elsa Jenner') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Amor, te quiero', 'Elsa Jenner', NULL, v_42, '2. AMOR, TE QUIERO - TRILOGÍA A BORDO II - Elsa Jenner.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El mundo tal como va' AND Autor = 'Voltaire') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El mundo tal como va', 'Voltaire', NULL, v_42, '1_5024155560635794126.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'LA PRINCESA EN EL PARAISO' AND Autor = 'Desconocido') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('LA PRINCESA EN EL PARAISO', 'Desconocido', NULL, v_42, '1_5059811468594118981.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Te protegeré siempre' AND Autor = 'Vega Manhattan') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Te protegeré siempre', 'Vega Manhattan', NULL, v_42, '4 Te protegere siempre - Vega Manhattan.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El rey lobo' AND Autor = 'Alice Borchardt') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El rey lobo', 'Alice Borchardt', NULL, v_42, '(Trilogia de Roma 03) El rey lobo.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¿Qué hacer con un hijo adicto?' AND Autor = 'José Arturo Luna') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¿Qué hacer con un hijo adicto?', 'José Arturo Luna', NULL, v_42, '¿Qué hacer un con un hijo adicto.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¿Te acuerdas de McKenna?' AND Autor = 'María Ferrer Payeras') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¿Te acuerdas de McKenna?', 'María Ferrer Payeras', NULL, v_42, '_Te acuerdas de McKenna_ - Maria Ferrer Payeras.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'La matÃ© porque era mÃ­a: psicobiologÃ­a de la ira, de la violencia y la agresividad, y de la sexualidad' AND Autor = 'MuntanÃ©, M. D. (CB)') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('La matÃ© porque era mÃ­a: psicobiologÃ­a de la ira, de la violencia y la agresividad, y de la sexualidad', 'MuntanÃ©, M. D. (CB)', NULL, v_42, '__La Maté porque era Mía - Psicobiologia de la ira, de la violencia y la agresividad y de la sexualidad.pdf · versión 1.pdf.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Sra. Maddox - Jamie McGuire' AND Autor = 'MoreBTT') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Sra. Maddox - Jamie McGuire', 'MoreBTT', NULL, v_42, '1.5- Sra. Maddox - Jamie McGuire.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¿Qué es la hermenéutica?' AND Autor = 'Jean Grondin') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¿Qué es la hermenéutica?', 'Jean Grondin', NULL, v_42, '_Que es la hermeneutica_ - Jean Grondin.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Hack' AND Autor = 'yeimi paola de avila vanegas') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Hack', 'yeimi paola de avila vanegas', NULL, v_42, '4. Hack.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Brawn' AND Autor = 'Nuevas Especies') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Brawn', 'Nuevas Especies', NULL, v_42, '5- Brawn - Nuevas Especies.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Jornadas de Sodoma.doc' AND Autor = 'dhc') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Jornadas de Sodoma.doc', 'dhc', NULL, v_42, '1 Los 120 días de Sodoma autor Marqués de Sade.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Una criminal liberada' AND Autor = 'Kris Buendia') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Una criminal liberada', 'Kris Buendia', NULL, v_42, '2. Una Criminal Liberada.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Brujaverde' AND Autor = 'Susan Cooper') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Brujaverde', 'Susan Cooper', NULL, v_42, '03 Brujaverde.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Capítulo 1' AND Autor = 'ROSA') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Capítulo 1', 'ROSA', 'Capítulo 1 (también conocido como K y B. Capitulo 1) es el primer extended play de los raperos hispano-marroquí Morad y Beny Jr lanzado el 1 de abril de 2022 y distribuido por Altafonte Network. El proyecto cuenta con éxitos como «Vuelve», «Que dirá», «Cómo es?», entre otros.​', v_157, '06. Connal.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Doce cuentos peregrinos' AND Autor = 'Gabriel García Márquez') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Doce cuentos peregrinos', 'Gabriel García Márquez', 'Los doce cuentos de este libro fueron escritos em el curso de los últimos dieciocho años. Antes de su forma actual, cinco de ellos periodísticas y guiones de cine, y uno fue un serial de televisión. Otro lo conté hace quince años en una entrevista grabada , y el amigo a quien se lo conté lo trancribió y lo publicó, y ahora lo he vuelto a escribir a partir de esa versión. Ha sido uma rara experiencia creativa que merece ser explicada, aunque sea para que los niños que quieren ser escritores cuando sean grandes sepan desde ahora qué insaciable y abrasivo es el vicio de escribir.', v_215, '.Doce cuentos peregrinos - Gabriel Garcia Marquez.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'The Stefans Diaries Blood lust' AND Autor = 'Loraine Perea') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('The Stefans Diaries Blood lust', 'Loraine Perea', NULL, v_42, '2 - The Stefans Diaries Blood lust - Lisa Jane Smith.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El modelo de Pickman' AND Autor = 'kr0n0') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El modelo de Pickman', 'kr0n0', 'El modelo de Pickman (Pickman''s Model en inglés) es un relato corto escrito en 1926 por H. P. Lovecraft.', v_129, '1_5024155560635794124.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Dungeon ni Deai wo Motomeru no wa Machigatteiru Darou ka' AND Autor = 'carlos') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Dungeon ni Deai wo Motomeru no wa Machigatteiru Darou ka', 'carlos', 'Dungeon ni Deai o Motomeru no wa Machigatteiru Darō ka (ダンジョンに出会いを求めるのは間違っているだろうか, lit. ¿Está mal querer tener un encuentro en una mazmorra??), también conocido como ¿Está mal seducir chicas en un calabozo? o  ¿Qué tiene de malo intentar ligar en una mazmorra? y varias veces abreviado como DanMachi (ダンまち, ''''DanMachi''''?), es una serie de novelas ligeras escritas por Fujino Ōmori e ilustradas por Suzuhito Yasuda. SB Creative ha publicado veintiuno volúmenes desde enero de 2013 bajo el sello de GA Bunko. Ha recibido una serie de spin-offs de la novela ligera y tres adaptaciones al manga. Una adaptación al anime, a cargo del estudio J.C.Staff, salió al aire desde el 4 de abril hasta el 27 de junio de 2015.
Ha sido la novela ligera más votada por los fanes en los premios Sugoi Japan Awards de la edición de 2016. En estos premios, los fanáticos deciden qué anime, manga, novela es la más indicada para ser comercializada en el mercado internacional.​', v_135, '[K-VT] Dungeon Vol. 03.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Cathedral' AND Autor = 'Windows User') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Cathedral', 'Windows User', 'Una catedral, también llamada seo, es un templo cristiano en donde tiene su sede o cátedra el obispo de la diócesis; por tanto, es la iglesia principal o mayor de cada diócesis o iglesia particular. La sede o cátedra episcopal es el lugar desde donde cada obispo preside la comunidad cristiana, enseñando el contenido de la fe y la doctrina de la Iglesia. También administra determinados sacramentos y órdenes. La sede o cátedra simboliza la función de gobierno del obispo.
La Iglesia cristiana ortodoxa se refiere a sus catedrales como gran iglesia, aunque suele traducirse como catedral.
Los edificios eclesiásticos que encarnan las funciones de una catedral aparecieron por primera vez en Italia, Galia, España y el norte de África en el siglo IV, pero las catedrales no se universalizaron dentro de la Iglesia católica occidental hasta el siglo XII, momento en el que ya habían desarrollado formas arquitectónicas, estructuras institucionales e identidades jurídicas distintas de las iglesias parroquiales, las iglesias monásticas y las residencias episcopales. La catedral es más importante en la jerarquía que la iglesia porque es desde la catedral que el obispo gobierna el área bajo su autoridad administrativa.​​​
Tras la Reforma Protestante, la Iglesia cristiana de varias partes de Europa occidental, como la Escocia, la Países Bajos, algunos Cantones suizos y partes de Alemania, adoptaron un sistema de gobierno presbiteriano que suprimía totalmente a los obispos. En los casos en los que los antiguos edificios catedralicios de estas tierras siguen utilizándose para el culto congregacional, generalmente conservan el título y la dignidad de "catedral", manteniendo y desarrollando funciones catedralicias diferenciadas, pero sin supremacía jerárquica. A partir del siglo XVI, pero especialmente desde el siglo XIX, las iglesias originarias de Europa Occidental han emprendido vigorosos programas de actividad misionera, que han dado lugar a la fundación de un gran número de nuevas diócesis con establecimientos catedralicios asociados de diversas formas en Asia, África, Australasia, Oceanía y América. Además, tanto la Iglesia católica como la Ortodoxa han formado nuevas diócesis en tierras anteriormente protestantes para los conversos y correligionarios emigrantes. En consecuencia, no es raro encontrar cristianos en una misma ciudad atendidos por tres o más catedrales de distintas denominaciones.', v_42, '1 Cathedral.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Ella es tu destino' AND Autor = 'Megan Maxwell') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Ella es tu destino', 'Megan Maxwell', 'Lidia es una caza-recompensas que, junto a su inseparable dragón Dracela y su fiel amigo Gaúl, ha hecho de su vida una aventura. Esta forma de vida le permite seguir con su particular misión que no es otra que encontrar a Dimas Deceus y vengar la muerte de su familia. Su último encargo: capturar al ladrón Bruno Mezzia, fugado hace pocos días. Tras capturar a Bruno (apuesto y fuerte) y mientras lo trasladan para su entrega, encuentran en su camino a Penélope Barmey en busca de ayuda para rescatar a su marido y, a cambio de su apoyo, les ofrece una llave élfica, pieza clave para vencer los peligros que les esperan en su camino y que facilitará que Lidia llegue hasta Dimas Deceus y culmine su venganza. Estos acontecimientos les obligarán a posponer la entrega de Bruno. El camino que recorrerán hará que poco a poco Lidia se fije en Bruno y éste en ella, a pesar de que la guerrera intente esconder sus sentimientos mostrándose fría y ruda. Mientras Gaúl se dará cuenta de que el hermano del terrateniente que les ha hecho el encargo no ha dicho toda la verdad. Bruno no es un ladrón. Una aventura que te llevará por tierras fantásticas de la mano de unos personajes que te llegarán al corazón.', v_210, '4. Ella es tu destino - Megan Maxwell.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Socorro!' AND Autor = 'Jacinta') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Socorro!', 'Jacinta', 'Send Help es una película estadounidense de suspenso y terror de supervivencia de 2026​ coproducida y dirigida por Sam Raimi y escrita por Damian Shannon y Mark Swift. La película está protagonizada por Rachel McAdams y Dylan O''Brien, quienes interpretan a una empleada y su jefe, respectivamente, quienes quedan varados en una isla desierta tras un accidente aéreo e intentan sobrevivir mientras la tensión aumenta entre ellos. Edyll Ismail, Xavier Samuel, Chris Pang y Dennis Haysbert también aparecen.
Send Help se estrenó en el Teatro Chino TCL en Los Ángeles, California, el 21 de enero de 2026, y fue estrenada en Estados Unidos por 20th Century Studios el 30 de enero. La película recibió críticas positivas de los críticos y recaudó $94,0 millones contra un presupuesto de producción de $40 millones.​​', v_110, '¡Socorro!.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Erotica: Romantica - Al Borde de la PASIÓN (Romance de un Millonario 4 "Romantica Erotica") (Spanish Edition)' AND Autor = 'Kimberly J. & Michelle L.') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Erotica: Romantica - Al Borde de la PASIÓN (Romance de un Millonario 4 "Romantica Erotica") (Spanish Edition)', 'Kimberly J. & Michelle L.', NULL, v_42, '4. Al Borde de la Pasión.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '6 Pequeñas historias de sexo para todos' AND Autor = 'Baby Pink') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('6 Pequeñas historias de sexo para todos', 'Baby Pink', NULL, v_42, '6 Pequeñas historias de sexo para todos- Baby Pink.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '6 relatos ejemplares 6' AND Autor = 'María Elvira Roca Barea') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('6 relatos ejemplares 6', 'María Elvira Roca Barea', NULL, v_42, '6 relatos ejemplares 6 - Maria Elvira Roca Barea.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Vacaciones... ¡menudo desmadre!' AND Autor = 'Sarah Rusell') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Vacaciones... ¡menudo desmadre!', 'Sarah Rusell', NULL, v_42, '2 Vacaciones_. !menudo desmadre! - Sarah Rusell (1).pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Los renglones torcidos de Dios' AND Autor = 'Torcuato Luca de Tena') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Los renglones torcidos de Dios', 'Torcuato Luca de Tena', 'Los renglones torcidos de Dios es una película mexicana de 1983 dirigida por Tulio Demicheli y basada en el libro homónimo de Torcuato Luca de Tena.
Su estreno se realizó el 29 de septiembre de 1983.
Fue filmada en diferentes lugares del estado mexicano de Morelos.​ Entre otros, en la ciudad de Cuautla, la Hacienda de Atlihuayan en Oaxtepec y en el pueblo de Yautepec de Zaragoza.
La historia se centra en la detective Alicia Gould, interpretada por Lucía Méndez, que siguiendo la pista de asesinato del padre del doctor García del Olmo, su cliente, decide internarse de manera encubierta en un manicomio. Las influencias del cine de Juan López Moctezuma, en especial de La mansión de la locura, y de los filmes anglosajones La naranja mecánica y La mujer pantera son fuertes.
El nombre de la protagonista, Alicia hace referencia a la novela de Lewis Carroll, Alicia en el País de las Maravillas. El título de la película hace referencia a la condición de los pacientes del lugar, en oposición a la supuesta rectitud de la condición mental de Alicia. Esto se hace explícito en una carta que Ignacio le escribe a Alicia donde le dice:', v_217, '.pdf los renglones torcidod.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'H. P. Lovecraft - El horror en el cementerio' AND Autor = 'TOMY') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('H. P. Lovecraft - El horror en el cementerio', 'TOMY', NULL, v_42, '1_5024155560635794112.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'La villa de las telas' AND Autor = 'Anne Jacobs') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('La villa de las telas', 'Anne Jacobs', 'La villa de las telas abre de nuevo sus puertas. Llega la esperada cuarta parte de la saga superventas de Anne Jacobs. Una magnífica mansion Una época turbulenta Un amor que puede vencerlo todo... Augsburgo, 1930. Marie y Paul Melzer son felices y su amor es más fuerte que nunca. Su hijo menor, el pequeño Kurti, que ahora tiene cuatro años, es un rayo de sol que se gana el afecto de todo el mundo y los gemelos Dodo y Leo han crecido espléndidamente. Dodo ha descubierto su amor por la técnica y sueña con convertirse en aviadora, mientras que Leo demuestra un gran talento para el piano, que se ha convertido en su gran pasión. Pero la villa no es ajena a la agitada situación política en Alemania y la crisis económica golpea con fuerza el negocio familiar. Los Melzer tienen importantes deudas y Marie deberá enfrentarse a dolorosas decisiones para evitar la ruina. El destino de la familia está en juego. Y su amada villa de las telas solo podrá salvarse si todos permanecen unidos. Sobre los libros de la saga han dicho: «Amor imposible y las rígidas normas sociales de la Europa central a principios del siglo XX serán el escenario en el que se desenvuelva esta entretenida historia llena de secretos». Jorge Pato García, El Imparcial «Es una gran historia de amor, con tintes dramáticos y secretos familiares, que nos ha gustado tanto por su calidad literaria como por su preciosismo histórico». Revista Kritica «Downton Abbey en Augsburgo». Histo-couch «Este libro lo tiene todo, todo que podríamos desear para un día de lluvia: una gran historia de amor, intriga [...] y un gran secreto familiar». Delmenhorster Kreisblatt «Con su escritura fluida, Anne Jacobs sabe cómo seducir a sus lectoras y transportarlas a la vida de la alta sociedad de hace cien años con todo su glamour pero también con sus sombras». Weilheimer Tagblatt Los lectores opinan: «A todos los que os gustan las sagas familiares estos libros os van a encantar. De esos libros que tiene un ritmo muy bueno en todo momento, no decae para nada y hace su lectura muy agradable». Blog Leyendo entre páginas «Una historia de familias, de amor, de superación personal y de valentía. Pero de una valentía que no sabes que tienes hasta que la necesitas». Blog Viajando gracias a los libros «Si echáis de menos Downton Abbey (yo la echo de menos casi a diario) esta saga llenará ese hueco por completo». labibliotecadelaabuela en Instagram « Regreso a la Villa de las telas ha sido la vuelta a uno de mis lugares favoritos de la literatura». Patricia Llamas para Sigue en serie', v_54, '^ La villa de las telas - Anne Jacobs(1).pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'ro. El Nuevo Orden Mundial' AND Autor = 'Desconocido') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('ro. El Nuevo Orden Mundial', 'Desconocido', 'La reconfiguración del mundo tras las guerras en Ucrania y Medio Oriente En dos años, el mundo ha cambiado de un modo que tardaremos décadas en entender. La invasión rusa a Ucrania y las matanzas en Gaza han provocado una serie de transformaciones a escala planetaria con infinidad de repercusiones: ya cambió el peso político y económico de Estados Unidos y China, se renovó el protagonismo de Moscú y su eje de influencia, se desató una carrera armamentista, el populismo se fortaleció y los balances de poder en Latinoamérica se han transfigurado. Incluso el boom de la inteligencia artificial debe leerse en clave de los grandes choques sociopolíticos que hoy vivimos. ¿Qué explica esta revolución? ¿Qué dinámicas estaba transitando el mundo que terminaron en esto? ¿Qué sigue y cómo nos preparamos para ello? En esta obra, contundente y lúcida, el economista Manuel Hinds nos presenta un panorama que trae luz a la complejidad que estamos atravesando, nos detalla los hitos que nos llevaron a esta encrucijada y nos hace ver los grandes riesgos que nos acechan. ENGLISH DESCRIPTION How the wars in Ukraine and the Middle East are reshaping the world. In the last two years, the world has changed in ways it will take us decades to understand. Russia''s invasion of Ukraine and the tragedy in Gaza have wrought a series of transformations on a global scale, with potentially infinite repercussions: shifting political and economic roles for the United States and China, an expanded sphere of influence for Russia, a renewed arms race, a resurgence in populism, and a new balance of power in Latin America. Even the artificial intelligence boom should be read in the context of the world''s current sociopolitical conflicts. How can we explain this revolution? What underlying dynamics were in place that led to this? What comes next, and how should we prepare? Economist Manuel Hinds offers this lucid and illuminating clarification of the complex phenomena affecting the world today, the events that brought us to this point, and the challenges still to come.', v_121, '1ro. El Nuevo Orden Mundial.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¿Es Dios un matemático?' AND Autor = 'Mario Livio') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¿Es Dios un matemático?', 'Mario Livio', '¿Son las matemáticas una creación humana? ¿O lo que aparece a través de ellas es el intrincado diseño del universo, que poco a poco vamos descubriendo? Desde la Antigüedad hasta el presente, científicos y filósofos se han maravillado de que una disciplina tan abstracta pudiera explicar de manera tan perfecta el mundo natural. Mario Livio explora brillantemente las ideas matemáticas desde Pitágoras hasta el siglo xxi y nos muestra cómo las más enigmáticas preguntas y las más ingeniosas respuestas nos han llevado a entender mejor el mundo que nos rodea. Este fascinante libro interesará a cualquier persona que sienta curiosidad por la mente humana y la ciencia. «Los lectores habituales de Mario Livio disfrutarán de este libro, y los recién llegados lo descubrirán», Publishers Weekly. «Una fascinante inmersión en las premisas que fundamentan las matemáticas», Booklist.', v_11, '_Es Dios un matematico_ - Mario Livio.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Atrápame' AND Autor = 'Anna Zaires') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Atrápame', 'Anna Zaires', '—Yulia —susurra mirándome y sé que siente también esta atracción, esta conexión tan visceral entre nosotros. Quizás tenga todo el poder, pero, en este momento, es tan vulnerable como yo, atrapado en la misma locura. Obligada a unirse a una agencia secreta de inteligencia a una edad muy temprana, la espía e intérprete rusa Yulia Tzakova no es ajena a los hombres peligrosos. Pero nunca ha conocido a uno tan despiadado y cautivador como Lucas Kent. El mercenario de carácter impetuoso la asusta, pero se siente atraída por él, por un hombre al que no tiene más remedio que traicionar. Lucas Kent es la mano derecha de un poderoso traficante de armas y nunca ha conocido a una mujer a la que desee tanto como a Yulia. Está obsesionado con esa preciosa rubia, por lo que no se detendrá ante nada para atraparla y hacerle pagar su traición. Desde las calles gélidas de Moscú hasta la jungla húmeda de Colombia, esta oscura pasión cautivadora los destruirá o los hará libres. ***** «Una montaña rusa perfecta y oscura de acción sobrecogedora y romance abrasador» —Skye Warren, autora superventas del New York Times. «Candente, cautivadora y trepidante» —Josie Litton, autora superventas del New York Times. ***** Más de 60 reseñas de 5 estrellas entre todos los libros. Esto es lo que dicen los lectores: · «Intensa, oscura, erótica, magnética, cautivadora, enigmática, apasionante y muy intrigante». · «…página tras página de anhelo y necesidad, de peligro, de más anhelo, de más peligro. Luego, culminación erótica, más necesidad. Después, dicha romántica y, de nuevo (¡aaahhh!), ¡MÁS PELIGRO! He disfrutado cada minuto leyéndola». · «La intensidad entre Yulia y Lucas era electrizante y trágica de la mejor manera posible». · «Anna Zaires ha creado una nueva obra de arte. Nunca me canso de leer sus relatos. Lucas es otro de sus héroes oscuros, me ha atrapado el corazón desde el principio y esta trilogía siempre será una de las mejores historias románticas y tenebrosas que he leído». · «…el tipo de colecciones que siempre tendrá un hueco en mi corazón». Este práctico paquete rebajado contiene los tres libros de la serie Atrápame: Atrápame, Átame y Tómame.', v_188, '1 Atrapame - Anna Zaires.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Besos prohibidos' AND Autor = 'Kathia Iblis') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Besos prohibidos', 'Kathia Iblis', 'Llega la sexta entrega de la serie «El corazón de un libertino» de Kathia Iblis. Su destino no era conocerse, menos aún amarse... La señorita Periwinkle Talbot tiene una sola misión en esta nueva temporada: lograr atrapar un partido adecuado que la ayude a mantener a sus hermanas y su hogar ancestral a salvo de su malvada abuela. Cuando misteriosos aliados intervienen para ayudarla a lograr su cometido lo último que espera es terminar conociendo al único hombre capaz de hacer tambalear su decisión de un matrimonio sin amor. ¿Podra ella dejarlo ir y olvidarlo para siempre? Aidan Ó Faoláin, criado en la calle, un sobreviviente, un hombre sin rango, de repente se encuentra a cargo de una misión que jamás creyó aceptar: asistir a una dama en su mayor momento de necesidad. Pero cuando sus consejos y estratagemas comiencen a tener el éxito deseado, ¿podrá dejarla ir a los brazos de otro hombre? ¿Podrán sus besos dejar de ser prohibidos?', v_210, '6 Besos prohibidos - Kathia Iblis.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Leyes de Atracción' AND Autor = 'Desconocido') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Leyes de Atracción', 'Desconocido', 'Sentando las reglas. La abogada Olivia Brannigan estaba acostumbrada a tratar con clientes impasibles, pero Blake Clayton era un auténtico maestro en el arte de ocultar sus sentimientos: ni siquiera pestañeó al enterarse de que había heredado una fortuna del padre al que no había visto en años. Blake no quería un dinero que no creía merecer, pero estaba francamente interesado en la guapa abogada encargada de su nueva cartera de propiedades. Olivia, por su parte, nunca mezclaba el trabajo con el placer. Hasta que algo le hizo plantearse que las normas, al fin y al cabo, estaban para romperse...', v_210, '01Leyes de Atracción.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'ALFAJORES Y GALLETAS' AND Autor = 'Desconocido') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('ALFAJORES Y GALLETAS', 'Desconocido', NULL, v_42, '_ALFAJORES Y GALLETAS.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'La villa de las telas' AND Autor = 'Anne Jacobs') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('La villa de las telas', 'Anne Jacobs', 'La villa de las telas abre de nuevo sus puertas. Llega la esperada cuarta parte de la saga superventas de Anne Jacobs. Una magnífica mansion Una época turbulenta Un amor que puede vencerlo todo... Augsburgo, 1930. Marie y Paul Melzer son felices y su amor es más fuerte que nunca. Su hijo menor, el pequeño Kurti, que ahora tiene cuatro años, es un rayo de sol que se gana el afecto de todo el mundo y los gemelos Dodo y Leo han crecido espléndidamente. Dodo ha descubierto su amor por la técnica y sueña con convertirse en aviadora, mientras que Leo demuestra un gran talento para el piano, que se ha convertido en su gran pasión. Pero la villa no es ajena a la agitada situación política en Alemania y la crisis económica golpea con fuerza el negocio familiar. Los Melzer tienen importantes deudas y Marie deberá enfrentarse a dolorosas decisiones para evitar la ruina. El destino de la familia está en juego. Y su amada villa de las telas solo podrá salvarse si todos permanecen unidos. Sobre los libros de la saga han dicho: «Amor imposible y las rígidas normas sociales de la Europa central a principios del siglo XX serán el escenario en el que se desenvuelva esta entretenida historia llena de secretos». Jorge Pato García, El Imparcial «Es una gran historia de amor, con tintes dramáticos y secretos familiares, que nos ha gustado tanto por su calidad literaria como por su preciosismo histórico». Revista Kritica «Downton Abbey en Augsburgo». Histo-couch «Este libro lo tiene todo, todo que podríamos desear para un día de lluvia: una gran historia de amor, intriga [...] y un gran secreto familiar». Delmenhorster Kreisblatt «Con su escritura fluida, Anne Jacobs sabe cómo seducir a sus lectoras y transportarlas a la vida de la alta sociedad de hace cien años con todo su glamour pero también con sus sombras». Weilheimer Tagblatt Los lectores opinan: «A todos los que os gustan las sagas familiares estos libros os van a encantar. De esos libros que tiene un ritmo muy bueno en todo momento, no decae para nada y hace su lectura muy agradable». Blog Leyendo entre páginas «Una historia de familias, de amor, de superación personal y de valentía. Pero de una valentía que no sabes que tienes hasta que la necesitas». Blog Viajando gracias a los libros «Si echáis de menos Downton Abbey (yo la echo de menos casi a diario) esta saga llenará ese hueco por completo». labibliotecadelaabuela en Instagram « Regreso a la Villa de las telas ha sido la vuelta a uno de mis lugares favoritos de la literatura». Patricia Llamas para Sigue en serie', v_54, '^ Las hijas d la Villa de las Telas - Anne Jacobs.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Drawing hands style ;v' AND Autor = 'Desconocido') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Drawing hands style ;v', 'Desconocido', NULL, v_171, '▪︎Dibujar Manos y Dedos.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Apocalipsis Maya' AND Autor = 'Steve Alten - Edmundo Capmartin') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Apocalipsis Maya', 'Steve Alten - Edmundo Capmartin', NULL, v_42, '__Apocalipsis Maya__ de Alten, Steve.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¿Amar o depender?' AND Autor = 'Walter Riso') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¿Amar o depender?', 'Walter Riso', '“Aunque la psicología ha avanzado en el tema de las adicciones, en el tema de la adicción afectiva el vacío es innegable Este libro está dirigido a todas aquellas personas que quieren hacer del amor una experiencia plena, alegre y saludable”. —Walter Riso Entregarse afectivamente no implica desaparecer sino integrarse en el otro. El amor sano es una suma de dos en la que nadie pierde. Sin embargo, millones de personas en todo el mundo son víctimas de relaciones amorosas inadecuadas y no saben qué hacer al respecto, ya que el miedo a la pérdida, a la soledad o al abandono contamina el vínculo amoroso y lo vuelve altamente vulnerable. Un amor inseguro es una bomba que puede estallar en cualquier momento y lastimarnos profundamente. En ¿Amar o depender?, Walter Riso, uno de los más conocidos autores de autoayuda, nos enseña que sí es posible vivir con independencia y aun así seguir amando, eliminando las ataduras psicológicas y manteniendo vivo el fuego del amor. La adicción afectiva es una enfermedad que tiene cura y, lo más importante, puede prevenirse. Este revelador libro pretende ayudar a aquellas personas que son o han sido víctimas de un amor malsano y guiar a las parejas sanas para que sigan trabajando en la costumbre de amar intensamente y sin apegos.', v_125, '_Amar o depender_ - Walter Riso (6).pdf-1-1.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'No eres tú, soy yo' AND Autor = 'Daniel De la Peña') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('No eres tú, soy yo', 'Daniel De la Peña', 'Amor, enredos y unos personajes muy divertidos en esta primera entrega de la bilogía «Tal para cual» de Daniel de la Peña. Y es que los momentos de crisis pueden ser los más creativos, ¡incluso en el amor! Mimi es una joven que cree en el amor cursi, repipi y hortera. Ese que está harta de ver en los cuentos de hadas y que jamás ha tocado ni de lejos. Su realidad es muy distinta; acaba de arruinarse gracias al fracaso de su agencia de adopción de pingüinos, no tiene novio y se ha quedado sin piso. Su mejor amiga, Daniela, una abogada experta en divorcios que no cree en el amor, la acoge en su casa. Una noche cuando asiste a una clase nocturna, conocerá a Héctor, un atractivo profesor por el que sentirá una conexión sexual muy fuerte y se experimentará un apasionado romance. Por si fuera poco, comenzará a sentir algo nuevo e intenso por Marín, su mejor amigo, con el que ha pasado momentos inolvidables compartiendo confesiones, criticando a sus respectivos ex, tomando cervezas... Tendrá que decidir si ignorar sus sentimientos para no peligrar su relación de amistad o atreverse a declarar su amor por Marín. Mientras tanto creará una aplicación para que la gente conozca a su media naranja llamada TalparaCual . Las divertidas quedadas con Carmen, su madre, y Daniela y las bebidas con misterio de las que serán adictas, animarán a la protagonista a que aprenda a escucharse a sí misma para ser feliz. ¿Será Héctor el semental que le hacía falta a la confiada de Mimi? ¿Se atreverá a confesar su amor hacía Marín? ¿Sabrá escucharse a sí misma? ¿Triunfará alguno de sus negocios?', v_210, '1 No eres tu, soy yo - Daniel De la Pena.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El Palacio de la Medianoche' AND Autor = 'Carlos Ruiz Zafón') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El Palacio de la Medianoche', 'Carlos Ruiz Zafón', 'The horrible adventure of a sixteen-year-old orphan, Ben, and his friends in the city of Calcutta in 1916.', v_170, '2 - El Palacio de la Medianoche - Carlos Ruiz Zafon.pdf.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'DarK Alpha_s Night (daire)' AND Autor = 'DG070049') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('DarK Alpha_s Night (daire)', 'DG070049', NULL, v_42, '05 - DarK Alpha_s Night (daire).pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'EL BURDEL' AND Autor = 'Beatriz Parga') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('EL BURDEL', 'Beatriz Parga', NULL, v_143, '1_5059811468594119021.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Desgarrada (Spanish Edition)' AND Autor = 'Sky Corgan') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Desgarrada (Spanish Edition)', 'Sky Corgan', NULL, v_42, '1 - Desgarrada.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Thankful For Her' AND Autor = 'usuario') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Thankful For Her', 'usuario', NULL, v_42, '01. Thankful For Her.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'H. P. Lovecraft - El horror en la playa Martin' AND Autor = 'TOMY') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('H. P. Lovecraft - El horror en la playa Martin', 'TOMY', NULL, v_42, '1_5024155560635794113.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Secrets' AND Autor = 'Begoña Hidalgo Martinez') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Secrets', 'Begoña Hidalgo Martinez', NULL, v_42, '04 Secrets - H.M. Ward.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '5024155560635794115' AND Autor = 'Desconocido') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('5024155560635794115', 'Desconocido', NULL, v_42, '1_5024155560635794115.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Carnal Alpha' AND Autor = 'yeimi paola de avila vanegas') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Carnal Alpha', 'yeimi paola de avila vanegas', NULL, v_42, '1. Carnal Alpha.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Y llegaste tú 1. Raquel' AND Autor = 'Merche Diolch') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Y llegaste tú 1. Raquel', 'Merche Diolch', NULL, v_42, '1,-Y llegaste tu [Raquel]▪︎Merche Diolch🐬🥀🍀🍂🐬.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Y llegaste tú 3. Mónica' AND Autor = 'Diolch, Merche') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Y llegaste tú 3. Mónica', 'Diolch, Merche', NULL, v_42, '3,-Y llegaste tu [Monica]▪︎Merche Diolch🐬🥀🍀🍂🐬.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Déjame estar contigo' AND Autor = 'Dylan Martins & Janis Sandgrouse') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Déjame estar contigo', 'Dylan Martins & Janis Sandgrouse', 'Déjame estar contigo es una película mexicana de drama romántico dirigida por Isaac Cherem, estrenada el 30 de enero de 2025.​ La trama sigue a Lucía, una joven que padece una enfermedad incurable, y a Bruno, un joven deportado a México sin hogar. Una llamada inesperada los une en un viaje de resiliencia, reconstrucción y esperanza, donde el amor se convierte en su principal herramienta para salvarse mutuamente.​', v_217, '3 Déjame-Déjame Estar Contigo.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Ho''oponopono y Karma (Metafísica y psicología nº 11) (Spanish Edition)' AND Autor = 'Adolfo Pérez Agustí') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Ho''oponopono y Karma (Metafísica y psicología nº 11) (Spanish Edition)', 'Adolfo Pérez Agustí', NULL, v_42, '1_5035110793847243048.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Cámara de los horrores' AND Autor = 'Curtis Garland') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Cámara de los horrores', 'Curtis Garland', NULL, v_42, '✮Terror 20 - Garland, Curtis - Camara de los horrores.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'La cicatriz que compartimos' AND Autor = 'Irene Hall') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('La cicatriz que compartimos', 'Irene Hall', '"La cicatriz que compartimos" es el tercer y último volumen de la trilogía "El veneno que nos separa".', v_42, '(Veneno. 03) La cicatriz que compartimos - Irene Hall-1.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Dark Alpha_s Demand (talin)' AND Autor = 'Mª de NURIA RODRÍGUEZ MATÍAS') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Dark Alpha_s Demand (talin)', 'Mª de NURIA RODRÍGUEZ MATÍAS', NULL, v_42, '03 - Dark Alpha_s Demand (talin).pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'The Black Room-Door One' AND Autor = 'user') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('The Black Room-Door One', 'user', NULL, v_42, '1 The Black Room-Door One.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¿Te conté lo de Alice?' AND Autor = 'Jennifer Mathieu') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¿Te conté lo de Alice?', 'Jennifer Mathieu', NULL, v_42, '¿Te conte lo de Alice_.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Dungeon ni Deai wo Motomeru no wa Machigatteiru Darou ka' AND Autor = 'carlos') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Dungeon ni Deai wo Motomeru no wa Machigatteiru Darou ka', 'carlos', 'Dungeon ni Deai o Motomeru no wa Machigatteiru Darō ka (ダンジョンに出会いを求めるのは間違っているだろうか, lit. ¿Está mal querer tener un encuentro en una mazmorra??), también conocido como ¿Está mal seducir chicas en un calabozo? o  ¿Qué tiene de malo intentar ligar en una mazmorra? y varias veces abreviado como DanMachi (ダンまち, ''''DanMachi''''?), es una serie de novelas ligeras escritas por Fujino Ōmori e ilustradas por Suzuhito Yasuda. SB Creative ha publicado veintiuno volúmenes desde enero de 2013 bajo el sello de GA Bunko. Ha recibido una serie de spin-offs de la novela ligera y tres adaptaciones al manga. Una adaptación al anime, a cargo del estudio J.C.Staff, salió al aire desde el 4 de abril hasta el 27 de junio de 2015.
Ha sido la novela ligera más votada por los fanes en los premios Sugoi Japan Awards de la edición de 2016. En estos premios, los fanáticos deciden qué anime, manga, novela es la más indicada para ser comercializada en el mercado internacional.​', v_135, '[K-VT] Dungeon Vol. 09.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'DONDE VIVEN LOS MONSTRUOS Por MAURICE SENDAK' AND Autor = 'Jane Cannici') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('DONDE VIVEN LOS MONSTRUOS Por MAURICE SENDAK', 'Jane Cannici', NULL, v_42, '1_5026138577101127903.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'His Little Bad Girl' AND Autor = 'CASA') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('His Little Bad Girl', 'CASA', NULL, v_42, '1. His Little Bad Girl-1.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Julia Quinn Te Doy Mi Corazon' AND Autor = 'Administrador') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Julia Quinn Te Doy Mi Corazon', 'Administrador', NULL, v_42, '003 Julia Quinn Te Doy Mi Corazon.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Lucas' AND Autor = 'Merche Diolch') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Lucas', 'Merche Diolch', 'Lucas es un nombre propio masculino de origen grecolatino (griego: Λουκᾶς, Lukâs, latín: Lucas), usado también como apellido.​', v_42, '4,-Y llegaste tu [Lucas]▪︎Merche Diolch🐬🥀🍀🍂🐬.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Mi error fue confiar en ti. Parte II (Spanish Edition)' AND Autor = 'Moruena Estríngana') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Mi error fue confiar en ti. Parte II (Spanish Edition)', 'Moruena Estríngana', NULL, v_42, '3.2. Mi error fue confiar en ti .pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'horas para enamorarte__ de Giampolo Morelli' AND Autor = 'Rosa Perez') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('horas para enamorarte__ de Giampolo Morelli', 'Rosa Perez', NULL, v_42, '__7 horas para enamorarte__ de Giampolo Morelli.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Dungeon Vol. 02' AND Autor = 'Desconocido') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Dungeon Vol. 02', 'Desconocido', 'Surviving the Deepest, Most Unknowable Dungeon takes more than fighting skills. Jean and his all-female party are brought into the woods, stripped of everything, and start training the skills they''ll need to live through the night. But will Jean be able to secure food, water, and clothing for him and the girls...or will he succumb to the temptations of other nighttime activities?', v_222, '[K-VT] Dungeon Vol. 02.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Pulse' AND Autor = 'Deborah Bladon') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Pulse', 'Deborah Bladon', 'Pulse - Part Three: Jessica wanted to believe Nathan was a changed man. The lust filled promises he made in bed are no match for the reality that she''s now holding in the palm of her hand. Sex drives men like Nathan Moore. She suspected it, then experienced it and now there''s absolutely no denying it. She knows what the right thing to do is. He knows that he''s never met anyone like her. Jessica struggles to forget him as Nathan''s desire for her consumes him. His compulsive need to possess her pushes him in ways that will change them both forever. Just how far is Nathan Moore willing to go to have the one woman he claims he can''t live without?', v_38, '02 Pulse - Deborah Bladon.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Su virgen cautiva' AND Autor = 'acb') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Su virgen cautiva', 'acb', NULL, v_42, '2. Su virgen cautiva.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Los secretos del multimillonario' AND Autor = 'Desconocido') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Los secretos del multimillonario', 'Desconocido', 'Disfrute de este libro sobre chicos malos multimillonarios de la autora romántica Kimberly Johanson... Max Lane está a punto de cumplir los treinta y sentar cabeza está en la vanguardia de su mente. Su gusto por las mujeres no hace que sus decisiones para encontrar una esposa y una futura madre de sus hijos sean fáciles. Las mujeres ricas y hermosas con piernas largas y cuerpos deliciosos son geniales hasta que tienes que lidiar con sus actitudes dignas de crédito lo que es algo que el joven multimillonario no tiene ni encuentra atractivo.', v_210, '_6 Los secretos del multimillonario.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Star Wars: Episodio V - El Imperio contraataca' AND Autor = 'Donald F. Glut') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Star Wars: Episodio V - El Imperio contraataca', 'Donald F. Glut', 'Star Wars: Episodio V - El Imperio contraataca (título original en inglés: Star Wars: Episode V - The Empire Strikes Back; también conocida en español como La guerra de las galaxias: Episodio V - El Imperio contraataca y a veces conocida como Star Wars: El Imperio Contraataca) es una película del género space opera dirigida por Irvin Kershner y estrenada por primera vez en Estados Unidos el 21 de mayo de 1980. El guion, basado en una historia de George Lucas, fue escrito por Lawrence Kasdan y Leigh Brackett. Aunque en términos cronológicos internos sea la quinta película de la saga Star Wars, en realidad fue la segunda película de la saga en ser estrenada.
La ficción de la película se sitúa tres años después de la destrucción de la estación espacial de combate conocida como la Estrella de la Muerte, destrucción acaecida al final del episodio anterior, Una Nueva Esperanza, estrenada en el año 1977. En El Imperio contraataca Luke Skywalker, Han Solo, Leia Organa y el resto de la Alianza Rebelde son perseguidos por Darth Vader y las fuerzas de élite del Imperio Galáctico. En este episodio se desarrolla la historia de amor entre Han y Leia,  mientras que Luke aprende más sobre los caminos de la Fuerza de la mano del maestro Yoda. Con Han y Leia capturados por el Imperio, Luke luchará contra Darth Vader en una confrontación sin igual, pero Vader esconde una terrible revelación.
Tras una difícil producción, Star Wars: Episode V - The Empire Strikes Back fue estrenada el 21 de mayo de 1980 y fue un éxito de crítica, siendo muy a menudo calificada como la mejor película de la saga.​​​
La película recaudó más de 538 millones de dólares en todo el mundo, convirtiéndola en la película más taquillera de 1980, y si se ajusta por la inflación la duodécima película más taquillera de la historia de los Estados Unidos.​
La película fue remasterizada y reeditada con cambios y alteraciones en imagen y sonido en 1997, 2004, 2011 y 2020. En 2008 la revista Empire la ubicó en el tercer puesto de su lista de las 500 mejores películas de todos los tiempos.​ Fue incluida en el National Film Registry de la Biblioteca del Congreso de Estados Unidos en 2010.​', v_28, '5.Star Wars.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Déjame para siempre' AND Autor = 'Dylan Martins') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Déjame para siempre', 'Dylan Martins', NULL, v_42, '2 Dejame para siempre - Dylan Martins.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Donde descansan las almas' AND Autor = 'Enrique Laso') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Donde descansan las almas', 'Enrique Laso', NULL, v_42, '_Donde descansan las almas_ - Enrique Laso-1-1.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'No soy yo, eres tú' AND Autor = 'Stephanie Kate Strohm') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('No soy yo, eres tú', 'Stephanie Kate Strohm', 'La hilarante historia de la vida sentimental de una chica narrada por sus amigos, su familia y sus enemigos. ¿Te enteraste...? Natalie Wagner, una alumna cualquiera: A Avery Dennis -la sin par Avery Dennis- su novio la dejó justo antes de la fiesta de graduación. Coco Kim, mejor amiga: ¡A Avery nunca nadie la ha dejado. Bueno, excepto esta vez. Bizzy Stanhope, lo peor de lo peor: La responsable del comité de organización de la fiesta no tiene con quién ir. Es más que patético. James Hutch Hutcherson, compañero del laboratorio: ¿De verdad Avery decidió que no volverá a salir con nadie hasta que descubra por qué no funcionan sus relaciones? Me lo creeré cuando lo vea. Robby Monroe, ex novio: ¿Te entrevistó Avery Dennis para su proyecto? Tripp Gomez-Parker, ex novio: Avery Dennis está entrevistando a todo el mundo. Avery Dennis, recientemente abandonada/objeto de muchos chismes: Todo el mundo está hablando de ello. Pues hablemos...', v_215, '_No soy yo, eres tú - Stephanie Kate Strohm.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Cuando encuentres el amor verdadero' AND Autor = 'Mara Brent') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Cuando encuentres el amor verdadero', 'Mara Brent', NULL, v_42, '1_5062446538404397369.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Enola Holmes -El caso del peculiar abanico rosa' AND Autor = 'Desconocido') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Enola Holmes -El caso del peculiar abanico rosa', 'Desconocido', NULL, v_42, '4. Enola Holmes -El caso del peculiar abanico rosa.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'f187332-33a1-40b1-8a9a-cc463f25233a' AND Autor = 'user') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('f187332-33a1-40b1-8a9a-cc463f25233a', 'user', NULL, v_42, '1f187332-33a1-40b1-8a9a-cc463f25233a.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Juegos insolentes 3' AND Autor = 'Emma Green') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Juegos insolentes 3', 'Emma Green', NULL, v_42, '0 Juegos_insolentes_3_Emma_Green4eda.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El poder del espejo (Crecimiento personal) (Spanish Edition)' AND Autor = 'Hay, Louise') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El poder del espejo (Crecimiento personal) (Spanish Edition)', 'Hay, Louise', NULL, v_42, '1_5091745486742749329.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Quién se ha llevado mi queso' AND Autor = 'Spencer Johnson') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Quién se ha llevado mi queso', 'Spencer Johnson', '¿Quién se ha llevado mi queso? Una manera sorprendente de afrontar el cambio en el trabajo y en la vida privada (en inglés: Who Moved My Cheese? An Amazing Way to Deal with Change in Your Work and in Your Life), publicado en 1998, es un libro de motivación escrito por el estadounidense Spencer Johnson en el estilo de una parábola y alegoria.
Describe el cambio en el trabajo y la vida, y cuatro típicas reacciones (resistirse al cambio por miedo a algo peor, aprender a adaptarse cuando se comprende que el cambio puede conducir a algo mejor, detectar pronto el cambio y finalmente apresurarse hacia la acción) al citado cambio con dos ratones, dos "liliputienses", y sus búsquedas de queso. Un superventas empresarial de New York Times desde el lanzamiento, ¿Quién se ha llevado mi queso? permaneció en la lista por casi cinco años y pasó en torno a doscientas semanas en la lista de no ficción de pasta dura de Publishers Weekly.​', v_114, '__Quien se ha llevado mi queso(1).pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El crimen de Lord Arthur Savile' AND Autor = 'Oscar Wilde') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El crimen de Lord Arthur Savile', 'Oscar Wilde', NULL, v_42, '06 Wilde Oscar - El crimen lord Arthur Saville.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Burning Desire' AND Autor = 'Mª de NURIA RODRÍGUEZ MATÍAS') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Burning Desire', 'Mª de NURIA RODRÍGUEZ MATÍAS', NULL, v_225, '03 - Burning Desire.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¿Qué es la meditación?' AND Autor = 'Osho') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¿Qué es la meditación?', 'Osho', NULL, v_42, '_Que es la meditacion_ - Osho-1.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Muérdeme ★M🌸' AND Autor = 'Sistemas') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Muérdeme ★M🌸', 'Sistemas', NULL, v_42, '2 - Muérdeme ★M🌸.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¿Qué le pasa a mi cuerpo? Chicas' AND Autor = 'Manuel Díaz') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¿Qué le pasa a mi cuerpo? Chicas', 'Manuel Díaz', NULL, v_42, '¿Qué le pasa a mi cuerpo. Para muchachas.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Julia Quinn a Sir Phillip con amor' AND Autor = 'Administrador') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Julia Quinn a Sir Phillip con amor', 'Administrador', NULL, v_42, '005 Julia Quinn a Sir Phillip con amor.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Secrets' AND Autor = 'Begoña Hidalgo Martinez') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Secrets', 'Begoña Hidalgo Martinez', NULL, v_42, '03 Secrets - H.M. Ward.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Veinticinco Agosto 1983 y otros cuentos' AND Autor = 'Jorge Luis Borges') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Veinticinco Agosto 1983 y otros cuentos', 'Jorge Luis Borges', NULL, v_42, '02 Borges - Otros cuentos .pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Yo soy tú: La mente no dual (Spanish Edition)' AND Autor = 'Corbera, Enric') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Yo soy tú: La mente no dual (Spanish Edition)', 'Corbera, Enric', NULL, v_42, '4_6035001793358857944.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Ana la de la Isla' AND Autor = 'Lucy Maud Montgomery') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Ana la de la Isla', 'Lucy Maud Montgomery', 'Ana, la de la Isla es una novela escrita por Lucy Maud Montgomery, sobre la vida de Anne Shirley.
Es la continuación de las historias de Ana y el tercer libro de la serie Ana de las Tejas Verdes. Ana, por fin asiste a la universidad Redmond en Kingsport, donde estudia para obtener su diplomatura. El libro está dedicado por L. M. Montgomery "A todas las jóvenes del mundo que han «querido algo más» sobre Ana."', v_62, '3.- ana_la_de_la_isla.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Como el fuego' AND Autor = 'Armentrout, Jennifer') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Como el fuego', 'Armentrout, Jennifer', NULL, v_42, '2. Como el fuego - Jennifer L. Armentrout-2.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¿Y si te enamoras de mí?' AND Autor = 'Ana Urbina') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¿Y si te enamoras de mí?', 'Ana Urbina', NULL, v_42, '_Y_si_te_enamoras_de_m_-_Ana_Urbina.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Forrest Gump' AND Autor = 'Winston Groom') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Forrest Gump', 'Winston Groom', 'A man named Forest Gump sits at a bus stop and tells everyone about his life. It starts in a doctor''s office when he gets leg braces. Then he goes to school where he meets Jenny, and his entire school career and football. Then it goes on to college football. then to Vietnam where he meets bubba. then bubba dies and forest saves a whole platoon. After the war forest gets a medal of honor and runs across America. Then his mom dies. Then he finds jenny again. They have a kid and get married. Then jenny dies. Then the book ends but there is more than this in the town of Greenbow Alabama.', v_42, '__Forrest Gump - Winston Groom (2).pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Dungeon ni Deai wo Motomeru no wa Machigatteiru Darou ka' AND Autor = 'carlos') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Dungeon ni Deai wo Motomeru no wa Machigatteiru Darou ka', 'carlos', 'Dungeon ni Deai o Motomeru no wa Machigatteiru Darō ka (ダンジョンに出会いを求めるのは間違っているだろうか, lit. ¿Está mal querer tener un encuentro en una mazmorra??), también conocido como ¿Está mal seducir chicas en un calabozo? o  ¿Qué tiene de malo intentar ligar en una mazmorra? y varias veces abreviado como DanMachi (ダンまち, ''''DanMachi''''?), es una serie de novelas ligeras escritas por Fujino Ōmori e ilustradas por Suzuhito Yasuda. SB Creative ha publicado veintiuno volúmenes desde enero de 2013 bajo el sello de GA Bunko. Ha recibido una serie de spin-offs de la novela ligera y tres adaptaciones al manga. Una adaptación al anime, a cargo del estudio J.C.Staff, salió al aire desde el 4 de abril hasta el 27 de junio de 2015.
Ha sido la novela ligera más votada por los fanes en los premios Sugoi Japan Awards de la edición de 2016. En estos premios, los fanáticos deciden qué anime, manga, novela es la más indicada para ser comercializada en el mercado internacional.​', v_135, '[K-VT] Dungeon Vol. 05.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Desgarrada: Parte Dos (Spanish Edition)' AND Autor = 'Sky Corgan') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Desgarrada: Parte Dos (Spanish Edition)', 'Sky Corgan', NULL, v_42, '2 - Desgarrada.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Se busca una mujer' AND Autor = 'Charles Bukowski') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Se busca una mujer', 'Charles Bukowski', NULL, v_42, '♠️ Se Busca Una Mujer. Charles Bukowski.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '5026138577101127902' AND Autor = 'Roberto') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('5026138577101127902', 'Roberto', NULL, v_42, '1_5026138577101127902.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Angel' AND Autor = 'Sarah Brianne') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Angel', 'Sarah Brianne', 'Un ángel es un ser sobrenatural presente en varias religiones y mitologías, cuya función principal es servir a una deidad suprema. Sus funciones y especificaciones varían según cada cultura. La rama de la teología que se especializa en  los ángeles se denomina angelología.
Las religiones monoteístas muchas veces representan a los ángeles como seres celestiales benevolentes que actúan como intermediarios entre Dios y la humanidad.
En el catolicismo se habla del ángel de la guarda o del custodio, que sería aquel que Dios tiene señalado a cada persona para protegerla. Por contraposición, también se tiene la figura del ángel caído, aquel que ha sido expulsado del cielo por desobedecer o rebelarse contra Dios. Los ángeles más conocidos en las tradiciones judeocristianas son: San Miguel, San Gabriel y San Rafael.', v_99, '__Donde los angeles no duermen.pdf.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Nero' AND Autor = 'Sarah Brianne') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Nero', 'Sarah Brianne', 'Elle is determined to keep her mouth shut when the mob boss tells Nero to make her talk.', v_99, '_Como emprender sin dinero_ (Sp - Gumaro Bracho-1.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El Niño Con El Pijama De Rayas. John Boyne' AND Autor = 'Desconocido') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El Niño Con El Pijama De Rayas. John Boyne', 'Desconocido', 'El libro que conmovió a millones de lectores. Estimado lector, estimada lectora: Aunque el uso habitual de un texto como éste es describir las características de la obra, por una vez nos tomaremos la libertad de hacer una excepción a la norma establecida. No sólo porque el libro que tienes en tus manos es muy difícil de definir, sino porque estamos convencidos de que explicar su contenido estropearía la experiencia de la lectura. Creemos que es importante empezar esta novela sin saber de qué trata. No obstante, si decides embarcarte en la aventura, debes saber que acompañarás a Bruno, un niño de nueve años, cuando se muda con su familia a una casa junto a una cerca. Cercas como ésa existen en muchos sitios del mundo, sólo deseamos que no te encuentres nunca con una. Por último, cabe aclarar que este libro no es sólo para adultos; también lo pueden leer, y sería recomendable que lo hicieran, niños a partir de los trece años de edad. El editor La crítica ha dicho... «Una historia que tiene mucho de fábula... una pequeña maravilla de libro». The Guardian «Un libro que persiste en la memoria del lector. Sutil, de una exquisita sencillez y absolutamente conmovedor». The Irish Times «Un libro tan sencillo, tan aparentemente accesible, que es casi perfecto». The Irish Independent «Profundamente conmovedor». The Wall Street Journal «Un libro que no se olvida». The Australian «Extraordinario». The Irish Examiner', v_210, '_El Niño Con El Pijama De Rayas. John Boyne.PDF', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Artemis Fowl' AND Autor = 'Eoin Colfer') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Artemis Fowl', 'Eoin Colfer', 'Nom : Fowl. Prénom : Artemis. Age : 12 ans. Signes particuliers : une intelligence hors du commun. Profession : voleur. Recherché pour : enlèvement de fée et demande de rançon. Appel à tous les FARfadets, membres des Forces Armées de Régulation du Peuple des fées : cet humain est dangereux et doit être neutralisé par tous les moyens possibles. Un anti-héros pétillant de malice, une galerie de personnages décapants, des dialogues vifs et intelligents, une histoire au rythme débridé... Laissez-vous entraîner dans l''univers sophistiqué d''Eoin Colfer, unique et enchanteur.', v_10, '03- Artemis Fowl - El Cubo B - Eoin Colfer..pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Rogue Cyborg' AND Autor = 'Alumno') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Rogue Cyborg', 'Alumno', NULL, v_42, '6. Rogue Cyborg.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Yo me he llevado tu queso' AND Autor = 'Darrel Bristow-Bovey') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Yo me he llevado tu queso', 'Darrel Bristow-Bovey', NULL, v_56, '__yo me he llevado tu queso.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¿Cómo viajar fuera del cuerpo? (Spanish Edition)' AND Autor = 'Joselito Montero') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¿Cómo viajar fuera del cuerpo? (Spanish Edition)', 'Joselito Montero', NULL, v_42, '_Como viajar fuera del cuerpo_ - Joselito Montero.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Nero' AND Autor = 'Sarah Brianne') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Nero', 'Sarah Brianne', 'Elle is determined to keep her mouth shut when the mob boss tells Nero to make her talk.', v_99, '_Como emprender sin dinero_ (Sp - Gumaro Bracho.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¡Sincroniza tu vida! (Spanish Edition)' AND Autor = 'Juna Albert') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¡Sincroniza tu vida! (Spanish Edition)', 'Juna Albert', NULL, v_42, '¡Sincroniza tu vida!.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'DINÁMICAS PARA HACER REIR1.doc' AND Autor = 'Gilbert') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('DINÁMICAS PARA HACER REIR1.doc', 'Gilbert', NULL, v_42, '_Ejercicios para hacer reír-1.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '5059811468594118971' AND Autor = 'Desconocido') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('5059811468594118971', 'Desconocido', NULL, v_42, '1_5059811468594118971.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Mujeres vampiro' AND Autor = 'Curtis Garland') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Mujeres vampiro', 'Curtis Garland', NULL, v_42, '✮Terror 06 - Garland, Curtis - Mujeres vampiro.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Yo, hombre-lobo' AND Autor = 'Curtis Garland') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Yo, hombre-lobo', 'Curtis Garland', NULL, v_42, '✮Terror 17 - Garland, Curtis - Yo, hombre-lobo.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Marcada' AND Autor = 'Kim Richardson') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Marcada', 'Kim Richardson', '* * * GANADOR DEL PREMIO “FAVORITO DE LOS LECTORES”* * * Kara Nightingale tiene dieciséis años, no es popular, es rara y definitivamente ordinaria—hasta que un día la atropella un autobús y muere… En segundos, su vida cambia de ordinaria a extraordinaria cuando despierta en un misterioso mundo con una nueva carrera—como una novata en la Legión de Los Ángeles Guardianes. Kara es succionada hacia un mundo sobrenatural donde los monos operan los elevadores, los oráculos caminan sobre bolas de cristal gigantes y los demonios se alimentan de las almas de los humanos. Cuando un niño Elemental es secuestrado, Kara es enviada a una riesgosa misión y se ve envuelta en una situación más peligrosa y mortal de lo que alguna vez pudo haber imaginado. De la escritora bestseller, hace su debut esta cautivadora y divertida novela, ganadora del premio Favorito de los Lectores. Marcada es una fantasía urbana de ritmo rápido llena de demonios, ángeles, vampiros, hombres lobo, brujas, fae, duendes, genios y cambiadores. ﻿Libros para adolescentes, Libros de Fantasía Ya, Libros de Fantasía Gratis para Adultos Jóvenes, Paquete para Adultos Jóvenes y Paquete para Adolescentes, Libros para Adultos Jóvenes Gratis, Libros para Adultos Jóvenes Gratis, Libros de Fantasía Gratis, Series para Adultos Jóvenes, Libros de Aventura Gratis, Libros de Fantasía Gratis para Adultos, Libros para Adultos Jóvenes Gratis, Libros de Fantasía Paranormal Gratis para Adultos Jóvenes, Fantasía Ya, Libros Gratis', v_215, '1- Marcada - Kim Richardson.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Mi primer beso' AND Autor = 'Reekles, Beth') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Mi primer beso', 'Reekles, Beth', 'The Kissing Booth (Mi Primer beso en España y El stand de los besos en Hispanoamérica) es una comedia romántica adolescente de 2018 basada en la novela homónima de la autora Beth Reekles. La película fue lanzada el 11 de mayo de 2018 por Netflix.​​', v_52, ', Mi primer beso - el stand de los besos-1.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El personaje' AND Autor = 'Vic Logan') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El personaje', 'Vic Logan', NULL, v_162, '✮Terror 21 - Logan, Vic - El personaje.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Y llegaste tú 6. Israel' AND Autor = 'Merche Diolch') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Y llegaste tú 6. Israel', 'Merche Diolch', NULL, v_42, '6,-Y llegaste tu [Israel]▪︎Merche Diolch🐬🥀🍀🍂🐬.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'La plegaria secreta (ESPIRITUALIDAD Y VIDA INTERIOR) (Spanish Edition)' AND Autor = 'Vitale, Joe') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('La plegaria secreta (ESPIRITUALIDAD Y VIDA INTERIOR) (Spanish Edition)', 'Vitale, Joe', NULL, v_42, '✩✿Joe Vitale - La plegaria secreta★M🌸.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¿Dónde Están los Niños?' AND Autor = 'Mary Higgins Clark') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¿Dónde Están los Niños?', 'Mary Higgins Clark', 'Nancy Harmon had fled the evil of her first marriage, the macabre deaths of her two little children, the hideous charges against her. She changed her name and moved across the country. Now she was married again, had two more lovely children, and her life was filled with happiness....

until the morning when she looked for her children and found only one tattered red mitten and knew that the nightmare was beginning again...', v_42, '_Donde Estan los Ninos_ - Mary Higgins Clark-1.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Derecho a la Libertad Personal' AND Autor = 'Desconocido') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Derecho a la Libertad Personal', 'Desconocido', 'Este libro aborda el derecho a la libertad personal prestando especial atención a las condiciones de validez de la detención y a los derechos del detenido, y las condiciones que la Constitución exige para que sean admisibles, utilizando con profusión los numerosos antecedentes existentes en otros países.', v_207, '3- Derecho a la Libertad Personal.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Mi error fue creer en cuentos de hadas. Parte II (Spanish Edition)' AND Autor = 'Moruena Estríngana') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Mi error fue creer en cuentos de hadas. Parte II (Spanish Edition)', 'Moruena Estríngana', NULL, v_42, '6.2. Mi error fue creer en cuentos de hadas .pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¿Qué tan alto quiere llegar\?. Determine su éxito cultivando la actitud correcta - PDFDrive.com' AND Autor = 'John C. Maxwell') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¿Qué tan alto quiere llegar\?. Determine su éxito cultivando la actitud correcta - PDFDrive.com', 'John C. Maxwell', NULL, v_42, '¿Qué tan alto quiere llegar_. Determine su éxito cultivando la actitud correcta ( PDFDrive ).pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Memorias de una puta' AND Autor = 'Mari Cielo Pajares') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Memorias de una puta', 'Mari Cielo Pajares', NULL, v_42, '_Memorias_de_una_puta (1).pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Deseo' AND Autor = 'Adrian Blake') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Deseo', 'Adrian Blake', 'Deseo es el undécimo álbum de estudio de la cantante mexicana Paulina Rubio. Fue lanzado el 14 de septiembre de 2018​ por Universal Spain, marcando su última producción con el sello discográfico Universal Music Group y el primero a siete años de editar Brava! (2011). Colaboró con una multitud de productores y músicos para el disco, entre ellos Mauricio Rengifo, Andrés Torres, los Julca Brothers, Antonio "Toy Selectah" Hernández, Joey Montana, Morat, Nacho, Juan Magán, Xabier San Martin y Alexis & Fido. Deseo es un álbum pop latino con una fuerte vibra del género urbano, aunque mantiene el característico estilo pop rock de la cantante en algunas canciones.
Paulina Rubio empezó a trabajar en un disco inédito a finales de 2014, pero por varias situaciones desconocidas Universal retrasó sus proyectos al grado de publicar sencillos independientes a lo largo de los siguientes dos años. Además, se involucró en su faceta como jueza en diferentes shows de televisión incluyendo la versión mexicana de La Voz, La Voz Kids, la versión estadounidense de The X Factor y La Apuesta.
Inicialmente se lanzaron dos sencillos del álbum: «Desire (Me Tienes Loquita)», una colaboración con Nacho, estrenada el 28 de mayo de 2018, y «Suave y Sutil», lanzada cuatro meses más tarde. El 15 de abril de 2019 se lanzó una edición especial de Deseo que incluía cuatro canciones inéditas, incluyendo el sencillo «Ya No Me Engañas», estrenado solo unos días antes del lanzamiento de la reedición.​ El disco también contiene los sencillos independientes  —lanzados entre 2015 y 2016— «Mi Nuevo Vicio», «Si Te Vas» y «Me Quema».
Tras su lanzamiento, Deseo recibió críticas mixtas por parte de los críticos de música, quienes elogiaron la «energía» de la cantante y su capacidad de adaptarse a los nuevos géneros musicales, pero sintieron que el flujo de las canciones en el disco no tenía ningún sentido ya que la mitad de los temas ya habían sido publicados, por lo que sostuvieron que se trataba más de una «compilación» poco sorprendente. Comercialmente, Deseo tuvo poco impacto en las listas musicales, alcanzando la posición número trece de la lista de Billboard Latin Pop Albums. Pese a ello, obtuvo una certificación de disco de oro en Chile,​ y se embarcó en una gira de conciertos en los Estados Unidos.', v_38, '2- El limite del deseo - Eve Berlin.versión 1.pdf · versión 1.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Pasar la noche' AND Autor = 'Violet Haze') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Pasar la noche', 'Violet Haze', NULL, v_42, '1.Trilogía Luna - Violet Haze🐬🥀🍀🍂🐬.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Mi error fue enamorarme del novio de mi hermana' AND Autor = 'Moruena Estríngana') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Mi error fue enamorarme del novio de mi hermana', 'Moruena Estríngana', NULL, v_42, '4. Mi error fue enamorarme del novio de mi hermana .pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Angel' AND Autor = 'Sarah Brianne') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Angel', 'Sarah Brianne', 'Un ángel es un ser sobrenatural presente en varias religiones y mitologías, cuya función principal es servir a una deidad suprema. Sus funciones y especificaciones varían según cada cultura. La rama de la teología que se especializa en  los ángeles se denomina angelología.
Las religiones monoteístas muchas veces representan a los ángeles como seres celestiales benevolentes que actúan como intermediarios entre Dios y la humanidad.
En el catolicismo se habla del ángel de la guarda o del custodio, que sería aquel que Dios tiene señalado a cada persona para protegerla. Por contraposición, también se tiene la figura del ángel caído, aquel que ha sido expulsado del cielo por desobedecer o rebelarse contra Dios. Los ángeles más conocidos en las tradiciones judeocristianas son: San Miguel, San Gabriel y San Rafael.', v_99, '(Yehuda Berg) - Inteligencia angelical.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¿A qué le tienes miedo\?. Vence tus temores con la fe - PDFDrive.com' AND Autor = 'David Jeremiah') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¿A qué le tienes miedo\?. Vence tus temores con la fe - PDFDrive.com', 'David Jeremiah', NULL, v_42, '_A que le tienes miedo__. Vence - David Jeremiah.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Artemis Fowl' AND Autor = 'Eoin Colfer') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Artemis Fowl', 'Eoin Colfer', 'Nom : Fowl. Prénom : Artemis. Age : 12 ans. Signes particuliers : une intelligence hors du commun. Profession : voleur. Recherché pour : enlèvement de fée et demande de rançon. Appel à tous les FARfadets, membres des Forces Armées de Régulation du Peuple des fées : cet humain est dangereux et doit être neutralisé par tous les moyens possibles. Un anti-héros pétillant de malice, une galerie de personnages décapants, des dialogues vifs et intelligents, une histoire au rythme débridé... Laissez-vous entraîner dans l''univers sophistiqué d''Eoin Colfer, unique et enchanteur.', v_10, '02- Artemis Fowl - Encuentro en el Artico - Eoin Colfer.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Volver al Amor' AND Autor = 'Polylopez y Mariquiña') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Volver al Amor', 'Polylopez y Mariquiña', NULL, v_226, '1_5059811468594118972.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '01 Después de Ti' AND Autor = 'Silvana Moreira & Diana Scott') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('01 Después de Ti', 'Silvana Moreira & Diana Scott', NULL, v_42, '01 Despues de Ti - Diana Scott.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Las pirañas' AND Autor = 'Curtis Garland') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Las pirañas', 'Curtis Garland', 'Las pirañas, exhibida en España como La boutique,​ es una película coproducción de Argentina y España dirigida por Luis García Berlanga según su propio guion escrito en colaboración con Rafael Azcona que se estrenó el 19 de octubre de 1967 y que tuvo como protagonistas a Sonia Bruno, Rodolfo Bebán, Ana María Campoy y Osvaldo Miranda.', v_82, '_Las piranas - Garland, Curtis -.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Mi error fue creer en cuentos de hadas. Parte I (Spanish Edition)' AND Autor = 'Moruena Estríngana') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Mi error fue creer en cuentos de hadas. Parte I (Spanish Edition)', 'Moruena Estríngana', NULL, v_42, '6. Mi error fue creer en cuentos de hadas .pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Lirio rojo' AND Autor = 'Nora Roberts') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Lirio rojo', 'Nora Roberts', 'La última entrega de la «Trilogía del jardín». Un empleo y empezar de cero era lo único que deseaba Hayley Phillips para ella y la hija que estaba esperando cuando llamó a la puerta de la mansión Harper. Lo que también encontró fue un hogar, la sólida amistad de Roz y Stella, y la posibilidad de un nuevo amor. Solo el misterio que rodea la mansión Harper se interponen ahora entre ella y su felicidad. TRILOGÍA DEL JARDÍN Tres mujeres se conocen en un momento crucial de sus vidas: cuando es necesario dejar atrás el pasado, pero el futuro todavía parece incierto. Para Stella, Rosalind y Hayley, la mansión Harper -una vieja casa sureña en las afueras de Memphis- se convierte en un puerto seguro y un auténtico hogar. El pequeño y próspero negocio de un vivero de flores y plantas, en el que todas han depositado sus esperanzas, se erige en el símbolo de su independencia. Juntas encontrarán el valor para rehacer sus vidas y aceptar el amor cuando aparezca... aunque un misterio anclado en la centenaria casa solariega puede ponerlas a ellas y a quienes más aman en peligro. Reseña: «La excelente Roberts lleva la conclusión de su "Trilogía del jardín" hacia un misterioso y seductor final con esta novela mágica que celebra el poder del amor.» Booklist', v_210, '(Trilogía del jardín 03) Lirio rojo - Nora Roberts.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Deseo' AND Autor = 'Adrian Blake') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Deseo', 'Adrian Blake', 'Deseo es el undécimo álbum de estudio de la cantante mexicana Paulina Rubio. Fue lanzado el 14 de septiembre de 2018​ por Universal Spain, marcando su última producción con el sello discográfico Universal Music Group y el primero a siete años de editar Brava! (2011). Colaboró con una multitud de productores y músicos para el disco, entre ellos Mauricio Rengifo, Andrés Torres, los Julca Brothers, Antonio "Toy Selectah" Hernández, Joey Montana, Morat, Nacho, Juan Magán, Xabier San Martin y Alexis & Fido. Deseo es un álbum pop latino con una fuerte vibra del género urbano, aunque mantiene el característico estilo pop rock de la cantante en algunas canciones.
Paulina Rubio empezó a trabajar en un disco inédito a finales de 2014, pero por varias situaciones desconocidas Universal retrasó sus proyectos al grado de publicar sencillos independientes a lo largo de los siguientes dos años. Además, se involucró en su faceta como jueza en diferentes shows de televisión incluyendo la versión mexicana de La Voz, La Voz Kids, la versión estadounidense de The X Factor y La Apuesta.
Inicialmente se lanzaron dos sencillos del álbum: «Desire (Me Tienes Loquita)», una colaboración con Nacho, estrenada el 28 de mayo de 2018, y «Suave y Sutil», lanzada cuatro meses más tarde. El 15 de abril de 2019 se lanzó una edición especial de Deseo que incluía cuatro canciones inéditas, incluyendo el sencillo «Ya No Me Engañas», estrenado solo unos días antes del lanzamiento de la reedición.​ El disco también contiene los sencillos independientes  —lanzados entre 2015 y 2016— «Mi Nuevo Vicio», «Si Te Vas» y «Me Quema».
Tras su lanzamiento, Deseo recibió críticas mixtas por parte de los críticos de música, quienes elogiaron la «energía» de la cantante y su capacidad de adaptarse a los nuevos géneros musicales, pero sintieron que el flujo de las canciones en el disco no tenía ningún sentido ya que la mitad de los temas ya habían sido publicados, por lo que sostuvieron que se trataba más de una «compilación» poco sorprendente. Comercialmente, Deseo tuvo poco impacto en las listas musicales, alcanzando la posición número trece de la lista de Billboard Latin Pop Albums. Pese a ello, obtuvo una certificación de disco de oro en Chile,​ y se embarcó en una gira de conciertos en los Estados Unidos.', v_38, 'Deseo - Adrian Blake.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Enola Holmes' AND Autor = 'El caso del crinolina críptica') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Enola Holmes', 'El caso del crinolina críptica', 'Enola Holmes es una película de misterio, romance, aventura y acción de 2020 protagonizada por Millie Bobby Brown como el personaje principal, la hermana adolescente del ya famoso detective de la época victoriana Sherlock Holmes. La película está dirigida por Hary Bradbeer a partir de un guion de Jack Thorne que adapta la primera novela de la serie Las aventuras de Enola Holmes de Nancy Springer. En la película, Enola viaja a Londres para encontrar a su madre desaparecida, pero termina en una emocionante aventura, formando pareja con un lord fugitivo mientras intentan resolver un misterio que amenaza a todo el país. Además de Brown, la película también está protagonizada por Sam Claflin, Henry Cavill y Helena Bonham Carter.
El rodaje comenzó en julio de 2019. Originalmente planeada para un estreno en cines por Warner Bros. Pictures, los derechos de distribución de la película fueron adquiridos por Netflix debido a la pandemia de COVID-19. Enola Holmes se estrenó el 23 de septiembre de 2020. La película recibió críticas positivas de los críticos, quienes elogiaron la actuación de Brown. Se convirtió en uno de los estrenos de películas originales de Netflix más vistos, con un estimado de 76 millones de hogares viendo la película durante sus primeras cuatro semanas. Una secuela, Enola Holmes 2, se estrenó en Netflix el 4 de noviembre de 2022.', v_164, '5. Enola Holmes - El caso del crinolina críptica .pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Los fríos labios de la muerte' AND Autor = 'Vic Logan') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Los fríos labios de la muerte', 'Vic Logan', NULL, v_42, '✮Terror 07 - Logan, Vic - Los frios labios de la muerte.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'La herencia' AND Autor = 'Kathryn Taylor') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('La herencia', 'Kathryn Taylor', 'La herencia, un legado de amor o simplemente La herencia, es una telenovela mexicana producida por Juan Osorio y Roy Nelson Rojas para TelevisaUnivision en el 2022.​​ Es la segunda adaptación de la telenovela chilena Hijos Del Monte de Víctor Carrasco, la cual, está basada en la última adaptación que se realizó en el 2011 bajo el título de Los herederos Del Monte, escrita por Roberto Stopello y Cristina Policastro.​​ Se estrenó a través de Las Estrellas el 28 de marzo de 2022 en sustitución de El último rey y finalizó el 15 de julio del mismo año siendo reemplazado por Vencer la ausencia.​​
Está protagonizada por Michelle Renaud, Matías Novoa, Emmanuel Palomares, Juan Pablo Gil y Mauricio Henao, junto con Daniel Elbittar, Elizabeth Álvarez, Tiaré Scanda, Paulina Matos y Sergio Basáñez en los roles antagónicos.​​', v_224, '01 ʕ·ᴥ·ʔ La herencia ✿.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'candidiasis y cerebro' AND Autor = 'ISHA') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('candidiasis y cerebro', 'ISHA', NULL, v_42, '1 candidiasis y cerebro.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El fuego en el que ardo (Spanish Edition)' AND Autor = 'Lightwood, Mike') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El fuego en el que ardo (Spanish Edition)', 'Lightwood, Mike', NULL, v_42, '_el fuego en el que ardo.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¿Amar o depender?' AND Autor = 'Walter Riso') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¿Amar o depender?', 'Walter Riso', '“Aunque la psicología ha avanzado en el tema de las adicciones, en el tema de la adicción afectiva el vacío es innegable Este libro está dirigido a todas aquellas personas que quieren hacer del amor una experiencia plena, alegre y saludable”. —Walter Riso Entregarse afectivamente no implica desaparecer sino integrarse en el otro. El amor sano es una suma de dos en la que nadie pierde. Sin embargo, millones de personas en todo el mundo son víctimas de relaciones amorosas inadecuadas y no saben qué hacer al respecto, ya que el miedo a la pérdida, a la soledad o al abandono contamina el vínculo amoroso y lo vuelve altamente vulnerable. Un amor inseguro es una bomba que puede estallar en cualquier momento y lastimarnos profundamente. En ¿Amar o depender?, Walter Riso, uno de los más conocidos autores de autoayuda, nos enseña que sí es posible vivir con independencia y aun así seguir amando, eliminando las ataduras psicológicas y manteniendo vivo el fuego del amor. La adicción afectiva es una enfermedad que tiene cura y, lo más importante, puede prevenirse. Este revelador libro pretende ayudar a aquellas personas que son o han sido víctimas de un amor malsano y guiar a las parejas sanas para que sigan trabajando en la costumbre de amar intensamente y sin apegos.', v_125, '¿Amar o depender - Walter Riso.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Muffin Top' AND Autor = 'Jimena Castillo') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Muffin Top', 'Jimena Castillo', NULL, v_42, '3. Muffin Top.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'H. P. Lovecraft - El hombre de piedra' AND Autor = 'TOMY') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('H. P. Lovecraft - El hombre de piedra', 'TOMY', NULL, v_42, '1_5024155560635794108.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Juegos insolentes 6' AND Autor = 'Emma Green') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Juegos insolentes 6', 'Emma Green', NULL, v_42, '0 Juegos_insolentes_6_Emma_Green09f4.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '5' AND Autor = 'Mª de NURIA RODRÍGUEZ MATÍAS') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('5', 'Mª de NURIA RODRÍGUEZ MATÍAS', NULL, v_42, '06.5 - Dark Kings.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'NUEVO LIBRO' AND Autor = 'FX') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('NUEVO LIBRO', 'FX', NULL, v_229, '2-El-sendero-con-Mi-Maestro-libro.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Juegos insolentes 2' AND Autor = 'Emma Green') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Juegos insolentes 2', 'Emma Green', NULL, v_42, '0 Juegos_insolentes_2_Emma_Green57ee.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '(Principe 01) Mi error fue amar al príncipe' AND Autor = 'Moruena Estríngana') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('(Principe 01) Mi error fue amar al príncipe', 'Moruena Estríngana', NULL, v_42, '1. Mi error fue amar al príncipe .pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'La mente despierta' AND Autor = 'Dalai Lama') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('La mente despierta', 'Dalai Lama', NULL, v_42, '_dalai_lama_La_mente_despierta.pdf_filename_= UTF-8_28dalai_20lama_29_20La_20mente_20despierta.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Dungeon ni Deai wo Motomeru no wa Machigatteiru Darou ka' AND Autor = 'carlos') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Dungeon ni Deai wo Motomeru no wa Machigatteiru Darou ka', 'carlos', 'Dungeon ni Deai o Motomeru no wa Machigatteiru Darō ka (ダンジョンに出会いを求めるのは間違っているだろうか, lit. ¿Está mal querer tener un encuentro en una mazmorra??), también conocido como ¿Está mal seducir chicas en un calabozo? o  ¿Qué tiene de malo intentar ligar en una mazmorra? y varias veces abreviado como DanMachi (ダンまち, ''''DanMachi''''?), es una serie de novelas ligeras escritas por Fujino Ōmori e ilustradas por Suzuhito Yasuda. SB Creative ha publicado veintiuno volúmenes desde enero de 2013 bajo el sello de GA Bunko. Ha recibido una serie de spin-offs de la novela ligera y tres adaptaciones al manga. Una adaptación al anime, a cargo del estudio J.C.Staff, salió al aire desde el 4 de abril hasta el 27 de junio de 2015.
Ha sido la novela ligera más votada por los fanes en los premios Sugoi Japan Awards de la edición de 2016. En estos premios, los fanáticos deciden qué anime, manga, novela es la más indicada para ser comercializada en el mercado internacional.​', v_135, '[K-VT] Dungeon Vol. 10.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¿Qué hablo con mis hijos sobre drogas? (Dialogar Para Prevenir) (Spanish Edition)' AND Autor = 'José Antonio Molina del Peral') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¿Qué hablo con mis hijos sobre drogas? (Dialogar Para Prevenir) (Spanish Edition)', 'José Antonio Molina del Peral', NULL, v_42, '¿Qué hablo con mis hijos sobre drogas. Dialogar para prevenir.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Teme' AND Autor = 'Lisa McMann') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Teme', 'Lisa McMann', 'Para Janie y Cabel la vida real se está poniendo mucho más difícil que los sueños. Ambos están tratando conseguir un poco de tiempo para poder estar juntos (en secreto) pero no están teniendo suerte. Y, por si fuera poco, algo extraño está pasando en el instituto Fieldridge, aunque nadie se atreve a hablar sobre ello. Cuando Janie entra en las violentas pesadillas de una compañera de clase, todo empieza a tener sentido, pero nada sale como lo habían planeado. Ni mucho menos. Janie siente que las cosas no van bien en su cabeza y el escandaloso comportamiento de Cabe tiene grave consecuencias para ambos. Y lo que es peor aún, Janie ha descubierto toda la verdad sobre sí misma y su especial habilidad. Y es una verdad desoladora y brutal, que no solo sella su destino como Cazadora de Sueños sino que hace que lo que está por venir sea más oscuro de lo que jamás se hubiera podido imaginar. ¿Crees que estás solo en tus sueños? No es cierto, no si yo estoy cerca. No es tu voluntad ni la mía sino una especie de maldición de la que no puedo escapar. Nadie puede ayudarme. Al menos eso pensaba hasta que Cabel llegó a mi vida. No estoy segura de quién es, no sé si puedo confiar en él, pero para mi corazón es demasiado tarde.Para Janie y Cabel la vida real se está poniendo mucho más difícil que los sueños. Ambos están tratando conseguir un poco de tiempo para poder estar juntos (en secreto) pero no están teniendo suerte. Y, por si fuera poco, algo extraño está pasando en el instituto Fieldridge, aunque nadie se atreve a hablar sobre ello. Cuando Janie entra en las violentas pesadillas de una compañera de clase, todo empieza a tener sentido, pero nada sale como lo habían planeado. Ni mucho menos. Janie siente que las cosas no van bien en su cabeza y el escandaloso comportamiento de Cabe tiene grave consecuencias para ambos. Y lo que es peor aún, Janie ha descubierto toda la verdad sobre sí misma y su especial habilidad. Y es una verdad desoladora y brutal, que no solo sella su destino como Cazadora de Sueños sino que hace que lo que está por venir sea más oscuro de lo que jamás se hubiera podido imaginar. ¿Crees que estás solo en tus sueños? No es cierto, no si yo estoy cerca. No es tu voluntad ni la mía sino una especie de maldición de la que no puedo escapar. Nadie puede ayudarme. Al menos eso pensaba hasta que Cabel llegó a mi vida. No estoy segura de quién es, no sé si puedo confiar en él, pero para mi corazón es demasiado tarde.', v_168, '2. Teme - Lisa McMann.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'lA VIDA QUE SUEÑAS' AND Autor = 'M CARMEN FERNANDEZ MAYORALAS') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('lA VIDA QUE SUEÑAS', 'M CARMEN FERNANDEZ MAYORALAS', NULL, v_42, '1_5059811468594119030.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¡Despierta!... que la vida sigue' AND Autor = 'César Lozano') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¡Despierta!... que la vida sigue', 'César Lozano', 'En este libro el Dr. César Lozano nos invita a tratar de ser felices y disfrutar de la vida, incluso de los más pequeños detalles Del autor bestseller de Por el placer de vivir, Destellos, El lado fácil de la gente difícil. César Lozano ha motivado a más de 20 millones de personas en el mundo. Reflexiones para disfrutar plenamente la vida. Esta es una obra en la que el Dr. César Lozano nos exhorta a valorar lo que tenemos; es un reconocimiento de que nuestra vida es breve y pasajera pero que, para aquellos que tenemos esperanza, siempre nos lleva al verdadero despertar. ¡Despierta!... que la vida sigue ofrece valiosas fórmulas y técnicas que te sacudirán para que no te quedes enredado en tus problemas y disfrutes de los mejores momentos de tu vida: una sonrisa de tus hijos, la caricia de un ser querido, la alegría de hacer algo por alguien desconocido. Después de leer este libro, tus relaciones tendrán un nuevo sentido y habrás encontrado la verdadera motivación para fijar sentirte feliz.', v_194, '¡Despierta!. que la vida sigue_ Reflexiones para disfrutar plenamente de la vida - César Lozano.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'LA MEJOR BODA……KAREN TEMPLENTON' AND Autor = 'mj') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('LA MEJOR BODA……KAREN TEMPLENTON', 'mj', NULL, v_42, '1_5062446538404397362.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '5024155560635794111' AND Autor = 'Desconocido') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('5024155560635794111', 'Desconocido', NULL, v_42, '1_5024155560635794111.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El Arte del Terror - Volumen 2' AND Autor = 'CROWVOX, CÉSAR COSTA, CARLOS HENRIQUE FERNANDES GOMES, E. N. ANDRADE, FABY CRYSTALL, JEFF LONDON, K.H.A.O.S, LARISSA PRADO, LUCAS SOUZA, OSCAR MENDES FILHO, PEDRO TEIXEIRA, RICARDO LOHEM, RONALDO COSTA') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El Arte del Terror - Volumen 2', 'CROWVOX, CÉSAR COSTA, CARLOS HENRIQUE FERNANDES GOMES, E. N. ANDRADE, FABY CRYSTALL, JEFF LONDON, K.H.A.O.S, LARISSA PRADO, LUCAS SOUZA, OSCAR MENDES FILHO, PEDRO TEIXEIRA, RICARDO LOHEM, RONALDO COSTA', NULL, v_42, '_Arte_del_Terror_-_Volumen_2_-_VVAA.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '84 RECETAS PARA PREPARAR COMIDA RÁPIDA: Incluye los secretos para preparar las comidas rápidas más famosas del mundo (Colección Cocina Práctica) (Spanish Edition)' AND Autor = 'Mariano Orzola') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('84 RECETAS PARA PREPARAR COMIDA RÁPIDA: Incluye los secretos para preparar las comidas rápidas más famosas del mundo (Colección Cocina Práctica) (Spanish Edition)', 'Mariano Orzola', NULL, v_42, '05-DULCES-CASEROS.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Dungeon ni Deai wo Motomeru no wa Machigatteiru Darou ka' AND Autor = 'carlos') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Dungeon ni Deai wo Motomeru no wa Machigatteiru Darou ka', 'carlos', 'Dungeon ni Deai o Motomeru no wa Machigatteiru Darō ka (ダンジョンに出会いを求めるのは間違っているだろうか, lit. ¿Está mal querer tener un encuentro en una mazmorra??), también conocido como ¿Está mal seducir chicas en un calabozo? o  ¿Qué tiene de malo intentar ligar en una mazmorra? y varias veces abreviado como DanMachi (ダンまち, ''''DanMachi''''?), es una serie de novelas ligeras escritas por Fujino Ōmori e ilustradas por Suzuhito Yasuda. SB Creative ha publicado veintiuno volúmenes desde enero de 2013 bajo el sello de GA Bunko. Ha recibido una serie de spin-offs de la novela ligera y tres adaptaciones al manga. Una adaptación al anime, a cargo del estudio J.C.Staff, salió al aire desde el 4 de abril hasta el 27 de junio de 2015.
Ha sido la novela ligera más votada por los fanes en los premios Sugoi Japan Awards de la edición de 2016. En estos premios, los fanáticos deciden qué anime, manga, novela es la más indicada para ser comercializada en el mercado internacional.​', v_135, '[K-VT] Dungeon Vol. 06.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El cardenal Napellus' AND Autor = 'Gustav Meyrink') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El cardenal Napellus', 'Gustav Meyrink', NULL, v_42, '03 Gustav Meyrink - El cardenal Napeluz .pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Finale Carta Perdida de Patch' AND Autor = 'ROBYLAP') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Finale Carta Perdida de Patch', 'ROBYLAP', NULL, v_42, '05.- Finale Carta Perdida de Patch - Becca Fitzpatrick.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Todas Nuestras Vidas (Libro Luna 3) (Spanish Edition)' AND Autor = 'Violet Haze') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Todas Nuestras Vidas (Libro Luna 3) (Spanish Edition)', 'Violet Haze', NULL, v_42, '3.Trilogía Luna - Violet Haze🐬🥀🍀🍂🐬.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El libro de los amores ridículos' AND Autor = 'Milan Kundera') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El libro de los amores ridículos', 'Milan Kundera', 'El libro de los amores ridículos (en checo, Směšné lásky) es un relato del escritor checo Milan Kundera, publicada en 1968.
Se trata de una obra que relata una serie de relaciones amorosas ambientadas en Praga. Esta obra, al igual que el resto de obras del autor, narra distintas relaciones amorosas a través de un humor sabio y un tinte filosófico.

Con esta obra, Milan Kundera hace reflexionar sobre los contradictorios juegos del amor, el sexo y la amistad.', v_42, '1_5006304388063428858.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El jefe' AND Autor = 'Victoria Quinn') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El jefe', 'Victoria Quinn', 'Emanuel Herrera Batista (Bajos de Haina, Provincia de San Cristóbal, 18 de diciembre de 1990) conocido artísticamente como el Alfa, es un cantante dominicano.​ Su música principalmente es dembow dominicano, aunque también hace y utiliza otros ritmos urbanos latinos.​​', v_98, '1. El hijo del jefe - Sierra Rose.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¿Te casarías con mi papá' AND Autor = 'BECKY1SV') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¿Te casarías con mi papá', 'BECKY1SV', NULL, v_42, '_Te casarias con mi papa - BECKY1SV.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Súper bebés!' AND Autor = 'Desconocido') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Súper bebés!', 'Desconocido', 'Irrepressible friends George and Harold create a new comic book superhero, Super Diaper Baby.', v_42, '¡Súper bebés!.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Darkest flame' AND Autor = 'Mª de NURIA RODRÍGUEZ MATÍAS') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Darkest flame', 'Mª de NURIA RODRÍGUEZ MATÍAS', NULL, v_42, '01 - Darkest flame.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Sexo 4.0' AND Autor = 'Valérie Tasso') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Sexo 4.0', 'Valérie Tasso', NULL, v_42, '_Tasso_Val_rie_Sexo_4_0_Temas_de_Hoy_.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Diablo' AND Autor = 'Stephanie Laurens') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Diablo', 'Stephanie Laurens', 'Las fans de la serie Cynster disfrutarán de esta apasionate novela, que como las demás se puede leer de forma independiente. Primera entrega de la saga romántica «Cynster». ¿Era el marido que siempre había soñado, o un verdadero demonio? Honoria Wetherby es institutriz, pero tiene otros proyectos: vivir aventuras, conocer mundo... aunque lo inesperado puede cambiar drásticamente hasta los mejores planes. Su intento de ayudar a un moribundo la lleva a pasar la noche en una cabaña solitaria en compañía del miembro más denostado de los Cynster, a quien llaman Diablo. Cuando esto sale a la luz, él no tiene otro remedio que pedir su mano. La familia Cynster está encantada de que el famoso libertino finalmente decida casarse, pero lo que menos desea la rebelde joven es un marido que la controle, y enamorarse no está en sus planes.', v_37, '✮Terror 05 - Carrados, Clark - Propiedad del Diablo.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Ho''oponopono, la Vida es Amor: Sentir, perdonar, agradecer y amar (Spanish Edition)' AND Autor = 'Isabel Feliciano') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Ho''oponopono, la Vida es Amor: Sentir, perdonar, agradecer y amar (Spanish Edition)', 'Isabel Feliciano', NULL, v_42, '1_5035110793847243040.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Dulce pecado (Memento Mori nº 3)' AND Autor = 'Nerea Vara') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Dulce pecado (Memento Mori nº 3)', 'Nerea Vara', NULL, v_42, '_3.Dulce•Pecado(M.M.)-Nerea_Vara.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'magia demoniaca grimorio' AND Autor = 'Luca Iovio@ETR-555') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('magia demoniaca grimorio', 'Luca Iovio@ETR-555', NULL, v_42, '_Grimorio Demoniaco.pdf.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Salvada por ti' AND Autor = 'Maya Banks') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Salvada por ti', 'Maya Banks', NULL, v_42, '1 Salvada por ti.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Una decisión difícil' AND Autor = 'Lola Barnon') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Una decisión difícil', 'Lola Barnon', NULL, v_42, '2 Una decision dificil - Lola Barnon.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'EL YOGA como MED 4' AND Autor = 'bartolome') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('EL YOGA como MED 4', 'bartolome', NULL, v_42, '1_4994500151486710089.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Ochenta melodias de pasion en amarillo de Vina Jackson' AND Autor = 'MIRIAM') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Ochenta melodias de pasion en amarillo de Vina Jackson', 'MIRIAM', NULL, v_42, '01 ♥ Ochenta melodias de pasion en amarillo de Vina Jackson.pdf · versión 1.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'estrategiaymenteres.doc' AND Autor = 'Carlos Martín Pérez') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('estrategiaymenteres.doc', 'Carlos Martín Pérez', NULL, v_42, '_estrategia_y_mente-1.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Macabra sugestión' AND Autor = 'Peter Kapra') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Macabra sugestión', 'Peter Kapra', NULL, v_42, '✮Terror 24 - Kapra, Peter - Macabra sugestion.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Suya, cuerpo y alma - Volumen 6 (Spanish Edition)' AND Autor = 'Dean, Olivia') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Suya, cuerpo y alma - Volumen 6 (Spanish Edition)', 'Dean, Olivia', NULL, v_42, '6 - Suya, cuerpo y alma - Olivia Dean.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Mister' AND Autor = 'E.L. James') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Mister', 'E.L. James', NULL, v_42, '(Versión Buena) Mister-E.L.James.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'CONVERSACIONES CON DIOS' AND Autor = 'Fernando Vargas García') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('CONVERSACIONES CON DIOS', 'Fernando Vargas García', 'Conversaciones con Dios es el nombre de una serie de libros escrita por Neale Donald Walsch. Desde el lanzamiento del primer libro en 1995 han tenido un gran éxito convirtiéndose en superventas. Publishers Weekly publicó que este primer libro permaneció en la lista de los más vendidos durante 137 semanas. Cada libro ha sido escrito como un diálogo en el que el autor conversa con Dios. Walsch asegura que este diálogo está realmente inspirado por Dios.​
La serie completa consta de más de 3.000 páginas en las que se tratan muchos temas (como la vida, la muerte, el amor, el sexo, la paternidad, la salud, la educación, la economía, la política, la espiritualidad, la religión, el trabajo, la física, el tiempo, las tradiciones, el proceso de la creación, nuestra relación con Dios, la ecología, el crimen, el castigo, la vida en las sociedades muy desarrolladas del cosmos, el bien y el mal, los mitos culturales,la naturaleza del amor genuino, etc.)', v_42, '01-CONVERSACIONES CON DIOS 1.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Thunder Thighs' AND Autor = 'Jimena Castillo') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Thunder Thighs', 'Jimena Castillo', NULL, v_208, '1. Thunder Thighs.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¿Sería mi esposa, señorita? (Mi señorita nº 2) (Spanish Edition)' AND Autor = 'Javiera Bielefeldt') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¿Sería mi esposa, señorita? (Mi señorita nº 2) (Spanish Edition)', 'Javiera Bielefeldt', NULL, v_42, '_Seria mi esposa senorita_ Mi - Javiera Bielefeldt.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Dungeon Vol. 01' AND Autor = 'Desconocido') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Dungeon Vol. 01', 'Desconocido', 'The planet Terra Amata had stopped turning, on one side is total darkness and coldness, on the other is a searing desert and eternal day. The survivors live on a thin slice of earth where day and night meet, known as Twilight. Marvin, old and blind, goes on a long trek to the legendary cemetery of dragons.', v_222, '[K-VT] Dungeon Vol. 01.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Una criminal: Culpable' AND Autor = 'Kris Buendia') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Una criminal: Culpable', 'Kris Buendia', NULL, v_42, '1. Una Criminal Culpable.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'La cabeza del muerto' AND Autor = 'Clark Carrados') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('La cabeza del muerto', 'Clark Carrados', NULL, v_42, '✮Terror 11 - Carrados, Clark - La cabeza del muerto.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Mated To The Cyborgs' AND Autor = 'Alumno') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Mated To The Cyborgs', 'Alumno', NULL, v_42, '2. Mated To The Cyborgs.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El anticristo' AND Autor = 'Friedrich Nietzsche') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El anticristo', 'Friedrich Nietzsche', 'El Anticristo, maldición sobre el cristianismo (Der Antichrist, Fluch auf das Christentum) es una de las últimas obras del filósofo alemán Friedrich Nietzsche. Aunque fue escrito en 1888, su controvertido contenido hizo que Franz Overbeck y Heinrich Köselitz retrasaran su publicación, junto con Ecce homo, hasta 1895.​ El libro es una crítica del cristianismo en conjunto, y de conceptos modernos como el igualitarismo y la democracia, a los cuales ve como consecuencia persistente de los ideales cristianos.', v_65, ',,,,el Anticristo.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¡ATENCIÓN!: Ideas útiles y consejos prácticos para prevenir y enfrentar la inseguridad (Spanish Edition)' AND Autor = 'Paola Spatola') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¡ATENCIÓN!: Ideas útiles y consejos prácticos para prevenir y enfrentar la inseguridad (Spanish Edition)', 'Paola Spatola', NULL, v_42, '¡ATENCIÓN! Ideas útiles y consejos prácticos para prevenir y enfrentar la inseguridad.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'EL HORROR OCULTO' AND Autor = 'kr0n0') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('EL HORROR OCULTO', 'kr0n0', NULL, v_42, '1_5024155560635794114.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Te amaré por siempre (La chica de mis sueño nº 2) (Spanish Edition)' AND Autor = 'Indhira Jacobo') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Te amaré por siempre (La chica de mis sueño nº 2) (Spanish Edition)', 'Indhira Jacobo', NULL, v_42, '2- Te amare por Siempre - Indhira Jacobo - (La chica de mis sueños  ).pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '04' AND Autor = 'Rodríguez Matías, María Nuria') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('04', 'Rodríguez Matías, María Nuria', NULL, v_42, '0.04 - Dark Heat.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Los caminos del recuerdo' AND Autor = 'Robert James Waller') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Los caminos del recuerdo', 'Robert James Waller', NULL, v_42, '02.-Los-caminos-del-recuerdo-Robert-James-Waller.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'arte de hacer preguntas X' AND Autor = 'Desconocido') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('arte de hacer preguntas X', 'Desconocido', 'Quien desee mejorar sus negociaciones, dirigir equipos de trabajo, dominar entrevistas y ser exitoso en su profesión... debe leer este libro. Si quieres ser persuasivo para ganar negocios, cerrar grandes acuerdos, triunfar en tus entrevistas y en tu vida personal, este libro sin duda te ayudará a triunfar en ello. Aprende a utilizar técnicas de preguntas que te ayudarán a descubrir el pensamiento oculto en la mente de las demás personas. En El arte de hacer preguntas descubrirás el secreto de hacer preguntas de alto nivel para descubrir información clave y ganar la batalla. Los buenos entrevistadores, reporteros, políticos, líderes y negociadores de alto calibre, usan información de la contraparte para convencer y cerrar los grandes acuerdos. El principio subyacente de mis técnicas de preguntas es que todas las personas tienen en su mente una visión de lo que quieren obtener en una entrevista y eso lo podrás aprender en este libro. Ya que si la descubres podrás usarla como poder de persuasión para lograr tu objetivo. Los grandes líderes dirigen aplicando preguntas de alto impacto. Utilizan lo que saben articulándolo con preguntas inteligentes. El gran negociador, el político eficaz o el entrevistador profesional nunca muestran sus cartas, sino que a través de preguntas persuasivas acometen y logran su objetivo con la información que disponen de la contraparte.', v_4, '_arte de hacer preguntas X-1-1.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'A de' AND Autor = 'adulterio') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('A de', 'adulterio', 'A de adulterio es el estreno de la escritora Sue Grafton en la serie de novelas de misterio protagonizada por Kinsey Millhone Alfabeto del crimen, publicada por primera vez en 1982. El libro se sitúa en la ciudad ficticia de Santa Teresa, inspirada en Santa Bárbara, al sur de California, en Estados Unidos. Grafton admite haber concebido la historia tras "fantasear" con asesinar a su exesposo mientras vivían el proceso de divorcio. La idea de asesinar sustituyendo el contenido de una caja de antihistamínicos por adelfa machacada significaba que una coartada carecía de valor, ya que el contenido de la tableta podría haber sido cambiado mucho antes de que la víctima llegara a ingerirlas.
La primera edición de A de adulterio fue de 7.500 copias, con un total de ventas de aproximadamente 6.000.​
​
​', v_71, '1A_de_adulterio.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El dilema de Jules' AND Autor = 'Amy Plum') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El dilema de Jules', 'Amy Plum', NULL, v_42, '✩✿El dilema de Jules (Ravenants ²_⁵) - Amy Plum★M🌸.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Dark Alpha_s Lover (fintan)' AND Autor = 'Mª de NURIA RODRÍGUEZ MATÍAS') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Dark Alpha_s Lover (fintan)', 'Mª de NURIA RODRÍGUEZ MATÍAS', NULL, v_42, '04 - Dark Alpha_s Lover (fintan).pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Ochenta melodías de pasión en azul (Grandes Novelas) (Spanish Edition)' AND Autor = 'Jackson, Vina') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Ochenta melodías de pasión en azul (Grandes Novelas) (Spanish Edition)', 'Jackson, Vina', NULL, v_42, '02 ♥ Ochenta melodias de pasion en azul de Vina Jackson.pdf · versión 1.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Aquí dentro siempre llueve (Spanish Edition)' AND Autor = 'Chris Pueyo') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Aquí dentro siempre llueve (Spanish Edition)', 'Chris Pueyo', NULL, v_42, '✩✿Aqui Dentro Siempre Llueve-Pueyo Chris ★M🌸.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¿Depresion? No, Gracias' AND Autor = 'Juan Antonio Guerrero Cañongo') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¿Depresion? No, Gracias', 'Juan Antonio Guerrero Cañongo', NULL, v_42, '_Depresion_ No, Gracias - Juan Antonio Guerrero Canongo.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Dungeon ni Deai wo Motomeru no wa Machigatteiru Darou ka' AND Autor = 'carlos') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Dungeon ni Deai wo Motomeru no wa Machigatteiru Darou ka', 'carlos', 'Dungeon ni Deai o Motomeru no wa Machigatteiru Darō ka (ダンジョンに出会いを求めるのは間違っているだろうか, lit. ¿Está mal querer tener un encuentro en una mazmorra??), también conocido como ¿Está mal seducir chicas en un calabozo? o  ¿Qué tiene de malo intentar ligar en una mazmorra? y varias veces abreviado como DanMachi (ダンまち, ''''DanMachi''''?), es una serie de novelas ligeras escritas por Fujino Ōmori e ilustradas por Suzuhito Yasuda. SB Creative ha publicado veintiuno volúmenes desde enero de 2013 bajo el sello de GA Bunko. Ha recibido una serie de spin-offs de la novela ligera y tres adaptaciones al manga. Una adaptación al anime, a cargo del estudio J.C.Staff, salió al aire desde el 4 de abril hasta el 27 de junio de 2015.
Ha sido la novela ligera más votada por los fanes en los premios Sugoi Japan Awards de la edición de 2016. En estos premios, los fanáticos deciden qué anime, manga, novela es la más indicada para ser comercializada en el mercado internacional.​', v_135, '[K-VT] Dungeon Vol. 07.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Beautiful Stranger' AND Autor = 'Desconocido') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Beautiful Stranger', 'Desconocido', 'Beautiful Stranger by Ruth Wind released on May 25, 2000 is available now for purchase.', v_210, '2-Beautiful Stranger.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¿Amar o depender?: cómo superar el apego afectivo y hacer del amor una experiencia plena y saludable (Biblioteca Walter Riso) (Spanish Edition)' AND Autor = 'Walter Riso') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¿Amar o depender?: cómo superar el apego afectivo y hacer del amor una experiencia plena y saludable (Biblioteca Walter Riso) (Spanish Edition)', 'Walter Riso', NULL, v_42, '_Amar o depender_ - Walter Riso.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Lazos de Amor' AND Autor = 'Air Liquide Argentina S.A.') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Lazos de Amor', 'Air Liquide Argentina S.A.', NULL, v_42, '✓Lazos de Amor-Brian Weiss.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Alpha' AND Autor = 'Angie Rossi') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Alpha', 'Angie Rossi', NULL, v_42, '1 Alpha - Angie Rossi.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Ho''oponopono (Spanish Edition)' AND Autor = 'María Soledad Miranda Eguiluz') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Ho''oponopono (Spanish Edition)', 'María Soledad Miranda Eguiluz', NULL, v_42, '1_5035110793847243039.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Y de postre' AND Autor = 'Zamzar') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Y de postre', 'Zamzar', NULL, v_42, '¿Y de postre - Merche Diolch.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'c4d8170-21ec-45ba-9b18-b6c17e8616af' AND Autor = 'Alumno') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('c4d8170-21ec-45ba-9b18-b6c17e8616af', 'Alumno', NULL, v_42, '5c4d8170-21ec-45ba-9b18-b6c17e8616af.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Como Hacer que las Cosas Pasen' AND Autor = 'Desconocido') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Como Hacer que las Cosas Pasen', 'Desconocido', '"Cómo hacer que las cosas pasen, en lugar de vivir hablando de lo que pasa. Personal Coaching personal para vencer el miedo y realizar los sueños Si deseas que empiece a pasar algo diferente en tu vida, este libro es para ti. No importa a qué te dediques o cuál sea tu edad y formación. Para hacer que las cosas pasen debes entrenarte a fin de ser más grande que tus desafíos y así poder: -Tratar con personas difíciles -Decir de manera constructiva cosas a priori incómodas -Crecer profesionalmente aunque no reconozcan tu valía -Superar el autoboicot y la postergación -Convertir imprevistos enoportunidades -Rehacer tu vida y construir un futuro que te apasione -Cambiar más rápido y con menos estrés -Inspirarte para dar la mejor versión de ti mismo En calidad de conferenciante, Guillermo Echevarría ha sido invitado por instituciones como las universidades de Buenos Aires, Argentina de la Empresa (UADE),San Andrés, del Centro de Estudios Macroeconómicos de Argentina (CEMA) o de Ciencias Empresariales y Sociales (UCES), así como por el Instituto de Altos Estudios Empresariales (IAE). Como responsable de áreas de capacitación y desarrollo, coordinó programas de Calidad Total y Mejora Continua de la Calidad. Asimismo, entrena directivos en habilidades de liderazgo, negociación, oratoria, supervisión y estrategia y se ha desempeñado como orador motivacional en varios países de América y de Europa, principalmente España, donde ha formado coaches e impartido seminarios en muchas de sus provincias."', v_230, '_Como Hacer que las Cosas Pasen.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Impulse' AND Autor = 'Deborah Bladon') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Impulse', 'Deborah Bladon', 'IMPULSE should be read after the complete PULSE series, which is available now. From New York Times and USA Today Bestseller author, Deborah Bladon, the continuing story of Nathan and Jessica. Nathan Moore had everything any man could ever dream of. He was a successful attorney in Manhattan, he was in love with the woman of his dreams and he could see his future planned out before him. All of that changed when he took a trip into his girlfriend''s past. Jessica Roth has only shared the details of her life that she wanted Nathan to know. She''s been careful and diligent in presenting a past that she believes will help her fit into his future. She doesn''t realize that he''s about to discover the one secret that she''s worked hard to hide for the past six years. He can''t let anything come between them. She won''t let him love her the way he needs to. Will they be able to finally have the happily-ever-after they deserve?', v_7, '05 Impulse - Deborah Bladon.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Indetenibles: 365 Reflexiones sólo para Indetenibles (Spanish Edition)' AND Autor = 'Yesenia Then') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Indetenibles: 365 Reflexiones sólo para Indetenibles (Spanish Edition)', 'Yesenia Then', NULL, v_42, '_ Yesenia Then Reflex. Indetenibles.pdf · versión 1.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Atrapada en el pasado' AND Autor = 'Lucy Gordon') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Atrapada en el pasado', 'Lucy Gordon', NULL, v_42, '1_5059811468594118969.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Kian' AND Autor = 'gargol traduc') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Kian', 'gargol traduc', NULL, v_42, '01 Kian - Callie Rhodes.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Aprende como Einstein : Técnicas prohibidas de persuasión manipulación e influencia usando patrones de lenguaje y técnicas de PN' AND Autor = 'Allen, Steve') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Aprende como Einstein : Técnicas prohibidas de persuasión manipulación e influencia usando patrones de lenguaje y técnicas de PN', 'Allen, Steve', NULL, v_42, '_Allen_Steve_Técnicas_prohibidas_de_persuasión_manipulación_e_influencia.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Thankful For Her-Alexa Riley' AND Autor = 'usuario') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Thankful For Her-Alexa Riley', 'usuario', NULL, v_42, '01 Thankful For Her-Alexa Riley.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El retorno' AND Autor = 'Kathryn Taylor') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El retorno', 'Kathryn Taylor', 'El Retorno es un municipio colombiano ubicado en el departamento del Guaviare, en la Región de la Amazonía. Dista de Bogotá (la capital del país) 420 km.', v_42, '03 ʕ·ᴥ·ʔ El retorno ✿.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Atrapada por el ALFA' AND Autor = 'Lena Relish') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Atrapada por el ALFA', 'Lena Relish', NULL, v_42, '4_5886702061596182873.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¿Sería mi esposa, señorita? (Mi señorita nº 2) (Spanish Edition)' AND Autor = 'Javiera Bielefeldt') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¿Sería mi esposa, señorita? (Mi señorita nº 2) (Spanish Edition)', 'Javiera Bielefeldt', NULL, v_42, '_Seria mi esposa, senorita_ (Mi - Javiera Bielefeldt-1.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Romance entre jefes' AND Autor = 'Victoria Quinn') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Romance entre jefes', 'Victoria Quinn', NULL, v_98, '6.Romance entre jefes.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Come comida real (Spanish Edition)' AND Autor = 'Ríos, Carlos') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Come comida real (Spanish Edition)', 'Ríos, Carlos', NULL, v_42, '_Come Comida Real.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El Arte del Terror - Volumen 3' AND Autor = 'Elemental Editoração') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El Arte del Terror - Volumen 3', 'Elemental Editoração', NULL, v_42, '_Arte del terror-_Volumen_3_-_Elemental_Editoracao.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Cuentos descorteses' AND Autor = 'Léon Bloy') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Cuentos descorteses', 'Léon Bloy', NULL, v_42, '04 Leon Bloyd - Cuentos descorteses .pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Her Cyborg Beast' AND Autor = 'Alumno') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Her Cyborg Beast', 'Alumno', NULL, v_42, '4. Her Cyborg Beast.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Tyler' AND Autor = 'MACARUBE') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Tyler', 'MACARUBE', NULL, v_42, '03. Tyler.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Suya, cuerpo y alma' AND Autor = 'Olivia Dean') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Suya, cuerpo y alma', 'Olivia Dean', NULL, v_42, '1 - Suya, cuerpo y alma  - Olivia Dean.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Quién se ha llevado mi queso' AND Autor = 'Spencer Johnson') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Quién se ha llevado mi queso', 'Spencer Johnson', '¿Quién se ha llevado mi queso? Una manera sorprendente de afrontar el cambio en el trabajo y en la vida privada (en inglés: Who Moved My Cheese? An Amazing Way to Deal with Change in Your Work and in Your Life), publicado en 1998, es un libro de motivación escrito por el estadounidense Spencer Johnson en el estilo de una parábola y alegoria.
Describe el cambio en el trabajo y la vida, y cuatro típicas reacciones (resistirse al cambio por miedo a algo peor, aprender a adaptarse cuando se comprende que el cambio puede conducir a algo mejor, detectar pronto el cambio y finalmente apresurarse hacia la acción) al citado cambio con dos ratones, dos "liliputienses", y sus búsquedas de queso. Un superventas empresarial de New York Times desde el lanzamiento, ¿Quién se ha llevado mi queso? permaneció en la lista por casi cinco años y pasó en torno a doscientas semanas en la lista de no ficción de pasta dura de Publishers Weekly.​', v_114, '__Quien se ha llevado mi queso.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Dark Alpha_s Hunger (Eoghan)' AND Autor = 'Mª de NURIA RODRÍGUEZ MATÍAS') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Dark Alpha_s Hunger (Eoghan)', 'Mª de NURIA RODRÍGUEZ MATÍAS', NULL, v_42, '06 - Dark Alpha_s Hunger (Eoghan).pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Suya, cuerpo y alma' AND Autor = 'Olivia Dean') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Suya, cuerpo y alma', 'Olivia Dean', NULL, v_42, '2 - Suya, cuerpo y alma - Olivia Dean.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Mi error fue buscarte en otros brazos. Parte I (Spanish Edition)' AND Autor = 'Moruena Estríngana') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Mi error fue buscarte en otros brazos. Parte I (Spanish Edition)', 'Moruena Estríngana', NULL, v_42, '2. Mi error fue buscarte en otros brazos .pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El hombre light' AND Autor = 'Enrique Rojas') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El hombre light', 'Enrique Rojas', NULL, v_42, '_El Hombre Light.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Diapositiva 1' AND Autor = 'raquel') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Diapositiva 1', 'raquel', NULL, v_42, '¡A la cama monstruitos!.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Muñequita' AND Autor = 'Lori Beasley Bradley') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Muñequita', 'Lori Beasley Bradley', NULL, v_42, '1_5059811468594119036.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Redención (Placeres prohibidos nº 4) (Spanish Edition)' AND Autor = 'Adrian Blake') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Redención (Placeres prohibidos nº 4) (Spanish Edition)', 'Adrian Blake', NULL, v_42, '4. Redención.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Angel' AND Autor = 'Sarah Brianne') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Angel', 'Sarah Brianne', 'Un ángel es un ser sobrenatural presente en varias religiones y mitologías, cuya función principal es servir a una deidad suprema. Sus funciones y especificaciones varían según cada cultura. La rama de la teología que se especializa en  los ángeles se denomina angelología.
Las religiones monoteístas muchas veces representan a los ángeles como seres celestiales benevolentes que actúan como intermediarios entre Dios y la humanidad.
En el catolicismo se habla del ángel de la guarda o del custodio, que sería aquel que Dios tiene señalado a cada persona para protegerla. Por contraposición, también se tiene la figura del ángel caído, aquel que ha sido expulsado del cielo por desobedecer o rebelarse contra Dios. Los ángeles más conocidos en las tradiciones judeocristianas son: San Miguel, San Gabriel y San Rafael.', v_99, '_Quien mato a Angela Blanco_ - Adrian Aragon.pdf · versión 1.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'cbfe051-c0ba-41c0-bc69-a22e6e4e02ef' AND Autor = 'Alumno') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('cbfe051-c0ba-41c0-bc69-a22e6e4e02ef', 'Alumno', NULL, v_42, '0cbfe051-c0ba-41c0-bc69-a22e6e4e02ef.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¿De qué vas, princeso?' AND Autor = 'Rosario Martín Martínez') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¿De qué vas, princeso?', 'Rosario Martín Martínez', NULL, v_42, '_De que vas, princeso_ - Rosario Martin Martinez.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Suya, cuerpo y alma - Volumen 5' AND Autor = 'Olivia Dean') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Suya, cuerpo y alma - Volumen 5', 'Olivia Dean', NULL, v_42, '5 - Suya, cuerpo y alma - Olivia Dean.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Madison Faye' AND Autor = 'CASA') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Madison Faye', 'CASA', NULL, v_42, '1 Madison Faye - Innocence Claimed - His Little Bad Girl.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Rey de diamantes: un romance de la mafia oscura' AND Autor = 'Renee Rose') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Rey de diamantes: un romance de la mafia oscura', 'Renee Rose', NULL, v_42, '1 Rey de diamantes (vegas clandestinas) - Renee Rose.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'En el momento justo' AND Autor = 'Chris de Wit') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('En el momento justo', 'Chris de Wit', NULL, v_42, '_  En el momento justo_._Chris de Wit.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Cuentos para pensar' AND Autor = 'Jorge Bucay') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Cuentos para pensar', 'Jorge Bucay', NULL, v_42, '1_5026138577101127900.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El pirata bien educado y sus amigos (Las Tres Edades)' AND Autor = 'Rafael Dezcallar') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El pirata bien educado y sus amigos (Las Tres Edades)', 'Rafael Dezcallar', NULL, v_42, '_ El Pirata Bien Educado Y Sus Amigos - Dezcallar Rafael -.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Nueva historia de la Guerra FrÃ­a' AND Autor = 'Gaddis, John Lewis(Author)') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Nueva historia de la Guerra FrÃ­a', 'Gaddis, John Lewis(Author)', 'Ensayo de interpretación histórica, donde el especialista en estrategias militares e historia de posguerra, John Lewis Gaddis emplea la información liberada en los años siguientes a la disolución del bloque soviético para ofrecer una nueva visión acerca de la Guerra Fría. El autor emplea en su exposición minutas de las reuniones del Politburo, información de los archivos, recientemente abiertos, de la Unión Soviética y Asia, conversaciones entre dirigentes oídas y anotadas por sus ayudantes y, sobre todo, las palabras de los protagonistas del conflicto.', v_42, '[Libro] NUEVA HISTORIA DE LA GUERRA FRÍA. Lewis Gaddis.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Liderazgo. El poder de la inteligencia emocional (EPUBS) (Spanish Edition)' AND Autor = 'Daniel Goleman') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Liderazgo. El poder de la inteligencia emocional (EPUBS) (Spanish Edition)', 'Daniel Goleman', NULL, v_42, '1_5159066509242269955.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El juego de las dudas' AND Autor = 'Luis Carranza Torres') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El juego de las dudas', 'Luis Carranza Torres', NULL, v_42, '1_5006073911528390825.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '5024155560635794103' AND Autor = 'Marina Cruz') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('5024155560635794103', 'Marina Cruz', NULL, v_42, '1_5024155560635794103.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¿Es éste mi marido? (Volumen independiente) (Spanish Edition)' AND Autor = 'Corín Tellado') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¿Es éste mi marido? (Volumen independiente) (Spanish Edition)', 'Corín Tellado', NULL, v_42, '_Es este mi marido_ (Volumen independiente) (Spanish Edition) - Corin Tellado-1.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '5006073911528390857' AND Autor = 'Desconocido') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('5006073911528390857', 'Desconocido', NULL, v_42, '1_5006073911528390857.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Ana, la de Ingleside' AND Autor = 'Administrador') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Ana, la de Ingleside', 'Administrador', 'Ana la de Ingleside es una novela juvenil escrita por la autora canadiense Lucy Maud Montgomery, publicada por primera vez en 1915.
Pertenece a la serie de libros de Ana de las Tejas Verdes, que relata la vida de una huérfana adoptada por una pareja de hermanos solterones que viven en una granja, en un pequeño pueblecito en la Isla del Príncipe Eduardo, en la costa de Canadá.
La novela es el sexto libro de la serie, sin embargo fue el último que se publicó.', v_62, '6.- Ana, la de Ingleside.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Sexys Cuentos de Hadas Al Rev?s: La Colecci?n Completa' AND Autor = 'AJ Tipton') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Sexys Cuentos de Hadas Al Rev?s: La Colecci?n Completa', 'AJ Tipton', NULL, v_42, '1_5017428258870788328.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Historia de la guerra' AND Autor = 'Parker, Geoffrey(Author)') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Historia de la guerra', 'Parker, Geoffrey(Author)', NULL, v_42, '[Libro] Historia de la Guerra. [Parker, Geoffrey, 2005].pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'arte de hacer preguntas X' AND Autor = 'Desconocido') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('arte de hacer preguntas X', 'Desconocido', 'Quien desee mejorar sus negociaciones, dirigir equipos de trabajo, dominar entrevistas y ser exitoso en su profesión... debe leer este libro. Si quieres ser persuasivo para ganar negocios, cerrar grandes acuerdos, triunfar en tus entrevistas y en tu vida personal, este libro sin duda te ayudará a triunfar en ello. Aprende a utilizar técnicas de preguntas que te ayudarán a descubrir el pensamiento oculto en la mente de las demás personas. En El arte de hacer preguntas descubrirás el secreto de hacer preguntas de alto nivel para descubrir información clave y ganar la batalla. Los buenos entrevistadores, reporteros, políticos, líderes y negociadores de alto calibre, usan información de la contraparte para convencer y cerrar los grandes acuerdos. El principio subyacente de mis técnicas de preguntas es que todas las personas tienen en su mente una visión de lo que quieren obtener en una entrevista y eso lo podrás aprender en este libro. Ya que si la descubres podrás usarla como poder de persuasión para lograr tu objetivo. Los grandes líderes dirigen aplicando preguntas de alto impacto. Utilizan lo que saben articulándolo con preguntas inteligentes. El gran negociador, el político eficaz o el entrevistador profesional nunca muestran sus cartas, sino que a través de preguntas persuasivas acometen y logran su objetivo con la información que disponen de la contraparte.', v_4, '_arte de hacer preguntas X.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Come Reza Ama' AND Autor = 'Elizabeth Gilbert') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Come Reza Ama', 'Elizabeth Gilbert', NULL, v_42, '__Comer, rezar, amar__ de Elizabeth Gilbert-1-1.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Muérdeme ★M🌸' AND Autor = 'Sistemas') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Muérdeme ★M🌸', 'Sistemas', NULL, v_42, '1 - Muérdeme ★M🌸.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'No me ames 2' AND Autor = 'Norah Carter & Monika Hoff & Patrick Norton') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('No me ames 2', 'Norah Carter & Monika Hoff & Patrick Norton', NULL, v_42, '02 NO ME AMES_NORAH CARTER.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Una decisión razonable' AND Autor = 'Lola Barnon') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Una decisión razonable', 'Lola Barnon', NULL, v_42, '3 Una decision razonable - Lola Barnon.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'La chica que leía novelas de amor' AND Autor = 'Ella Valentine') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('La chica que leía novelas de amor', 'Ella Valentine', NULL, v_42, '3 La chica que leia novelas de am - Ella Valentine.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Need you (You 2)' AND Autor = 'Estelle Maskame') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Need you (You 2)', 'Estelle Maskame', NULL, v_42, '4_5962859189033240714.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'La otra vida' AND Autor = 'Blanca Bravo') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('La otra vida', 'Blanca Bravo', NULL, v_42, '1_5006073911528390845.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'La calavera viviente' AND Autor = 'Ada Coretti') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('La calavera viviente', 'Ada Coretti', NULL, v_42, '_La calavera viviente - Coretti, Ada.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '5024155560635794106' AND Autor = 'Marina Cruz') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('5024155560635794106', 'Marina Cruz', NULL, v_42, '1_5024155560635794106.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'La hija de Frankenstein' AND Autor = 'Silver Kane') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('La hija de Frankenstein', 'Silver Kane', 'Santo contra la hija de Frankenstein es una película de terror, acción y ciencia ficción mexicana de 1971, dirigida por Miguel M. Delgado y protagonizada por El Santo, Gina Romand, Anel Noreña y Sonia Fuentes.​Esta película fue estrenada el 10 de agosto de 1972.', v_80, '✮Terror 25 - Kane, Silver - La hija de Frankenstein.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Los caprichos del millonario' AND Autor = 'Melissa Hall') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Los caprichos del millonario', 'Melissa Hall', NULL, v_42, '✰Los Cɑprichos Del Millonario✰⟪⍣Ɛʍყ G⍣⟫Melissa Hall.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¡Despierta!... que la vida sigue' AND Autor = 'César Lozano') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¡Despierta!... que la vida sigue', 'César Lozano', 'En este libro el Dr. César Lozano nos invita a tratar de ser felices y disfrutar de la vida, incluso de los más pequeños detalles Del autor bestseller de Por el placer de vivir, Destellos, El lado fácil de la gente difícil. César Lozano ha motivado a más de 20 millones de personas en el mundo. Reflexiones para disfrutar plenamente la vida. Esta es una obra en la que el Dr. César Lozano nos exhorta a valorar lo que tenemos; es un reconocimiento de que nuestra vida es breve y pasajera pero que, para aquellos que tenemos esperanza, siempre nos lleva al verdadero despertar. ¡Despierta!... que la vida sigue ofrece valiosas fórmulas y técnicas que te sacudirán para que no te quedes enredado en tus problemas y disfrutes de los mejores momentos de tu vida: una sonrisa de tus hijos, la caricia de un ser querido, la alegría de hacer algo por alguien desconocido. Después de leer este libro, tus relaciones tendrán un nuevo sentido y habrás encontrado la verdadera motivación para fijar sentirte feliz.', v_194, '¡Despierta!. que la vida sigue. Reflexiones para disfrutar plenamente de la vida.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Los cuerpos de la habitación roja' AND Autor = 'Iñigo Aguas') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Los cuerpos de la habitación roja', 'Iñigo Aguas', NULL, v_42, '1.Los cuerpos de la habitacion roja- Inigo Aguas.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Neurociencia' AND Autor = 'Desconocido') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Neurociencia', 'Desconocido', 'Los educadores, los científicos y los planificadores de la educación están cada vez más convencidos de que el campo de la Educación puede beneficiarse del conocimiento del cerebro. Sin embargo, los intentos de combinar la Neurociencia y la Educación se han visto con frecuencia obstaculizados por diferencias cruciales de conceptos, lenguaje y filosofía. En este libro, Paul Howard-Jones examina estas diferencias, basándose en las opiniones de educadores y científicos, para defender un nuevo campo de investigación: la Investigación Neuroeducativa. Investigación neuroeducativa tiende un puente significativo entre dos perspectivas distintas sobre el aprendizaje. Sostiene que ese puente puede servir a dos objetivos críticamente relacionados entre sí: debe enriquecer tanto la interpretación científica como la educativa. Este reto suscita unas cuestiones conceptuales, metodológicas y éticas excepcionales que caracterizarán, inevitablemente, este nuevo campo, y se examinarán e ilustrarán aquí a través de la investigación empírica. A lo largo del libro, Paul Howard-Jones examina los ''neuromitos'' y su influencia en el pensamiento educativo, destaca las oportunidades de combinar las pruebas biológicas, sociales y experienciales para comprender cómo aprendemos, defiende una ciencia natural de la educación basada en el conocimiento del cerebro, presenta con toda claridad el concepto de un enfoque neuroeducativo interdisciplinar, crea una metodología para desarrollar la investigación neuroeducativa y aprovecha los estudios monográficos de casos y los descubrimientos empíricos para mostrar cómo puede facilitar el enfoque neuroeducativo un cuadro más completo de nuestra forma de aprender. Este libro presenta un programa destinado a introducir nuestros conocimientos del cerebro en la educación, convirtiéndolo en lectura esencial para todas las personas interesadas por el aprendizaje humano en contextos reales: educadores, científicos y planificadores de la educación.', v_1, '_Neurociencia.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'TRONO DE CRISTAL. Micronovela 2: La asesina en el desierto (Ebook)' AND Autor = 'Maas, Sarah J.') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('TRONO DE CRISTAL. Micronovela 2: La asesina en el desierto (Ebook)', 'Maas, Sarah J.', NULL, v_42, '0.2 LADE, SJM.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Anhelo (Placeres prohibidos nº 3) (Spanish Edition)' AND Autor = 'Blake, Adrian') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Anhelo (Placeres prohibidos nº 3) (Spanish Edition)', 'Blake, Adrian', NULL, v_42, '3. Anhelo.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'La madrugada de los cadaveres' AND Autor = 'Curtis Garland') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('La madrugada de los cadaveres', 'Curtis Garland', NULL, v_42, '_La madrugada de los cadaveres - Garland, Curtis -.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Elaboración de Jabones Ar' AND Autor = 'DORELIRA') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Elaboración de Jabones Ar', 'DORELIRA', NULL, v_161, '04 - Jabones.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '101 RECETAS CRUDIVEGANAS PARA SOLUCIONARTE LA VIDA (Spanish Edition)' AND Autor = 'MORENO, ANA') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('101 RECETAS CRUDIVEGANAS PARA SOLUCIONARTE LA VIDA (Spanish Edition)', 'MORENO, ANA', NULL, v_42, '☻101 RECETAS CRUDIVEGANAS.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'No me ames 3 (Spanish Edition)' AND Autor = 'Norah Carter & Monika Hoff & Patrick Norton') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('No me ames 3 (Spanish Edition)', 'Norah Carter & Monika Hoff & Patrick Norton', NULL, v_42, '03 NO ME AMES_NORAH CARTER.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'La noche del horror' AND Autor = 'Silver Kane') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('La noche del horror', 'Silver Kane', NULL, v_42, '✮Terror 13 - Kane, Silver - La noche del horror.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Daniel Goleman' AND Autor = 'Desconocido') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Daniel Goleman', 'Desconocido', 'Daniel Goleman (Stockton, 17 de marzo de 1946)​ es un psicólogo, periodista y escritor estadounidense. Adquirió fama mundial a partir de la publicación de su libro Emotional Intelligence (en español Inteligencia emocional) en 1995.​
Editado por primera vez en 1995, el libro Inteligencia emocional se mantuvo durante un año y medio en la lista de los libros más vendidos del The New York Times. Según la página web oficial de Daniel Goleman, se han vendido, hasta 2006, alrededor de 5.000.000 de ejemplares en 30  idiomas, y ha sido superventas en muchos países. En 1996 se publicó en español su libro Inteligencia emocional.
Daniel Goleman nació y se crio en Stockton, California,​ hijo de los profesores universitarios Fay Goleman e Irving Goleman. Fay Goleman fue profesora de sociología en la Universidad del Pacífico, mientras que Irving fue profesor de humanidades en el San Joaquín Delta College.​
Goleman sostiene que las competencias emocionales se dividen en dos categorías: intrapersonales e interpersonales. Las primeras se refieren a la relación que establecemos con nosotros mismos y la segunda a las relaciones que tenemos con los demás. Todo empieza por uno mismo.
Daniel Goleman estudió antropología en la Universidad de Amherst, Massachusetts para posteriormente obtener su doctorado en psicología clínica en la Universidad de Harvard, también en Massachusetts.​
Trabajó como redactor de la sección de ciencias de la conducta y del cerebro del periódico The New York Times.​ Ha sido editor de la revista ''Psychology Today'' y profesor de psicología en la Universidad de Harvard, en la que obtuvo su doctorado.
Goleman fue cofundador de la Collaborative for Academic, Social and Emotional Learning (Sociedad para el Aprendizaje Académico, Social y Emocional) en el Centro de Estudios Infantiles de la Universidad de Yale (posteriormente en la Universidad de Illinois, en Chicago), cuya misión es ayudar a las escuelas a introducir cursos de educación emocional.', v_42, '_emociones-destructivas-como-enfrentar.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'ESTRATEGIAS PARA AUMENTAR SU RIQUEZA' AND Autor = 'RICHA _ DAD') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('ESTRATEGIAS PARA AUMENTAR SU RIQUEZA', 'RICHA _ DAD', NULL, v_42, '5 ESTRATEGIAS PARA AUMENTAR SU RIQUEZA - RICHA _ DAD - 7 PAGINAS.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Cuando tu llegaste' AND Autor = 'Administrador') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Cuando tu llegaste', 'Administrador', NULL, v_42, '1 Cuando tu llegaste.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '5 Catacombs' AND Autor = 'Windows User') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('5 Catacombs', 'Windows User', NULL, v_42, '0.5 Catacombs.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Todo por ?l (Multimillonario y dominador) - volumen 1 (Spanish Edition)' AND Autor = 'Harold, Megan') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Todo por ?l (Multimillonario y dominador) - volumen 1 (Spanish Edition)', 'Harold, Megan', NULL, v_42, '1. Todo por el - Serie Multimillonario y Dominador.pdf · versión 1.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El mar de los monstruos' AND Autor = 'Rick Riordan') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El mar de los monstruos', 'Rick Riordan', 'El mar de los monstruos (título original en inglés: The Sea of Monsters) es una novela fantástica de aventuras basada en la mitología griega. Está escrita por el autor Rick Riordan y fue publicada el 1 de abril de 2006 en Estados Unidos, y en junio de 2008 en España,​ por la editorial Salamandra, dentro de su línea Narrativa Juvenil. Es el segundo libro de la saga Percy Jackson y los dioses del Olimpo y la secuela de El ladrón del rayo. Este libro narra las aventuras del semidiós (hijo de un dios y una mortal) Percy Jackson, y trata de como él y su amiga Annabeth —otra semidiosa— van a rescatar al sátiro Grover del cíclope Polifemo y salvar el campamento de los ataques de los monstruos, por lo que tienen que traer el vellocino de oro para curar de envenenamiento el árbol de Thalía.', v_140, '2El mar de los monstruos - Rick Riordan.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'el beso del infierno' AND Autor = 'yosbe') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('el beso del infierno', 'yosbe', NULL, v_42, '_1_el beso del infierno-1.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Twain, Mark' AND Autor = 'WinuE') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Twain, Mark', 'WinuE', NULL, v_42, '_Twain, Mark - Diarios de Adán y Eva.pdf · versión 1.pdf · versión 1.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Valiant' AND Autor = 'maria luisa  alhama aroca') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Valiant', 'maria luisa  alhama aroca', NULL, v_42, '3- Valiant - Nuevas Especies.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Anoche salí de la tumba' AND Autor = 'Curtis Garland') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Anoche salí de la tumba', 'Curtis Garland', NULL, v_42, '✮Terror 02 - Garland, Curtis - Anoche sali de la tumba.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '5 Raven' AND Autor = 'Alejandra;Meeny') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('5 Raven', 'Alejandra;Meeny', NULL, v_42, '1.5 Raven - Lauren Oliver.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '1.280 Almas' AND Autor = 'Jim Thompson') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('1.280 Almas', 'Jim Thompson', '1280 almas (Pop. 1280) es una novela negra de Jim Thompson publicada en 1964. Una de las más célebres del autor, su título hace referencia al número de habitantes del pueblo donde transcurre la acción.​​
En Francia, fue la novela elegida por la editorial Gallimard para publicar el número 1000 en su prestigiosa Série Noire con el título 1275 âmes (1966).​', v_177, '1.280 Almas - Jim Thompson.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Marshmallow' AND Autor = 'Serious') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Marshmallow', 'Serious', 'Malvavisco​, nube​ o bombón es una golosina que en su forma moderna consiste en azúcar o jarabe de maíz, clara de huevo batida, gelatina previamente ablandada con agua, goma arábiga y saborizantes, todo ello batido para lograr una consistencia esponjosa. Se puede elaborar en muchas formas. La receta tradicional usaba un extracto de la raíz mucilaginosa de la planta herbácea Althaea officinalis. El mucílago actuaba de antitusivo. Los malvaviscos comerciales son una innovación de finales del siglo XX. Desde el proceso de extrusión patentado por Alex Doumak en 1956,​ los malvaviscos se extruyen como cilindros suaves, se cortan en trozos y se rebozan con una mezcla de maicena y azúcar glas.​

Los malvaviscos son muy populares en el mundo anglosajón y se comen con o sin acompañamiento. En los Estados Unidos, es frecuente comerlos asados o tostados, y en otros lugares acompañados con chocolate o café moca, como parte de otras golosinas, cubriendo boniatos asados, en algunos sabores de helado, etcétera e incluso como ingrediente en numerosas recetas de repostería en forma de crema o fundidos.', v_42, '1. Marshmallow.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'William' AND Autor = 'Emma Madden') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('William', 'Emma Madden', 'William es un nombre propio de los antiguos germánicos. Se hizo muy popular en el idioma inglés después de la conquista normanda de 1066, y siguió siéndolo durante toda la Edad Media y en la era moderna. El equivalente moderno en alemán es "Wilhelm". Es a veces abreviado "Wm." . Las abreviaturas más comunes del nombre suelen ser "Willy", "Will", "Billy" y "Bill". Su traducción al español es Guillermo.', v_42, '1 William - Emma Madden.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Arrastrada por la tormenta: Un relato de la saga krinar' AND Autor = 'Anna Zaires') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Arrastrada por la tormenta: Un relato de la saga krinar', 'Anna Zaires', NULL, v_42, '4- ArrastradaTormenta -  Anna Zaires.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Quiero estar en tu Cama' AND Autor = 'Bianca de Santis') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Quiero estar en tu Cama', 'Bianca de Santis', NULL, v_42, '4_5864081847532652464.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El monasterio perdido' AND Autor = 'Ralph Barby') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El monasterio perdido', 'Ralph Barby', NULL, v_42, '✮Terror 08 - Barby, Ralph - El monasterio perdido.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'H. P. Lovecraft - El libro' AND Autor = 'LEONIC') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('H. P. Lovecraft - El libro', 'LEONIC', NULL, v_42, '1_5024155560635794122.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Remedios caseros para un corazón partío' AND Autor = 'Sylvia Carlock') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Remedios caseros para un corazón partío', 'Sylvia Carlock', NULL, v_42, '_༺࿇ꦶ☬🇲🇽༒Lᵒᵇᶤᵗᵒ༒🇲🇽☬,ॄ࿇༻_58.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¿Amar o depender?' AND Autor = 'Walter Riso') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¿Amar o depender?', 'Walter Riso', '“Aunque la psicología ha avanzado en el tema de las adicciones, en el tema de la adicción afectiva el vacío es innegable Este libro está dirigido a todas aquellas personas que quieren hacer del amor una experiencia plena, alegre y saludable”. —Walter Riso Entregarse afectivamente no implica desaparecer sino integrarse en el otro. El amor sano es una suma de dos en la que nadie pierde. Sin embargo, millones de personas en todo el mundo son víctimas de relaciones amorosas inadecuadas y no saben qué hacer al respecto, ya que el miedo a la pérdida, a la soledad o al abandono contamina el vínculo amoroso y lo vuelve altamente vulnerable. Un amor inseguro es una bomba que puede estallar en cualquier momento y lastimarnos profundamente. En ¿Amar o depender?, Walter Riso, uno de los más conocidos autores de autoayuda, nos enseña que sí es posible vivir con independencia y aun así seguir amando, eliminando las ataduras psicológicas y manteniendo vivo el fuego del amor. La adicción afectiva es una enfermedad que tiene cura y, lo más importante, puede prevenirse. Este revelador libro pretende ayudar a aquellas personas que son o han sido víctimas de un amor malsano y guiar a las parejas sanas para que sigan trabajando en la costumbre de amar intensamente y sin apegos.', v_125, '_Amar o depender_ - Walter Riso (6).pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¿Quién se ha llevado mi queso?' AND Autor = 'Spencer Johnson') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¿Quién se ha llevado mi queso?', 'Spencer Johnson', '¿Quién se ha llevado mi queso? Una manera sorprendente de afrontar el cambio en el trabajo y en la vida privada (en inglés: Who Moved My Cheese? An Amazing Way to Deal with Change in Your Work and in Your Life), publicado en 1998, es un libro de motivación escrito por el estadounidense Spencer Johnson en el estilo de una parábola y alegoria.
Describe el cambio en el trabajo y la vida, y cuatro típicas reacciones (resistirse al cambio por miedo a algo peor, aprender a adaptarse cuando se comprende que el cambio puede conducir a algo mejor, detectar pronto el cambio y finalmente apresurarse hacia la acción) al citado cambio con dos ratones, dos "liliputienses", y sus búsquedas de queso. Un superventas empresarial de New York Times desde el lanzamiento, ¿Quién se ha llevado mi queso? permaneció en la lista por casi cinco años y pasó en torno a doscientas semanas en la lista de no ficción de pasta dura de Publishers Weekly.​', v_114, '_Quién se ha llevado mi queso_- Spencer Johnson.pdf · versión 1.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Forrest Gump' AND Autor = 'Winston Groom') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Forrest Gump', 'Winston Groom', 'A man named Forest Gump sits at a bus stop and tells everyone about his life. It starts in a doctor''s office when he gets leg braces. Then he goes to school where he meets Jenny, and his entire school career and football. Then it goes on to college football. then to Vietnam where he meets bubba. then bubba dies and forest saves a whole platoon. After the war forest gets a medal of honor and runs across America. Then his mom dies. Then he finds jenny again. They have a kid and get married. Then jenny dies. Then the book ends but there is more than this in the town of Greenbow Alabama.', v_42, '__Forrest Gump - Winston Groom-1.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¡Cómo Obtener Seguridad, Confianza, Influencia Y Afinidad Al Instante!: 13 Maneras De Crear Mentes Abiertas Hablándole A La Mente Subconsciente (Spanish Edition)' AND Autor = 'Schreiter, Tom "Big Al"') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¡Cómo Obtener Seguridad, Confianza, Influencia Y Afinidad Al Instante!: 13 Maneras De Crear Mentes Abiertas Hablándole A La Mente Subconsciente (Spanish Edition)', 'Schreiter, Tom "Big Al"', NULL, v_42, '_Cómo Obtener Seguridad, Confianza, Influencia Y Afinidad Al Instante!-1 (1).pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Libro Oncolog™a 256 Pag.' AND Autor = 'Karen G4') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Libro Oncolog™a 256 Pag.', 'Karen G4', NULL, v_42, '¿PORQUÉ NOS CUESTA ESCUCHAR.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¡Estas vivo!: Potencializa cada momento y llena tu corazón de alegría (Spanish Edition)' AND Autor = 'Mark Nepo') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¡Estas vivo!: Potencializa cada momento y llena tu corazón de alegría (Spanish Edition)', 'Mark Nepo', NULL, v_42, '¡Estas vivo! Potencializa cada momento y llena tu corazón de alegría.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¿Bailamos?' AND Autor = 'Christine Poves') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¿Bailamos?', 'Christine Poves', '«Bailamos» es un sencillo mezcla de estilo flamenco español y pop del cantante Enrique Iglesias que aparece en su disco Enrique.
Tras intervenir en uno de los conciertos de Enrique, Will Smith le preguntó a Enrique para contribuir en la banda sonora de la película Wild Wild West y "Bailamos" fue elegida para aparecer en ella.
"Bailamos" llegó al primer lugar en los Estados Unidos, haciéndolo el primer sencillo de Iglesias en llegar al primer lugar en el Billboard Hot 100.
La canción fue dedicada a Brandon Kimball y Marisa Bisaccia.
En ese mismo año de 1999 Interscope demandó a la compañía mexicana Fonovisa Records por haber utilizado el tema sin autorización para un disco de éxitos luego de que Iglesias terminara su contrato con la compañía mexicana en 1998, mas por la altas ventas del disco la demanda fue retirada y Fonovisa lanzó más tarde otro compilatorio esta vez sin el tema de Bailamos.', v_8, '_Bailamos_ - Christine Poves.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Dom' AND Autor = 'yeimi paola de avila vanegas') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Dom', 'yeimi paola de avila vanegas', 'La República Dominicana es un país de América situado en el Caribe, ubicado en la zona central de las Antillas; ocupa la parte central y oriental de la isla La Española. Su capital y ciudad más poblada es Santo Domingo. Limita al norte con el océano Atlántico, al este con el canal de la Mona (que lo separa de Puerto Rico), al sur con el mar Caribe y al oeste con Haití, que es el otro país situado en La Española. Con 48 448 km²​ y una población superior a los 11,4 millones de habitantes en septiembre de 2024,​ es el segundo país más extenso de los países insulares caribeños, después de Cuba, y el tercero más poblado, después de Haití y Cuba. Forma parte del Caribe hispanófono.
En el territorio del país, habitado por taínos desde el siglo VII, desembarcó Cristóbal Colón en 1492, convirtiéndolo en el lugar del primer asentamiento europeo permanente en América. El país alcanzó su primera independencia en 1821, pero fue invadido por el vecino Haití en 1822. Tras la victoria obtenida en la guerra de la independencia dominicana en 1844, los dominicanos experimentaron varias luchas, en su mayoría internas, y también un breve regreso de la dominación española (1861-1865). En un período de doce años fueron asesinados dos presidentes (Ulises Heureaux en 1899 y Ramón Cáceres en 1911). Estados Unidos ocupó el país entre 1916 y 1924, al que siguió un período relativamente tranquilo y próspero de seis años bajo el liderazgo de Horacio Vásquez.
Alrededor de 1930, la República Dominicana se encontró bajo el control del dictador Rafael Trujillo, quien gobernó el país hasta su asesinato en 1961.​ Juan Bosch fue elegido presidente en 1962, pero fue depuesto por un golpe militar en 1963.​ En 1965, Estados Unidos encabezó una intervención en medio de una guerra civil provocada por un levantamiento para restaurar a Bosch.​ En 1966, Joaquín Balaguer derrotó a Bosch en las elecciones presidenciales.​ Balaguer mantuvo un estricto control del poder por doce años, caracterizado por la represión de los partidarios del bando constitucionalista, hasta 1978, cuando fue derrotado en las elecciones por Antonio Guzmán, del Partido Revolucionario Dominicano (PRD), quien gobernó hasta 1982, cuando ganó las elecciones Salvador Jorge Blanco, también del Partido Revolucionario Dominicano (PRD).​ En 1986, debido a la lucha entre facciones existentes en el PRD, Jacobo Majluta, el candidato presidencial del PRD perdió las elecciones ante Joaquín Balaguer, quien regresó al poder hasta 1996, cuando la reacción internacional a unas elecciones defectuosas lo obligó a recortar su mandato en 1996.​ Desde entonces, se han celebrado elecciones competitivas periódicas en las que candidatos de la oposición han ganado la presidencia. En 1996, Leonel Fernández, del Partido de la Liberación Dominicana (PLD) ganó las elecciones para el período 1996-2000, pero el PLD perdió las elecciones en 2000 ante Hipólito Mejía, siendo su candidato Danilo Medina, quien, a su vez, perdió en 2004 ante Leonel Fernández, que también ganó las elecciones de 2008, logrando gobernar el país por doce años (1996-2000 y 2004-2012).​ Ganó la elección para un nuevo mandato en 2004 tras una enmienda constitucional que permitía a los presidentes servir más de un mandato y luego fue reelegido para un segundo mandato consecutivo. Tras la presidencia de dos mandatos de Danilo Medina (2012-2020), Luis Abinader, del opositor Partido Revolucionario Moderno (PRM), fue elegido presidente en julio de 2020 para el período 2020-2024 y reelegido para el 2024-2028.​
En 2022 la República Dominicana tenía la séptima economía más grande de América Latina​ y en 2010 la primera de América Central y el Caribe​ y en 2018 ocupaba la séptima posición en ingreso per cápita en América Latina, solo superada por Puerto Rico, Panamá, Chile, Uruguay, Argentina y Costa Rica.​ El país ha disfrutado de un fuerte crecimiento económico en las últimas décadas. Según el Banco Mundial, durante los últimos veinticinco años, la República Dominicana (RD) ha experimentado un notable período de sólido crecimiento económico (5,3 %, en promedio, entre los años 2000 y 2019), la segunda economía de mayor crecimiento en la región, impulsado principalmente por una rápida acumulación de capital y consumo privado.​ «Este notable desarrollo contribuye al objetivo de lograr una condición de país de alto ingreso para el año 2030.»​ El continuo crecimiento ha logrado reducir en parte la pobreza y la desigualdad. La tasa de pobreza se ha reducido de casi un 50 % en 2003 a un 21.8 % en el 2022.​​ Aunque antiguamente conocida por la producción de azúcar, la economía está ahora dominada por los servicios.​ La migración internacional afecta en gran medida al país, ya que recibe y envía gran flujo de migrantes. La inmigración irregular de haitianos y la integración en materia legal de los descendientes de estos es el principal problema inmigratorio; la población total de origen haitiano se estima en alrededor de 750 000.​ En los Estados Unidos existe una gran diáspora dominicana, contabilizada en 1,5 millones de personas;​ esa diáspora ayuda al desarrollo nacional, enviando miles de millones de dólares a sus familias, lo que representa una décima parte del PIB.​
La República Dominicana es el destino más visitado del Caribe y el segundo de Latinoamérica.​ Durante todo el año los campos de golf del país se encuentran entre las principales atracciones de la isla.​ En el país se encuentra la montaña más alta del Caribe, el pico Duarte en la provincia de San Juan, así como el punto más bajo en cuanto al nivel del mar se refiere, el lago Enriquillo, en la provincia Independencia, que es el lago más grande del Caribe.​ Dominicana, como también se le llama, es un país tropical con una temperatura promedio de 26 °C, la cual varía muy poco durante el año, y una gran diversidad biológica.​
La población es 47,8 % católica y 21,3 % protestante, mientras que el 28 % se declara no creyente.​ El país tuvo la presidencia pro tempore de la Comunidad de Estados Latinoamericanos y Caribeños (CELAC) para el período 2016-2017.​', v_42, '3. Dom.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '5816631224940103766' AND Autor = 'Rafa') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('5816631224940103766', 'Rafa', NULL, v_42, '4_5816631224940103766.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Lady Sarah (Spanish Edition)' AND Autor = 'Jane Mackenna') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Lady Sarah (Spanish Edition)', 'Jane Mackenna', NULL, v_42, '2- Lady Sarah - Jane Mackenna - Lady_s.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Guía para el tratamiento del duelo en la infancia y en la adolescencia' AND Autor = 'Desconocido') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Guía para el tratamiento del duelo en la infancia y en la adolescencia', 'Desconocido', 'Of all the emotions that our children experience, I believe that sadness is one of those that is hardest for us to learn to deal with, and not because it bothers us as parents or caretakers, but because it breaks our hearts to see them in such pain and not be able to change the harshness of the situation, as in the case of the death of a person we love. There are no ABCs that tell us step by step what to do at such times. Each family processes experiences in specific ways. And even with some light on how to approach this situation with our children, it is very likely that the pain of the moment can silence the brilliance of the theory. I have written this guide from my own experience and from my desire to continue to maintain a vision full of inclusion, love and respect for our children even in times of loss, situations in which, unfortunately, in some contexts they are still excluded precisely because they are children. The guide will help you both if you are going through a process of mourning the significant death of a loved one and also if you want to have an idea of how to approach the concept of death with your children or students.', v_125, '_Guía para el tratamiento del duelo en la infancia y en la adolescencia_-1.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Star Wars Episodio VI El retorno del Jedi' AND Autor = 'James Kahn') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Star Wars Episodio VI El retorno del Jedi', 'James Kahn', 'Star Wars: Episode VI - Return of the Jedi (conocida en español como Star Wars: Episodio VI - El retorno del Jedi o La guerra de las galaxias: Episodio VI - El regreso del Jedi) es una película de space opera estadounidense de 1983 (seis años después del estreno de la primera película) escrita por George Lucas y Lawrence Kasdan, basada en una historia de Lucas y  dirigida por Richard Marquand. Secuela de Una nueva esperanza y El Imperio contraataca, es la tercera película de la Trilogía Original, la tercera estrenada de la saga Star Wars y la sexta en términos de cronología interna de la saga.
Ambientada un año después de El Imperio Contraataca, el Imperio Galáctico está construyendo una segunda Estrella de la Muerte para exterminar a la Alianza Rebelde. Después de que Luke Skywalker y sus amigos liberan a Han Solo de Jabba el Hutt, la flota rebelde diseña y ejecuta un ataque a la Estrella de la Muerte con la esperanza de destruirla a ella y al Emperador, mientras Luke lucha por traer de vuelta a su padre, Darth Vader, al Lado Luminoso de La Fuerza.
La película se estrenó en los cines el 25 de mayo de 1983. Recaudó 374 millones de dólares en todo el mundo durante su presentación inicial en cines, convirtiéndose en la película más taquillera de 1983. La película fue bien recibida por la crítica, con grandes elogios hacia los efectos especiales y las secuencias de acción, las actuaciones, la música de John Williams y el peso emocional. De la trilogía original fue la película más criticada, ya que mucha gente la consideraba la más infantil por la inclusión de los ewoks. Aun así fue aclamada por la mayoría de la gente, que la consideraron una gran conclusión para la saga. Al igual que los episodios Una Nueva Esperanza y El Imperio Contraataca fue reeditada en 1997 y 2004 para las versiones de VHS y DVD. También tuvo modificaciones para su versión en Blu-ray.  En 2021, fue considerada «cultural, histórica y estéticamente significativa» por la Biblioteca del Congreso de Estados Unidos y seleccionada para su preservación en el National Film Registry.', v_13, '6.Star Wars.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Mi error fue amarte (Libro 2)' AND Autor = 'Moruena Estríngana') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Mi error fue amarte (Libro 2)', 'Moruena Estríngana', NULL, v_42, '5.2. Mi error fue amarte .pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'CHANDLER' AND Autor = 'Unknown') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('CHANDLER', 'Unknown', NULL, v_42, '5. CHANDLER - LAURELIN PAIGE.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Más horrible cada vez' AND Autor = 'Ada Coretti') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Más horrible cada vez', 'Ada Coretti', NULL, v_42, '_Mas horrible cada vez - Coretti, Ada.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Su virgen concubina' AND Autor = 'Desconocido') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Su virgen concubina', 'Desconocido', NULL, v_42, '3. Su virgen concubina.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Mi jefe es un amor' AND Autor = 'Aitor Ferrer') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Mi jefe es un amor', 'Aitor Ferrer', NULL, v_42, '1 Mi jefe es un amor - Aitor Ferrer.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¿Viernes o te vas?: Querido destino, no seas cabrón' AND Autor = 'Nina Minina') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¿Viernes o te vas?: Querido destino, no seas cabrón', 'Nina Minina', NULL, v_42, '_Viernes o te vas__ Querido des - Nina Minina.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'ALLY. La historia de Allison y Robert (MIA 2)' AND Autor = 'A. G. Keller') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('ALLY. La historia de Allison y Robert (MIA 2)', 'A. G. Keller', NULL, v_42, '02 - ALLY. La historia de Allison y  - A. G. Keller.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Come Reza Ama' AND Autor = 'Elizabeth Gilbert') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Come Reza Ama', 'Elizabeth Gilbert', NULL, v_42, '__Comer, rezar, amar__ de Elizabeth Gilbert-1-1-1.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'I El lado explosivo de Jude' AND Autor = 'Nicole Williams') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('I El lado explosivo de Jude', 'Nicole Williams', NULL, v_42, '1. El_lado_explosivo_de_Jude.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Home For Christmas' AND Autor = 'usuario') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Home For Christmas', 'usuario', NULL, v_131, '02. Home For Christmas - Alexa Riley.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Dungeon ni Deai wo Motomeru no wa Machigatteiru Darou ka' AND Autor = 'carlos') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Dungeon ni Deai wo Motomeru no wa Machigatteiru Darou ka', 'carlos', 'Dungeon ni Deai o Motomeru no wa Machigatteiru Darō ka (ダンジョンに出会いを求めるのは間違っているだろうか, lit. ¿Está mal querer tener un encuentro en una mazmorra??), también conocido como ¿Está mal seducir chicas en un calabozo? o  ¿Qué tiene de malo intentar ligar en una mazmorra? y varias veces abreviado como DanMachi (ダンまち, ''''DanMachi''''?), es una serie de novelas ligeras escritas por Fujino Ōmori e ilustradas por Suzuhito Yasuda. SB Creative ha publicado veintiuno volúmenes desde enero de 2013 bajo el sello de GA Bunko. Ha recibido una serie de spin-offs de la novela ligera y tres adaptaciones al manga. Una adaptación al anime, a cargo del estudio J.C.Staff, salió al aire desde el 4 de abril hasta el 27 de junio de 2015.
Ha sido la novela ligera más votada por los fanes en los premios Sugoi Japan Awards de la edición de 2016. En estos premios, los fanáticos deciden qué anime, manga, novela es la más indicada para ser comercializada en el mercado internacional.​', v_135, '[K-VT] Dungeon Vol. 04.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Soando contigo- Lisa kelypas.PDF' AND Autor = 'usuario') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Soando contigo- Lisa kelypas.PDF', 'usuario', NULL, v_42, '2 Soñando contigo.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Soldadito de plomo' AND Autor = 'Hans Christian Andersen') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Soldadito de plomo', 'Hans Christian Andersen', NULL, v_42, '《El soldadito de plomo》 Hans Christian Andersen.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Huye' AND Autor = 'Lisa McMann') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Huye', 'Lisa McMann', 'Por primera vez en años, Janie se va de vacaciones. Está pasando unos días en la cabaña del lago que tiene el hermano de Cabe, lejos de su madre alcohólica y del revuelo que ha causado en el pueblo la revelación de que ella trabaja para la policía. Por suerte, ya puede dejar de esconder su relación con Cabe y el año que viene comienza la universidad, lejos del pueblo. Por desgracia sus poderes le evitan llevar una vida normal, y tras un par de incidentes con sueños en los que Cabe no reacciona como ella espera, Janie comienza a tener dudas. Pero todo deja de tener importancia cuando Janie recibe una llamada de Carrie en la que su amiga le informa que ha tenido que llevar a su madre al hospital. Janie y Cabe vuelven corriendo para descubrir que no es la madre de Janie la que está ingresada, si no su padre, al que Janie jamás conoció ya que abandonó a su madre antes de que ella naciera. El padre está en coma, y la única persona que aparece en los papeles médicos que hay en su casa es su madre, que no quiere saber nada del tema. Sospecha que su padre podría ser como ella y tener la habilidad de entrar en los sueños de los demás, así que comienza a investigar su vida y su pasado para intentar descifrar su propio futuro.', v_168, '05 Giovanni Papini - El espejo que huye .pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '2. Mia Por Ahora - Scott J. S.' AND Autor = 'Carmen') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('2. Mia Por Ahora - Scott J. S.', 'Carmen', NULL, v_42, '2.Mía Por Ahora 2 - J. S. Scott.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Drácula' AND Autor = 'Bram Stoker') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Drácula', 'Bram Stoker', NULL, v_42, '.Dracula (Ilustrado) - Bram Stoker.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¿Quién está ahí?' AND Autor = 'John W. Campbell, Jr.') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¿Quién está ahí?', 'John W. Campbell, Jr.', NULL, v_42, '_Quien esta ahi_ - John W. Campbell, Jr_ (6).pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Índice' AND Autor = 'privado') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Índice', 'privado', NULL, v_42, '1_4983409622510469382.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El jefe' AND Autor = 'Victoria Quinn') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El jefe', 'Victoria Quinn', 'Emanuel Herrera Batista (Bajos de Haina, Provincia de San Cristóbal, 18 de diciembre de 1990) conocido artísticamente como el Alfa, es un cantante dominicano.​ Su música principalmente es dembow dominicano, aunque también hace y utiliza otros ritmos urbanos latinos.​​', v_98, '3. El hijo del jefe - Sierra Rose.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Desgarrada: Parte Cuatro (Spanish Edition)' AND Autor = 'Sky Corgan') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Desgarrada: Parte Cuatro (Spanish Edition)', 'Sky Corgan', NULL, v_42, '4 - Desgarrada.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Comunicación' AND Autor = 'gsa') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Comunicación', 'gsa', NULL, v_42, '0-Comunicación.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El veneno que nos separa' AND Autor = 'Irene Hall') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El veneno que nos separa', 'Irene Hall', NULL, v_42, '(Veneno. 01) El veneno que nos separa - Irene Hall.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¿Y si te enamoras de mí?' AND Autor = 'Ana Urbina') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¿Y si te enamoras de mí?', 'Ana Urbina', NULL, v_42, '_Y_si_te_enamoras_de_m_-_Ana_Urbina.pdf_filename= UTF-8__Y si te enamoras de mí - Ana Urbina.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El billar no es de vagos' AND Autor = 'Bosch, Carlos(Author)') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El billar no es de vagos', 'Bosch, Carlos(Author)', NULL, v_42, '_El Billar No Es de Vagos-1.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El Niño Con El Pijama De Rayas. John Boyne' AND Autor = 'Desconocido') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El Niño Con El Pijama De Rayas. John Boyne', 'Desconocido', 'El libro que conmovió a millones de lectores. Estimado lector, estimada lectora: Aunque el uso habitual de un texto como éste es describir las características de la obra, por una vez nos tomaremos la libertad de hacer una excepción a la norma establecida. No sólo porque el libro que tienes en tus manos es muy difícil de definir, sino porque estamos convencidos de que explicar su contenido estropearía la experiencia de la lectura. Creemos que es importante empezar esta novela sin saber de qué trata. No obstante, si decides embarcarte en la aventura, debes saber que acompañarás a Bruno, un niño de nueve años, cuando se muda con su familia a una casa junto a una cerca. Cercas como ésa existen en muchos sitios del mundo, sólo deseamos que no te encuentres nunca con una. Por último, cabe aclarar que este libro no es sólo para adultos; también lo pueden leer, y sería recomendable que lo hicieran, niños a partir de los trece años de edad. El editor La crítica ha dicho... «Una historia que tiene mucho de fábula... una pequeña maravilla de libro». The Guardian «Un libro que persiste en la memoria del lector. Sutil, de una exquisita sencillez y absolutamente conmovedor». The Irish Times «Un libro tan sencillo, tan aparentemente accesible, que es casi perfecto». The Irish Independent «Profundamente conmovedor». The Wall Street Journal «Un libro que no se olvida». The Australian «Extraordinario». The Irish Examiner', v_210, '_El Niño Con El Pijama De Rayas. John Boyne.PDF · versión 1.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'horas Para' AND Autor = 'Rosa Perez') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('horas Para', 'Rosa Perez', NULL, v_42, '__7_horas_Para_Enamorarte-1.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Dungeon ni Deai wo Motomeru no wa Machigatteiru Darou ka' AND Autor = 'carlos') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Dungeon ni Deai wo Motomeru no wa Machigatteiru Darou ka', 'carlos', 'Dungeon ni Deai o Motomeru no wa Machigatteiru Darō ka (ダンジョンに出会いを求めるのは間違っているだろうか, lit. ¿Está mal querer tener un encuentro en una mazmorra??), también conocido como ¿Está mal seducir chicas en un calabozo? o  ¿Qué tiene de malo intentar ligar en una mazmorra? y varias veces abreviado como DanMachi (ダンまち, ''''DanMachi''''?), es una serie de novelas ligeras escritas por Fujino Ōmori e ilustradas por Suzuhito Yasuda. SB Creative ha publicado veintiuno volúmenes desde enero de 2013 bajo el sello de GA Bunko. Ha recibido una serie de spin-offs de la novela ligera y tres adaptaciones al manga. Una adaptación al anime, a cargo del estudio J.C.Staff, salió al aire desde el 4 de abril hasta el 27 de junio de 2015.
Ha sido la novela ligera más votada por los fanes en los premios Sugoi Japan Awards de la edición de 2016. En estos premios, los fanáticos deciden qué anime, manga, novela es la más indicada para ser comercializada en el mercado internacional.​', v_135, '[K-VT] Dungeon Vol. 12.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Angel' AND Autor = 'Sarah Brianne') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Angel', 'Sarah Brianne', 'Un ángel es un ser sobrenatural presente en varias religiones y mitologías, cuya función principal es servir a una deidad suprema. Sus funciones y especificaciones varían según cada cultura. La rama de la teología que se especializa en  los ángeles se denomina angelología.
Las religiones monoteístas muchas veces representan a los ángeles como seres celestiales benevolentes que actúan como intermediarios entre Dios y la humanidad.
En el catolicismo se habla del ángel de la guarda o del custodio, que sería aquel que Dios tiene señalado a cada persona para protegerla. Por contraposición, también se tiene la figura del ángel caído, aquel que ha sido expulsado del cielo por desobedecer o rebelarse contra Dios. Los ángeles más conocidos en las tradiciones judeocristianas son: San Miguel, San Gabriel y San Rafael.', v_99, '__Donde_los_angeles_no_duermen.pdf-538988541-1.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Juegos insolentes 1' AND Autor = 'Emma Green') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Juegos insolentes 1', 'Emma Green', NULL, v_42, '0 Juegos_insolentes_1_Emma_Greenaad0.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Únicamente tú' AND Autor = 'Moruena Estríngana') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Únicamente tú', 'Moruena Estríngana', NULL, v_42, '4.Unicamente tu-Morena Estringana.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '5136612411628847448' AND Autor = 'Desconocido') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('5136612411628847448', 'Desconocido', NULL, v_42, '1_5136612411628847448.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'The Whitechapel Fiend' AND Autor = 'Desconocido') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('The Whitechapel Fiend', 'Desconocido', 'Jack the Ripper stalks through London, and only the Shadowhunters can stop him. One of ten adventures in Tales from the Shadowhunter Academy. Simon learns the truth behind the Jack the Ripper murders—“Jack” was stopped by Will Herondale and his institute of Victorian Shadowhunters. This standalone e-only short story follows the adventures of Simon Lewis, star of the #1 New York Times bestselling series The Mortal Instruments, as he trains to become a Shadowhunter. Tales from the Shadowhunter Academy features characters from Cassandra Clare’s Mortal Instruments, Infernal Devices, and the upcoming Dark Artifices and Last Hours series. The Whitechapel Fiend is written by Cassandra Clare and Maureen Johnson.', v_215, '3. The Whitechapel Fiend .pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El Señor de los Lobos' AND Autor = 'Clark Carrados') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El Señor de los Lobos', 'Clark Carrados', NULL, v_42, '✮Terror 19 - Carrados, Clark - El Senor de los Lobos.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El jefe' AND Autor = 'Victoria Quinn') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El jefe', 'Victoria Quinn', 'Emanuel Herrera Batista (Bajos de Haina, Provincia de San Cristóbal, 18 de diciembre de 1990) conocido artísticamente como el Alfa, es un cantante dominicano.​ Su música principalmente es dembow dominicano, aunque también hace y utiliza otros ritmos urbanos latinos.​​', v_98, '2. El hijo del jefe - Sierra Rose.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¡Estoy bien! (Spanish Edition)' AND Autor = 'Ryuho Okawa') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¡Estoy bien! (Spanish Edition)', 'Ryuho Okawa', NULL, v_42, '¡Estoy bien! Cómo encontrarse uno mismo y llevar una vida positiva.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'La teoría de juegos' AND Autor = 'Jean Blaise Mimbang') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('La teoría de juegos', 'Jean Blaise Mimbang', NULL, v_42, '1_5006073911528390842.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Imagen' AND Autor = 'WinuE') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Imagen', 'WinuE', 'Una imagen (del latín imago) es una representación visual, que manifiesta la apariencia visual de un objeto real o imaginario. Aunque el término suele entenderse como sinónimo de representación visual, también se aplica como extensión para otros tipos de percepción, como imágenes auditivas, olfativas, táctiles, sinestesias, etc. Las imágenes que la persona no percibe sino que vive interiormente, se las denominan imágenes mentales, mientras que las que representan visualmente un objeto mediante técnicas diferentes, se las designa como imágenes creadas (o bien, imágenes reproducidas). Algunas de ellas son el dibujo, el diseño, la pintura, la fotografía o el vídeo, entre otras.
Existen una gran cantidad de expresiones relacionadas con la imagen, pues esta puede hacer referencia a: la imagen gráfica, imagen visual, imagen material, imagen mental, etc. En el mundo empresarial, por su parte, se usa el término "imagen" para referirse a ciertos conceptos como: imagen de empresa, imagen de marca, imagen corporativa e imagen global; de la misma manera, la imagen de empresa se subdivide en imagen depositada, la imagen deseada y la imagen difundida, todas ellas de gran importancia pues es la visión que se tiene de una empresa en el mercado.
Román Gubern, en su libro Patología de la imagen, establece dos ámbitos de uso de la imagen:

Uso público: Es el uso que se hace de la imagen a través de los medios de comunicación, las instituciones, etc.
Uso privado: Es el uso que se hace de la imagen dentro del ámbito individual o familiar.', v_42, '1c97af0a-185f-4781-bba1-5c9290220e5c.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '5059811468594119029' AND Autor = 'Desconocido') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('5059811468594119029', 'Desconocido', NULL, v_42, '1_5059811468594119029.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'COMO AFRONTAR EL DUELO+' AND Autor = 'Desconocido') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('COMO AFRONTAR EL DUELO+', 'Desconocido', 'La guía para líderes de Surviving the Holidays ofrece instrucciones paso a paso sobre cómo organizar un evento festivo. Cada kit de Surviving the Holidays incluye una guía para líderes, pero puede que desees comprar libros adicionales según el tamaño de tu evento y la cantidad de líderes. Este libro incluye una lista de verificación detallada de lo que debes hacer antes de tu evento, una agenda del evento, preguntas de discusión para el tiempo facilitado de compartir en grupos pequeños, un esquema para tomar notas del video y otras herramientas e información para organizar un evento impactante.', v_60, '+COMO AFRONTAR EL DUELO+.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Una Criminal Engañada (Spanish Edition)' AND Autor = 'Buendia, Kris') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Una Criminal Engañada (Spanish Edition)', 'Buendia, Kris', NULL, v_42, '3. Una Criminal Engañada.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¡Sí, puedes!: 40 píldoras estimulantes para mentes inquietas (Spanish Edition)' AND Autor = 'Sánchez-Ocaña, Alejandro Suárez') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¡Sí, puedes!: 40 píldoras estimulantes para mentes inquietas (Spanish Edition)', 'Sánchez-Ocaña, Alejandro Suárez', NULL, v_42, '¡Si puedes! 40 píldoras estimulantes para mentes inquietas.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El embrujo de Satán' AND Autor = 'Burton Hare') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El embrujo de Satán', 'Burton Hare', NULL, v_42, '✮Terror 03 - Hare, Burton - El embrujo de Satan.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Autocontrol' AND Autor = 'Kelly McGonigal') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Autocontrol', 'Kelly McGonigal', 'El autocontrol es la habilidad que permite regular las emociones, pensamientos, habilidades, comportamientos y deseos que cada ser humano tiene. Este proceso cognitivo puede ser necesario a la hora de cumplir metas y alcanzar ciertos objetivos.', v_42, '_Autocontrol_-_Kelly_McGonigal.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Desgarrada: Parte seis (Spanish Edition)' AND Autor = 'Sky Corgan') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Desgarrada: Parte seis (Spanish Edition)', 'Sky Corgan', NULL, v_42, '6 - Desgarrada Sky Corgan.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Un hombre en la oscuridad' AND Autor = 'Paul Auster') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Un hombre en la oscuridad', 'Paul Auster', 'Un hombre en la oscuridad es una novela del escritor estadounidense Paul Auster publicada por primera vez en 2008. Narra una noche de un viejo periodista insomne que yace en la cama. Al principio de la noche el viejo trata de no pensar en su propia vida e imagina una distopía en el marco actual de Estados Unidos, suscitada por una nueva guerra civil y de secesión luego de las elecciones presidenciales de 2000. Los bandos enfrentados en la guerra ficticia están constituidos por los estados que habitualmente votan al Partido Republicano o Partido Demócrata. Finalmente, pareciéndole fútil el intento, cede a sus angustias y arrepentimientos inútiles y pasa revista a su vida y a la de su familia. Al alba comparte sus recuerdos con su nieta que vive en la misma casa.', v_31, '1_5006073911528390858.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Cómo Construir La Autodisciplina' AND Autor = 'Martin Meadows') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Cómo Construir La Autodisciplina', 'Martin Meadows', NULL, v_42, '1_5048553032166408442.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Secretos 03' AND Autor = 'Christian Martins') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Secretos 03', 'Christian Martins', NULL, v_42, '3.Secretos.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Algo inesperado' AND Autor = 'Pilar Cabero') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Algo inesperado', 'Pilar Cabero', NULL, v_42, '_Algo inesperado- Pilar Cabero.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El jefe' AND Autor = 'Victoria Quinn') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El jefe', 'Victoria Quinn', 'Emanuel Herrera Batista (Bajos de Haina, Provincia de San Cristóbal, 18 de diciembre de 1990) conocido artísticamente como el Alfa, es un cantante dominicano.​ Su música principalmente es dembow dominicano, aunque también hace y utiliza otros ritmos urbanos latinos.​​', v_98, '♋♋El jefe-VictoriaQuinn02.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Huye' AND Autor = 'Lisa McMann') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Huye', 'Lisa McMann', 'Por primera vez en años, Janie se va de vacaciones. Está pasando unos días en la cabaña del lago que tiene el hermano de Cabe, lejos de su madre alcohólica y del revuelo que ha causado en el pueblo la revelación de que ella trabaja para la policía. Por suerte, ya puede dejar de esconder su relación con Cabe y el año que viene comienza la universidad, lejos del pueblo. Por desgracia sus poderes le evitan llevar una vida normal, y tras un par de incidentes con sueños en los que Cabe no reacciona como ella espera, Janie comienza a tener dudas. Pero todo deja de tener importancia cuando Janie recibe una llamada de Carrie en la que su amiga le informa que ha tenido que llevar a su madre al hospital. Janie y Cabe vuelven corriendo para descubrir que no es la madre de Janie la que está ingresada, si no su padre, al que Janie jamás conoció ya que abandonó a su madre antes de que ella naciera. El padre está en coma, y la única persona que aparece en los papeles médicos que hay en su casa es su madre, que no quiere saber nada del tema. Sospecha que su padre podría ser como ella y tener la habilidad de entrar en los sueños de los demás, así que comienza a investigar su vida y su pasado para intentar descifrar su propio futuro.', v_168, '3. Huye - Lisa McMann.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El jefe' AND Autor = 'Victoria Quinn') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El jefe', 'Victoria Quinn', 'Emanuel Herrera Batista (Bajos de Haina, Provincia de San Cristóbal, 18 de diciembre de 1990) conocido artísticamente como el Alfa, es un cantante dominicano.​ Su música principalmente es dembow dominicano, aunque también hace y utiliza otros ritmos urbanos latinos.​​', v_98, '2.El jefe.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Link' AND Autor = 'yeimi paola de avila vanegas') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Link', 'yeimi paola de avila vanegas', 'Johann Heinrich Friedrich Link (Hildesheim, 1767-Berlín, 1851) fue un médico, botánico, pteridólogo, micólogo y naturalista alemán.', v_42, '2. Link.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¿En qué creen los que no creen?' AND Autor = 'Umberto Eco & Carlo Maria Martini & Emanuele Severino & Manlio Sgalambro & Eugenio Scalfari & Indro Montanelli & Vittorio Foa & Claudio Martelli') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¿En qué creen los que no creen?', 'Umberto Eco & Carlo Maria Martini & Emanuele Severino & Manlio Sgalambro & Eugenio Scalfari & Indro Montanelli & Vittorio Foa & Claudio Martelli', NULL, v_42, '_En que creen los que no creen_ - Umberto Eco.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Cyborg Fever' AND Autor = 'Alumno') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Cyborg Fever', 'Alumno', NULL, v_42, '5. Cyborg Fever.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Fairest' AND Autor = 'USUARIO') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Fairest', 'USUARIO', NULL, v_42, '5 Fairest.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Mortuary show' AND Autor = 'Silver Kane') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Mortuary show', 'Silver Kane', NULL, v_42, '_Mortuary show -Kane, Silver -.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Lady Sarah (Spanish Edition)' AND Autor = 'Jane Mackenna') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Lady Sarah (Spanish Edition)', 'Jane Mackenna', NULL, v_42, '02 - Lady Sarah.pdf · versión 1.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Ghostgirl 2- El regreso' AND Autor = 'Serie GhostGirl') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Ghostgirl 2- El regreso', 'Serie GhostGirl', NULL, v_42, '2 El Regreso - Serie GhostGirl.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Night_s Blaze' AND Autor = 'Mª de NURIA RODRÍGUEZ MATÍAS') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Night_s Blaze', 'Mª de NURIA RODRÍGUEZ MATÍAS', NULL, v_42, '05 - Night_s Blaze.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Arregla tu vida con grafología (Spanish Edition)' AND Autor = 'Maryfer Centeno') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Arregla tu vida con grafología (Spanish Edition)', 'Maryfer Centeno', NULL, v_42, '_Arregla tu vida con Grafologia _ Marifer Centeno.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '… Y surgieron de la niebla' AND Autor = 'Ralph Barby') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('… Y surgieron de la niebla', 'Ralph Barby', NULL, v_42, '✮Terror 12 - Barby, Ralph - _. Y surgieron de la niebla.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Horror en el cuarto oscuro' AND Autor = 'Ada Coretti') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Horror en el cuarto oscuro', 'Ada Coretti', NULL, v_42, '✮Terror 26 - Coretti, Ada - Horror en el cuarto oscuro.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Aristoteles y Dante descubren los secretos del Universo' AND Autor = 'Benjamin Alires Sáenz') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Aristoteles y Dante descubren los secretos del Universo', 'Benjamin Alires Sáenz', 'Aristóteles y Dante descubren los secretos del universo (en inglés, Aristotle and Dante Discover the Secrets of the Universe) es una novela de literatura juvenil del escritor estadounidense Benjamin Alire Sáenz publicada el 21 de febrero de 2012. La trama está ambientada en 1987 en El Paso y sigue la vida de dos adolescentes mexicanos-estadounidenses: Aristóteles Mendoza y Dante Quintana que, después de conocerse, entablan una amistad y exploran su identidad étnica, su sexualidad y sus relaciones familiares y románticas.
Desde su publicación consiguió diversas críticas positivas y recibió cuatro premios literarios. Desde 2017 está planificada que sea adaptada al cine. Cuenta con una secuela, Aristóteles y Dante se sumergen en las aguas del mundo, publicada en 2021.', v_209, '_ Aristoteles y Dante descubren los secretos del universo _-1.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El rey gris' AND Autor = 'Susan Cooper') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El rey gris', 'Susan Cooper', NULL, v_42, '04 El rey gris.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¡Hazlo!' AND Autor = 'Seth Godin') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¡Hazlo!', 'Seth Godin', 'Este libro es una llamada de atención sobre las iniciativas que estás tomando, en el trabajo y en cuanto te concierne. Ha llegado el momento de que dejes de esperar a que alguien te proporcione un mapa del camino y empieces a dibujarlo tú mismo. Llevamos a nuestros hijos al colegio y nos obsesionamos con sus notas, su comportamiento y su capacidad de integración. Colgamos una oferta de trabajo y buscamos experiencia, universidades de prestigio y una carrera sin fracasos. Y entonces, ¿por qué nos sorprendemos cuando todo se desmorona? Nuestra economía no es estática, pero actuamos como si lo fuera. Tu posición en el mundo se define en función de lo que emprendes, de cómo lo haces y de lo que aprendes de los acontecimientos que causas. ¡Hazlo! Constituye un manifiesto sobre la producción de algo que escasea y es, por lo tanto, valioso. Ha llegado el momento de que dejes de esperar a que alguien te proporcione un mapa del camino y empieces a dibujarlo tú mismo. Este libro quizá te haga sentir incómodo. Es una llamada de atención sobre las iniciativas que estás tomando, en el trabajo y en cuanto te concierne. Pero también puede ser el puntapié que necesitas para introducir un cambio en tu vida.', v_29, '¡Hazlo! Cuando fue la última vez que hiciste algo por primera vez.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¡ Y tenía que ser mi jefe !' AND Autor = 'Norah Carter') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¡ Y tenía que ser mi jefe !', 'Norah Carter', NULL, v_42, '1 ! Y tenia que ser mi jefe !  - Norah Carter & Monika Hoff.pdf.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Querida abuelita Fanny' AND Autor = 'Silver Kane') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Querida abuelita Fanny', 'Silver Kane', NULL, v_42, '✮Terror 18 - Kane, Silver - Querida abuelita Fanny.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Calhoun' AND Autor = 'MACARUBE') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Calhoun', 'MACARUBE', NULL, v_42, '01. Calhoun.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¡No pienses más!: Cómo parar la rueda del hámster que hay en tu cabeza (Spanish Edition)' AND Autor = 'Serge Marquis') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¡No pienses más!: Cómo parar la rueda del hámster que hay en tu cabeza (Spanish Edition)', 'Serge Marquis', NULL, v_42, '¡No pienses más! Cómo parar la rueda del hámster que hay en tu cabeza.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Ripe for the Alpha' AND Autor = 'yeimi paola de avila vanegas') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Ripe for the Alpha', 'yeimi paola de avila vanegas', NULL, v_42, '4. Ripe for the Alpha.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'EL ORFANATO' AND Autor = 'WinuE') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('EL ORFANATO', 'WinuE', 'El orfanato es una película coproducción española-mexicana de terror gótico y drama de 2007, dirigida por J.A. Bayona en su primer largometraje y escrita por Sergio G. Sánchez. Está protagonizada por Belén Rueda y producida por Rodar y Rodar y Telecinco Cinema, con el cineasta mexicano Guillermo del Toro como productor ejecutivo.
La película tuvo éxito en España, tanto en taquilla como en crítica, y recaudó casi 80 millones de dólares a nivel mundial. Estuvo nominada a 61 premios internacionales de los que ganó 31, entre los que destacan 7 premios Goya.', v_44, '1 El Orfanato.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'EL PADRE FUNDADOR' AND Autor = 'Gabriela Flores Chirino') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('EL PADRE FUNDADOR', 'Gabriela Flores Chirino', NULL, v_42, '0. El Padre Fundador.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Educar las emociones en la primera infancia.: Teoría y guía práctica para niños de 3 a 6 años: Descubre todo lo necesario para aplicar la educación emocional en educación infantil' AND Autor = 'Belén Piñeiro') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Educar las emociones en la primera infancia.: Teoría y guía práctica para niños de 3 a 6 años: Descubre todo lo necesario para aplicar la educación emocional en educación infantil', 'Belén Piñeiro', NULL, v_42, '_ Educar emociones 3 a 6 años-1-1.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Chloe' AND Autor = 'Sarah Brianne') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Chloe', 'Sarah Brianne', 'Chloe (también estilizado como Chloë, Chloé, Cloe o Cloi)​ es un nombre femenino, cuyo significado es "floreciente" o "fertilidad". Ha sido un nombre muy popular en Reino Unido desde 1990, llegando a la cima de su popularidad en esa y la primera década del siglo XXI. El nombre viene del griego, khlóē, uno de los muchos nombres de la diosa Demeter y se refiere al follaje joven y verde. El nombre aparece en el Nuevo Testamento, en Corintios 1:11 en el contexto de "la casa de Chloe".​', v_99, '_Y si te toco yo_ - Chloe Collins.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Piaget' AND Autor = 'Psicología del niño') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Piaget', 'Psicología del niño', NULL, v_42, '_Piaget - Psicología del niño.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¿POR QUE LE ES INFIEL? (Spanish Edition)' AND Autor = 'Esteban Cañamares') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¿POR QUE LE ES INFIEL? (Spanish Edition)', 'Esteban Cañamares', NULL, v_42, '¿Por qué le es infiel.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Sobre el mar, bajo la tierra' AND Autor = 'Susan Cooper') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Sobre el mar, bajo la tierra', 'Susan Cooper', NULL, v_42, '01 Sobre el mar, bajo la tierra.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'La villa de las telas' AND Autor = 'Anne Jacobs') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('La villa de las telas', 'Anne Jacobs', 'La villa de las telas abre de nuevo sus puertas. Llega la esperada cuarta parte de la saga superventas de Anne Jacobs. Una magnífica mansion Una época turbulenta Un amor que puede vencerlo todo... Augsburgo, 1930. Marie y Paul Melzer son felices y su amor es más fuerte que nunca. Su hijo menor, el pequeño Kurti, que ahora tiene cuatro años, es un rayo de sol que se gana el afecto de todo el mundo y los gemelos Dodo y Leo han crecido espléndidamente. Dodo ha descubierto su amor por la técnica y sueña con convertirse en aviadora, mientras que Leo demuestra un gran talento para el piano, que se ha convertido en su gran pasión. Pero la villa no es ajena a la agitada situación política en Alemania y la crisis económica golpea con fuerza el negocio familiar. Los Melzer tienen importantes deudas y Marie deberá enfrentarse a dolorosas decisiones para evitar la ruina. El destino de la familia está en juego. Y su amada villa de las telas solo podrá salvarse si todos permanecen unidos. Sobre los libros de la saga han dicho: «Amor imposible y las rígidas normas sociales de la Europa central a principios del siglo XX serán el escenario en el que se desenvuelva esta entretenida historia llena de secretos». Jorge Pato García, El Imparcial «Es una gran historia de amor, con tintes dramáticos y secretos familiares, que nos ha gustado tanto por su calidad literaria como por su preciosismo histórico». Revista Kritica «Downton Abbey en Augsburgo». Histo-couch «Este libro lo tiene todo, todo que podríamos desear para un día de lluvia: una gran historia de amor, intriga [...] y un gran secreto familiar». Delmenhorster Kreisblatt «Con su escritura fluida, Anne Jacobs sabe cómo seducir a sus lectoras y transportarlas a la vida de la alta sociedad de hace cien años con todo su glamour pero también con sus sombras». Weilheimer Tagblatt Los lectores opinan: «A todos los que os gustan las sagas familiares estos libros os van a encantar. De esos libros que tiene un ritmo muy bueno en todo momento, no decae para nada y hace su lectura muy agradable». Blog Leyendo entre páginas «Una historia de familias, de amor, de superación personal y de valentía. Pero de una valentía que no sabes que tienes hasta que la necesitas». Blog Viajando gracias a los libros «Si echáis de menos Downton Abbey (yo la echo de menos casi a diario) esta saga llenará ese hueco por completo». labibliotecadelaabuela en Instagram « Regreso a la Villa de las telas ha sido la vuelta a uno de mis lugares favoritos de la literatura». Patricia Llamas para Sigue en serie', v_54, '^ El legado d la Villa de las Telas - Anne Jacobs.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Inteligencia práctica: el arte y la ciencia del sentido común' AND Autor = 'Karl Albrecht') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Inteligencia práctica: el arte y la ciencia del sentido común', 'Karl Albrecht', 'El autor de Inteligencia social, Karl Albrecht, da un paso más y nos explica que la inteligencia práctica puede considerarse una de las aptitudes vitales clave. Karl Albrecht, autor de Inteligencia social, aborda ahora el tema de la inteligencia práctica, y nos muestra que quienes la poseen toman mejores decisiones, son capaces de pensar en términos de opciones y posibilidades, convivir con la ambigüedad y la complejidad, articular problemas con claridad y trabajar hasta dar con soluciones, además de tener ideas originales y creativas. Inteligencia práctica es el perfecto compañero de cualquiera que desee aprender a pensar con mayor claridad y eficacia. Opinión: «Tal u como hizo en su brillante libro Inteligencia social, Karl Albercht nos regala una obra lúcida y amena sobre algo tan necesario como la inteligencia práctica. Su lectura no les dejará indiferentes: les abrirá nuevas puertas de pensamiento y creatividad y, probablemente, les dará claves sumamente útiles para gestionar la gran oportunidad que es la vida» Álex Rovira', v_190, 'PDF/Inteligencia practica - el arte y la ciencia del sentido comun - Karl Albrecht.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Multimillonario & Canalla' AND Autor = 'Ella Valentine') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Multimillonario & Canalla', 'Ella Valentine', NULL, v_42, 'PDF/Multimillonario y Canalla - Ella Valentine.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Esmeralda' AND Autor = 'Kerstin Gier') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Esmeralda', 'Kerstin Gier', 'Cruza las fronteras del tiempo y encuentra el verdadero amor. Llega el desenlace de esta grandiosa aventura: un torbellino de sentimientos que arrastra a Gideon y Gwen a través de los siglos. ¿Qué se puede hacer cuando te han roto el corazón? Sin duda, la mejor terapia consiste en telefonear a tu mejor amiga, comer chocolate y hundirte durante semanas en la autocompasión. Lo malo es que la última viajera en el tiempo, Gwendolyn, tiene que emplear sus energías en cosas muy distintas; por ejemplo, sobrevivir. Porque los hilos que ha tejido el turbio conde de Saint Germain en el pasado se tensan ya para urdir una peligrosa red también en el presente. Con el objetivo de desvelar las intenciones secretas del Conde, Gwendolyn y Gideon -olvidando por un momento sus penas de amor- no solo deben bailar un minué en una esplendorosa fiesta en el siglo XVIII, sino también lanzarse a vivir increíbles aventuras que les llevarán más allá de las fronteras del tiempo... «¿No podríamos seguir siendo amigos?» Seguro que muere un hada cada vez que en algún lugar del mundo se pronuncia esta pregunta... Pero el perfectísimo Gideon de Villiers -a quien Xemerius prefiere llamar «el innombrable»- no tiene suficiente sensibilidad ni para pensar en las hadas ni para dejar de pisotear mi corazoncito. Si no fuera porque cuando le miro se me corta la respiración y me tiemblan las piernas, le hubiese soltado un bofetón que le habría mandado directo al siglo XIX sin necesidad de cronógrafo# Aunque, en lugar de hacer eso, solo le fulminé con la mirada y me alejé. Al fin y al cabo, éramos los dos últimos viajeros en el tiempo y en pocas horas saltaríamos juntos a 1782 con una misión a vida o muerte... Una saga que ha conquistado a los bloggers y lectores de la novela juvenil: «Kerstin debe de haber lanzado algún tipo de magia entre sus páginas. Sin lugar a dudas, la trilogía ES UN IMÁN del que no te podrás separar». Blog Juvenil romántica «Los personajes, la trama, las tres novelas en sí, aportan al lector una historia adictiva que no podrá abandonar hasta haberla leído de principio a fin». Blog Luna lunera «Kerstin Gier ha ido encajando las piezas de este puzzle compuesto por viajes en el tiempo, que hará de esta saga una lectura entretenida, ágil y con su pizca de fantasía y amor». Blog Más allá de las palabras «Diferente, adictiva y emocionante, los ingredientes necesarios para hacer de esta trilogía una saga especial y sumamente interesante». Blog El amor más allá del tiempo «Una trama de lo más maravillosa, es un cóctel explosivo. No podréis parar de reír y sufriréis, sufriréis hasta la última página». Blog Adicción literaria «Lo mejor de los libros son los personajes. Son diferentes; Gwen es simpática y luchadora, Gideon no sabemos de qué pie cojea, Xemerius es total». Blog Lágrimas de cristal «Sin duda Rubí, Zafiro y Esmeralda ocupan desde ya un lugar especial en mi estantería y en mi corazón». Blog Estrellas y páginas «Unas novelas que consiguen adentrarse en tu corazón y hacer de este un lugar más cálido. Definitivamente Gwen se ha convertido en un personaje diez, y me he enamorado de Gideon». Blog La estrella de mi camino «Una de las trilogías más redondas y satisfactorias leídas en los últimos tiempos». Blog Alice in wonderland', v_215, 'PDF/Esmeralda - Kerstin Gier.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El jefe' AND Autor = 'Victoria Quinn') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El jefe', 'Victoria Quinn', 'Emanuel Herrera Batista (Bajos de Haina, Provincia de San Cristóbal, 18 de diciembre de 1990) conocido artísticamente como el Alfa, es un cantante dominicano.​ Su música principalmente es dembow dominicano, aunque también hace y utiliza otros ritmos urbanos latinos.​​', v_98, 'PDF/El jefe - Victoria Quinn.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Juego de ángeles' AND Autor = 'María Martínez') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Juego de ángeles', 'María Martínez', 'Última entrega de la trilogía «Almas Oscuras». Para todos los amantes de las novelas de vampiros y para los que creen que el amor no entiende de fronteras ni de mundos. La maldición se ha roto y la única debilidad que mantenía a los vampiros en las sombras ha desaparecido. En pocos días, cientos de renegados comenzarán a tomar las calles y a convertir humanos. Aunque ese no es el mayor problema al que deberá enfrentarse William. La tregua entre los ángeles se ha roto y no tardarán en declararse la guerra. Las lectoras dicen: «Oscuro, inquietante, impredecible. El final perfecto para una trilogía que me ha mantenido pegada a sus páginas desde la primera escena. Me era imposible dejar de leer.» Cristina Mas, Leyendo entre horas «Una lectura absorbente y muy sexy. Un giro argumental inesperado. Unos personajes complejos y pasionales que parecen saltar de la página gracias al talento de la autora.» Marta Fernández, Tejiendo críticas en la sombra «Emocionante e intensa. La trilogía que necesitaba para volver a engancharme y caer en las redes de las historias de vampiros y licántropos.» María Cabal, Soy Cazadora de Sombras y Libros', v_160, 'PDF/Juego de ángeles - María Martínez.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Bill Gates en sus propias palabras' AND Autor = 'Lisa Rogak') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Bill Gates en sus propias palabras', 'Lisa Rogak', 'Ruthless billionaire or benevolent philanthropist? Whatever your take on him, Bill Gates is a force to be reckoned with in the world of business and in the realm of international philanthropy. Hailed by most as an ingenious visionary and considered by some to be an unscrupulous monopolist, Gates has had an indelible impact on the growth of digital technology. As founder and former CEO of Microsoft, he helped spearhead one of the greatest revolutions in modern history, seizing on the importance of software in the rise of personal computing and becoming in 1987 - at the age of 31 - the youngest ever self-made billionaire. But Gates''s second act has been no less compelling than his first. After leaving Microsoft''s day-to-day operations in 2008 to devote himself full-time to the Bill & Melinda Gates Foundation, a kinder, gentler Gates began to emerge, one deeply concerned with Third World health issues and educational reform. Drawing on more than three decades of media coverage - print, electronic and online - this book offers real insight into the man behind the millions. Essential reading for anyone seeking wisdom from the world''s entrepreneur extraordinaire.', v_64, 'PDF/Bill Gates en sus propias palabras - Lisa Rogak.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Genética Molecular y Citogenética Humana' AND Autor = 'César Paz-y-Miño; Andrés López-Cortés') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Genética Molecular y Citogenética Humana', 'César Paz-y-Miño; Andrés López-Cortés', NULL, v_176, 'PDF/Genética Molecular y Citogenética Humana - César Paz-y-Miño; Andrés López-Cortés.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Metamanagement. Tomo 1: Principios' AND Autor = 'Fredy Kofman') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Metamanagement. Tomo 1: Principios', 'Fredy Kofman', NULL, v_87, 'PDF/Metamanagement. Tomo 1 Principios - Fredy Kofman.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Origin' AND Autor = 'Jennifer L. Armentrout') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Origin', 'Jennifer L. Armentrout', 'Origin by Jennifer Armentrout, Book Four of the bestselling Lux series Daemon will do anything to get Katy back. After the successful but disastrous raid on Mount Weather, he''s facing the impossible. Katy is gone. Taken. Everything becomes about finding her. Taking out anyone who stands in his way? Done. Burning down the whole world to save her? Gladly. Exposing his alien race to the world? With pleasure. All Katy can do is survive. Surrounded by enemies, the only way she can come out of this is to adapt. After all, there are sides of Daedalus that don''t seem entirely crazy, but the group''s goals are frightening and the truths they speak even more disturbing. Who are the real bad guys? Daedalus? Mankind? Or the Luxen? Together, they can face anything. But the most dangerous foe has been there all along, and when the truths are exposed and the lies come crumbling down, which side will Daemon and Katy be standing on? And will they even be together?', v_84, 'PDF/Origin - Jennifer L. Armentrout.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Unida a los guerreros' AND Autor = 'Grace Goodwin') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Unida a los guerreros', 'Grace Goodwin', 'Cuando las circunstancias la dejan sin otra opción más que ofrecerse como voluntaria en el Programa de Novias Interestelares, Hannah Johnson es asignada no solo a un compañero, sino a dos. Sus futuros esposos son guerreros del planeta Prillon, un mundo cuyos hombres son conocidos en todos lados debido a su destreza en las batallas y en la cama. Luego de ser transportada en una nave espacial hacia el otro lado de la galaxia, Hannah se despierta en presencia de Zane Deston, el enorme y ferozmente guapo comandante de la flota Prillon. Tras hacerle saber que es ahora su compañera, así como la de su segundo, Zane se encarga de supervisar la manera minuciosa e íntima en la que Hannah es examinada. Su incapacidad de cooperar adecuadamente con el doctor de la nave le vale una dolorosa y vergonzosa nalgada sobre su trasero desnudo, pero es la reacción de su cuerpo ante el examen lo que la hace sonrojarse de verdad. A pesar de su desconcierto ante la perspectiva de ser compartida entre Zane y su segundo, el atractivo guerrero Dare, Hannah no puede esconder su excitación mientras estos dos machos alfa se toman su tiempo para dominar su cuerpo. A medida que el día de la ceremonia de unión se aproxima, Hannah comienza a anhelar el momento en el que Zane y Dare la hagan totalmente suya; pero ¿se arriesgará a entregar su corazón a unos hombres que podrían morir en combate en cualquier momento?', v_201, 'PDF/Unida a los guerreros - Grace Goodwin.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Strawberry Moon: La hija de la luna' AND Autor = 'Laia López') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Strawberry Moon: La hija de la luna', 'Laia López', 'Diana es una sirena hija de la Luna que, al cumplir la mayoría de edad, decide salir a la superficie para vivir como los humanos. En la universidad coincide con Edlyn, Mako, Isla y Lucas, otros seres como ella. Bajo las aguas de la laguna, Diana siempre había estado sola, pero ahora tiene grandes amigos con los que compartir su día a día. Además, está Eiden, ese humano tan simpático al que tiene ganas de conocer más... Sin embargo, su amistad con él podría hacer peligrar la vida de todas las sirenas y tritones del planeta. Entre tanto, en el campus están pasando cosas de lo más extrañas. Los alumnos desaparecen continuamente, e Isla sospecha que detrás de esto están las merrows, otra especie de sirenas capaces de arrebatar las almas de los humanos. Pero hacía ya muchos años que las merrows respetaban el pacto de paz establecido por el consejo de la laguna; ¿por qué lo tendrían que romper justo ahora?', v_215, 'PDF/Strawberry Moon- La hija de la luna - Laia López.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El heredero salvaje' AND Autor = 'Karina Halle') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El heredero salvaje', 'Karina Halle', NULL, v_98, 'PDF/El heredero salvaje - Karina Halle (2).pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'La novia del millonario ruso' AND Autor = 'Leona Lee') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('La novia del millonario ruso', 'Leona Lee', NULL, v_38, 'PDF/La novia del millonario ruso - Leona Lee.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Adorada por su lobo' AND Autor = 'T. N. Hawke') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Adorada por su lobo', 'T. N. Hawke', NULL, v_93, 'PDF/Adorada por su lobo - T. N. Hawke.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Zafiro' AND Autor = 'Kerstin Gier') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Zafiro', 'Kerstin Gier', 'Cruza las fronteras del tiempo y encuentra el verdadero amor. Sigue la grandiosa aventura de Gideon y Gwen: un torbellino de sentimientos que arrastra a los protagonistas a través de los siglos. Gwen vive en una nube... ¡con Gideon!, aunque sabe bien que el amor entre dos viajeros en el tiempo puede deparar sorpresas traicioneras. Por suerte, tiene muy buenos consejeros: su mejor amiga, Leslie, su compinche, James el fantasma, y Xemerius, una gárgola que se mete en bastantes líos. Además, Gwen y Gideon tienen importantes problemas de los que ocuparse... Por ejemplo, salvar el mundo. O aprender a bailar un minué (algo nada fácil). Sin embargo, ambos deberán entender que el amor debe pasar por delante de lo demás, sobre todo cuando caigan en las redes del conde de Saint Germain... Todo había empezado con aquel beso. Gideon de Villiers me había besado a mí: Gwendolyn Sheperd. Naturalmente, debería haberme preguntado por qué se le habría ocurrido aquella idea de una forma tan repentina y en unas circunstancias tan extrañas, escondidos en un confesionario y todavía sin aliento tras una persecución de película por medio Londres. Pero el hecho era que en aquel momento yo no pensaba absolutamente en nada, aparte quizá de que no quería que el beso acabara nunca. Por eso tampoco fui del todo consciente del tirón que sentí en el vientre ni me di cuenta de que entre tanto habíamos vuelto a saltar en el tiempo... Reseña: «Kerstin debe de haber lanzado algún tipo de magia entre sus páginas. La historia es alucinante... ¡Quién fuera Gwen para pasar dos horas con Gideon en un sofá! ¡A SOLAS! Sin lugar a dudas, la trilogía ES UN IMÁN del que no te podrás separar. ¡Imprescindible en tu estantería!» Eva Rubio, administradora de JUVENIL ROMÁNTICA', v_215, 'PDF/Zafiro - Kerstin Gier.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Porque eres mía' AND Autor = 'Beth Kery') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Porque eres mía', 'Beth Kery', NULL, v_38, 'PDF/Porque eres mia - Beth Kery.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Reverenciada por su lobo' AND Autor = 'T. N. Hawke') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Reverenciada por su lobo', 'T. N. Hawke', NULL, v_93, 'PDF/Reverenciada por su lobo - T. N. Hawke.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¿Cómo crece tu jardín?' AND Autor = 'Agatha Christie') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¿Cómo crece tu jardín?', 'Agatha Christie', 'Una anciana llamada Amelia Barrowby envía a Poirot una extraña carta explicando que necesita sus servicios. En su mensaje, insiste en que la discreción es fundamental porque su familia podría estar involucrada en el asunto. El detective acepta y propone un encuentro, pero no vuelve a tener noticias de su cliente. Cinco días más tarde, el periódico anuncia la muerte de la señora Barrowby. Hércules Poirot visitará su casa e investigará a la familia hasta descubrir toda la verdad.', v_18, 'PDF/Como crece tu jardin - Agatha Christie.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Pareja asignada' AND Autor = 'Grace Goodwin') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Pareja asignada', 'Grace Goodwin', 'La única manera de salvar a la testigo Eva Daily hasta el juicio es escondiéndola en prisión y sacándola del planeta a través del Programa de Novias Interestelares como Evelyn Day. Pero la unión con Tark de Trion es real. Y él exige que Eva se someta, en cuerpo y alma, porque ha estado esperándola y está decidido a quedarse con ella.', v_202, 'PDF/Pareja asignada - Grace Goodwin.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¡Sálvese quien pueda!' AND Autor = 'Andrés Oppenheimer') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¡Sálvese quien pueda!', 'Andrés Oppenheimer', 'Manteniéndose fiel a su característico estilo periodístico, Andrés Oppenheimer lleva a sus lectores en un nuevo viaje, esta vez a través del mundo, con la intención de comprender cuál será el futuro de los trabajos de hoy en el día, mientras se aproxima lo que muchos han denominado como la era de la automatización. Tal como lo indican dos de los entrevistados de Oppenheimer -ambos expertos en tecnología y economía de la Universidad de Oxford- el cuarenta y siete por ciento de los trabajos existentes corren el riesgo de automatizarse o volverse obsoletos debido a los avances tecnológicos y el crecimiento de los productos y servicios en línea que están por venir en los próximos veinte años. Oppenheimer conversa con expertos en sus campos y examina los cambios que ya comienzan a desarrollarse en varias áreas de empleo, incluyendo en la industria de alimentos, en el mundo legal, en la banca y en la medicina. Oppenheimer contrapone también las perspectivas de los "tecno-optimistas" con las de los "tecno-negativistas" e intenta encontrar un término medio entre una visión alarmista del futuro y una que es demasiado acrítica. Autodenominado un "optimista cauteloso", Oppenheimer opina que la tecnología no necesariamente creará un desempleo masivo, sino más bien cambiará drásticamente la definición de lo que hoy conocemos como un "empleo".', v_105, 'PDF/¡Sálvese quien pueda! - Andrés Oppenheimer.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Elementary Vocabulary' AND Autor = 'B. J. Thomas') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Elementary Vocabulary', 'B. J. Thomas', 'This text contains over 1500 lexical items, divided into topic areas, with exercises to provide the practice students need to build their vocabulary in an interesting way. The material can be used in pairs or groups, as well as by students working individually, at elementary to advanced level.', v_14, 'PDF/Elementary Vocabulary - B. J. Thomas.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Oscuros. La trampa del amor' AND Autor = 'Lauren Kate') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Oscuros. La trampa del amor', 'Lauren Kate', NULL, v_149, 'PDF/Oscuros. La trampa del amor - Lauren Kate.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¡Préstame a tu novio!' AND Autor = 'Iris Boo') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¡Préstame a tu novio!', 'Iris Boo', NULL, v_86, 'PDF/¡Préstame a tu novio! - Iris Boo.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El Devorador de Almas' AND Autor = 'Michelle Paver') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El Devorador de Almas', 'Michelle Paver', 'Tercera entrega de «Crónicas de la prehistoria», una emocionante serie de aventuras prehistóricas que ya cuenta con un numeroso grupo de jóvenes lectores. Los protagonistas deberán recurrir en esta aventura a todo su coraje e ingenio para salvar a su amigo. Torak, Renn y Lobo viven unos días apacibles tras superar las azarosas peripecias de su última aventura. Sin embargo, cuando por fin han logrado reunirse, muy pronto se ven enfrentados a la peor pesadilla imaginable: durante una rutinaria partida de caza, los Devoradores de Almas secuestran a Lobo con malévolos designios. Así, para seguir la pista de su entrañable amigo, Torak tiene que recurrir a su recién descubierto poder de trasladar su espíritu al cuerpo de diversos animales, aunque el uso de este portentoso don tiene terribles consecuencias que pueden costarle muy caras a nuestro joven héroe. El desenlace se librará en el lejano y helado Norte, donde nuestros intrépidos protagonistas deberán recurrir a todo su ingenio y coraje en un entorno inhóspito y plagado de peligros indescriptibles. Reseñas: «Una aventura maravillosamente imaginada.» Times Educational Supplement «Soberbio.» The Times', v_206, 'PDF/El Devorador de Almas - Michelle Paver.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Teoría del cuerpo enamorado' AND Autor = 'Michel Onfray') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Teoría del cuerpo enamorado', 'Michel Onfray', NULL, v_204, 'PDF/Teoría del cuerpo enamorado - Michel Onfray.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El jefe supremo' AND Autor = 'Victoria Quinn') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El jefe supremo', 'Victoria Quinn', NULL, v_98, 'PDF/El jefe supremo - Victoria Quinn.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Rebel' AND Autor = 'Marie Lu') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Rebel', 'Marie Lu', 'Respect the Legend. Idolize the Prodigy. Celebrate the Champion. But never underestimate the Rebel. Coming soon as a graphic novel! With unmatched suspense and her signature cinematic storytelling, #1 New York Times–bestselling author Marie Lu plunges readers back into the unforgettable world of Legend for a truly grand finale. Eden Wing has been living in his brother’s shadow for years. Even though he’s a top student at his academy in Ross City, Antarctica, and a brilliant inventor, most people know him only as Daniel Wing’s little brother. A decade ago, Daniel was known as Day, the boy from the streets who led a revolution that saved the Republic of America. But Day is no longer the same young man who was once a national hero. These days he’d rather hide out from the world and leave his past behind. All that matters to him now is keeping Eden safe—even if that also means giving up June, the great love of Daniel’s life. As the two brothers struggle to accept who they’ve each become since their time in the Republic, a new danger creeps into the distance that’s grown between them. Eden soon finds himself drawn so far into Ross City’s dark side, even his legendary brother can’t save him. At least not on his own . . .', v_20, 'PDF/Rebel - Marie Lu.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Tómame' AND Autor = 'Anna Zaires') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Tómame', 'Anna Zaires', 'Puede que Yulia haya escapado, no está a salvo. El peligro que conlleva mi trabajo me tiene muy ocupado, pero vivo para perseguirla. Y cuando la encuentre, ya no volverá a escapar. ﻿ Haré lo que sea para retenerla.', v_188, 'PDF/Tómame - Anna Zaires.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Reclamada por su alfa' AND Autor = 'T. N. Hawke') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Reclamada por su alfa', 'T. N. Hawke', NULL, v_93, 'PDF/Reclamada por su alfa - T. N. Hawke.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El heredero salvaje' AND Autor = 'Karina Halle') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El heredero salvaje', 'Karina Halle', NULL, v_98, 'PDF/El heredero salvaje - Karina Halle.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Psicología del color' AND Autor = 'Eva Heller') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Psicología del color', 'Eva Heller', 'Este libro aborda la relación de los colores con nuestros sentimientos y demuestra cómo ambos no se combinan de manera accidental, pues sus asociaciones no son meras cuestiones de gusto, sino experiencias universales que están profundamente enraizadas en nuestro lenguaje y en nuestro pensamiento. Organizado en 13 capítulos que corresponden a 13 colores distintos, el volumen poporciona una gran cantidad y variedad de información sobre los colores: desde dichos y saberes populares, hasta su utilización en el diseño de productos, los diferentes tests que se basan en colores, la curación por medio de ellos, la manipulación de las personas, los nombres y apellidos relacionados con colores, etc. La diversidad de este enfoque convierte a la obra de Eva Heller en una herramienta fundamental para todas aquellas personas que trabajan con colores: artistas, terapeutas, diseñadores gráficos e industriales, interioristas, arquitectos, diseñadores de moda, publicistas, entre otros.', v_211, 'PDF/Psicologia del color - Eva Heller.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Átame' AND Autor = 'Anna Zaires') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Átame', 'Anna Zaires', 'Mi nueva prisionera es una contradicción que me vuelve loca: obediente pero desafiante, frágil pero fuerte. Tengo que descubrir sus secretos, pero hacerlo podría truncarlo todo. Mi obsesión podría destruirnos a ambos.', v_193, 'PDF/Átame - Anna Zaires.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'La princesa fiel' AND Autor = 'Philippa Gregory') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('La princesa fiel', 'Philippa Gregory', 'A los tres años de edad, Catalina de Aragón es prometida al príncipe Arthur, hijo y heredero de Henry VII de Inglaterra, y es educada para convertirse en princesa de Gales. Sin embargo, tiene que soportar duras pruebas. Finalmente, Catalina se va adaptando poco a poco a la primera corte de la dinastía Tudor y su vida como esposa de Arthur le resulta menos insoportable de lo que creía al principio. Cuando su esposo fallece, Catalina se ve obligada a construir un futuro propio. Su única salida es casarse con el hermano menor de Arthur, Harry. Henry y su madre se oponen a ese matrimonio y los poderosos padres de Catalina tampoco lo ven con buenos ojos... Pero la joven ha heredado de su madre, Isabel la Católica, su indomable espíritu de lucha.', v_121, 'PDF/La princesa fiel - Philippa Gregory.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Prodigy' AND Autor = 'Marie Lu') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Prodigy', 'Marie Lu', 'The second book in the best-selling Legend trilogy comes to life in this vibrant graphic novel adaptation. After escaping from the Republic''s stronghold, Day and June are on the run in Vegas when the country learns that their Elector Primo has died and his son has stepped in to take his place. They meet up with the rebel stronghold of the Patriots—a large organization straddling the line between the Republic and its warring neighbor, the Colonies—and learn about an assassination plot against the Elector. Using threats and blackmail to get what he wants, the Patriots'' leader, Razor, convinces June to let herself be captured by Republic soldiers so she can win over the Elector and feed him a decoy assassination plan. But when June realizes that the new Elector is nothing like his father, she must work with Day to try to stop the Patriots'' plot before Razor can fulfill his own devastating plans.', @Cat_Distopacienciaficcinjuvenil, 'PDF/Prodigy - Marie Lu.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Corona de medianoche' AND Autor = 'Sarah J. Maas') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Corona de medianoche', 'Sarah J. Maas', 'Una joven y famosa asesina condenada a muerte es liberada de las minas de sal en donde sirve condena a condición de competir en un torneo en el que se seleccionará al paladín oficial del rey. Se ha tenido que enfrentar a ladrones, asesinos profesionales y guerreros de todo el imperio y no solo ha salido con vida, sino que ha resultado la ganadora del certamen. Ahora Celaena deberá servir al rey durante tres años antes de ganar su libertad. Pero Caelena no puede aceptar sumisamente las macabras órdenes del monarca del Reino de Endovier y deberá poner en riesgo todo aquello que ha aprendido a querer: al atractivo capitán de la guardia y al propio príncipe. Además oscuras y poderosas fuerzas se están concentrando en el horizonte y amenazan con destruir todo su mundo. Ella es la única esperanza del reino y tendrá que elegir a quién debe lealtad y por lo que está más dispuesta a luchar.', v_215, 'PDF/Corona de medianoche - Sarah J. Maas.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Ciudad de las almas perdidas' AND Autor = 'Cassandra Clare') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Ciudad de las almas perdidas', 'Cassandra Clare', 'Jace es ahora un sirviente del mal, vinculado a Sebastian por toda la eternidad. Solo un pequeño grupo de Cazadores de Sombras cree posible su salvación. Para lograrla, deben desafiar al Cónclave, y deben actuar sin Clary. Porque Clary está jugando a un juego muy peligroso por su propia cuenta y riesgo. Si pierde, el precio que deberá pagar no consiste tan solo en entregar su vida, sino también el alma de Jace. Clary está dispuesta a hacer lo que sea por Jace, pero ¿puede seguir confiando en él? ¿O lo ha perdido para siempre? ¿Es el precio a pagar demasiado alto, incluso para el amor?', v_186, 'PDF/Ciudad de las almas perdidas - Cassandra Clare.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Chantajes sexuales' AND Autor = 'Dorgeval') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Chantajes sexuales', 'Dorgeval', NULL, v_5, 'PDF/Chantajes sexuales - Dorgeval.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¡Ya supéralo! Te adaptas, te amargas o te vas' AND Autor = 'César Lozano') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¡Ya supéralo! Te adaptas, te amargas o te vas', 'César Lozano', 'Aléjate de las malas decisiones y transforma tu vida para ser feliz. ¿Por qué te aferras a alguien que no te ama? ¿Qué ganas con discutir todo el tiempo? ¿Quién te dijo que hacerte la víctima te garantiza obtener lo que deseas? ¡Ya supéralo! La dicha no está en quienes te rodean, ¡debes crearla!, deja de culpar a los demás de lo que no puedes resolver, ¿así, o más claro? Con su estilo incomparable, lecciones de vida, anécdotas y experiencias que han marcado su camino, César Lozano entrega en este libro los consejos más efectivos para superar una traición, deshacerte de tu imaginación destructiva, evitar a los vampiros emocionales y alejarte del rencor. Consciente de que ante una pérdida es imposible hablar de superarla, te invita a comprender el dolor profundo para sobrellevarla y hacer menos dolorosa la ausencia o la muerte de un ser querido. ¡Ya supéralo! Te adaptas, te amargas o te vas, te ayuda a decidir siempre por tu bien, a no cargar todos los días tus miedos e inseguridades; el autor, bestseller internacional, te comparte numerosas reflexiones para que te olvides de la perfección que buscas pues sólo te estresa. El libro tiene el propósito de hacerte más claro y directo el camino hacia el bienestar.', v_173, 'PDF/¡Ya supéralo! Te adaptas, te amargas o te vas - César Lozano.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Oscuros' AND Autor = 'Lauren Kate') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Oscuros', 'Lauren Kate', 'Oscuros (en inglés: Fallen) es una novela romántica de ángeles caídos dirigida al público adolescente, escrita por Lauren Kate y publicada en 2009.
De esta gran historia de fantasía se desprenden 5 libros más y un anexo, en total 6, el primero es Oscuros (2009), el segundo El poder de las sombras (2010), el tercero La trampa del amor  (2011), el cuarto La primera maldición (2012), y el quinto El retorno de los caídos (2015). Después de que se publicara el primer libro de "Oscuros" en 2009, los derechos de los cinco libros fueron comprados en su totalidad para ser llevados a la gran pantalla. El 9 de septiembre del 2022 Variety informo sobre la preparación de una serie de televisión de Fallen (Oscuros), la producción esta acargo de Silve Reel y Night Train Media, con la coproducción del servicio de streaming brasileño Globoplay.​ La saga ha sido traducida a más de 30 idiomas.
Lauren Kate publicó en noviembre de 2015 el quinto libro de la saga llamado en inglés "Unforgiven", que se centra solo en el personaje de Cam, el personaje antagonista de "Oscuros". Según Kate la historia narra qué fue lo que pasó con Cam una vez que termina el libro "La primera maldición", esto fue como respuesta a los fanes que querían saber más de este personaje y qué es lo que le depara después de su misteriosa despedida en el último libro.
El anexo se llama La eternidad y un día (2012), donde se relata la historia de amor de 4 de las parejas principales de la historia.​', v_74, 'PDF/Oscuros - El poder de las sombras - Lauren Kate.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Repostería esencial' AND Autor = 'Cornelia Schinharl y Sebastian Dickhaut') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Repostería esencial', 'Cornelia Schinharl y Sebastian Dickhaut', NULL, v_196, 'PDF/Reposteria esencial - Cornelia Schinharl y Sebastian Dickhaut.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Predestined' AND Autor = 'Abbi Glines') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Predestined', 'Abbi Glines', 'You would think after helping save her boyfriend from an eternity in Hell that things would go back to normal. Well, as normal as life can be when you can see souls and your boyfriend is Death. But for Pagan Moore, things are just getting weirder. The high school quarterback and reigning heartthrob, Leif Montgomery, is missing. While the town is in a frenzy of worry, Pagan is a nervous wreck for other reasons. Apparently good ''ol Leif isn''t your average teenage boy. He isn''t even human. According to Death, Leif doesn''t have a soul. The quarterback may have skipped town but he''s still showing up in Pagan''s dreams... uninvited. Dank has known from the beginning Leif wasn''t human. But he hadn''t worried about a simple soulless creature. Now, he realizes he made a grave mistake. Pagan''s soul has been marked since birth as a restitution, to a spirit so dark not even Death walks near it. Dank knows saving Pagan''s soul won''t be easy but Pagan is his. And he''s already proven he''ll defy Heaven to keep her. If Hell wants a piece of him too, then bring it on.', v_93, 'PDF/Predestined - Abbi Glines.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Kundalini Yoga' AND Autor = 'Anónimo') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Kundalini Yoga', 'Anónimo', 'El kundalini yoga (de Kuṇḍalinī más yoga) es una disciplina física, mental y espiritual basada en distintos senderos yóguicos como
raya yoga,
shakti yoga,
kriya yoga y
nada yoga (desarrollo de los nāḍī , o ‘ríos’ de energía dentro del cuerpo) —que están basados en los pilares del texto sánscrito Yoga sutra (de Patanyali, siglo III a. C.)— con agregados de bhakti (devoción a Dios) y tantra.
El Kundalini yoga es muy parecido al laya yoga (yoga que se enfoca en la fusión de la consciencia individual con la consciencia universal), en el aspecto de que ambos se basan en el desarrollo  y control de la energía (al parecer básicamente prāṇa), que según los hinduistas reside en el ser humano y debe unirse a la consciencia universal (que en el caso del kundalini yoga sería Shivá en el chakra coronario (sahasrara), situado en la parte superior de la cabeza), diferenciándose el Kundalini, por enfocar su concentración en todos los chakras a diferencia del laya yoga que suele en su práctica el tener que enfocarse directamente en el Chakra superior Ajna que está ubicado en el entrecejo del individuo.
La difusión a nivel mundial de esta disciplina en el siglo XX se debió principalmente gracias al trabajo del maestro Yogui Bhajan. Sin embargo su uso en occidente por parte de la corriente de la nueva era ha tergiversado su verdadera esencia, pasando a ser solo otra forma de esoterismo, a diferencia de lo que sucede en la India.', v_199, 'PDF/Kundalini Yoga - Anonimo.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¡No te soporto, vecino!' AND Autor = 'Olympia Russell') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¡No te soporto, vecino!', 'Olympia Russell', NULL, v_86, 'PDF/¡No te soporto, vecino! - Olympia Russell.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¿Quién mató a Alex? El secreto desvelado' AND Autor = 'Janeth G. S.') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¿Quién mató a Alex? El secreto desvelado', 'Janeth G. S.', 'El fenómeno que arrasa en Wattpad. Más de 37 millones de lecturas. Premio Wattys. Hannah es una adolescente de dieciséis años enganchada a las redes sociales. Pero un día recibe una solicitud de amistad de Facebook de un chico llamado Alex Crowell. Al aceptarla, descubre en el muro de Alex que está muerto. Y luego pasa algo todavía más escalofriante: recibe un mensaje privado del joven donde él le pide ayuda para averiguar quién lo mató. En una trepidante investigación, Hannah descubre que hay muchas personas involucradas en su muerte. Pero contará con una ayuda inesperada, la del fantasma de Alex.', v_133, 'PDF/Quien mato a Alex El secreto desvelado - Janeth G. S..pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Dirty Red' AND Autor = 'Tarryn Fisher') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Dirty Red', 'Tarryn Fisher', 'Manipulation. Lies. Backstabbing. Just your typical obsessively toxic love triangle. Dear Opportunist, You thought you could take him from me, but you lost. Now that he''s mine, I''ll do anything to keep him. Do you doubt me? I have everything that was supposed to be yours. In case you were wondering—he doesn''t even think about you anymore. I won''t let him go…ever. Dirty Red Leah Smith finally has everything she’s ever wanted. Except she doesn''t. Her marriage feels more like a loan than a lifelong commitment, and the image she has worked so hard to build is fraying before her eyes. With a new role and a past full of secrets, Leah must decide how far she is willing to go to keep what she has stolen. You know Olivia’s side of the story, but now it’s Leah’s turn.', v_98, 'PDF/Dirty Red - Tarryn Fisher.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Inframundo' AND Autor = 'S. D. Perry') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Inframundo', 'S. D. Perry', 'Umbrella está creando monstruosos asesinos biológicos. A pesar de su inmenso poder, está empezando a perder el control de sus instalaciones secretas, pero una de las más avanzadas está a punto de entrar en funcionamiento. En su interior se encuentra también la clave para detener a Umbrella de una vez por todas. Pero Leon, Claire, Redfield y Rebeca deberán superar los horrores de la ingeniería genética que les esperan bajo tierra.', v_48, 'PDF/Inframundo - S. D. Perry.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Corazón desnudo' AND Autor = 'Elena Montagud') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Corazón desnudo', 'Elena Montagud', 'Has dudado mucho, pero ahora ya lo sabes: es el hombre de tu vida. ¿Cómo conseguirás retenerlo a tu lado? Corazón desnudo es el esperadísimo y ardiente desenlace de la trilogía «Corazón» de Elena Montagud, iniciada con Corazón elástico y Corazón indomable. ADVERTENCIA: El esperado desenlace de esta ardiente e inolvidable trilogía puede dejarte sin respiración. Blanca y Adrián deben separarse cuando él acepta la oferta de montar su obra musical en los escenarios de Broadway. Pero no se trata solo un distanciamiento físico por trabajo y Blanca lo sabe. Detrás de esa separación se esconden también otros miedos que ella no llega a entender del todo y que le hacen temer que Adrián se esté replanteando su relación. Por eso, cuando por fin él la invita al estreno de la obra en Nueva York, una Blanca más decidida y hermosa que nunca se decide a tomar la Gran Manzana al asalto y dejarle claro que ese músico que la enamoró en la adolescencia es el hombre a quien sigue amando y deseando, el único que la hace vibrar de placer y temblar de verdadera emoción. Una novela para quienes se atreven a saltar al abismo del amor sin más red que un corazón sincero. Intenso, vertiginoso, sensible, sexual... Nunca lo olvidarás.', v_98, 'PDF/Corazón desnudo - Elena Montagud.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¡Santa tía Rita, lo que se da no se quita!' AND Autor = 'Verónica García Montiel') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¡Santa tía Rita, lo que se da no se quita!', 'Verónica García Montiel', NULL, v_86, 'PDF/¡Santa tía Rita, lo que se da no se quita! - Verónica García Montiel.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Requiem' AND Autor = 'Lauren Oliver') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Requiem', 'Lauren Oliver', '''The new Hunger Games... '' Cosmopolitan He never loved me. It was all a lie. ''The old Lena is dead,'' I say, and then push past him. Each step is more difficult that the last; the heaviness fills me and turns my limbs to stone. You must hurt, or be hurt. An all-out uprising has been ignited and Lena Haloway is right at its centre. But things have changed. The Wilds are no longer a safe haven for the rebels and pockets of resistance have opened throughout the country. And when a face from her past reappears, Lena is faced with a devastating choice that could tear her and the revolution apart. ''Un-put-downable, a truly fantastic finale.'' Guardian', v_137, 'PDF/Requiem - Lauren Oliver.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Solo Tuya 3' AND Autor = 'Anabel García') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Solo Tuya 3', 'Anabel García', NULL, v_38, 'PDF/Solo Tuya 3 - Anabel Garcia.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Atrápame' AND Autor = 'Anna Zaires') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Atrápame', 'Anna Zaires', '—Yulia —susurra mirándome y sé que siente también esta atracción, esta conexión tan visceral entre nosotros. Quizás tenga todo el poder, pero, en este momento, es tan vulnerable como yo, atrapado en la misma locura. Obligada a unirse a una agencia secreta de inteligencia a una edad muy temprana, la espía e intérprete rusa Yulia Tzakova no es ajena a los hombres peligrosos. Pero nunca ha conocido a uno tan despiadado y cautivador como Lucas Kent. El mercenario de carácter impetuoso la asusta, pero se siente atraída por él, por un hombre al que no tiene más remedio que traicionar. Lucas Kent es la mano derecha de un poderoso traficante de armas y nunca ha conocido a una mujer a la que desee tanto como a Yulia. Está obsesionado con esa preciosa rubia, por lo que no se detendrá ante nada para atraparla y hacerle pagar su traición. Desde las calles gélidas de Moscú hasta la jungla húmeda de Colombia, esta oscura pasión cautivadora los destruirá o los hará libres. ***** «Una montaña rusa perfecta y oscura de acción sobrecogedora y romance abrasador» —Skye Warren, autora superventas del New York Times. «Candente, cautivadora y trepidante» —Josie Litton, autora superventas del New York Times. ***** Más de 60 reseñas de 5 estrellas entre todos los libros. Esto es lo que dicen los lectores: · «Intensa, oscura, erótica, magnética, cautivadora, enigmática, apasionante y muy intrigante». · «…página tras página de anhelo y necesidad, de peligro, de más anhelo, de más peligro. Luego, culminación erótica, más necesidad. Después, dicha romántica y, de nuevo (¡aaahhh!), ¡MÁS PELIGRO! He disfrutado cada minuto leyéndola». · «La intensidad entre Yulia y Lucas era electrizante y trágica de la mejor manera posible». · «Anna Zaires ha creado una nueva obra de arte. Nunca me canso de leer sus relatos. Lucas es otro de sus héroes oscuros, me ha atrapado el corazón desde el principio y esta trilogía siempre será una de las mejores historias románticas y tenebrosas que he leído». · «…el tipo de colecciones que siempre tendrá un hueco en mi corazón». Este práctico paquete rebajado contiene los tres libros de la serie Atrápame: Atrápame, Átame y Tómame.', v_188, 'PDF/Atrapame - Anna Zaires.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Madam Temptress' AND Autor = 'Meghan March') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Madam Temptress', 'Meghan March', 'From New York Times bestselling author Meghan March comes the stunning conclusion to the highly-anticipated Magnolia Duet. I didn’t choose this path. No one would. I played the cards I was dealt. This life made me. This city made me. I won’t apologize for who I’ve become. Moses wouldn''t have me any other way. He says he wants forever, and I’m starting to believe him. But I can’t outrun my past, and my sins are catching up with me. If it’s time to atone, I’ll gladly pay my penance. We might be getting our second chance, but we have to make it out alive first. Madam Temptress is the second book of the Magnolia Duet and should be read following Creole Kingpin.', v_16, 'PDF/Madam Temptress - Meghan March.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Tras el telón' AND Autor = 'Stella Knightley') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Tras el telón', 'Stella Knightley', 'La complicada historia de amor entre Sarah Thomson y Marco Donato continúa. La pasión que los une es profunda, pero ambos han sufrido experiencias traumáticas y tienen miedo de mostrarle al otro sus puntos más vulnerables. Mientras tanto, Sarah ha empezado una nueva investigación histórica En la Alemania de la década de 1930, Katherine Hazleton se escapa de su asfixiante internado y viaja a Berlín siguiendo a un hombre que no le conviene. Cuando su novio la abandona, se encuentra sola y sin dinero en un país extranjero. Las circunstancias la llevan a trabajar como camarera en un cabaret. Allí se reinventa y se convierte en Kitty Katkin, quien no sólo llega a escribir sus propias canciones, sino que las acompaña de bailes atrevidos que se convierten en todo un éxito. Kitty se enamora de Berlín y de un guapo pianista, pero Alemania está cambiando rápidamente. ¿Encontrarán Sarah y Kitty el amor que ambas merecen?', v_203, 'PDF/Tras el telon - Stella Knightley.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Cómo aprender a escuchar' AND Autor = 'Samael Aun Weor') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Cómo aprender a escuchar', 'Samael Aun Weor', NULL, v_104, 'PDF/Cómo aprender a escuchar - Samael Aun Weor.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Amor entre jefes' AND Autor = 'Victoria Quinn') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Amor entre jefes', 'Victoria Quinn', NULL, v_98, 'PDF/Amor entre jefes - Victoria Quinn.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El libro del mindfulness' AND Autor = 'Bhante Henepola Gunaratana') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El libro del mindfulness', 'Bhante Henepola Gunaratana', 'El libro del mindfulness es ya el texto más leído, reconocido y recomendado en todo el mundo acerca de la práctica de la meditación. Joseph Goldstein lo ha elogiado como una obra "extraordinariamente clara y directa". Con un lenguaje muy ingenioso y asequible, Bhante G como cariñosamente se conoce a su autor extiende su mano y ofrece su amplia experiencia y conocimientos a lectores de cualquier extracción y condición. Paso a paso, nos conduce a través de los mitos, realidades y beneficios de la práctica de la meditación y de la atención plena (mindfulness). Con una claridad poco habitual nos revela que ya poseemos el fundamento necesario para vivir nuestra vida de un modo más productivo, consciente y pacífico. Bhante simplemente señala cada herramienta de meditación y nos explica en qué consiste, lo que hace y cómo emplearla con eficacia. Esta edición ampliada incluye el texto completo de la aclamada primera versión, así como un nuevo capítulo dedicado al cultivo del amor-amistad, un tema especialmente importante en el mundo convulso en el que vivimos.', v_197, 'PDF/El libro del mindfulness - Bhante Henepola Gunaratana.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Office Mate' AND Autor = 'Katie Ashley') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Office Mate', 'Katie Ashley', NULL, v_98, 'PDF/Office Mate - Katie Ashley.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El ABC de la actitud' AND Autor = 'John C. Maxwell') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El ABC de la actitud', 'John C. Maxwell', 'Durante una conferencia John C. Maxwell, uno de los gurúes más destacados del liderazgo, preguntó a su audiencia: “¿Qué palabra describe lo que determina nuestra felicidad, aceptación, paz y éxito?”. Como respuesta, del público surgieron palabras como trabajo, educación, dinero, tiempo. Finalmente, alguien dijo “actitud”. Un área tan importante de sus vidas constituía un pensamiento secundario para esas personas... y para casi todos nosotros. Sin embargo, es la fuerza principal que predispone a unos y destroza a otros, que determina si triunfamos o fracasamos. Maxwell desarrolla en este libro la importancia de la actitud y nos motiva a adoptar la que ayude a un líder a pasar el siguiente nivel. ¡La actitud es contagiosa! ¡Asegúrate de que tu equipo esté contagiándose de la actitud correcta! El ABC de la Actitud, junto con El ABC del Éxito, El ABC de las Relaciones y El ABC de la Capacitación integran la colección que se ha convertido en un auténtico best seller de los libros de management inspiracional.', v_174, 'PDF/El ABC de la actitud - John C. Maxwell.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Lucca' AND Autor = 'Sarah Brianne') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Lucca', 'Sarah Brianne', 'Lucca es una ciudad y municipio italiano ubicado en la región de Toscana, en el centro-norte del país. Situada a orillas del río Serchio, en una fértil llanura cercana al mar Tirreno, es la capital de la provincia homónima y cuenta con unos 88 000 habitantes.', v_99, 'PDF/Lucca - Sarah Brianne.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Romance entre jefes' AND Autor = 'Victoria Quinn') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Romance entre jefes', 'Victoria Quinn', NULL, v_98, 'PDF/Romance entre jefes - Victoria Quinn.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Solo Tuya' AND Autor = 'Anabel García') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Solo Tuya', 'Anabel García', 'Solo tuya es el primer álbum de estudio de la cantante y actriz mexicana Aracely Arámbula. Este fue lanzado por el sello Disa Records en 14 de mayo de 2002 como un disco compacto y un casete.​ Solo tuya alcanzó número 35 en la lista de Billboard de los álbumes de música latina y número 19 en México.​ Los dos sencillos — «Te quiero más que ayer», el dúo con Palomo, y «Ojalá» — fueron lanzados en 2002. «Te quiero más que ayer» logró número nueve en México y número 27 en la lista Billboard Hot Latin Tracks.', v_38, 'PDF/Solo tuya - Anabel García.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'La caída' AND Autor = 'Amanda Hocking') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('La caída', 'Amanda Hocking', 'Al descubrir su verdadera identidad, Wendy cae entre dos destinos: el amor y la lealtad. Wendy parece estar más conectada a sus rivales, los Vittra, de lo que jamás imaginó, y estos intentan convencerla de que luche junto a ellos. Con una guerra a punto de estallar, la única esperanza de salvar a los suyos está en desarrollar su fuerza y casarse con un poderoso noble. Dividida entre los dictados de su corazón y la llamada del deber, Wendy tendrá que decidir, y si se equivoca, podría perder todo loque ama.', v_215, 'PDF/La caída - Amanda Hocking.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¡Buenos días, princesa!' AND Autor = 'Blue Jeans') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¡Buenos días, princesa!', 'Blue Jeans', 'Han pasado algo más de dos años en la vida de los chicos que forman “el club de los incomprendidos”. Las cosas han cambiado desde que uno tras otro se fueron encontrando en el camino. Nuevos problemas, secretos, amores, celos... Sin embargo, hasta el momento, su amistad ha podido con todo y con todos.Raúl, se ha convertido en un atractivo joven y en un líder nato; Valeria, derrocha simpatía por donde pisa, aunque no ha vencido del todo a su timidez; Eli, es la que más se ha transformado de todos y se los lleva de calle; María, vigila y sueña tras sus gafas de pasta de color azul; Bruno, no consigue olvidar lo que siente y en lo más profundo de su corazón espera ser correspondido; y Ester, es la nuera que toda madre querría tener aunque no es tan inocente como todos piensan.Son seis chicos que sienten, sufren, aman, creen, ríen, evolucionan... como otros chicos de su edad. Pero los seis son especiales. Al menos, para el resto del grupo.¿Conseguirán superar todas las pruebas que se le van a presentar?Sólo puedes averiguarlo leyendo, ¡Buenos días, princesa!', v_107, 'PDF/Buenos dias, princesa - Blue Jeans (2).pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Creole Kingpin' AND Autor = 'Meghan March') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Creole Kingpin', 'Meghan March', 'New York Times bestselling author Meghan March goes back to New Orleans and the world of Lachlan Mount with a dangerous and bold new anti-hero. The thing about ghosts is they’re supposed to stay dead. That’s exactly what I am, but I can’t stay away from Magnolia Marie Maison for one more day, let alone another year. We’ve already got fifteen of those between us. As it stands, she’ll want to kill me as soon as she lays eyes on me. And knowing her, she’s completely up to the task. But I’m a man on a mission, and I’ve got everything riding on this. So, here I come, Magnolia. This ghost is ready for whatever you got. After all, there’s only one way I want this to end—’til death do us part. Creole Kingpin is the first book in the Magnolia Duet. Magnolia’s story concludes in Madam Temptress.', v_99, 'PDF/Creole Kingpin - Meghan March.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Juegos entre jefes' AND Autor = 'Victoria Quinn') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Juegos entre jefes', 'Victoria Quinn', NULL, v_98, 'PDF/Juegos entre jefes - Victoria Quinn.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'La pelirroja' AND Autor = 'Tarryn Fisher') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('La pelirroja', 'Tarryn Fisher', 'Querida Oportunista: Pensaste que podrías quitármelo, pero perdiste. Ahora él es mío y haré lo que sea para mantenerlo a mi lado. ¿No me crees? Tengo todo lo que se suponía que iba a ser tuyo. Por si acaso te lo preguntabas: no, él ya no piensa en ti. No lo dejaré marchar... Nunca. La Pelirroja Leah Smith tiene por fin todo lo que quería. O quizá no. Su matrimonio parece cada vez más un préstamo que un compromiso para toda la vida, y la imagen que tanto ha trabajado para construir está deshilándose ante sus propios ojos. Con un nuevo rol y un pasado lleno de secretos, Leah debe decidir hasta dónde está dispuesta a llegar para mantener aquello que robó.', v_100, 'PDF/La pelirroja - Tarryn Fisher.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Broken Juliet' AND Autor = 'Leisa Rayven') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Broken Juliet', 'Leisa Rayven', 'Leisa Rayven has captivated millions of fans with her intoxicating romance set behind the theater’s curtains. For the first time together in an exhilarating eBook bundle, fall in love again with the Starcrossed series: Bad Romeo Cassie Taylor was the good girl actress until she met bad boy Ethan Holt in their college’s production of Romeo and Juliet. Like their characters, Cassie and Ethan’s epic romance ended in tragedy; but now, years later, they’re on Broadway together, and Ethan is determined to change their ending. Broken Juliet Reunited ex-lovers Cassie and Ethan are starring in a Broadway show together, and Ethan claims to be a changed man...but can Cassie believe him? Or has their love been broken beyond repair? Wicked Heart Elissa Holt has only ever loved Liam Quinn. But when they have to work together on his new Broadway show (alongside his fiancé), Elissa realizes that love doesn’t always follow the script...', v_98, 'PDF/Broken Juliet - Leisa Rayven.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El libro del pan' AND Autor = 'Eric Treuillé y Ursula Ferrigno') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El libro del pan', 'Eric Treuillé y Ursula Ferrigno', 'This book covers the essential techniques of mixing, kneading, shaping, and baking bread. It also contains over 100 recipes, this is the perfect guide for both novice and experienced bakers.', v_152, 'PDF/El libro del pan - Eric Treuille y Ursula Ferrigno.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Switched' AND Autor = 'Amanda Hocking') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Switched', 'Amanda Hocking', 'Switched is the first novel in Amanda Hocking''s bestselling trilogy, Trylle. Wendy Everly knew she was different the day her mother tried to kill her and accused her of having been switched at birth. Although certain she''s not the monster her mother claimed she is, she does feel that she doesn''t quite fit in. She''s bored and frustrated by her small-town life - and then there''s the secret she can''t tell anyone. Her mysterious ability - she can influence people''s decisions, without knowing how, or why . . . When the intense and darkly handsome newcomer Finn suddenly turns up at her bedroom window one night, her world is turned upside down. He holds the key to her past, the answers to her strange powers and is the doorway to a place she never imagined could exist: Förening, the home of the Trylle. Finally everything makes sense. Among the Trylle she is not just different, but special. But what marks her out as chosen for greatness in this world also places her in grave danger. With everything around her changing, Finn is the only person she can trust. But dark forces are conspiring - not only to separate them, but to see the downfall of everything that Wendy cares about. The fate of Förening rests in Wendy''s hands, and the decisions she and Finn make could change all their lives forever . . .', v_215, 'PDF/Switched - Amanda Hocking.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Chloe' AND Autor = 'Sarah Brianne') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Chloe', 'Sarah Brianne', 'Chloe (también estilizado como Chloë, Chloé, Cloe o Cloi)​ es un nombre femenino, cuyo significado es "floreciente" o "fertilidad". Ha sido un nombre muy popular en Reino Unido desde 1990, llegando a la cima de su popularidad en esa y la primera década del siglo XXI. El nombre viene del griego, khlóē, uno de los muchos nombres de la diosa Demeter y se refiere al follaje joven y verde. El nombre aparece en el Nuevo Testamento, en Corintios 1:11 en el contexto de "la casa de Chloe".​', v_99, 'PDF/Chloe - Sarah Brianne.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Seducida por su lobo' AND Autor = 'T. N. Hawke') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Seducida por su lobo', 'T. N. Hawke', NULL, v_93, 'PDF/Seducida por su lobo - T. N. Hawke.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Marca de un alfa' AND Autor = 'Stormy Glenn') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Marca de un alfa', 'Stormy Glenn', NULL, v_93, 'PDF/Marca de un alfa - Stormy Glenn.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El descubrimiento de las brujas' AND Autor = 'Deborah Harkness') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El descubrimiento de las brujas', 'Deborah Harkness', NULL, v_36, 'PDF/El descubrimiento de las brujas - Deborah Harkness.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '7 claves en finanzas personales' AND Autor = 'Sandro Muñoz') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('7 claves en finanzas personales', 'Sandro Muñoz', '�Pasan los a�os y tu situaci�n econ�mica no mejora?�Te gustar�a tener ideas que tienen potencial para cambiar tu vida econ�mica para siempre?Aprende a manejar tu econom�a, a medirla y compararla. Aprende cu�les son tus valores y qu� h�bitos quieres cambiar.Aprender es la clave �quieres?', v_72, 'PDF/7 claves en finanzas personales - Sandro Munoz.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¡Defendámonos de los dioses!' AND Autor = 'Salvador Freixedo') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¡Defendámonos de los dioses!', 'Salvador Freixedo', 'Podria ser que los dioses que nos presentan las religiones fuesen unos embaucadores? Y que los tripulantes de los ovnis tampoco fueran lo que parecen ser, como por ejemplo unos seres de otros planetas que vienen al nuestro por las noches a recoger muestras? Este libro trata de averiguar como se manifiestan las inteligencias extrahumanas y que se esconde realmente detras de ellas, y lo hace buceando tanto en la historia humana -una historia a menudo complicada y plagada de injusticias- como en la no menos compleja historia de las religiones. Quienes son esos "dioses" que desde tiempos inmemoriales parecen ser los instigadores de la mayoria de religiones? Cuales son sus intereses? Por que se entrometen en la vida de las personas y juegan con nosotros? A lo largo de estas paginas el autor busca respuestas a un tema tan controvertido, abordandolo desde un punto de vista donde los limites entre la religion y el fenomeno ovni se difuminan hasta casi desaparecer y convertirse en un todo del que quiza tengamos que defendernos. "Defendamonos de los dioses" es una de las obras mas conocidas de Salvador Freixedo, y una de las mas populares de la ufologia mundial. Esta edicion, revisada y actualizada por el propio autor, no puede faltar en la biblioteca de ningun aficionado a los ovnis... ni a las religiones."', v_55, 'PDF/Defendamonos de los dioses - Salvador Freixedo.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Normas de jefes' AND Autor = 'Victoria Quinn') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Normas de jefes', 'Victoria Quinn', NULL, v_98, 'PDF/Normas de jefes - Victoria Quinn.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Ángel mecánico' AND Autor = 'Cassandra Clare') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Ángel mecánico', 'Cassandra Clare', 'Tessa Gray se dirige a Londres dispuesta a encontrar a su hermano, pero pronto es raptada por las Hermanas Oscuras y rescatada por los Cazadores de Sombras. Tessa se sentirá atraída por Jem y Will, y deberá elegir quién de ellos ganará su corazón mientras los tres siguen en busca de su hermano y descubren que alguien trama acabar con ellos.', v_215, 'PDF/Angel mecanico - Cassandra Clare.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Anhelada por su oso' AND Autor = 'T. N. Hawke') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Anhelada por su oso', 'T. N. Hawke', NULL, v_93, 'PDF/Anhelada por su oso - T. N. Hawke.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Los chamanismos a revisión' AND Autor = 'Josep M.ª Fericgla') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Los chamanismos a revisión', 'Josep M.ª Fericgla', 'Desde hace décadas el fenómeno del chamanismo suscita un enorme interés entre la comunidad científica y el público no especializado. A partir de los años setenta también comenzó a difundirse un neochamanismo occidental popular, normalmente ligado a los movimientos de crecimiento personal. El presente libro es una revisión acutalizada de los conceptos básicos del fenómeno, notablemente de la figura del chamán y de los fenómenos mentales, culturales, terpéuticos y cognitivos que se esconden bajo este arquetipo. También es una crítica lúcida, acerada y no exente de ironía sobre algunas versiones del neochamanismo y sobre el supermercado de creencias en el que se ha convertido la moderna sociedad occidental.', v_205, 'PDF/Los chamanismos a revision - Josep M.a Fericgla.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¿Quién mató a Alex? El secreto desvelado' AND Autor = 'Janeth G. S.') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¿Quién mató a Alex? El secreto desvelado', 'Janeth G. S.', 'El fenómeno que arrasa en Wattpad. Más de 37 millones de lecturas. Premio Wattys. Hannah es una adolescente de dieciséis años enganchada a las redes sociales. Pero un día recibe una solicitud de amistad de Facebook de un chico llamado Alex Crowell. Al aceptarla, descubre en el muro de Alex que está muerto. Y luego pasa algo todavía más escalofriante: recibe un mensaje privado del joven donde él le pide ayuda para averiguar quién lo mató. En una trepidante investigación, Hannah descubre que hay muchas personas involucradas en su muerte. Pero contará con una ayuda inesperada, la del fantasma de Alex.', v_133, 'PDF/¿Quién mató a Alex - El secreto desvelado - Janeth G. S..pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Todo lo que quiero' AND Autor = 'Alanna Ignacio') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Todo lo que quiero', 'Alanna Ignacio', 'Todo lo que quiero (título original All I Want, también conocida como Try Seventeen) es una película comedia-dramática del año 2002, dirigida por Jeffrey Porter y escrita por Charles Kephart. Está protagonizada por Elijah Wood, Franka Potente y Mandy Moore. La película se estrenó en el Festival de Cine de Toronto el 10 de septiembre de 2002 y en el Palm Springs International Film Festival el 12 de enero de 2003.', v_122, 'PDF/Todo lo que quiero - Alanna Ignacio.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Corazón malvado' AND Autor = 'Leisa Rayven') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Corazón malvado', 'Leisa Rayven', NULL, v_98, 'PDF/Corazón malvado - Leisa Rayven.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¡A otra con ese cuento!' AND Autor = 'Raquel Antúnez') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¡A otra con ese cuento!', 'Raquel Antúnez', 'Lucía es una chica normal y corriente que vive cómo quiere y puede. Comparte piso con sus dos mejores amigas, trabaja en una importante empresa y mantiene una relación más o menos estable con Daniel, el chico que le gusta. Pero un buen día todo cambia de la noche a la mañana. Lucía es enviada a otra oficina bajo el mando de una jefa déspota que parece tener algo contra ella. Como si esto no fuese suficiente, además tiene que aguantar a Marcos, un compañero que muestra un extraño interés por ella, no sabe si espía para la jefa o si sólo es un tarado. Para colmo, algo no acaba de funcionar bien con Daniel y la sombra de la sospecha empieza a planear sobre su idílico romance. Y así, con la vida vuelta del revés, Lucía comprende que los cuentos no son más que un embuste y que lo difícil viene justo después del: “Y vivieron felices”. «¡A otra con ese cuento!» es una novela que habla sobre las relaciones y sobre cómo en muchas ocasiones se idealizan los sentimientos. Delicada e íntima, te muestra un punto de vista diferente sobre el amor y sobre los “finales felices”. ¿Vas a perdértelo?', v_98, 'PDF/A otra con ese cuento - Raquel Antunez.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Venerada por su lobo' AND Autor = 'T. N. Hawke') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Venerada por su lobo', 'T. N. Hawke', NULL, v_93, 'PDF/Venerada por su lobo - T. N. Hawke.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Opposition' AND Autor = 'Jennifer L. Armentrout') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Opposition', 'Jennifer L. Armentrout', 'Don''t miss Opposition, the fifth and final book in Jennifer L. Armentrout''s bestselling Lux series, now available as a standalone in print for the first time! "An unmissable series!" –Samantha Young, New York Times bestselling author of On Dublin Street “This is the stuff swoons are made of.” —Wendy Higgins, New York Times bestselling author of Sweet Evil Katy knows the world changed the night the Luxen came. She can''t believe Daemon stood by as his kind threatened to obliterate every last human and hybrid on Earth. But the lines between good and bad have blurred. Daemon will do anything to save those he loves, even if it means betrayal. But when it quickly becomes impossible to tell friend from foe, and the world is crumbling around them, they may lose everything to ensure the survival of their friends...and mankind. Want to read the LUX series on your ereader? Each book is sold individually in e-format: #1: Obsidian #2: Onyx #3: Opal #4: Origin #5: Opposition Dawson’s story: Shadows', v_84, 'PDF/Opposition - Jennifer L. Armentrout.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Drago' AND Autor = 'Sarah Brianne') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Drago', 'Sarah Brianne', NULL, v_99, 'PDF/Drago - Sarah Brianne.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Atada' AND Autor = 'Lorelei James') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Atada', 'Lorelei James', 'Amery Hardwich está tan concentrada en levantar su negocio que apenas tiene tiempo para divertirse. Pero cuando Molly, su ayudante, es víctima de un atraco y se apunta a un dojo de jiu jitsu para recibir clases de defensa personal, Amery no lo duda y la acompaña para apoyarla. Ronin Black, propietario del dojo, se siente tan atraído por Amery que se hace cargo en exclusiva de su formación, tanto en público como en privado. El atractivo y enigmático profesor pone a prueba los límites de la joven desde el principio y, con cada nuevo encuentro amoroso, ella se vuelve más adicta al placer que el sensei le proporciona. Sin embargo, cuando percibe que Ronin le oculta algo, Amery se cuestiona sus sentimientos, a pesar de la innegable excitación que le produce sentirse dominada por él.', v_38, 'PDF/Atada - Lorelei James.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Eldest' AND Autor = 'Christopher Paolini') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Eldest', 'Christopher Paolini', 'Eragon y su dragona, Saphira, tienen que viajar al país de los elfos, para continuar con su formación en la magia y en la lucha con la espada para poder enfrentarse al Malvado rey Galbatoriz.', v_21, 'PDF/Eldest - Christopher Paolini.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¡Y tenía que ser mi jefe! 2' AND Autor = 'Norah Carter, Patrick Norton y Monika Hoff') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¡Y tenía que ser mi jefe! 2', 'Norah Carter, Patrick Norton y Monika Hoff', NULL, v_98, 'PDF/Y tenia que ser mi jefe 2 - Norah Carter, Patrick Norton y Monika Hoff.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'La actitud mental positiva' AND Autor = 'Napoleon Hill y W. Clement Stone') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('La actitud mental positiva', 'Napoleon Hill y W. Clement Stone', NULL, v_214, 'PDF/La actitud mental positiva - Napoleon Hill y W. Clement Stone.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Un rey nórdico' AND Autor = 'Karina Halle') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Un rey nórdico', 'Karina Halle', NULL, v_98, 'PDF/Un rey nordico - Karina Halle.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El inmenso poder de la mente. Tomo II' AND Autor = 'Prof. Fassman') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El inmenso poder de la mente. Tomo II', 'Prof. Fassman', NULL, v_75, 'PDF/El inmenso poder de la mente. Tomo II - Prof. Fassman.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Amada por sus lobos' AND Autor = 'T. N. Hawke') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Amada por sus lobos', 'T. N. Hawke', NULL, v_93, 'PDF/Amada por sus lobos - T. N. Hawke.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Filosofía Lógica' AND Autor = 'Andrés Espíritu Ávila y Francisco Ramos Vásquez') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Filosofía Lógica', 'Andrés Espíritu Ávila y Francisco Ramos Vásquez', NULL, v_78, 'PDF/Filosofia Logica - Andres Espiritu Avila y Francisco Ramos Vasquez.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Formas de pensamiento' AND Autor = 'Annie Besant y Charles W. Leadbeater') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Formas de pensamiento', 'Annie Besant y Charles W. Leadbeater', 'Formas de Pensamiento: Un Registro de Investigación Clarividente (del inglés: Thought-Forms: A Record of Clairvoyant Investigation) es un libro teosófico escrito por Annie Besant y Charles Webster Leadbeater, ambos miembros de la Sociedad Teosófica. Fue publicado originariamente en Londres en 1905.​​ Desde el punto de vista de la Teosofía, expresa dictámenes sobre la visualización de pensamientos, experiencias, emociones y música. Las ilustraciones de las "formas de pensamiento" fueron realizadas por John Varley Jr. (nieto del pintor John Varley), Prince y McFarlane.​​', v_32, 'PDF/Formas de pensamiento - Annie Besant y Charles W. Leadbeater.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El cerebro femenino' AND Autor = 'Louann Brizendine') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El cerebro femenino', 'Louann Brizendine', 'Más de 1 millón de ejemplares vendidos en todo el mundo Un fenómeno internacional que ha cambiado la vida de miles de mujeres «Una guía ágil y esclarecedora sobre las mujeres y una lectura obligada para los hombres». Daniel Goleman ¿Por qué las mujeres tienen mayor capacidad verbal que los hombres? ¿Por qué recuerdan detalles de las peleas que ellos no recuerdan? ¿Por qué tienden a establecer vínculos más profundos con sus amigas que los hombres con sus compañeros? En este libro, Louanne Brizendine reúne los últimos descubrimientos para mostrar cómo cada estado hormonal -años de infancia, de adolescencia, de citas amorosas, de maternidad y de menopausia- actúa como fertilizante de diferentes conexiones neurológicas. Y revela que la estructura singularmente flexible del cerebro femenino determina cómo piensan las mujeres, qué valoran, cómo se comunican y a quién aman. Basado en tres décadas de investigación, El cerebro femenino ayudará a las mujeres a comprenderse mejor a sí mismas y a los hombres de su vida. Reseñas: «El mayor regalo de la autora a sus lectores es la forma en que los lleva a través de las etapas de la vida de una mujer para mostrar la influencia de los niveles hormonales en cada decisión». Los Angeles Times «Louann Brizendine ha hecho un gran favor a todo hombre que quiera entender a las desconcertantes mujeres de su vida. Una guía ágil y esclarecedora sobre las mujeres y una lectura obligada para los hombres». Daniel Goleman, autor de Inteligencia emocional', v_96, 'PDF/El cerebro femenino - Louann Brizendine.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'La trampa dorada' AND Autor = 'Philippa Gregory') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('La trampa dorada', 'Philippa Gregory', 'Inglaterra, 1539. Tras la muerte de Jane Seymour, el rey Enrique VIII vuelve a tomar esposa: su cuarta reina. Desde todos los confines del reino, las jóvenes de familia noble anhelan ser llamadas a la Corte y eludir así un destino poco prometedor. Pero el rey se fija en Ana de Cléveris, hija del duque de Cléveris, a la que únicamente ha visto retratada en pinturas. Juana Bolena y Catalina Howard, dos mujeres caídas en desgracia, sin fortuna que asegure sus dotes, se cuentan entre las elegidas para servir a la nueva reina.No obstante, lo que parece un cuento de hadas de pronto se revela como una trampa dorada. La historia se repite: Enrique VIII se enamora de una de las damas de compañía de su esposa. Pero Ana de Cléveris es una mujer que ha conocido la tiranía desde la infancia, una mujer que sabe del pasado voluble del rey y que, consciente de que se enfrenta al cadalso, tendrá que jugar bien sus cartas.Tras La otra Bolena, La trampa dorada retoma las vicisitudes de la dinastía Tudor después de la ejecución de Ana Bolena. Una novela intensa, de intriga absorbente y factura impecable que captura la época y el sentir de tres mujeres radicalmente opuestas que, sin embargo, verán sus destinos unirse para intentar sobrevivir en la corte de un tirano.«La reina de la novela histórica.» USA Today', v_121, 'PDF/La trampa dorada - Philippa Gregory.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Trono de cristal' AND Autor = 'Sarah J. Maas') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Trono de cristal', 'Sarah J. Maas', 'Un corazón de hielo. Una voluntad de hierro. Bella. Letal. Destinada a la grandeza. Conoce a la asesina Celaena Sardothien, la única capaz de salvar al reino de Endovier. Dos hombres la aman. El mundo entero le teme. Y sólo ella puede salvarse a sí misma. Descubre la primera parte de la trilogía Trono de Cristal, serie bestseller de The New York Times. Seleccionada como Mejor libro para jóvenes de Kirkus Review. En un mundo sin magia, y tras un año de trabajos forzados en las minas de sal, una joven asesina es convocada a palacio. Ella no acude para acabar con el sanguinario rey que gobierna desde su trono de cristal, sino para conquistar su propia libertad. Si vence a veintitrés asesinos, ladrones y guerreros en una competencia a vida o muerte, será absuelta de prisión para ejercer como campeona real. Su nombre es Celaena Sardothien. El príncipe la provocará. El capitán de la guardia la protegerá. Una princesa de lejanas tierras se convertirá en su amiga. Pero algo maligno mora en el castillo y está ahí para matar. Mientras sus competidores van cayendo uno a uno, la lucha de Celaena por su liberación se convierte en una lucha por la sobrevivencia y en una incesante búsqueda del origen del mal antes de que destruya su mundo. La crítica ha opinado: "Una lectura indispensable para los amantes de la fantasía épica y los cuentos de hadas." -USA Today- "Los fans de George R. R. Martin se llevarán este libro." -RT Book Reviews- "Los fans de Juego de tronos y Los juegos del hambre quedarán encantados." Colleen Houck, autora de la serie Tiger''s Curse', v_215, 'PDF/Trono de cristal - Sarah J. Maas.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'The Room Mate' AND Autor = 'Kendall Ryan') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('The Room Mate', 'Kendall Ryan', 'The last time Paige saw her best friend''s younger brother, he was a geek wearing braces. But when Cannon shows up to crash in her spare room he''s twenty-four, broad shouldered and masculine, and so sinfully sexy she wants to climb him like a jungle gym. At six-foot-something with lean muscles hiding under his T-shirt, a deep sexy voice, and full lips that pull into a smirk when he studies her, he''s pure temptation. Fresh out of a messy breakup, he doesn''t want any entanglements. But she can resist, right?--Adapted from page 4 of cover.', v_122, 'PDF/The Room Mate - Kendall Ryan.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Leif' AND Autor = 'Abbi Glines') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Leif', 'Abbi Glines', '"She was mine. I owned her soul...until Death stole her heart." This is a novella to be read after Existence and Predestined.', v_93, 'PDF/Leif - Abbi Glines (2).pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¡Lo que tú digas!' AND Autor = 'Christian Martins') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¡Lo que tú digas!', 'Christian Martins', NULL, v_98, 'PDF/Lo que tu digas - Christian Martins.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Todo lo que soñé' AND Autor = 'Alanna Ignacio') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Todo lo que soñé', 'Alanna Ignacio', NULL, v_122, 'PDF/Todo lo que sone - Alanna Ignacio.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¡Házmelo!' AND Autor = 'Señora S') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¡Házmelo!', 'Señora S', NULL, v_66, 'PDF/Hazmelo - Senora S.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'La ciudad de los muertos' AND Autor = 'S. D. Perry') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('La ciudad de los muertos', 'S. D. Perry', 'Cae la noche... Leon Kennedy; un policía novato y lleno de energía, dispuesto a demostrar su valía y con ganas de comenzar una nueva vida en Racoon City... y que encuentra la ciudad extrañamente desierta. El fantasmal silencio del anochecer sólo se ve roto por el ruido esporádico de unos pasos en las sombras y por el espectral gemido de algo que acecha en las cercanías... Claire Redfield; la independiente y audaz hermana de Chris Redfield, uno de los miembros de los STARS, desaparecido en Racoon City.', v_48, 'PDF/La ciudad de los muertos - S. D. Perry.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¡Haz que el dinero sea tu amigo!' AND Autor = 'Gregorio Hernández Jiménez') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¡Haz que el dinero sea tu amigo!', 'Gregorio Hernández Jiménez', NULL, v_94, 'PDF/Haz que el dinero sea tu amigo - Gregorio Hernandez Jimenez.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Opal' AND Autor = 'Jennifer L. Armentrout') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Opal', 'Jennifer L. Armentrout', 'Book Three of the bestselling Lux series No one is like Daemon Black. When he set out to prove his feelings for me, he wasn''t fooling around. Doubting him isn''t something I''ll do again, and now that we''ve made it through the rough patches, well... There''s a lot of spontaneous combustion going on. But even he can''t protect his family from the danger of trying to free those they love. After everything, I''m no longer the same Katy. I''m different... And I''m not sure what that will mean in the end. When each step we take in discovering the truth puts us in the path of the secret organization responsible for torturing and testing hybrids, the more I realize there is no end to what I''m capable of. The death of someone close still lingers, help comes from the most unlikely source, and friends will become the deadliest of enemies, but we won''t turn back. Even if the outcome will shatter our worlds forever. Together we''re stronger...and they know it. Read the entire bestselling series! #1: Obsidian (from Katy''s point of view) #2: Onyx (from Katy''s point of view) #3: Opal (from Katy''s point of view) #4: Origin #5: Opposition Oblivion (Books 1-3 from Daemon''s point of view) CAN BE READ FIRST OR AFTER KATY''S POV! Prequel: Shadows (Dawson''s story)', v_84, 'PDF/Opal - Jennifer L. Armentrout.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'La oportunista' AND Autor = 'Tarryn Fisher') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('La oportunista', 'Tarryn Fisher', 'Querido Caleb: ¿Qué demonios? ¿No sabes quién soy? ¿Cómo te atreves a OLVIDAR a quien te rompió el corazón? Te diré lo que PIENSO HACER: haré ver que NUNCA NOS CONOCIMOS. Entonces haré que te ENAMORES de mí otra vez. Los dos sabemos que haré LO QUE SEA para conseguir lo que quiero. NUNCA he pretendido ser una buena persona. Si hay algo REAL en mí, eres TÚ. Por favor, no me recuerdes... POR FAVOR. Con amor, OLIVIA P.D.: ¿Una pelirroja, Caleb? ¿DE VERDAD? ¿No podrías haberme sustituido por una RUBIA? Olivia Kaspen es una manipuladora y acaba de descubrir que su exnovio, Caleb Drake, ha perdido la memoria. Por supuesto, hará todo lo que sea necesario para recuperarlo a la vez que intentará mantener en secreto su pasado en común. Sin embargo, su principal obstáculo será Leah Smith, la nueva novia de Caleb. Las dos se enfrascarán en una descarnada lucha para poseer a un hombre que ya no las recuerda. Pero pronto Olivia tendrá que hacer frente a las consecuencias de sus mentiras, y durante el proceso descubrirá que a veces el amor no es suficiente para alcanzar la redención.', v_100, 'PDF/La oportunista - Tarryn Fisher.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Locke' AND Autor = 'Harper Sloan') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Locke', 'Harper Sloan', NULL, v_98, 'PDF/Locke - Harper Sloan.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'La jefa' AND Autor = 'Victoria Quinn') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('La jefa', 'Victoria Quinn', 'La jefa es una película española de 2022, del género drama, ópera prima del director Fran Torres​ y protagonizada por Aitana Sánchez-Gijón y Cumelén Sanz.', v_98, 'PDF/La jefa - Victoria Quinn.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Profecía' AND Autor = 'María Martínez') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Profecía', 'María Martínez', 'Me encontraba tomando una clase de hermenéutica cuando el maestro mencionó que la creación estaba narrada dos veces en la Biblia. Esta afirmación llamó profundamente mi atención, ya que previamente había escuchado diferentes versiones sobre la creación de la humanidad: la Biblia la presenta de una manera y la ciencia de otra. Entonces, ¿a quién debía creer? Con esa inquietud en mente, me propuse investigar tanto en las Sagradas Escrituras como en la historia y la ciencia, con el objetivo de llegar a una conclusión. Descubrí que, al escudriñar la Biblia y examinar la historia, es posible entender mejor el propósito de la profecía. Comprendí que la única manera de conocer la verdad absoluta es a través de la Palabra de Dios, tal como está plasmada en la Biblia. Fue precisamente ahí donde entendí que no se trataba de dos narraciones diferentes de la creación, sino de un enfoque complementario: el Señor primero describe lo que hizo y luego detalla cómo lo hizo. Muchas veces, nuestra confusión surge porque no prestamos atención a lo que las Escrituras realmente nos enseñan. Eso fue exactamente lo que me ocurrió a mí. Me tomó dos años y medio investigar y profundizar aquí y allá en la Biblia, en la ciencia y en la historia para finalmente comprender con mayor claridad las “dimensiones históricas del último día de la creación.”', v_36, 'PDF/Profecía - María Martínez.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Detrás de la máscara' AND Autor = 'Adriana Rubens') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Detrás de la máscara', 'Adriana Rubens', '"Premio Vergara-El Rincon de la Novela Romantica 2015. Una novela romantica ejemplar, ambientada en la Inglaterra de la Regencia, en la tradicion de autorias como Lisa Kleypas y Johanna Lindsey"--Amazon.', v_231, 'PDF/Detras de la mascara - Adriana Rubens.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'The Rebel King' AND Autor = 'Kennedy Ryan') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('The Rebel King', 'Kennedy Ryan', 'From beloved, RITA-award-winning author Kennedy Ryan comes the gripping, passionate finale of the All the King''s Men duology. Though surrender is what Maxim Cade demanded of Lennix Hunter''s body and heart, she had other plans. They were fast-burning fascination and combustible chemistry, the son of an oil baron and the Apache daughter at war with his family, but she trusted him, and he turned out to be a thief who stole her love. Still, if what they had was a lie, why had it felt so real? Now, the man she swore to hate is about to have it all, and he wants Lennix at his side. But when the two of them are forced to face the unthinkable, their rocky foundation is tested, as is the invisible thread that seems to wind their fates together. As they navigate a treacherous political landscape in their quest for justice, Maxim and Lennix soon learn that power is a game, and they are merely the pawns and players. Facing insurmountable odds, will they win the world, or will they lose it all?', v_98, 'PDF/The Rebel King - Kennedy Ryan.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Obsidian' AND Autor = 'Jennifer L. Armentrout') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Obsidian', 'Jennifer L. Armentrout', 'Discover the New York Times bestselling series from Jennifer L. Armentrout. Starting over sucks. When we moved to West Virginia right before my senior year, I''d pretty much resigned myself to thick accents, dodgy internet access, and a whole lot of boring...until I spotted my hot neighbor, with his looming height and eerie green eyes. Things were looking up. And then he opened his mouth. Daemon is infuriating. Arrogant. Stab-worthy. We do not get along. At all. But when a stranger attacks me and Daemon literally freezes time with a wave of his hand, well, something...unexpected happens. The hot alien living next door marks me. You heard me. Alien. Turns out Daemon and his sister have a galaxy of enemies wanting to steal their abilities, and Daemon''s touch has me lit up like the Vegas Strip. The only way I''m getting out of this alive is by sticking close to Daemon until my alien mojo fades. If I don''t kill him first, that is. Read the entire bestselling series! #1: Obsidian (from Katy''s point of view) #2: Onyx (from Katy''s point of view) #3: Opal (from Katy''s point of view) #4: Origin #5: Opposition Oblivion (Books 1-3 from Daemon''s point of view) CAN BE READ FIRST OR AFTER KATY''S POV! Prequel: Shadows (Dawson''s story)', v_132, 'PDF/Obsidian - Jennifer L. Armentrout.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Unida a la bestia' AND Autor = 'Grace Goodwin') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Unida a la bestia', 'Grace Goodwin', 'Tras la muerte de sus dos hermanos en la guerra contra la implacable amenaza alienígena que pone en peligro a toda la Coalición Interestelar, Sarah Mills se ofrece como voluntaria para sumarse al combate en un intento de llevar a casa a su único hermano vivo. Sin embargo, cuando la procesan por error como una novia en vez de un soldado, opta por rechazar a su pareja. Pero su compañero tiene otras ideas… Dax es un señor de la guerra de Atlán, y al igual que todos los hombres de su raza, una bestia primitiva vive en su interior, lista para aparecer en la furia de la batalla o en la intensidad de la fiebre de apareamiento. Al enterarse de que su novia ha elegido luchar en las líneas de fuego en vez de quedarse en su cama, parte para encontrarla y reclamar lo que la bestia necesita. Sarah no se muestra muy contenta cuando una imponente bestia, que afirma ser su compañero, llega repentinamente en medio de una batalla; y su descontento se transforma en ira cuando la presencia de Dax interrumpe su misión y da lugar a la captura de su hermano. Pero luego de que su oficial superior se niegue a autorizar una misión de rescate, la única esperanza de Sarah para salvar al único pariente que le queda es aceptar la oferta de Dax para ayudarla, incluso si eso significa entregarse a él como recompensa. A pesar de su felicidad por haber encontrado a su rebelde novia, Dax rápidamente descubre que Sarah no se parece en nada a las mujeres dóciles y sumisas de su mundo. Si la quiere, deberá dominarla; así tenga que usar su firme mano sobre su trasero. Pero Dax no solo quiere a Sarah, sino que la necesita. ¿Podrá ella satisfacer la temible bestia que se encuentra en su interior antes de que pierda el control por completo?', v_201, 'PDF/Unida a la bestia - Grace Goodwin.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Ciudad del fuego celestial' AND Autor = 'Cassandra Clare') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Ciudad del fuego celestial', 'Cassandra Clare', 'La oscuridad ha regresado al Mundo de las Sombras. Mientras su mundo se desmorona alrededor, Clary, Jace, Simon y sus amigos deben unirse para luchar contra el mayor enemigo al que se han enfrentado nunca los nefilim: el hermano de Clary. Se perderán vidas, se sacrificarán amores y el mundo entero cambiará en el sexto volumen de la serie Cazadores de Sombras.', v_186, 'PDF/Ciudad del fuego celestial - Cassandra Clare.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¡Ni lo sueñes!' AND Autor = 'Megan Maxwell') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¡Ni lo sueñes!', 'Megan Maxwell', NULL, v_98, 'PDF/¡Ni lo sueñes! - Megan Maxwell (copia 2).pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'La biblia del vendedor' AND Autor = 'Alex Dey') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('La biblia del vendedor', 'Alex Dey', 'This indispensable manual teaches how to create a presentation, sell an appointment over the phone and rebut any negative answer within 3 seconds. This "Bible" of sales techniques contains quick, effective approaches for the competitive sales person. With over 1,000,000 copies sold, this is not just any book, it''s the manual every sales person needs.', v_123, 'PDF/La biblia del vendedor - Alex Dey.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¡Te odio, Derek Brooks!' AND Autor = 'Isabella Marín') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¡Te odio, Derek Brooks!', 'Isabella Marín', NULL, v_98, 'PDF/¡Te odio, Derek Brooks! - Isabella Marín.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El tatuaje de la concubina' AND Autor = 'Laura Joh Rowland') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El tatuaje de la concubina', 'Laura Joh Rowland', NULL, v_216, 'PDF/El tatuaje de la concubina - Laura Joh Rowland.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Like the First Time' AND Autor = 'Jennifer L. Armentrout') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Like the First Time', 'Jennifer L. Armentrout', 'Aliens are the new vampires, and sexy Daemon Black will set your pulse racing. . . STARTING OVER SUCKS When we moved to West Virginia right before my senior year, I''d pretty much resigned myself to thick accents, dodgy internet access, and a whole lot of boring. . . until I spotted my hot neighbour, with his looming height and eerie green eyes. Things were looking up. AND THEN HE OPENED HIS MOUTH Daemon is infuriating. Arrogant. Stab-worthy. We do not get along. At all. But when a stranger attacks me and Daemon literally freezes time with a wave of his hand, well, something. . . unexpected happens. THE HOT ALIEN LIVING NEXT DOOR MARKS ME You heard me. Alien. Turns out Daemon and his sister have a galaxy of enemies wanting to steal their abilities, and Daemon''s touch has me lit up like the Vegas Strip. The only way I''m getting out of this alive is by sticking close to Daemon until my alien mojo fades. IF I DON''T KILL HIM FIRST, THAT IS ''If you haven''t already picked these books up, seriously what are you waiting for!'' ⭐⭐⭐⭐⭐ ''I don''t usually like alien stories, but this one! Oh my god! AMAZING!'' ⭐⭐⭐⭐⭐ ''Immediately upon starting Obsidian I was hit with the most beautiful feelings of nostalgia. It made me feel how I felt reading Twilight, The Hunger Games, and Divergent for the first time'' ⭐⭐⭐⭐⭐', v_189, 'PDF/Like the First Time - Jennifer L. Armentrout.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Las 7 leyes espirituales del éxito' AND Autor = 'Deepak Chopra') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Las 7 leyes espirituales del éxito', 'Deepak Chopra', 'En Las siete leyes espirituales del éxito se destila la esencia de las enseñanzas de Chopra en siete sencillos pero poderosos principios, que pueden ser fácilmente aplicados para crear el éxito en todas las áreas de su vida. Colmado de eterna sabiduría, y pasos prácticos que usted puede poner en práctica de inmediato, este es un libro que apreciará toda su vida, pues en su interior se encuentran los secretos para que todos sus sueños se hagan realidad. Basado en las leyes naturales que gobiernan la creación, este libro destruye el mito de que el éxito es el resultado del trabajo arduo, de la esmerada planificación o de la ambición. Deepak Chopra ofrece a cambio, una perspectiva sobre la consecución del éxito capaz de transformar su vida. Cuando comprendemos nuestra verdadera naturaleza y aprendemos a vivir en armonía con las leyes naturales brotan, con facilidad y sin esfuerzo, el sentido de bienestar, la buena salud, las relaciones satisfactorias y la abundancia material.', v_70, 'PDF/Las 7 leyes espirituales del exito - Deepak Chopra.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '365 días' AND Autor = 'Blanka Lipińska') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('365 días', 'Blanka Lipińska', 'BEST SELLER INTERNACIONAL N.o 1 2.000.000 ejemplares vendidos La novela que inspiró el fenómeno mundial emitido por Netflix. Una excitante historia de sexo de alto voltaje, lujo y poder que no olvidarás. Una pasión sin medida. Un mundo donde no existen los límites ni la clemencia. Tiene 365 días para enamorarse de él. Massimo Toricelli es el capo de una familia de la mafia siciliana. Oscuro, peligroso y tremendamente atractivo, busca obsesionado desde hace años a una mujer que se le apareció en una visión cuando estuvo a punto de morir. Laura es una joven ejecutiva polaca, quemada por el trabajo y atrapada en una relación sin pasión. Durante unas vacaciones en las que Laura viaja a Sicilia, el poderoso Massimo la reconoce y, dispuesto a hacerla suya a cualquier precio, la secuestra en su lujosa mansión y le da un plazo de un año para que se enamore de él. La prensa ha dicho: «Coronada como la nueva "Cincuenta sombras".» Cosmopolitan', v_38, 'PDF/365 dias - Blanka Lipinska.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El espíritu de la laguna' AND Autor = 'Laia López') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El espíritu de la laguna', 'Laia López', '¿Qué oscura criatura se esconde bajo las aguas de la laguna? Ahora que el curso ha terminado, Diana y sus amigos tienen por delante unas tranquilas vacaciones de verano. Sin embargo, pronto se darán cuenta de que los problemas no han hecho más que empezar... Un dragón amenaza con destruirlo todo a su paso y alguien con mucho poder en la laguna está empeñado en sellar un pacto que causará mucho dolor. Por si fuera poco, para las sirenas es más difícil que nunca ocultar su verdadera identidad, especialmente desde que un par de periodistas andan husmeando por el campus universitario... Las pesadillas de Eiden no dejan de empeorar, y su hermana Liv tampoco está pasando por un buen momento. La sospecha de que sobre la familia Kirous pesa una terrible maldición es cada vez más fuerte. La cuenta atrás para la próxima luna llena ha comenzado, pero Diana está decidida a salvar a sus amigos... sin importarle las consecuencias.', v_215, 'PDF/El espíritu de la laguna - Laia López.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Princesa mecánica' AND Autor = 'Cassandra Clare') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Princesa mecánica', 'Cassandra Clare', 'El peligro aumenta para los Cazadores de Sombras ahora que esta trilogía, besteller del New York Times, llega a su fin. Si la única manera de salvar el mundo fuera destruyendo a quien más amás, ¿lo harías? El tiempo corre. Debes elegir. Pasión. Poder. Secretos. Magia. El peligro acecha a los Cazadores de Sombras en la entrega final de Los Orígenes.', v_186, 'PDF/Princesa mecánica - Cassandra Clare.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Antibióticos de la Madre Naturaleza' AND Autor = 'No especificado') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Antibióticos de la Madre Naturaleza', 'No especificado', NULL, v_22, 'PDF/Antibióticos de la Madre Naturaleza - No especificado.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Reina de las sombras' AND Autor = 'Sarah J. Maas') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Reina de las sombras', 'Sarah J. Maas', 'La serie bestseller de The New York Times , Trono de Cristal, alcanza nuevas alturas en este cuarto volumen. Continúa el viaje épico de Celaena, cuya intensidad va en aumento hasta alcanzar una apasionada y terrible crisis que podría destrozar su mundo. Una épica travesía que ha cautivado los corazones y la imaginación de millones de personas en todo el mundo y que en su cuarta entrega mantendrá a los lectores embelesados mientras la historia de Celaena avanza in crescendo, a un ritmo de infarto que sacudirá el orbe de la nueva reina. Celaena Sardothien ha perdido a todos aquellos que ama, pero por fin está de vuelta en el imperio para vengarse, para rescatar su reino, antes glorioso, y para enfrentar las sombras de su pasado... Ha reconocido su identidad como Aelin Galathynius, reina de Terrasen. Pero antes de reclamar su trono deberá luchar. Luchará por su primo, un guerrero dispuesto a morir por volver a verla. Luchará por su amigo, un joven atrapado en una prisión inenarrable. Y luchará por su gente, que aguarda esclavizada, bajo el yugo de un inhumano rey, el retorno triunfal de su reina perdida. La crítica ha opinado: "Las motivaciones y las interacciones de los personajes aparecen siempre muy acertadas y con delicados matices, en especial conforme la creciente madurez de Aelin le ofrece nuevas perspectivas sobre viejos conocidos. Imposible dejar de leer." Kirkus Reviews "A los fans de las series de fantasía intensa les tendrá totalmente sin cuidado la prolongada historia, cargada como viene de amenazantes miradas, tensión sexual a punto de ebullición, sinuosos giros de la trama, sarcástico humor y una exuberante construcción del universo. Los capítulos finales de esta entrega" Booklist', v_215, 'PDF/Reina de las sombras - Sarah J. Maas.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Rubí' AND Autor = 'Kerstin Gier') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Rubí', 'Kerstin Gier', 'Cruza las fronteras del tiempo y encuentra el verdadero amor. Engánchate a la saga que ha cautivado a miles de lectores. Vivir en una familia cargada de secretos no es fácil. O al menos eso es lo que piensa Gwendolyn Sheperd. Y es que en su casa nada ni nadie es del todo «normal»: empezando por su excéntrica tía abuela, pasando por la misteriosa Lucy, que se escapó de casa hace diecisiete años sin dejar rastro... y, para acabar, también está Charlotte, su encantadora y rabiosamente perfecta prima, quien, según parece, ha heredado un extraño gen familiar que le permitirá viajar en el tiempo. Pero un día Gwen se encuentra de pronto en el Londres del penúltimo cambio de siglo y comprende que el mayor secreto de su familia es ¡ella misma! Para protegerla, su madre trató de ocultarle todas las pruebas, pero en realidad ella es la última viajera en el tiempo y tiene una importante misión que cumplir. Ahora Gwen está en el ojo del huracán y parece que todo el mundo tiene un montón de advertencias que hacerle. En cambio, nadie va a decirle lo más importante: es mejor no enamorarse mientras se viaja de una época a otra, porque eso puede complicar terriblemente las cosas... Como cualquier otro día, regresé pronto a casa al salir del instituto. Mi tía se había quedado sin sus dulces favoritos y me ofrecí para ir a la tienda a comprar más. Pero de camino empecé a sentir algo muy extraño: las piernas me temblaban y tuve una sensación rara en el estómago. De repente, la calle desapareció ante mis ojos. Poco después reapareció, pero muchas cosas eran diferentes. Había vuelto al pasado. Me llamo Gwen y soy la última viajera en el tiempo. Así empieza la aventura de mi vida... Reseña: «Kerstin debe de haber lanzado algún tipo de magia entre sus páginas. La historia es alucinante... ¡Quién fuera Gwen para pasar dos horas con Gideon en un sofá! ¡A SOLAS! Sin lugar a dudas, la trilogía ES UN IMÁN del que no te podrás separar. ¡Imprescindible en tu estantería!» Eva Rubio, administradora de JUVENIL ROMÁNTICA', v_215, 'PDF/Rubí - Kerstin Gier.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¡Cógetelo!' AND Autor = 'Sandra Parejo') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¡Cógetelo!', 'Sandra Parejo', NULL, v_3, 'PDF/¡Cógetelo! - Sandra Parejo.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Pacto de sangre' AND Autor = 'María Martínez') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Pacto de sangre', 'María Martínez', 'Primera entrega de la trilogía «Almas Oscuras». Para todos los amantes de las novelas de vampiros y para los que creen que el amor no entiende de fronteras ni de mundos. Desde hace siglos, vampiros y licántropos mantienen un pacto que protege a los humanos de un mundo de peligros y oscuridad. William es uno de ellos, un vampiro temible y letal. Callado y distante, su mirada esconde grandes secretos y un corazón frío como el hielo. Pero eso no es lo que le hace diferente: William es el único vampiro que puede vivir bajo el sol. Ese don le convierte en un ser especial, en la esperanza que su raza necesita, pero también en la llave que los renegados persiguen para liberarse de su maldición. Ahora, William tendrá que volver a luchar, no solo por su vida, también por la de Kate: una humana que amenaza con cambiar todo su mundo. Reseñas: «Adictiva, trepidante y sugerente.María Martínez sabe cómo cautivar al lector a través de unos diálogos y unas descripciones que dotan de vida propia a la novela. El libro que necesitaba para volver a engancharme a las historias de vampiros y licántropos.» María Cabal Gómez, administradora del blog Soy cazadora de sombras y libros. «Una estupenda novela, intensa y vibrante, con un ritmo ágil y una atmósfera muy cinematográfica. Unos personajes complejos y pasionales que parecen saltar de la página gracias al talento de la autora.» Marta Fernández, administradora del blog Tejiendo críticas en la sombra.', v_93, 'PDF/Pacto de sangre - Maria Martinez.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Revelada' AND Autor = 'P. C. Cast y Kristin Cast') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Revelada', 'P. C. Cast y Kristin Cast', 'Neferet está agora mais poderosa do que nunca, e sua busca por vingança ameaça as vidas não apenas de Zoey e seus aliados, mas de toda a humanidade. O caos impera em Tulsa, e todos passam a culpar a Morada da Noite por isso. Poderá Zoey impedir os planos terríveis de Neferet a tempo, antes que seu ódio possa desencadear uma guerra de consequências devastadoras? A série House of Night é um dos maiores fenômenos do mercado editorial, tendo alcançado a primeira posição na lista dos mais vendidos em países como Estados Unidos, Alemanha e Reino Unido, mantendo-se na lista de best-sellers do The New York Times por cerca de 150 semanas consecutivas. Agora, no penúltimo capítulo dessa aclamada série, a ação é ainda mais eletrizante, e os riscos são ainda maiores na batalha de Zoey e de seus amigos para proteger sua escola – e seu lar – da destruição. Ao mesmo tempo, os cativantes personagens criados por P. C. e Kristin Cast têm de lidar com seus sentimentos, com o jogo de amizades e traições e com o dia a dia entre as paredes da Morada da Noite.', v_118, 'PDF/Revelada - P. C. Cast y Kristin Cast.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¿Quién mató a Alex? El misterio que nos une' AND Autor = 'Janeth G. S.') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¿Quién mató a Alex? El misterio que nos une', 'Janeth G. S.', 'El fenómeno que arrasa en Wattpad. Más de 37 millones de lecturas. Premio Wattys. Hannah es una adolescente de dieciséis años enganchada a las redes sociales. Pero un día recibe una solicitud de amistad de Facebook de un chico llamado Alex Crowell. Al aceptarla, descubre en el muro de Alex que está muerto. Y luego pasa algo todavía más escalofriante: recibe un mensaje privado del joven donde él le pide ayuda para averiguar quién lo mató. En una trepidante investigación, Hannah descubre que hay muchas personas involucradas en su muerte. Pero contará con una ayuda inesperada, la del fantasma de Alex.', v_97, 'PDF/¿Quién mató a Alex- El misterio que nos une - Janeth G. S.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '5 hábitos que ayudan a desarrollar tu mente' AND Autor = 'Autor desconocido') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('5 hábitos que ayudan a desarrollar tu mente', 'Autor desconocido', NULL, v_230, 'PDF/5 habitos que ayudan a desarrollar tu mente - Autor desconocido.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Nero' AND Autor = 'Sarah Brianne') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Nero', 'Sarah Brianne', 'Elle is determined to keep her mouth shut when the mob boss tells Nero to make her talk.', v_99, 'PDF/Nero - Sarah Brianne.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Príncipe mecánico' AND Autor = 'Cassandra Clare') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Príncipe mecánico', 'Cassandra Clare', 'Consciente del singular poder de Tessa, El Magister sigue tras sus pasos, dispuesto a acabar con los Cazadores de Sombras. Tessa, junto al bello y autodestructivo Will y el dulce y devoto Jem, iniciará un viaje que les llevará a descubrir el secreto familiar que esconde la verdadera identidad de la chica.Segundo título de la exitosa trilogía que precede la historia de Cazadores de sombras y nos desvela sus orígenes.', v_215, 'PDF/Principe mecanico - Cassandra Clare.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Legend' AND Autor = 'Marie Lu') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Legend', 'Marie Lu', '"Legend doesn''t merely survive the hype, it deserves it." From the New York Times bestselling author of The Young Elites What was once the western United States is now home to the Republic, a nation perpetually at war with its neighbors. Born into an elite family in one of the Republic''s wealthiest districts, fifteen-year-old June is a prodigy being groomed for success in the Republic''s highest military circles. Born into the slums, fifteen-year-old Day is the country''s most wanted criminal. But his motives may not be as malicious as they seem. From very different worlds, June and Day have no reason to cross paths - until the day June''s brother, Metias, is murdered and Day becomes the prime suspect. Caught in the ultimate game of cat and mouse, Day is in a race for his family''s survival, while June seeks to avenge Metias''s death. But in a shocking turn of events, the two uncover the truth of what has really brought them together, and the sinister lengths their country will go to keep its secrets. Full of nonstop action, suspense, and romance, this novel is sure to move readers as much as it thrills.', v_158, 'PDF/Legend - Marie Lu.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Running Mate' AND Autor = 'Katie Ashley') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Running Mate', 'Katie Ashley', 'Barrett The name''s Barrett Callahan. Yeah, that Barrett Callahan-the one the press dubbed "Bare" after those naked pictures surfaced. At twenty-seven, I was armed with an MBA from Harvard, an executive position at my father''s Fortune 500 company, a penthouse, and a different piece of delectable eye candy in my bed every weekend. I had a life most men dreamed of. But then my father decided to run for president, and my playboy lifestyle became a liability to his campaign that was built on family values. My "makeover" comes in the form of a fake fiancée who I don''t even get to choose--one who is an uptight, choirgirl acting priss but also sexy-as-hell. Addison My latest relationship had gone down in flames, and I was drowning in a sea of student loans when in true Godfather status, James Callahan made me an offer I couldn''t refuse. Seven figures for seven months on the campaign trail pretending to be the adoring fiancée of his son, Barrett. As soon as he won the election, our engagement would be dissolved amicably for the press, I was free to ride off into the sunset a million dollars richer, and because of the NDA, no one would be the wiser. Sure, I''d never met the guy, but I''d been a theater nerd in high school. I could pull off any role from Lady Macbeth to Maria Von Trapp. But that was before I met my fake fiancé-the infuriating, self-absorbed, egotistical, drop-dead-sexy King of the Manwhores. The race will be a fight to the death finish, and that''s not even the actual campaign.', v_122, 'PDF/Running Mate - Katie Ashley.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Ceaseless' AND Autor = 'Abbi Glines') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Ceaseless', 'Abbi Glines', 'Can he make her fall in love with him... again? When Pagan Moore proved worthy of Death''s devotion, he was given the gift of getting to keep her. But Dank was never promised that Pagan would keep him. When a soul is created, so is its mate. In every lifetime those souls find each other. They complete the other''s destiny. It''s time for Pagan''s soul to choose if she truly wants an eternity at Death''s side or if she wants the mate created just for her. Dank didn''t think he had to worry about her choice. He knew where her heart belonged. Until he realized that every kiss, every touch, every moment of their time together would be washed from her memories. He would have to win her heart all over again and prove to her soul that he was where she belonged. If only her soul''s mate wasn''t right there standing in his way.', v_93, 'PDF/Ceaseless - Abbi Glines.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El beso del traidor' AND Autor = 'Erin Beaty') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El beso del traidor', 'Erin Beaty', 'Una chica convencida de no casarse. Un soldado desesperado por demostrar su valía. Un reino al borde de la guerra. La nueva trilogía de fantasía que está triunfando en Estados Unidos. Con una lengua afilada y un temperamento indisciplinado, Salvia no es precisamente lo que se espera de una dama, lo que no le supone ningún problema. Cuando la consideran no apta para el matrimonio, tiene que aprender de la mano de una casamentera, junto a otras jóvenes damas, cómo ser la jovencita perfecta. El único fin es que acabe contrayendo matrimonio en una alianza política. Pero Salvia sabe que tiene que estar siempre alerta, así que escucha las conversaciones de sus compañeras y de los soldados que las escoltan para enterarse de las verdades que ocultan. Cuando la escolta militar de las damas siente un levantamiento político, Salvia es reclutada por un intrépido militar para infiltrarse en las filas enemigas. Cuanto más descubre como espía, menos segura está de en quién confiar... Salvia se ve en atrapada en la representación más importante de toda su vida: de su actuación dependerá el destino del reino. ¿Podrá ser la espía que todos esperan? La crítica ha dicho... «Una historia de acción, con un argumento perfectamente trazado, repleta de traiciones y de intriga, con una heroína irresistible y un romance dulce y sexy» Publishers Weekly. Los blogs opinan... « El Beso de la Traición es un libro un poco introductorio pero que marca el principio de una trilogía que promete y que pienso seguir leyendo.» Blog Paperblog', v_221, 'PDF/El beso del traidor - Erin Beaty.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Tras un abanico' AND Autor = 'Stella Knightley') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Tras un abanico', 'Stella Knightley', 'Dolida y confusa por el repentino final de su extraña aventura amorosa con el millonario veneciano Marco Donato, Sarah Thomson se traslada a París, donde tratará de olvidar lo mucho que añora a Marco sumergiéndose en un nuevo proyecto: el estudio de la famosa cortesana del siglo xix Augustine Levert, cuyos encantos causaron la ruina de muchos hombres de su época. Durante su estancia en la capital francesa, Sarah se reúne con su exnovio Steven. Su relación, psicológica y sexualmente torturada, parece reavivarse. Sin embargo, cuando la vida de Sarah empieza a parecerse demasiado a la de Augustine, se da cuenta de que nunca podrá borrar a Marco de su corazón. Ambas mujeres deberán elegir entre la seguridad y la pasión arrebatadora, pero ¿serán capaces de tomar la decisión correcta?', v_66, 'PDF/Tras un abanico - Stella Knightley.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El libro de la claridad' AND Autor = 'Rabí Nehunia ben Hakaná') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El libro de la claridad', 'Rabí Nehunia ben Hakaná', NULL, v_76, 'PDF/El libro de la claridad - Rabí Nehunia ben Hakaná.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Juntos' AND Autor = 'Ally Condie') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Juntos', 'Ally Condie', 'Nunca desafíes el juego del amor... Juntos, primera parte de la trilogía, lo tiene todo: un futuro utópico, aventura, suspense, crítica social y un amor imposible. En el mundo de Cassia, las autoridades lo deciden todo. A quién debes amar, de qué debes trabajar, incluso cuándo debes morir. Cassia nunca ha cuestionado las decisiones que han tomado por ella, ni siquiera cuando le comunican que su «pareja perfecta» -la persona con quien deberá compartir el resto de su vida- es Xander, su mejor amigo. Los problemas llegan más tarde, cuando un extraño error informático hace que en la microficha que las autoridades le han entregado aparezca la cara de otro chico: el enigmático Ky. Con una mezcla de estupefacción y curiosidad, Cassia empieza a investigar. ¿Y si este error no fuera fortuito? ¿Y si la persona de su vida no fuera quien le han asegurado que es? Al intentar buscar respuestas a todas estas preguntas, Cassia deberá afrontar una elección imposible entre la perfección y la pasión, entre Xander y Ky, entre la única vida que conoce y el camino que nadie hasta entonces se ha atrevido a seguir... Reseñas: «El mayor éxito juvenil desde Los juegos del hambre.» Entertainment Weekly «Si el mundo de Katniss te ha marcado, no puedes perderte esta saga en la que no hay libertad ni para decidir de quién te enamoras.» Seventeen Magazine «Intenso, inolvidable, adictivo.» Kirkus Review', v_137, 'PDF/Juntos - Ally Condie.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'La vida es ahora. Los beneficios de mindfulness en el día a día' AND Autor = 'Bárbara Porter J. y Magdalena Andrade N.') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('La vida es ahora. Los beneficios de mindfulness en el día a día', 'Bárbara Porter J. y Magdalena Andrade N.', NULL, v_197, 'PDF/La vida es ahora. Los beneficios de mindfulness en el dia a dia - Barbara Porter J. y Magdalena Andrade N.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¿Qué es la masonería?' AND Autor = 'Orden Internacional Mixta Le Droit Humain') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¿Qué es la masonería?', 'Orden Internacional Mixta Le Droit Humain', NULL, v_33, 'PDF/Que es la masoneria - Orden Internacional Mixta Le Droit Humain.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Todo es diferente' AND Autor = 'Alanna Ignacio') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Todo es diferente', 'Alanna Ignacio', NULL, v_122, 'PDF/Todo es diferente - Alanna Ignacio.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '#Quiérete. La receta de Vikika para ser feliz' AND Autor = 'Verónica Costa') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('#Quiérete. La receta de Vikika para ser feliz', 'Verónica Costa', 'En este libro, el más personal de Vikika, la autora contesta a muchas de las preguntas que recibe en sus redes sociales: cómo se cuida, de dónde saca la motivación para entrenarse y mantener una dieta saludable, cómo se marca sus metas y objetivos, lo imprescindible que es estar bien con uno mismo para poder conseguir todo lo que te propongas, el esfuerzo, el inconformismo, la importancia del amor y la amistad... También nos explicará paso a paso las recetas que le ayudan a mantener unos abdominales perfectos. #Quiérete es un grito de guerra, un tatuaje vital, un acto para hacer de la felicidad, la alegría y, sobre todo, de quererte tu prioridad. «Con este libro quiero hacer lo mismo que con mi vida: escribir algo que merezca la pena leer. O hacer algo que merezca la pena escribir.» Vikika', v_19, 'PDF/Quierete. La receta de Vikika para ser feliz - Veronica Costa.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'La jefa suprema' AND Autor = 'Victoria Quinn') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('La jefa suprema', 'Victoria Quinn', NULL, v_98, 'PDF/La jefa suprema - Victoria Quinn.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Detrás de un beso' AND Autor = 'Adriana Rubens') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Detrás de un beso', 'Adriana Rubens', 'Después de Detrás de la máscara y Detrás de tu mirada, llega la esperada tercera entrega de la serie «Whitechapel» ambientada en el Londres de finales del siglo XIX. Jacqueline Darcy fue testigo del asesinato de su hermano, y desde entonces vive escondida en Whitechapel bajo la identidad masculina de Jack Ellis. Cuando le sugieren que se convierta en el asistente del doctor Richmond para descubrir la causa del extraño comportamiento de este, ella acepta, aunque con renuencia. La relación no empieza con buen pie, pero cuanto más conoce al doctor, más se enamora de él, hasta que descubre que aquello que lo atormenta es un enemigo más temible de lo que nadie hubiese podido imaginar. Joshua Richmond tiene dos problemas. El primero es la atracción que despierta en él su nuevo asistente. El segundo, su creciente dependencia del opio, aunque al menos esto último puede controlarlo. O eso cree él. Tendrá que enfrentarse al riesgo de perder a sus seres queridos, a la vez que a sus miedos y más terribles pesadillas, para darse cuenta de que se ha metido en un infierno del que no puede escapar sin ayuda. Cualquier cosa, con tal de conseguir aquello que vislumbró detrás de un beso.', v_231, 'PDF/Detrás de un beso - Adriana Rubens.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Oscuros. La primera maldición' AND Autor = 'Lauren Kate') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Oscuros. La primera maldición', 'Lauren Kate', 'Solo la luz de su amor podría iluminar la oscuridad de todo un mundo... La primera maldición es la cuarta entrega de la saga paranormal romántica «Oscuros», que narra la cruel historia de amor de Daniel y Luce. A Luce y a Daniel solo les queda una oportunidad para salvar su historia... y la del mundo. Y es que Lucifer ha desvelado por fin sus planes: quiere recrear la Caída de los Ángeles a la Tierra para alterar el tiempo y borrar, de un plumazo, todo lo acontecido en los últimos siete mil años. Luce y Daniel son los únicos que pueden detenerle, pero cuentan solo con nueve días. Así que, acompañados de sus amigos (e incluso de algún enemigo) iniciarán una carrera contrarreloj para evitar que el ángel traidor destruya el rumbo de la humanidad...', v_149, 'PDF/Oscuros. La primera maldicion - Lauren Kate.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'La ascensión' AND Autor = 'Amanda Hocking') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('La ascensión', 'Amanda Hocking', 'La Ascensión es una localidad del Estado de México, México. Es parte del municipio de Zumpahuacán.​', v_215, 'PDF/La ascensión - Amanda Hocking.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'La amante del millonario' AND Autor = 'Leona Lee') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('La amante del millonario', 'Leona Lee', NULL, v_38, 'PDF/La amante del millonario - Leona Lee.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El ladrón' AND Autor = 'Tarryn Fisher') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El ladrón', 'Tarryn Fisher', 'El amor es paciente; el amor es amable; el amor no presume o alardea. No hay arrogancia en el amor; nunca es brusco, bruto ni indecente; no es egocéntrico. El amor no es fácilmente amargo. El amor no se equivoca calculando. El amor confía, cree y sobrevive a todo. El amor nunca se quedará obsoleto. Lucharé por ella.', v_100, 'PDF/El ladron - Tarryn Fisher.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¡Sin pretextos! Cambia el pero por el puedo' AND Autor = 'Yordi Rosado') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¡Sin pretextos! Cambia el pero por el puedo', 'Yordi Rosado', 'Lo que eres es mucho más que suficiente para ser… todo lo grande que quieres ser. Sabías que: · No puedes regresar al pasado para volver a empezar, pero puedes empezar ahora y cambiar el futuro. · Cuando crees de verdad en algo, tu mente encuentra la manera de lograrlo. · Tus logros no te definen, te define lo que superas. · Las crisis son la mejor oportunidad para crecer, pues la vida te las pone en frente para que hagas algo que jamás te hubieras atrevido. · El éxito no se basa en hacer cosas extraordinarias de vez en cuando, sino en hacer cosas correctas constantemente. Así que: ¡Sin pretextos! Cambia el pero por el puedo. En este libro encontrarás un gran número de herramientas, estrategias, consejos y estudios avalados por los más grandes coach motivacionales, emprendedores, terapeutas y líderes, así como muchos de los aciertos y errores que he enfrentado para lograr mis objetivos. En este escrito te comparto situaciones muy íntimas de mi vida que jamás había contado, con el único fin de que nos ayuden a todos a mejorar. En ¡Sin Pretextos! Cambia el pero por el puedo, te invito —con una lectura fresca, documentada, sincera y al mismo tiempo muy profunda—, a que vayas por más, te empoderes, mejores tu autoestima —de forma permanente—, ubiques tus cualidades para que conozcas los alcances que realmente tienes y, especialmente, para que descubras que puedes ser muy feliz con lo que cuentas y con la persona que eres. ENGLISH DESCRIPTION You are more than enough to be... everything great that you want to be. Did you know: · You can''t go back to the past and start over again, but you can begin now and change your future. · When you really believe in something, your mind finds a way to make it happen. · Your achievements don''t define you, what you overcome defines you. · Crisis is the best opportunity for growth, so life places them in front of you so that you''ll do something you never would have dared to do before. · Success isn''t based on doing extraordinary things from time to time, rather in doing the right things consistently. So that''s why: No Excuses! Change I Can''t to I Can! In this book you will find a great number of tools, strategies, advice, and supported studies by the best motivational coaches, entrepreneurs, therapists, and leaders, as well as many wise choices and errors that I''ve made to reach my goals. In this writing, I share intimate situations of my life that I''ve never talked about before, with the only objective to help all of us improve ourselves. In, No Excuses! Change I Can''t to I Can! I invite you—with a refreshing, documented, sincere and, at the same time, very profound, read—to go for more, empower yourself, improve your self-esteem—permanently—to find your virtues so that you really understand the power you have, especially, so you will discover that you can be happy with what counts and with the person you are.', v_173, 'PDF/¡Sin pretextos! Cambia el pero por el puedo - Yordi Rosado.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'La loba de plata' AND Autor = 'Alice Borchardt') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('La loba de plata', 'Alice Borchardt', NULL, v_30, 'PDF/La loba de plata - Alice Borchardt.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'La noche del lobo' AND Autor = 'Alice Borchardt') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('La noche del lobo', 'Alice Borchardt', NULL, v_30, 'PDF/La noche del lobo - Alice Borchardt.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Dominada por sus compañeros' AND Autor = 'Grace Goodwin') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Dominada por sus compañeros', 'Grace Goodwin', 'Amanda Bryant ha sido una espía durante cinco largos años, pero cuando los alienígenas aparecen repentinamente, afirmando que un enemigo mortal amenaza la supervivencia de los habitantes de la Tierra, los superiores de Amanda la envían a enfrentar la misión más peligrosa de su vida: ofrecerse para ser la novia de un alienígena, compartir la cama con el extraño guerrero y, finalmente, traicionarlo. Aceptando la tarea, Amanda es procesada como la primera novia interestelar y es transportada al otro lado de la galaxia, con dirección a la nave de guerra de su nuevo compañero. Al despertar, descubre que ha sido emparejada no solo con un gigante guerrero de Prillon, sino con dos de ellos. Estupefacta por su sed de sentir a dos machos alfas y dominantes, Amanda se da cuenta de que la amenaza para la Tierra es muy real. ¿Cómo puede proteger a los guerreros que ha terminado amando y, al mismo tiempo, impedir que las personas de la Tierra cometan un terrible error? ¿Le creerán sus contactos en la Tierra cuando, con cada uno de sus movimientos, con cada una de sus miradas, noten hasta qué punto ha sido dominada por sus compañeros?', v_201, 'PDF/Dominada por sus companeros - Grace Goodwin.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Manual de fisioterapia respiratoria' AND Autor = 'Marisé Mercado Rus') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Manual de fisioterapia respiratoria', 'Marisé Mercado Rus', NULL, v_6, 'PDF/Manual de fisioterapia respiratoria - Marise Mercado Rus.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'La otra Bolena' AND Autor = 'Philippa Gregory') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('La otra Bolena', 'Philippa Gregory', 'María Bolena tiene apenas catorce años cuando inicia un romance adúltero con el rey Enrique VIII, fruto del cual nacerán dos hijos. Las cosas se complican cuando su astuta y perversa hermana, Ana, se convierte en amante y consejera del rey, y trama un plan para deshacerse de la reina Catalina de Aragón.', v_121, 'PDF/La otra Bolena - Philippa Gregory.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¡Auxilio, somos padres! Manual para no enloquecer (al pediatra)' AND Autor = 'Ingrid Beck y Alejandro Fainboim') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¡Auxilio, somos padres! Manual para no enloquecer (al pediatra)', 'Ingrid Beck y Alejandro Fainboim', 'Ingrid Beck vuelve con todo el humor de la «Guía (inútil) para madres primerizas». Esta vez embarca en su locura a Alejandro Fainboim, el pediatra de sus hijos. La sala de espera de un pediatra es un cuadro dantesco. Ese lugar al que llegamos luego de un arduo casting para encontrar al pediatra ideal es el caldo de cultivo de piojos, mocos y virus en todas sus variedades. Es el lugar al que llegamos con nuestras ojeras, bolsos, ropa manchada, asientos de bebé, mamaderas y a veces también con lo que queda de quien supo ser nuestra pareja. Y, por último, es el lugar donde está él o ella. Nuestra salvación: el pediatra. El hombre o la mujer que nos quitará todos los miedos, todas nuestras angustias, que nos ayudará a criar al niño o niña y que nos dirá qué hacer, cuándo y cómo. Nos dirá si está flaco o está gordo, si tiene que dejar la teta, si tiene que dejar el pañal, si ya debería decir más de diez palabras, si ya debería caminar, si ya debería dormir solo de un tirón, qué hacemos si se cae de cabeza, si se corta, si tiene fiebre, en fin, que nos confirme que somos pésimos padres y que la culpa es el motor de nuestras vidas. El pediatra es todo, por eso este libro también es para ellos, que podrán reírse de las insólitas preguntas que les hacemos los padres, en el consultorio o por teléfono a las cuatro de la madrugada porque el nene tiene tanto catarro que parece un cantor de tango.', v_200, 'PDF/Auxilio, somos padres Manual para no enloquecer (al pediatra) - Ingrid Beck y Alejandro Fainboim.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¡Un amor de locos!' AND Autor = 'Hugo Sanz') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¡Un amor de locos!', 'Hugo Sanz', NULL, v_86, 'PDF/¡Un amor de locos! - Hugo Sanz.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¡Libre! El camino emprendedor como filosofía de vida' AND Autor = 'Andy Freire') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¡Libre! El camino emprendedor como filosofía de vida', 'Andy Freire', 'Cómo utilizar herramientas del mundo emprendedor para alcanzar sus objetivos cotidianos. El carácter emprendedor es una de las cualidades más importantes en el mundo de la empresa y los negocios, a punto tal que existe un conjunto de herramientas que ayudan a desarrollarlo. Andy Freire, emprendedor por excelencia y columnista reconocido en radio y televisión, descubrió que esas herramientas pueden trascender el ámbito empresarial y ser de enorme utilidad para definir nuestros propósitos y trazar de manera dinámica y proactiva el camino para conseguirlos, que no es otro que el de una vida plena. "Emprender es mucho más que crear una empresa o una organización: es hacer que las cosas sucedan". Reducir la brecha entre lo que somos y lo que queremos ser es, en fin, la manera de alcanzar y ejercer nuestra propia libertad.', v_4, 'PDF/Libre El camino emprendedor como filosofia de vida - Andy Freire.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¡Invisibles!' AND Autor = 'R. L. Stine') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¡Invisibles!', 'R. L. Stine', 'On Max''s birthday, he finds a sort of magic mirror in the attic. It can make him become invisible.', v_12, 'PDF/Invisibles - R. L. Stine.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¡No te limites! Sé tu mejor versión' AND Autor = 'Lupita Venegas') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¡No te limites! Sé tu mejor versión', 'Lupita Venegas', NULL, v_173, 'PDF/¡No te limites! Sé tu mejor versión - Lupita Venegas.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '33 técnicas de persuasión infalibles: utiliza la influencia positiva para alcanzar tus metas' AND Autor = 'Borja Girón') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('33 técnicas de persuasión infalibles: utiliza la influencia positiva para alcanzar tus metas', 'Borja Girón', NULL, v_90, 'PDF/33 técnicas de persuasión infalibles utiliza la influencia positiva para alcanzar tus metas - Borja Girón.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Rey de las mentiras' AND Autor = 'Whitney G.') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Rey de las mentiras', 'Whitney G.', 'El hombre del que me he enamorado es un mentiroso. No tengo mucho tiempo para revelar todos los detalles, pero esos titulares de "Una mujer desaparece después de su boda" no son más que mentiras. No he desaparecido. No he huido después de mi boda. Nunca habría huido después de mi increíble luna de miel. Mi marido me ha raptado. No, me ha secuestrado. Porque, según él, "Es mejor así"; solo soy un peón en su retorcida partida de ajedrez. A pesar de que mi corazón sigue atado al suyo o de que es el hombre más arrolladoramente guapo y atractivo que he conocido en toda mi vida (aún puede hacer que me encienda solo con dirigirme la palabra), tengo que centrarme en escapar de él. Debo aceptar que ya no es el hombre del que me enamoré. Es el rey de las mentiras. La mujer de la que me he enamorado es tremendamente sexy, pero también exasperante. Está desesperadamente enamorada de mí, pero también está urdiendo un cuidadoso plan para escaparse. ¿Piensa de verdad que yo soy "el rey de las mentiras"? Ella sí que es la reina de las mentiras. Estamos en esto juntos; mentira por mentira, verdad por verdad. Los dos arrastramos un pasado doloroso, a los dos nos da miedo construir un futuro... A pesar de todo, hay un atisbo de esperanza para ambos... siempre que uno de los dos se doblegue. Somos el rey y la reina de las mentiras.', v_98, 'PDF/Rey de las mentiras - Whitney G.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Neurociencias y su importancia en contextos de aprendizaje' AND Autor = 'María Laura de la Barrera y Danilo Donolo') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Neurociencias y su importancia en contextos de aprendizaje', 'María Laura de la Barrera y Danilo Donolo', NULL, v_1, 'PDF/Neurociencias y su importancia en contextos de aprendizaje - María Laura de la Barrera y Danilo Donolo.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El café de los corazones rotos' AND Autor = 'Penelope Stokes') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El café de los corazones rotos', 'Penelope Stokes', 'Una encantadora historia de la autora que ya nos deleitó con El café de los corazones rotos. Veintitrés años atrás, la reina de belleza Peach Rondell había dejado Misisipí a sus espaldas y jurado que no regresaría nunca más. Ahora está de vuelta, divorciada y con el corazón roto, e intenta entender por qué la vida le ha ido tan mal. Para escapar de la mirada acechante de su madre, pasa el día en el pequeño Heartbreak Café, sentada a una de cuyas mesas va escribiendo en su diario, a la espera de algo que la ilumine. En lugar de eso, Peach conseguirá algo incluso mejor: la amistad inesperada de un insólito grupo de personas que le enseñarán que averiguar adónde vas suele implicar aceptar de dónde vienes. Reseñas: «Una bonita novela. Penelope stokes explora con habilidad tanto las dificultades como la satisfacción de encontrarse a sí mismo.» The Romance Readers Connection «Fantástica historia que nos devuelve a nuestros propios recuerdos y hace que revivamos las razones que nos llevaron a convertirnos en las personas que somos.» The Night Owl Reviews «Un relato divertido, conmovedor y lleno de esperanza.» De amor, libros y otras historias, sobre El café de los corazones rotos «Una escritura que destaca por su calidad. La prosa de Stokes es tersa como la mantequilla.» Publishers Weekly', v_83, 'PDF/El cafe de los corazones rotos - Penelope Stokes.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Predestined' AND Autor = 'Abbi Glines') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Predestined', 'Abbi Glines', 'You would think after helping save her boyfriend from an eternity in Hell that things would go back to normal. Well, as normal as life can be when you can see souls and your boyfriend is Death. But for Pagan Moore, things are just getting weirder. The high school quarterback and reigning heartthrob, Leif Montgomery, is missing. While the town is in a frenzy of worry, Pagan is a nervous wreck for other reasons. Apparently good ''ol Leif isn''t your average teenage boy. He isn''t even human. According to Death, Leif doesn''t have a soul. The quarterback may have skipped town but he''s still showing up in Pagan''s dreams... uninvited. Dank has known from the beginning Leif wasn''t human. But he hadn''t worried about a simple soulless creature. Now, he realizes he made a grave mistake. Pagan''s soul has been marked since birth as a restitution, to a spirit so dark not even Death walks near it. Dank knows saving Pagan''s soul won''t be easy but Pagan is his. And he''s already proven he''ll defy Heaven to keep her. If Hell wants a piece of him too, then bring it on.', v_93, 'PDF/Predestined - Abbi Glines (2).pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Corazón indomable' AND Autor = 'Elena Montagud') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Corazón indomable', 'Elena Montagud', 'Le has dado una segunda oportunidad y te ha vuelto a fallar. ¿Existe alguna fórmula mágica para superar el desengaño? Tras Corazón elástico, llega Corazón indomable, la segunda novela de la trilogía «Corazón», en la que Elena Montagud vuelve a sorprendernos con una historia de relaciones aparentemente imposibles y sensualmente inevitables. A esta novela le sigue el desenlace Corazón desnudo. ADVERTENCIA: Esta historia tierna y pasional puede provocarte los sueños más eróticos. Después de la ruptura con Adrián, Blanca regresa a su vida anterior. Mucho trabajo, algún ligue sin importancia, fiesta y descontrol. Ella sabe que eso no es lo que le conviene ni lo que desea de verdad, aunque cualquier cosa es mejor que quedarse en casa echando de menos a un hombre al que no es capaz de perdonar. Pero Adrián no se da por vencido. Quizá las circunstancias no los hayan ayudado, ni en la adolescencia ni tampoco ahora. Quizá ambos hayan dejado que el sexo devore las palabras... Pero lo que está claro es que la atracción sigue viva como una llama, encendiendo sus cuerpos para luego hacerlos pelear de nuevo, con la misma voracidad con la que antes hicieron el amor. ¿Hay solución para esta pareja imposible? Él despierta en ti las emociones más desatadas: pasión, odio, temor, deseo... Ese chico se está convirtiendo en el dueño de tu placer. Frágil, sexy, sincero, atrevido... Nunca lo olvidarás.', v_98, 'PDF/Corazón indomable - Elena Montagud.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El pícaro real' AND Autor = 'Karina Halle') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El pícaro real', 'Karina Halle', NULL, v_98, 'PDF/El picaro real - Karina Halle.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'La ensenada Calibán' AND Autor = 'S. D. Perry') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('La ensenada Calibán', 'S. D. Perry', 'La ensenada de la bioquímica y médico militar Rebecca Chambers, única superviviente del equipo Bravo de Racoon City, se une a una nueva fuerza de ataque de los STARS cuando les llega el rumor de la existencia de otro centro experimental de Umbrella. Se encuentra oculto bajo los acantilados rocosos de la Ensenada de Calibán, un pueblo de Maine, donde alguien está reuniendo un ejército de zombies. Los STARS deben llegar al interior del siniestro faro tras atravesar un laberinto de cuevas submarinas y, finalmente, enfrentarse dentro de los restos de un naufragio a horrores inenarrables.', v_48, 'PDF/La ensenada Calibán - S. D. Perry.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¡Despierta!... que la vida sigue' AND Autor = 'César Lozano') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¡Despierta!... que la vida sigue', 'César Lozano', 'En este libro el Dr. César Lozano nos invita a tratar de ser felices y disfrutar de la vida, incluso de los más pequeños detalles Del autor bestseller de Por el placer de vivir, Destellos, El lado fácil de la gente difícil. César Lozano ha motivado a más de 20 millones de personas en el mundo. Reflexiones para disfrutar plenamente la vida. Esta es una obra en la que el Dr. César Lozano nos exhorta a valorar lo que tenemos; es un reconocimiento de que nuestra vida es breve y pasajera pero que, para aquellos que tenemos esperanza, siempre nos lleva al verdadero despertar. ¡Despierta!... que la vida sigue ofrece valiosas fórmulas y técnicas que te sacudirán para que no te quedes enredado en tus problemas y disfrutes de los mejores momentos de tu vida: una sonrisa de tus hijos, la caricia de un ser querido, la alegría de hacer algo por alguien desconocido. Después de leer este libro, tus relaciones tendrán un nuevo sentido y habrás encontrado la verdadera motivación para fijar sentirte feliz.', v_194, 'PDF/Despierta... que la vida sigue - Cesar Lozano.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Oscuros' AND Autor = 'Lauren Kate') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Oscuros', 'Lauren Kate', 'Oscuros (en inglés: Fallen) es una novela romántica de ángeles caídos dirigida al público adolescente, escrita por Lauren Kate y publicada en 2009.
De esta gran historia de fantasía se desprenden 5 libros más y un anexo, en total 6, el primero es Oscuros (2009), el segundo El poder de las sombras (2010), el tercero La trampa del amor  (2011), el cuarto La primera maldición (2012), y el quinto El retorno de los caídos (2015). Después de que se publicara el primer libro de "Oscuros" en 2009, los derechos de los cinco libros fueron comprados en su totalidad para ser llevados a la gran pantalla. El 9 de septiembre del 2022 Variety informo sobre la preparación de una serie de televisión de Fallen (Oscuros), la producción esta acargo de Silve Reel y Night Train Media, con la coproducción del servicio de streaming brasileño Globoplay.​ La saga ha sido traducida a más de 30 idiomas.
Lauren Kate publicó en noviembre de 2015 el quinto libro de la saga llamado en inglés "Unforgiven", que se centra solo en el personaje de Cam, el personaje antagonista de "Oscuros". Según Kate la historia narra qué fue lo que pasó con Cam una vez que termina el libro "La primera maldición", esto fue como respuesta a los fanes que querían saber más de este personaje y qué es lo que le depara después de su misteriosa despedida en el último libro.
El anexo se llama La eternidad y un día (2012), donde se relata la historia de amor de 4 de las parejas principales de la historia.​', v_74, 'PDF/Oscuros - Lauren Kate.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¡Buenos días, princesa!' AND Autor = 'Blue Jeans') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¡Buenos días, princesa!', 'Blue Jeans', 'Han pasado algo más de dos años en la vida de los chicos que forman “el club de los incomprendidos”. Las cosas han cambiado desde que uno tras otro se fueron encontrando en el camino. Nuevos problemas, secretos, amores, celos... Sin embargo, hasta el momento, su amistad ha podido con todo y con todos.Raúl, se ha convertido en un atractivo joven y en un líder nato; Valeria, derrocha simpatía por donde pisa, aunque no ha vencido del todo a su timidez; Eli, es la que más se ha transformado de todos y se los lleva de calle; María, vigila y sueña tras sus gafas de pasta de color azul; Bruno, no consigue olvidar lo que siente y en lo más profundo de su corazón espera ser correspondido; y Ester, es la nuera que toda madre querría tener aunque no es tan inocente como todos piensan.Son seis chicos que sienten, sufren, aman, creen, ríen, evolucionan... como otros chicos de su edad. Pero los seis son especiales. Al menos, para el resto del grupo.¿Conseguirán superar todas las pruebas que se le van a presentar?Sólo puedes averiguarlo leyendo, ¡Buenos días, princesa!', v_107, 'PDF/Buenos dias, princesa - Blue Jeans.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Hermano Lobo' AND Autor = 'Michelle Paver') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Hermano Lobo', 'Michelle Paver', 'Hermano lobo es la primera entrega de la serie «Crónicas de la prehistoria». Una historia de amistad y aventuras en la prehistoria que encantará a los niños de todas las edades. Hace miles de años, un niño llamado Torak vive feliz en el bosque, hasta el día en que un oso gigante ataca y hiere a su padre. Moribundo, éste le ordena que se dirija al Norte para encontrar la Montaña del Espíritu del Mundo, antes de que aparezca en el cielo la Luna del Sauce Rojo. Pero Torak sólo tiene doce años, desconoce qué camino tomar y no puede acudir a nadie en busca de ayuda. Sin embargo, perseguido por el enorme oso, el niño emprende el viaje acompañado de un lobezno que ha encontrado a la orilla de un río. Pronto se unirá a ellos Renn, una niña perteneciente al Clan del Cuervo, y juntos vivirán emocionantes y peligrosas aventuras que pondrán a prueba su valor, su habilidad como cazadores, su inteligencia y su naciente amistad. La crítica ha dicho... « Hermano Lobo es el tipo de novela que sueñas con leer y que es tan difícil encontrar.» The Times «Impresionante.» The Guardian', v_206, 'PDF/Hermano Lobo - Michelle Paver.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¡Hazlo!' AND Autor = 'Seth Godin') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¡Hazlo!', 'Seth Godin', 'Este libro es una llamada de atención sobre las iniciativas que estás tomando, en el trabajo y en cuanto te concierne. Ha llegado el momento de que dejes de esperar a que alguien te proporcione un mapa del camino y empieces a dibujarlo tú mismo. Llevamos a nuestros hijos al colegio y nos obsesionamos con sus notas, su comportamiento y su capacidad de integración. Colgamos una oferta de trabajo y buscamos experiencia, universidades de prestigio y una carrera sin fracasos. Y entonces, ¿por qué nos sorprendemos cuando todo se desmorona? Nuestra economía no es estática, pero actuamos como si lo fuera. Tu posición en el mundo se define en función de lo que emprendes, de cómo lo haces y de lo que aprendes de los acontecimientos que causas. ¡Hazlo! Constituye un manifiesto sobre la producción de algo que escasea y es, por lo tanto, valioso. Ha llegado el momento de que dejes de esperar a que alguien te proporcione un mapa del camino y empieces a dibujarlo tú mismo. Este libro quizá te haga sentir incómodo. Es una llamada de atención sobre las iniciativas que estás tomando, en el trabajo y en cuanto te concierne. Pero también puede ser el puntapié que necesitas para introducir un cambio en tu vida.', v_29, 'PDF/Hazlo - Seth Godin.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Las 7 leyes espirituales del éxito' AND Autor = 'Deepak Chopra') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Las 7 leyes espirituales del éxito', 'Deepak Chopra', 'En Las siete leyes espirituales del éxito se destila la esencia de las enseñanzas de Chopra en siete sencillos pero poderosos principios, que pueden ser fácilmente aplicados para crear el éxito en todas las áreas de su vida. Colmado de eterna sabiduría, y pasos prácticos que usted puede poner en práctica de inmediato, este es un libro que apreciará toda su vida, pues en su interior se encuentran los secretos para que todos sus sueños se hagan realidad. Basado en las leyes naturales que gobiernan la creación, este libro destruye el mito de que el éxito es el resultado del trabajo arduo, de la esmerada planificación o de la ambición. Deepak Chopra ofrece a cambio, una perspectiva sobre la consecución del éxito capaz de transformar su vida. Cuando comprendemos nuestra verdadera naturaleza y aprendemos a vivir en armonía con las leyes naturales brotan, con facilidad y sin esfuerzo, el sentido de bienestar, la buena salud, las relaciones satisfactorias y la abundancia material.', v_70, 'PDF/Las 7 leyes espirituales del exito - Deepak Chopra (2).pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Tomada por sus compañeros' AND Autor = 'Grace Goodwin') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Tomada por sus compañeros', 'Grace Goodwin', 'El príncipe Nial es desterrado y se le niega su derecho a reclamar una pareja. Acompañado por su segundo, se dirige a la Tierra. Rechazada una vez, Jessica está lejos de perdonar y olvidar. Cuando el príncipe Nial regrese y defienda su derecho de nacimiento, ¿Jessica se someterá a feroces y dominantes guerreros para salvar a todos?', v_201, 'PDF/Tomada por sus compañeros - Grace Goodwin.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Cómo aprender a escuchar' AND Autor = 'Samael Aun Weor') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Cómo aprender a escuchar', 'Samael Aun Weor', NULL, v_104, 'PDF/Cómo aprender a escuchar - Samael Aun Weor (2).pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Blue Moon: El espíritu de la laguna' AND Autor = 'Laia López') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Blue Moon: El espíritu de la laguna', 'Laia López', '¿Qué oscura criatura se esconde bajo las aguas de la laguna? Ahora que el curso ha terminado, Diana y sus amigos tienen por delante unas tranquilas vacaciones de verano. Sin embargo, pronto se darán cuenta de que los problemas no han hecho más que empezar... Un dragón amenaza con destruirlo todo a su paso y alguien con mucho poder en la laguna está empeñado en sellar un pacto que causará mucho dolor. Por si fuera poco, para las sirenas es más difícil que nunca ocultar su verdadera identidad, especialmente desde que un par de periodistas andan husmeando por el campus universitario... Las pesadillas de Eiden no dejan de empeorar, y su hermana Liv tampoco está pasando por un buen momento. La sospecha de que sobre la familia Kirous pesa una terrible maldición es cada vez más fuerte. La cuenta atrás para la próxima luna llena ha comenzado, pero Diana está decidida a salvar a sus amigos... sin importarle las consecuencias.', v_215, 'PDF/Blue Moon El espiritu de la laguna - Laia Lopez.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Mafia Queen' AND Autor = 'Bella J.') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Mafia Queen', 'Bella J.', 'Rules. I''m starting to think I have the natural talent for breaking them. I hate rules. Always have. Especially since I had them shoved in my face my entire life. I didn''t ask to be a Valenti. And I sure as hell didn''t agree to follow all their goddamn rules. Yet it''s been years since I broke one of my family''s most cardinal laws. It was a mistake-I know that now. But that''s the thing about mistakes. You never know you''re about to make one until it''s too late. Unfortunately, every transgression, every wrong decision has a way to demand atonement. No matter if it''s hours, days, or years after. I''m still waiting for my past mistakes to exact payment. It''ll come. I know it will. But now, while I''m sitting in the interrogation room staring at the sinfully gorgeous Detective Lorik Stone, I can''t help but think about all my family''s rules... ...and how I''m about to break another one.', v_99, 'PDF/Mafia Queen - Bella J..pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Inteligencia práctica: el arte y la ciencia del sentido común' AND Autor = 'Karl Albrecht') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Inteligencia práctica: el arte y la ciencia del sentido común', 'Karl Albrecht', 'El autor de Inteligencia social, Karl Albrecht, da un paso más y nos explica que la inteligencia práctica puede considerarse una de las aptitudes vitales clave. Karl Albrecht, autor de Inteligencia social, aborda ahora el tema de la inteligencia práctica, y nos muestra que quienes la poseen toman mejores decisiones, son capaces de pensar en términos de opciones y posibilidades, convivir con la ambigüedad y la complejidad, articular problemas con claridad y trabajar hasta dar con soluciones, además de tener ideas originales y creativas. Inteligencia práctica es el perfecto compañero de cualquiera que desee aprender a pensar con mayor claridad y eficacia. Opinión: «Tal u como hizo en su brillante libro Inteligencia social, Karl Albercht nos regala una obra lúcida y amena sobre algo tan necesario como la inteligencia práctica. Su lectura no les dejará indiferentes: les abrirá nuevas puertas de pensamiento y creatividad y, probablemente, les dará claves sumamente útiles para gestionar la gran oportunidad que es la vida» Álex Rovira', v_190, 'PDF/Inteligencia practica - el arte y la ciencia del sentido comun - Karl Albrecht (2).pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¡Bye bye, Love!' AND Autor = 'Lorraine Cocó') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¡Bye bye, Love!', 'Lorraine Cocó', NULL, v_122, 'PDF/Bye bye, Love - Lorraine Coco.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¡Se busca novia! Para mi ex' AND Autor = 'Kris Buendía') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¡Se busca novia! Para mi ex', 'Kris Buendía', NULL, v_86, 'PDF/¡Se busca novia! Para mi ex - Kris Buendía.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Influencia: ciencia y práctica' AND Autor = 'Robert B. Cialdini') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Influencia: ciencia y práctica', 'Robert B. Cialdini', NULL, v_163, 'PDF/Influencia - ciencia y practica - Robert B. Cialdini.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Deseada por su lobo' AND Autor = 'T. N. Hawke') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Deseada por su lobo', 'T. N. Hawke', NULL, v_93, 'PDF/Deseada por su lobo - T. N. Hawke.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¡Un mojito, por favor!' AND Autor = 'Ariadna Baker') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¡Un mojito, por favor!', 'Ariadna Baker', NULL, v_86, 'PDF/¡Un mojito, por favor! - Ariadna Baker.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'La actitud mental positiva' AND Autor = 'Napoleon Hill y W. Clement Stone') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('La actitud mental positiva', 'Napoleon Hill y W. Clement Stone', NULL, v_214, 'PDF/La actitud mental positiva - Napoleon Hill y W. Clement Stone (2).pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¡No te prives! Defensa de la ciudadanía' AND Autor = 'Fernando Savater') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¡No te prives! Defensa de la ciudadanía', 'Fernando Savater', 'Er político en el sentido auténtico del término, no en el insultante y pueril, es preferir enmendar errores a linchar culpables. Actualmente, en España, los debates políticos giran en torno al rechazo abrupto a los gobernantes por ineficaces o corruptos, la desconfianza en las instituciones a causa de la crisis económica y las pulsiones separatistas en Cataluña o el País Vasco. Pero no siempre queda claro en todas estas cuestiones en qué consiste el papel de la ciudadanía democrática, que es lo que realmente está en juego. Con la fuerza y la valentía que le caracteriza, Savater trata de dilucidar ese punto y plantear la irrenunciable defensa de los derechos y garantías del ciudadano, recordando también sus deberes: porque sin apoyarse en ellos cualquier intento de solución política está condenado de antemano a la frustración o la involución democrática hacia populismo retrógrados. Una obra combativa pero que no renuncia juntamente a ser pedagógica.', v_169, 'PDF/¡No te prives! Defensa de la ciudadanía - Fernando Savater.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Insurgent' AND Autor = 'Veronica Roth') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Insurgent', 'Veronica Roth', 'Fighting for survival in a shattered world... the truth is her only hope. The thrillingly dark sequel to No. 1 New York Times bestseller, DIVERGENT.', @Cat_Distopacienciaficcinjuvenil, 'PDF/Insurgent - Veronica Roth.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¡Maldición! (En un pueblo atípico)' AND Autor = 'Ulises de Laney') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¡Maldición! (En un pueblo atípico)', 'Ulises de Laney', NULL, v_83, 'PDF/¡Maldición! (En un pueblo atípico) - Ulises de Laney.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El libro de los atributos' AND Autor = 'Rabí Najmán de Breslov') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El libro de los atributos', 'Rabí Najmán de Breslov', 'EL LIBRO DE LOS ATRIBUTOS (Sefer HaMidot) Seleccion de epigramas, redactados por el Rabi Najman bajo el titulo de Sefer HaMidot. Cada frase de este libro es una piedra preciosa multifacetica que debe ser investigada y asentada en la reflexion."', v_141, 'PDF/El libro de los atributos - Rabí Najmán de Breslov.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El libro de la vida' AND Autor = 'Deborah Harkness') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El libro de la vida', 'Deborah Harkness', 'El desenlace de «El descubrimiento de las brujas». Un magistral cierre del suspense y la magia de una trilogía que ha cautivado a millones de lectores en todo el mundo. Tras viajar en el tiempo con La sombra de la noche, la historiadora y bruja Diana Bishop y el genetista Matthew Clairmont vuelven al presente para hacer frente a nuevos problemas y a viejos enemigos. Pero la amenaza real para su futuro todavía está por llegar y, cuando lo hace, la búsqueda del Ashmole 782 y sus páginas perdidas cobra aún mayor urgencia. En casas ancestrales y laboratorios universitarios, haciendo uso de conocimientos antiguos y de la ciencia moderna, desde las colinas de la campiña francesa hasta los palacios de Venecia, la pareja al fin desvelará lo que las brujas descubrieron hace siglos. ¿En qué consistía el secreto encerrado en el misterioso Ashmole 782 y después perseguido incansablemente por daimones, vampiros y brujos? ¿Cómo podrán la bruja Diana y el vampiro Matthew vivir su amor y cumplir con su misión bajo el peso de todas las diferencias que los separan? La gran aventura culmina aquí. ENGLISH DESCRIPTION The #1 New York Times bestselling series finale and sequel to A Discovery of Witches and Shadow of Night. Look for the hit TV series “A Discovery of Witches” airing Sundays on AMC and BBC America, and streaming on Sundance Now and Shudder. Bringing the magic and suspense of the All Souls Trilogy to a deeply satisfying conclusion, this highly anticipated finale went straight to #1 on the New York Times bestseller list. In The Book of Life, Diana and Matthew time-travel back from Elizabethan London to make a dramatic return to the present—facing new crises and old enemies. At Matthew’s ancestral home, Sept-Tours, they reunite with the beloved cast of characters from A Discovery of Witches—with one significant exception. But the real threat to their future has yet to be revealed, and when it is, the search for Ashmole 782 and its missing pages takes on even more urgency.', v_146, 'PDF/El libro de la vida - Deborah Harkness.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Solo Tuya' AND Autor = 'Anabel García') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Solo Tuya', 'Anabel García', 'Solo tuya es el primer álbum de estudio de la cantante y actriz mexicana Aracely Arámbula. Este fue lanzado por el sello Disa Records en 14 de mayo de 2002 como un disco compacto y un casete.​ Solo tuya alcanzó número 35 en la lista de Billboard de los álbumes de música latina y número 19 en México.​ Los dos sencillos — «Te quiero más que ayer», el dúo con Palomo, y «Ojalá» — fueron lanzados en 2002. «Te quiero más que ayer» logró número nueve en México y número 27 en la lista Billboard Hot Latin Tracks.', v_38, 'PDF/Solo Tuya - Anabel Garcia.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Allegiant' AND Autor = 'Veronica Roth') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Allegiant', 'Veronica Roth', 'The explosive conclusion to Veronica Roth''s #1 New York Times bestselling Divergent trilogy reveals the secrets of the dystopian world that captivated millions of readers and film fans in Divergent and Insurgent. One choice will define you. What if your whole world was a lie? What if a single revelation—like a single choice—changed everything? What if love and loyalty made you do things you never expected? Told from a riveting dual perspective, this third installment in the series follows Tris and Tobias as they battle to comprehend the complexities of human nature—and their selves—while facing impossible choices of courage, allegiance, sacrifice, and love. And don''t miss The Fates Divide, Veronica Roth''s powerful sequel to the bestselling Carve the Mark!', @Cat_Distopacienciaficcinjuvenil, 'PDF/Allegiant - Veronica Roth.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'La ladrona de libros' AND Autor = 'Markus Zusak') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('La ladrona de libros', 'Markus Zusak', 'Trying to make sense of the horrors of World War II, Death relates the story of Liesel--a young German girl whose book-stealing and story-telling talents help sustain her family and the Jewish man they are hiding, as well as their neighbors.', v_121, 'PDF/La ladrona de libros - Markus Zusak.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Mafia Princess' AND Autor = 'Bella J.') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Mafia Princess', 'Bella J.', 'La princesa de la mafia (título original: Mafia Princess) es un telefilme estadounidense de drama y crimen de 1986, dirigido por Robert L. Collins,​ escrito por Robert W. Lenski, está basado en un libro de Antoinette Giancana y Thomas C. Renner; musicalizado por Lee Holdridge, en la fotografía estuvo Alexander Gruszynski y los protagonistas son Susan Lucci, Kathleen Widdoes y Tony Curtis, entre otros.​ Este largometraje fue producido por Group W y se estrenó el 19 de enero de 1986.', v_99, 'PDF/Mafia Princess - Bella J..pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'La sombra de la noche' AND Autor = 'Deborah Harkness') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('La sombra de la noche', 'Deborah Harkness', 'Picking up from A Discovery of Witches’ cliffhanger ending, Shadow of Night takes Diana and Matthew on a trip through time to Elizabethan London, where they are plunged into a world of spies, magic, and a coterie of Matthew’s old friends, the School of Night. As the search for Ashmole 782 deepens and Diana seeks out a witch to tutor her in magic, the net of Matthew’s past tightens around them, and they embark on a very different—and vastly more dangerous—journey.', v_146, 'PDF/La sombra de la noche - Deborah Harkness.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'La conspiración Umbrella' AND Autor = 'S. D. Perry') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('La conspiración Umbrella', 'S. D. Perry', 'La Unidad de Rescate y Tácticas Especiales (STARS) se ha desplegado en Racoon City para investigar el caos. Se trata de un ecléctico grupo de especialistas: el rebelde Chris Redfield, la antigua ladrona de guante blanco Jill Valentine, el combativo Barry Burton y el enigmático jefe de la unidad, Albert Wesker. Pero lo que los STARS descubren cuando entran en la mansión es un terror que supera sus peores pesadillas: criaturas que desafían las leyes de la vida y de la muerte. S. D. Perry es la autora de casi todos los libros de la serie Resident Evil. También ha escrito novelas sobre Alien y novelizaciones de películas.', v_48, 'PDF/La conspiracion Umbrella - S. D. Perry.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'La redención de Gabriel' AND Autor = 'Sylvain Reynard') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('La redención de Gabriel', 'Sylvain Reynard', 'El profesor Gabriel Emerson ha dejado su plaza en la Universidad de Toronto para iniciar una nueva vida junto a su amada Julianne. Está seguro de que juntos podrán enfrentarse a cualquier desafío, in cluso a su deseo de ser padre. Pero el programa de doctorado de la joven pondrá a prueba los planes de Gabriel, ya que la dura vida de estudiante le roba demasiado tiempo. Cuando Julianne recibe el honor de dar una conferencia en Oxford, éste se muestra reacio, pues ambos tienen opiniones encontradas sobre la materia. Para complicar un poco más la relación, aparecen varios personajes del pasado empeñados en humillar a Julia y en sacar a la luz uno de los secretos más oscuros de Gabriel', v_98, 'PDF/La redencion de Gabriel - Sylvain Reynard.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Oscuros. La eternidad y un día' AND Autor = 'Lauren Kate') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Oscuros. La eternidad y un día', 'Lauren Kate', 'La eternidad y un día es la quinta novela de la saga «Oscuros», y funciona como una secuela en la que la autora aborda, además de la historia de amor principal entre Luce y Daniel, los romances entre otros personajes de la saga, en el marco de la celebración de San Valentín. Inesperado Prohibido No correspondido Eterno El amor tiene muchas caras, pero un solo corazón... «El amor eterno de Luce y Daniel es emblemático, pero no es el único tipo de amor posible... Este es un libro inspirado por vosotros, mis lectores, que habéis compartido conmigo vuestras historias de amor desde el principio y me habéis mostrado las distintas formas que puede adoptar el más elevado de los sentimientos. » La eternidad y un día es un grand tour de romanticismo que atraviesa el tiempo y los corazones. Acercaos un poco más a la eternidad de Luce y Daniel y descubrid los derroteros amorosos de Miles, Shelby, Roland, Arriane...» Lauren Kate, la autora Reseña: «Sexy, fascinante y estremecedora. ¡Me encantó!» P.C. Cast, autora de La Casa de la Noche', v_149, 'PDF/Oscuros. La eternidad y un dia - Lauren Kate.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'This Girl' AND Autor = 'Colleen Hoover') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('This Girl', 'Colleen Hoover', 'From the New York Times bestselling author of It Ends With Us, Colleen Hoover’s bestselling Slammed series comes to its gripping conclusion. There are two sides to every love story. Now hear Will’s. Layken and Will’s love has managed to withstand the toughest of circumstances, and the young lovers, now married, are beginning to feel safe and secure in their union. As much as Layken relishes their new life together, she finds herself wanting to know everything there is to know about her husband, even though Will makes it clear he prefers to keep the painful memories of the past where they belong. Still, he can’t resist his wife’s pleas, and so he begins to untangle his side of the story, revealing for the first time his most intimate feelings and thoughts, retelling both the good and bad moments, and sharing a few shocking confessions of his own from the time when they first met. In This Girl, Will tells the story of their complicated relationship from his point of view. Their future rests on how well they deal with the past in this final instalment of the beloved Slammed series.', v_98, 'PDF/This Girl - Colleen Hoover.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Tras una máscara' AND Autor = 'Stella Knightley') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Tras una máscara', 'Stella Knightley', 'Sarah Thompson viaja a Venecia con un doble objetivo: profundizar en su trabajo de doctorado e intentar, además, superar la ruptura con su novio Steven. Sin embargo, el seductor Marco Donato le roba enseguida la capacidad de concentrarse. A pesar de que su relación es cada vez más profunda, el misterioso millonario la reta a participar en un juego repleto de sombras tras las que él se esconde. ¿De qué está huyendo Marco? La tesis de Sarah se centra en la joven veneciana Luciana Giordano. En una época en la que el desenfreno sexual era el pasatiempo favorito de la ciudad, la virginal Luciana permanece oculta y custodiada por una estricta carabina... hasta que conoce a Giacomo Casanova. El legendario amante le descubrirá no solo los secretos del erotismo y el placer, sino que también le dará las claves para obtener la libertad.', v_38, 'PDF/Tras una mascara - Stella Knightley.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Una noche mágica' AND Autor = 'Lisa Kleypas') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Una noche mágica', 'Lisa Kleypas', 'Una encantadora novela de la inimitable Lisa Kleypas, que te hará llorar y reír, a veces al mismo tiempo. Una niña que necesita una familia. Una noche lluviosa, la pequeña Holly perdió a la única familia que conocía: su madre, Victoria. Y desde esa noche no ha vuelto a pronunciar una sola palabra. Un soltero que necesita una esposa. Lo último que necesita Mark Nolan en su vida es una niña de seis años. Pero pronto se da cuenta de que hará todo lo que esté en su mano para que a Holly no le falte de nada. El testamento de su hermana le señala el camino correcto: «Eres la única alternativa. Solo tienes que quererla. El resto vendrá solo.» A veces solo hace falta un poco de magia... Maggie Conroy no se atreve a enamorarse de nuevo, pero cree en la magia de la imaginación. Cuando conoce a Holly Nolan, ve a una niña desesperada por un poco de magia en su vida... Tres personas solitarias. Tres vidas que se encuentran en una encrucijada. Tres seres que están a punto de descubrir que a veces los deseos encuentran el modo de llegar a casa... ENGLISH DESCRIPTION Now a Hallmark Hall of Fame television movie, CHRISTMAS WITH HOLLY (previously published as CHRISTMAS EVE AT FRIDAY HARBOR) is the first book in New York Times bestselling author Lisa Kleypas''s new series, which begins during the most magical time of year... ONE LITTLE GIRL NEEDS A FAMILY One rain-slicked night, six-year-old Holly lost the only parent she knew, her beloved mother Victoria. And since that night, she has never again spoken a word. ONE SINGLE MAN NEEDS A WIFE The last thing Mark Nolan needs is a six-year-old girl in his life. But he soon realizes that he will do everything he can to make her life whole again. His sister''s will gives him the instructions: There''s no other choice but you. Just start by loving her. The rest will follow. SOMETIMES, IT TAKES A LITTLE MAGIC… Maggie Collins doesn''t dare believe in love again, after losing her husband of one year. But she does believe in the magic of imagination. As the owner of a toy shop, she lives what she loves. And when she meets Holly Nolan, she sees a little girl in desperate need of a little magic. …TO MAKE DREAMS COME TRUE Three lonely people. Three lives at the crossroads. Three people who are about to discover that Christmas is the time of year when anything is possible, and when wishes have a way of finding the path home…', v_98, 'PDF/Una noche magica - Lisa Kleypas.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Vincent' AND Autor = 'Sarah Brianne') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Vincent', 'Sarah Brianne', NULL, v_99, 'PDF/Vincent - Sarah Brianne.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Doctrina secreta tomo VI: objeto de los misterios y práctica de la filosofía oculta' AND Autor = 'Helena Petrovna Blavatsky') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Doctrina secreta tomo VI: objeto de los misterios y práctica de la filosofía oculta', 'Helena Petrovna Blavatsky', 'Blavatskys masterwork on theosophy, covering cosmic, planetary, and human evolution, as well as science, religion, and mythology. It covers the creation of the universe, the evolution of humankind, and the primordial tradition underlying the various religions, mythologies and philosophies of the world. It is the seminal book of esoteric knowledge of our age.', v_178, 'PDF/Doctrina secreta tomo VI - objeto de los misterios y practica de la filosofia oculta - Helena Petrovna Blavatsky.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Boss Empire' AND Autor = 'Victoria Quinn') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Boss Empire', 'Victoria Quinn', 'I''ve found a woman I can''t live without. It''s not just about the things we do in the bedroom. But the way she looks at me. The way she touches me. The way she loves me. Maybe I can have what Titan has. Maybe I can have even more.', v_98, 'PDF/Boss Empire - Victoria Quinn.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¡Ni lo sueñes!' AND Autor = 'Megan Maxwell') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¡Ni lo sueñes!', 'Megan Maxwell', NULL, v_98, 'PDF/¡Ni lo sueñes! - Megan Maxwell (copia 1).pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'La familia del millonario' AND Autor = 'Leona Lee') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('La familia del millonario', 'Leona Lee', NULL, v_38, 'PDF/La familia del millonario - Leona Lee.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Tower of Dawn' AND Autor = 'Sarah J. Maas') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Tower of Dawn', 'Sarah J. Maas', 'Poder, alianzas, guerra, venganza... La travesía a un imperio distante de sanadores mágicos. Chaol Westfall siempre se ha definido a sí mismo como un hombre de lealtad inquebrantable, de gran fortaleza y a partir de su posición como capitán de la Guardia. Pero todo eso ha cambiado desde que el castillo de cristal se hizo añicos: sus hombres fueron diezmados y el rey de Adarlan lo libró de un golpe mortal pero dejó su cuerpo destrozado. Su única oportunidad de recuperarse reside en los legendarios curanderos de la Torre Cesme en Antica -el bastión del poderoso imperio en el Continente Meridional. Y ahora que la guerra se cierne sobre Dorian y Aelin de vuelta en casa, su supervivencia quizá dependa de que Chaol y Nesryn convenzan a sus regidores de formar una alianza con ellos. Pero lo que descubren en Antica los cambiará por completo y será más vital salvar a Erilea de lo que podrían haber imaginado. ENGLISH DESCRIPTION In the next installment of the New York Times bestselling Throne of Glass series, follow Chaol on his sweeping journey to a distant empire. Chaol Westfall has always defined himself by his unwavering loyalty, his strength, and his position as the Captain of the Guard. But all of that has changed since the glass castle shattered, since his men were slaughtered, since the King of Adarlan spared him from a killing blow, but left his body broken. His only shot at recovery lies with the legendary healers of the Torre Cesme in Antica--the stronghold of the southern continent''s mighty empire. And with war looming over Dorian and Aelin back home, their survival might lie with Chaol and Nesryn convincing its rulers to ally with them. But what they discover in Antica will change them both--and be more vital to saving Erilea than they could have imagined.', v_215, 'PDF/Tower of Dawn - Sarah J. Maas.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Corazón elástico' AND Autor = 'Elena Montagud') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Corazón elástico', 'Elena Montagud', 'Si tu primer amor te destrozó el corazón, ¿crees que merece una segunda oportunidad? Corazón elástico es la primera novela de la trilogía «Corazón», en la que Elena Montagud vuelve a sorprendernos con una historia de rabiosa actualidad, una relación tan tormentosa como sensual y unos protagonistas inolvidables. A esta novela le siguen: Corazón indomable y Corazón desnudo. ADVERTENCIA: Esta historia romántica e increíblemente sexy puede alterar el ritmo de tu corazón. Blanca es una abogada capaz y decidida, una amante experta que disfruta de una activa y variada vida sexual, una mujer moderna que no quiere compromisos ni ataduras. Pero hay alguien a quien no ha conseguido olvidar: Adrián, su mejor y único amigo en la adolescencia, el joven a quien entregó su virginidad y con quien vivió un primer amor sensual e inesperado, el chico que le falló y al que ha intentado desterrar de su mente con innumerables ligues de una noche. Ahora ha llegado la hora de enfrentarse al pasado, al pueblo agobiante del que huyó años atrás y, tal vez también, al hombre que a pesar de todo sigue convirtiendo sus sueños en fantasías eróticas de alto voltaje. Una novela sobre el hechizo del primer amor: ese chico tan especial que sigue haciéndote vibrar de placer muchos años después. Arrollador, ingenuo, inocente, sensual... Nunca lo olvidarás.', v_122, 'PDF/Corazon elastico - Elena Montagud.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Bad Boy''s Girl: Te odiaré hasta que te quiera' AND Autor = 'Blair Holden') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Bad Boy''s Girl: Te odiaré hasta que te quiera', 'Blair Holden', '#BadBoysGirl, el nuevo fenómeno de la plataforma de lectura Wattpad, con más de 130 millones de lecturas, llega a las librerías. Tessa es una chica del montón. Su plan para el último curso del instituto es pasar desapercibida y seguir admirando a su fichaje, Jay Stone, desde la distancia. Pero todo cambia cuando el hermano de Jay, Cole, vuelve al instituto. Desde que Tessa puede recordar, Cole se ha dedicado a hacerle la vida imposible. Aunque también es verdad que si vas a tener un enemigo número uno, mejor que sea como Cole: alto, buenorro como hay pocos y con unos ojos azules que tiran para atrás. Sí, es verdad, ha sido el tormento de Tessa desde que eran pequeños: le ha puesto motes, se ha metido con su manera de hablar, de andar y hasta de respirar. Pero el chico que ha vuelto no se parece en nada al bully de antes. Este chico nuevo la desafía, prueba sus límites, la fuerza a sacar a la chica guay que ella se empeña en esconder bajo una capa de mediocridad y cutrerío... ¡Un momento! ¿Podría ser que quien ella cree que es su peor pesadilla sea en realidad su ángel de la guarda? Ya lo dice el refrán: quien bien te quiere, te hará rabiar. ADVERTENCIA: Incluido en esta historia viene un chico malo, cuyas contraindicaciones son suspiros pronunciados y risa histérica. Los efectos secundarios incluyen alucinaciones y plantearte si podrías encontrar uno igualito en eBay y pagar por él lo que sea necesario. La opinión de los lectores: «Gracias a Dios [que me hice con este libro] porque esta reseña se queda corta para decir lo mucho que he amado a Cole. Te odiaré hasta que te quiera es una lectura juvenil que te engancha y que te hace suspirar cada página por Cole dejándote con un final altamente inesperado.» Blog La chica del mundo perdido «Lo devoré. Lo saboreé lenta y orgullosamente y lo disfruté con ganas. Fui feliz mientras leía. [...] Es una de esas novelas que conseguirá hacerse un huequecito en vuestros corazones a la mínima, capaz de despertaros muchos sentimientos y desenterrar recuerdos enterrados. Altamente recomendable.» Blog El blog de Wendy', v_15, 'PDF/Bad Boy''s Girl Te odiare hasta que te quiera - Blair Holden.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Reclamada por sus parejas' AND Autor = 'Grace Goodwin') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Reclamada por sus parejas', 'Grace Goodwin', 'Drogan, Tor y Lev, los trillizos de Royal Viken, deben tomar una pareja y engendrar un heredero lo antes posible para unir a su gente cuando una amenaza terrible pone en peligro su mundo. Con su futuro y el del planeta en juego, ¿su errante novia resistirá tercamente las demandas de su cuerpo o se rendirá para ser reclamada por sus compañeros?', v_201, 'PDF/Reclamada por sus parejas - Grace Goodwin.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Ciudad de los ángeles caídos' AND Autor = 'Cassandra Clare') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Ciudad de los ángeles caídos', 'Cassandra Clare', 'Alguien está dando muerte a los Cazadores de Sombras del círculo de Valentine, y esas muertes enemistan de nuevo a los Cazadores de Sombras con los subterráneos. Solo Simon, ahora convertido en vampiro, podrá evitar el enfrentamiento. Mientras, Clary y Jace descubrirán un misterio que les llevará a fortalecer su relación o... a destruirla para siempre.', v_186, 'PDF/Ciudad de los ángeles caídos - Cassandra Clare.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Técnica de Liberación Emocional (Tapping EFT) para pérdida de peso' AND Autor = 'Randal P. Lawrence') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Técnica de Liberación Emocional (Tapping EFT) para pérdida de peso', 'Randal P. Lawrence', NULL, v_181, 'PDF/Técnica de Liberación Emocional (Tapping EFT) para pérdida de peso - Randal P. Lawrence.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Champion' AND Autor = 'Marie Lu') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Champion', 'Marie Lu', 'The explosive finale to Marie Lu''s New York Times bestselling LEGEND trilogy - perfect for fans of THE HUNGER GAMES and DIVERGENT! He is a Legend. She is a Prodigy. Who will be Champion? June and Day have sacrificed so much for the people of the Republic - and each other - and now their country is on the brink of a new peaceful existence. June is back in the good graces of the Republic, working within the government''s elite circles while Day has been assigned a high level military position. But when a plague outbreak, deadlier than any other, causes panic in the Colonies, and war threatens the Republic''s border cities, the two are thrown back together. June is the only one who knows the key to her country''s defence. But saving the lives of thousands will mean asking the one she loves to give up everything he has. With heart-pounding action and suspense, Marie Lu''s bestselling trilogy, a brilliant re-imaginging of Les Miserables, draws to a stunning conclusion. Praise for the Legend trilogy: If you liked The Hunger Games, you''ll LOVE this! - Sarah-Rees Brennan, author of The Demon''s Lexicon Legend is impossible to put down and even harder to forget - Kami Garcia, NYT bestselling author of Beautiful Creatures Razor-sharp plotting, depth of character and emotional arc, Legend doesn''t merely survive the hype, it deserves it - USA Today ''To me it blows the socks off of Hunger Games." - Wyck Godfrey, producer of The Twilight Saga @Marie_Lu marielu.org legendtheseries.com facebook.com/legendtheseries', @Cat_Distopacienciaficcinjuvenil, 'PDF/Champion - Marie Lu.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Heredera de fuego' AND Autor = 'Sarah J. Maas') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Heredera de fuego', 'Sarah J. Maas', 'Ella es la heredera de ceniza y fuego, y no se doblegará ante nadie. Descubre la tercera parte de la trilogía Trono de Cristal, serie bestseller de The New York Times. La asesina del rey enfrenta el desafío de un destino aún más importante y arde con un resplandor más impresionante que nunca antes en Heredera de fuego, continuación del bestseller Corona de sangre. Celaena Sardothien ha sobrevivido a mortíferos combates y a la demoledora experiencia del desamor, pero a un costo indescriptible. Ahora debe viajar a una nueva tierra para enfrentar su más oscuro pasado, una verdad sobre su historia que podría darle un vuelco a su vida, y a su futuro, para siempre. Mientras tanto, brutales y monstruosas fuerzas se van reuniendo en el horizonte e intentan esclavizar su mundo. Para derrotarlos, Celaena debe hallar la fortaleza no solo para combatir a sus propios demonios internos, sino para vencer al mal que está a punto de desencadenarse. La crítica ha opinado: "Los lectores van a devorar esta última entrega de Sarah J. Maas... Una adquisición obligada." - School Library Journal- "Una avalancha de tensión con giros devastadores y un desenlace absolutamente fascinante. Dejará a los lectores ávidos de más." - Kirkus Reviews- "¡Temía soltar este libro!" -Tamora Pierce, autora bestseller de The New York Times-', v_215, 'PDF/Heredera de fuego - Sarah J. Maas.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'La novia se va a Irlanda' AND Autor = 'Carlota Manzano') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('La novia se va a Irlanda', 'Carlota Manzano', '<div>
<p style="font-family: ''Amazon Ember'',''Arial'',''sans-serif''; font-size: 14px"><span style="color: #333333; background-color: #ffffff">Andrea entra en la iglesia del brazo de su padre para casarse cuando no puede creer lo que ven sus ojos… El pasado a menudo nos persigue y a veces lo hace en los lugares más insospechados y en las situaciones más variopintas. De lo que decida en ese momento van a depender su futuro y el de su bebé, Lorcan. La mirada de su déspota progenitor no la ayuda, pero ¿será capaz de tomar una decisión que suponga una vuelta de tuerca brutal para sus vidas?</span></p></div>', v_98, 'PDF/La novia se va a Irlanda - Carlota Manzano.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'La ciencia del lenguaje corporal' AND Autor = 'Camila Díaz') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('La ciencia del lenguaje corporal', 'Camila Díaz', NULL, v_9, 'PDF/La ciencia del lenguaje corporal - Camila Diaz.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Empire of Storms' AND Autor = 'Sarah J. Maas') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Empire of Storms', 'Sarah J. Maas', 'Only the greatest sacrifice can turn the tide of war. War is brewing in the fifth book in this complete, #1 bestselling Throne of Glass series by Sarah J. Maas, author of the Court of Thorns and Roses (ACOTAR) series.', v_215, 'PDF/Empire of Storms - Sarah J. Maas.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '#Mírate' AND Autor = 'Andrea Vilallonga') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('#Mírate', 'Andrea Vilallonga', 'Andrea Vilallonga, profesora de OT 2017 y experta en imagen y comunicación, nos presenta el método #MÍRATE: Mejora tu imagen, renueva tu actitud, trabaja tu expresión. EL MÉTODO MÍRATE TE PERMITE, SENCILLAMENTE, AMARTE: - Aceptar cómo te ves. - Mejorar la comunicación con los demás. - Aclarar lo que realmente quieres transmitir con tu imagen. - Revelar qué te hace único y decidir sacar lo mejor de ti mismo. - Transformar la perspectiva que tienes sobre tu imagen. - Elevar tu autoestima. El método #MÍRATE se basa en la idea de aceptación de la imagen propia como punto de mejora, usándola como elemento de presencia y no de belleza. Este libro desarrolla un trabajo que explica cómo descubrir cuál es la imagen transmitida y, a través de la propia imagen externa, la expresión y la actitud, entender cómo mejorarla, basándose siempre en las características y necesidades de cada persona para transmitir su verdadero yo, sin disfrazarse o querer ser lo que no se es.', v_148, 'PDF/Mirate - Andrea Vilallonga.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Técnicas terapéuticas de la oración' AND Autor = 'Joseph Murphy') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Técnicas terapéuticas de la oración', 'Joseph Murphy', 'En este libro, el doctor Murphy nos enseña unas técnicas de oración cuya eficacia está comprobada, pues han ayudado a miles de personas en todo el mundo a resolver sus problemas. A través de ejemplos sacados de la vida real, podemos ver cómo a menudo la o', v_0, 'PDF/Tecnicas terapeuticas de la oracion - Joseph Murphy.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Angel' AND Autor = 'Sarah Brianne') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Angel', 'Sarah Brianne', 'Un ángel es un ser sobrenatural presente en varias religiones y mitologías, cuya función principal es servir a una deidad suprema. Sus funciones y especificaciones varían según cada cultura. La rama de la teología que se especializa en  los ángeles se denomina angelología.
Las religiones monoteístas muchas veces representan a los ángeles como seres celestiales benevolentes que actúan como intermediarios entre Dios y la humanidad.
En el catolicismo se habla del ángel de la guarda o del custodio, que sería aquel que Dios tiene señalado a cada persona para protegerla. Por contraposición, también se tiene la figura del ángel caído, aquel que ha sido expulsado del cielo por desobedecer o rebelarse contra Dios. Los ángeles más conocidos en las tradiciones judeocristianas son: San Miguel, San Gabriel y San Rafael.', v_99, 'PDF/Angel - Sarah Brianne.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Leif' AND Autor = 'Abbi Glines') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Leif', 'Abbi Glines', '"She was mine. I owned her soul...until Death stole her heart." This is a novella to be read after Existence and Predestined.', v_93, 'PDF/Leif - Abbi Glines.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El libro de los chakras' AND Autor = 'Osho') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El libro de los chakras', 'Osho', NULL, v_150, 'PDF/El libro de los chakras - Osho.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Redimida' AND Autor = 'P. C. Cast y Kristin Cast') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Redimida', 'P. C. Cast y Kristin Cast', 'Zoey Redbird está em apuros. Tendo dado a pedra da vidência para Aphrodite e rendendo‐se à Polícia de Tulsa, ela se isola de seus amigos e mentores, determinada a enfrentar a punição que merece – mesmo que isso lhe custe a vida. Só o amor das pessoas mais próximas poderá salvá‐la da escuridão em seu espírito. Um mal terrível emerge das sombras, mais poderoso do que nunca... Neferet finalmente se revela aos mortais. Coroando‐seDeusa das Trevas, ela está desencadeando o mal e escravizando os cidadãos de Tulsa. Os vampiros da Morada da Noite aliam‐se à polícia, juntando suas últimas forças, mas sabem que nenhum deles é forte o suficiente para vencê‐la. Apenas Zoey é herdeira de tal poder... contudo, está incapacitada de ajudar por causa das consequências do uso da magia antiga. No derradeiro livro da série House of Night, uma batalha épica da Luz contra as Trevas irá decidir quem será redimida... ... e quem se perderá para sempre.', v_118, 'PDF/Redimida - P. C. Cast y Kristin Cast.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El precio de la inteligencia' AND Autor = 'Jordi Agustí, Enric Bufill y Marina Mosquera') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El precio de la inteligencia', 'Jordi Agustí, Enric Bufill y Marina Mosquera', 'En la investigación sobre el origen de nuestra mente están hoy involucradas un gran número de disciplinas, que incluyen la paleoantropología, la paleoecología humana, la arqueología prehistórica, la primatología, la etología, la neurociencia cognitiva y la genómica. La cuestión del origen de la mente humana, por tanto, sólo puede ser abordada desde un enfoque pluridisciplinar. Pero a pesar de los importantísimos logros de los últimos años, la tarea sigue siendo mucho más ardua de lo que podíamos imaginar: cada nuevo avance supone un nuevo frente abierto que muchas veces plantea muchas más nuevas cuestiones de las que pretendía responder. Y ello es así porque la complejidad de la tarea es directamente proporcional a la complejidad del problema que se pretende abordar, la mente humana y su origen. Esta obra pretende hacer un recorrido por las cuestiones más candentes en torno al origen de la mente humana y el órgano que la rige, el cerebro, así como trazar algunas de las líneas maestras que pueden marcar la investigación en este campo. Los autores pretenden ofrecer un esbozo de algunas de las líneas de investigación más activas que se desarrollan en este centro, como son la paleoantropología, la paleoecología humana, la arqueología prehistórica, la neurociencia evolutiva o los estudios sobre cognición en primates.', v_59, 'PDF/El precio de la inteligencia - Jordi Agusti, Enric Bufill y Marina Mosquera.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¡Crear o morir!' AND Autor = 'Andrés Oppenheimer') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¡Crear o morir!', 'Andrés Oppenheimer', NULL, v_67, 'PDF/Crear o morir - Andres Oppenheimer.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El príncipe sueco' AND Autor = 'Karina Halle') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El príncipe sueco', 'Karina Halle', NULL, v_122, 'PDF/El principe sueco - Karina Halle.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El Clan de la Foca' AND Autor = 'Michelle Paver') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El Clan de la Foca', 'Michelle Paver', 'Cuando una enfermedad empieza a afligir a los clanes, Torak, de 12 años, con la ayuda de Renny Wolf, sale en un viaje para encontrar un remedio.', v_206, 'PDF/El Clan de la Foca - Michelle Paver.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Divergente' AND Autor = 'Veronica Roth') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Divergente', 'Veronica Roth', 'Una sola elección puede transformarte. Una sola elección puede destruirte. Una elección te define. Divergente, una de las sagas más exitosas de todos los tiempos, reunida en un atractivo estuche. Una apasionante historia distópica de elecciones electrizantes, consecuencias poderosas, un romance inesperado y una sociedad perfecta que es en realidad profundamente defectuosa. En una sociedad dividida donde todos deben conformarse, Tris no encaja. Así que se aventura, sola, decidida a descubrir a dónde pertenece realmente. Una tetralogía apasionante para todos los que intentan identificar su lugar en el mundo.', v_137, 'PDF/Divergente - Veronica Roth.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Panteras' AND Autor = 'Lena Valenti') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Panteras', 'Lena Valenti', 'Imoco Volley es un club de voleibol femenino italiano fundado en Conegliano, perteneciente a la Serie A1 de la Liga Italiana de Voleibol. Es uno de los clubes de voleibol femenino italianos más exitosos, habiendo conseguido ocho títulos de liga, tres campeonatos europeos y tres mundiales, entre otras competencias.', v_121, 'PDF/Panteras - Lena Valenti.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Detrás de tu mirada' AND Autor = 'Adriana Rubens') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Detrás de tu mirada', 'Adriana Rubens', 'Segunda entrega de la serie «Whitechapel» de Adriana Rubens. Una novela romántica histórica ambientada en el Londres de finales del siglo XIX, de la mano de una autora clásica del sello y ganadora del Premio Vergara. Lady Samantha Richmond es una dama poco común. No solo por su singular belleza sino por el interés que tiene en ejercer una profesión: ser periodista. Un empleo poco usual para una mujer a finales del siglo XIX y completamente descabellado para la hija de un duque. Sabedor de que la joven no va a dejar que nadie la detenga en sus aspiraciones, su padre, Nathaniel Richmond, duque de Bellrose, decide contratar los servicios de la mejor empresa de seguridad de Londres para protegerla mientras trabaja. En los blogs... «La historia de amor entre los personajes prometía un libro que estaba deseando leer, pero Adriana Rubens ha ido más allá de mis expectativas y me ha dejado con una sensación tan maravillosa y aturdida al terminar la novela, que lo único quería hacer era volver a principio para releer la historia de nuevo con todos su matices. Porque así es Detrás de tu mirada, una de esas joyas que necesito guardar en mi estantería para poder volver a disfrutar de sus inolvidables escenas siempre que quiera.» Blog A merced de las musas', v_231, 'PDF/Detrás de tu mirada - Adriana Rubens.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Inteligencia relacional: una mejor manera de vivir y convivir' AND Autor = 'Jaime García Aguilera; Manuel Manga') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Inteligencia relacional: una mejor manera de vivir y convivir', 'Jaime García Aguilera; Manuel Manga', NULL, v_109, 'PDF/Inteligencia relacional una mejor manera de vivir y convivir - Jaime García Aguilera; Manuel Manga.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El éxtasis de Gabriel' AND Autor = 'Sylvain Reynard') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El éxtasis de Gabriel', 'Sylvain Reynard', NULL, v_98, 'PDF/El extasis de Gabriel - Sylvain Reynard.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Curso práctico de dibujo y pintura 1' AND Autor = 'RBA') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Curso práctico de dibujo y pintura 1', 'RBA', NULL, v_119, 'PDF/Curso práctico de dibujo y pintura 1 - RBA.pdf', '.pdf', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¿De quien te escondes?' AND Autor = 'Charlotte Link') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¿De quien te escondes?', 'Charlotte Link', '«¿De quién te escondes?». Al final Simon tiene que preguntárselo a Nathalie. Dos días atrás se tropezó con esta joven en la playa. Estaba demacrada y asustada, y él se ofreció a ayudarla. Una decisión impulsiva que se ha vuelto en su contra, pues desde entonces se han visto envueltos en una espiral creciente de violencia y muerte que les ha convertido en blancos… ¿de quién? Nathalie no está simplemente perdida o desamparada, como él creyó. ¿Es una víctima? ¿Es culpable? ¿Qué está pasando? «¿De quién te escondes?», un suspense psicológico impecable, nos lleva a una decisión cuyas consecuencias, como sucede tantas veces, era imposible prever, al tiempo que va atrapándonos en una historia de secretos, mentiras, asesinatos y una sórdida red que trafica con los sueños y la vida de quienes tienen poco que perder. La novela que desbancó a J. K. Rowling, Elena Ferrante, Henning Mankell, Stephen King y Jojo Moyes en las listas de libros más vendidos en Alemania.', v_77, 'EPUB/De quien te escondes - Charlotte Link.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Destino: tu Corazón' AND Autor = 'Katy Colins') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Destino: tu Corazón', 'Katy Colins', 'Déjate llevar… Se suponía que poner en marcha el Club de Viaje de los Corazones Solitarios iba a ser una segunda oportunidad, la oportunidad que le devolvería a Georgia Green su vida. Ella pensaba que tan solo sería cuestión de viajar, pero la realidad no era tan idílica, ¡poner en marcha un nuevo negocio no era precisamente un camino de rosas! Así que, cuando Georgia se vio de repente rumbo a la India por una cuestión de trabajo, supo que algo tenía que cambiar. ¿Dónde estaba la chica que había luchado con tanto ahínco por reconstruir su vida? Tal vez, en la tierra de Bollywood, de las playas maravillosas y del Taj Mahal, pudiera encontrar la clave para recuperar el ritmo… Pero lo que estaba a punto de comprobar era que, en La India, el país tenía las riendas de la situación, y no el viajero. ¡Sin embargo, Georgia no iba a desanimarse tan fácilmente! Puro entretenimiento.', v_34, 'EPUB/Destino tu Corazón - Katy Colins.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Tu nombre es escándalo' AND Autor = 'Stephanie Laurens') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Tu nombre es escándalo', 'Stephanie Laurens', '«SERÁ EL PADRE DE TUS HIJOS...». Catriona Hennessy, la señora del valle un viejo título de la pequeña aristocracia escocesa, queda desconcertada al recibir esta predicción. ¿Cómo puede ella casarse con Richard Cynster, un autoritario caballero con una reputación escandalosa? Más asombroso todavía resulta el testamento de su tutor, que decreta que ella y Richard han de casarse en el plazo de una semana. Aunque no puede negar que a pesar de todo se siente muy atraída por él, no quiere renunciar a su independencia, por lo que urde un plan para conseguir lo que necesita sin tener que pronunciar los votos nupciales. Richard se queda igual de atónito ante la disposición testamentaria. El matrimonio nunca ha entrado en sus planes, aunque quizás domesticar a la señora del valle sea justo el desafío que necesita...', v_220, 'EPUB/Tu nombre es escándalo - Stephanie Laurens.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Cómo seducir a un guerrero' AND Autor = 'Karen Marie Moning') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Cómo seducir a un guerrero', 'Karen Marie Moning', 'Gavrael Mclllioch había nacido en un clan de guerreros de fuerza sobrenatural, pero abandonó su nombre y su castillo de las Highlands decidido a escapar del sombrío destino de sus antepasados. Ocultando su identidad al implacable clan rival que lo perseguía, pasó a llamarse Grimm para proteger a la gente que le importaba y juró no admitir jamás su amor por la encantadora Jillian St. Clair. Y entonces el padre de Jillian lo convocó con urgencia…¿Por qué había huido él de ella durante tantos años? Y ¿por qué regresa ahora para verla ofrecida como premio en una competición orquestada por su padre? Furiosa, Jillian había jurado no casarse jamás. Pero Grimm era el hombre al que amaba, y ella la única mujer que podía domeñar a la bestia que bramaba dentro de él… Todo ello, mientras sus enemigos mortales se conjuraban para acabar con ambos.', v_37, 'EPUB/Cómo seducir a un guerrero - Karen Marie Moning.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Padres Toxicos' AND Autor = 'Jose Luis Canales') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Padres Toxicos', 'Jose Luis Canales', '<font class="Apple-style-span" face="''MS Shell Dlg 2'', sans-serif"><span class="Apple-style-span" style="font-size: 12px;">El legado de una infancia tóxica es fácil de reconocer pero difícil de interiorizar y superar. Nuestros padres dejan semillas emocionales en nosotros. En algunas familias, éstas son de respeto, amor e independencia, pero en otras, son de miedo, culpa y autocastigo. Si te identificas con el segundo grupo, necesitas entender el legado nocivo de tus padres y comprometerte a cambiar los pensamientos dañinos que te marcaron, dejar ir las emociones negativas que rigen tu vida y reconocer que, mientras no te liberes de las enredaderas de tu infancia, vivirás un ciclo autodestructivo. Todos los padres emocionalmente sanos se equivocan; el problema es cuando lo hacen intencionalmente y de manera repetitiva. Es normal que pierdan el control por momentos o que tengan ciertas conductas abusivas con los hijos; sin embargo, lo que los convierte en tóxicos es el patrón de daño constante. Los hijos de padres tóxicos tienden a relacionar el amor con sufrimiento, a caer en relaciones de dependencia, a vivir con culpa y, más importante aún, a repetir los patrones destructivos que sufrieron en su niñez. Recuerda que no eres culpable de lo que viviste en la infancia pero sí eres responsable de tu adultez. Este libro es el primer paso para tener una vida plena, romper los patrones perjudiciales que viviste y criar una familia sana. </span></font>', v_127, 'EPUB/Padres Toxicos - Jose Luis Canales.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'La violinista de la rosa blanca' AND Autor = 'Amelia Noguera') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('La violinista de la rosa blanca', 'Amelia Noguera', '<div>
<p style="font-family: ''Arial''; font-size: 14px"><span style="background-color: #ffffff; color: #333333">Una desgraciadísima noche de luna llena, el barrendero Hipólito mata por accidente con el camión de la basura a la anciana vagabunda Isabella y al socorrerla, su amigo Bruno cae en coma. Sintiéndose culpable por la desventura de los dos, nuestro protagonista iniciará entonces un viaje que comienza por el encuentro con una loca heredera que busca al asesino de su padre y jura y perjura que él y otros fueron asesinados hace décadas, allá por los años cincuenta más o menos, por un hombre lobo, a quien ella necesita encontrar para vengarse. Y este viaje sabe dios dónde acaba, pero llevará a Hipólito —un buen chico que cuida de su abuelo enfermo, aunque también un poco desmemoriado, maniático y puede que algo gafe— tras la pista de los dos, en una sucesión de episodios a veces grotescos y disparatados, pero siempre emocionantes.</span></p></div>', v_138, 'EPUB/La violinista de la rosa blanca - Amelia Noguera.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Hugo: Un corazón para conquistar' AND Autor = 'Jenny Del') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Hugo: Un corazón para conquistar', 'Jenny Del', '<div>
<p style="font-size: 14px; font-family: ''Amazon Ember'',''Arial'',''sans-serif''"><span style="color: #333333; background-color: #ffffff">Cuando Mara conoce a Hugo no puede imaginar que perderá la cabeza por él. Y es que ese misterioso hombre, que le da una de cal y otra de arena, parece jugar con ella a su antojo. La espiral sexual en la que ambos se ven envueltos no es más que la punta del iceberg. Lo complicado llega cuando los sentimientos entran en juego.</span></p></div>', v_38, 'EPUB/Hugo - Un corazón para conquistar - Jenny Del.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Nieblas de las Highlands' AND Autor = 'Karen Marie Moning') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Nieblas de las Highlands', 'Karen Marie Moning', 'En el reino todo el mundo lo conoce como Halcón, legendario predador de los campos de batalla y los tocadores de las damas. Ninguna mujer puede resistirse a sus encantos, pero ninguna ha conquistado jamás su corazón. Hasta que un hada vengativa hace caer a Adrienne de Simone, del moderno Seattle a la Escocia medieval... Cautiva en un siglo que no es el suyo, absolutamente temeraria, franca y sincera, constituye un desafío irresistible para un bribón [también podría ser donjuán, por el contexto] del siglo XVI. Obligada a casarse con Halcón, Adrienne jura mantenerlo a distancia..., pero los encantos de él hacen estragos en sus planes. Para ese bribón ella siempre tiene un rotundo ''no'' en los hermosos labios, pero Halcón se ha propuesto que susurre su nombre presa del deseo, de la pasión arrebatadora que ha conseguido encender en su interior. Las barreras del tiempo y el espacio no impedirán que Halcón conquiste el amor de Adrienne. A pesar de su indecisión acerca de si seguir o no los deseos de su apasionado corazón, las reticencias de Adrienne aumentan la determinación de Halcón de conservarla a su lado.', v_227, 'EPUB/Nieblas de las Highlands - Karen Marie Moning.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Las Guerreras 03 - Siempre te encontraré' AND Autor = 'Megan Maxwell') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Las Guerreras 03 - Siempre te encontraré', 'Megan Maxwell', 'Tercer volumen de la saga que consagró a Megan como la autora más querida del género El laird Kieran O''Hara y sus guerreros son atacados por unos villanos mientras pernoctan en el bosque cercano al castillo de Caerlaveroch, pero una misteriosa banda de encapuchados, liderados por una mujer a la que los aldeanos llaman «Hada», consigue salvarlos. Angela es la menor de las hijas del laird Kubrat Ferguson. Todo el mundo cree que es una muchacha débil, temerosa de los caballos y que tiembla ante el acero. Cuando Kieran la conoce, la actitud tímida de la joven, su torpeza y su sentido del pudor ante su caballerosidad y galantería llaman su atención, sin saber que aquélla es la encapuchada a la que anda buscando. Juntos conseguirán desenmascarar al codicioso cuñado de Angela, Cedric Steward, quien ha tramado un plan terrible que cambiará para siempre el futuro de los habitantes del castillo de Caerlaveroch. Una historia vibrante, con unos personajes que te enamorarán y te harán sonreír mientras disfrutas de sus andanzas por las Highlands escocesas.', v_42, 'EPUB/Las Guerreras 03 - Siempre te encontraré - Megan Maxwell.epub', '.epub', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Diagnóstico del placer' AND Autor = 'Mimmi Kass') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Diagnóstico del placer', 'Mimmi Kass', 'Después de todo lo ocurrido entre ellos, las dudas atormentan a Erik y a Inés. Caer en una relación sin futuro podría destrozarlos a los dos, pero sus límites comienzan a difuminarse, y todo aquello en lo que creen, lo que sienten y anhelan, se derrumba y se rompe en mil pedazos. Santiago de Chile muestra su doble faz, desde el lujo más obsceno hasta la pobreza más amarga. Erik ya no sabe cuál es su hogar, y su vocación se tambalea. Inés experimenta el placer más sublime y el dolor más absoluto. El sexo adquiere dimensiones hasta ahora nunca exploradas. Cuando la persona que camina a tu lado sacude todos tus cimientos, solo cabe una pregunta. ¿Se atreverán a explorar fuera de su zona de confort? Por fin llega la esperada segunda entrega de En cuerpo y alma. En Diagnóstico del placer, el erotismo y las emociones se profundizan. Tras el éxito conseguido con Radiografía del deseo, best seller en ficción erótica de Amazon, la autora nos entrega una historia donde los límites se hacen difusos y los personajes se ven enfrentados continuamente con el desafío de abandonar sus zonas de confort. Y tú, ¿sabes bien cuáles son tus límites?', v_198, 'EPUB/Diagnóstico del placer - Mimmi Kass.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Caer' AND Autor = 'Javier de Frutos') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Caer', 'Javier de Frutos', '<div><p class="description"></p><div style="font-family: ''MS Shell Dlg 2'', sans-serif; font-size: 12px; text-align: justify;"><b style="color: rgb(51, 51, 51); font-family: verdana, arial, helvetica, sans-serif; font-size: small; orphans: 2; widows: 2; background-color: rgb(255, 255, 255);">La historia oculta que el Vaticano no quiere que sepas, ni Dan Brown que leas.</b></div><div style="text-align: justify;"><font color="#333333" face="verdana, arial, helvetica, sans-serif" size="2"><br></font></div><strong style="font-family: verdana, arial, helvetica, sans-serif; font-size: small; color: rgb(51, 51, 51); orphans: 2; widows: 2; background-color: rgb(255, 255, 255);"><div style="text-align: justify;"><strong>Septiembre de 2014 (España).</strong> Daniel Steelman, un joven profesor de idiomas canadiense, recibe la desesperada llamada de una exalumna: su hermana gemela ha desaparecido y necesita su ayuda.</div></strong><div style="text-align: justify;"><font color="#333333" face="verdana, arial, helvetica, sans-serif" size="2"><br></font></div><span style="font-family: verdana, arial, helvetica, sans-serif; font-size: small; color: rgb(51, 51, 51); orphans: 2; widows: 2; background-color: rgb(255, 255, 255);"><div style="text-align: justify;">Las circunstancias que rodean la desaparición y los descubrimientos que se irán realizando conforme se desarrolla la búsqueda pondrán de manifiesto que no se trata una simple desaparición más.</div></span><div style="text-align: justify;"><font color="#333333" face="verdana, arial, helvetica, sans-serif" size="2"><br></font></div><span style="font-family: verdana, arial, helvetica, sans-serif; font-size: small; color: rgb(51, 51, 51); orphans: 2; widows: 2; background-color: rgb(255, 255, 255);"><div style="text-align: justify;">El inesperado hallazgo de unas cartas de finales del s. XIX y otras de mediados del s. XX junto con un extraño moleskine revelará la verdad que en ellos se oculta.</div></span><div style="text-align: justify;"><font color="#333333" face="verdana, arial, helvetica, sans-serif" size="2"><br></font></div><span style="font-family: verdana, arial, helvetica, sans-serif; font-size: small; color: rgb(51, 51, 51); orphans: 2; widows: 2; background-color: rgb(255, 255, 255);"><div style="text-align: justify;">Una verdad difícil de asumir que algunos preferirían que nunca fuera descubierta.</div></span><div style="text-align: justify;"><font color="#333333" face="verdana, arial, helvetica, sans-serif" size="2"><br></font></div><span style="font-family: verdana, arial, helvetica, sans-serif; font-size: small; color: rgb(51, 51, 51); orphans: 2; widows: 2; background-color: rgb(255, 255, 255);"><div style="text-align: justify;">CAER <i>es una novela de misterio y acción en la que conviven personajes ficticios con otros reales no menos sorprendentes.</i></div></span><i style="orphans: 2; widows: 2; background-color: rgb(255, 255, 255);"><div style="text-align: justify;"><font color="#333333" face="verdana, arial, helvetica, sans-serif" size="2"><br></font></div><font color="#333333" face="verdana, arial, helvetica, sans-serif" size="2"><div style="text-align: justify;"><i><font color="#333333" face="verdana, arial, helvetica, sans-serif" size="2">Es el fruto de una minuciosa labor de investigación y documentación que ha permitido, basándose en ella, crear una trama intrigante que abre la mente del lector a hacerse preguntas que, tal vez, antes de leer este libro nunca se hubiera preguntado.</font></i></div></font></i><div style="text-align: justify;"><font color="#333333" face="verdana, arial, helvetica, sans-serif" size="2"><br></font></div><strong style="font-family: verdana, arial, helvetica, sans-serif; font-size: small; color: rgb(51, 51, 51); orphans: 2; widows: 2; background-color: rgb(255, 255, 255);"><div style="text-align: justify;"><strong>Solo quería acallar su conciencia,</strong></div><div style="text-align: justify;"><strong>acabar con aquellas pesadillas,</strong></div><div style="text-align: justify;"><strong>reconciliarse con su pasado.</strong></div></strong><b style="font-family: verdana, arial, helvetica, sans-serif; font-size: small; color: rgb(51, 51, 51); orphans: 2; widows: 2; background-color: rgb(255, 255, 255);"><div style="text-align: justify;"><b>Pero uno no elige su destino.</b></div></b></div>', v_103, 'EPUB/Caer - Javier de Frutos.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El beso del highlander' AND Autor = 'Karen Marie Moning') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El beso del highlander', 'Karen Marie Moning', 'Drustan MacKeltar, un vigoroso jefe de un clan escocés, había sido confinado por una maldición gitana a permanecer dormido en una cueva hasta el fin de los tiempos. Pero, quinientos años después, Gwen, una joven turista norteamericana, es capaz de cambiar tan triste sino y despertarle de un sueño eterno. Confuso y desorientado, Drustan sólo sabe que debe encontrar el modo de regresar a su época para salvar a su pueblo. Aunque ahora debe enfrentarse a un nuevo problema: ¿cómo abandonar a aquella atractiva joven que le ha devuelto la vida?', v_37, 'EPUB/El beso del highlander - Karen Marie Moning.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Deseo' AND Autor = 'Adrian Blake') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Deseo', 'Adrian Blake', 'Deseo es el undécimo álbum de estudio de la cantante mexicana Paulina Rubio. Fue lanzado el 14 de septiembre de 2018​ por Universal Spain, marcando su última producción con el sello discográfico Universal Music Group y el primero a siete años de editar Brava! (2011). Colaboró con una multitud de productores y músicos para el disco, entre ellos Mauricio Rengifo, Andrés Torres, los Julca Brothers, Antonio "Toy Selectah" Hernández, Joey Montana, Morat, Nacho, Juan Magán, Xabier San Martin y Alexis & Fido. Deseo es un álbum pop latino con una fuerte vibra del género urbano, aunque mantiene el característico estilo pop rock de la cantante en algunas canciones.
Paulina Rubio empezó a trabajar en un disco inédito a finales de 2014, pero por varias situaciones desconocidas Universal retrasó sus proyectos al grado de publicar sencillos independientes a lo largo de los siguientes dos años. Además, se involucró en su faceta como jueza en diferentes shows de televisión incluyendo la versión mexicana de La Voz, La Voz Kids, la versión estadounidense de The X Factor y La Apuesta.
Inicialmente se lanzaron dos sencillos del álbum: «Desire (Me Tienes Loquita)», una colaboración con Nacho, estrenada el 28 de mayo de 2018, y «Suave y Sutil», lanzada cuatro meses más tarde. El 15 de abril de 2019 se lanzó una edición especial de Deseo que incluía cuatro canciones inéditas, incluyendo el sencillo «Ya No Me Engañas», estrenado solo unos días antes del lanzamiento de la reedición.​ El disco también contiene los sencillos independientes  —lanzados entre 2015 y 2016— «Mi Nuevo Vicio», «Si Te Vas» y «Me Quema».
Tras su lanzamiento, Deseo recibió críticas mixtas por parte de los críticos de música, quienes elogiaron la «energía» de la cantante y su capacidad de adaptarse a los nuevos géneros musicales, pero sintieron que el flujo de las canciones en el disco no tenía ningún sentido ya que la mitad de los temas ya habían sido publicados, por lo que sostuvieron que se trataba más de una «compilación» poco sorprendente. Comercialmente, Deseo tuvo poco impacto en las listas musicales, alcanzando la posición número trece de la lista de Billboard Latin Pop Albums. Pese a ello, obtuvo una certificación de disco de oro en Chile,​ y se embarcó en una gira de conciertos en los Estados Unidos.', v_38, 'EPUB/S.E.C.R.E.T. 3 - Deseos revelados - L. Marie Adeline.mobi', '.mobi', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Zapatos de cristal' AND Autor = 'Ruy Alexander') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Zapatos de cristal', 'Ruy Alexander', '<div>
<p style="font-size: 14px; font-family: ''Amazon Ember'',''Arial'',''sans-serif''"><span style="color: #333333; background-color: #ffffff">''¿Qué niña no ha deseado ser una Cenicienta de cuento con su zapatito de cristal?'' Un traumático suceso llevará a Ana a desaparecer de su antigua vida, a cambiar de instituto, de compañeros, a desconfiar y saber que, tarde o temprano, le volverán a hacer daño. Con el telón de fondo de las redes sociales y cómo éstas afectarán a la vida de los protagonistas.</span></p></div>', v_213, 'EPUB/Zapatos de cristal - Ruy Alexander.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '(Fjallbacka 04) Crimen en directo' AND Autor = 'Camilla Lackberg') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('(Fjallbacka 04) Crimen en directo', 'Camilla Lackberg', 'Patrik y Erica siguen disfrutando de su idilio en el pueblo de Fjällbacka, ahora acompañados por su bebé, la pequeña Maja, que ya tiene ocho meses. Mientras la joven pareja está plenamente volcada en los preparativos de su próxima boda, los asuntos en la comisaría, donde Patrik trabaja, siguen su curso rutinario. Pero el alcalde reúne al pleno del Ayuntamiento para anunciar la llegada a Tanum de un equipo de televisión para filmar un «reality-show» bastante escandaloso llamado «Fucking Tanum» que, supuestamente, debería reportar unos jugosos beneficios a la población y que va a suponer en realidad una auténtica pesadilla. Poco después, Patrik debe investigar la muerte de una mujer, víctima de un accidente de tráfico. Aparentemente la mujer bebió más de la cuenta, pero a Patrik le llaman la atención unas extrañas marcas en el cuello de la víctima y descubre muy pronto que existe una misteriosa relación entre ese crimen y otros asesinatos que tuvieron lugar en el pasado en distintos lugares de Suecia. Al lado de todos los cuerpos había una página del cuento infantil «Hansel y Gretel». Mientras tanto, el productor del programa, consciente de que a mayor escándalo, mayor índice de audiencia, alimenta los conflictos entre el grupo de participantes.', v_39, 'EPUB/(Fjallbacka 04) Crimen en directo - Camilla Lackberg.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Witch Fury' AND Autor = 'Anya Bast') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Witch Fury', 'Anya Bast', 'Witches are taking the nation by storm. With the untapped gift to create fire, witch Sarafina Connell is caught up in a war between good and evil. And she has no choice but to join an infamous playboy in the battle for supremacy-one that''s getting hotter by the minute.', v_42, 'EPUB/Witch Fury - Anya Bast.epub', '.epub', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Petirrojo' AND Autor = 'Jo Nesbø') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Petirrojo', 'Jo Nesbø', 'Año 1944: Daniel, combatiente del frente oriental, muere asesinado en las trincheras de Leningrado. En un hospital de Viena, un soldado herido dice ser Daniel. Entre él y la enfermera Helena surge un romance. Año 1999: El investigador Harry Hole dispara por accidente a un agente de los servicios secretos durante la visita a Noruega del presidente norteamericano Clinton. Harry Hole es trasladado a la policía de seguridad ciudadana, donde se le asigna la misión de comprobar la información sobre una red de tráfico de armas relacionada con círculos de viejos y nuevos nazis. Año 2000: Mientras la nieve se funde en las calles de Oslo, entra en escena un asesino con un objetivo muy especial.', v_102, 'EPUB/Petirrojo - Jo Nesbø.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Lusitania. El hundimiento que cambió el rumbo de la historia' AND Autor = 'Erik Larson') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Lusitania. El hundimiento que cambió el rumbo de la historia', 'Erik Larson', 'Hacia las dos de la tarde del 7 de mayo de 1915, el Lusitania, el mayor y más lujoso transatlántico del momento, recibía el impacto de un torpedo disparado por un submarino alemán, hundiéndose en apenas veinte minutos con el doloroso balance de 1.200 muertos, la mayoría ciudadanos estadounidenses.Esta muerte fue utilizada por los periódicos para crear un clima de opinión propicio a la participación en la guerra. Incluso se dijo que a los niños alemanes se les había dado un día de fiesta para celebrar el hundimiento del Lusitania.Pero ¿cuál es la verdad sobre este hundimiento? ¿Fue un hecho orquestado para justificar la entrada de Estados Unidos en la Gran Guerra? ¿Iba cargado con armamento para la Gran Bretaña? La realidad como suele suceder es completamente diferente a lo divulgado por la prensa de la época.Este libro se acerca como nunca hasta ahora a todas las claves del suceso que llevo a Estados Unidos a intervenir en la primera guerra mundial, y que a la postre inclinaría la victoria hacia el lado aliado.', v_26, 'EPUB/Lusitania. El hundimiento que cambió el rumbo de la historia - Erik Larson.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Mi hermosa apostadora' AND Autor = 'A. S. Lefebre') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Mi hermosa apostadora', 'A. S. Lefebre', 'Una promesa y dos corazones dispuestos a apostar por un amor. Katherine Rushmore debe cumplir una promesa y casarse con el nieto del mejor amigo de su abuelo... pero ella en realidad solo desea una cosa: casarse por amor. Su carácter rebelde le obliga a no aceptar el compromiso, y decide hacer lo imposible para que su prometido, a quien aún no conoce, rompa con ella para encontrar así a quien robó su corazón unas noches atrás. Sebastian Beckham regresa a Londres con un único objetivo: cumplir la promesa de casarse. Sin embargo, una noche conoce a una misteriosa enmascara de ojos esmeralda vestida como un hombre, quien se adueña de sus sueños y su corazón... hasta que conoce a su prometida y queda atraído por su belleza y carácter. Tiene un serio problema: ella no quiere casarse y él se siente atraído por dos mujeres con el mismo color de ojos. Sebastian decide jugar su última carta y conquistar a su prometida, mientras que Katherine se encuentra cara a cara con quien le robó el corazón... y decide ponerlo a prueba. ¿Será él merecedor de su amor? ¿Cumplirán ambos la promesa de matrimonio?', v_37, 'EPUB/Mi hermosa apostadora - A. S. Lefebre.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Cuidado con el muñeco de nieve' AND Autor = 'R.L. Stine') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Cuidado con el muñeco de nieve', 'R.L. Stine', NULL, v_42, 'EPUB/(Pesadilla N°49) Cuidado con el muñeco de nieve - R.L. Stine.mobi', '.mobi', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Cruzada contra el Grial' AND Autor = 'Otto Rahn') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Cruzada contra el Grial', 'Otto Rahn', '<p class="description" style="text-align: justify;">La primera edición de «Cruzada contra el Grial» apareció en Alemania en 1933; era el resultado de varios años de investigación rigurosa. Su autor, Otto Rahn, tenía entonces veintiocho años. Su obra es la síntesis de sus visitas a la región de los cátaros y a los castillos de los templarios en el sur de Francia, de los impresionantes testimonios que recogió, de sus excursiones por el teatro de los hechos y de sus exploraciones en las cuevas pirenaicas acompañado por guías expertos, de su estudio de las fuentes en archivos y bibliotecas de universidades francesas y alemanas, y de su concienzudo trabajo bibliográfico. Su libro es un compendio de nociones y conocimientos de historia, de germanística, de religión, de arte y de vivas descripciones paisajísticas. En su campo, es un libro atrevido, que marcó caminos nuevos en la interpretación y en la recuperación del pasado. El autor parte en su obra de lo literario, del Parsifal de Wolfram von Eschenbach, y de la poesía de los trovadores y «minnesänger», para llevarnos al campo histórico de la creación de la Inquisición y de la Cruzada contra los Albigenses en que Roma y París, aliadas, acabaron con la civilización occitana y con unas formas de vida y espiritualidad que Rahn ejemplificó y simbolizó en el mítico Grial, el cáliz de los más altos ideales.</p>', v_46, 'EPUB/Cruzada contra el Grial - Otto Rahn.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Un hombre sueña despierto' AND Autor = 'Lavie Tidhar') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Un hombre sueña despierto', 'Lavie Tidhar', 'En el campo de concentración más infame de la historia, un hombre sueña despierto. Se llama Shomer, y antes de la guerra era escritor de novelas pulp. Ahora, para escapar de la brutal realidad de su vida en Auschwitz, pasa sus noches imaginando otro mundo, uno en el que un exdictador llamado Wolf lleva una vida miserable como detective en Londres.Como toda buena novela negra, la trama comienza en la oficina cutre del detective con la visita de una mujer fatal que requiere de sus servicios. Aquí empieza la caída libre del personaje en un proceso de humillación, destrucción y transformación. Tras todo tipo de vejaciones, Wolf, Adolf Hitler, acabará transformado en judío, en humano.El modo en que al final se entrelazan ficción y realidad es sobrecogedor. Una novela fantástica, de ritmo trepidante y muy divertida. Un homenaje inolvidable al poder de la imaginación.', v_17, 'EPUB/Un hombre sueña despierto - Lavie Tidhar.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Esposa de mi jefe' AND Autor = 'Rox Aguirre') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Esposa de mi jefe', 'Rox Aguirre', '<div><div style="font-family: ''Segoe UI'', sans-serif; font-size: 13px; text-align: justify;"><span style="color: rgb(51, 51, 51); font-family: verdana, arial, helvetica, sans-serif; font-size: small; orphans: 2; widows: 2; background-color: rgb(255, 255, 255);">Alexandra Carlin, es una chica recién graduada de la universidad, sin éxito en el campo laboral, es contratada por fin como secretaria del presidente de una revista de prestigio a nivel internacional, Oliver Anderson, un joven apuesto de 25 años, Oliver está a punto de perder la presidencia de la empresa por no tener una vida formal, sus vidas dan un giro cuando hace un contrato con Alex de ser su esposa por seis meses.</span></div><div style="text-align: justify;"><font color="#333333" face="verdana, arial, helvetica, sans-serif" size="2"><br></font></div><span style="font-family: verdana, arial, helvetica, sans-serif; font-size: small; color: rgb(51, 51, 51); orphans: 2; widows: 2; background-color: rgb(255, 255, 255);"><div style="text-align: justify;">Conoce el divertido matrimonio odio-amor entre Alex Carlin y su jefe, una vez que nada sale como ellos esperaban.</div></span></div>', v_165, 'EPUB/Esposa de mi jefe - Rox Aguirre.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '(Las aventuras de Alfred y Agatha 1) Los 10 pajaros Elster' AND Autor = ' Ana Campoy') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('(Las aventuras de Alfred y Agatha 1) Los 10 pajaros Elster', ' Ana Campoy', '¿Qué hubiera ocurrido si Alfred Hitchcock y Agatha Christie se hubieran conocido de niños? ¿Qué aventuras habrían vivido? ¿Qué sorprendentes casos habrían resuelto juntos? Las aventuras de Alfred&Agatha nos muestra cómo podría haber sido la amistad de infancia de los dos maestros del suspense más importantes de nuestro tiempo. En esta primera entrega, Alfred vivirá la aventura más increíble que jamás hubiera imaginado. Junto a Agatha y Morritos Jones, investigará la desaparición de las diez joyas Elster, unas lujosas figuras con forma de pájaro. Y los tres se verán implicados en un caso de auténticos detectives cuando la dueña de las joyas, la vieja señora Elster, también desaparece. Alfred nunca hubiera pensado que saltaría en tirolina, que se colaría en una mansión a escondidas ni que sobreviviría a un ataque de pájaros hambrientos. Pero lo que jamás habría creído es que gracias a esta aventura, lograría encontrar amigos de verdad.', v_81, 'EPUB/(Las aventuras de Alfred y Agatha 1) Los 10 pajaros Elster - Ana Campoy.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'La princesa de hielo' AND Autor = 'Camilla Läckberg') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('La princesa de hielo', 'Camilla Läckberg', 'En un pueblo que esconde muchos secretos es peligroso saber la verdad. Se llamaba Alexandra, era joven, rica y guapa, y nadie en el pueblo se puede explicar su muerte. Por pura casualidad, Erica, amiga de la infancia y autora de biografías, se ve involucrada en el caso. Había regresado a su pueblo natal para hacerse cargo de la casa que acababa de heredar de sus padres, recientemente fallecidos en un accidente, y para trabajar en su próximo libro. Cuando la familia de Alex le pide que escriba un recordatorio para el funeral, Erica, todavía conmocionada por la repentina muerte de su amiga, comienza a investigar la vida de la víctima.Con la ayuda del comisario Patrik, otro viejo conocido que pronto se convertirá en algo más que un amigo, descubre un oscuro secreto, largamente guardado. Alguien conoció a Alex desde su infancia y le preparó un helado lecho mortuorio.Camilla Läckberg dibuja finamente el retrato de la sociedad cerrada de una pequeña ciudad, en la que todos lo saben todo de todo el mundo, pero en la cual las apariencias son fundamentales.', v_218, 'EPUB/La princesa de hielo - Camilla Läckberg.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Frío invierno en París' AND Autor = 'Dylan Martins, Janis Sandgrouse') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Frío invierno en París', 'Dylan Martins, Janis Sandgrouse', 'Cuando el vaso se llena, no hay más opción que poner remedio y distancia de por medio.

Eso es lo que hace Carmen cuando se da cuenta de que tiene que cambiar su vida.

Con una maleta y decidida a dejar todo atrás, viaja a París donde empezará a reconstruir su vida.

Una niña perdida, un hombre que dará la vuelta a su mundo, un secreto y un objetivo: ser feliz.

Acompaña a Carmen en esta huida sin retorno donde risas, emoción y amor serán parte de su rutina.', v_42, 'EPUB/Frío invierno en París - Dylan Martins, Janis Sandgrouse.epub', '.epub', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Némesis' AND Autor = 'Jo Nesbø') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Némesis', 'Jo Nesbø', 'Una cámara de seguridad muestra a un atracador en un banco de Oslo apuntando a un empleado. Le ha dado veinticinco segundos al director para que vacíe el cajero. Dispara. Ha tardado treinta y uno. A Harry Hole, el impredecible detective que ha dado fama mundial a Jo Nesbø, la imagen granulada del homicidio no se le va de la cabeza. Junto a la inexperta Beate Lønn deberá encontrar al asesino. Siguen la pista hasta un famoso atracador. Sólo que está en la cárcel. Además, Harry Hole tiene un gran defecto: nadie como él sabe crearse problemas y casi siempre huelen a alcohol. Cuando parecía que su vida privada había alcanzado la paz con Rakel y sus problemas en la comisaria estaban resueltos, amanece con una resaca que despierta sus peores pesadillas. Sólo recuerda la insensatez que cometió la noche anterior: atender la llamada y la invitación de Anna, una antigua novia, nada más. Lo peor es que Anna ha aparecido muerta esa misma mañana. Y él es el sospechoso, a menos que pueda aclarar y demostrar lo que ha hecho durante las últimas doce horas.', v_42, 'EPUB/Némesis - Jo Nesbø.epub', '.epub', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '(Fjallbacka 02) Los gritos del pasado' AND Autor = 'Camilla Lackberg') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('(Fjallbacka 02) Los gritos del pasado', 'Camilla Lackberg', 'La escritora Erika Falk y su compañero, el detective Patrik Hedströn, disfrutan de unas merecidas vacaciones en su casa en la pequeña población costera de Fjällbacka que, en verano, es visitada por muchos turistas. Erika está embarazada de ocho meses y la ola de calor hace especialmente difícil este último mes de gestación. En esta situación, lo que menos falta le hace a la joven pareja es un nuevo caso de asesinato. Pero las vacaciones de Patrik se terminan de golpe, cuanto un niño descubre casualmente el cadáver de una joven turista. Lo más extraño es que junto al cadáver aparecen los restos de dos mujeres desaparecidas años atrás. Las autopsias demuestran que las tres víctimas murieron estranguladas y que además fueron torturadas. Basando el suspense en la acertada caracterización de los personajes, el realismo de sus comportamientos y una excelente ambientación, Camilla Läckberg vuelve a mantener al lector sin aliento hasta la última página y consigue meternos de lleno en la piel de los protagonistas.', v_39, 'EPUB/(Fjallbacka 02) Los gritos del pasado - Camilla Lackberg.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Artemis Fowl' AND Autor = 'Eoin Colfer') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Artemis Fowl', 'Eoin Colfer', 'Nom : Fowl. Prénom : Artemis. Age : 12 ans. Signes particuliers : une intelligence hors du commun. Profession : voleur. Recherché pour : enlèvement de fée et demande de rançon. Appel à tous les FARfadets, membres des Forces Armées de Régulation du Peuple des fées : cet humain est dangereux et doit être neutralisé par tous les moyens possibles. Un anti-héros pétillant de malice, une galerie de personnages décapants, des dialogues vifs et intelligents, une histoire au rythme débridé... Laissez-vous entraîner dans l''univers sophistiqué d''Eoin Colfer, unique et enchanteur.', v_10, 'EPUB/Artemis Fowl - La cuenta atrás - Eoin Colfer.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '3 pasos contra el sedentarismo' AND Autor = 'Juanje Ojeda') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('3 pasos contra el sedentarismo', 'Juanje Ojeda', '<span style="font-family: Tahoma, sans-serif, Arial, Helvetica; orphans: 2; white-space: pre-wrap; widows: 2; background-color: rgb(255, 255, 255);">Caminar más, colgarte de las manos y sentarte a menudo en el suelo son los tres sencillos pasos que te ayudarán a moverte más y mejor y a contrarrestar los graves efectos del sedentarismo en tu bienestar. Si tienes problemas de movilidad, dolores o estrés, muy probablemente sean a causa de nuestro estilo de vida sedentario. Juanje Ojeda, entrenador personal, te da las claves para recuperar la funcionalidad de tu cuerpo sin invertir mucho tiempo ni aplicar técnicas complejas. Tienes en las manos la mejor guía para personas sedentarias de todas las edades, pero también para atletas avanzados, con ejercicios muy sencillos pero de gran impacto en nuestra salud.</span>', v_166, 'EPUB/3 pasos contra el sedentarismo - Juanje Ojeda.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Las hijas del frío' AND Autor = 'Camilla Läckberg') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Las hijas del frío', 'Camilla Läckberg', 'La alegría de Erica y Patrik por el nacimiento de su hija es inmensa, pero deben enfrentarse a unos problemas nuevos para ellos; la pequeña llora mucho, Erica sufre una depresión posparto y Patrik está constantemente cansado. Erica encuentra entonces apoyo en Charlotte, madre de Sara, una niña de siete años que sufre el síndrome de deficiencia de atención cuando, de repente, se produce un drama totalmente inesperado. Un pescador encuentra el cadáver de la pequeña Sara, ahogada en el mar. Las autoridades piensan que se trata de un accidente, pero la autopsia revela que la pequeña fue ahogada en una bañera antes de ser arrojada al mar, y que alguien le hizo tragar cenizas.', v_228, 'EPUB/Las hijas del frío - Camilla Läckberg.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Destino de cazadora' AND Autor = 'Mari Mancusi') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Destino de cazadora', 'Mari Mancusi', 'Rayne McDonald lo tenía todo calculado: convertirse en vampiro, ser la compañera del líder del Círculo de Sangre y vivir la buena vida para toda la eternidad... pero el destino tenía otros planes para ella. De hecho, Rayne no solo sigue siendo humana, sino que se ha enterado de que es una cazavampiros. Tras ser reclutada por una organización secreta, a Rayne le asignan su primera misión: infiltrarse en un bar de mala reputación y desenmascarar a su propietario vampiro, un tal Maverick, por propagar a propósito un virus en la sangre. Por suerte, el Círculo de Sangre envía ayuda, personificada en un sensual vampiro llamado Jareth. ¿Serán capaces el vampiro y la cazadora de resolver sus diferencias y trabajar juntos para detener a Maverick?', v_187, 'EPUB/Destino de cazadora - Mari Mancusi.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '(Star Wars) Asi que quieres ser un jedi' AND Autor = 'Adam Gidwitz') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('(Star Wars) Asi que quieres ser un jedi', 'Adam Gidwitz', '3 años después de la batalla de Yavin. ¿ASÍ QUE QUIERES SER UN JEDI? Parece emocionante. Puedes mover objetos con la mente. Controlar a la gente con tus pensamientos. Ah, y los sables de luz. Sí, son impresionantes. Pero no todo es poder mental y linternas armadas. Ser un jedi requiere de mucho trabajo. Además, hay tipos malos, muchísimos. Y quieren matarte. ¿AÚN QUIERES SER UN JEDI? Aquí encontrarás la historia de uno de los más grandes jedi de todos los tiempos y un recuento del clásico filme Star Wars El Imperio contraataca. Pero no sólo eso. Sabrás cómo ser un jedi. Tal vez no necesites aprender a levitar o percibir tu alrededor con los ojos vendados. Tal vez no te interese escuchar una historia sobre sables de luz, criaturas de nieve asesinas y naves espaciales, pero quizá sí. Y tal vez, sólo tal vez, quieras aprender a ser un jedi. Bueno, en ese caso, este es el libro para ti. La decisión, mi joven amigo, está en tus manos. Literalmente.', v_189, 'EPUB/(Star Wars) Asi que quieres ser un jedi - Adam Gidwitz.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'No bajes al sótano' AND Autor = 'R.L. Stine') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('No bajes al sótano', 'R.L. Stine', NULL, v_42, 'EPUB/(Pesadilla N°5) No bajes al sótano - R.L. Stine.mobi', '.mobi', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'La villa de las telas' AND Autor = 'Anne Jacobs') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('La villa de las telas', 'Anne Jacobs', 'La villa de las telas abre de nuevo sus puertas. Llega la esperada cuarta parte de la saga superventas de Anne Jacobs. Una magnífica mansion Una época turbulenta Un amor que puede vencerlo todo... Augsburgo, 1930. Marie y Paul Melzer son felices y su amor es más fuerte que nunca. Su hijo menor, el pequeño Kurti, que ahora tiene cuatro años, es un rayo de sol que se gana el afecto de todo el mundo y los gemelos Dodo y Leo han crecido espléndidamente. Dodo ha descubierto su amor por la técnica y sueña con convertirse en aviadora, mientras que Leo demuestra un gran talento para el piano, que se ha convertido en su gran pasión. Pero la villa no es ajena a la agitada situación política en Alemania y la crisis económica golpea con fuerza el negocio familiar. Los Melzer tienen importantes deudas y Marie deberá enfrentarse a dolorosas decisiones para evitar la ruina. El destino de la familia está en juego. Y su amada villa de las telas solo podrá salvarse si todos permanecen unidos. Sobre los libros de la saga han dicho: «Amor imposible y las rígidas normas sociales de la Europa central a principios del siglo XX serán el escenario en el que se desenvuelva esta entretenida historia llena de secretos». Jorge Pato García, El Imparcial «Es una gran historia de amor, con tintes dramáticos y secretos familiares, que nos ha gustado tanto por su calidad literaria como por su preciosismo histórico». Revista Kritica «Downton Abbey en Augsburgo». Histo-couch «Este libro lo tiene todo, todo que podríamos desear para un día de lluvia: una gran historia de amor, intriga [...] y un gran secreto familiar». Delmenhorster Kreisblatt «Con su escritura fluida, Anne Jacobs sabe cómo seducir a sus lectoras y transportarlas a la vida de la alta sociedad de hace cien años con todo su glamour pero también con sus sombras». Weilheimer Tagblatt Los lectores opinan: «A todos los que os gustan las sagas familiares estos libros os van a encantar. De esos libros que tiene un ritmo muy bueno en todo momento, no decae para nada y hace su lectura muy agradable». Blog Leyendo entre páginas «Una historia de familias, de amor, de superación personal y de valentía. Pero de una valentía que no sabes que tienes hasta que la necesitas». Blog Viajando gracias a los libros «Si echáis de menos Downton Abbey (yo la echo de menos casi a diario) esta saga llenará ese hueco por completo». labibliotecadelaabuela en Instagram « Regreso a la Villa de las telas ha sido la vuelta a uno de mis lugares favoritos de la literatura». Patricia Llamas para Sigue en serie', v_54, 'EPUB/La villa de las telas - Anne Jacobs.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Los gritos del pasado' AND Autor = 'Camilla Läckberg') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Los gritos del pasado', 'Camilla Läckberg', 'La escritora Erika Falk y su compañero, el detective Patrik Hedström, disfrutan de unas merecidas vacaciones en su casa en la pequeña población costera de Fjällbacka que, en verano, es visitada por muchos turistas. Erika está embarazada de ocho meses y la ola de calor hace especialmente difícil este último mes de gestación. En esta situación, lo que menos falta le hace a la joven pareja es un nuevo caso de asesinato. Pero las vacaciones de Patrik se terminan de golpe, cuanto un niño descubre casualmente el cadáver de una joven turista. Lo más extraño es que junto al cadáver aparecen los restos de dos mujeres desaparecidas años atrás. Las autopsias demuestran que las tres víctimas murieron estranguladas y que además fueron torturadas.Basando el suspense en la acertada caracterización de los personajes, el realismo de sus comportamientos y una excelente ambientación, Camilla Läckberg vuelve a mantener al lector sin aliento hasta la última página y consigue meternos de lleno en la piel de los protagonistas.', v_228, 'EPUB/Los gritos del pasado - Camilla Läckberg.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El juramento de un libertino' AND Autor = 'Stephanie Laurens') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El juramento de un libertino', 'Stephanie Laurens', 'Vane Cynster siempre había sabido hacia dónde soplaba el viento: en dirección al matrimonio. Tal vez a los demás varones de la familia Cynster no les importase llegar al altar, pero Vane nunca quiso verse atado a ninguna mujer, por muy encantadora que fuera. Bellamy May le parecía el lugar perfecto para ocultarse durante un tiempo de las cazamaridos de Londres; pero cuando conoció a Patience Debbington comprendió que había encontrado la pareja ideal para él, y pronto nació en su mente algo más que el deseo de seducción.', v_220, 'EPUB/El juramento de un libertino - Stephanie Laurens.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'La ira y el amanecer' AND Autor = 'Renée Ahdieh') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('La ira y el amanecer', 'Renée Ahdieh', '«Cien vidas por la que tomasteis. Una vida por cada amanecer». En una tierra regida por un monstruoso califa, cada nuevo amanecer rompe el corazón de una familia. Día tras día, el rey contrae matrimonio con una joven que al alba es ejecutada. «Si falláis una sola vez, os arrebataré vuestros sueños, os arrebataré vuestra ciudad. Y os arrebataré estas vidas multiplicadas por mil». Por eso es un misterio cuando una desconocida se presenta voluntaria para casarse con él. Esa misma noche, ella le cuenta una historia. «Yo no estoy aquí para luchar. Estoy aquí para ganar». Y por primera vez, la aurora no llega teñida de rojo. «Os juro que viviré para ver todos los atardeceres posibles. Y que os mataré. Con mis propias manos».', v_41, 'EPUB/La ira y el amanecer - Renée Ahdieh.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '(Fjallbacka 08) La mirada de los ángeles' AND Autor = 'Camilla Lackberg') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('(Fjallbacka 08) La mirada de los ángeles', 'Camilla Lackberg', 'Cuando ya lo has perdido todo, puede que alguien quiera destruirte también a ti.Tras la muerte accidental de su hijo pequeño, Ebba y Mårten se trasladan a la isla de Valö para rehacer su vida. Ahí, se instalan en una granja en la que vivió la familia de Ebba hace muchos años. Pero la tragedia los sigue acechando, y un incendio, a todas luces provocado, saca a relucir la historia siniestra que pesa sobre la granja. Hace treinta años toda la familia de Ebba desapareció sin dejar rastro. Solo se salvó ella, entonces un bebé de un año, a quien encontraron sola en la casa. Desde ese momento, recibe una misteriosa felicitación el día de su cumpleaños, firmada con una simple G…Patrik abre una investigación, y Erica, siempre en busca de material narrativo, empieza a tirar del hilo de la historia de la granja por su cuenta. Un acto impulsivo de Anna, la hermana de Erica, aún afectada por la pérdida del bebé que esperaba, revelará la verdad de golpe.', v_39, 'EPUB/(Fjallbacka 08) La mirada de los ángeles - Camilla Lackberg.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Mi suerte eres tú' AND Autor = 'Kate Danon') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Mi suerte eres tú', 'Kate Danon', '<div>
<p style="font-size: 14px; font-family: ''Amazon Ember'',''Arial'',''sans-serif''"><span style="color: #333333; background-color: #ffffff">Los sueños a veces se hacen realidad. Sin embargo, en ocasiones, se vuelven pesadillas. Jennifer Morrison lo descubrió cuando emigró a California en busca de un marido y se encontró con un demonio que transformó su vida en un infierno. Ahora, tras enviudar, su existencia en Loan''s Valley se ha convertido en una rutina solitaria que carece de cualquier aliciente. Pero está a salvo y ya nadie la maltrata. No volverán a hacerle daño, porque ha blindado su corazón y no piensa volver a enamorarse nunca más... Hasta que Nat Hardei, un itinerante jugador de póker, llega a Loan''s Valley desplegando su encanto canalla y sus modales elegantes, tan distintos al del resto de los vaqueros del lugar. El recién llegado despierta en ella sentimientos olvidados y tendrá que luchar con todas sus fuerzas para no dejarse engatusar por ese conquistador nato. Un hombre que disfruta de su libertad y que vive cada momento dejándose llevar, sin pensar en las consecuencias. Un hombre que no le conviene en absoluto, que lleva la fiebre del juego en las venas y que nunca se queda mucho tiempo en un mismo lugar. Sin embargo, el destino es caprichoso y logra que Nat y Jenny se embarquen juntos en una aventura inesperada que pondrá a prueba sus mutuas convicciones. </span><strong style="color: #333333; background-color: #ffffff">Ella descubrirá que estar a salvo no es lo mismo que estar viva, y él se dará cuenta de que, a veces, la mejor manera de ganar la partida más importante, es guardar bajo la manga un as de corazones.</strong></p></div>', v_86, 'EPUB/Mi suerte eres tú - Kate Danon.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Las luces de septiembre' AND Autor = 'Carlos Ruiz Zafón') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Las luces de septiembre', 'Carlos Ruiz Zafón', 'Un misterioso fabricante de juguetes vive recluido en una mansión gigantesca poblada de seres mecánicos y sombras del pasado. Un enigma en torno a las extrañas luces que brillan entre la niebla que rodea el islote del faro. Una criatura de pesadilla que se oculta en la profundidad del bosque. Estos y otros elementos tejen la trama del misterio que unirá a Irene e Ismael para siempre durante un mágico verano en Bahía Azul.', v_170, 'EPUB/Las luces de septiembre - Carlos Ruiz Zafón.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '(Fjallbacka 05) Las huellas imborrables' AND Autor = 'Camilla Lackberg') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('(Fjallbacka 05) Las huellas imborrables', 'Camilla Lackberg', 'El secreto de una joven en los años cuarenta. Un nuevo caso trepidante de Erica Falck y Patrik Hedström. El verano llega a su fin y la escritora Erica Falck vuelve al trabajo tras la baja de maternidad. Ahora le toca a su compañero, el comisario Patrik Hedström, tomarse un tiempo libre para ocuparse de la pequeña Maja. Pero el crimen no descansa nunca, ni siquiera en la tranquila ciudad de Fjällbacka, y cuando dos adolescentes descubren el cadáver de Erik Frankel, Patrik compaginará el cuidado de su hija con su interés por el asesinato de este historiador especializado en la Segunda Guerra Mundial. Mientras tanto, Erica hace un sorprendente hallazgo: diarios de su madre Elsy, con quien tuvo una relación difícil, junto con una antigua medalla nazi. Pero lo más inquietante es que, poco antes de la muerte del historiador, Erica había ido a su casa para obtener más información sobre la medalla. ¿Es posible que su visita desencadenara los acontecimientos que condujeron a su muerte? En «Las huellas imborrables» Camilla Läckberg entreteje con maestría una historia contemporánea con la vida de una joven en la Suecia de 1940. Escrita con numerosos «flashbacks», en esta novela Erica Falck debe adentrarse en el oscuro pasado de su propia familia.', v_39, 'EPUB/(Fjallbacka 05) Las huellas imborrables - Camilla Lackberg.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Batir de alas' AND Autor = 'Paul Hoffman') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Batir de alas', 'Paul Hoffman', 'Thomas Cale ha estado huyendo de la verdad. Desde que descubrió que su brutal formación militar obedecía a un solo propósito —la destrucción del mayor error divino, la humanidad. Cale vive bajo la amenaza fantasmal del hombre que le convirtió en Ángel de la Muerte: el papa redentor Bosco. Pero Cale no ha dicho todavía su última palabra: la suerte de la humanidad está en sus manos.', v_112, 'EPUB/Batir de alas - Paul Hoffman.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Te veré bajo el hielo' AND Autor = 'Robert Bryndza') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Te veré bajo el hielo', 'Robert Bryndza', 'Su cuerpo está congelado. Sus ojos cerrados han visto la muerte. Sus labios parecen estar a punto de decirnos algo. El thriller que ha sorprendido a más de 1.000.000 de lectores. Un joven descubre el cadáver de una chica debajo de una gruesa capa de hielo en un parque del sur de Londres. La detective Erika Foster será la encargada de dirigir la investigación del caso, mientras lucha contra sus propios demonios personales. Cuando Erika comienza a indagar en el pasado de la víctima, todo parece apuntar que su asesinato está conectado con el homicidio de otras tres mujeres que han sido encontradas con signos de estrangulación, las manos atadas y, sospechosamente, también bajo las aguas congeladas de otros lagos en Londres. Poco a poco, Erika se aproxima a la verdad, sin sospechar que el asesino quizá también la observa y se acerca cada vez más a ella. Reseñas: «Ha nacido una nueva detective estrella.» La Razón «Un excelente modelo o ejemplo de novela negra, negrísima y muy actual.» Juan Bolea, El Periódico de Aragón «Todo un fenómeno mundial en lo que al thriller británico se refiere.» Laura Fernández, El Mundo «Leí de un tirón Te veré bajo el hielo. Y lo hice con esa gratificación que dejan los libros muy bien construidos.» J. Ernesto Ayala-DIP, El Correo «Un thriller sorprendente, ameno, que se "devora" sin respiro.» Quelibroleo «Una historia de bajos fondos y alta sociedad con pulso de gran thriller.» Cultura|s de La Vanguardia «El amplio abanico de posibles sospechosos, los constantes giros y, sobre todo, el buen ritmo que mantiene Robert Bryndza, hacen que la lectura sea amena, intrigante y altamente recomendable.» Revista Krítica «Las aventuras de una detective de origen eslovaco y con un carácter de hierro.» El Periodico / EFE «Todo lo que se le pide a una novela de este género: Trama trepidante, intriga hasta el desenlace, ritmo frenético, grandes personajes y un final impactante.» Carmen en su tinta «Una gran trama que apela a lo más profundo de la naturaleza humana.» Book Lover «Lleno de pistas inteligentes y de giros. Mantiene al lector cautivado hasta la última página.» The Book Review Café «Un thriller que te mantendrá en vilo toda la noche.» Booked: The Crime Fiction Club «Una novela adictiva y compulsiva.» For the Love of Books «Una lectura que atrapa, con un final totalmente sorprendente. Absolutamente necesaria para todos los fans de la novela criminal.» The Letter Book Reviews', v_47, 'EPUB/Te veré bajo el hielo - Robert Bryndza.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Un amor secreto' AND Autor = 'Stephanie Laurens') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Un amor secreto', 'Stephanie Laurens', 'En el Londres de la Regencia, todos saben que ninguno de los Cynster abandonaría a una dama en problemas& Pero su protección puede tener un alto y muy seductor precio para la dama en cuestión. Cuando una mujer misteriosa, con el rostro oculto por un velo negro, le ruega a Gabriel Cynster que la ayude, él no puede resistirse. A cambio, sin embargo, le exige algo que sólo un Cynster podría pedir: por cada dato que él le aporte ella debe pagarle con un beso. Lady Alathea Morwellan sabe que Gabriel está intrigado. A pesar de la inocultable atracción que los une, nunca lograron estar juntos sin reñir. Por otra parte, cuantas más cosas están en juego, más crece el deseo de Gabriel por obtener su pago, y cada beso embriagador, cada brazo apasionado, aleja para Alathea la posibilidad de resistir la seducción final... Pero ¿qué pasará cuando ella le revele la verdad que tan celosamente le oculta?', v_220, 'EPUB/Un amor secreto - Stephanie Laurens.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'La guerra de los cielos: Volumen IV' AND Autor = 'Fernando Trujillo Sanz') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('La guerra de los cielos: Volumen IV', 'Fernando Trujillo Sanz', 'La guerra más antigua y devastadora de la existencia ha encontrado el modo de continuar, de extenderse por toda la creación. El Cielo y el Infierno ya no son los únicos escenarios para este terrible conflicto.Comenzó cuando el planeta se estremeció. Todos los habitantes perdieron la facultad de moverse, quedando resignados a contemplar impotentes cómo todo su mundo se desmoronaba. Al fenómeno lo llamaron la Onda y produjo cambios más allá de la comprensión humana. Después de aquello nada volvió a ser lo mismo para ninguno de nosotros.Ahora tenemos que sobrevivir a las consecuencias. Los ángeles y los demonios están entre nosotros, son reales, y nos han impuesto su guerra. Una guerra en la que somos insignificantes, una guerra que no creímos posible y que cambiará nuestras vidas para siempre.', v_128, 'EPUB/La guerra de los cielos - Volumen IV - Fernando Trujillo Sanz.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'S.E.C.R.E.T. 2 - Secretos compartidos' AND Autor = 'L. Marie Adeline') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('S.E.C.R.E.T. 2 - Secretos compartidos', 'L. Marie Adeline', NULL, v_192, 'EPUB/S.E.C.R.E.T. 2 - Secretos compartidos - L. Marie Adeline.mobi', '.mobi', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Witch Heart' AND Autor = 'Anya Bast') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Witch Heart', 'Anya Bast', 'Third in the Elemental Witch series from the national bestselling author View our feature on Anya Bast’s Witch Heart. Claire, a demon’s handmaiden, is rescued from enslavement by a handsome playboy. Now they’re both in danger of being captured by warlocks who are determined to harness Claire’s powers for evil.', v_42, 'EPUB/Witch Heart - Anya Bast.epub', '.epub', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'La hermana perla' AND Autor = 'Lucinda Riley') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('La hermana perla', 'Lucinda Riley', '<span itemprop="description"><b>Subtitulado: La historia de Cece.</b><br>
<br>
CeCe D’Aplièse nunca ha encajado en ningún lugar. Tras la muerte de su
padre, el misterioso multimillonario Pa Salt, que adoptó a las seis
hermanas desde distintas partes del mundo, se encuentra en una
encrucijada: ha dejado la escuela de arte y su hermana Star se distancia
 de ella para perseguir su sueño.<br>
A la desesperada decide huir de Londres y descubrir su pasado. Las
únicas pistas que tiene son una fotografía y el nombre de una mujer
pionera que vivió en Australia hace un siglo.<br>
De camino hacia Sidney hace parada en el único lugar donde se ha sentido
 ella misma: las playas de Krabi en Tailandia, donde conoce al
misterioso Ace.<br>
Cien años antes Kitty McBride, hija de un reverendo de Edimburgo, viaja a
 Australia como dama de compañía de la acaudalada señora McCrombie. En
Adelaida su destino se ve unido a la rica familia, incluidos los
idénticos aunque muy diferentes gemelos, el impetuoso Drummond y el
ambicioso Andrew, heredero de una fortuna en la industria de la perla.</span>', v_89, 'EPUB/La hermana perla - Lucinda Riley.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'La llamada de las sombras' AND Autor = 'Karen Chance') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('La llamada de las sombras', 'Karen Chance', 'Un legado reciente convirtió a Cassandra Palmer en heredera del título de pitia, la vidente más poderosa del mundo. Normalmente, el puesto se consigue después de años de entrenamiento, pero las circunstancias que rodean a Cassie son un tanto anormales. Ahora, Cassie se ve atrapada en una situación en la que dispone de una cantidad ingente de poder que los vampiros, duendes y magos de la ciudad quieren monopolizar o erradicar a toda costa… y que ella misma no se atreve a usar. Es más, Cassandra acaba de descubrir que cierto maestro vampiro un tanto arrogante le ha lanzado un hechizo mágico que advierte a cualquier posible pretendiente para que no se acerque a ella... y que podría explicar la incomprensible atracción que existe entre ellos.', v_167, 'EPUB/La llamada de las sombras - Karen Chance.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Cucarachas' AND Autor = 'Jo Nesbø') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Cucarachas', 'Jo Nesbø', 'El embajador noruego aparece asesinado en un burdel de Bangkok. El embajador mantenía relaciones muy cercanas con el primer ministro noruego. En Oslo, para evitar el escándalo, tratan de desviar la atención hacia el ministro de Asuntos Exteriores… Harry Hole, alcoholizado y adicto a la vitamina B12, llega a Bangkok con instrucciones claras: silenciar el caso. ¿Será necesario ocultar pruebas? Harry descubre que el caso esconde otras tramas siniestras: se trata de un asesinato mucho más complejo de lo que a priori parecía. Inmerso en el ruido y el tráfico de una ciudad multitudinaria, Harry recorre las calles de un Bangkok lleno de bares de alterne, templos, fumadores de opio, trampas para turistas… Harry trata de encontrar la clave del asesinato del embajador, aunque nadie se lo ha pedido. Y nadie le quiere cerca, ni siquiera él mismo…', v_102, 'EPUB/Cucarachas - Jo Nesbø.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '(Fjallbacka 01) La princesa de hielo ' AND Autor = 'Camilla Lackberg') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('(Fjallbacka 01) La princesa de hielo ', 'Camilla Lackberg', 'En un pueblo que esconde muchos secretos es peligroso saber la verdad. Se llamaba Alexandra, era joven, rica y guapa, y nadie en el pueblo se puede explicar su muerte. Por pura casualidad, Erica, amiga de la infancia y autora de biografías, se ve involucrada en el caso. Había regresado a su pueblo natal para hacerse cargo de la casa que acababa de heredar de sus padres, recientemente fallecidos en un accidente, y para trabajar en su próximo libro. Cuando la familia de Alex le pide que escriba un recordatorio para el funeral, Erica, todavía conmocionada por la repentina muerte de su amiga, comienza a investigar la vida de la víctima. Con la ayuda del comisario Patrik, otro viejo conocido que pronto se convertirá en algo más que un amigo, descubre un oscuro secreto, largamente guardado. Alguien conoció a Alex desde su infancia y le preparó un helado lecho mortuorio. Camilla Läckberg dibuja finamente el retrato de la sociedad cerrada de una pequeña ciudad, en la que todos lo saben todo de todo el mundo, pero en la cual las apariencias son fundamentales.', v_39, 'EPUB/(Fjallbacka 01) La princesa de hielo - Camilla Lackberg.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Innovación docente en didáctica de la lengua y la literatura: teoría e investigación' AND Autor = 'Pilar Núñez Delgado, Irene Alonso Aparicio') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Innovación docente en didáctica de la lengua y la literatura: teoría e investigación', 'Pilar Núñez Delgado, Irene Alonso Aparicio', 'El libro recoge varias aportaciones surgidas de un proyecto de innovación de la docencia universitaria desarrollado en la Universidad de Granada. El principal propósito de este ha sido dar a conocer —en el plano teórico y principalmente en la práctica— a los estudiantes de los grados de Maestro de Educación Infantil y de Maestro de Educación Primaria estrategias metodológicas adecuadas para el desarrollo de la competencia comunicativa y literaria de los escolares, dado que el ámbito de innovación que parece más rentable para lograr tales metas es, sin duda, el de la metodología. Esta metodología, entendida como el conjunto de criterios y decisiones que organiza la acción didáctica y que define el estilo educativo del docente, lejos de ser un elemento menor, es la clave para la implementación del necesario cambio que contribuya a desterrar el gramaticalismo y el historicismo que aún imperan en nuestras aulas. Los trabajos aquí compilados pueden ser útiles, por una parte, tanto para los docentes en ejercicio como para los que se preparan para serlo, especialmente para los de lengua y literatura. Además, también pueden guiar a profesores universitarios que forman a futuros docentes.', v_91, 'EPUB/Innovación docente en didáctica de la lengua y la literatura - teoría e investigación - Pilar Núñez Delgado, Irene Alonso Aparicio.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El tiempo suficiente' AND Autor = 'Amara Castro Cid') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El tiempo suficiente', 'Amara Castro Cid', '<div>
<p style="font-family: ''Amazon Ember'',''Arial'',''sans-serif''; font-size: 14px"><span style="color: #000000">Las hermanas Telma y Celia viven en Vigo. Telma es una enfermera que se preocupa por sus pacientes y que presta especial atención a un anciano llamado Pío. Celia, dos años más joven, acaba de ascender a jefa de departamento en su empresa, pero no se siente a gusto en la compañía. Las comidas de los miércoles en casa de su abuela Gala, un importante referente para las hermanas, son lo más sagrado para las tres. Cuando la abuela fallece, las hermanas leen juntas las memorias que les ha dejado y descubren muchos detalles que desconocían de Gala, una mujer fuerte que perdió a su primer marido y su gran amor cuando su hija, Amparo, tenía tan solo dos años. Afortunadamente, volvió a encontrar la felicidad al lado de su segundo marido, Rodrigo, el abuelo que conocieron las dos hermanas.</span></p></div>', v_42, 'EPUB/El tiempo suficiente - Amara Castro Cid.epub', '.epub', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Hambre' AND Autor = 'Roxane Gay') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Hambre', 'Roxane Gay', '<div>
<p>En sus tremendamente populares ensayos y en su blog de Tumblr, Roxane Gay ha escrito con intimidad y sensibilidad sobre la comida y el cuerpo, usando sus propias luchas emocionales y psicológicas como una forma de explorar nuestras ansiedades compartidas sobre el placer, el consumo, la apariencia y la salud.<br>Como mujer que describe su propio cuerpo como "salvajemente indisciplinado", Roxane comprende la tensión entre el deseo y la negación, entre el confort con uno misma y cuidarse.<br>En <em>Hambre</em> explora su pasado, incluido el devastador acto de violencia que supuso un punto de inflexión en su joven vida, y acerca a los lectores en su viaje para comprender y finalmente salvarse a sí misma.</p></div>', v_42, 'EPUB/Hambre - Roxane Gay.epub', '.epub', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Promesas en la oscuridad' AND Autor = 'Sadie Matthews') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Promesas en la oscuridad', 'Sadie Matthews', 'Déjate llevar por el corazón... ¿Se puede salvar un amor que ha sufrido una profunda fractura? Separarme de Dominic me había dejado mucho más hundida de lo que nunca me pude imaginar. Me tenía en sus manos en cuerpo y alma, pero un malentendido hizo que todo saltara en pedazos. El dolor y la tristeza me persiguen como un a sombra y me resulta imposible darle sentido a mi vida. Un momento con él y la sangre me hierve de nuevo, su contacto enciende un fuego que mi cuerpo se ha negado a olvidar. Estoy perdida, indefensa ante Dominic. Encontrar la forma de recuperar lo que fuimos va a exigirnos mucha confianza y tener fe el uno en el otro. Sólo así sabremos si existe la posibilidad de que lo que hay entre nosotros dure para siempre. Intensidad, sensualidad y seducción? Todas estas sensaciones esperan en esta parte final de la excitante trilogía romántica que ha cautivado a miles de lectores en todo el mundo.', v_153, 'EPUB/Promesas en la oscuridad - Sadie Matthews.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Vengo a matarle' AND Autor = 'W. Martyn') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Vengo a matarle', 'W. Martyn', 'Un jinete a todo galope entró en la polvorienta calzada que formaba la mejor calle de Fontenelle, en Wyoming, casi en las márgenes del Green River y detuvo el caballo frente a una de las tabernas de la calle. Se apeó casi antes de que el animal detuviese su loca carrera y penetró en el establecimiento preguntando: — ¿Está mi patrón? —Está ahí dentro, en el reservado. El peón cruzó el pasillo y empujó una puerta penetrando en el reservado, donde ante una botella con dos vasos, uno de ellos vacío, se encontraba el patrón por quien el jinete preguntaba. Se trataba de un hombre que aún no habría cumplido los cuarenta años. Era alto, bien proporcionado, guapo y de facciones enérgicas. Tenía un cigarrillo entre los morenos dedos y un vaso a medio llenar en el borde de la mesa. Vestía con bastante elegancia, acusando el traje su posición acomodada. Era un ranchero de la localidad llamado Babe Lucien. El peón, un poco agitado, exclamó: —Patrón, Tiger viene hacia aquí… ¿Manda usted algo? —Nada, puedes marcharte. — ¿No… me… necesitará…?', v_212, 'EPUB/Vengo a matarle - W. Martyn.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Huye' AND Autor = 'Lisa McMann') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Huye', 'Lisa McMann', 'Por primera vez en años, Janie se va de vacaciones. Está pasando unos días en la cabaña del lago que tiene el hermano de Cabe, lejos de su madre alcohólica y del revuelo que ha causado en el pueblo la revelación de que ella trabaja para la policía. Por suerte, ya puede dejar de esconder su relación con Cabe y el año que viene comienza la universidad, lejos del pueblo. Por desgracia sus poderes le evitan llevar una vida normal, y tras un par de incidentes con sueños en los que Cabe no reacciona como ella espera, Janie comienza a tener dudas. Pero todo deja de tener importancia cuando Janie recibe una llamada de Carrie en la que su amiga le informa que ha tenido que llevar a su madre al hospital. Janie y Cabe vuelven corriendo para descubrir que no es la madre de Janie la que está ingresada, si no su padre, al que Janie jamás conoció ya que abandonó a su madre antes de que ella naciera. El padre está en coma, y la única persona que aparece en los papeles médicos que hay en su casa es su madre, que no quiere saber nada del tema. Sospecha que su padre podría ser como ella y tener la habilidad de entrar en los sueños de los demás, así que comienza a investigar su vida y su pasado para intentar descifrar su propio futuro.', v_168, 'EPUB/Huye - Lisa McMann.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Un conde sin corazón' AND Autor = 'Nuria Rivera') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Un conde sin corazón', 'Nuria Rivera', '<p>Para encontrar el amor… ¿será necesario convertirse en una dama?</p> <p>Algunas reglas están para romperlas.</p> <p>&nbsp;</p> <p>Para retrasar la decisión paterna de un matrimonio concertado, <i xml:lang="en">lady</i> Rose Mary Lowell ingresa en la Escuela de Señoritas de lady Acton, en Minstrel Valley, para convertirse en una Dama Selecta y enfrentarse a su destino: un matrimonio sin amor. Allí, su solitaria y triste existencia, se llena de amistad y camaradería; aunque la melancolía que a veces la consume, y una noticia que temía, la lleva a un acto desesperado.</p> <p>El nuevo conde de McEwan, Richard Bellamy, se formó como médico porque no iba a heredar un título, pero la muerte de su hermano trastoca sus planes. Si algo tiene claro es que jamás entregará su corazón, sencillamente porque no tiene. La invitación de su tía a visitarla le sirve de excusa para alejarse de esa vida que lo aburre y busca refugiarse en el pueblo donde encontró sosiego tras la muerte de su padre.</p> <p>La casualidad hace que sea testigo de la acción desolada de una joven y se lance a ayudarla. Conocer a la ninfa a la que salvó acrecentará su deseo y es que desde el momento en que la tuvo entre sus brazos se propuso seducirla y poseerla, sin pensar en el riesgo que eso supondría.</p> <p>Rose está resignada a su destino, aunque la intensa seducción que le ofrece el nuevo conde de McEwan le hará olvidar algunas reglas para ser una dama. ¿Será capaz de no entregar su corazón a alguien que no tiene y casarse con otro?</p>', v_88, 'EPUB/Un conde sin corazón - Nuria Rivera.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Una sombra en la oscuridad (Serie Erika Foster) (Spanish Edition)' AND Autor = 'Robert Bryndza') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Una sombra en la oscuridad (Serie Erika Foster) (Spanish Edition)', 'Robert Bryndza', 'En el ocaso de una sofocante noche de calor, la detective Erika Foster recibe una llamada para asistir a la escena de un crimen. La víctima es hallada asfixiada en su cama. Sus muñecas están atadas y se perciben sus abultados ojos a través de una bolsa de plástico atada por encima de su cabeza. Pocos días después, otra víctima es encontrada muerta; la escena del crimen es exactamente igual. Mientras Erika Foster y su equipo comienzan a profundizar en la investigación, pronto descubren que se enfrentan a un calculador asesino en serie que acecha a sus víctimas antes de elegir el momento más oportuno para atacarlas. Todas las víctimas son hombres solteros, con vidas privadas muy alejadas del foco público. ¿Por qué sus pasados están envueltos en tantos secretos? Y sobre todo, ¿qué es lo que les unía a cada uno de ellos con el asesino?', v_35, 'EPUB/Una sombra en la oscuridad (Serie Erika Foster) (Spanish Edition) - Robert Bryndza.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Artemis Fowl: Encuentro en el ártico' AND Autor = 'Eoin Colfer') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Artemis Fowl: Encuentro en el ártico', 'Eoin Colfer', '¿Todavía sigues ahí? A estas alturas, ya sabes que no soy una persona —por favor, lo de niño dejémoslo para los adultos ignorantes— normal. Después de conseguir el oro que necesitaba, tenía otra prioridad: rescatar a mi padre, secuestrado en algún lugar del frío Antártico. No fue fácil, pero pude chantajear al mundo subterráneo para que me ayudaran porque, como decimos los humanos, ''En todas partes cuecen habas'' y ellos no lo están pasando demasiado bien: así que hicimos un pacto de caballeros…', @Cat_FantsticoJuvenil, 'EPUB/Artemis Fowl Encuentro en el ártico - Eoin Colfer.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'La sombra del minotauro' AND Autor = 'Antonio Lozano') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('La sombra del minotauro', 'Antonio Lozano', 'Las Palmas de Gran Canaria. En su despacho, el detective José García Gago recibe la visita de María Elena y José Miguel Bravo, hijos de un acaudalado empresario de edad avanzada, que ven peligrar su herencia próxima y sustanciosa por la relación que su padre mantiene con una joven dominicana. El asesinato de ésta convertirá sin embargo lo que parecía una investigación anodina en una rocambolesca historia que obligará al detective a asociarse al inspector Márquez, y que conducirá a ambos a través de los laberintos de la actividad mafiosa de la isla, con el análisis satírico de la doble moral de una burguesía rancia y trasnochada como telón de fondo. Una trama en la mejor tradición del género negro sobre la que, permanentemente, planea la sombra del Minotauro. Y, tal vez, la mejor novela de Antonio Lozano, que fuera ganador de la primera edición del Premio Internacional de Novela Negra Ciudad de Carmona por su celebrada y memorable “El caso Sankara”. ''Antonio Lozano es uno de los mejores narradores del género negro en español. No en vano fue apadrinado en sus comienzos por el mismísimo Vázquez Montalbán''. Rogelio Dueñas', v_228, 'EPUB/La sombra del minotauro - Antonio Lozano.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Secretos En La Oscuridad' AND Autor = 'Sadie Matthews') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Secretos En La Oscuridad', 'Sadie Matthews', '<p class="description">Enamorarme de Dominic me cambió como persona. Renuncié totalmente a lo que era antes y le entregué mi corazón y mi confianza, pero en un momento exquisito y a la vez terrible, él perdió el control. Angustiado por lo que había hecho, decidió encerrar sus deseos oscuros en lo más profundo de su ser.Ahora Dominic no es el único que necesita desesperadamente ese juego de seducción que implica caminar por el filo de la pasión, entre el dolor y el placer, el desenfreno y la liberación. Persuadir a Dominic para que deje salir esa parte tan íntima de sí mismo va a suponer el mayor riesgo que he corrido en mi vida, pero no puedo evitarlo. Aunque eso signifique que no volvamos a estar juntos nunca más.Provocativa y sofisticada, emocionante y seductora,''Secretos en la oscuridad''te llevará de la mano de Beth y Dominic por caminos que nunca imaginaste, por placeres cautivadores que siempre soñaste. Te acercará un paso más al filo agridulce de la pasión.</p>', v_126, 'EPUB/Secretos En La Oscuridad - Sadie Matthews.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '(Fjallbacka 09) El domador de leones' AND Autor = 'Camilla Lackberg') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('(Fjallbacka 09) El domador de leones', 'Camilla Lackberg', 'En ocasiones, el mal puede ser aún más poderoso que el amor. Una tragedia familiar no resuelta reabre varios casos en el presente. Estamos en pleno mes de enero y en Fjällbacka hace un frío polar. Una joven medio desnuda deambula por el bosque nevado y llega a la carretera. Un coche aparece de la nada y no tiene tiempo de esquivarla. Cuando el comisario Patrik Hedström y su equipo reciben la alarma sobre el accidente, la chica ya ha sido identificada. Desapareció cuatro meses atrás y desde entonces no se ha sabido nada de ella. Su cuerpo tiene marcas de atrocidades inimaginables, y es posible que no sea la única, ni la última víctima de su agresor. Al mismo tiempo, Erica Falck investiga una vieja tragedia familiar que acabó con la muerte de un hombre. Erica sospecha que su esposa oculta algo terrible y teme que el pasado proyecte su alargada sombra sobre el presente.', v_39, 'EPUB/(Fjallbacka 09) El domador de leones - Camilla Lackberg.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'La estrella del diablo' AND Autor = 'Jo Nesbø') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('La estrella del diablo', 'Jo Nesbø', 'Es un verano excepcionalmente caluroso en Oslo. El cuerpo de una joven aparece en el suelo de su apartamento, en medio de un charco de sangre. Tiene amputado un dedo de la mano izquierda, y bajo un párpado le han colocado un pequeño diamante rojo con la forma de una estrella de cinco puntas: el emblema del diablo. Cinco días después, un hombre denuncia la desaparición de su esposa. Otro dedo cercenado aparece en escena: lleva un anillo con un diamante rojo engarzado, tallado como una estrella de cinco puntas. A los cinco días aparece el tercer cadáver… y se repite el ritual.Harry Hole es un policía poco convencional. El alcohol y una situación personal muy complicada le han hecho tocar fondo. Los demonios reales y los imaginarios se mezclan en la mente Hole, que se tiene que enfrentar a un criminal sanguinario y a un enemigo implacable dentro del departamento.', v_139, 'EPUB/La estrella del diablo - Jo Nesbø.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Teme' AND Autor = 'Lisa McMann') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Teme', 'Lisa McMann', 'Para Janie y Cabel la vida real se está poniendo mucho más difícil que los sueños. Ambos están tratando conseguir un poco de tiempo para poder estar juntos (en secreto) pero no están teniendo suerte. Y, por si fuera poco, algo extraño está pasando en el instituto Fieldridge, aunque nadie se atreve a hablar sobre ello. Cuando Janie entra en las violentas pesadillas de una compañera de clase, todo empieza a tener sentido, pero nada sale como lo habían planeado. Ni mucho menos. Janie siente que las cosas no van bien en su cabeza y el escandaloso comportamiento de Cabe tiene grave consecuencias para ambos. Y lo que es peor aún, Janie ha descubierto toda la verdad sobre sí misma y su especial habilidad. Y es una verdad desoladora y brutal, que no solo sella su destino como Cazadora de Sueños sino que hace que lo que está por venir sea más oscuro de lo que jamás se hubiera podido imaginar. ¿Crees que estás solo en tus sueños? No es cierto, no si yo estoy cerca. No es tu voluntad ni la mía sino una especie de maldición de la que no puedo escapar. Nadie puede ayudarme. Al menos eso pensaba hasta que Cabel llegó a mi vida. No estoy segura de quién es, no sé si puedo confiar en él, pero para mi corazón es demasiado tarde.Para Janie y Cabel la vida real se está poniendo mucho más difícil que los sueños. Ambos están tratando conseguir un poco de tiempo para poder estar juntos (en secreto) pero no están teniendo suerte. Y, por si fuera poco, algo extraño está pasando en el instituto Fieldridge, aunque nadie se atreve a hablar sobre ello. Cuando Janie entra en las violentas pesadillas de una compañera de clase, todo empieza a tener sentido, pero nada sale como lo habían planeado. Ni mucho menos. Janie siente que las cosas no van bien en su cabeza y el escandaloso comportamiento de Cabe tiene grave consecuencias para ambos. Y lo que es peor aún, Janie ha descubierto toda la verdad sobre sí misma y su especial habilidad. Y es una verdad desoladora y brutal, que no solo sella su destino como Cazadora de Sueños sino que hace que lo que está por venir sea más oscuro de lo que jamás se hubiera podido imaginar. ¿Crees que estás solo en tus sueños? No es cierto, no si yo estoy cerca. No es tu voluntad ni la mía sino una especie de maldición de la que no puedo escapar. Nadie puede ayudarme. Al menos eso pensaba hasta que Cabel llegó a mi vida. No estoy segura de quién es, no sé si puedo confiar en él, pero para mi corazón es demasiado tarde.', v_168, 'EPUB/Teme - Lisa McMann.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Calle Dublín' AND Autor = 'Samantha Young') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Calle Dublín', 'Samantha Young', 'Cuatro años atrás, Jocelyn Butler dijo adiós a su trágico pasado en Estados Unidos para empezar una nueva vida en Edimburgo. Pero cuando se muda a un apartamento en Dublin Street y conoce al hermano mayor de su compañera de piso, todo cuanto ha intentado proteger se ve sacudido hasta lo más profundo. Braden Carmichael es un hombre que siempre consigue lo que quiere, y ahora la quiere a ella. Sabedor de que Jocelyn ha renunciado a establecer cualquier clase de relación, le propone dar rienda suelta a la intensa atracción que siente el uno por el otro, sin dejar que la relación vaya más allá del sexo. Jocelyn acepta, sin imaginar que el atractivo escocés se enamorará de ella sin remedio.', v_37, 'EPUB/Calle Dublín - Samantha Young.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '3.096 días' AND Autor = 'Natascha Kampusch') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('3.096 días', 'Natascha Kampusch', 'Natascha Kampusch no era una niña feliz: su infancia había estado marcada por unos padres inmaduros y por un omnipresente sentimiento de inseguridad. El 2 de marzo de 1998, Natascha, que tenía por aquel entonces diez años, se dirigía a la escuela, sola por primera vez. Era un auténtico desafío para ella, una manera de demostrarse, a ella y a su madre, con la que se había enfadado la noche antes y de la que no se había despedido, que ya era una niña mayor. Apenas llevaba andados unos pocos metros cuando vio a un hombre junto a una furgoneta. No recordaba haberlo visto antes. Era Wolfgang Priklopil, y con él iba a pasar en cautiverio los siguientes ocho años de su vida.
A partir de aquel día todo cambiaría en la vida de Natascha. Su mundo se vería reducido primero a un zulo de cinco metros cuadrados y posteriormente a toda una serie de maltratos físicos y psicológicos que acabarían por anular su personalidad. Sin embargo, algo permaneció inmutable en su interior: la fortaleza y la madurez que se había visto obligada a desarrollar en su niñez la habían preparado, de algún modo, para sobrevivir a aquella tortura diaria. Y así es como, siendo aún una niña, se hizo una valiente promesa a sí misma: cuando cumpliera la mayoría de edad, escaparía...
El presente libro es el relato de aquel largo cautiverio, el más largo que haya vivido una menor en Europa. 3.096 días marcados por el miedo, el desconcierto, el dolor y la humillación, pero también, y no en menor medida, por la lucha, la esperanza y la superación, las mismas que permitirían a su joven protagonista obtener la libertad y contar al mundo su historia.', v_42, 'EPUB/3.096 días - Natascha Kampusch.epub', '.epub', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Reina' AND Autor = 'Fernández, Bebi') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Reina', 'Fernández, Bebi', 'Reina, el esperado desenlace de Memorias de una salvaje, es más que un thriller. Es un desafío a toda la sociedad. España, año 2020. La vida de Kassandra Fernández transcurre entre libros e intentos por superar su pasado, pero todo se tambalea cuando su mayor enemigo hace acto de presencia de la peor forma posible, dando lugar a una cruenta guerra fría donde la estrategia, los negocios criminales y los límites entre el bien y el mal se difuminan, y en la cual la protagonista se debatirá internamente entre la venganza y la justicia, librando también una batalla interna donde tendrá que averiguar quién es en realidad. Mientras todo ocurre, el amor y la amistad parecen ser más difíciles de comprender que nunca. Abrir el cajón donde guardaba las piezas de ajedrez no será fácil, pero Kassandra Fernández ya no es solo una joven valiente y necesitada de conocer su destino, sino una salvaje mujer dispuesta a ganar la partida —o quizás no. Reina, el esperado desenlace de Memorias de una salvaje, es más que un thriller. Es un desafío a toda la sociedad. Bebi Fernández, el despertar de una generación SALVAJE. Más de 200.000 lectores.', v_42, 'EPUB/Reina - Fernández, Bebi.epub', '.epub', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Neïra - Siete citas para Valentina' AND Autor = 'Neïra') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Neïra - Siete citas para Valentina', 'Neïra', NULL, v_42, 'EPUB/Neïra - Siete citas para Valentina - Neïra.epub', '.epub', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El límite del deseo' AND Autor = 'Eve Berlin') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El límite del deseo', 'Eve Berlin', 'Sexual dominant Dante knew Kara back in high school. He never imagined her darkest fantasies would align so perfectly with his. When Dante lands a job at Kara''s law firm, intense desire draws them closer while deep-rooted fears threaten to pull them apart- unless they can embrace both the pain and pleasure of love. **Winner of the 2011 Holt Medallion Award!**', v_192, 'EPUB/El límite del deseo - Eve Berlin.mobi', '.mobi', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Autoridad' AND Autor = 'Jeff VanderMeer') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Autoridad', 'Jeff VanderMeer', 'Segunda entrega de la trilogía Southern Reach. Después del fracaso de la expedición número 12, la agencia se encuentra sumida en el caos. John Rodríguez ha sido nombrado nuevo director de la agencia. Con la única ayuda de un equipo en el que no puede confi ar, debe desentrañar qué sucedió en la última expedición. Pero a medida que resuelve los enigmas que rodean el Área X, se ve enfrentado también a su propia verdad y a la de la agencia que dirige.', v_113, 'EPUB/Autoridad - Jeff VanderMeer.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Muerte en Hamburgo' AND Autor = 'Craig Russell') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Muerte en Hamburgo', 'Craig Russell', 'Un macabro asesino tiene a la ciudad de Hamburgo ente sus manos. «Podra detenerme, pero nunca me atrapará». Así finaliza el nuevo mensaje que el comisario Jan Fabel acaba de recibir de parte de alguien que firma como «Hijo de Sven». Es el segundo comunicado de este misterioso personaje, y otra vez anuncia un crimen macabro: dos mujeres han muerto asesinadas de la misma manera, con los pulmones arrancados, como si se tratara de un terrible ritual donde lo sagrado y lo monstruoso se dan la mano. El comisario Fabel debe resolver las numerosas incógnitas que el caso propone antes de que el asesino vuelva a actuar. Pero éste no ha dejado rastro alguno, ni parece haber relación entre una víctima y otra, ni un móvil claro. Tan sólo una pista que conduce a la extraña pervivencia de un culto vikingo, a la comunión de supersticiones antiguas y modernas ideologías sanguinarias, en las que el mal es la ley. En su primera novela, Craig Russell nos sumerge en una trama de misterio que no da descanso, y nos conduce por una Hamburgo convertida en un escenario fantasmagórico y violento de la mano de Jan Fabel, mitad policía, mitad historiador.', v_102, 'EPUB/Muerte en Hamburgo - Craig Russell.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '(Pesadillas N°41) Sálvese quien pueda' AND Autor = 'R.L. Stine') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('(Pesadillas N°41) Sálvese quien pueda', 'R.L. Stine', NULL, v_156, 'EPUB/(Pesadillas N°41) Sálvese quien pueda - R.L. Stine.mobi', '.mobi', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Neurociencia para educadores' AND Autor = 'Bueno i Torrens, David') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Neurociencia para educadores', 'Bueno i Torrens, David', 'Un libro riguroso, claro y de agradable lectura, lleno de ideas para meditar sobre el oficio de ser aprendices. Neurociencia para educadores es un libro espléndido que lleva un subtítulo suficientemente explícito. Los lectores encontraran en su interior " todo aquello que los educadores siempre han querido saber sobre el cerebro de sus alumnos y nunca nadie se ha atrevido a explicárselo de manera comprensible y útil". Para sorpresa de muchos, el resultado no echa por tierra la totalidad de la pedagogía moderna, sino que da una explicación científica complementaria a por qué, si se trabaja con conocimiento y dedicación, todo funciona razonablemente bien. Y un argumento sólido para no dar marcha atrás, como parecen querer algunas voces desmemoriadas.', v_42, 'EPUB/Neurociencia para educadores - Bueno i Torrens, David.epub', '.epub', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Un mes para seducir a una dama' AND Autor = 'Diane Howards') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Un mes para seducir a una dama', 'Diane Howards', '<p class="centrado">¿A quién seguir cuando el corazón te grita que te enamores del joven apuesto que hace que la pasión despierte en cada poro de tu piel, pero la razón te dice que es otro el adecuado?</p> <p>&nbsp;</p> <p>Becca Grant ha decidido enamorarse del nuevo profesor de arte. Ese hombre debe ser el adecuado, pues es apuesto, culto y le hace sentir un ligera expectativa, así que se lanza a una serie de encuentros no tan casuales para llamar su atención. Pero en su camino se interpone el señor Miller, que se va a quedar en Minstrel Valley unas semanas y ha decidido hacer de ella su conquista, con él todo se convierten en deseo de aventura.</p> <p>Desde el momento en que Patrick ve a Becca el resto de mujeres dejan de existir. Tiene poco tiempo para hacerla suya así que se ve obligado a utilizar métodos… poco sofisticados para llamar su atención. Pero cuando la traición cae sobre su amada se da cuenta de que no todo vale en el amor y que si tiene que esperar toda una vida por ella, lo hará.</p> <p>Porque cuando los sentimientos son verdaderos, el amor espera para siempre.</p>', v_88, 'EPUB/Un mes para seducir a una dama - Diane Howards.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Fuera de juego' AND Autor = 'Anna Casanovas') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Fuera de juego', 'Anna Casanovas', 'Con apenas dieciocho años, Pam sobrevivió a un infierno y empezó de cero lejos de casa. Entonces se prometió que sería fuerte y los tatuajes que lleva le recuerdan que es una luchadora y que no necesita a nadie. Su trabajo como fotógrafa y cámara le permite viajar por el mundo y se especializa en rodar documentales, cuanto más peligrosos mejor. Pero el último casi acaba con su vida y ahora, para evitar que la despidan, tiene que rodar un maldito documental en Cerdeña con el National Geographic. Pam se lo toma con resignación, como unas vacaciones forzosas, hasta que se tropieza con Ben y siente que nada de lo que ha hecho o sentido hasta ahora la ha preparado para un hombre como él. Ben estudió la carrera perfecta, se enamoró y se casó con la mujer perfecta y tenía el trabajo perfecto. Hasta que estuvo a punto de ser acusado de traición. Ahora Ben acaba de divorciarse y ha dimitido. No tiene nada ni a nadie, y necesita desaparecer para poder pensar y recordar quién es de verdad. Cuando tenía veinte años pasó un verano en Cerdeña y, en un impulso, compra un billete para la isla. Una vez allí, Ben se da cuenta de que lleva años viviendo sin respirar, sin sentir, sin emocionarse y decide hacer todo lo que sea necesario para remediarlo. Pero en sus planes no entra para nada sentirse atraído por una mujer completamente opuesta a él, una mujer cuya mirada contiene demasiados secretos y a la que él, sin saberlo, lleva toda la vida esperando. Hay personajes secundarios que se merecen su propia y gran historia de amor. Si conociste a Pam y a Ben en Las reglas del juego y Donde empieza todo, ahora te enamorarás de ellos en Fuera de juego.', v_37, 'EPUB/Fuera de juego - Anna Casanovas.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Artemis Fowl y su peor enemigo' AND Autor = 'Eoin Colfer') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Artemis Fowl y su peor enemigo', 'Eoin Colfer', 'Han pasado tres años desde las últimas aventuras de Artemis y, ahora, es un chico normal. Hechas las paces con el mundo mágico y convertido en una persona respetable, solo hay algo que le preocupa: la salud de su madre que se deteriora por momentos. Según el médico, padece una rarísima enfermedad incurable y le quedan pocos días de vida. Pero Artemis guarda un as en la manga: conserva magia del mundo elemental y está convencido de que puede curar a su madre. Al no ser así, no le quedará otro remedio que pedir ayuda al mundo mágico que le asegura que el antídoto de la enfermedad de su madre está en el cerebro de un animal que el propio Artemis mató ocho años atrás. A Artemis sólo le queda una posibilidad: volver ocho años atrás y recuperar el cerebro de ese animal…', @Cat_FantsticoJuvenil, 'EPUB/Artemis Fowl y su peor enemigo - Eoin Colfer.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Cercano y peligroso' AND Autor = 'Linda Howard') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Cercano y peligroso', 'Linda Howard', 'Un misterioso accidente de avión... un peligroso viaje a través de la salvaje tierra de Idaho... una intensa atracción y un letal juego del gato y el ratón. Los intrigantes hijastros de Bailey Wingate se quedan sorprendidos cuando descubren que la última voluntad de su padre, casado con Bailey, deja el control de toda su fortuna a su esposa... y entonces da comienzo una guerra sin tregua. Un año más tarde, volando desde Seattle hasta Denver en un pequeño avión, Bailey casi muerecuando el motor deja de funcionar.
Sin embargo, gracias a las habilidades de Cam Justice, su piloto privado, consiguen realizar un aterrizaje forzoso sin perder la vida. Perdidos en una tierra árida, y luchando por ocultar los sentimientos que ese apuesto texano le inspiran, Bailey comienza a preguntarse si el fallo del motor ha sido un mero accidente o hay algo más detrás. Y una vez de vuelta a la civilización las sospechas de Bailey comienzan a confirmarse: ¿Quién ha podido manipular el avión? ¿Quién está tratando de reunir a Bailey y a su difunto esposo en el Más Allá?
Confiando su vida –y su corazón– a Cam, Bailey tendrá que ser más lista que un asesino que es capaz de todo para terminar el trabajo que se le ha encomendado.
Cercano y peligroso es una novela llena de sensualidad y de intriga, con un ritmo vertiginoso. Linda Howard nos obsequia con una narración en la que las aventuras extremas y el aislamiento llevan a nuestros protagonistas al límite de sus sentimientos.', v_37, 'EPUB/Cercano y peligroso - Linda Howard.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Tres abuelas y un plan de sabotaje' AND Autor = 'Minna Lindgren') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Tres abuelas y un plan de sabotaje', 'Minna Lindgren', 'Las obras de mejora en la residencia El Bosque del Crepúsculo llegan a su fin y los ancianos pueden regresar a sus apartamentos. Ahora todo es diferente porque la dirección está en manos de una organización religiosa de dudosa legalidad; es poco probable que convertir ancianos y pedirles su dinero esté permitido. Pero hay otro tema que preocupa más a los residentes: las innovaciones tecnológicas hacen que ya no se necesite la presencia de personas que cuiden de los ancianos. La supervisión médica se hace online, se ha sustituido a los enfermeros por inventos automatizados y el servicio de apoyo se presta por Internet desde la India. Las tres abuelas están hartas de una vida programada por ordenador, así que deciden tramar un plan para destruir el sistema informático. A su edad se pueden romper unas cuantas leyes y reglas si no hay justicia. Su intento de hackeo les hace acabar en prisión, pero después de una noche en la celda empiezan a vislumbrar un futuro un poco más libre. La aventura más emocionante está todavía por llegar', v_27, 'EPUB/Tres abuelas y un plan de sabotaje - Minna Lindgren.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'La sombra de la sirena' AND Autor = 'Camilla Läckberg') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('La sombra de la sirena', 'Camilla Läckberg', 'Un hombre desaparece en Fjällbacka sin dejar rastro. Pese a que Patrik Hedström y sus colegas de la policía han hecho cuanto han podido para encontrarlo, nadie sabe si está vivo o muerto. Al cabo de tres meses, lo encuentran finalmente congelado en el hielo. Cuando averiguan que el escritor Christian Thydell, uno de los amigos de la víctima, lleva más de un año recibiendo cartas anónimas plagadas de amenazas, todo se complica.Christian trata de restarle importancia, pero su amiga Erica Falck, quien lo ayudó en la escritura de su primera y exitosa novela, La sombra de la sirena, es consciente del peligro. La policía no tarda en comprender que el asesinato y las cartas están relacionados.Alguien odia a Christian profundamente, y ese alguien parece que no dudará en cumplir sus amenazas…', v_102, 'EPUB/La sombra de la sirena - Camilla Läckberg (2).epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El Palacio de la Medianoche' AND Autor = 'Carlos Ruiz Zafón') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El Palacio de la Medianoche', 'Carlos Ruiz Zafón', 'The horrible adventure of a sixteen-year-old orphan, Ben, and his friends in the city of Calcutta in 1916.', v_170, 'EPUB/El Palacio de la Medianoche - Carlos Ruiz Zafón.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Fuego en la oscuridad' AND Autor = 'Sadie Matthews') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Fuego en la oscuridad', 'Sadie Matthews', '<p class="description">''Adam acababa de destrozarme el corazón. Me lo había roto en tantos pedazos que apenas podía unirlos para volver a ser una persona medianamente feliz. Pero todo iba a cambiar cuando conocí a Dominic. Dominic me enseñó una manera de dejarme llevar, de abandonarme, que nunca había conocido. Me mostró un sendero de puro placer, pero también de dolor... Su amor me iluminaba, aunque tenía un lado oscuro. Y, me llevara donde me llevara, yo no tenía más opción que seguirle.''<br>La historia de Beth te cautivará y te seducirá como nunca habías soñado. Intensa y romántica, sensual y embriagadora, Fuego en la oscuridad te conducirá por unas sendas en las que el amor y el sexo juegan libremente ajenos a cualquier límite.</p>', v_38, 'EPUB/Fuego en la oscuridad - Sadie Matthews.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Que podemos perder' AND Autor = 'Sandra Miro') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Que podemos perder', 'Sandra Miro', NULL, v_179, 'EPUB/Que podemos perder - Sandra Miro.epub', '.epub', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Memento Mori' AND Autor = 'Cesar Perez Gellida') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Memento Mori', 'Cesar Perez Gellida', 'Septiembre de 2010. Aquella mañana de domingo nada le hacía presagiar al inspector de homicidios de Valladolid Ramiro San­cho que acababa de dar comienzo una pesadilla que lo dejaría marcado para el resto de sus días.
La investigación del asesinato de una joven ecuatoria­na a la que le han mutilado los párpados y cuyo cuer­po han encontrado unos versos amenazantes, ocupa las primeras páginas de esta novela negra narrada con un dinámico y atrevido lenguaje cinematográfico. Sin embargo, el autor nos arrastra por un camino inespe­rado al describir los hechos desde la perspectiva del propio asesino: un sociópata narcisista influenciado por la música más actual y por las grandes obras de la literatura universal.
La evolución frenética de los acontecimientos desem­boca en la intervención de uno de los especialistas más reconocidos en el comportamiento de los ase­sinos en serie. Este complejo triángulo emocional, unido a la intriga que envuelve al siniestro cómplice del asesino, hace que Memento mori se convierta en un profundo thriller de acción con banda sonora que atrapará al lector de principio a fin.', v_61, 'EPUB/Memento Mori - Cesar Perez Gellida.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Minstrel Valley 4. La tentación de un beso' AND Autor = 'Christine Cross') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Minstrel Valley 4. La tentación de un beso', 'Christine Cross', '<div><p style="margin: -4px 0px 14px; padding: 0px; color: rgb(51, 51, 51); font-family: Arial, sans-serif; font-size: 14px; orphans: 2; widows: 2; background-color: rgb(255, 255, 255);">Eleanor ha cumplido 25 años y se siente algo abrumada por la monotonía de su vida. Una mañana se presenta en la escuela un abogado para hablar con ella. Alguien ha hecho un testamento en su favor dejándole una herencia sustanciosa con la que podría cumplir su sueño de viajar, conocer el mundo y a otras personas, o volver a la alta sociedad a la que pertenecía. Junto con el dinero, recibe también un extraño y antiguo medallón. Asaltada por las dudas sobre la cuestión del dinero, decide hablar con Lady Acton.</p><p style="margin: -4px 0px 14px; padding: 0px; color: rgb(51, 51, 51); font-family: Arial, sans-serif; font-size: 14px; orphans: 2; widows: 2; background-color: rgb(255, 255, 255);">Cuando acude a su saloncito privado conoce a Ashton Melham, conde de Clifford, un hombre que desestabiliza su mundo, aunque lo considera un aventurero. Él se interesa enseguida por el medallón. Recuerda haber visto algo parecido, cuando era un niño, en algún lugar de la vieja mansión de su familia. Lady Acton anima a Eleanor a tomarse unas pequeñas vacaciones para que pueda serenarse y tomar una adecuada decisión con respecto a su futuro; de paso, podrá visitar la mansión Clifford y averiguar algo sobre el medallón...</p><p style="margin: -4px 0px 14px; padding: 0px; color: rgb(51, 51, 51); font-family: Arial, sans-serif; font-size: 14px; orphans: 2; widows: 2; background-color: rgb(255, 255, 255);"><b>Las tardes pasadas en Clifford Manor, se transformarán en un refugio cálido para Eleanor mientras la relación con Ash se va transformando en algo distinto.</b></p></div>', v_53, 'EPUB/Minstrel Valley 4. La tentación de un beso - Christine Cross.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Radiografía del deseo' AND Autor = 'Mimmi Kass') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Radiografía del deseo', 'Mimmi Kass', 'Primera parte de la serie «En cuerpo y alma», donde la pasión y el erotismo, junto a los grandes temas sobre la vida y el amor, se mezclan en un cóctel explosivo. Elegante, arriesgada, y divertida, «Radiografía del Deseo» no te dejará indiferente.Erik es un cardiocirujano noruego volcado en su trabajo; vive dedicado al hospital y no tiene tiempo, ni le interesan, las relaciones serias. Es duro y exigente consigo mismo, y espera lo mismo del resto de sus colegas.Inés es residente. Un espíritu libre que intenta equilibrar todas las facetas de su vida, segura de que cumplirá su proyecto de futuro al lado de un hombre que la ame. A pesar de las diferencias culturales, de temperamento y de los continuos enfrentamientos en un hospital competitivo de primer nivel, nace entre ellos una espiral de deseo irresistible contra la que no podrán luchar. El sexo lo inundará todo, pero ¿surgirá algo más?', v_144, 'EPUB/Radiografía del deseo - Mimmi Kass.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Guerreras 02-Desde donde se domine la llanura' AND Autor = 'Megan Maxwell') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Guerreras 02-Desde donde se domine la llanura', 'Megan Maxwell', NULL, v_42, 'EPUB/Guerreras 02-Desde donde se domine la llanura - Megan Maxwell.epub', '.epub', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'La caja mágica' AND Autor = 'Ana Campoy') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('La caja mágica', 'Ana Campoy', '¿Qué hubiera ocurrido si Alfred Hitchcock y Agatha Christie se hubieran conocido de niños? ¿Qué aventuras habrían vivido? ¿Qué sorprendentes casos habrían resuelto juntos? Las aventuras de Alfred&Agatha nos muestra cómo podría haber sido la amistad de infancia de los dos maestros del suspense más importantes de nuestro tiempo.  En esta tercera aventura, la madre de Agatha regala a los niños un par de entradas para el cinematógrafo. Alfred está emocionado ante el acontecimiento y disfruta mucho del espectáculo. A la salida de la película, los niños conocen a un imponente caballero, Thomas Alva Edison, inventor y empresario que no duda en ofrecerles visitar su próspera compañía.', v_42, 'EPUB/La caja mágica - Ana Campoy.epub', '.epub', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Una flor para otra flor (Las guerreras Maxwell 4)' AND Autor = 'Megan Maxwell') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Una flor para otra flor (Las guerreras Maxwell 4)', 'Megan Maxwell', '<div>Estar enamorado de la mujer que se desea olvidar no es algo que el joven e impetuoso highlander Zac Philips lleve bien.<br><br>Tiempo atrás, Zac posó sus ojos en Sandra, una joven de mirada y pelo castaños que cautivó con su sonrisa. Pero cuando el padre de Sandra falleció, sus abuelos maternos las obligaron, tanto a ella como a su madre, a dejar las Highlands, su lugar de residencia, y regresar a Carlisle, un lugar en el que ninguna de las dos conseguía ser feliz, sobre todo cuando sus abuelos se empeñaron en concertarle un matrimonio. <br><br>Dispuesto a salvar a su amada, Zac partió hacia Carlisle, pero al llegar allí se encontró con Sandra riendo divertida con uno de aquellos ingleses. Ofuscado y con el corazón destrozado, regresó a las Highlands con la intención de olvidarla. <br><br>Sin remilgos ni medias tintas, Sandra iba ahuyentando a sus supuestos pretendientes, ganándose así la enemistad de sus abuelos y, con el tiempo, cargando con la culpa por la muerte de su abuela.

</div>', v_86, 'EPUB/Una flor para otra flor (Las guerreras Maxwell 4) - Megan Maxwell.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Bruja Americana' AND Autor = 'Thea Harrison') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Bruja Americana', 'Thea Harrison', '<div>
<p>Llega la primera novela de una nueva fascinante trilogía de Thea Harrison… </p>
<p>El poder puede cambiar a una persona... </p>
<p>Durante meses Molly Sullivan soporta lo inexplicable: sobrecargas eléctricas, averías en los coches, visiones. Incluso se pregunta si ella podría ser la causa... y se pregunta si podría estar loca. Luego descubre que su marido la ha engañado. Otra vez. Ahora Molly se da cuenta de que es una bruja recién despertada y una mujer al límite. </p>
<p>La venganza puede formar a una persona... </p>
<p>Josiah Mason es un poderoso brujo y el líder de un aquelarre secreto con un objetivo compartido: destruir a un antiguo enemigo que ha arruinado muchas vidas. Josiah perdió años con este hombre, y su único objetivo es la venganza. Está preparado para cualquier contingencia, excepto para encontrarse con una nueva y hermosa bruja que no entiende nada del inmenso Poder que acumula en su interior ni de la atracción que ejerce sobre él. </p>
<p>El peligro puede unirlos... </p>
<p>Al divorciarse de su marido, Molly descubre un peligroso secreto cuya protección él está dispuesto a matar. Acude a Josiah en busca de ayuda, y descubren una conexión entre el marido de Molly y el enemigo de Josiah. </p>
<p>Mientras trabajan juntos, se enciende una chispa entre ellos que amenaza con convertirse en un incendio. Pero Molly ya no se compromete con ningún hombre, y la misión de Josiah es su principal prioridad. Y el enemigo es astuto, cruel y cada vez más cercano. </p>
<p>A medida que el peligro aumenta, también lo hace la tensión entre ellos. ¿Es posible una relación duradera? ¿Vivirá alguno de ellos lo suficiente para intentarlo? </p></div>', v_93, 'EPUB/Bruja Americana - Thea Harrison.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '(Fjallbacka 03) Las hijas del frío' AND Autor = 'Camilla Lackberg') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('(Fjallbacka 03) Las hijas del frío', 'Camilla Lackberg', 'La alegría de Erica y Patrik por el nacimiento de su hija es inmensa, pero deben enfrentarse a unos problemas nuevos para ellos; la pequeña llora mucho, Erica sufre una depresión posparto y Patrik está constantemente cansado. Erica encuentra entonces apoyo en Charlotte, madre de Sara, una niña de siete años que sufre el síndrome de deficiencia de atención cuando, de repente, se produce un drama totalmente inesperado. Un pescador encuentra el cadáver de la pequeña Sara, ahogada en el mar. Las autoridades piensan que se trata de un accidente, pero la autopsia revela que la pequeña fue ahogada en una bañera antes de ser arrojada al mar, y que alguien le hizo tragar cenizas.', v_39, 'EPUB/(Fjallbacka 03) Las hijas del frío - Camilla Lackberg.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El límite de la tentación' AND Autor = 'Eve Berlin') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El límite de la tentación', 'Eve Berlin', 'Mischa Kennon es una luchadora nata y pocas cosas la harán sucumbir, esto es hasta que conoce al muy sexy Connor Galloway, un irlandés de ojos verdes con un aire autoritario que es irresistible. Mientras que ejerce sus labores como dama de honor de su mejor amiga, Mischa se mete en una relación poco seria con Connor. Y se verá sorprendida por el dominio que él ejerce sobre ella y que le hace desear más y más batallas desenfrenadas antes de la rendición total. Todo es un juego en el Club de BDSM La cúpula del placer, hasta que Mischa empieza a darse cuenta de que Connor también podría acabar por dominar su corazón. Si cede a su deseo, ¿será imposible de dominar o le abrirá los ojos a un tipo de amor que jamás pensó posible?', v_144, 'EPUB/El límite de la tentación - Eve Berlin.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El guardián de las flores' AND Autor = 'Autor desconocido') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El guardián de las flores', 'Autor desconocido', NULL, v_42, 'EPUB/El guardián de las flores - Autor desconocido.epub', '.epub', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Las siete Hermanas 5 - La hermana luna' AND Autor = 'Lucinda Riley') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Las siete Hermanas 5 - La hermana luna', 'Lucinda Riley', 'La hermana luna es el quinto volumen de la emocionante saga de Lucinda Riley Las Siete Hermanas, una serie de novelas basada en la mitología griega y en la astrología que enamorará a sus lectoras y que en este caso nos transporta a Granada, Barcelona y Madrid. Siete hermanas, siete destinos, un padre con un pasado misterioso... Cuando Tiggy D''Aplièse acepta trabajar en una de las zonas más recónditas de Escocia, en concreto en la enorme finca Kinnaird, nada le hace sospechar que el misterioso terrateniente, Charlie Kinnaird, está a punto de alterar su futuro e, irónicamente, revelarle su pasado. En su nuevo hogar Tiggy descubrirá que tiene un don, el sexto sentido, una herencia de sus antepasados gitanos. Lucía Amaya-Albaycín nació en 1912 en el barrio del Sacromonte, frente a la Alhambra, y la apodaron La Candela. En su destino está escrito convertirse en una de las grandes bailarinas de la historia, y por eso su padre se la lleva a los bares de flamenco de Barcelona con solo diez años. Al estallar la Guerra Civil, Lucía y su grupo de bailaores se ven obligados a buscar refugio en Nueva York. Pero para ver cumplido su sueño Lucía tendrá que elegir entre la pasión por el baile o el hombre al que ama... Conforme conoce sus raíces españolas y desentraña el pasado de su familia, Tiggy comienza a aceptar y a controlar su don sin saber que ella también deberá tomar una difícil decisión, no muy distinta a la que en su día afrontó Lucía. Si quieres saber más, incluso sobre mitología griega, las Pléyades, las esferas armilares..., visita la web de Lucinda Riley en español: esp.lucindariley.co.uk. También encontrarás documentación sobre las Highlands, Carmen Amaya, las cuevas del Sacromonte, el flamenco, los gitanos en España y los ciervos blancos. La crítica ha dicho sobre la saga Las Siete Hermanas... «La serie Las Siete Hermanas es romántica, arrolladora, lujosa y glamurosa». The Daily Mail «Un libro brillante que no puedes dejar, lleno de glamour y romance». The Daily Mail «Riley es una experta contadora de relatos románticos que entreteje con habilidad la historia con la ficción. Un libro absorbente y fascinante». Booklist «Una pizca de misterio, un poco de romance, algo de ficción histórica y mucho drama familiar en una historia maravillosa. Una apuesta segura para fans de Kate Morton, Kristin Hannah o Maeve Binchy». Library Journal Los lectores opinan: «Las Siete Hermanas siguen siendo una maravillosa conjunción de astrología, feminismo, mitología, romance... junto a unos personajes capaces de amar y sufrir a partes iguales». Blog El cuervo de alas rotas «Si os gusta la novela contemporánea, los libros de misterios familiares, los saltos en el tiempo, viajar a través de la lectura... esta es vuestra autora». Blog Historias de algodón «He vuelto a disfrutar de la habilidad de la autora para mezclar grandes protagonistas con amor, historia y buena ambientación.» Blog Bajo la piel de un lector «Un logro por parte de la autora conseguir que todas las entregas de esta larga serie sean igualmente interesantes». Blog Libros que hay que leer', v_42, 'EPUB/Las siete Hermanas 5 - La hermana luna - Lucinda Riley.epub', '.epub', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Deseo concedido' AND Autor = 'Megan Maxwell') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Deseo concedido', 'Megan Maxwell', 'Lady Megan Phillips es una joven y bella luchadora que tiene a su cargo a dos hermanos pequeños. La vida no le ha resultado nada fácil, por lo que ha forjado el carácter de una auténtica guerrera que no se doblega ante nada ni nadie. El highlander Duncan McRae, más conocido como el Halcón, es un hombre acostumbrado a liderar ejércitos, librar batallas y salir victorioso de todas ellas junto con su clan. Pero al llegar al castillo de Dunstaffnage para celebrar el enlace de su buen amigo Alex McDougall, se encuentra con el mayor desafío de su vida, alguien con quien no está acostumbrado a lidiar: lady Megan Phillips, una morena que no le tiene miedo a nada. Asombrado por el descaro y el ímpetu de la joven, el Halcón no puede apartar sus ojos verdes de ella y, tras hacerle una promesa al abuelo de la muchacha, se ve unido a lady Megan en una boda que durará un año y un día. ¿Qué les deparará el destino a los señores McRae? ¿Conseguirán entenderse o acabarán odiándose para el resto de sus días?', v_231, 'EPUB/Deseo concedido - Megan Maxwell.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'La propuesta de un canalla' AND Autor = 'Stephanie Laurens') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('La propuesta de un canalla', 'Stephanie Laurens', 'Felicity sabía que Demonio Cynster era uno de los solteros más codiciados de la alta sociedad londinense y un canalla de la peor ralea, pero era el único capaz de hacer que su amigo saliese del lío en que se había metido. Pese a la fuerza que asoma bajo su fachada de despreocupación, Felicity no puede evitar sentirse fascinada por él, ni aplacar el deseo que se apodera de su cuerpo cada vez que la toma entre sus brazos. Sabe que Demonio nunca le entregará su amor, y que la pasión sería el único sostén posible de un matrimonio con un hombre como él…', v_220, 'EPUB/La propuesta de un canalla - Stephanie Laurens.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Not My Romeo' AND Autor = 'Ilsa Madden-Mills') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Not My Romeo', 'Ilsa Madden-Mills', '<div> <p align="justify">Comenzamos con una mentira el día de San Valentín. </p> <p align="justify">Mi cita a ciegas no es el tipo estudioso que esperaba. No, es un sexy jugador magnífico con ojos ambarinos pecaminosos y un cuerpo asesino. De alguna manera terminamos en su ático. Culpo al gin tonic. </p> <p align="justify">Al día siguiente, descubro que es Jack Hawke: todo un chico malo y mariscal de campo profesional con un pasado turbio. </p> <p align="justify">El acuerdo de confidencialidad que me hizo firmar debería haber sido una advertencia de que no es una persona normal. Por favor. Lo firmé como Julieta Capuleto, así que adiós, jugador de fútbol famoso con abdominales de acero, y buena suerte rastreando a esta bibliotecaria de un pueblo pequeño. </p> <p align="justify">Pero Jack sigue apareciendo en los lugares donde menos lo espero. Justo cuando estoy segura que se ha ido, entra al teatro de mi comunidad y gana el papel del Romeo para mi Julieta. </p> <p align="justify">¿Cómo se supone que una chica sencilla, mayormente inocente como yo, debe resistirse a un hombre como él? </p> <p align="justify">¿Acaso Jack es mi verdadero Romeo... o este magnífico jugador de fútbol solo me romperá el corazón? </p></div>', v_98, 'EPUB/Not My Romeo - Ilsa Madden-Mills.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Aceptación' AND Autor = 'Jeff VanderMeer') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Aceptación', 'Jeff VanderMeer', 'Tercera entrega de la trilogía Southern Reach. Control, el director de la agencia estatal Southern Reach, se dirige al Área X. Está convencido de que si descubre cuál es el misterio que se esconde más allá de sus fronteras podrá evitar que su naturaleza amenazante se propague. Pero una vez allí todas sus convicciones se d esmontan. En pleno invierno y sin ninguna certeza a la que aferrarse, deberá remontarse hasta los orígenes del Área X y aquellos que la han habitado para resolver el enigma. Aceptación es la última entrega de la trilogía Southern Reach, una serie que ha sido calificada de ''''inquietante'''' (The New York Times), ''''apasionante'''' (Los Angeles Times) y ''''adictiva'''' (BookPage).', v_113, 'EPUB/Aceptación - Jeff VanderMeer.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El asesino del Camino Norte' AND Autor = 'Rober H. L. Cagiao') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El asesino del Camino Norte', 'Rober H. L. Cagiao', '<div>
<p style="font-family: ''Arial'',''sans-serif''; font-size: 14px"><span style="background-color: #ffffff; color: #333333">Primera parte de uno de los nuevos capítulos de la Saga de El Guardián de las Flores, thriller ambientado en Galicia. En este caso, en el Camino Norte de peregrinación a Compostela. Colindres, Gernika, Zarautz, Luarca, Arzúa y la capital de Galicia serán los nuevos escenarios en esta nueva entrega.</span></p></div>', v_42, 'EPUB/El asesino del Camino Norte - Rober H. L. Cagiao.epub', '.epub', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Amores Cruzados' AND Autor = 'Erina Alcala') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Amores Cruzados', 'Erina Alcala', '<div><span style="color: rgb(51, 51, 51); font-family: ''Amazon Ember'', Arial, sans-serif; font-size: 14px; orphans: 2; widows: 2; background-color: rgb(255, 255, 255);">Amores que se cruzan, amores que no son felices. Amores infieles. Eso le pasó a Candela Díaz, una chica malagueña, cuya vida no había sido fácil desde la infancia.</span><br style="color: rgb(51, 51, 51); font-family: ''Amazon Ember'', Arial, sans-serif; font-size: 14px; orphans: 2; widows: 2; background-color: rgb(255, 255, 255);"><span style="color: rgb(51, 51, 51); font-family: ''Amazon Ember'', Arial, sans-serif; font-size: 14px; orphans: 2; widows: 2; background-color: rgb(255, 255, 255);">En el amor, no tuvo mejor suerte y su divorcio la llevó a enamorarse del marido de la amante de su marido. Y él, Jesús, de ella. Pero cada vez que podían unirse algo, los separaba.</span><br style="color: rgb(51, 51, 51); font-family: ''Amazon Ember'', Arial, sans-serif; font-size: 14px; orphans: 2; widows: 2; background-color: rgb(255, 255, 255);"><span style="color: rgb(51, 51, 51); font-family: ''Amazon Ember'', Arial, sans-serif; font-size: 14px; orphans: 2; widows: 2; background-color: rgb(255, 255, 255);">Jesús, era bombero y nunca creyó, que su mujer Bea le fuese infiel, hasta que Candela llegó a su puerta con un sobre amarillo de un detective privado con unas fotos que no daban lugar a ninguna duda de que su mujer estaba con el marido de Candela.</span><br style="color: rgb(51, 51, 51); font-family: ''Amazon Ember'', Arial, sans-serif; font-size: 14px; orphans: 2; widows: 2; background-color: rgb(255, 255, 255);"><span style="color: rgb(51, 51, 51); font-family: ''Amazon Ember'', Arial, sans-serif; font-size: 14px; orphans: 2; widows: 2; background-color: rgb(255, 255, 255);">Se volvieron a encontrar y se enamoraron.</span><br style="color: rgb(51, 51, 51); font-family: ''Amazon Ember'', Arial, sans-serif; font-size: 14px; orphans: 2; widows: 2; background-color: rgb(255, 255, 255);"><span style="color: rgb(51, 51, 51); font-family: ''Amazon Ember'', Arial, sans-serif; font-size: 14px; orphans: 2; widows: 2; background-color: rgb(255, 255, 255);">Pero la vida para ellos no fue tan fácil a pesar de que él nunca dejó de amarla y de los errores que ambos cometieron.</span><br style="color: rgb(51, 51, 51); font-family: ''Amazon Ember'', Arial, sans-serif; font-size: 14px; orphans: 2; widows: 2; background-color: rgb(255, 255, 255);"><span style="color: rgb(51, 51, 51); font-family: ''Amazon Ember'', Arial, sans-serif; font-size: 14px; orphans: 2; widows: 2; background-color: rgb(255, 255, 255);">¿Volverían a reunirse y a amarse con el tiempo? Si te gustan las novelas donde la vida real supera la ficción, no te la pierdas.</span></div>', v_42, 'EPUB/Amores Cruzados - Erina Alcala.epub', '.epub', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Lo que encontré bajo el sofá' AND Autor = 'Eloy Moreno') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Lo que encontré bajo el sofá', 'Eloy Moreno', '¿Qué ocurre al mover un sofá? ¿Y al mover una vida? Es posible que en ambos casos encuentres algo parecido: recuerdos que ya esperabas, otros de los que ni te acordabas y alguno que no hubieras deseado encontrar nunca… de esos que se convierten al instante en secretos.¿Y si movemos una sociedad? Entonces uno se da cuenta de que vive en un lugar con demasiados gusanos para tan poca manzana. Pero también un lugar donde, al observarnos, descubrimos que somos los primeros en hacer aquello que tanto criticamos.', v_106, 'EPUB/Lo que encontré bajo el sofá - Eloy Moreno.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Tres abuelas y un joyero de ida y vuelta' AND Autor = 'Minna Lindgren') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Tres abuelas y un joyero de ida y vuelta', 'Minna Lindgren', 'La esperada segunda entrega de la «Trilogía de Helsinki», una original mezcla entre comedia y thriller escandinavo protagonizado por un grupo de nonagenarias. Siiri, Irma y Anna-Liisa son tres viudas de noventa años residentes en El Bosque del Crepúsculo, un centro privado de apartamentos para la tercera edad de Helsinki que, bajo su apariencia de nidito acogedor para personas mayores, resulta un lugar un tanto siniestro. En esta ocasión las abuelas ven su vida convertida en un infierno por unas obras interminables. El ruido es ensordecedor, en las paredes surgen agujeros, las cosas desaparecen y los residentes tienen que usar inodoros portátiles. A las protagonistas no les queda más remedio que mudarse a un apartamento compartido, donde sus costumbres y manías no harán la convivencia nada fácil. Las ancianas comienzan además a darse cuenta de que las obras de su residencia son bastante sospechosas y podrían estar encubriendo actividades criminales. Cuando los misterios comiencen a resolverse, las amigas descubrirán que en esta vida poca gente está tan libre de culpa como parece.', v_147, 'EPUB/Tres abuelas y un joyero de ida y vuelta - Minna Lindgren.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '(Fjallbacka 10) La bruja' AND Autor = 'Camilla Lackberg') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('(Fjallbacka 10) La bruja', 'Camilla Lackberg', 'La desaparición de Linnea, una niña de cuatro años, de una granja en las afueras de Fjällbacka, despierta trágicos recuerdos. Treinta años antes se perdió en la misma granja el rastro de otra niña, Stella, que al poco fue hallada sin vida.Entonces dos adolescentes fueron acusadas y declaradas culpables de su secuestro y asesinato, pero evitaron ir a prisión por ser menores de edad. Una de ellas, Helen, ha llevado una vida apacible en Fjällbacka; la otra, Marie, una actriz de éxito, regresa por primera vez después del suceso para rodar una película.</b></p><p><b>Los habitantes de Fjällbacka se organizan para buscar a Linnea y no pueden evitar preguntarse si otras niñas pueden estar en peligro. Aunque Patrik cree que la verdad siempre encuentra su camino a pesar de los rumores, tanto él como sus compañeros de la comisaría investigan la conexión entre ambos casos.</b></p><p><b>Tan solo su mujer Erika parece conservar la calma; lleva algún tiempo trabajando en un libro sobre el asesinato de aquella niña, aparentemente resuelto hace años. Pero la investigación abrirá antiguas heridas y aumentará el miedo a que lo desconocido traiga terribles consecuencias para todos los habitantes de Fjällbacka.', v_39, 'EPUB/(Fjallbacka 10) La bruja - Camilla Lackberg.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'La muerte de Erika Knapp' AND Autor = 'Luca D''Andrea') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('La muerte de Erika Knapp', 'Luca D''Andrea', '<div>
<p style="font-family: ''Amazon Ember'',''Arial'',''sans-serif''; font-size: 14px"><strong style="color: #000000">Regresa el autor de</strong><span style="font-style: italic; font-weight: 600; color: #000000"> La sustancia del mal</span><strong style="color: #000000">, con más de 300.000 lectores en 42 países, con un nuevo</strong><span style="font-style: italic; font-weight: 600; color: #000000"> thriller</span><strong style="color: #000000"> que lo confirma como estrella de la novela negra europea, junto a</strong><span style="color: #000000"> </span><strong style="color: #000000">Dazieri,</strong><span style="color: #000000"> </span><strong style="color: #000000">Lemaitre y</strong><span style="color: #000000"> </span><strong style="color: #000000">Dicker.</strong></p>
<p style="font-family: ''Amazon Ember'',''Arial'',''sans-serif''; font-size: 14px"><strong style="color: #000000">«De lectura obligada. Léela con el cinturón de seguridad abrochado.»</strong><span style="color: #000000"><br></span><span style="font-style: italic; font-weight: 600; color: #000000">La Stampa</span></p>
<p style="font-family: ''Amazon Ember'',''Arial'',''sans-serif''; font-size: 14px"><strong style="color: #000000">«Un experimento narrativo consumado.»</strong><span style="color: #000000"><br></span><span style="font-style: italic; font-weight: 600; color: #000000">Il Corriere</span><span style="color: #000000"> </span><span style="font-style: italic; font-weight: 600; color: #000000">della Sera</span></p>
<p style="font-family: ''Amazon Ember'',''Arial'',''sans-serif''; font-size: 14px"><span style="color: #000000">Tony Carcano lleva una vida aislada y monótona, en la que las únicas emociones que experimenta son las que describe en sus propios libros, unas novelas de amor que desde hace tiempo le proporcionan éxito y bienestar. Sin embargo, Sibylle, una veinteañera imprudente y encantadora, irrumpe en su vida con una antigua foto que lo retrata joven y sonriente junto al cadáver de una mujer: Erika Knapp.</span></p>
<p style="font-family: ''Amazon Ember'',''Arial'',''sans-serif''; font-size: 14px"><span style="color: #000000">Tony se ve obligado a retomar los hilos de una historia que durante mucho tiempo quiso dejar atrás. Junto a Sibylle, tendrá que volver a adentrarse en las sombras del pequeño pueblo tirolés de Kreuzwirt, donde se esconde un misterio hecho de mentiras, violencia, locura y codicia. Este</span><em style="color: #000000"> thriller,</em><span style="color: #000000"> de una potencia avasalladora y un ritmo diabólico, hará resurgir un secreto oculto durante más de veinte años abriendo de par en par las compuertas del infierno.</span></p></div>', v_42, 'EPUB/La muerte de Erika Knapp - Luca D''Andrea.epub', '.epub', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Hacia las estrellas' AND Autor = 'Mary Robinette Kowal') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Hacia las estrellas', 'Mary Robinette Kowal', '<div>
<p>El futuro de la humanidad está en manos de un grupo de mujeres.</p>
<p>En un frío día primaveral de 1952, un meteorito impacta contra la Tierra y arrasa la Costa Este de Estados Unidos. Pronto, las consecuencias de tal cataclismo harán del planeta un lugar inhóspito, como ocurrió antes de la extinción de los dinosaurios. Esta terrible amenaza obliga a la humanidad a acelerar radicalmente sus esfuerzos para colonizar el espacio.</p>
<p>Elma York, piloto del Servicio Aéreo Femenino y matemática, será una de las mujeres que trabajarán en la Coalición Espacial Internacional como calculadoras para llevar al hombre a la Luna. Su ambición por convertirse en astronauta hará que se enfrente a una sociedad que no está preparada para ver a una mujer rumbo hacia las estrellas.</p>
<p>La mejor novela de ciencia ficción del año, ganadora de los premios Hugo, Nébula y Locus.</p>
<p>''Elma York es lo que le falta a la NASA: una heroína con garra.''</p>
<p>The Wall Street Journal</p></div>', v_117, 'EPUB/Hacia las estrellas - Mary Robinette Kowal.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'La sombra de la sirena' AND Autor = 'Camilla Läckberg') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('La sombra de la sirena', 'Camilla Läckberg', 'Un hombre desaparece en Fjällbacka sin dejar rastro. Pese a que Patrik Hedström y sus colegas de la policía han hecho cuanto han podido para encontrarlo, nadie sabe si está vivo o muerto. Al cabo de tres meses, lo encuentran finalmente congelado en el hielo. Cuando averiguan que el escritor Christian Thydell, uno de los amigos de la víctima, lleva más de un año recibiendo cartas anónimas plagadas de amenazas, todo se complica.Christian trata de restarle importancia, pero su amiga Erica Falck, quien lo ayudó en la escritura de su primera y exitosa novela, La sombra de la sirena, es consciente del peligro. La policía no tarda en comprender que el asesinato y las cartas están relacionados.Alguien odia a Christian profundamente, y ese alguien parece que no dudará en cumplir sus amenazas…', v_102, 'EPUB/La sombra de la sirena - Camilla Läckberg.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Señuelo mortal' AND Autor = 'P. J. Tracy') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Señuelo mortal', 'P. J. Tracy', 'Tras resolver el caso de la compañía de «software». Monkeewrench, los detectives Leo Magozzi y Gino Rolseth llevan un tiempo sin ningún caso de homicidio que investigar, hasta que les llega la noticia del asesinato de Morey Gilbert, a quien su esposa, Lily, acaba de encontrar tumbado, con una bala en el cráneo, en el invernadero de su casa. ¿Quién ha podido acabar con la vida de este respetable anciano al que todo el mundo parecía adorar? Entre los sospechosos figuran no sólo la mujer del muerto, que se muestra extrañamente irritable con la policía, sino también su yerno, Marty Pullman, y su hijo, la única persona con la que Morey no se hablaba. Como si de un juego de dominó se tratara, a este homicidio siguen otros, que comparten unas características similares: además de presentar un mismo método, las víctimas siempre son ancianos. Algún tipo de secreta conexión entre éstas se les escapa a los dos detectives, que trabajan contrarreloj para tratar de adelantarse al asesino Grace McBride, la guapa fundadora de Monkeewrench, volverá a colaborar con ellos. ¿Podrán los tres, con la ayuda de los más sofisticados sistemas de búsqueda informática, descubrir la pieza que resuelve el rompecabezas?', v_27, 'EPUB/Señuelo mortal - P. J. Tracy.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Cómo salvar una mala racha' AND Autor = 'Marie Robert') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Cómo salvar una mala racha', 'Marie Robert', '<div>
<p style="font-family: ''Amazon Ember'',''Arial'',''sans-serif''; font-size: 14px"><span style="color: #000000">Una visita catastrófica a Ikea en donde nada ocurre como estaba previsto, una cita a ciegas fracasa por varias incompatibilidades, una madre entra en pánico al descubrir que su hijo está en plena adolescencia y no sabe qué hacer con él… Distintas situaciones cotidianas que nos pueden confundir y hacernos pensar que estamos pasando una mala racha. ¿Qué tenemos que hacer para evitar que nos entre el pánico o para no acabar llorando? ¿Y si invitamos a Platón, Spinoza, Nietzsche o Wittgenstein para hablar de estos temas? ¿Qué habría contestado Kant a un mensaje de ruptura? ¿Aristóteles habría tomado otro vodka más? ¿Qué nos diría Epicuro sobre nuestras angustias? ¿Qué haría Spinoza en Ikea? Los filósofos salen por fin de las bibliotecas para ayudarnos a reaccionar con humor a todas las sorpresas de la vida. </span></p>
<p style="font-family: ''Amazon Ember'',''Arial'',''sans-serif''; font-size: 14px"><span style="color: #000000">Este libro original y curioso recrea doce situaciones de crisis y doce filósofos capaces de tranquilizarnos y ayudarnos a desdramatizar. Se trata de momentos que se nos escapan, de esos minutos de caos en los que todo se tambalea; esos instantes que nos llevan al enfado, el llanto, el sentimiento de culpa, la incomprensión, la vergüenza… ¿Cómo no buscar una respuesta en palabras o ideas que han sobrevivido a lo largo de los siglos?</span></p></div>', v_42, 'EPUB/Cómo salvar una mala racha - Marie Robert.epub', '.epub', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Consummatum est' AND Autor = 'César Pérez Gellida') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Consummatum est', 'César Pérez Gellida', 'La pequeña localidad islandesa de Grindavik amanece con todos los miembros de una familia bru­talmente asesinados. En uno de los países del mundo con menor tasa de homicidios por habitante, el comi­sario de la Brigada de Homicidios de Reykjavik, Ólafur Olafsson, se enfrenta al caso más escabroso que ha visto justo en el ocaso de su carrera profesional. Pero muy pronto todas las pistas empiezan a apuntar hacia un sofisticado asesino en serie, Augusto Ledesma, que durante varios años ha ido componiendo una siniestra poética de versos regados de sangre a lo largo y ancho de Europa.
Ante tales evidencias, la INTERPOL decide poner al frente del caso al jefe de la Unidad de Búsqueda In­ternacional de Prófugos, Robert. J. Michelson, que se rodeará de un grupo especial integrado por algunos «viejos conocidos» del asesino.
En Consummatum est el lector asistirá al ansiado desenlace de una trilogía —Versos, Canciones y troci­tos de carne— que ha robado el sueño a quienes leye­ron Memento mori y continuaron recorriendo los la­berintos de la mente criminal con Dies irae. El singular y novedoso estilo narrativo de Pérez Gellida promete no dejar a nadie indiferente en este magistral e im­previsible acto final.', v_155, 'EPUB/Consummatum est - César Pérez Gellida.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El aliento de las Tinieblas' AND Autor = 'Karen Chance') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El aliento de las Tinieblas', 'Karen Chance', 'Cassandra Palmer puede ver el futuro y comunicarse con los espíritus. Los fantasmas de los muertos no son peligrosos normalmente; sólo les gusta hablar… y mucho. Como cualquier chica sensata, Cassie trata de evitar a los vampiros. Pero cuando el mafioso chupasangre del que escapó hace tres años encuentra a Cassie de nuevo, a ella no le queda más remedio que dirigirse al Senado de los vampiros en busca de protección. Cassie se encontrará trabajando con uno de los integrantes más poderosos y atractivos del Senado, un maestro vampiro peligrosamente seductor; y el tributo que él desea puede ser más grande que lo que Cassie está dispuesta a pagar…', v_167, 'EPUB/El aliento de las Tinieblas - Karen Chance.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El legado de la villa de las telas' AND Autor = 'Anne Jacobs') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El legado de la villa de las telas', 'Anne Jacobs', 'Una poderosa familia. Una situación dramática. Una mansión que esconde más de un secreto... La brillante tercera parte de la saga superventas que comenzó con La villa de las telas . Augsburgo, 1920. El estado de ánimo en la villa es optimista respecto al futuro. Paul Melzer ha regresado del frente y toma las riendas de la fábrica decidido a que el negocio familiar recupere su antiguo esplendor. Las cosas van bien incluso para su hermana Elizabeth, que regresa a casa ilusionada con un nuevo amor. Pero «felices para siempre» puede estar aún lejos para los Melzer. Marie, la joven esposa de Paul, quiere cumplir un viejo sueño: tener su propio taller de moda. A pesar de que sus modelos y sus diseños gozan de éxito, su alegría se ve empañada por las constantes discusiones con su marido. Incapaz de soportarlo más, Marie, la mujer que mantuvo a flote la fábrica, la villa y a toda la familia cuando más la necesitaron, toma una dura decisión y abandona la mansión junto a sus hijos. Esta apasionante saga familiar continúa en la cuarta parte Regreso a la villa de las telas. Reseñas de La villa de las telas: «Es una gran historia de amor, con tintes dramáticos y secretos familiares, que nos ha gustado tanto por su calidad literaria como por su preciosismo histórico». Revista Kritica «Una novela histórica muy entretenida que capta el ambiente de comienzos del siglo XX». Fränkische Nachrichten «Amor imposible y las rígidas normas sociales de la Europa central a principios del siglo XX serán el escenario en el que se desenvuelva esta entretenida historia llena de secretos». Jorge Pato García, El Imparcial «Downtown Abbey en Augsburgo». Histo-couch «Este libro lo tiene todo, todo que podríamos desear para un día de lluvia: una gran historia de amor, intriga [...] y un gran secreto familiar». Delmenhorster Kreisblatt «Con su escritura fluida, Anne Jacobs sabe cómo seducir a sus lectoras y transportarlas a la vida de la alta sociedad de hace cien años con todo su glamour pero también con sus sombras». Weilheimer Tagblatt En los blogs... «El estilo ameno y sencillo de la autora, la intensidad de las emociones, la pasión que mueve a sus personajes y el esmerado contexto histórico componen una atractiva lectura, de las que conmueven y cautivan a lo largo de todas sus páginas». Blog Me gustan los libros «Las geniales descripciones de los espacios y la evolución psicológica que nos regala la aclamada autora Anne Jacobs hacen de esta novela toda una delicia que nos lleva a reflexionar sobre la diferencia de clases sociales». Blog La Petita Librería «Una novela de lectura muy viva que despierta rápidamente el interés del lector y en la que este queda atrapado intentando desvelar los múltiples enredos que plantea». Blog Bookeando con Ma Ángeles «La villa de las telas es una saga familiar que atrapa, emocionante y muy entretenida, que me ha hecho disfrutar muchísimo». Blog Adivina quién lee «Las intrigas y los secretos se suceden, como piezas de un puzle, que poco a poco nos permiten vislumbrar una verdad demasiado abrumadora para los habitantes de esa casa». Blog Forjada entre sueños «Ideal para perderse entre sus páginas en una de estas tardes de frío, con todos los ingredientes necesarios para enganchar al más escéptico». Blog Entérate de lo último', v_42, 'EPUB/El legado de la villa de las telas - Anne Jacobs.epub', '.epub', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Mutatis mutandis' AND Autor = 'César Pérez Gellida') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Mutatis mutandis', 'César Pérez Gellida', '«El problema no es el presente, es la pesarosa herencia del pasado y la paupérrima proyección del futuro»
Con esta sentencia contenida en el primer spin off de la trilogía Versos, canciones y trocitos de carne, Armando Lopategui «Carapocha» ofrece su visión de un porvenir que vislumbra ya sombrío.
César Pérez Gellida regala a sus lectores este flashback, una pequeña ventana abierta al pasado de uno de los personajes más relevantes de la trilogía desde la que podremos vislumbrar la génesis del hombre en el que se convertirá, así como su difícil relación con su hija Erika y con su mujer en el preámbulo de la guerra de los Balcanes y al filo de un vuelco radical de su destino.', v_61, 'EPUB/Mutatis mutandis - César Pérez Gellida.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Deseo' AND Autor = 'Adrian Blake') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Deseo', 'Adrian Blake', 'Deseo es el undécimo álbum de estudio de la cantante mexicana Paulina Rubio. Fue lanzado el 14 de septiembre de 2018​ por Universal Spain, marcando su última producción con el sello discográfico Universal Music Group y el primero a siete años de editar Brava! (2011). Colaboró con una multitud de productores y músicos para el disco, entre ellos Mauricio Rengifo, Andrés Torres, los Julca Brothers, Antonio "Toy Selectah" Hernández, Joey Montana, Morat, Nacho, Juan Magán, Xabier San Martin y Alexis & Fido. Deseo es un álbum pop latino con una fuerte vibra del género urbano, aunque mantiene el característico estilo pop rock de la cantante en algunas canciones.
Paulina Rubio empezó a trabajar en un disco inédito a finales de 2014, pero por varias situaciones desconocidas Universal retrasó sus proyectos al grado de publicar sencillos independientes a lo largo de los siguientes dos años. Además, se involucró en su faceta como jueza en diferentes shows de televisión incluyendo la versión mexicana de La Voz, La Voz Kids, la versión estadounidense de The X Factor y La Apuesta.
Inicialmente se lanzaron dos sencillos del álbum: «Desire (Me Tienes Loquita)», una colaboración con Nacho, estrenada el 28 de mayo de 2018, y «Suave y Sutil», lanzada cuatro meses más tarde. El 15 de abril de 2019 se lanzó una edición especial de Deseo que incluía cuatro canciones inéditas, incluyendo el sencillo «Ya No Me Engañas», estrenado solo unos días antes del lanzamiento de la reedición.​ El disco también contiene los sencillos independientes  —lanzados entre 2015 y 2016— «Mi Nuevo Vicio», «Si Te Vas» y «Me Quema».
Tras su lanzamiento, Deseo recibió críticas mixtas por parte de los críticos de música, quienes elogiaron la «energía» de la cantante y su capacidad de adaptarse a los nuevos géneros musicales, pero sintieron que el flujo de las canciones en el disco no tenía ningún sentido ya que la mitad de los temas ya habían sido publicados, por lo que sostuvieron que se trataba más de una «compilación» poco sorprendente. Comercialmente, Deseo tuvo poco impacto en las listas musicales, alcanzando la posición número trece de la lista de Billboard Latin Pop Albums. Pese a ello, obtuvo una certificación de disco de oro en Chile,​ y se embarcó en una gira de conciertos en los Estados Unidos.', v_38, 'EPUB/Deseo - Adrian Blake.pdf', '.pdf', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Mi jugada perfecta' AND Autor = 'A.S. Lefebre') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Mi jugada perfecta', 'A.S. Lefebre', '<div> <p style="font-family: ''Amazon Ember'',''Arial'',''sans-serif''; font-weight: 600; font-size: 14px; background-color: #ffffff"><span style="color: #333333">Segunda entrega de la serie «Apostando al amor».</span></p> <p style="font-family: ''Amazon Ember'',''Arial'',''sans-serif''; font-weight: 600; font-size: 14px; background-color: #ffffff"><span style="color: #333333">Dos corazones dispuestos a luchar por su amor contra el estatus social.</span></p> <p style="font-family: ''Amazon Ember'',''Arial'',''sans-serif''; font-weight: 600; font-size: 14px; background-color: #ffffff"><span style="color: #333333">¿Podrá el amor ir más allá de los límites que marca la aristocracia?</span></p> <p style="font-family: ''Amazon Ember'',''Arial'',''sans-serif''; font-size: 14px; background-color: #ffffff"><strong style="color: #333333">Andrew Miller</strong><span style="color: #333333"> había jurado no enamorarse nunca, ya que en el pasado una mujer lo había traicionado con su hermano y su mejor amigo. Pero su juramento se viene abajo cuando conoce a una humilde joven de ojos grises de la cual queda perdidamente enamorado, sin saber sus orígenes ni su estatus social.</span></p> <p style="font-family: ''Amazon Ember'',''Arial'',''sans-serif''; font-size: 14px; background-color: #ffffff"><strong style="color: #333333">Clara Williams</strong><span style="color: #333333"> era la doncella, pero también la mejor amiga, de Katherine Rushmore, hija de condes, quien insiste en hacerle un pequeño lugar en sociedad. Tras una salida, Clara conoce al hombre que le robará su corazón..., pero este será un amor imposible.</span></p> <p style="font-family: ''Amazon Ember'',''Arial'',''sans-serif''; font-size: 14px; background-color: #ffffff"><span style="color: #333333; background-color: #ffffff">Después de varios encuentros casuales Andrew decide confesar sus sentimientos a Clara sin tener en cuenta sus orígenes, por lo que ella huye y empieza a evitarlo por temor a ser rechazada, ya que él es un noble y ella una simple sirvienta.</span></p> <p style="font-family: ''Amazon Ember'',''Arial'',''sans-serif''; font-size: 14px; background-color: #ffffff"><span style="color: #333333; background-color: #ffffff">Dos años después, Andrew regresa en busca de Clara y esta decide confesarle su verdad, lo cual los lleva a luchar contra todas las reglas sociales y a enfrentar a sus familias para así realizar una jugada perfecta en la que el amor será el vencedor.</span></p></div>', v_42, 'EPUB/Mi jugada perfecta - A.S. Lefebre.epub', '.epub', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '(Fjallbacka 06) La sombra de la sirena' AND Autor = 'Camilla Lackberg') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('(Fjallbacka 06) La sombra de la sirena', 'Camilla Lackberg', 'Un hombre desaparece en Fjällbacka sin dejar rastro. Pese a que Patrik Hedström y sus colegas de la policía han hecho cuanto han podido para encontrarlo, nadie sabe si está vivo o muerto. Al cabo de tres meses, lo encuentran finalmente congelado en el hielo. Cuando averiguan que el escritor Christian Thydell, uno de los amigos de la víctima, lleva más de un año recibiendo cartas anónimas plagadas de amenazas, todo se complica. Christian trata de restarle importancia, pero su amiga Erica Falck, quien lo ayudó en la escritura de su primera novela “La sombra de la Sirena”, es consciente del peligro. La policia no tarda en comprender que el asesinato y las cartas, están relacionados.', v_39, 'EPUB/(Fjallbacka 06) La sombra de la sirena - Camilla Lackberg.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El silencio de tu nombre' AND Autor = 'Andrés Pérez Domínguez') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El silencio de tu nombre', 'Andrés Pérez Domínguez', 'CuandoErika Walter, viuda de un agente secreto alemán, huye a Madrid con unimportante legajo de documentos que implican a altos cargos nazis en el exilio,su amante Martín Navarro, ex miembro del PCE, se ve obligado a abandonar Parísy perseguirla. Aunque sabe que en España le espera la cárcel si es capturadopor la policía franquista o la muerte por traición si sus camaradas del partidole descubren, Martín lo arriesgará todo, incluso sus convicciones ideológicas,por volver a reunirse con Erika. Con la policía, los nazis, los comunistas y laCIA pisándoles los talones, ambos amantes se verán envueltos en una trama deespionaje e intereses ocultos más compleja y peligrosa de lo que nunca hubieranimaginado. Plagadade espías desencantados, idealistas convencidos y héroes a su pesar, Elsilencio de tu nombre aúna historia, aventura, intriga y romance.Una novela que refleja con maestría cómo en una Europa arrasada por laintolerancia y el fanatismo político y hay lugar para el amor, la amistad, elhonor y la esperanza.', v_139, 'EPUB/El silencio de tu nombre - Andrés Pérez Domínguez.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Días de perros' AND Autor = 'Gilles Legardinier') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Días de perros', 'Gilles Legardinier', 'Cansado de vivir en un mundo en el que no encuentra su lugar, el millonario Andrew Blake decide dar un giro radical a su vida: deja su Londres natal y se marcha al campo en Francia… ¡A trabajar como mayordomo! Pero cuando llega a Beauvillier, nada sale como tenía previsto. Las relaciones entre los particulares habitantes de la mansión están llenas de malentendidos y situaciones absurdas, así que Andrew no tiene otra opción que intentar poner orden en esta caótica casa y hacerse amigo de Méphisto.', v_58, 'EPUB/Días de perros - Gilles Legardinier.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El retorno del mundo de Marco Polo' AND Autor = 'Robert D. Kaplan') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El retorno del mundo de Marco Polo', 'Robert D. Kaplan', '<div><span style="color: rgb(51, 51, 51); font-family: Arial, sans-serif; font-size: 14px; orphans: 2; widows: 2; background-color: rgb(255, 255, 255);">A finales del siglo XIII, Marco Polo emprendió un largo viaje hacia Oriente, siguiendo una Ruta de la Seda por la que Europa extendería su influencia. En las primeras décadas del siglo XXI, el sentido de esta ruta está cambiando y el poder en el escenario internacional se está moviendo. Nuevas potencias emergentes luchan por imponerse, mientras que los países que antiguamente dominaban el mundo se enfrentan a nuevos desafíos.</span><br style="color: rgb(51, 51, 51); font-family: Arial, sans-serif; font-size: 14px; orphans: 2; widows: 2; background-color: rgb(255, 255, 255);"><span style="color: rgb(51, 51, 51); font-family: Arial, sans-serif; font-size: 14px; orphans: 2; widows: 2; background-color: rgb(255, 255, 255);">Con su habitual clarividencia, Robert D. Kaplan analiza en esta recopilación de artículos el mundo que nos espera: desde las difíciles decisiones que deberá tomar Estados Unidos en un futuro próximo hasta los dilemas de la Unión Europea, pasando por los movimientos estratégicos de países como Irán o India, o por el puente que está construyendo China hacia Europa.</span></div>', v_42, 'EPUB/El retorno del mundo de Marco Polo - Robert D. Kaplan.epub', '.epub', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Las huellas imborrables' AND Autor = 'Camilla Läckberg') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Las huellas imborrables', 'Camilla Läckberg', 'El secreto de una joven en los años cuarenta.Un nuevo caso trepidante de Erica Falck y Patrik Hedström.El verano llega a su fin y la escritora Erica Falck vuelve al trabajo tras la baja de maternidad. Ahora le toca a su compañero, el comisario Patrik Hedström, tomarse un tiempo libre para ocuparse de la pequeña Maja. Pero el crimen no descansa nunca, ni siquiera en la tranquila ciudad de Fjällbacka, y cuando dos adolescentes descubren el cadáver de Erik Frankel, Patrik compaginará el cuidado de su hija con su interés por el asesinato de este historiador especializado en la Segunda Guerra Mundial. Mientras tanto, Erica hace un sorprendente hallazgo: diarios de su madre Elsy, con quien tuvo una relación difícil, junto con una antigua medalla nazi. Pero lo más inquietante es que, poco antes de la muerte del historiador, Erica había ido a su casa para obtener más información sobre la medalla. ¿Es posible que su visita desencadenara los acontecimientos que condujeron a su muerte?En Las huellas imborrables Camilla Läckberg entreteje con maestría una historia contemporánea con la vida de una joven en la Suecia de 1940. Escrita con numerosos flashbacks, en esta novela Erica Falck debe adentrarse en el oscuro pasado de su propia familia.', v_228, 'EPUB/Las huellas imborrables - Camilla Läckberg.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El highlander oscuro' AND Autor = 'Karen Marie Moning') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El highlander oscuro', 'Karen Marie Moning', 'Dageus McKeltar había viajado a través del tiempo desde su Escocia natal del siglo XV para salvar la vida de su hermano. Sin embargo, un maleficio había caído sobre él, y sólo en los antiguos manuscritos de los druidas escoceses podía encontrar la forma de deshacerlo. Pero en la Nueva York del siglo XXI, entre museos y colecciones privadas, conocerá a la bella experta en antigüedades Chloe Zanders, y en ese momento empezará a intuir que su salvación quizá no esté donde siempre había pensado.', v_37, 'EPUB/El highlander oscuro - Karen Marie Moning.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Más allá del espejo' AND Autor = 'John Connolly') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Más allá del espejo', 'John Connolly', 'Algo malsano flota todavía en el interior de la Casa Grady. En esa tenebrosa casa, perdida en las lindes de un denso bosque y de cuyas paredes cuelgan tal vez demasiados espejos, ocurrieron hechos atroces. Allí su dueño, John Grady, asesinó a varios niños tras secuestrarlos. Años después, el padre de una de las víctimas, que compró la casa para que nadie olvidara los crímenes cometidos en ella, tiene indicios de que una niña desconocida podría estar en peligro. Y acude a Charlie Parker para que evite una tragedia. El detective, que no duda en aceptar el caso, va en busca de todos los que conocieron a John Grady. Quizá logre así descubrir qué secretos oculta todavía la casa, aunque eso suponga atraerse la ira de esos seres espectrales que acuden siempre a la llamada del Mal.', v_42, 'EPUB/Más allá del espejo - John Connolly.epub', '.epub', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El último fado (Novela)' AND Autor = 'Concepción Valverde') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El último fado (Novela)', 'Concepción Valverde', 'Desde niña, Amalia vive obsesionada por la muerte de una de sus tías, a la que no llegó a conocer pero de la que lleva su nombre. El entorno en el que vive se presta a la especulación, ya que sus tres tías acostumbran a convertir la realidad en algo confuso y plagado de contradicciones. En una elegante casa de familia bien venida a menos, todo es controlado con mano férrea por la tía Celia, que esconde un secreto que la protagonista descubrirá, y que no dudará en relacionar con esa misteriosa y no aclarada muerte.
Aunque lo que más angustia a la joven es no saber apenas nada de sus padres, a los que perdió a los pocos meses de nacer. Desde entonces, la tía Celia ha urdido una sucesión de falsedades en torno a su origen que han hecho que Amalia se vea obligada a buscar la verdad por sí misma. Cuando con dieciséis años creía haber superado sus antiguos temores, la protagonista encontrará un diario que la hará regresar a ese mórbido universo familiar, en el que cada nuevo dato está a su vez envuelto en el misterio. Las diversas incógnitas se irán despejando paulatinamente hasta llegar al último recodo de esta novela, en el que una revelación inesperada imprimirá un definitivo giro al relato.

"El último fado" mantiene en vilo al lector a lo largo de sus páginas, sin darle tregua para recuperarse. En esta asombrosa obra conviven rasgos del género policíaco con los de la narrativa psicológica, en una hábil mezcolanza que provoca el aplauso a su conclusión.​', v_154, 'EPUB/El último fado (Novela) - Concepción Valverde.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'La novia se va a Irlanda' AND Autor = 'Carlota Manzano') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('La novia se va a Irlanda', 'Carlota Manzano', '<div>
<p style="font-family: ''Amazon Ember'',''Arial'',''sans-serif''; font-size: 14px"><span style="color: #333333; background-color: #ffffff">Andrea entra en la iglesia del brazo de su padre para casarse cuando no puede creer lo que ven sus ojos… El pasado a menudo nos persigue y a veces lo hace en los lugares más insospechados y en las situaciones más variopintas. De lo que decida en ese momento van a depender su futuro y el de su bebé, Lorcan. La mirada de su déspota progenitor no la ayuda, pero ¿será capaz de tomar una decisión que suponga una vuelta de tuerca brutal para sus vidas?</span></p></div>', v_98, 'EPUB/La novia se va a Irlanda - Carlota Manzano.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Apostando al destino' AND Autor = 'A. S. Lefebre') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Apostando al destino', 'A. S. Lefebre', '<div>
<p>Llega la tercera entrega de la serie «Apostando al amor». Un amor verdadero, un pasado triste y una apuesta al destino. Elizabeth Jones, después de la desaparición de su esposo y tras encontrar una carta en donde se entera de que su familia materna la buscó por años y está en Inglaterra, decide embarcarse para buscar su destino, a su familia y a su desaparecido esposo. No solo encuentra amigos que la ayudan, sino unos ojos color esmeralda que se convierten en el amor de su vida. Eduardo Rushmore, quien había decidido no casarse nunca al menos por amor, pues quien creía que había sido el amor de su vida era feliz con su familia, una noche, en un baile de máscaras, conoce a una misteriosa dama de acento extranjero. Jura que es un ángel, y queda perdido en su mirada azul claro. Cuando Eduardo llega a creer que su nuevo título es una maldición porque todos insisten en que debe casarse y por otras situaciones más, se encuentra cara a cara con su ángel, ambos se dan cuenta de que su amor es correspondido. Pero ella guarda un secreto: está casada. ¿Podrán ganar su apuesta al destino para al fin poder estar juntos y llevar a cabo su amor?</p></div>', v_49, 'EPUB/Apostando al destino - A. S. Lefebre.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Más gente tóxica' AND Autor = 'Bernardo Stamateas') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Más gente tóxica', 'Bernardo Stamateas', 'Tras el esperado éxito del libro que ha revolucionado el mundo de la autoayuda, Bernardo Stamateas nos brinda una nueva oportunidad para reconocer los prototipos tóxicos que nos rodean al tiempo que nos desvela las claves de su personalidad, a fin de reconocerlos y librarnos de ellos. Después de explicarnos cómo distinguir y neutralizar al envidioso, al descalificador, al neurótico y al manipulador, entre otros, Stamateas descubre, en Más gente tóxica, cómo comportarse ante, por ejemplo, el triangulador, el miedoso, el obsesivo, el masoquista, el prepotente, el negativo, entre otros.
«Muchas veces permitimos entrar en nuestro círculo más íntimo a “gente tóxica”, personas equivocadas que permanentemente evalúan lo que decimos y lo que hacemos, o lo que no hacemos».
Se trata de «personas tóxicas» que potencian nuestras debilidades y nos llenan de cargas y frustraciones.
«Ser tóxico es una forma de vivir, de pensar y de actuar; es una manera de funcionar. Mientras todos tratamos de corregir los rasgos tóxicos que percibimos en nosotros mismos, la “persona tóxica” no los reconoce y vive echando la culpa a los demás, robando su energía. Son adictos emocionales que necesitan hacer sentir mal al otro para sentirse bien ellos». Bernardo Stamateas.', v_25, 'EPUB/Más gente tóxica - Bernardo Stamateas.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Las aventuras de Alfred y Agatha 2: El chelín de plata.' AND Autor = 'Ana Campoy') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Las aventuras de Alfred y Agatha 2: El chelín de plata.', 'Ana Campoy', '¿Qué hubiera ocurrido si Alfred Hitchcock y Agatha Christie se hubieran conocido de niños? ¿Qué aventuras habrían vivido? ¿Qué sorprendentes casos habrían resuelto juntos? Las aventuras de Alfred&Agatha nos muestra cómo podría haber sido la amistad de infancia de los dos maestros del suspense más importantes de nuestro tiempo. Como recompensa por sus buenas notas, Alfred recibe un auténtico chelín de plata de parte de su padre. Orgulloso de su regalo, el niño acude a casa de Agatha para enseñárselo, pero su amiga tiene reservada para él otra sorpresa: va a presentarle a su honorable vecino, el escritor Sir Arthur Conan Doyle, creador de las novelas de Sherlock Holmes. Alfred queda encantado tras la visita, en cambio Morritos Jones está muy enfadada. Tras un duro enfrentamiento con la perrita, el chico se marcha a casa muy disgustado, pero a la mañana siguiente, cuando todo parece haber vuelto a la normalidad, ya es demasiado tarde. Morritos ha desaparecido sin dejar rastro.', v_42, 'EPUB/Las aventuras de Alfred y Agatha 2 El chelín de plata. - Ana Campoy.epub', '.epub', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Aniquilación' AND Autor = 'Jeff VanderMeer') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Aniquilación', 'Jeff VanderMeer', 'En un futuro no determinado, el Área X es un lugar remoto y escondido declarado zona de desastre ambiental desde hace décadas. La naturaleza salvaje ha conquistado el lugar y su acceso está prohibido. La agencia estatal Southern Reach ha enviado diversas expediciones pero casi siempre han fracasado: todos los miembros de una expedición se suicidaron; otros enloquecieron y acabaron matándose entre sí, y los integrantes de la última expedición regresaron convertidos en sombras de lo que un día fueron. Ésta es la expedición número doce. El grupo está compuesto por cuatro mujeres: una antropóloga, una topógrafa, una psicóloga y la narradora, una bióloga. Su misión es cartografiar el terreno y recolectar muestras, anotar todas sus observaciones tanto de su entorno como de sus compañeras. Pronto descubren una gran anomalía geográfica y formas de vida más allá de todo entendimiento. Mientras se enfrentan a una naturaleza tan bella como claustrofóbica, el pasado y los secretos con los que cruzaron la frontera se vuelven cada vez más amenazantes. Aniquilación es el primer volumen de la Trilogía Southern Reach, una serie que crea un mundo como nunca has imaginado y que nos enfrenta al extraño que se esconde dentro de nosotros mismos.', v_185, 'EPUB/Aniquilación - Jeff VanderMeer.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Chicos que muerden' AND Autor = 'Mari Mancusi') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Chicos que muerden', 'Mari Mancusi', 'Cuando Sunny McDonnald se ve arrastrada al Club Colmillo por su hermana gemela, Rayne, no espera encontrar nada más aparte de un puñado de niños góticos que juegan a ser vampiros. Pero cuando un tío confunde a Sunny con su hermana, amante del lado oscuro, y la muerde en el cuello, averigua que sus colmillos son reales… y mortales. Ahora Sunny tiene menos de una semana para descubrir cómo invertir los efectos del mordisco, o de lo contrario acabará igual que los no muertos. Y no solo se convertirá en vampiro, sino que también estará atada a Magnus, el chupasangre que la mordió, para siempre. Y para siempre es mucho tiempo...', v_132, 'EPUB/Chicos que muerden - Mari Mancusi.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Tumbas Sin Nombre' AND Autor = 'Administrador') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Tumbas Sin Nombre', 'Administrador', NULL, v_42, 'EPUB/Tumbas Sin Nombre - Administrador.epub', '.epub', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'La hermana sombra' AND Autor = 'Lucinda Riley') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('La hermana sombra', 'Lucinda Riley', 'La hermana sombra es el tercer libro de la serie basada en la mitología griega y en la astrología, Las Siete Hermanas, de la autora superventas mundial Lucinda Riley. Siete hermanas, siete destinos, un padre con un pasado misterioso... Star D''Aplièse se encuentra en una encrucijada tras la repentina muerte de su padre, el misterioso millonario Pa Salt. Ha dejado a cada una de sus seis hijas una pista sobre sus orígenes, pero Star, la más enigmáticade todas, tiene serias dudas sobre la necesidad de aventurarse y perder la seguridad que la estrecha relación con su hermana CeCe le brinda. A la desesperada decide seguir la pista, que la conduce a una librería de antiguo en Londres y al comienzo de un nuevo mundo para ella. Hace cien años Flora MacNichol jura que nunca se casará. Se siente feliz y segura en su casa en el Lake District cerca de Beatrix Potter, a quien idolatra. Pero se ve arrastrada contra su voluntad hasta Londres, a la casa de una de las personas más influyentes de la sociedad eduardiana: Alice Keppel, la amante más famosa de Eduardo VII, el hijo mayor de la reina Victoria. Flora se debate entre el amor apasionado y la obligación hacia su familia al mismo tiempo que se siente como un peón en juego ajeno, cuyas reglas solo conocen otros, hasta que el encuentro fortuito con un misterioso caballero le proporciona las respuestas que Flora ha estado esperando toda su vida. Si quieres saber más, incluso sobre mitología griega, las Pléyades, las esferas armilares..., visita la web de Lucinda Riley en español: esp.lucindariley.co.uk. También encontrarás documentación sobre Beatrix Potter, Kent, el distrito de los lagos, Violet y Sonia Keppel y Alice Keppel. Reseñas: «La serie "Las Siete Hermanas" es romántica, arrolladora, lujosa y glamurosa.» The Daily Mail «Un libro brillante que no puedes dejar, lleno de glamour y romance.» The Daily Mail «Riley es una experta contadora de historias románticas, que trama con habilidad la historia con la ficción. Un relato absorbente y fascinante.» Booklist En los blogs... «Me ha parecido un libro fantástico y la verdad es que creo que Lucinda es una buena escritora, ya que los tres libros que he leído de ella me han fascinado.» Blog Tesorera de libros «La mezcla perfecta de mitología griega, astrología, romance y novela contemporánea.» Blog El cuervo de las alas rotas «La tercera entrega está a la altura y promete que la siguiente va a ser interesante al acompañar a la cuarta hermana en la búsqueda de su pasado y su identidad.» Blog Viaja gracias a los libros', v_42, 'EPUB/La hermana sombra - Lucinda Riley.epub', '.epub', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Wanted' AND Autor = 'Lou Carrigan') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Wanted', 'Lou Carrigan', 'Antonio Vera Ramírez (n. 2 de julio de 1934 en Barcelona, Cataluña) es un prolífico escritor español conocido por su seudónimo Lou Carrigan que utilizó para escribir tanto novelas de aventuras, del oeste como de ciencia-ficción. Ha utilizad,o entre otros, los seudónimos de Angelo Antonioni, Crowley Farber, Mortimer Cody, Lou Flanagan, Anthony Hamilton, Sol Harrison, Anthony Michaels, Anthony W. Rawer, Angela Windsor y Giselle (muchos de ellos con variaciones de su propio nombre). En 1959 apareció su primer western:: Un hombre busca a otro hombre, y creó su seudónimo más afamado Lou Carrigan. Su producción supera las 1.000 novelas, de las cuales 500 pertenecen a la serie de la periodista y espía Brigitte Baby Montfort. León Klimovsky llevó al cine una novela suya con el título de No importa morir. Al menos otras cuatro películas están basadas en sus novelas. Su hermano Francisco Vera Ramírez, también escribió novelas como Ducan M. Cody y Mortimer Cody..', v_191, 'EPUB/Wanted - Lou Carrigan.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Asesinato' AND Autor = 'P.H. Ubeda') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Asesinato', 'P.H. Ubeda', 'Samuel Benton achicó los ojos cuando los dirigió hacia el cielo. No le estaba gustando nada aquel repentino cambio de color, pues del azul claro había, pasado casi en un cuarto de hora a ser gris. Las nubes se estaban adueñando de él y el sol había desaparecido por completo. No tuvo otro remedio que liarse a latigazos con aquellas muías perezosas que parecían ir de paseo a no ser que prefiriera llegar al rancho empapado y con el género que llevaba en la carreta echado a perder.', v_218, 'EPUB/Asesinato - P.H. Ubeda.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El toque del highlander' AND Autor = 'Karen Marie Moning') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El toque del highlander', 'Karen Marie Moning', 'El señor del castillo de Brodie era un poderoso guerrero escocés, un habitante de un mundo regido por leyes ancestrales y una antigua magia. Sin embargo, ninguno de sus poderes inmortales podía prepararle para el encuentro con aquella encantadora y maldita muchacha llamada Lisa, que se hallaba de pie ante él en su habitación, procedente de un lejano e imposible siglo XXI. Un terrible truco mágico del destino la había transportado en el tiempo a través de siete siglos, sólo para tentarlo con su fascinante y arrebatadora belleza, un arma frente a la que él, con todo su poder, no logrará resistirse. Y aunque Lisa no tenía intención alguna de permanecer en esa tierra salvaje desgarrada por la traición y la guerra, pronto descubrió que su captor tenía otros planes para ella... unos planes que la iban a salvar de un trágico destino.', v_37, 'EPUB/El toque del highlander - Karen Marie Moning.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Un océano para llegar a ti' AND Autor = 'Sandra Barneda') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Un océano para llegar a ti', 'Sandra Barneda', '<div>
<p style="font-size: 14px; font-weight: 600; font-family: ''Amazon Ember'',''Arial'',''sans-serif''"><span style="color: #000000">Una novela tierna y atrevida sobre los secretos familiares y las emociones silenciadas.</span></p>
<p style="font-size: 14px; font-family: ''Amazon Ember'',''Arial'',''sans-serif''"><span style="color: #000000">Tras la muerte de su madre, Gabriele vuelve al pueblo de los veranos de su infancia. Allí le espera su padre, con el que no habla desde hace años. Juntos se disponen a cumplir el último deseo de Greta: que las tres personas más importantes de su vida ―su marido, su única hija y su cuñada― esparzan sus cenizas en un lugar donde fueron felices. Los secretos que Greta desvela en las cartas que deja a su familia terminarán con el silencio entre padre e hija y, como en un dominó, alterarán la vida de todos y propiciarán un encuentro inesperado que hará que Gabriele descubra que en la vulnerabilidad se halla la magia de la vida.</span></p>
<p style="font-size: 14px; font-weight: 600; font-family: ''Amazon Ember'',''Arial'',''sans-serif''"><span style="color: #000000">¿Y si el destino de las personas tendiera un hilo invisible que las conecta con aquellos que deben encontrar? ¿Y si la vida solo fuera un viaje para encontrarlos?</span></p></div>', v_42, 'EPUB/Un océano para llegar a ti - Sandra Barneda (2).epub', '.epub', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El límite del placer' AND Autor = 'Eve Berlin') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El límite del placer', 'Eve Berlin', 'Erotica author Dylan Ivory meets the man who is everything she ever wanted. Alec Walker writes dark thrillers and extends them into the bedroom. The only thing he fears is true love. Slowly, Alec shows her that by letting go and submitting to his every desire she can experience the ultimate pleasure. But to keep her, can Alec take the risk and surrender his heart?', v_192, 'EPUB/El límite del placer - Eve Berlin.mobi', '.mobi', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Muuu' AND Autor = 'David Safier') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Muuu', 'David Safier', '¡Muuu!, de David Safier, autor de otras obras de la narrativa de humor como Jesús me quiere o Una familia feliz, es una divertidísima fábula protagonizada, al igual que Maldito karma, por animales; y con los mismos ingredientes que hicieron de esta novela un éxito: optimismo y mucho sentido del humor. ¡Muuu! es una divertidísima novela protagonizada por una heroína conmovedora que lucha por hacer realidad sus sueños: la felicidad y el amor. David Safier es todo un fenómeno literario.Lolle, una vaca del norte de Alemania, pasa por una etapa bastante mala: no sólo ha descubierto que su queridísimo toro Champion la engaña con esa vaca idiota de Susi. No, además se ha enterado de que el agricultor quiere vender la finca y que todas las vacas del rebaño acabarán entre dos rebanadas de pan. Pero aún hay esperanza. Un gato italiano de mundo le dice que existe un paraíso para las vacas: ¡la India! De manera que Lolle decide poner pies en polvorosa esa misma noche con sus dos mejores amigas y emprender el peligroso viaje hacia la tierra prometida. Situaciones delirantes y una particular filosofía de vida.', v_73, 'EPUB/Muuu - David Safier.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '(Trilogía Versos, Canciones Y Trocitos De Carne 02) Dies Irae(c.1)' AND Autor = 'Cesar Perez Gellida') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('(Trilogía Versos, Canciones Y Trocitos De Carne 02) Dies Irae(c.1)', 'Cesar Perez Gellida', 'La acción de este thriller implacable arranca en la peculiar ciudad italiana de Trieste, frontera entre dos mundos. Augusto Ledesma elige el que fuera hogar de James Joyce como primer escenario para continuar su siniestra obra, que alimenta del aliento de sus víctimas y de la humillación de sus perseguidores. Hasta allí se trasladará el inspector Ramiro Sancho en su frenética y obsesiva persecución de un asesino en serie que parece haber acentuado su voracidad. Entretanto, al otro lado de la frontera, el psicólogo criminalista y exagente del KGB Armando Lopategui, «Carapocha», recorrerá las calles de Belgrado junto a su hija y ahora discípula con el propósito de zanjar cuentas con un pasado despiadado del que no logra despojarse. En otra vuelta de tuerca, a través de fugaces viajes en el tiempo, descubriremos cómo se fraguó la relación entre Pílades y Orestes y asistiremos a su sorprendente desenlace. Tras el rotundo éxito de Memento mori, primera parte de la trilogía Versos, canciones y trocitos de carne, César Pérez Gellida nos conduce de nuevo por los complejos laberintos que conforman la mente criminal desde los ojos de sus protagonistas, ya sean víctimas, asesinos en serie, genocidas o quienes les persiguen. El inesperado desarrollo de los acontecimientos obligará al lector a pasar páginas en una ineludible búsqueda de respuestas. Haciendo gala de un particular estilo cinematográfico aclamado por la crítica literaria, el autor nos envuelve en una trama adictiva, tejida a partir de un argumento sólido y pespunteado de poemas y canciones que componen una singular banda sonora del crimen.', v_228, 'EPUB/(Trilogía Versos, Canciones Y Trocitos De Carne 02) Dies Irae(c.1) - Cesar Perez Gellida.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Huida mortal' AND Autor = 'P. J. Tracy') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Huida mortal', 'P. J. Tracy', 'Grace MacBride y Annie Belinsky, fundadoras de Monkeewrench, una exitosa empresa informática que presta sus servicios a la policía para resolver diversos casos, acompañadas de Sharon Mueller, una agente del FBI, viajan a Green Bay, Wisconsin, con el fin de seguir la pista de un nuevo asesino en serie. A medio camino, sufren una avería en su coche, en mitad de una zona boscosa, aparentemente alejada de cualquier tipo de civilización, incomunicada. Después de andar un buen rato por caminos intransitados, llegan a la población de Four Corners, donde esperan poder hallar a alguien que les ayude a reemprender la marcha; sin embargo, lo que encontrarán es… absolutamente nada. Four Corners parece una ciudad fantasma, un lugar que carece completamente de vida: ningún sonido, ningún medio de comunicación en funcionamiento, nada, sólo restos de una vida que ya no está. En esa ausencia de vida, de repente, serán testigos, como salido de ningún lugar, de un brutal doble asesinato. A partir de ese momento, y sin comprender muy bien qué es lo que realmente ha sucedido, emprenden una huida incierta para salvar sus vidas. Mientras tanto, en el resto del grupo Monkeewrench crece la inquietud por la desaparición de las mujeres, y con la compañía de dos policías de Mineápolis, Leo Magozzi y Gino Rolseth, inicial una búsqueda a ciegas, sin pistas ni señales.', v_27, 'EPUB/Huida mortal - P. J. Tracy.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'La curandera de Atenas' AND Autor = 'Isabel Martín') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('La curandera de Atenas', 'Isabel Martín', '«Una mujer vendida como esclava se convierte en discípula de Hipócrates, el médico más aclamado de la Historia».Siglo V a.C. Helena, hija del filósofo Empédocles, es secuestrada en Sicilia y, tras un largo viaje, vendida en Atenas a Aspasia de Mileto, amante de Pericles. Allí conocerá a Hipócrates, uno de los más afamados médicos de la antigua Grecia, cuya sabiduría ha llegado hasta nuestros días. Junto a él se introducirá en el mundo de la sanación y del verdadero amor. De esclava a hetaira, de hereje a curandera, el personaje de Helena nos muestra en esta novela el momento cumbre de la Atenas clásica, una ciudad por la que en este periodo desfilan los más ilustres filósofos y donde la democracia siembra sus primeras semillas. La curandera de Atenas narra los inicios de la medicina a través de un personaje sensual y fascinante.', v_26, 'EPUB/La curandera de Atenas - Isabel Martín.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El redentor' AND Autor = 'Jo Nesbø') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El redentor', 'Jo Nesbø', 'En pleno centro de Oslo, durante la celebración de un concierto navideño, un inocente cae abatido a manos de un pistolero que parece haber errado el tiro. Sin móvil aparente, sin sospechoso y sin arma homicida, el inspector Harry Hole deberá enfrentarse a uno de los casos más desconcertantes de su carrera. Pero pronto la situación dará un temible vuelco: el asesino parece empeñado en saldar su error dando con su auténtica víctima. La ciudad se convertirá entonces en un inmenso tablero en que asesino y policía jugarán una partida a contrarreloj. ¿A quién persigue realmente el criminal? ¿Qué relaciona su san-grienta misión con el rapto de una niña doce años atrás? A medida que el cerco sobre el volátil homicida se vaya estrechando, Hole irá tomando conciencia de que cada segundo puede llegar a contar más que toda una vida.', v_111, 'EPUB/El redentor - Jo Nesbø.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Aguas oscuras' AND Autor = 'Robert Bryndza') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Aguas oscuras', 'Robert Bryndza', '<div><p>Tercer libro de la serie de la detective Erika Foster. Por el autor del best seller internacional Te vere bajo el hielo. La detective Erika Foster recibe un aviso de que la clave para resolver un importante caso de narcoticos esta escondida en una cantera abandonada en las afueras de Londres, por lo que ordena que sea registrada. Alli, entre el lodo espeso, encuentran un alijo de droga, pero tambien lo que parece ser el esqueleto de un nino pequeno. Los restos se identifican como los de Jessica Collins, de siete anos, la chica desaparecida que copo los titulares hace veintiseis anos. Mientras Erika trata de juntar las nuevas pruebas con las antiguas, tambien indaga mas sobre el pasado de la familia Collins y se pone en contacto con la principal detective del caso en aquella epoca, Amanda Baker, una mujer atormentada por el fracaso de no haber encontrado a Jessica Collins en su momento. Pero alguien guarda terribles secretos. Alguien que no quiere que este caso sea resuelto y que hara todo lo que este en sus manos para evitar que Erika descubra la verdad. / Detective Erika Foster learns that key evidence for a major narcotics case was stashed in a disused quarry on the outskirts of London and has it searched. The thick sludge contains the drugs, and also the skeleton of a young child, quickly identified as that of Jessica Collins, vanished twenty-six years ago.</p>
<p>**</p></div>', v_35, 'EPUB/Aguas oscuras - Robert Bryndza.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'La piedra del destino' AND Autor = 'Rober H. L. Cagiao') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('La piedra del destino', 'Rober H. L. Cagiao', '<div>
<p style="font-family: ''Arial'',''sans-serif''; font-size: 14px"><span style="color: #333333; background-color: #ffffff">II Volumen de la Saga de El Guardián de las Flores: La muerte, recreada en pueblos malditos que han sido arrasados por la gran epidemia de Peste del siglo XVIII, conducirá al lector a un reencuentro inesperado: Rianxo, el Castelo Lúa, la Torre de Hércules, Castelao… La comisaria Paola Gómez y su equipo, se enfrentan al más difícil de los casos. Todo enmascarado entre enigmas, acertijos, poemas, leyendas y un enemigo implacable. Una novela policíaca de acción, misterio, suspense, magia y corrupción que se mezclan y dan lugar a esta segunda aventura de la saga El Guardián de las Flores, en la que el lector irá descubriendo, junto a sus personajes, quién está detrás de toda la trama.</span></p></div>', v_42, 'EPUB/La piedra del destino - Rober H. L. Cagiao.epub', '.epub', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Los cien errores de ortografía más frecuentes en el idioma español: Manual de Consulta Interactivo' AND Autor = 'Mónica Castro Plaza') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Los cien errores de ortografía más frecuentes en el idioma español: Manual de Consulta Interactivo', 'Mónica Castro Plaza', '<p class="description">Los cien errores mas frecuentes en ortografia y las reglas que aplican para corregirlos definitivamente.</p>', v_195, 'EPUB/Los cien errores de ortografía más frecuentes en el idioma español - Manual de Consulta Interactivo - Mónica Castro Plaza.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'S.E.C.R.E.T. 1' AND Autor = 'L. Marie Adeline') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('S.E.C.R.E.T. 1', 'L. Marie Adeline', 'As young widow, Cassie’s life is filled with sadness and regret. She waits tables at the rundown Café Rose in New Orleans, heading home alone each night, yearning for more from her life and wishing she could make it happen. But when Cassie discovers a notebook left behind by a mysterious woman at the café, her world is changed forever. The notebook’s stunningly explicit confessions shock and fascinate Cassie, and eventually lead her to S·E·C·R·E·T, an underground society dedicated to helping women realize their wildest, most intimate sexual fantasies. At the heart of the society is three rules: NO JUDGEMENTS. NO LIMITS. NO SHAME. As Cassie is set free from her inhibitions, she is transformed by the confidence and passion she’s kept buried deep inside. But can she find the courage to reveal this new side of herself to the one man she never thought she could have? An irresistible, erotically charged story, perfect for fans of E. L. James’ Fifty Shades of Grey trilogy and Sylvia Day’s Bared to You.', v_192, 'EPUB/S.E.C.R.E.T. 1 - L. Marie Adeline.mobi', '.mobi', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '(Helsinki 1) Tres abuelas y un cocinero muerto' AND Autor = 'Minna Lindgren') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('(Helsinki 1) Tres abuelas y un cocinero muerto', 'Minna Lindgren', 'Tienen 90 años. Pero no piensan morirse hasta descubrir al asesino. Siiri, Irma y Anna-Liisa son tres viudas de noventa años residentes en El Bosque del Crepúsculo, un centro privado de apartamentos para la tercera edad de Helsinki. Más que un nidito acogedor para las personas mayores, la residencia resulta un lugar siniestro en el que los ancianos se ven privados de su identidad, rodeados todos los días por enfermeros vagos e inexpertos, y obligados a hacer gimnasia, a asistir a conferencias y a tomar un gran cantidad de medicamentos prescritos por médicos a los que apenas han visto. Parece que para las tres amigas los días ya solo traerán partidas de cartas, viajes en tranvía y asistencia a funerales. Pero en la residencia se empiezan a producir unos misteriosos asesinatos… y quizá nadie había contado con la curiosidad y el tiempo libre de unas inocentes ancianitas.', v_92, 'EPUB/(Helsinki 1) Tres abuelas y un cocinero muerto - Minna Lindgren.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Ardiente verano' AND Autor = 'Noelia Amarillo') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Ardiente verano', 'Noelia Amarillo', 'María, una mujer de poco más de treinta años, con un hijo adolescente y una vida cómoda en Madrid, se ve «obligada» a pasar las vacaciones de verano en el pueblo de su exmarido. Y no es que le haga mucha gracia… Un día, perdida en la sierra, encuentra una rústica cabaña de madera en un claro del bosque. Junto a ella hay un pequeño cercado con dos caballos; incapaz de resistir la curiosidad, se acerca para recrearse en sus movimientos sin saber que ella misma está siendo observada. A partir de ese momento todo su mundo dará un giro radical. Todo en lo que cree cambiará a manos de un desconocido que no permite que le vea la cara mientras le ordena, susurrante, que haga lo que jamás se atrevió a hacer. ¿Lo hará? ¿Se dejará llevar por las palabras encendidas, las caricias ocultas y la pasión prohibida de un hombre al que ni siquiera puede ver el rostro?', v_38, 'EPUB/Ardiente verano - Noelia Amarillo.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Primeros casos de Rosendo Noriega' AND Autor = 'Miguel Velando Cabañas') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Primeros casos de Rosendo Noriega', 'Miguel Velando Cabañas', '<div>
<p>Una despedida de soltero en una aislada casa rural en las montañas de Guadalajara durante una tormenta de nieve. Un asesinato trastocará los planes de los invitados. Un joven Inspector, Rosendo Noriega, se fiará de su intuición para poder desentrañar unos extraordinarios hechos y descubrir al asesino entre los nueve asistentes.</p></div>', v_218, 'EPUB/Primeros casos de Rosendo Noriega - Miguel Velando Cabañas.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El highlander inmortal' AND Autor = 'Karen Marie Moning') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El highlander inmortal', 'Karen Marie Moning', 'Con su larga melena y sus fascinantes ojos, Adam Black es sinónimo de problemas. Inmortal y arrogante, es un maestro de la seducción que puede recorrer el tiempo y los continentes... hasta que una maldición lo despoja de su inmortalidad y lo vuelve invisible. Sólo le queda una esperanza: que la única mujer en el mundo capaz de verlo acceda a ayudarlo.Gabrielle O’Callaghan, una estudiante de Derecho, ha sido maldecida con la capacidad de ver ambos mundos, el de los mortales y el de las criaturas mágicas. En cuanto ve a Adam Black, está segura de que ese hombre podría ser su perdición. Adam la arrastrará a un mundo de hadas que hierve de mortíferas intrigas... Si consiguen alzarse con la victoria, ganarán una recompensa que pocos mortales llegan a conocer jamás: un amor que no terminará nunca.', v_37, 'EPUB/El highlander inmortal - Karen Marie Moning.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Todo sobre el amor' AND Autor = 'Stephanie Laurens') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Todo sobre el amor', 'Stephanie Laurens', 'Alasdair Cynster -conocido por sus íntimos como Lucifer- ha decidido refugiarse en el campo antes de que las habilidades como casamenteras de las madres de Londres se concentren en él, el último Cynster que permanece soltero. Pero su huida hacia Devon lo lleva derecho a encontrarse con su destino, en la forma de la irresistible Phyllida Tallent, una joven tan bella como testaruda e independiente, que despierta de forma imperiosa los instintos de Cynster. Lucifer trata de negar el deseo que Phyllida suscita en él, pues no quiere caer en una trampa en la que juró que nunca caería... Phyllida ha tenido muchos pretendientes -su belleza e inteligencia son famosas en el condado-, pero ninguno la ha atraído del modo en que lo ha hecho Lucifer. La oferta de éste de enseñarle todo lo relativo a las formas del amor resulta demasiado tentadora para resistirse. Y aun cuando Phyllida no ha capitulado por completo, sabe que sólo una tonta se resistiría a Cynster..., y ella no es ninguna tonta.', v_220, 'EPUB/Todo sobre el amor - Stephanie Laurens.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Michael Jordan: La biografía definitiva' AND Autor = 'Roland Lazenby') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Michael Jordan: La biografía definitiva', 'Roland Lazenby', '<div>
<p style="font-size: 14px; font-family: ''Amazon Ember'',''Arial'',''sans-serif''"><span style="color: #000000">«A veces me pregunto cómo será mirar hacia atrás y ver todo esto, incluso si me parecerá real.»<br></span><strong style="color: #000000">Michael Jordan</strong></p>
<p style="font-size: 14px; font-family: ''Amazon Ember'',''Arial'',''sans-serif''"><span style="color: #000000">El talento más excepcional de la historia del baloncesto fue como un cometa que cruza el cielo a toda velocidad, del que solo atisbamos el rastro de su brillo. La fascinante carrera de Michael Jordan dejó a seguidores, medios, entrenadores, compañeros y al propio Jordan intentando comprender qué es lo que había sucedido, incluso años después de su retirada.</span></p>
<p style="font-size: 14px; font-family: ''Amazon Ember'',''Arial'',''sans-serif''"><span style="color: #000000">Roland Lazenby dedicó casi treinta años a cubrir la carrera de Michael Jordan, desde la universidad hasta su consolidación como embajador mundial del baloncesto. Sin embargo, también fue testigo de la transformación de Jordan en un competidor insaciable y, a menudo, despiadado, muy lejos del modelo de perfección que se quiso proyectar durante años. </span></p>
<p style="font-size: 14px; font-family: ''Amazon Ember'',''Arial'',''sans-serif''"><span style="color: #000000">Este libro arroja luz sobre la compleja personalidad que se esconde detrás del mito, gracias a innumerables entrevistas con amigos y familiares, con entrenadores y compañeros, además de con el propio Michael Jordan. El resultado es una biografía monumental que muestra a Jordan desde todas sus facetas: el jugador, el icono y el hombre.</span></p></div>', v_42, 'EPUB/Michael Jordan - La biografía definitiva - Roland Lazenby.epub', '.epub', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Artemis Fowl' AND Autor = 'Eoin Colfer') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Artemis Fowl', 'Eoin Colfer', 'Nom : Fowl. Prénom : Artemis. Age : 12 ans. Signes particuliers : une intelligence hors du commun. Profession : voleur. Recherché pour : enlèvement de fée et demande de rançon. Appel à tous les FARfadets, membres des Forces Armées de Régulation du Peuple des fées : cet humain est dangereux et doit être neutralisé par tous les moyens possibles. Un anti-héros pétillant de malice, une galerie de personnages décapants, des dialogues vifs et intelligents, une histoire au rythme débridé... Laissez-vous entraîner dans l''univers sophistiqué d''Eoin Colfer, unique et enchanteur.', v_10, 'EPUB/Artemis Fowl - Eoin Colfer.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Como te atreves a volver' AND Autor = 'Sophie Saint Rose') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Como te atreves a volver', 'Sophie Saint Rose', '<div>
<p style="font-family: ''Arial'',''sans-serif''; font-size: 14px"><span style="color: #333333; background-color: #ffffff">Lorrie cometió un error en el pasado que ha pagado muy caro. Perdió a la que creía su familia y ahora era el momento de enfrentarse a ellos por mucho que le doliera. Pero lo que más temía era enfrentarse a Craig, porque su rechazo seguía doliendo incluso después de tantos años. Debería odiarle, debería odiarles a todos. Solo esperaba perderles de vista cuanto antes para empezar a olvidar. Sophie Saint Rose es una prolífica escritora que tiene entre sus éxitos “Huir del amor” o “La elegida”. En los últimos años ha publicado en Amazon más de ciento cuarenta historias que han sido Best Sellers en su categoría, desde contemporáneas como la serie oficina o Australia, hasta de época victoriana o de vikingos.</span></p></div>', v_98, 'EPUB/Como te atreves a volver - Sophie Saint Rose.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Las hijas de la villa de las telas' AND Autor = 'Anne Jacobs') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Las hijas de la villa de las telas', 'Anne Jacobs', '<p class="description">Después de La villa de las telas llega la segunda parte de esta saga romántica histórica para fans de Downton Abbey, María Dueñas, Kate Morton o Lucinda Riley, que ha cautivado a más de un millón y medio de lectoras. Una poderosa familia.Una guerra terrible.Una mansión que esconde más de un secreto... El destino de una familia en tiempos convulsos y un amor que todo lo vence.  Augsburgo, 1916. La mansión de la familia Melzer pasa a ser, por necesidad, un hospital militar. Las hijas de la casa, ayudadas por el servicio, se convierten en enfermeras que curan, cuidan y escuchan a los heridos en combate.  Entretanto, Marie, la joven esposa de Paul Melzer, se hace cargo de la fábrica de telas en ausencia de su marido. Sin embargo, recibe una terrible noticia: su cuñado ha caído en el frente y Paul es ahora un prisionero de guerra.  Marie se niega a que las circunstancias la venzan y lucha con todas sus fuerzas por preservar el patrimonio familiar. Pero, mientras no pierde la esperanza de volver a ver a Paul con vida y se deja la piel en la fábrica, el elegante Ernst von Klippstein aparece en la puerta de la mansión, empeñado en no perder de vista a la joven y bella mujer que tiene entre sus capaces manos el destino de la familia Melzer.  Esta apasionante saga familiar terminará en la tercera parte El legado de la villa de las telas. La crítica ha dicho...«Es una gran historia de amor, con tintes dramáticos y secretos familiares, que nos ha gustado tanto por su calidad literaria como por su preciosismo histórico.»Revista Kritica «Una novela histórica muy entretenida que capta el ambiente decomienzos del siglo XX.»Fränkische Nachrichten «Downtown Abbey en Augsburgo.»Histo-couch «Este libro lo tiene todo, todo que podríamos desear para un día de lluvia: una gran historia de amor, intriga [...] y un gran secreto familiar.»Delmenhorster Kreisblatt «Con su escritura fluida, Anne Jacobs sabe cómo seducir a sus lectoras y transportarlas a la vida de la alta sociedad de hace cien años con todo su glamour pero también con sus sombras.»Weilheimer Tagblatt</p>', v_95, 'EPUB/Las hijas de la villa de las telas - Anne Jacobs.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Sangre embrujada' AND Autor = 'Anya Bast') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Sangre embrujada', 'Anya Bast', NULL, v_42, 'EPUB/Sangre embrujada - Anya Bast.epub', '.epub', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Calígula' AND Autor = 'Albert Camus') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Calígula', 'Albert Camus', 'Reflexión sobre los problemas y obsesiones que nutrieron su creación literaria y teórica, Calígula —obra gestada entre 1938 y 1942 y representada por vez primera en 1945— es una de las grandes piezas dramáticas de Albert Camus (1913-1960). En ella, los temas recurrentes del absurdo existencial, la enajenación metafísica, el sufrimiento del hombre y la lógica del poder reciben un despliegue dramático que discurre en paralelo a las novelas y ensayos de un autor cuyo talento y sensibilidad ética se centraron siempre en una indagación sobre la complejidad, la ambigüedad y la riqueza de la condición humana.', v_51, 'EPUB/Calígula - Albert Camus.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Si me lo pide el corazón' AND Autor = 'Bethany Bells') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Si me lo pide el corazón', 'Bethany Bells', '<p class="centrado">Había nacido en un lugar surgido del amor eterno. No podía conformarse con menos.</p> <p> </p> <p>Olivia había nacido en un lugar surgido del amor eterno… y no podía conformarse con menos.</p> <p>Olivia y Marcus se conocen en una situación muy difícil, en la que descubren que los actos de sus padres provocaron un cambio en la línea legítima de la herencia del marquesado de Northcott. Tras ese comienzo tan conflictivo, inician una relación en la que él se siente impulsado a una boda por el deber de limpiar el honor de su apellido.</p <p>Pero Olivia, nacida en un pueblo que se mueve en entre la realidad y la leyenda de un amor eterno, no desea algo así. Ella solo se casará por amor.</p>', v_50, 'EPUB/Si me lo pide el corazón - Bethany Bells.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Juego de asesinos' AND Autor = 'P. J. Tracy') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Juego de asesinos', 'P. J. Tracy', 'Los directivos de la compañía de software Monkeewrench descubren que alguien está reproduciendo los asesinatos de uno de sus juegos. De momento ya hay dos víctimas, una mujer joven y un hombre que había salido a hacer «footing», pero el número puede elevarse de forma espeluznante. Grace McBride, la fundadora de la compañía, y su equipo estudian atentamente su juego para evitar más muertes, pero inevitablemente están en el punto de mira del detective Leo Magozzi, que, tirando del hilo, ha descubierto que McBride y sus colegas ya habían estado involucrados en otra serie de asesinatos ocurridos en Atlanta una década atrás.', @Cat_Intrigapolicial, 'EPUB/Juego de asesinos - P. J. Tracy.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Un océano para llegar a ti' AND Autor = 'Sandra Barneda') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Un océano para llegar a ti', 'Sandra Barneda', '<div>
<p style="font-size: 14px; font-weight: 600; font-family: ''Amazon Ember'',''Arial'',''sans-serif''"><span style="color: #000000">Una novela tierna y atrevida sobre los secretos familiares y las emociones silenciadas.</span></p>
<p style="font-size: 14px; font-family: ''Amazon Ember'',''Arial'',''sans-serif''"><span style="color: #000000">Tras la muerte de su madre, Gabriele vuelve al pueblo de los veranos de su infancia. Allí le espera su padre, con el que no habla desde hace años. Juntos se disponen a cumplir el último deseo de Greta: que las tres personas más importantes de su vida ―su marido, su única hija y su cuñada― esparzan sus cenizas en un lugar donde fueron felices. Los secretos que Greta desvela en las cartas que deja a su familia terminarán con el silencio entre padre e hija y, como en un dominó, alterarán la vida de todos y propiciarán un encuentro inesperado que hará que Gabriele descubra que en la vulnerabilidad se halla la magia de la vida.</span></p>
<p style="font-size: 14px; font-weight: 600; font-family: ''Amazon Ember'',''Arial'',''sans-serif''"><span style="color: #000000">¿Y si el destino de las personas tendiera un hilo invisible que las conecta con aquellos que deben encontrar? ¿Y si la vida solo fuera un viaje para encontrarlos?</span></p></div>', v_42, 'EPUB/Un océano para llegar a ti - Sandra Barneda.epub', '.epub', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'La muerte en mi Colt' AND Autor = 'Spencer Curtis') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('La muerte en mi Colt', 'Spencer Curtis', 'EL hombre alto, desgarbado, de ojos grises y fríos como la muerte, dijo: —Dos ataúdes de tercera. No pienso gastar más dinero con vosotros, ratas. Lo que sucedió a continuación quizá no se había visto nunca en Hot Springs. Los dos pistoleros tenían empuñados ya los «Colts» y comenzaban ya a apretar los gatillos, cuando el hombre de los ojos grises fue en busca de sus armas con una velocidad diabólica. Pero no desenfundó. Hizo dos extraños giros con ambas muñecas y disparó a través de las pistoleras.', v_85, 'EPUB/La muerte en mi Colt - Spencer Curtis.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '#Topadentro con Slow cooker ' AND Autor = 'Marta Miranda') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('#Topadentro con Slow cooker ', 'Marta Miranda', '#topadentro se refiere a recetas en las que solo hay una elaboración: se ponen directamente los ingredientes en el Slow Cooker y se cocinan, sin pochar, dorar, reducir... Más fácil, imposible. ¿Y qué tipo de platos se pueden preparar de un modo tan sencillo?', v_145, 'EPUB/#Topadentro con Slow cooker - Marta Miranda.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El Recetario De La Abuela' AND Autor = 'Alejandro Ruiz Reyes') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El Recetario De La Abuela', 'Alejandro Ruiz Reyes', '<div>
<p>¿Te gustaria aprender  a comer postres siendo diabetico? </p>
<p>¿Que tal un mousse de chocolate? </p>
<p>¿Te gustan las peras envinadas? </p>
<p>¿O prefieres una gelatina de durazno?</p>
<p> </p>
<p>Tras casì 20 años de vivir en una familia de doctores y especialistas de la salud el autor nos cuenta que si es posible ser diabetico y comer rico o simplemente comer antojitos cuidando de nuestra salud</p>
<p>En este libro aprenderas: </p>
<p>✅A cocinar postres Ricos y sabrosos </p>
<p>✅A cuidar de tu salud siendo diabetico </p>
<p>✅A cocinar de forma Fit </p>
<p>✅Aprenderas a cuidar de ti y de tu familia</p>
<p>Deja De SUFRIR Y Comienza A VIVIR...</p>
<p> </p>
<p> </p></div>', v_108, 'EPUB/El Recetario De La Abuela - Alejandro Ruiz Reyes.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El Asesino del Camino Norte Parte II' AND Autor = 'Rober H. L. Cagiao') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El Asesino del Camino Norte Parte II', 'Rober H. L. Cagiao', '<div>
<p style="font-family: ''arial''; font-size: 12px"><span style="background-color: #ffffff; color: #333333">Segunda y última parte de El Asesino del Camino Norte, cuarto volumen de la saga de El Guardián de las Flores. Se puede leer independiente aunque se recomienda haber leído previamente El Guardián. Este libro desaparecerá con la crisis y la cuarentena que estamos sufriendo. Gracias.</span></p></div>', v_42, 'EPUB/El Asesino del Camino Norte Parte II - Rober H. L. Cagiao.epub', '.epub', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El desfile de los malditos' AND Autor = 'Antonio Lozano') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El desfile de los malditos', 'Antonio Lozano', '<div>
<p>Nadie está a salvo de perderlo todo. Ildefonso Artiles puede dar fe de ello. De buena familia, felizmente casado, padre de dos hijos, ejemplar profesor de historia en un colegio privado, el paro lo arrastra al alcohol; el alcohol, a la calle, y la calle, a la desaparición. Metafórica, primero; real, después: su rastro parece haberse borrado de las aceras de Las Palmas, que se habían convertido en su hogar. ¿Dónde está Ildefonso? El detective José García Gago recibe el encargo de encontrarlo. Sus hermanos, tras años de ignorarlo, lo buscan. Por una herencia, dicen. Pero García Gago sospecha que hay algo más, algo mucho más turbio que lo lleva a viajar de la ciudad canaria a Madrid y a Barcelona tras el rastro de Ildefonso. Un viaje que no acaba ahí, y que le obligará a adentrarse en territorios en los que la vida de algunos seres humanos vale tan poco que se vende a piezas a quienes puedan pagarla.</p>
<p>En El desfile de los malditos, Antonio Lozano González recupera a su personaje icónico, el detective melómano José García Gago, para embarcarlo en una novela comprometida y valiente, que atrapa y revuelve, que sacude y que, a menudo, indigna. Una novela no apta para cínicos, porque la denuncia del tráfico de órganos —en Colombia, en Pakistán, en el cuerno de África y en China, pero también a la vuelta de la esquina— no permite paños calientes ni medias tintas.</p>
<p>La productora Meridional Producciones ha comprado los derechos audiovisuales de Preludio para una muerte, La sombra del Minotauro y El desfile de los malditos para la creación de una serie televisiva, Calima, protagonizada por su personaje, el inspector García Gago.</p></div>', v_219, 'EPUB/El desfile de los malditos - Antonio Lozano.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'El murciélago' AND Autor = 'Jo Nesbø') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('El murciélago', 'Jo Nesbø', 'Harry Hole es enviado a Sidney desde Oslo para que investigue el asesinato de una mujer noruega, Inger Holter, cuyo cadáver ha sido encontrado entre oscuras rocas, al pie de un acantilado. La policía sospecha que fue violada antes de morir, pero no se ha hallado rastro alguno de ADN. Harry Hole tendrá como compañero de investigación a Andrew Kensington, detective aborigen australiano. Ambos sospechan del novio de Inger, Evans White, atractivo camello conocido por la policía. Sin embargo, Harry comienza a vislumbrar que el caso es más complejo de lo que a priori pudiera parecer, y poco después el equipo de investigación relaciona una serie de desapariciones y asesinatos sin resolver que sugieren que un asesino en serie anda suelto. Harry Hole es un joven y brillante detective, pero esconde un oscuro secreto. Durante su estancia en Sidney se enamorará perdidamente de Birgitta Enquist, a quien le confesará lo que oculta su pasado y qué le aleja de su país…', v_228, 'EPUB/El murciélago - Jo Nesbø.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Artemis Fowl' AND Autor = 'Eoin Colfer') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Artemis Fowl', 'Eoin Colfer', 'Nom : Fowl. Prénom : Artemis. Age : 12 ans. Signes particuliers : une intelligence hors du commun. Profession : voleur. Recherché pour : enlèvement de fée et demande de rançon. Appel à tous les FARfadets, membres des Forces Armées de Régulation du Peuple des fées : cet humain est dangereux et doit être neutralisé par tous les moyens possibles. Un anti-héros pétillant de malice, une galerie de personnages décapants, des dialogues vifs et intelligents, une histoire au rythme débridé... Laissez-vous entraîner dans l''univers sophistiqué d''Eoin Colfer, unique et enchanteur.', v_10, 'EPUB/Artemis Fowl - La venganza de Opal - Eoin Colfer.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Pecado original' AND Autor = 'Karin Slaughter') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Pecado original', 'Karin Slaughter', 'La agente Faith Mitchell llega tarde a todos los sitios. Se suponía que tenía que recoger a su bebé a mediodía, pero no para de llamar a su madre a casa y no le responde. Evelyn Mitchell, capitán de la policía de Atlanta ya retirada, nunca sale de casa sin decirle a alguien adónde va, especialmente si está cuidando de su nieta. La preocupación de Faith se intensifica después de horas de llamadas sin respuesta… Cuando se presenta en casa de Evelyn, encuentra la huella sangrienta de una mano en la puerta de la entrada, y la casa hecha un caos. Todo indica que su madre ha sido secuestrada. Encontrarla se convertirá en tarea prioritaria de Amanda Wagner, la subdirectora del departamento de policía y amiga íntima de Evelyn. El compañero de Faith, Will Trent la ayudará con una investigación paralela. Las sospechas apuntan a los antiguos compañeros de Evelyn en la brigada de narcóticos, todos ellos condenados por corrupción por quedarse con parte del dinero decomisado al que tenían acceso; sin embargo, una nueva pista proporcionada por una vecina chismosa desvía la investigación hacia un caballero que visitaba a Evelyn varias veces a la semana. Mientras la investigación avanza, el romance entre la doctora Linton y Will Trent se afianza; Faith intenta mantener la compostura en la terrible situación que le ha tocado vivir; Amanda y Will persiguen todos los indicios, incluso aquellos que les lleven a los bajos fondos del estado de Georgia. La prioridad es encontrar a Evelyn y detener a sus secuestradores antes de que sea demasiado tarde…', v_102, 'EPUB/Pecado original - Karin Slaughter.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Artemis Fowl: El Cubo B' AND Autor = 'Eoin Colfer') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Artemis Fowl: El Cubo B', 'Eoin Colfer', 'Espero, humano, que con sólo oír mi nombre un escalofrío recorra tu cuerpo.Si no, pregúntales a las Criaturas mágicas o a las que viven en el Ártico quién soy; seguramente formo parte de sus pesadillas más temidas, y eso a mí me gusta. Sepas que yo pienso, y Mayordomo actúa. Fui el primer humano que se enfrentó a los seres subterráneos y conseguí lo que quería: oro y algún secreto más. Ahora todo parece volver a la normalidad: he rescatado a mi padre y mi madre está empeñada en que seamos una familia normal. Me queda poco tiempo para mi última maniobra... No sé si ni siquiera te mereces saber cuál es: pero, bueno, hoy me siento especialmente generoso, así que te adelanto que voy a chantajear a un magnate de la tecnología de la comunicación con un invento -mío, evidentemente-: el cubo B. Y, ahora, ¿a qué esperas para empezar a leer?', @Cat_FantsticoJuvenil, 'EPUB/Artemis Fowl El Cubo B - Eoin Colfer.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Crimen en directo' AND Autor = 'Camilla Läckberg') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Crimen en directo', 'Camilla Läckberg', NULL, v_42, 'EPUB/Crimen en directo - Camilla Läckberg.epub', '.epub', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Matar un ruiseñor' AND Autor = 'Nelle Harper Lee') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Matar un ruiseñor', 'Nelle Harper Lee', '<div>
<p>Matar a un ruiseñor</p>
<p>Harper Lee</p>
<p>narrativa</p>
<p>La explosión de odio y violencia racial en un pequeño pueblo de Alabama, es percibida por una niña cuyo padre defiende a un hombre negro acusado de violación. Matar un ruiseñor, está ambientada en el sur mítico, degradado y humillado tras la derrota contra los yankees en la Guerra de Secesión. La acción transcurre en los años treinta, los años de la terrible depresión post Crac del 29. Narrativamente acaba donde empieza Faulkner y comienza donde acaba Carson McCullers, pero es una historia de personajes. Los principales: los niños Scout y Jem y su padre Atticus, el pueblo y sus habitantes blancos y negros. El drama de la segregación racial y las raíces del funesto racismo enquistado en una sociedad tradicional y conservadora. La novela habla por si sola, se trata de una historia de niños en los que va influyendo la brutalidad y la cordura de los adultos, ese mundo fracturado cuyos fragmentos se complementan en una educación moral llena de contradicciones. La reedición ahora en castellano es una buena oportunidad para adentrarse en esa sociedad desaparecida pero con preocupantes espasmos contemporáneos.</p></div>', @Cat_narrativa, 'EPUB/Matar un ruiseñor - Nelle Harper Lee.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Una impostora en Minstrel Valley' AND Autor = 'Mariam Orazal') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Una impostora en Minstrel Valley', 'Mariam Orazal', '<p class="centrado">Valery Sherman ha conseguido ocultarse de todo y de todos, menos del amor.</p> <p> </p> <p>Cuando llegó a Minstrel Valley, la ficticia señorita Sherman creyó haber encontrado el refugio perfecto donde ocultarse de los peligros que la acechaban, pero halló mucho más que eso pues la Escuela de Señoritas de lady Acton le proporcionó un hogar y una familia. Como profesora de etiqueta su vida es pacífica y algo monótona hasta que aparece en el valle un nuevo profesor que no se dejará engañar por su disfraz de maestra severa.</p> <p>El negocio familiar lo es todo para Dunhcan Bissop. Lo que menos había pensado era que la apertura de sus nuevas caballerizas lo lanzaría de cabeza a terminar como instructor de equitación ¡en una escuela de señoritas! Por suerte, encontrará en la muy estirada señorita Sherman un aliciente para acudir todos los días a la gran mansión y descubrir quién es la mujer que se oculta bajo capas y capas de decoro y secretos.</p>', v_88, 'EPUB/Una impostora en Minstrel Valley - Mariam Orazal.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Los jardines de los muertos' AND Autor = 'William Brodrick') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Los jardines de los muertos', 'William Brodrick', 'Una muerte en extrañas circunstancias, una abogada de la Corona de Su Graciosa Majestad, un caso judicial que
vuelve a abrirse, removiendo conciencias sepultadas por el olvido…
Los juzgados y los muelles de Londres dibujarán el paisaje en el que deben dilucidarse cuestiones tan complejas
como la justicia, la inocencia o la línea que separa el bien del mal. Tal vez las respuestas se encuentren en el monasterio en el que se refugia un antiguo colaborador de la abogada muerta. Este monje será el encargado de desenterrar la verdad sobre un oscuro pasado, desvelando también el motivo de su tardía vocación religiosa.', v_27, 'EPUB/Los jardines de los muertos - William Brodrick.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Enseñar a investigar. Una didáctica nueva de la investigación en ciencias sociales y humanas' AND Autor = 'Ricardo Sánchez Puentes') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Enseñar a investigar. Una didáctica nueva de la investigación en ciencias sociales y humanas', 'Ricardo Sánchez Puentes', 'En este libro, interesa analizar y evaluar distintas estrategias didácticas que han sido diseñadas y aplicadas para generar conocimiento en ciencias sociales y humanidades. Para Ricardo Sánchez Puentes, no hay duda de que enseñar a investigar es un proceso complejo y una actividad ampliamente diversificada; así, sostiene que es más fecunda y da mejores resultados la didáctica de la investigación que tiene como referentes las prácticas concretas y los procesos efectivos de la generación de conocimiento. Si se quiere enseñar el oficio de investigador, no basta con fundar la propuesta programática en la mera descripción, análisis y crítica de ese quehacer, es necesario que quien desea aprender se involucre en todas las tareas de esta práctica, aliado de otra persona con mayor experiencia y en un ejercicio institucional en el que se promueva la investigación social y humanística.', v_115, 'EPUB/Enseñar a investigar. Una didáctica nueva de la investigación en ciencias sociales y humanas - Ricardo Sánchez Puentes.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Llamada a los Bichos Raros' AND Autor = 'R.L. Stine') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Llamada a los Bichos Raros', 'R.L. Stine', NULL, v_42, 'EPUB/(Pesadilla N°48) Llamada a los Bichos Raros - R.L. Stine.mobi', '.mobi', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Mi vida por la tuya' AND Autor = 'Amy Plum') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Mi vida por la tuya', 'Amy Plum', 'Cuando los padres de Kate Mercier mueren en un trágico accidente de automóvil, ella deja atrás su vida —y sus recuerdos— para irse a vivir con sus abuelos en París. Para Kate, la única manera de sobrevivir al dolor que encuentra es sumergirse en el mundo de los libros y del arte parisino. Y así es hasta que conoce a Vincent Delacroix. Misterioso, encantador y devastadoramente guapo, Vincent amenaza con derretir el hielo con el que ella protege su corazón con solo una sonrisa. A medida que se va enamorando de él, la joven descubre que es un revenant, un no muerto marcado por un destino: debe sacrificarse a sí mismo una y otra vez para salvar las vidas de los demás. Vincent y otros como él se encuentran metidos desde hace siglos en una guerra contra un grupo de revenants malvados, los numa, que solo se mantienen en este mundo para asesinar y traicionar. Si sigue a su corazón, Kate sabe que quizá nunca más pueda mantenerse a salvo.', v_68, 'EPUB/Mi vida por la tuya - Amy Plum.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Preludio para una muerte' AND Autor = 'Antonio Lozano') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Preludio para una muerte', 'Antonio Lozano', 'En Preludio para una muerte, el detective privado José García Gago se enfrenta por primera vez a un caso importante: el asesinato de un personaje destacado ocurrido veinte años atrás en una pequeña localidad cuya irresolución creó dos bandos, que aunque enfrentados desde entonces, no facilitarán la labor a nuestro investigador porque hasta las pequeñas comunidades guardan secretos que pesan sobre la conciencia de todos y de los que a nadie le interesa hablar. No obstante, la presencia de un “forastero” pone en alerta a la comunidad, y nuevas muertes y revelaciones nos descubren una historia sórdida y triste de abandono, desamor y conflicto de clases.', v_120, 'EPUB/Preludio para una muerte - Antonio Lozano.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Susúrramelo al oído (Volumen independiente) (Spanish Edition)' AND Autor = 'Patricia Geller') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Susúrramelo al oído (Volumen independiente) (Spanish Edition)', 'Patricia Geller', NULL, v_42, 'EPUB/Susúrramelo al oído (Volumen independiente) (Spanish Edition) - Patricia Geller.epub', '.epub', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '(Fjallbacka 07) Los vigilantes del faro ' AND Autor = 'Camilla Lackberg') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('(Fjallbacka 07) Los vigilantes del faro ', 'Camilla Lackberg', 'Desde que Patrik se ha reincorporado al trabajo, Erica se dedica de lleno a sus gemelos, que nacieron prematuros. Apenas tiene tiempo para ir a visitar a Annie Wester, una compañera de instituto que acaba de regresar a Fjällbacka después de muchos años. Junto con su hijo Sam, Annie se ha instalado en el faro abandonado de la isla de Gråskär, propiedad de su familia. A pesar de los rumores que circulan por el pueblo sobre la leyenda de la «isla de los espíritus», en la que los muertos vagan libremente, no parecen importarle las voces extrañas que oye por la noche. Además, su antiguo novio Matte Sverin, quien también ha pasado unos años en Estocolmo y acaba de empezar a trabajar en el Ayuntamiento de Fjällbacka, aparece asesinado. Annie es la última persona que lo ve con vida. Estos sucesos le depararán a Patrik y a su eficaz colaboradora Paula muchos quebraderos de cabeza. Por su parte, Erica, que realiza su propia investigación en paralelo, conseguirá atar algunos cabos sueltos que serán de gran ayuda para la resolución del caso.', v_39, 'EPUB/(Fjallbacka 07) Los vigilantes del faro - Camilla Lackberg.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'No cambies por mí, amor' AND Autor = 'Sophie Saint Rose') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('No cambies por mí, amor', 'Sophie Saint Rose', 'Natalya tiene una vida perfectamente ordenada. Ha conseguido el trabajo que siempre había soñado y tiene unas amigas estupendas. La única pega es que no tiene novio y por mucho que lo intentaba no conseguía al hombre de sus sueños. ¿Era demasiado exigente? Puede, pero estaba en su derecho. Aunque sus amigas consideraban que la conocían lo suficiente para encontrar al hombre que encajara en su vida, ¿debía arriesgarse? Mira que tenían gustos muy distintos y podía llegar a salir con hombres que ella ni miraría dos veces. Pero el premio era demasiado tentador…', v_220, 'EPUB/No cambies por mí, amor - Sophie Saint Rose.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¡Y tenía que ser mi jefe! 4: El desenlace' AND Autor = 'Norah Carter & Monika Hoff') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¡Y tenía que ser mi jefe! 4: El desenlace', 'Norah Carter & Monika Hoff', 'Cuando Davinia cree que Óscar es el amor de su vida, descubre el engaño de este. Mientras decide terminar con su matrimonio, es su antiguo jefe quien decide apoyarla en todo y no separarse de ella en ningún momento.Peter ha sufrido un cambio radical y eso puede que le haga ganarse el corazón de la única mujer que amó. ¿Lograrán estar por fin juntos? El desenlace de esta saga lo conoceremos aquí.', v_220, 'EPUB/¡Y tenía que ser mi jefe! 4 El desenlace - Norah Carter & Monika Hoff.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'A que estas esperando' AND Autor = 'Megan Maxwell') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('A que estas esperando', 'Megan Maxwell', 'Vuelve a soñar con la nueva novela de la autora nacional más vendida.


Can Drogo, piloto e hijo del dueño de la empresa aeronáutica High Drogo, es un hombre alto, guapo, adinerado, simpático… Puede elegir a la mujer que desee, y aunque disfruta de esa «magia especial» con la que le ha dotado la vida, en su interior siente que todas lo aburren.


Por su parte, Sonia Becher es la mayor de cuatro hermanas y la propietaria de una empresa de eventos y de una agencia de modelos.


Can ve en ella a una chica divertida, atrevida, sin tabúes, con la que se puede hablar de todo, incluido de sexo, pero poco más, pues considera que no es su tipo. Hasta que un día las sonrisas y las miradas de la joven no van dirigidas a él, y eso, sin saber por qué, comienza a molestarlo.


¿En serio Sonia va a sonreír a otros hombres estando él delante?


Sexo. Familia. Diversión. Locura. Todo esto es lo que vas a encontrar en ¿A qué estás esperando?, una novela que te hará ver que, en ocasiones, tu corazón se desboca por quien menos esperas sin que puedas frenarlo.', v_134, 'EPUB/A que estas esperando - Megan Maxwell.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'No soy un asesino' AND Autor = 'Kent Wilson') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('No soy un asesino', 'Kent Wilson', 'Ángel Cazorla Olmo, nacido en Santa Cruz de Marchena (provincia de Almería) en 1930, en una familia de humildes labradores. A los 15 años emigra a Cataluña, donde realiza diversos trabajos. A los 22 años se inicia en la literatura popular con el seudónimo Kent Wilson, publicando casi un centenar de relatos del genero westerns, policíacos, de guerra y ciencia ficción.', v_136, 'EPUB/No soy un asesino - Kent Wilson.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Territorio de caza' AND Autor = 'Miguel Velando Cabañas') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Territorio de caza', 'Miguel Velando Cabañas', '<div>
<p style="font-size: 14px; font-family: ''Amazon Ember'',''Arial'',''sans-serif''"><span style="background-color: #ffffff; color: #333333">Una mujer es encontrada muerta de un tiro de escopeta en un camino cerca de Madrid. Casi a la vez, otra mujer es asesinada de la misma manera en un pueblo de Ciudad Real. La investigación llevará al inspector Noriega y a la oficial Salinas a colaborar con el capitán Torres de la UCO en medio de la atmósfera opresiva de Vegas de Calatraba, un pueblo imaginario perfectamente real.</span></p></div>', v_69, 'EPUB/Territorio de caza - Miguel Velando Cabañas.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = 'Diablo' AND Autor = 'Stephanie Laurens') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('Diablo', 'Stephanie Laurens', 'Las fans de la serie Cynster disfrutarán de esta apasionate novela, que como las demás se puede leer de forma independiente. Primera entrega de la saga romántica «Cynster». ¿Era el marido que siempre había soñado, o un verdadero demonio? Honoria Wetherby es institutriz, pero tiene otros proyectos: vivir aventuras, conocer mundo... aunque lo inesperado puede cambiar drásticamente hasta los mejores planes. Su intento de ayudar a un moribundo la lleva a pasar la noche en una cabaña solitaria en compañía del miembro más denostado de los Cynster, a quien llaman Diablo. Cuando esto sale a la luz, él no tiene otro remedio que pedir su mano. La familia Cynster está encantada de que el famoso libertino finalmente decida casarse, pero lo que menos desea la rebelde joven es un marido que la controle, y enamorarse no está en sus planes.', v_37, 'EPUB/Diablo - Stephanie Laurens.epub', '.epub', 0, 1);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¿Por qué funciona el populismo.epub' AND Autor = 'Desconocido') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¿Por qué funciona el populismo.epub', 'Desconocido', NULL, v_43, 'no funca/¿Por qué funciona el populismo.epub', '.epub', 0, 0);
END IF;

IF NOT EXISTS (SELECT 1 FROM BibliotecaLibros WHERE Titulo = '¿Y dónde está la gente.epub' AND Autor = 'Desconocido') THEN
    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES ('¿Y dónde está la gente.epub', 'Desconocido', NULL, v_43, 'no funca/¿Y dónde está la gente.epub', '.epub', 0, 0);
END IF;

COMMIT;

END;
GO
CALL migrate_013_seed_biblioteca_data();
GO
DROP PROCEDURE migrate_013_seed_biblioteca_data;
GO
