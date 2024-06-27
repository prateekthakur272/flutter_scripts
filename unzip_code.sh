#!/bin/bash
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <zip_file_path> <destination_directory>"
    exit 1
fi

ZIP_FILE=$1
DEST_DIR=$2

# Unzip the file
unzip "$ZIP_FILE" -d "$DEST_DIR"

echo "Unzipped $ZIP_FILE to $DEST_DIR"

# Remove __MACOSX folder if it exists
if [ -d "$DEST_DIR/__MACOSX" ]; then
    echo "Removing __MACOSX folder..."
    rm -rf "$DEST_DIR/__MACOSX"
fi
