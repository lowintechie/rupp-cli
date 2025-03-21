#!/bin/bash
manage_firewall() {
    local action=$1
    local zone=$2
    local service=$3
    local port protocol confirm

    # Check if firewalld is installed
    if ! command -v firewall-cmd &> /dev/null; then
        echo -e "${RED}Error: firewalld is not installed. Please install it first.${NC}"
        return 1
    fi

    case "$action" in
        status)
            echo -e "${CYAN}Firewall Status:${NC}"
            if systemctl is-active firewalld &> /dev/null; then
                firewall-cmd --list-all
            else
                echo -e "${YELLOW}Firewall is not running${NC}"
            fi
            ;;
        enable)
            echo -e "${CYAN}Enabling firewall...${NC}"
            if systemctl enable --now firewalld &> /dev/null; then
                echo -e "${GREEN}Firewall enabled and started${NC}"
            else
                echo -e "${RED}Error: Failed to enable firewall${NC}"
                return 1
            fi
            ;;
        disable)
            echo -e "${YELLOW}Warning: Disabling firewall reduces system security${NC}"
            read -p "Are you sure you want to continue? (y/n): " confirm
            if [[ "$confirm" =~ ^[yY]([eE][sS])?$ ]]; then
                if systemctl disable --now firewalld &> /dev/null; then
                    echo -e "${RED}Firewall disabled${NC}"
                else
                    echo -e "${RED}Error: Failed to disable firewall${NC}"
                    return 1
                fi
            else
                echo -e "${GREEN}Operation cancelled${NC}"
            fi
            ;;
        add-rule)
            port=$2
            protocol=$3
            if [ -z "$port" ] || [ -z "$protocol" ]; then
                echo -e "${RED}Error: Missing parameters. Usage: rupp-cli firewall add-rule PORT PROTOCOL${NC}"
                return 1
            fi
            if firewall-cmd --permanent --add-port="$port/$protocol" &> /dev/null; then
                firewall-cmd --reload &> /dev/null
                echo -e "${GREEN}Rule added: $port/$protocol${NC}"
            else
                echo -e "${RED}Error: Failed to add rule $port/$protocol${NC}"
                return 1
            fi
            ;;
        remove-rule)
            port=$2
            protocol=$3
            if [ -z "$port" ] || [ -z "$protocol" ]; then
                echo -e "${RED}Error: Missing parameters. Usage: rupp-cli firewall remove-rule PORT PROTOCOL${NC}"
                return 1
            fi
            if firewall-cmd --permanent --remove-port="$port/$protocol" &> /dev/null; then
                firewall-cmd --reload &> /dev/null
                echo -e "${GREEN}Rule removed: $port/$protocol${NC}"
            else
                echo -e "${RED}Error: Failed to remove rule $port/$protocol${NC}"
                return 1
            fi
            ;;
        check-zone)
            echo -e "${CYAN}Checking active firewall zones...${NC}"
            if firewall-cmd --get-active-zones; then
                echo -e "${GREEN}Active zones listed above${NC}"
            else
                echo -e "${RED}Error: No active zones or firewalld not running${NC}"
                return 1
            fi
            ;;
        check-services)
            if [ -z "$zone" ]; then
                echo -e "${RED}Error: Zone not specified. Usage: rupp-cli firewall check-services ZONE${NC}"
                return 1
            fi
            echo -e "${CYAN}Checking services in zone: $zone${NC}"
            if firewall-cmd --zone="$zone" --list-services; then
                echo -e "${GREEN}Services listed above${NC}"
            else
                echo -e "${RED}Error: Failed to list services for zone $zone${NC}"
                return 1
            fi
            ;;
        change-zone)
            if [ -z "$zone" ]; then
                echo -e "${RED}Error: Zone not specified. Usage: rupp-cli firewall change-zone ZONE${NC}"
                return 1
            fi
            echo -e "${CYAN}Changing default zone to: $zone${NC}"
            if firewall-cmd --set-default-zone="$zone" &> /dev/null; then
                echo -e "${GREEN}Default zone changed to $zone${NC}"
            else
                echo -e "${RED}Error: Failed to change default zone to $zone${NC}"
                return 1
            fi
            ;;
        add-service)
            if [ -z "$zone" ] || [ -z "$service" ]; then
                echo -e "${RED}Error: Missing parameters. Usage: rupp-cli firewall add-service ZONE SERVICE${NC}"
                return 1
            fi
            echo -e "${CYAN}Adding service $service to zone $zone${NC}"
            if firewall-cmd --zone="$zone" --add-service="$service" --permanent &> /dev/null; then
                firewall-cmd --reload &> /dev/null
                echo -e "${GREEN}Service $service added to zone $zone${NC}"
            else
                echo -e "${RED}Error: Failed to add service $service to zone $zone${NC}"
                return 1
            fi
            ;;
        remove-service)
            if [ -z "$zone" ] || [ -z "$service" ]; then
                echo -e "${RED}Error: Missing parameters. Usage: rupp-cli firewall remove-service ZONE SERVICE${NC}"
                return 1
            fi
            echo -e "${CYAN}Removing service $service from zone $zone${NC}"
            if firewall-cmd --zone="$zone" --remove-service="$service" --permanent &> /dev/null; then
                firewall-cmd --reload &> /dev/null
                echo -e "${GREEN}Service $service removed from zone $zone${NC}"
            else
                echo -e "${RED}Error: Failed to remove service $service from zone $zone${NC}"
                return 1
            fi
            ;;
        *)
            echo -e "${RED}Error: Unknown firewall action. Use 'rupp-cli help firewall' for available commands${NC}"
            return 1
            ;;
    esac
}
