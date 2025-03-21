#!/bin/bash

manage_firewall() {
    local action=$1
    local zone=$2
    local service=$3

    case "$action" in
        status)
            echo -e "${CYAN}Firewall Status:${NC}"
            firewall-cmd --list-all
            ;;
        enable)
            echo -e "${CYAN}Enabling firewall...${NC}"
            systemctl enable --now firewalld
            echo -e "${GREEN}Firewall enabled and started${NC}"
            ;;
        disable)
            echo -e "${YELLOW}Warning: Disabling firewall reduces system security${NC}"
            read -p "Are you sure you want to continue? (y/n): " confirm
            if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
                systemctl disable --now firewalld
                echo -e "${RED}Firewall disabled${NC}"
            else
                echo -e "${GREEN}Operation cancelled${NC}"
            fi
            ;;
        add-rule)
            local port=$2
            local protocol=$3
            
            if [ -z "$port" ] || [ -z "$protocol" ]; then
                echo -e "${RED}Error: Missing parameters. Usage: rupp-cli firewall add-rule PORT PROTOCOL${NC}"
                return 1
            fi
            
            firewall-cmd --permanent --add-port=$port/$protocol
            firewall-cmd --reload
            echo -e "${GREEN}Rule added: $port/$protocol${NC}"
            ;;
        remove-rule)
            local port=$2
            local protocol=$3
            
            if [ -z "$port" ] || [ -z "$protocol" ]; then
                echo -e "${RED}Error: Missing parameters. Usage: rupp-cli firewall remove-rule PORT PROTOCOL${NC}"
                return 1
            fi
            
            firewall-cmd --permanent --remove-port=$port/$protocol
            firewall-cmd --reload
            echo -e "${GREEN}Rule removed: $port/$protocol${NC}"
            ;;
        check-zone)
            echo -e "${CYAN}Checking firewall zone...${NC}"
            firewall-cmd --get-active-zones
            ;;
        check-services)
            echo -e "${CYAN}Checking services in zone: $zone${NC}"
            firewall-cmd --zone=$zone --list-services
            ;;
        change-zone)
            echo -e "${CYAN}Changing default zone to: $zone${NC}"
            firewall-cmd --set-default-zone=$zone
            ;;
        add-service)
            echo -e "${CYAN}Adding service $service to zone $zone${NC}"
            firewall-cmd --zone=$zone --add-service=$service --permanent
            firewall-cmd --reload
            ;;
        remove-service)
            echo -e "${CYAN}Removing service $service from zone $zone${NC}"
            firewall-cmd --zone=$zone --remove-service=$service --permanent
            firewall-cmd --reload
            ;;
        *)
            echo -e "${RED}Error: Unknown firewall action. Use 'rupp-cli help firewall' for available commands${NC}"
            return 1
            ;;
    esac
}