#!/usr/bin/env bash
set -euo pipefail

manifest="${1:-assets/manifest-v0.csv}"
out="${2:-docs/day8-qc-report.md}"
mkdir -p "$(dirname "$out")"

{
  echo "# Day8 QC Report"
  echo
  echo "| file | name_check | file_exists |"
  echo "|---|---|---|"

  while IFS=',' read -r brand item color lod filename target; do
    if [ "$brand" = "brand" ]; then
      continue
    fi

    if ./scripts/validate_name.sh "$filename" >/dev/null 2>&1; then
      name_check="PASS"
    else
      name_check="FAIL"
    fi

    if [ -f "$filename" ]; then
      file_exists="YES"
    else
      file_exists="NO"
    fi

    echo "| $filename | $name_check | $file_exists |"
  done < "$manifest"
} > "$out"

echo "written: $out"
