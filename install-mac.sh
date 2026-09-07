#!/usr/bin/env bash
set -euo pipefail

SCRIPT_NAME="a2fetch"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd || echo ".")"

# Determine target installation directory on macOS
if [ -n "${INSTALL_DIR:-}" ]; then
  TARGET_DIR="$INSTALL_DIR"
elif [ -d "/opt/homebrew/bin" ] && [ -w "/opt/homebrew/bin" ]; then
  TARGET_DIR="/opt/homebrew/bin"
elif [ -d "/usr/local/bin" ] && [ -w "/usr/local/bin" ]; then
  TARGET_DIR="/usr/local/bin"
else
  TARGET_DIR="${HOME}/.local/bin"
fi

echo "================================================================="
echo "🍎 Installing $SCRIPT_NAME on macOS to $TARGET_DIR"
echo "================================================================="

# Check / install dependencies on macOS
if ! command -v aria2c &>/dev/null; then
  echo "⚠️  'aria2c' was not detected in PATH."
  if command -v brew &>/dev/null; then
    echo "Installing aria2 via Homebrew..."
    brew install aria2 || {
      echo "⚠️  Failed to install aria2 automatically via brew."
      echo "Please run manually: brew install aria2"
    }
  else
    echo "Homebrew was not detected. Please install aria2 manually, e.g.:"
    echo "  brew install aria2"
  fi
fi

# Create target directory if needed
mkdir -p "$TARGET_DIR"

# Install script (local copy if available, or fetch from GitHub)
if [ -f "$SCRIPT_DIR/$SCRIPT_NAME" ]; then
  cp "$SCRIPT_DIR/$SCRIPT_NAME" "$TARGET_DIR/$SCRIPT_NAME"
else
  echo "Fetching latest $SCRIPT_NAME from repository..."
  curl -fsSL "https://raw.githubusercontent.com/EOX-A/a2fetch/main/$SCRIPT_NAME" -o "$TARGET_DIR/$SCRIPT_NAME"
fi
chmod +x "$TARGET_DIR/$SCRIPT_NAME"

echo "✅ $SCRIPT_NAME installed successfully to $TARGET_DIR/$SCRIPT_NAME"

# Check if TARGET_DIR is in PATH
if [[ ":$PATH:" != *":$TARGET_DIR:"* ]]; then
  echo
  echo "💡 NOTE: '$TARGET_DIR' is not in your current PATH."
  echo "Add it to your shell configuration (e.g., ~/.zshrc or ~/.bash_profile):"
  echo "  export PATH=\"$TARGET_DIR:\$PATH\""
else
  echo "You can now run '$SCRIPT_NAME' from anywhere in your shell!"
fi
