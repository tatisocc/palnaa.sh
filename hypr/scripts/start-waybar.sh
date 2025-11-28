#!/bin/bash
# Evita que se apilen si ya están abiertas
killall waybar

# Inicia la barra en segundo plano, asegurando que sea persistente
waybar &
