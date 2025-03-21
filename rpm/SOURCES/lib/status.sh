#!/bin/bash

check_system_status() {
    local firewall_status=""
    local selinux_status=""
    local ssh_status=""
    local fail2ban_status=""
    local updates_status=""
    
    if systemctl is-active --quiet firewalld; then
        firewall_status="${GREEN}Active${NC}"
    else
        firewall_status="${RED}Inactive${NC}"
    fi
    
    selinux_mode=$(sestatus | grep "Current mode" | awk '{print $3}')
    if [ "$selinux_mode" == "enforcing" ]; then
        selinux_status="${GREEN}Enforcing${NC}"
    elif [ "$selinux_mode" == "permissive" ]; then
        selinux_status="${YELLOW}Permissive${NC}"
    else
        selinux_status="${RED}Disabled${NC}"
    fi
    
    if systemctl is-active --quiet sshd; then
        if grep -q "^PermitRootLogin no" /etc/ssh/sshd_config; then
            ssh_status="${GREEN}Hardened${NC}"
        else
            ssh_status="${YELLOW}Active but not hardened${NC}"
        fi
    else
        ssh_status="${RED}Inactive${NC}"
    fi
    
    if systemctl is-active --quiet fail2ban; then
        fail2ban_status="${GREEN}Active${NC}"
    else
        fail2ban_status="${RED}Inactive${NC}"
    fi
    
    updates_available=$(yum check-update --quiet | wc -l)
    if [ "$updates_available" -gt 0 ]; then
        updates_status="${YELLOW}$updates_available updates available${NC}"
    else
        updates_status="${GREEN}System up to date${NC}"
    fi
    
    echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║ ${WHITE}SYSTEM SECURITY STATUS                                  ${BLUE}║${NC}"
    echo -e "${BLUE}╠════════════════════════════════════════════════════════╣${NC}"
    echo -e "${BLUE}║ ${CYAN}• Firewall & Network Security:${NC} $firewall_status${BLUE}             ║${NC}"
    echo -e "${BLUE}║ ${CYAN}• SELinux Enforcement:${NC} $selinux_status${BLUE}                      ║${NC}"
    echo -e "${BLUE}║ ${CYAN}• SSH Hardening:${NC} $ssh_status${BLUE}                       ║${NC}"
    echo -e "${BLUE}║ ${CYAN}• Intrusion Detection (fail2ban):${NC} $fail2ban_status${BLUE}           ║${NC}"
    echo -e "${BLUE}║ ${CYAN}• System Updates:${NC} $updates_status${BLUE}            ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
}