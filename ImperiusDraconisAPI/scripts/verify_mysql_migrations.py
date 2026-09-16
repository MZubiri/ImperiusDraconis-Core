"""Run from repository root against an isolated container named id-remediation-mysql.
Run twice to verify rerun behavior. Creates only the remediation test schema.
"""
from pathlib import Path
import subprocess,re,sys
base='''CREATE DATABASE IF NOT EXISTS remediation CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE remediation;
CREATE TABLE IF NOT EXISTS Alumnos (IdAlumno INT PRIMARY KEY, Codigo VARCHAR(20), Nombre VARCHAR(100), IdCasa INT, Activo TINYINT DEFAULT 1, Dracoins DECIMAL(18,2) DEFAULT 0);
CREATE TABLE IF NOT EXISTS Casas (IdCasa INT PRIMARY KEY, Nombre VARCHAR(100));
CREATE TABLE IF NOT EXISTS Cargos (IdCargo INT PRIMARY KEY, Nombre VARCHAR(100));
CREATE TABLE IF NOT EXISTS Trabajos (IdTrabajo INT PRIMARY KEY);
CREATE TABLE IF NOT EXISTS Permisos (IdCargo INT, Controlador VARCHAR(100), Accion VARCHAR(100), TienePermiso TINYINT);
CREATE TABLE IF NOT EXISTS PermisosTrabajos (IdTrabajo INT, Controlador VARCHAR(100), Accion VARCHAR(100), TienePermiso TINYINT);
'''
subprocess.run(['docker','exec','-i','id-remediation-mysql','mysql','-uroot'],input=base,text=True,check=True)
for p in sorted(Path('ImperiusDraconisAPI/ImperiusDraconisAPI/SQLMigrar').glob('*.sql')):
 script='DELIMITER $$\n'+'\n'.join(x.strip()+'$$' for x in re.split(r'^GO\s*$',p.read_text(),flags=re.M) if x.strip())
 r=subprocess.run(['docker','exec','-i','id-remediation-mysql','mysql','-uroot','remediation'],input=script,text=True,capture_output=True)
 print(p.name, 'PASS' if not r.returncode else r.stderr[-1800:])
 if r.returncode: sys.exit(1)
