
# CONFIGURACIÓN PERSONAL.

#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    # done = Modificación lista.

#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# PRENDIENTES:

    # Firmware de lector de huellas digitales.
    # Configurar waybar.

#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ALIASES --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

        alias ls='ls --color=auto' #............................................ done .... "Enlista con color distintos los archivos, directorios y ejecutables."
        alias grep='grep --color=auto' #........................................ done .... "Enlista con color las coincidencias de texto."

        alias fetch='fastfetch' #............................................... done .... "Activa fastfetch."
        alias a='commandss' #................................................... done .... "Listado de comandos y atajos."
        alias x='cd -' #........................................................ done .... "Retrocede al directorio anterior."
        alias c='clear' #....................................................... done .... "Limpiar terimnal."
        alias arc='ranger' #.................................................... done .... "Visor de archivos."
        alias up='sudo pacman -Syu' #........................................... done .... "Actualizar paquetes instalados."
        alias die='sudo shutdown now' #......................................... done .... "Apagar sistema."
        alias upda='source ~/.bashrc && source ~/.bash_aliases' #....' #........ done .... "Actualizar cambios de .bash_aliases y .bashrc"
        alias setwp='bash ~/.config/hypr/scripts/set_wallpaper.sh' #............ done .... "Establecer nuevo wallpaper."

        alias venvon='source venv/bin/bash'
        alias venvoff='deactivate'

#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        
function d(){ #................................................................. done .... "Elimina permanentemente directorios y archivos con confirmación."

    local target="$@"
    
    if [ -z "$target" ]; then
        echo -e "Uso: 'd' elimina PERMANENTE lo seleccionado; escribe el nombre del archivo después del comando. (d ejemplo.sh)"
        return 1
    fi

    read -r -p "¿Estás seguro de que quieres eliminar PERMANENTEMENTE \"$target\"? (y/n): " confirmation

    if [[ "$confirmation" =~ ^[Yy]$ ]]; then

        rm -rf "$target"
        
        if [ $? -eq 0 ]; then
            echo -e "\"$target\" y su contenido eliminado con éxito."
            ls
        else
            echo -e "Fallo al eliminar: \"$target\". (Verifica los permisos)" 
        fi
    else
        echo "Eliminación cancelada."
    fi
    
    }

#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function p(){ #................................................................. done .... "Activa y desactiva permisos de ejecución."

    if [ -z "$1" ]; then
        echo -e "Uso: 'p' activa y desactiva los permisos de ejecución; escribe el nombre del archivo después del comando. (p ejemplo.sh)"
        return 1
    fi

    local ARCHIVO="$1"

    if [ -x $ARCHIVO ]; then
        chmod -x "$ARCHIVO"
        echo -e "Permiso de ejecucuón retirado."
    else 
        chmod +x "$ARCHIVO"
        echo -e "Permiso de ejecución otorgado."
    fi

}

#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function _() { #................................................................ done .... "Ejecutar scripts con ./"
    
    ./"$1"

}

#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function mkcd() { #............................................................. done .... "Hacer y viajar a directorio."
	
    mkdir -p "$1" && cd "$1"

}

#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function expy3() { #............................................................ done .... "Ejecutar scripts con formato python3."

	python3 "$@"

}

#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

commandss() { #................................................................. done .... "Lista de comandos."

    cat << 'EOF'
    
   personales.                            hyprland.                              osint.
 • goto ......... Busca un objetivo.    • WIN + Tab ........ Abre terminal.    • PrtSc ................... Screenshot.
 • mkcd .............. Crea y viaja.    • WIN + Backspace . Cerrar ventana.    • WIN + Clic + Drag . Arrastra ventana.
 • x............. Último directorio.    • WIN + K ......... Luz de teclado.    • WIN + Shift + 1/0 .... Mover ventana.
 • c ............. Limpiar terminal.    • WIN + Arrows .... Cambia pestaña.    • WIN + L ....... Reiniciar escritorio.
 • fuck .............. Elimina apps.    • WIN + 1/0 .... Cambia escritorio.    • ghost ................ Rastreo OSINT.
 • die ............. Apagar sistema.    • WIN + Q ................... rofi.
 • dev ................ Prepara VSC.    • WIN + W ................. vscode.
 • expy3 ........ Scripts 'python3'.    • ascit ................... matriz. 
 • p ..................... Permisos.    • F2 ..................... -5% vol.
 • _ ............. Scripts con './'.    • F3 ..................... +5% vol.
 • up .......... Actualiza paquetes.    • F4 .................. Mic ON/OFF. 
 • upda ......... Actualiza aliases.    • F5 .................. Brillo -5%.
 • setwp ........ Fondo de Pantalla.    • F6 .................. Brillo +5%.

EOF
}

#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function dev() { #.............................................................. done .... "Desarrollar proyecto en vscode."
    local TARGET="$1"

    if [ -z "$TARGET" ]; then
        echo -e "Debes especificar un nombre de archivo, carpeta o patrón de búsqueda."
        return 1
    fi
    
    local COINCIDENCIAS 
    COINCIDENCIAS=$(find ~ -iname "*$TARGET*" -print 2>/dev/null) 
    
    IFS=$'\n' read -r -d '' -a RESULTADOS <<< "$COINCIDENCIAS" 
    
    local NUM_RESULTADOS=${#RESULTADOS[@]} 
    local RUTA_FINAL="" 

    if [ "$NUM_RESULTADOS" -gt 0 ]; then 

        echo -e "Se encontraron $NUM_RESULTADOS coincidencias para '$TARGET'. Selecciona un número: \n" 
          
        for i in "${!RESULTADOS[@]}"; do 
            local RUTA="${RESULTADOS[i]}" 
            local TIPO="Archivo" 
            if [ -d "$RUTA" ]; then 
                TIPO="Directorio" 
            fi 
            local NOMBRE_ITEM=$(basename "$RUTA") 
            local RUTA_DIRECTORIO=$(dirname "$RUTA") 

            echo -e "$((i+1)). [$TIPO] $NOMBRE_ITEM (${RUTA_DIRECTORIO})" 
        done 
          
        echo "" 

        read -r -p "Introduce (1-$NUM_RESULTADOS): " SELECCION 

        if [[ "$SELECCION" == "exit" ]]; then 
            echo "Cancelando." 
            return 0 
        fi 

        if [[ "$SELECCION" =~ ^[0-9]+$ ]] && [ "$SELECCION" -ge 1 ] && [ "$SELECCION" -le "$NUM_RESULTADOS" ]; then 
            RUTA_FINAL="${RESULTADOS[$((SELECCION-1))]}" 
        else 
            echo "Cancelando." 
            return 1 
        fi 
          
        _dev_open "$RUTA_FINAL" 
          
    else 

        local RUTA_CREACION="$HOME/$TARGET"
        read -r -p "No se encontró. ¿Deseas crear el directorio '$TARGET' en $HOME? (y/n): " confirmation

        if [[ "$confirmation" =~ ^[Yy]$ ]]; then
            
            echo "Creando directorio: '$RUTA_CREACION'."
            
            if [ ! -d "$RUTA_CREACION" ]; then
                mkdir -p "$RUTA_CREACION" || { echo "Fallo al crear el directorio."; return 1; }
            fi
            
            _dev_open "$RUTA_CREACION"
            echo "Entorno de desarrollo para '$TARGET' listo."
            
        else
            echo "Cancelando"
            return 0
        fi
        
    fi
    
    return 0
}

function _dev_open() { #........................................................ done .... "Abir proyecto en vscode."
    local RUTA_FINAL="$1" 
     
    if command -v code &> /dev/null; then 
        ( code "$RUTA_FINAL" > /dev/null 2>&1 & disown ) 

    elif [ -d "$RUTA_FINAL" ]; then 

        echo "Navegando a: $RUTA_FINAL" 
        cd "$RUTA_FINAL" 
         
    else 

        echo "El comando 'code' no se encontró. No se pudo abrir el entorno." 
        return 1 
    fi 
}

#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function goto() { #............................................................. done .... "Navegación profunda."
    local TARGET="$1"

    if [ -z "$TARGET" ]; then
        echo "Debe escribir el objetivo de búsqueda después de 'goto'."
        return 1
    fi
    
    local COINCIDENCIAS_EXACTAS
    COINCIDENCIAS_EXACTAS=$(find ~ -maxdepth 5 \( -name "$TARGET" -o -iname "$TARGET" \) -print 2>/dev/null)
    
    IFS=$'\n' read -r -d '' -a RESULTADOS_EXACTOS <<< "$COINCIDENCIAS_EXACTAS"
    local NUM_EXACTOS=${#RESULTADOS_EXACTOS[@]}

    local COINCIDENCIAS_PARCIALES
    COINCIDENCIAS_PARCIALES=$(find ~ -maxdepth 3 -iname "*$TARGET*" -not \( -name "$TARGET" -o -iname "$TARGET" \) -print 2>/dev/null)

    IFS=$'\n' read -r -d '' -a RESULTADOS_PARCIALES <<< "$COINCIDENCIAS_PARCIALES"
    local NUM_PARCIALES=${#RESULTADOS_PARCIALES[@]}
    
    local NUM_TOTAL=$((NUM_EXACTOS + NUM_PARCIALES))
    local RUTA_FINAL=""

    if [ "$NUM_TOTAL" -eq 0 ]; then
        echo "No se encontró ninguna coincidencia para '$TARGET'."
        return 1
    fi
    
    if [ "$NUM_EXACTOS" -gt 0 ]; then
        echo ""
        echo "Coincidencias directas ($NUM_EXACTOS):"
        
        for i in "${!RESULTADOS_EXACTOS[@]}"; do
            local RUTA="${RESULTADOS_EXACTOS[i]}"
            local NOMBRE_ITEM=$(basename "$RUTA")
            local RUTA_DIRECTORIO=$(dirname "$RUTA")
            echo "$((i+1)). [Exacta] $NOMBRE_ITEM ($RUTA_DIRECTORIO)"
        done
        echo ""
    fi

    local OFFSET="$NUM_EXACTOS"
    if [ "$NUM_PARCIALES" -gt 0 ]; then
        echo "Coincidencias parecidas ($NUM_PARCIALES):"
        
        for i in "${!RESULTADOS_PARCIALES[@]}"; do
            local RUTA="${RESULTADOS_PARCIALES[i]}"
            local NOMBRE_ITEM=$(basename "$RUTA")
            local RUTA_DIRECTORIO=$(dirname "$RUTA")
            local INDICE_GLOBAL=$((i + 1 + OFFSET))
            echo "$INDICE_GLOBAL. [Parcial] $NOMBRE_ITEM ($RUTA_DIRECTORIO)"
        done
        echo ""
    fi
    
    local LIMITE="$NUM_TOTAL"

    if [ "$NUM_TOTAL" -eq 1 ]; then
        RUTA_FINAL="${RESULTADOS_EXACTOS[0]}"
    else
        read -r -p "Introduce (1-$LIMITE): " SELECCION
        
        if [[ "$SELECCION" =~ ^[0-9]+$ ]] && [ "$SELECCION" -ge 1 ] && [ "$SELECCION" -le "$LIMITE" ]; then
            
            local INDICE=$((SELECCION - 1))
            
            if [ "$INDICE" -lt "$NUM_EXACTOS" ]; then
                RUTA_FINAL="${RESULTADOS_EXACTOS[$INDICE]}"
            else
                local INDICE_PARCIAL=$((INDICE - NUM_EXACTOS))
                RUTA_FINAL="${RESULTADOS_PARCIALES[$INDICE_PARCIAL]}"
            fi
        else
            echo "Cancelando."
            return 1
        fi
    fi

    if [ -d "$RUTA_FINAL" ]; then
        cd "$RUTA_FINAL" && ls
    elif [ -f "$RUTA_FINAL" ]; then
        local DIRECTORIO_CONTENEDOR
        DIRECTORIO_CONTENEDOR=$(dirname "$RUTA_FINAL")
        
        cd "$DIRECTORIO_CONTENEDOR"
    else
        echo "El objetivo no es válido."
        return 1
    fi
}

#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function print_skull() { #...................................................... done .... "Imprime arte ASCII."
    cat << 'EOF'

    fuck.v.1 ----------------------------------------------------------
    |                      ..::!~!!!!!:.                              |                              
    |                   .xUHWH!! !!?M88WHX:.                          |                              
    |                 .X*#M@$!!  !X!M$$$$$$WWx:.                      |                              
    |               :!!!!!!?H! :!$!$$$$$$$$$$8X:                      |                              
    |              !!~  ~:~!! :~!$!#$$$$$$$$$$8X:                     |                              
    |             !:!~::!H!<   ~.U$X!?R$$$$$$$$MM!                    |                              
    |             !~!~!!!!~~ .:XW$$$U!!?$$$$$$RMM!                    |                              
    |              !!!:~~~ .:!M"T#$$$$WX??#MRRMMM!                    |                              
    |              !!~?WuxiW*`   `"#$$$$8!!!!??!!!                    |                              
    |              :X- M$$$$       `"T#$T~!8$WUXU~                    |                              
    |             :%`  ~#$$$m:        ~!~ ?$$$$$$"                    |                              
    | |:_        :!`.-   ~T$$$$8xx.  .xWW- ~""##*                     |                               
    | ::::-_  _#:<` !    ~?T#$$@@W@*?$$      /`                       |                              
    | W$@M!!! .!~~ !!     .:XUW$W!~ `"~:    :                         |     
    | #"~~`.:x%`!!  !H:   !WM$$$$Ti.: .!WUn+!`                        |              
    | :::~:!!`:X~ .: ?H.!u  $$$B$$$!W:U!T$$M!                         |                              
    | .~~   :X@!.-~   ?@WTWo(" $$$W$TH$! `                            |                              
    | Wi.~!X$?!-~    : ?$$$B$Wu( *$ M!                                |                              
    | $R@i.~~ !     :   ~$$$$$B$$en:;_                                |                        
    | ?MXT@Wx.~    :#    ~"##*$$$$ .:$#:-._                           |
    ----------------------------------------------------------- by @tat

EOF
}

function fuck() { #............................................................. done .... "Eliminación profunda de aplicaciones."

    if [ -z "$1" ]; then
        echo "Para usar 'fuck' debes especificar el nombre de la aplicación que deseas eliminar."
        return 1
    fi

    local APP_NAME="$1"
    local APP_LOWER=$(echo "$APP_NAME" | tr '[:upper:]' '[:lower:]')
    local FILES_TO_CHECK=()

    local LOCATIONS=(
        "$HOME/.config/$APP_NAME"
        "$HOME/.config/$APP_LOWER"
        "$HOME/.local/share/$APP_NAME"
        "$HOME/.local/share/$APP_LOWER"
        "$HOME/.cache/$APP_NAME"
        "$HOME/.cache/$APP_LOWER"
        "$HOME/.$APP_LOWER"
    )
    
    for dir in "${LOCATIONS[@]}"; do
        if [ -d "$dir" ] || [ -f "$dir" ]; then
            FILES_TO_CHECK+=("$dir")
        fi
    done
    
    local PACKAGES_LIST=()
    local IFS=$'\n' 

    if command -v dpkg &> /dev/null; then
        PACKAGES_LIST+=( $(dpkg -l | grep -i "$APP_NAME" | awk '{print "PAQUETE (SUDO): "$2}') )
    elif command -v dnf &> /dev/null; then
        PACKAGES_LIST+=( $(dnf list installed | grep -i "$APP_NAME" | awk '{print "PAQUETE (SUDO): "$1}') )
    elif command -v pacman &> /dev/null; then
        PACKAGES_LIST+=( $(pacman -Qq | grep -i "$APP_NAME" | awk '{print "PAQUETE (SUDO): "$1}') )
    fi

    if command -v snap &> /dev/null; then
        local SNAP_PKGS
        SNAP_PKGS=$(snap list --all | grep -i "$APP_NAME" | awk '{print "SNAP (SUDO): "$1}')
        if [ ! -z "$SNAP_PKGS" ]; then
            PACKAGES_LIST+=( $SNAP_PKGS )
        fi
    fi

    if command -v flatpak &> /dev/null; then
        local FLATPAK_PKGS
        FLATPAK_PKGS=$(flatpak list --app | grep -i "$APP_NAME" | awk '{print "FLATPAK (USUARIO): "$1}')
        if [ ! -z "$FLATPAK_PKGS" ]; then
            PACKAGES_LIST+=( $FLATPAK_PKGS )
        fi
    fi
    
    unset IFS 

    for item in "${PACKAGES_LIST[@]}"; do
        FILES_TO_CHECK+=("$item")
    done

    local NUM_RESULTS=${#FILES_TO_CHECK[@]}

    if [ "$NUM_RESULTS" -eq 0 ]; then
        echo "No se encontraron archivos o paquetes relacionados con '$APP_NAME' en ubicaciones comunes."
        return 0
    fi

    #print_skull

    echo "Se encontraron $NUM_RESULTS elementos relacionados con '$APP_NAME'."
    
    echo "" 
    for i in "${!FILES_TO_CHECK[@]}"; do
        echo "$((i+1)). ${FILES_TO_CHECK[i]}"
    done
    echo "" 
    
    read -r -p "Selecciona los números con comas (o 'all' / 'exit'): " SELECCION

    if [[ "$SELECCION" == "exit" ]]; then
        echo "Cancelando."
        return 0
    fi
    
    if [[ "$SELECCION" == "all" ]]; then
        SELECCION=$(seq -s, 1 "$NUM_RESULTS")
    fi

    local ITEMS_TO_DELETE=()
    local IFS=','
    read -ra SELECCION_ARRAY <<< "$SELECCION"

    for num_str in "${SELECCION_ARRAY[@]}"; do
        if [ -z "$num_str" ]; then
            continue
        fi
        local num=$((num_str - 1))
        if [ "$num" -ge 0 ] && [ "$num" -lt "$NUM_RESULTS" ]; then
            ITEMS_TO_DELETE+=("${FILES_TO_CHECK[num]}")
        else
            echo "Advertencia: Número '$num_str' fuera de rango. Ignorado."
        fi
    done

    if [ ${#ITEMS_TO_DELETE[@]} -eq 0 ]; then
        echo "Cancelando."
        return 0
    fi
    
    echo "Elementos seleccionados para ELIMINAR:"
    echo
    for item in "${ITEMS_TO_DELETE[@]}"; do
        if [[ "$item" == *PAQUETE* ]]; then
            echo "[PAQUETE] $item"
        elif [[ "$item" == *SNAP* ]]; then
            echo "[SNAP] $item"
        elif [[ "$item" == *FLATPAK* ]]; then
            echo "[FLATPAK] $item"
        else
            echo "[ARCHIVO/DIR] $item"
        fi
    done
    echo
    
    echo "Se eliminarán ${#ITEMS_TO_DELETE[@]} elementos (incluyendo paquetes con sudo)."
    read -r -p "Escribe las palabras 'fuck it' sin el espacio para confirmar la eliminación: " FINAL_CONFIRM    
    if [[ "$FINAL_CONFIRM" != "fuckit" ]]; then
        echo "Operación cancelada por el usuario. No se ha eliminado nada."
        return 0
    fi
    
    echo "Iniciando eliminación... (Se puede requerir contraseña de SUDO)"
    
    for item in "${ITEMS_TO_DELETE[@]}"; do
        
        if [[ "$item" == PAQUETE* ]]; then
            local PKG_NAME=$(echo "$item" | sed 's/PAQUETE (SUDO): //')
            echo "Desinstalando paquete: $PKG_NAME"
            if command -v apt-get &> /dev/null; then
                sudo apt-get purge "$PKG_NAME" -y
            elif command -v dnf &> /dev/null; then
                sudo dnf remove "$PKG_NAME" -y
            elif command -v pacman &> /dev/null; then
                sudo pacman -Rsn "$PKG_NAME" --noconfirm
            fi
            
        elif [[ "$item" == SNAP* ]]; then
            local PKG_NAME=$(echo "$item" | sed 's/SNAP (SUDO): //')
            echo "Desinstalando Snap: $PKG_NAME"
            sudo snap remove "$PKG_NAME"
            
        elif [[ "$item" == FLATPAK* ]]; then
            local PKG_NAME=$(echo "$item" | sed 's/FLATPAK (USUARIO): //')
            echo "Desinstalando Flatpak: $PKG_NAME"
            flatpak uninstall "$PKG_NAME" --delete-data -y
            
        else
            echo "Eliminando residual: $item"
            rm -rf "$item"
        fi
    done

    if [ $(echo "${ITEMS_TO_DELETE[@]}" | grep -c PAQUETE) -gt 0 ]; then
        echo "Limpiando dependencias no utilizadas (autoremove)..."
        if command -v apt-get &> /dev/null; then
            sudo apt-get autoremove -y
        elif command -v dnf &> /dev/null; then
            sudo dnf autoremove -y
        fi
    fi
    
    echo "Limpieza profunda y selectiva de '$APP_NAME' completada."
}
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function ghur() {
    cd ~/.nemo/salar/ghur_main
    source venv/bin/activate
    python ghur
    deactivate
}
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
