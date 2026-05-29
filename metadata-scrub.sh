#!/usr/bin/env bash
set -euo pipefail

if [[ $# -eq 0 ]]; then
  echo "Usage: $0 <folder>" >&2
  exit 1
fi

FOLDER="$1"

if [[ ! -d "$FOLDER" ]]; then
  echo "Error: Folder '$FOLDER' not found." >&2
  exit 1
fi

count=0
while IFS= read -r -d '' f; do
  exiftool -overwrite_original -all= "$f" || echo "WARN: exiftool failed on '$f'" >&2
  count=$(( count + 1 ))
done < <(find "$FOLDER" -type f \( \
  -iname "*.jpg"  -o -iname "*.jpeg" -o -iname "*.png"  -o -iname "*.gif" \
  -o -iname "*.tiff" -o -iname "*.bmp" -o -iname "*.webp" \
\) -print0)
if [[ "$count" -eq 0 ]]; then
  echo "No matching files found in '$FOLDER'."
else
  echo "Metadata removed from $count file(s) in '$FOLDER'."
fi
