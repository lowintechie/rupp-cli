#!/bin/bash

manage_firewall() {
    local action=$1
    local zone=$2
    local service=$3
    local port protocol

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
                echo -e "${RED}Firewall is not running${NC}"
                return 1
            fi
            ;;
        create-zone)
            if [ -z "$zone" ]; then
                echo -e "${RED}Error: Zone name not specified. Usage: rupp-cli firewall create-zone ZONE${NC}"
                return 1
            fi
            echo -e "${CYAN}Creating new zone: $zone${NC}"
            if firewall-cmd --permanent --new-zone="$zone" &> /dev/null; then
                firewall-cmd --reload &> /dev/null
                echo -e "${GREEN}Zone $zone created${NC}"
            else
                echo -e "${RED}Error: Failed to create zone $zone (may already exist or invalid name)${NC}"
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
        check-zone)
            if [ -z "$zone" ]; then
                echo -e "${RED}Error: Zone not specified. Usage: rupp-cli firewall check-zone ZONE${NC}"
                return 1
            fi
            echo -e "${CYAN}Checking zone: $zone${NC}"
            if firewall-cmd --get-active-zones | grep -q "$zone"; then
                echo -e "${GREEN}Zone $zone is active${NC}"
                firewall-cmd --zone="$zone" --list-all
            elif firewall-cmd --get-all-zones | grep -q "$zone"; then
                echo -e "${YELLOW}Zone $zone exists but is not active${NC}"
                firewall-cmd --zone="$zone" --list-all
            else
                echo -e "${RED}Error: Zone $zone does not exist${NC}"
                return 1
            fi
            ;;
        list-zones)
            echo -e "${CYAN}Listing all available zones:${NC}"
            echo -e "${GREEN}Active zones:${NC}"
            firewall-cmd --get-active-zones || echo -e "${YELLOW}No active zones${NC}"
            echo -e "${GREEN}All configured zones:${NC}"
            firewall-cmd --get-all-zones | tr ' ' '\n' | while read -r z; do
                if firewall-cmd --get-active-zones | grep -q "$z"; then
                    echo -e "$z ${GREEN}(active)${NC}"
                else
                    echo -e "$z"
                fi
            done
            ;;
        *)
            echo -e "${RED}Error: Unknown firewall action. Available: status, create-zone, check-services, add-rule, remove-rule, add-service, remove-service, check-zone, list-zones${NC}"
            return 1
            ;;
    esac
}
