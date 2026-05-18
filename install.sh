#!/bin/bash
# Install claude-profiles to ~/.local/bin

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
INSTALL_DIR="$HOME/.local/bin"

mkdir -p "$INSTALL_DIR"
mkdir -p "$HOME/.claude/profiles"

# Symlink so updates from git pull take effect immediately
ln -sf "$SCRIPT_DIR/claude-profiles" "$INSTALL_DIR/claude-profiles"
chmod +x "$SCRIPT_DIR/claude-profiles"

# Check if already in PATH
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    SHELL_RC=""
    if [[ "$SHELL" == *"zsh"* ]]; then
        SHELL_RC="$HOME/.zshrc"
    elif [[ "$SHELL" == *"bash"* ]]; then
        SHELL_RC="$HOME/.bashrc"
    fi

    if [[ -n "$SHELL_RC" ]]; then
        echo '' >> "$SHELL_RC"
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$SHELL_RC"
        echo "Added ~/.local/bin to PATH in $SHELL_RC"
        echo "Run: source $SHELL_RC"
    else
        echo "Add to your shell rc: export PATH=\"\$HOME/.local/bin:\$PATH\""
    fi
else
    echo "~/.local/bin already in PATH"
fi

echo "Installed! Run 'claude-profiles' to get started."
