#!/bin/bash

# CentShield Setup Script - Automated Security Tool Installation

# Colors for readability
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🔹 CentShield Installation Started...${NC}"

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}[ERROR] This script must be run as root! Use sudo.${NC}"
   exit 1
fi

# Update system packages
echo -e "${YELLOW}[INFO] Updating system packages...${NC}"
yum update -y

# Install required dependencies
echo -e "${YELLOW}[INFO] Installing dependencies...${NC}"
yum install -y firewalld fail2ban logwatch python3 python3-pip

# Install Flask for Web UI
echo -e "${YELLOW}[INFO] Installing Flask for Web UI...${NC}"
pip3 install flask

# Set execute permissions for security scripts
echo -e "${YELLOW}[INFO] Setting script permissions...${NC}"
chmod +x scripts/*.sh
chmod +x security-tool.sh

# Enable and start necessary services
echo -e "${YELLOW}[INFO] Enabling and starting firewalld and Fail2Ban...${NC}"
systemctl enable firewalld --now
systemctl enable fail2ban --now

# Display completion message
echo -e "${GREEN}✅ CentShield has been installed successfully!${NC}"
echo -e "${GREEN}✅ Run CentShield CLI using: sudo ./security-tool.sh${NC}"
echo -e "${GREEN}✅ Start the Web UI using: cd web-ui && python3 app.py${NC}"
