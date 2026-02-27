#!/usr/bin/env bash
set -euo pipefail

manifest="${1:-assets/manifest-v0.csv}"
out="${2:-docs/day8-qc-report.md}"
mkdir -p "$(dirname "$out")"

total=0
fail_name=0
missing=0

{
  echo "# QC Report"
  echo
  echo "| file | name_check | file_exists |"
  echo "|---|---|---|"

  while IFS=',' read -r brand item color lod filename target; do
    if [ "$brand" = "brand" ]; then
      continue
    fi
    total=$((total+1))

    if ./scripts/validate_name.sh "$filename" >/dev/null 2>&1; then
      name_check="PASS"
    else
      name_check="FAIL"
      fail_name=$((fail_name+1))
    fi

    if [ -f "$filename" ]; then
      file_exists="YES"
    else
      file_exists="NO"
      missing=$((missing+1))
    fi

    echo "| $filename | $name_check | $file_exists |"
  done < "$manifest"

  echo
  echo "## Summary"
  echo "- total: $total"
  echo "- name_fail: $fail_name"
  echo "- missing_files: $missing"
} > "$out"

echo "written: $out"
