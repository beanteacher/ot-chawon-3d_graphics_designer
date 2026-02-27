#!/usr/bin/env bash
set -euo pipefail

MANIFEST="${1:-assets/manifest-v0.csv}"
OUT="${2:-docs/day10-qc-summary.txt}"

if [ ! -f "$MANIFEST" ]; then
  echo "[FAIL] missing manifest: $MANIFEST"
  exit 1
fi

total=$(( $(wc -l < "$MANIFEST") - 1 ))
ready=$(tail -n +2 "$MANIFEST" | rg -c ',ready$' || true)
review=$(tail -n +2 "$MANIFEST" | rg -c ',review$' || true)

{
  echo "QC Summary"
  echo "=========="
  echo "total: $total"
  echo "ready: $ready"
  echo "review: $review"
} > "$OUT"

echo "[DONE] wrote $OUT"
