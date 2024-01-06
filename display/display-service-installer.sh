#!/bin/bash

set -e

INSTALL_DIR="/home/$USER/OpenNept4une"

# Run the first script
chmod +x "$INSTALL_DIR/display/display-env-install.sh" && sudo "$INSTALL_DIR/display/display-env-install.sh"

# Define the service file path, script path, and log file path
SERVICE_FILE="/etc/systemd/system/display.service"
SCRIPT_PATH="$INSTALL_DIR/display/display.py"
VENV_PATH="$INSTALL_DIR/display/venv"
LOG_FILE="/var/log/display.log"

# Check if the script exists
if [ ! -f "$SCRIPT_PATH" ]; then
    echo "Error: Script $SCRIPT_PATH not found."
    exit 1
fi

# Create the systemd service file
echo "Creating systemd service file at $SERVICE_FILE..."
cat <<EOF | sudo tee $SERVICE_FILE > /dev/null
[Unit]
Description=Elegoo Neptune Display Driver
After=network.target

[Service]
ExecStartPre=/bin/sleep 30
ExecStart=$VENV_PATH/bin/python $SCRIPT_PATH >> $LOG_FILE 2>&1
WorkingDirectory=$(dirname "$SCRIPT_PATH")
Restart=always
User=$USER

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd to read new service file
echo "Reloading systemd..."
sudo systemctl daemon-reload

# Enable and start the service
echo "Enabling and starting the service..."
sudo systemctl enable display.service
sudo systemctl start display.service

echo "Service setup complete."
