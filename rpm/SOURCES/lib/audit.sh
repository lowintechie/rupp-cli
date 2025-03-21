#!/bin/bash

run_security_audit() {
    echo -e "${CYAN}Running system security audit...${NC}"
    echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║ ${WHITE}SYSTEM SECURITY AUDIT                                  ${BLUE}║${NC}"
    echo -e "${BLUE}╠════════════════════════════════════════════════════════╣${NC}"
    
    echo -e "${BLUE}║ ${YELLOW}Firewall Check:${NC}"
    if systemctl is-active --quiet firewalld; then
        echo -e "${BLUE}║ ${GREEN}✓ Firewall is active${NC}"
    else
        echo -e "${BLUE}║ ${RED}✗ Firewall is not active${NC}"
    fi
    
    echo -e "${BLUE}║ ${YELLOW}SELinux Check:${NC}"
    selinux_mode=$(sestatus | grep "Current mode" | awk '{print $3}')
    if [ "$selinux_mode" == "enforcing" ]; then
        echo -e "${BLUE}║ ${GREEN}✓ SELinux is enforcing${NC}"
    else
        echo -e "${BLUE}║ ${RED}✗ SELinux is not enforcing ($selinux_mode)${NC}"
    fi
    
    echo -e "${BLUE}║ ${YELLOW}SSH Security Check:${NC}"
    if grep -q "^PermitRootLogin no" /etc/ssh/sshd_config; then
        echo -e "${BLUE}║ ${GREEN}✓ Root login is disabled${NC}"
    else
        echo -e "${BLUE}║ ${RED}✗ Root login is enabled${NC}"
    fi
    
    if grep -q "^PasswordAuthentication no" /etc/ssh/sshd_config; then
        echo -e "${BLUE}║ ${GREEN}✓ Password authentication is disabled${NC}"
    else
        echo -e "${BLUE}║ ${RED}✗ Password authentication is enabled${NC}"
    fi
    
    echo -e "${BLUE}║ ${YELLOW}Intrusion Detection Check:${NC}"
    if systemctl is-active --quiet fail2ban; then
        echo -e "${BLUE}║ ${GREEN}✓ Fail2ban is active${NC}"
    else
        echo -e "${BLUE}║ ${RED}✗ Fail2ban is not active${NC}"
    fi
    
    echo -e "${BLUE}║ ${YELLOW}System Updates Check:${NC}"
    updates_available=$(yum check-update --quiet | wc -l)
    if [ "$updates_available" -gt 0 ]; then
        echo -e "${BLUE}║ ${RED}✗ $updates_available updates available${NC}"
    else
        echo -e "${BLUE}║ ${GREEN}✓ System is up to date${NC}"
    fi
    
    echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
}