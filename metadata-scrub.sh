#!/usr/bin/env bash
set -euo pipefail

BINARIES=0
FOLDER=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --binaries) BINARIES=1; shift ;;
    -*) echo "Unknown option: $1" >&2; exit 1 ;;
    *) FOLDER="$1"; shift ;;
  esac
done
if [[ -z "$FOLDER" ]]; then
  echo "Usage: $0 [--binaries] <folder>" >&2
  exit 1
fi

if [[ ! -d "$FOLDER" ]]; then
  echo "Error: Folder '$FOLDER' not found." >&2
  exit 1
fi

# RTF: exiftool support is limited — {\info} author/title blocks in older RTF files may survive -all=
count=0
while IFS= read -r -d '' f; do
  exiftool -overwrite_original -all= "$f" || echo "WARN: exiftool failed on '$f'" >&2
  count=$(( count + 1 ))
done < <(find "$FOLDER" -type f \( \
  -iname "*.jpg"  -o -iname "*.jpeg" -o -iname "*.png"  -o -iname "*.gif"  \
  -o -iname "*.tiff" -o -iname "*.bmp"  -o -iname "*.webp" \
  -o -iname "*.heic" -o -iname "*.heif" -o -iname "*.avif" \
  -o -iname "*.cr2"  -o -iname "*.nef"  -o -iname "*.arw"  \
  -o -iname "*.dng"  -o -iname "*.orf"  -o -iname "*.rw2"  \
  -o -iname "*.pdf" \
  -o -iname "*.docx" -o -iname "*.xlsx" -o -iname "*.pptx" \
  -o -iname "*.docm" -o -iname "*.xlsm" -o -iname "*.pptm" \
  -o -iname "*.doc"  -o -iname "*.xls"  -o -iname "*.ppt"  \
  -o -iname "*.odt"  -o -iname "*.ods"  -o -iname "*.odp"  \
  -o -iname "*.odg"  -o -iname "*.rtf"  \
\) -print0)
if [[ "$count" -eq 0 ]]; then
  echo "No matching files found in '$FOLDER'."
else
  echo "Metadata removed from $count file(s) in '$FOLDER'."
fi

if [[ "$BINARIES" -eq 1 ]]; then
  FOLDER=$(realpath -e -- "$FOLDER") || { echo "Error: '$FOLDER' does not exist." >&2; exit 1; }
  case "$FOLDER" in
    /|/usr|/usr/*|/nix|/nix/*|/bin|/lib|/lib64|/etc|/boot)
      echo "Error: --binaries refuses to operate on system path '$FOLDER'" >&2
      exit 1 ;;
  esac
  bin_count=0
  while IFS= read -r -d '' f; do
    mime=$(file --brief --mime-type -- "$f")
    case "$mime" in
      application/x-executable|application/x-sharedlib|application/x-pie-executable)
        strip --strip-all -- "$f" || echo "WARN: strip failed on '$f'" >&2
        bin_count=$(( bin_count + 1 )) ;;
    esac
  done < <(find "$FOLDER" -type f -print0)
  if [[ "$bin_count" -gt 0 ]]; then
    echo "Stripped debug symbols from $bin_count ELF binary/binaries in '$FOLDER'."
  else
    echo "No ELF binaries found in '$FOLDER'."
  fi
fi
