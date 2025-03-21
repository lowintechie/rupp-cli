#!/bin/bash

check_root() {
    if [ "$EUID" -ne 0 ]; then
        echo -e "${RED}Error: This script must be run as root${NC}"
        exit 1
    fi
}

check_dependencies() {
    local missing_deps=0
    local tools=("iptables" "fail2ban-client" "sestatus" "ssh" "yum" "systemctl")
    
    for tool in "${tools[@]}"; do
        if ! command -v "$tool" &> /dev/null; then
            echo -e "${YELLOW}Warning: $tool is not installed${NC}"
            missing_deps=$((missing_deps+1))
        fi
    done
    
    if [ $missing_deps -gt 0 ]; then
        echo -e "${YELLOW}Some dependencies are missing. Installation may be required.${NC}"
        return 1
    else
        return 0
    fi
}