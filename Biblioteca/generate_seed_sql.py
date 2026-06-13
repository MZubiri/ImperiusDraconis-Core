import openpyxl
import os
import re

base_dir = "/home/guss/Desktop/Proyectos/IDNUEVO/Biblioteca"
excel_file = os.path.join(base_dir, "GELATINA - LIBROS PROCESADOS.xlsx")
sql_output_file = "/home/guss/Desktop/Proyectos/IDNUEVO/SQLMigrar/013_seed_biblioteca_data.sql"

def escape_sql_string(s):
    if not s:
        return "NULL"
    # Escapar comillas simples duplicándolas
    escaped = s.replace("'", "''")
    return f"N'{escaped}'"

def sanitize_variable_name(name):
    # Crear un nombre de variable SQL válido a partir del género
    clean = re.sub(r'[^a-zA-Z0-9]', '', name)
    return clean if clean else "Desconocido"

def generate():
    if not os.path.exists(excel_file):
        print(f"No excel file found at: {excel_file}")
        return
        
    wb = openpyxl.load_workbook(excel_file, data_only=True)
    sheet = wb.active
    
    books = []
    unique_categories = set()
    
    for row in list(sheet.iter_rows(min_row=2, values_only=True)):
        # Con la nueva estructura de columnas:
        # 0: item, 1: listo, 2: titulo, 3: autor, 4: formato, 5: genero, 6: genero_sugerido, 7: sinopsis, 8: nombre_archivo
        if not row[2]: # Titulo vacío
            continue
        
        genre = row[5] if row[5] else "No especificado"
        unique_categories.add(genre)
        
        # Mapeamos 'listo' (puede ser bool, string o None)
        listo_val = row[1]
        listo_bool = True if listo_val is True or str(listo_val).strip().lower() in ['true', '1', 'si', 'sí', 'listo', 'verdadero'] else False
        
        books.append({
            "listo": listo_bool,
            "titulo": row[2],
            "autor": row[3] if row[3] else "Desconocido",
            "formato": row[4] if row[4] else ".pdf",
            "genero": genre,
            "sinopsis": row[7] if row[7] else "",
            "nombre_archivo": row[8] if row[8] else ""
        })
        
    print(f"Loaded {len(books)} books and {len(unique_categories)} unique genres from Excel.")
    
    with open(sql_output_file, "w", encoding="utf-8") as f:
        f.write("/*\n")
        f.write("    Migracion: 013_seed_biblioteca_data\n")
        f.write("    Proposito: Insertar categorías y catálogo de libros consolidados.\n")
        f.write("    Fecha: 2026-06-12\n")
        f.write("*/\n\n")
        
        # 1. Declarar variables para los IDs de categorías
        f.write("-- 1. Declarar variables de categorías\n")
        for cat in unique_categories:
            var_name = sanitize_variable_name(cat)
            f.write(f"DECLARE @Cat_{var_name} INT;\n")
        f.write("\n")
        
        # 2. Insertar categorías y capturar IDs
        f.write("-- 2. Insertar categorías si no existen y asignar variables\n")
        for cat in unique_categories:
            var_name = sanitize_variable_name(cat)
            escaped_cat = escape_sql_string(cat)
            f.write(f"IF NOT EXISTS (SELECT 1 FROM dbo.BibliotecaCategorias WHERE Nombre = {escaped_cat})\n")
            f.write("BEGIN\n")
            f.write(f"    INSERT INTO dbo.BibliotecaCategorias (Nombre, Descripcion, Activo) VALUES ({escaped_cat}, N'Categoría {cat}', 1);\n")
            f.write("END;\n")
            f.write(f"SELECT @Cat_{var_name} = Id FROM dbo.BibliotecaCategorias WHERE Nombre = {escaped_cat};\n\n")
            
        # 3. Insertar libros
        f.write("-- 3. Insertar libros en lotes\n")
        f.write("BEGIN TRANSACTION;\n\n")
        
        for idx, book in enumerate(books, 1):
            var_name = sanitize_variable_name(book["genero"])
            t = escape_sql_string(book["titulo"])
            a = escape_sql_string(book["autor"])
            s = escape_sql_string(book["sinopsis"])
            fmt = escape_sql_string(book["formato"])
            path = escape_sql_string(book["nombre_archivo"])
            
            # Comprobar si el libro ya está registrado para evitar duplicados en re-ejecuciones
            f.write(f"-- Libro {idx}: {book['titulo'][:40]}\n")
            f.write(f"IF NOT EXISTS (SELECT 1 FROM dbo.BibliotecaLibros WHERE Titulo = {t} AND Autor = {a})\n")
            f.write("BEGIN\n")
            activo_val = 1 if book["listo"] else 0
            f.write(f"    INSERT INTO dbo.BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo) \n")
            f.write(f"    VALUES ({t}, {a}, {s}, @Cat_{var_name}, {path}, {fmt}, 0, {activo_val});\n")
            f.write("END;\n\n")
            
        f.write("COMMIT TRANSACTION;\n")
        f.write("GO\n")
        
    print(f"Successfully generated seed SQL script: {sql_output_file}")

if __name__ == "__main__":
    generate()
