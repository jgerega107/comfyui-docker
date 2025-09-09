#!/bin/bash

set -e

COMFYUI_VENV_DIR="/usr/src/venv"
COMFYUI_EXECUTABLE="main.py"
COMFYUI_REPO_URL="https://github.com/comfyanonymous/ComfyUI.git"
COMFYUI_RELEASE_VER="0.3.57"
COMFYUI_REPO_URL_DIR="/usr/src/app"

if [ ! -f "$COMFYUI_VENV_DIR/bin/activate" ]; then
    echo "Creating venv since it doesn't exist"
    python3.12 -m venv $COMFYUI_VENV_DIR
fi

echo "Activating virtual environment..."
source "$COMFYUI_VENV_DIR/bin/activate"

if [ ! -f "$COMFYUI_REPO_URL_DIR/$COMFYUI_EXECUTABLE" ]; then
    echo "Repo doesn't exist, cloning and installing reqs."
    git clone --depth 1 --branch v$COMFYUI_RELEASE_VER $COMFYUI_REPO_URL /tmp/app
    rsync -rv /tmp/app/ $COMFYUI_REPO_URL_DIR && rm -rf /tmp/app
    $COMFYUI_VENV_DIR/bin/pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu128
    $COMFYUI_VENV_DIR/bin/pip install -r $COMFYUI_REPO_URL_DIR/requirements.txt
fi

echo "Starting ComfyUI..."
cd $COMFYUI_REPO_URL_DIR && $COMFYUI_VENV_DIR/bin/python3 "$COMFYUI_EXECUTABLE" "$@"
