#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
source .venv/bin/activate
STAMP=$(date +"%Y-%m-%d")
OUT="out/weekly-$STAMP"

python main.py --site "RayMiskiewicz.com" --days 7 --plot no --out "$OUT" --preset full

# publish the newest weekly folder to GitHub Pages
./scripts/publish.sh
