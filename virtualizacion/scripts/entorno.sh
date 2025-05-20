#!/bin/bash

# Script para crear/activar entorno virtual y gestionar archivos

# Variables
VENV_NAME="mi_entorno"
BASE_DIR="$(dirname "$(realpath "$0")")/.."
VENV_DIR="$BASE_DIR/contenido/$VENV_NAME"
SRC_DIR="$VENV_DIR/src"
BACKEND_DIR="$BASE_DIR/../backend"
FRONTEND_DIR="$BASE_DIR/../frontend"

case "$1" in
    "crear")
        echo "Creando entorno virtual en $VENV_DIR..."
        python3 -m venv "$VENV_DIR"

        echo "Activando entorno..."
        source "$VENV_DIR/bin/activate"

        echo "Creando directorio src en $SRC_DIR..."
        mkdir -p "$SRC_DIR"

        echo "Copiando backend a src..."
        cp -r "$BACKEND_DIR" "$SRC_DIR/"

        echo "Copiando frontend a src..."
        cp -r "$FRONTEND_DIR" "$SRC_DIR/"

        echo "Entorno creado y archivos copiados!"
        ;;
    "sync")
        echo "Sincronizando cambios de src a backend y frontend originales..."
        
        echo "Actualizando backend..."
        cp -r "$SRC_DIR/backend/"* "$BACKEND_DIR/"
        
        echo "Actualizando frontend..."
        cp -r "$SRC_DIR/frontend/"* "$FRONTEND_DIR/"

        echo "Sincronización completada!"
        ;;
    "eliminar")
        echo "Eliminando entorno virtual en $VENV_DIR..."
        rm -rf "$VENV_DIR"
        echo "Entorno eliminado!"
        ;;
    *)
        echo "Uso: $0 {crear|sync|eliminar}"
        exit 1
        ;;
esac

