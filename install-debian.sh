#!/usr/bin/env bash
set -e

INSTALL_DIR="/usr/local/bin"
SCRIPT_NAME="a2fetch"

# Check if script exists
if [ ! -f "$SCRIPT_NAME" ]; then
  echo "Error: $SCRIPT_NAME not found in the current directory."
  exit 1
fi

# Ensure dependencies (aria2)
if ! command -v aria2c >/dev/null 2>&1; then
  echo "aria2 not found. Installing via apt..."
  sudo apt update
  sudo apt install -y aria2
fi

# Install the script
echo "Installing $SCRIPT_NAME to $INSTALL_DIR..."
sudo cp "$SCRIPT_NAME" "$INSTALL_DIR/"
sudo chmod +x "$INSTALL_DIR/$SCRIPT_NAME"

echo "✅ $SCRIPT_NAME installed successfully."
echo "You can now use '$SCRIPT_NAME' from anywhere in your shell_
