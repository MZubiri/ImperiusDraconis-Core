"""Render explicit GO-delimited migration files for the mysql command-line client.

Example:
  python3 render_mysql_batches.py path/to/017.sql path/to/018.sql | mysql ...

This program only writes SQL to stdout; it never connects to a database.
"""
import argparse
from pathlib import Path
import re
import sys

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument("scripts", nargs="+", type=Path)
args = parser.parse_args()
print("DELIMITER $$")
print("SET SESSION lock_wait_timeout = 15$$")
print("SET SESSION innodb_lock_wait_timeout = 15$$")
for path in args.scripts:
    script = path.read_text(encoding="utf-8-sig")
    if "$$" in script:
        sys.exit(f"Delimiter $$ appears in {path}; refusing ambiguous output.")
    for batch in re.split(r"^\s*GO\s*$", script, flags=re.MULTILINE | re.IGNORECASE):
        if batch.strip():
            print(batch.strip() + "$$")
print("DELIMITER ;")
