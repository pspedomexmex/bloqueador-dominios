#!/bin/bash

# ========= CONFIGURACIÓN ========= #
LISTA_URL="https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
HOSTS_FILE="/etc/hosts"
BACKUP="/etc/hosts.bak"
TEMP="/tmp/hosts_malware.txt"
SCRIPT_PATH="$(realpath "$0")"
MANUAL_TAG="# BLOQUEO_MANUAL"
# ================================= #

# ===== FUNCIONES ===== #
mostrar_bloqueos_manuales() {
    echo -e "[INFO] Dominios bloqueados manualmente:\n"
    grep "$MANUAL_TAG" "$HOSTS_FILE" | awk '{print $2}' | sort | uniq
    echo -e "\n--------------------------------------------"
}

bloquear_webs() {
    clear
    echo "[INFO] Descargando lista pública desde:"
    echo "       $LISTA_URL"
    [[ ! -f "$BACKUP" ]] && cp "$HOSTS_FILE" "$BACKUP" && echo "[INFO] Respaldo creado en $BACKUP"

    curl -s "$LISTA_URL" -o "$TEMP" || { echo "[!] Error al descargar lista"; exit 1; }

    grep "^127.0.0.1" "$TEMP" | grep -v "localhost" | while read -r linea; do
        if ! grep -qF "$linea" "$HOSTS_FILE"; then
            echo "$linea" >> "$HOSTS_FILE"
        fi
    done

    echo -e "[OK] Sitios maliciosos bloqueados desde lista pública.\n"
    read -p "Presiona [Enter] para volver al menú..."
    clear
}

agendar_script() {
    clear
    echo "📅 Selecciona la frecuencia de ejecución automática:"
    select frecuencia in "Al iniciar el sistema" "Diariamente" "Semanalmente" "Mensualmente" "Personalizado (cron)" "Volver al menú anterior"; do
        case $REPLY in
            1) CRON_LINE="@reboot bash $SCRIPT_PATH"; break ;;
            2) CRON_LINE="@daily bash $SCRIPT_PATH"; break ;;
            3) CRON_LINE="@weekly bash $SCRIPT_PATH"; break ;;
            4) CRON_LINE="@monthly bash $SCRIPT_PATH"; break ;;
            5)
                read -rp "Expresión cron personalizada (ej. '0 */6 * * *'): " CUSTOM
                CRON_LINE="$CUSTOM bash $SCRIPT_PATH"
                break
                ;;
            6) clear; return ;;
            *) echo "[!] Opción inválida." ;;
        esac
    done

    (crontab -l 2>/dev/null | grep -vF "$SCRIPT_PATH"; echo "$CRON_LINE") | crontab -
    echo -e "\n[OK] Script agendado con éxito."
    read -p "Presiona [Enter] para volver al menú..."
    clear
}

desagendar_script() {
    clear
    crontab -l 2>/dev/null | grep -vF "$SCRIPT_PATH" | crontab -
    echo -e "[OK] Ejecución automática desactivada.\n"
    read -p "Presiona [Enter] para volver al menú..."
    clear
}

agregar_manual() {
    clear
    read -rp "🔹 Dominio a bloquear (ej: facebook.com): " dominio
    if grep -q "$dominio" "$HOSTS_FILE"; then
        echo "[~] Este dominio ya está bloqueado."
    else
        echo "127.0.0.1 $dominio $MANUAL_TAG" >> "$HOSTS_FILE"
        echo "127.0.0.1 www.$dominio $MANUAL_TAG" >> "$HOSTS_FILE"
        echo "[OK] Dominio bloqueado manualmente: $dominio"
    fi
    read -p "Presiona [Enter] para continuar..."
    clear
}

quitar_bloqueo() {
    clear
    read -rp "🔸 Dominio a desbloquear (ej: facebook.com): " dominio
    sed -i "/$dominio.*$MANUAL_TAG/d" "$HOSTS_FILE"
    echo "[-] Bloqueo eliminado para: $dominio"
    read -p "Presiona [Enter] para continuar..."
    clear
}
# ===================== #

# ===== VERIFICACIÓN DE ROOT ===== #
if [[ $EUID -ne 0 ]]; then
    echo "[!] Este script debe ejecutarse como root."
    exit 1
fi

# ===== INTERFAZ INICIAL ===== #
clear
echo "============================================"
echo "🛡️  BLOQUEADOR DE DOMINIOS MALICIOSOS - v. 1.0"
echo "📚 Basado en lista pública: StevenBlack/hosts"
echo "============================================"
echo ""
mostrar_bloqueos_manuales

# ===== MENÚ PRINCIPAL ===== #
while true; do
    echo "MENÚ PRINCIPAL:"
    echo "1) Bloquear sitios desde lista pública"
    echo "2) Gestión manual de dominios"
    echo "3) Configurar ejecución automática"
    echo "4) Salir"
    read -rp $'\nSeleccione una opción (1-4): ' opcion

    case "$opcion" in
        1) bloquear_webs ;;
        2)
            clear
            echo "GESTIÓN MANUAL DE DOMINIOS:"
            echo "1) Agregar dominio manualmente"
            echo "2) Quitar bloqueo a un dominio"
            echo "3) Volver al menú principal"
            read -rp $'\nSeleccione una opción (1-3): ' subop
            case "$subop" in
                1) agregar_manual ;;
                2) quitar_bloqueo ;;
                3) clear ;;
                *) echo "[!] Opción inválida." ;;
            esac
            ;;
        3)
            clear
            echo "CONFIGURAR AGENDADO:"
            echo "1) Activar ejecución automática"
            echo "2) Desactivar ejecución automática"
            echo "3) Volver al menú principal"
            read -rp $'\nSeleccione una opción (1-3): ' subag
            case "$subag" in
                1) agendar_script ;;
                2) desagendar_script ;;
                3) clear ;;
                *) echo "[!] Opción inválida." ;;
            esac
            ;;
        4) echo -e "\n👋 Saliendo..."; exit 0 ;;
        *) echo "[!] Opción inválida." ;;
    esac
done
