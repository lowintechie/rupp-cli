#!/bin/bash

manage_selinux() {
    local action=$1
    
    case "$action" in
        status)
            echo -e "${CYAN}SELinux Status:${NC}"
            sestatus
            ;;
        enforcing)
            echo -e "${CYAN}Setting SELinux to enforcing mode...${NC}"
            setenforce 1
            sed -i 's/^SELINUX=.*/SELINUX=enforcing/' /etc/selinux/config
            echo -e "${GREEN}SELinux set to enforcing mode${NC}"
            ;;
        permissive)
            echo -e "${YELLOW}Warning: Setting SELinux to permissive mode reduces system security${NC}"
            read -p "Are you sure you want to continue? (y/n): " confirm
            if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
                setenforce 0
                sed -i 's/^SELINUX=.*/SELINUX=permissive/' /etc/selinux/config
                echo -e "${YELLOW}SELinux set to permissive mode${NC}"
            else
                echo -e "${GREEN}Operation cancelled${NC}"
            fi
            ;;
        relabel)
            echo -e "${CYAN}Relabeling SELinux contexts on next boot...${NC}"
            touch /.autorelabel
            echo -e "${GREEN}System will relabel SELinux contexts on next boot${NC}"
            read -p "Do you want to reboot now? (y/n): " confirm
            if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
                reboot
            fi
            ;;
        *)
            echo -e "${RED}Error: Unknown SELinux action. Use 'rupp-cli help selinux' for available commands${NC}"
            return 1
            ;;
    esac
}