#!/bin/bash
# ----------------------------------------------------
# Script para seleccionar y aplicar un fondo de pantalla
# Uso: yad (selector gráfico) y swaybg (aplicador Wayland)
# ----------------------------------------------------

# 1. Ejecuta YAD para mostrar la ventana gráfica de selección de archivos.
#    Solo permite seleccionar archivos de imagen (.png, .jpg, .jpeg).
WALLPAPER_PATH=$(yad --title="Seleccionar Fondo de Pantalla" --file --add-filter='Imágenes | *.png | *.jpg | *.jpeg')

# $? almacena el código de salida del último comando. 0 = OK (Seleccionado), 1 = Cancelar.
if [ $? -eq 0 ] && [ -n "$WALLPAPER_PATH" ]; then
    
    # 2. Mata el proceso antiguo de swaybg para que el nuevo tome el control.
    killall swaybg
    
    # 3. Aplica la nueva imagen con swaybg.
    #    -i: input file (archivo de entrada)
    #    -m fill: modo de escalado para llenar la pantalla
    #    &: ejecuta en segundo plano
    swaybg -i "$WALLPAPER_PATH" -m fill & 

    # 4. Guarda el comando en un archivo de inicio para que Hyprland
    #    lo ejecute automáticamente al reiniciar o recargar (exec-once).
    #    Añadimos 'sleep 1' para dar tiempo a Hyprland a iniciarse antes de dibujar el fondo.
    echo "sleep 1 && swaybg -i \"$WALLPAPER_PATH\" -m fill &" > ~/.config/hypr/startup_wallpaper.sh
    
    # NOTA: Este comando también se aplicará al instante gracias a 'swaybg -i ... &'
fi