#!/bin/bash

set -e

INSTALL_DIR="/home/$USER/OpenNept4une"
VENV_PATH="$INSTALL_DIR/display/venv"

sudo apt update
sudo apt install python3-venv

# Navigate to the display script directory
cd "$INSTALL_DIR/display" || exit

# Create a Python virtual environment in the current directory
python3 -m venv $VENV_PATH

# Activate the virtual environment
source "$VENV_PATH/bin/activate"

# Install required Python packages
pip install -r requirements.txt

# Deactivate the virtual environment
deactivate
