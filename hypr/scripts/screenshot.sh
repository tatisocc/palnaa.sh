#!/bin/bash

DIR="$HOME/Imágenes/Capturas de pantalla"
mkdir -p "$DIR"

LOCK_FILE="/tmp/screenshot_lock"

if [ -f "$LOCK_FILE" ]; then
    exit 1
fi

touch "$LOCK_FILE"

trap "rm -f $LOCK_FILE" EXIT

FILENAME="$(date +'%Y-%m-%S.png')"
FILEPATH="$DIR/$FILENAME"

GEOMETRY=$(slurp)

if [ -n "$GEOMETRY" ]; then
    grim -g "$GEOMETRY" "$FILEPATH"

    if [ -f "$FILEPATH" ]; then
        wl-copy < "$FILEPATH"
    fi
    
fi
