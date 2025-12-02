#!/bin/bash

# Configuration
UUID="PeekCam@tolik518.github.io"
SOURCE_DIR="PeekCam@tolik518.github.io"
INSTALL_DIR="$HOME/.local/share/gnome-shell/extensions/$UUID"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}Installing $UUID...${NC}"

# Check if source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    echo -e "${RED}Error: Source directory '$SOURCE_DIR' not found.${NC}"
    echo "Make sure you are running this script from the root of the repository."
    exit 1
fi

# Remove existing installation to ensure a clean install
if [ -d "$INSTALL_DIR" ]; then
    echo "Removing existing installation..."
    rm -rf "$INSTALL_DIR"
fi

# Create installation directory
echo "Creating installation directory..."
mkdir -p "$INSTALL_DIR"

# Copy files
echo "Copying files..."
cp -r "$SOURCE_DIR"/* "$INSTALL_DIR/"

# Compile schemas
if [ -d "$INSTALL_DIR/schemas" ]; then
    echo "Compiling schemas..."
    glib-compile-schemas "$INSTALL_DIR/schemas"
fi

# Enable extension
echo "Enabling extension..."
ENABLE_OUTPUT=$(gnome-extensions enable "$UUID" 2>&1)
if [ $? -eq 0 ]; then
    echo -e "${GREEN}Extension enabled successfully!${NC}"
else
    if [[ "$ENABLE_OUTPUT" == *"does not exist"* ]]; then
        echo -e "${BLUE}Extension installed, but not yet recognized by the shell.${NC}"
        echo "This is normal on Wayland. You must log out and log back in and run the script again."
    else
        echo -e "${RED}Failed to enable extension:${NC}"
        echo "$ENABLE_OUTPUT"
    fi
fi

echo -e "${GREEN}Installation complete!${NC}"
echo "----------------------------------------------------------------"
echo "To apply changes:"
echo "  - On X11: Press Alt+F2, type 'r', and press Enter."
echo "  - On Wayland: Log out and log back in."
echo "----------------------------------------------------------------"
