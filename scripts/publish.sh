#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."

LATEST_DIR=$(ls -1dt out/weekly-* 2>/dev/null | head -n1 || true)
if [[ -z "${LATEST_DIR}" ]]; then
  echo "No weekly folder found. Run scripts/runner.sh first."
  exit 0
fi

echo "Publishing from: ${LATEST_DIR}"

DEST="latest"
mkdir -p "${DEST}/csv" "${DEST}/plots"

# core
cp -f "${LATEST_DIR}/summary.json" "${DEST}/summary.json" || true
cp -f "${LATEST_DIR}/summary.md"   "${DEST}/summary.md"   || true

# csv
cp -f "${LATEST_DIR}/csv/pages_clean.csv"        "${DEST}/csv/pages_clean.csv" || true
cp -f "${LATEST_DIR}/csv/channels.csv"          "${DEST}/csv/channels.csv"     || true
cp -f "${LATEST_DIR}/csv/channel_cvr.csv"       "${DEST}/csv/channel_cvr.csv"  || true
cp -f "${LATEST_DIR}/csv/conversions_focus.csv" "${DEST}/csv/conversions_focus.csv" || true
cp -f "${LATEST_DIR}/csv/source_medium.csv"     "${DEST}/csv/source_medium.csv" || true

# plots (optional)
cp -f "${LATEST_DIR}/plots/users_timeseries.png"    "${DEST}/plots/users_timeseries.png" || true
cp -f "${LATEST_DIR}/plots/sessions_timeseries.png" "${DEST}/plots/sessions_timeseries.png" || true

cat > "${DEST}/index.json" <<JSON
{
  "published_from": "${LATEST_DIR}",
  "generated_at": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
}
JSON

git add public_api
git commit -m "data: publish $(basename "${LATEST_DIR}")" || true
git push origin main
echo "Published to GitHub Pages."
