#!/bin/bash

disable_root_login() {
    echo -e "${CYAN}Disabling root login for SSH...${NC}"
    cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
    sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
    sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
    systemctl restart sshd
    echo -e "${GREEN}Root login via SSH has been disabled.${NC}"
}

enable_root_login() {
    echo -e "${CYAN}Enabling root login via SSH and SFTP...${NC}"
    cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
    sed -i 's/^#*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
    sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
    systemctl restart sshd
    echo -e "${GREEN}Root login via SSH has been enabled.${NC}"
}

harden_ssh() {
    local action=$1
    
    case "$action" in
        status)
            echo -e "${CYAN}SSH Service Status:${NC}"
            if ! systemctl status sshd; then
                echo -e "${RED}Error: Unable to get SSH status${NC}"
                return 1
            fi
            echo -e "\n${CYAN}SSH Configuration:${NC}"
            grep -E "^PermitRootLogin|^PasswordAuthentication|^Port|^Protocol" /etc/ssh/sshd_config || echo -e "${YELLOW}No relevant SSH configuration found${NC}"
            ;;
        disable-root)
            disable_root_login
            ;;
        enable-root)
            enable_root_login
            ;;
        change-port)
            local port=$2
            if [ -z "$port" ]; then
                echo -e "${RED}Error: Missing port parameter. Usage: rupp-cli ssh change-port PORT${NC}"
                return 1
            fi
            if ! [[ "$port" =~ ^[0-9]+$ ]] || [ "$port" -lt 1 ] || [ "$port" -gt 65535 ]; then
                echo -e "${RED}Error: Invalid port number. Must be between 1-65535${NC}"
                return 1
            fi
            if ss -tln | grep -q ":$port "; then
                echo -e "${RED}Error: Port $port is already in use${NC}"
                return 1
            fi
            echo -e "${CYAN}Changing SSH port to $port...${NC}"
            cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup
            sed -i "s/^#*Port.*/Port $port/" /etc/ssh/sshd_config
            if ! firewall-cmd --permanent --add-port=$port/tcp; then
                echo -e "${RED}Error: Failed to update firewall${NC}"
                cp /etc/ssh/sshd_config.backup /etc/ssh/sshd_config
                return 1
            fi
            if ! firewall-cmd --reload; then
                echo -e "${RED}Error: Failed to reload firewall${NC}"
                cp /etc/ssh/sshd_config.backup /etc/ssh/sshd_config
                return 1
            fi
            if command -v semanage &> /dev/null; then
                if ! semanage port -a -t ssh_port_t -p tcp $port; then
                    echo -e "${RED}Error: Failed to update SELinux policy${NC}"
                    cp /etc/ssh/sshd_config.backup /etc/ssh/sshd_config
                    firewall-cmd --permanent --remove-port=$port/tcp
                    firewall-cmd --reload
                    return 1
                fi
            else
                echo -e "${YELLOW}Warning: semanage not found, skipping SELinux port configuration${NC}"
            fi
            if ! systemctl restart sshd; then
                echo -e "${RED}Error: Failed to restart SSH service${NC}"
                cp /etc/ssh/sshd_config.backup /etc/ssh/sshd_config
                firewall-cmd --permanent --remove-port=$port/tcp
                firewall-cmd --reload
                semanage port -d -t ssh_port_t -p tcp $port 2>/dev/null
                return 1
            fi
            echo -e "${GREEN}SSH port changed to $port${NC}"
            echo -e "${YELLOW}Warning: Remember to connect to the new port on your next session${NC}"
            ;;
    esac
}