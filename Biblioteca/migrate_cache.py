import json
import os
import re

base_dir = "/home/guss/Desktop/Proyectos/IDNUEVO/Biblioteca"
cache_file = os.path.join(base_dir, "metadata_cache.json")

def clean_string(s):
    if not s:
        return ""
    s = s.lower().strip()
    replacements = {
        "á": "a", "é": "e", "í": "i", "ó": "o", "ú": "u", "ü": "u", "ñ": "n"
    }
    for char, replacement in replacements.items():
        s = s.replace(char, replacement)
    s = re.sub(r'[^a-z0-9\s]', '', s)
    return re.sub(r'\s+', ' ', s).strip()

def parse_filename_clean(name):
    # Simular la lógica de limpieza de process_metadata.py
    name = re.sub(r'\.pdf|\.epub|\.mobi', '', name, flags=re.IGNORECASE)
    name = re.sub(r' · versi[oó]n \d+', '', name, flags=re.IGNORECASE)
    name = re.sub(r'-\d+(-\d+)*$', '', name)
    name = re.sub(r'_filename= UTF-8_', '', name, flags=re.IGNORECASE)
    name = re.sub(r'_filename_= UTF-8_[A-Fa-f0-9_]*', '', name, flags=re.IGNORECASE)
    
    name = name.strip('_').strip()
    name = re.sub(r'^[\(\[\{][^\)\]\}]+[\)\]\}]\s*', '', name)
    name = re.sub(r'^\d+[\.\-\s_]*', '', name)
    name = re.sub(r'^[^\w\s]+\s*', '', name)
    name = name.strip('_').strip()
    
    parts = re.split(r'\s+-\s+|\s*—\s*|\s+–\s+', name)
    if len(parts) >= 2:
        title = parts[0].strip('_').strip()
        author = parts[1].strip('_').strip()
        return title, author
        
    return name, "Desconocido"

def migrate():
    if not os.path.exists(cache_file):
        print("No cache file found to migrate.")
        return
        
    with open(cache_file, 'r', encoding='utf-8') as f:
        cache = json.load(f)
        
    new_cache = {}
    migrations = 0
    
    # Primero copiamos todos los existentes para no perder nada
    for k, v in cache.items():
        new_cache[k] = v
        
    # Ahora migramos claves que tengan .pdf, .epub, etc. o versiones
    for k, v in cache.items():
        title = v.get("titulo", "")
        author = v.get("autor", "Desconocido")
        
        # Correr la nueva lógica de limpieza sobre el título y autor registrados
        clean_title, clean_author = parse_filename_clean(title)
        if clean_author == "Desconocido" and author != "Desconocido":
            clean_author = author
            
        new_k = clean_string(clean_title) + "||" + clean_string(clean_author)
        
        if new_k != k:
            # Si la nueva clave no existe o no tiene sinopsis, y la vieja sí la tiene, migrar!
            old_has_syn = v.get("sinopsis") and v.get("sinopsis").strip() != ""
            new_has_syn = new_cache.get(new_k, {}).get("sinopsis") and new_cache.get(new_k, {}).get("sinopsis").strip() != ""
            
            if old_has_syn and not new_has_syn:
                new_cache[new_k] = {
                    "titulo": clean_title,
                    "autor": clean_author,
                    "genero": v.get("genero", "No especificado"),
                    "sinopsis": v.get("sinopsis", ""),
                    "source": v.get("source", "cache_migration")
                }
                migrations += 1
                
    with open(cache_file, 'w', encoding='utf-8') as f:
        json.dump(new_cache, f, indent=4, ensure_ascii=False)
        
    print(f"Migración completada. Nuevas llaves generadas: {migrations}. Total claves en caché: {len(new_cache)}")

if __name__ == "__main__":
    migrate()
