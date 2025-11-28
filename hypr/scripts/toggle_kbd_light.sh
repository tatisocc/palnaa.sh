#!/bin/bash

DEVICE="tpacpi::kbd_backlight"
MAX_BRIGHTNESS=2 # Nivel Alto/ON

CURRENT=$(brightnessctl -d $DEVICE get)

if [ "$CURRENT" -gt 0 ]; then
    # Si está en el nivel 1 o 2 (Encendido), apagar
    brightnessctl -d $DEVICE set 0
else
    # Si está en el nivel 0 (Apagado), encender al máximo (2)
    brightnessctl -d $DEVICE set $MAX_BRIGHTNESS
fi
