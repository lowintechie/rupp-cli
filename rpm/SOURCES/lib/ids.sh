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
                echo -e "${CYAN}Active Jail Statuses:${NC}"
                fail2ban-client status
            else
                echo -e "${CYAN}Jail Status for $jail:${NC}"
                fail2ban-client status "$jail"
            fi
            ;;
        ban-ip)
            local ip=$2
            local jail=$3
            if [ -z "$ip" ] || [ -z "$jail" ]; then
                echo -e "${RED}Error: Please provide an IP and jail name (e.g., sshd)${NC}"
                return 1
            fi
            echo -e "${CYAN}Banning IP $ip in jail $jail...${NC}"
            fail2ban-client set "$jail" banip "$ip"
            echo -e "${GREEN}IP $ip banned in $jail${NC}"
            ;;
        unban-ip)
            local ip=$2
            local jail=$3
            if [ -z "$ip" ] || [ -z "$jail" ]; then
                echo -e "${RED}Error: Please provide an IP and jail name (e.g., sshd)${NC}"
                return 1
            fi
            echo -e "${CYAN}Unbanning IP $ip from jail $jail...${NC}"
            fail2ban-client set "$jail" unbanip "$ip"
            echo -e "${GREEN}IP $ip unbanned from $jail${NC}"
            ;;
        *)
            echo -e "${RED}Error: Unknown action. Available commands: status, enable, disable, jail-status, ban-ip, unban-ip${NC}"
            return 1
            ;;
    esac
}
