
# Check if a folder is provided
if [[ -z "$1" ]]; then
  echo "Usage: $0 <folder>"
  exit 1
fi

FOLDER="$1"

# Ensure the folder exists
if [[ ! -d "$FOLDER" ]]; then
  echo "Error: Folder '$FOLDER' not found."
  exit 1
fi

# Recursively find and scrub metadata from all image files
find "$FOLDER" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.tiff" -o -iname "*.bmp" -o -iname "*.webp" \) -print0 \
| xargs -0 -n 1 -P "$(nproc)" exiftool -overwrite_original -all=

echo "✅ Metadata removed from all images in '$FOLDER'."

