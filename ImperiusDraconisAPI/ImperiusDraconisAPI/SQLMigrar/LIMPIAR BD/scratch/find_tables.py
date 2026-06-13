import os
import re

tables = [
    "AgendaDinamicas", "AlumnoPreferencias", "Alumnos", "Alumnos_Backup_Codigos", "AlumnosTrabajos",
    "Asignaciones", "aspnet_Applications", "aspnet_Membership", "aspnet_Paths", "aspnet_PersonalizationAllUsers",
    "aspnet_PersonalizationPerUser", "aspnet_Profile", "aspnet_Roles", "aspnet_SchemaVersions", "aspnet_Users",
    "aspnet_UsersInRoles", "aspnet_WebEvent_Events", "AuditoriaEventos", "BoardMembers", "BookCategories",
    "Books", "Cargos", "Casas", "ChismeImagenes", "Chismes", "ComidasDragon", "Comisiones",
    "ContactMessages", "CuentasEspeciales", "CuentasVinculadas", "DecisionesAdministrativas", "DetallePedidos",
    "DetallesPedidoRincon", "Dinamicas", "DispositivosAlumno", "DracoinsDinamica", "Dragones",
    "EstadosPedido", "Events", "ExamCategories", "Exams", "ExcepcionesAuditoria", "FormasDragon",
    "GameDracoinLedger", "GameDragonCapacity", "GameDragons", "GameEggDefinitions", "GameEggs",
    "GameEggTransfers", "GameIdempotency", "GameLinkCodes", "GameRobloxLinks", "HistorialAccesos",
    "HistorialDragon", "HistorialEstadosPedido", "HistorialMarcadores", "Impuestos anuales", "JuegosPartidas",
    "MarcadorActual", "Mascotas", "MascotasPorAlumno", "MovimientosDracoins", "NotasAlumno",
    "PagosAdministrativos", "PagosMascotas", "PagosMensuales", "Pedidos", "PedidosRincon",
    "Permisos", "PermisosTrabajos", "Productos", "ProductosRincon", "ResearchCategories", "Researches",
    "ResultadosPorCasa", "ResumenAuditoriaAccesos", "Roles", "Servicios", "SueldosCargo",
    "Trabajos", "UserRoles", "Users", "Usuarios"
]

project_dir = "/home/guss/Desktop/Proyectos/IDNUEVO"
exclude_dirs = {".git", "node_modules", "dist", ".angular", "obj", "bin", "Ejecutar proyectos"}
exclude_extensions = {".sql", ".log", ".md", ".json", ".user", ".png", ".jpg", ".jpeg", ".ico", ".svg", ".zip", ".ods"}

results = {t: {"cs": 0, "ts": 0, "html": 0, "other": 0, "files": []} for t in tables}

patterns = {}
for t in tables:
    escaped = re.escape(t)
    pattern = re.compile(rf'(?<![a-zA-Z0-9_]){escaped}(?![a-zA-Z0-9_])', re.IGNORECASE)
    patterns[t] = pattern

for root, dirs, files in os.walk(project_dir):
    dirs[:] = [d for d in dirs if d not in exclude_dirs]
    
    for file in files:
        ext = os.path.splitext(file)[1].lower()
        if ext in exclude_extensions:
            continue
            
        filepath = os.path.join(root, file)
        try:
            with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
                content = f.read()
        except Exception:
            continue
            
        rel_path = os.path.relpath(filepath, project_dir)
        
        for t in tables:
            matches = len(patterns[t].findall(content))
            if matches > 0:
                if ext == ".cs":
                    results[t]["cs"] += matches
                elif ext == ".ts":
                    results[t]["ts"] += matches
                elif ext == ".html":
                    results[t]["html"] += matches
                else:
                    results[t]["other"] += matches
                results[t]["files"].append(f"{rel_path} ({matches})")

# Print results
print("Table|C# Matches|TS Matches|HTML Matches|Other Matches|Files")
print("---|---|---|---|---|---")
for t in tables:
    res = results[t]
    total = res["cs"] + res["ts"] + res["html"] + res["other"]
    if total > 0:
        files_str = ", ".join(res["files"][:5])
        if len(res["files"]) > 5:
            files_str += f" and {len(res['files']) - 5} more"
        print(f"{t}|{res['cs']}|{res['ts']}|{res['html']}|{res['other']}|{files_str}")
    else:
        print(f"{t}|0|0|0|0|NONE")
