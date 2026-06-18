/*
    Migracion: 014_new_books
    Proposito: Registrar las nuevas categorias y libros descargados de Anna's Archive.
    Fecha: 2026-06-13
*/

-- 1. Declarar variables para IDs de categorias
DECLARE @Cat_ProgramacinyVideojuegos INT;
DECLARE @Cat_DibujoyArteManga INT;
DECLARE @Cat_LiteraturaJuvenilyFantasa INT;

-- 2. Insertar categorias si no existen y obtener IDs
IF NOT EXISTS (SELECT 1 FROM dbo.BibliotecaCategorias WHERE Nombre = N'Programación y Videojuegos')
BEGIN
    INSERT INTO dbo.BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES (N'Programación y Videojuegos', N'Desarrollo de videojuegos, Lua, Roblox Studio y tecnología para jóvenes.', 1);
END;
SELECT @Cat_ProgramacinyVideojuegos = Id FROM dbo.BibliotecaCategorias WHERE Nombre = N'Programación y Videojuegos';

IF NOT EXISTS (SELECT 1 FROM dbo.BibliotecaCategorias WHERE Nombre = N'Dibujo y Arte Manga')
BEGIN
    INSERT INTO dbo.BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES (N'Dibujo y Arte Manga', N'Ilustración, dibujo estilo manga/anime, y guías de arte digital.', 1);
END;
SELECT @Cat_DibujoyArteManga = Id FROM dbo.BibliotecaCategorias WHERE Nombre = N'Dibujo y Arte Manga';

IF NOT EXISTS (SELECT 1 FROM dbo.BibliotecaCategorias WHERE Nombre = N'Literatura Juvenil y Fantasía')
BEGIN
    INSERT INTO dbo.BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES (N'Literatura Juvenil y Fantasía', N'Novelas juveniles, fantasía, aventuras y clásicos modernos.', 1);
END;
SELECT @Cat_LiteraturaJuvenilyFantasa = Id FROM dbo.BibliotecaCategorias WHERE Nombre = N'Literatura Juvenil y Fantasía';

-- 3. Insertar libros descargados
BEGIN TRANSACTION;

-- Libro 1: Roblox Game Development: From Zero To Pr
IF NOT EXISTS (SELECT 1 FROM dbo.BibliotecaLibros WHERE Titulo = N'Roblox Game Development: From Zero To Proficiency' AND Autor = N'Beginner')
BEGIN
    INSERT INTO dbo.BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES (N'Roblox Game Development: From Zero To Proficiency', N'Beginner', N'Libro sobre Roblox Game Development de la biblioteca de Imperius Draconis.', @Cat_ProgramacinyVideojuegos, N'Programacion/Roblox Game Development From Zero To Proficiency Beginner.pdf', N'.pdf', 300.00, 1);
END;

-- Libro 2: Lua Programming Beginners: Learn Lua Pro
IF NOT EXISTS (SELECT 1 FROM dbo.BibliotecaLibros WHERE Titulo = N'Lua Programming Beginners: Learn Lua Programming Step by Step very easy' AND Autor = N'Desconocido')
BEGIN
    INSERT INTO dbo.BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES (N'Lua Programming Beginners: Learn Lua Programming Step by Step very easy', N'Desconocido', N'Libro sobre Lua Programming de la biblioteca de Imperius Draconis.', @Cat_ProgramacinyVideojuegos, N'Programacion/Lua Programming Beginners Learn Lua Programming Step by Step very easy.pdf', N'.pdf', 300.00, 1);
END;

-- Libro 3: How to Draw Manga - Vol. 26 - Making Ani
IF NOT EXISTS (SELECT 1 FROM dbo.BibliotecaLibros WHERE Titulo = N'How to Draw Manga - Vol. 26 - Making Anime' AND Autor = N'Desconocido')
BEGIN
    INSERT INTO dbo.BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES (N'How to Draw Manga - Vol. 26 - Making Anime', N'Desconocido', N'Libro sobre How to Draw Manga de la biblioteca de Imperius Draconis.', @Cat_DibujoyArteManga, N'Dibujo/How to Draw Manga - Vol. 26 - Making Anime.pdf', N'.pdf', 300.00, 1);
END;

-- Libro 4: Riordan, Rick - Percy Jackson 1
IF NOT EXISTS (SELECT 1 FROM dbo.BibliotecaLibros WHERE Titulo = N'Riordan, Rick - Percy Jackson 1' AND Autor = N'Desconocido')
BEGIN
    INSERT INTO dbo.BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES (N'Riordan, Rick - Percy Jackson 1', N'Desconocido', N'Libro sobre Percy Jackson Lightning Thief de la biblioteca de Imperius Draconis.', @Cat_LiteraturaJuvenilyFantasa, N'Literatura/Riordan Rick - Percy Jackson 1.pdf', N'.pdf', 300.00, 1);
END;

-- Libro 5: Prince Caspian
IF NOT EXISTS (SELECT 1 FROM dbo.BibliotecaLibros WHERE Titulo = N'Prince Caspian' AND Autor = N'Desconocido')
BEGIN
    INSERT INTO dbo.BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo)
    VALUES (N'Prince Caspian', N'Desconocido', N'Libro sobre Chronicles of Narnia de la biblioteca de Imperius Draconis.', @Cat_LiteraturaJuvenilyFantasa, N'Literatura/Prince Caspian.pdf', N'.pdf', 300.00, 1);
END;

COMMIT TRANSACTION;