import os
import json
import time
import gdown

# Configuración de rutas
base_dir = os.path.dirname(os.path.abspath(__file__))
json_path = os.path.join(base_dir, "drive_files.json")
output_base = os.path.join(base_dir, "Libros")

if not os.path.exists(json_path):
    print(f"Error: {json_path} no existe.")
    exit(1)

# Cargar lista de archivos de Google Drive
with open(json_path, "r", encoding="utf-8") as f:
    files = json.load(f)

print(f"Se encontraron {len(files)} archivos para descargar.")

success_count = 0
skip_count = 0
fail_count = 0

for i, entry in enumerate(files, 1):
    url = entry["url"]
    rel_path = entry["path"]
    
    # Ruta de destino absoluta
    dest_path = os.path.join(output_base, rel_path)
    dest_dir = os.path.dirname(dest_path)
    
    # 1. Comprobar si ya se ha descargado y tiene tamaño correcto
    if os.path.exists(dest_path) and os.path.getsize(dest_path) > 0:
        # Imprimir progreso simplificado para no saturar logs
        if i % 10 == 0 or i == len(files):
            print(f"[{i}/{len(files)}] Procesando catálogo... (Saltando ya existentes)")
        skip_count += 1
        continue
        
    # Crear carpeta si no existe
    os.makedirs(dest_dir, exist_ok=True)
    
    print(f"[{i}/{len(files)}] Descargando: {rel_path}...")
    
    # 2. Descargar con reintentos
    retries = 3
    downloaded = False
    for attempt in range(1, retries + 1):
        try:
            # gdown.download devuelve la ruta del archivo si tiene éxito, o None
            out = gdown.download(url, dest_path, quiet=True)
            if out is not None and os.path.exists(dest_path) and os.path.getsize(dest_path) > 0:
                downloaded = True
                break
        except Exception as e:
            print(f"  Intento {attempt} falló: {e}")
        
        # Esperar un momento antes del reintento
        time.sleep(5)
        
    if downloaded:
        success_count += 1
        # Retardo de seguridad para evitar que Google limite la IP
        time.sleep(1.2)
    else:
        print(f"  [ERROR] No se pudo descargar {rel_path} tras {retries} intentos. Saltando al siguiente.")
        fail_count += 1
        # Esperar un poco más tras un fallo antes de continuar
        time.sleep(8)

print("\n--- Resumen Final del Proceso ---")
print(f"Descargados con éxito en esta sesión: {success_count}")
print(f"Saltados (ya existían localmente): {skip_count}")
print(f"Fallidos / Saltados por error: {fail_count}")
print(f"Total de libros listos: {skip_count + success_count}")
