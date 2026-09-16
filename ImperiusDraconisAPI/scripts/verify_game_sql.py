"""Validate static Game queries with EXPLAIN after verify_mysql_migrations.py.
Uses only the isolated id-remediation-mysql container and remediation schema.
"""
from pathlib import Path
import re,subprocess
count=0;fail=[]
for p in Path('ImperiusDraconisAPI/ImperiusDraconisAPI/Services/Game').glob('*Service.cs'):
 for m in re.finditer(r'"""([\s\S]*?)"""|"([^"\n]*)"',p.read_text()):
  sql=(m[1] or m[2] or '').strip()
  if not re.match('(?:SELECT|UPDATE|INSERT|DELETE)\\b',sql,re.I) or '{' in sql:continue
  sql=re.sub(r'@\w+', 'NULL',sql)
  for statement in sql.split(';'):
   if not statement.strip():continue
   count+=1
   r=subprocess.run(['docker','exec','-i','id-remediation-mysql','mysql','-uroot','remediation','-N'],input='EXPLAIN '+statement+';',text=True,capture_output=True)
   if r.returncode:fail.append((p.name, r.stderr.strip(),statement[:120]))
print('Game SQL statements checked:',count)
for f in fail: print(f)
if fail: raise SystemExit(1)
