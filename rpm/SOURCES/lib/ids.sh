#!/bin/bash

manage_ids() {
    local action=$1
    
    case "$action" in
        status)
            echo -e "${CYAN}Fail2ban Status:${NC}"
            fail2ban-client status
            ;;
        enable)
            echo -e "${CYAN}Enabling fail2ban...${NC}"
            systemctl enable --now fail2ban
            echo -e "${GREEN}Fail2ban enabled and started${NC}"
            ;;
        disable)
            echo -e "${YELLOW}Warning: Disabling intrusion detection reduces system security${NC}"
            read -p "Are you sure you want to continue? (y/n): " confirm
            if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
                systemctl disable --now fail2ban
                echo -e "${RED}Fail2ban disabled${NC}"
            else
                echo -e "${GREEN}Operation cancelled${NC}"
            fi
            ;;
        jail-status)
            local jail=$2
            if [ -z "$jail" ]; then
                echo -e "${CYAN}All Jail Statuses:${NC}"
                fail2ban-client status
            else
                echo -e "${CYAN}Jail Status for $jail:${NC}"
                fail2ban-client status $jail
            fi
            ;;
        protect-ssh)
            echo -e "${CYAN}Setting up SSH protection with fail2ban...${NC}"
            systemctl enable --now fail2ban
            cat > /etc/fail2ban/jail.d/sshd.local << EOF
[sshd]
enabled = true
port = ssh
filter = sshd
logpath = /var/log/secure
maxretry = 3
bantime = 3600
findtime = 600
EOF
            fail2ban-client reload
            echo -e "${GREEN}SSH protection with fail2ban enabled${NC}"
            ;;
        *)
            echo -e "${RED}Error: Unknown intrusion detection action. Use 'rupp-cli help ids' for available commands${NC}"
            return 1
            ;;
    esac
}