#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_SCRIPT="$SCRIPT_DIR/rpm/SOURCES/rupp-cli.sh"
INSTALL_PATH="/usr/local/bin/rupp-cli"

# Check if running in the correct directory with rupp-cli.sh present
if [ ! -f "$SOURCE_SCRIPT" ]; then
    echo -e "${RED}Error: rupp-cli.sh not found in $SCRIPT_DIR/rpm/SOURCES/.${NC}"
    echo "Please ensure the script is in the correct location and try again."
    exit 1
fi

# Check for sudo privileges (needed for install)
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}This script requires sudo privileges to install to $INSTALL_PATH.${NC}"
    echo "Please run with sudo (e.g., 'sudo ./build-and-install.sh')."
    exit 1
fi

# Check if firewalld is installed (optional, but since it’s a firewalld tool)
if ! command -v firewall-cmd &> /dev/null; then
    echo -e "${RED}Warning: firewalld is not installed. rupp-cli may not work as expected.${NC}"
    read -p "Continue anyway? (y/n): " confirm
    if [[ ! "$confirm" =~ ^[yY]$ ]]; then
        echo -e "${GREEN}Installation cancelled.${NC}"
        exit 0
    fi
fi

# Install the script
echo "Installing rupp-cli to $INSTALL_PATH..."
cp "$SOURCE_SCRIPT" "$INSTALL_PATH" || {
    echo -e "${RED}Error: Failed to copy rupp-cli.sh to $INSTALL_PATH.${NC}"
    exit 1
}

# Set executable permissions
chmod +x "$INSTALL_PATH" || {
    echo -e "${RED}Error: Failed to set executable permissions on $INSTALL_PATH.${NC}"
    exit 1
}

# Rename to remove .sh extension for cleaner CLI usage
if [ "${INSTALL_PATH: -3}" == ".sh" ]; then
    mv "$INSTALL_PATH" "${INSTALL_PATH%.sh}" || {
        echo -e "${RED}Error: Failed to rename the script.${NC}"
        exit 1
    }
    INSTALL_PATH="${INSTALL_PATH%.sh}"
fi

# Verify installation
if command -v rupp-cli &> /dev/null; then
    echo -e "${GREEN}Installation complete! You can now use 'rupp-cli' (e.g., 'rupp-cli status').${NC}"
else
    echo -e "${RED}Error: Installation failed. rupp-cli is not in your PATH.${NC}"
    exit 1
fi
