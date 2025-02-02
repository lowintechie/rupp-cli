#!/bin/bash

# CentShield CLI Tool - Security Management for CentOS

# Set script directory
SCRIPT_DIR="$(cd "$(dirname "$0")/scripts" && pwd)"

# Colors for better readability
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Function to show the menu
show_menu() {
    echo -e "${GREEN}Welcome to CentShield - CentOS Security Tool${NC}"
    echo "------------------------------------------"
    echo "1) Setup Firewall"
    echo "2) Install Fail2Ban"
    echo "3) Enable Automatic Updates"
    echo "4) View System Logs"
    echo "5) Start Web Interface"
    echo "6) Exit"
    echo "------------------------------------------"
    read -p "Choose an option: " choice
    handle_choice "$choice"
}

# Function to execute scripts
execute_script() {
    local script_name="$1"
    if [[ -x "$SCRIPT_DIR/$script_name" ]]; then
        echo -e "${YELLOW}[INFO] Running $script_name...${NC}"
        bash "$SCRIPT_DIR/$script_name"
        echo -e "${GREEN}[SUCCESS] $script_name executed.${NC}"
    else
        echo -e "${RED}[ERROR] Script not found or not executable: $SCRIPT_DIR/$script_name${NC}"
    fi
}

# Function to handle user choice
handle_choice() {
    case $1 in
        1) execute_script "firewall_setup.sh" ;;
        2) execute_script "install_fail2ban.sh" ;;
        3) execute_script "enable_updates.sh" ;;
        4) show_logs ;;
        5) start_web_ui ;;
        6) echo "Exiting CentShield."; exit 0 ;;
        *) echo -e "${RED}Invalid option!${NC}"; show_menu ;;
    esac
}

# Function to show system logs
show_logs() {
    echo -e "${YELLOW}--- Fail2Ban Logs ---${NC}"
    sudo tail -n 10 /var/log/fail2ban.log
    echo -e "${YELLOW}--- Firewall Logs ---${NC}"
    sudo tail -n 10 /var/log/firewalld.log
    echo -e "${YELLOW}--- System Logs ---${NC}"
    sudo tail -n 10 /var/log/messages
}

# Function to start the Web UI
start_web_ui() {
    echo -e "${GREEN}[INFO] Starting Web Interface on http://localhost:5000...${NC}"
    cd "$(dirname "$0")/web-ui" || exit
    python3 app.py
}

# Main function
show_menu
