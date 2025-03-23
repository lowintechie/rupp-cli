#!/bin/bash

harden_ssh() {
    local action=$1
    
    case "$action" in
        status)
            echo -e "${CYAN}SSH Service Status:${NC}"
            systemctl is-active sshd >/dev/null 2>&1
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}SSH service is running${NC}"
            else
                echo -e "${RED}SSH service is not running${NC}"
            fi
            echo -e "\n${CYAN}Current SSH Configuration:${NC}"
            grep -E "^PermitRootLogin|^PasswordAuthentication|^Port" /etc/ssh/sshd_config || 
            echo -e "${YELLOW}No relevant SSH configuration found${NC}"
            ;;

        disable-root)
            echo -e "${CYAN}Disabling root login and password authentication...${NC}"
            cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak.$(date +%Y%m%d_%H%M%S)
            sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
            sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
            if systemctl restart sshd >/dev/null 2>&1; then
                echo -e "${GREEN}Root login and password auth disabled (SSH key auth only)${NC}"
            else
                echo -e "${RED}Error: Failed to restart SSH service${NC}"
                cp /etc/ssh/sshd_config.bak.$(date +%Y%m%d_%H%M%S) /etc/ssh/sshd_config
                return 1
            fi
            ;;

        change-port)
            local port=$2
            if [ -z "$port" ]; then
                echo -e "${RED}Error: Please specify a port number${NC}"
                return 1
            fi
            if ! [[ "$port" =~ ^[0-9]+$ ]] || [ "$port" -lt 1024 ] || [ "$port" -gt 65535 ]; then
                echo -e "${RED}Error: Port must be between 1024-65535${NC}"
                return 1
            fi
            if ss -tln | grep -q ":$port "; then
                echo -e "${RED}Error: Port $port is already in use${NC}"
                return 1
            fi
            
            echo -e "${CYAN}Changing SSH port to $port...${NC}"
            cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak.$(date +%Y%m%d_%H%M%S)
            sed -i "s/^#*Port.*/Port $port/" /etc/ssh/sshd_config
            
            # Firewall configuration
            if command -v firewall-cmd >/dev/null 2>&1; then
                firewall-cmd --permanent --remove-service=ssh 2>/dev/null
                firewall-cmd --permanent --add-port=$port/tcp
                firewall-cmd --reload
            fi
            
            # SELinux configuration if present
            if command -v semanage >/dev/null 2>&1; then
                semanage port -a -t ssh_port_t -p tcp $port 2>/dev/null || true
            fi
            
            if systemctl restart sshd >/dev/null 2>&1; then
                echo -e "${GREEN}SSH port changed to $port${NC}"
                echo -e "${YELLOW}Note: Update your SSH client to use port $port${NC}"
            else
                echo -e "${RED}Error: Failed to apply changes${NC}"
                cp /etc/ssh/sshd_config.bak.$(date +%Y%m%d_%H%M%S) /etc/ssh/sshd_config
                return 1
            fi
            ;;
            
        *)
            echo -e "${YELLOW}Usage: harden_ssh [status|disable-root|change-port PORT]${NC}"
            return 1
            ;;
    esac
}
