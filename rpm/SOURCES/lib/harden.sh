#!/bin/bash

one_click_hardening() {
    local level=$1
    
    if [ -z "$level" ]; then
        echo -e "${RED}Error: Missing level parameter. Usage: rupp-cli harden LEVEL (basic|medium|high)${NC}"
        return 1
    fi
    
    echo -e "${CYAN}Applying $level security hardening...${NC}"
    
    case "$level" in
        basic)
            systemctl enable --now firewalld
            setenforce 0
            sed -i 's/^SELINUX=.*/SELINUX=permissive/' /etc/selinux/config
            systemctl enable --now fail2ban
            yum -y update --security
            echo -e "${GREEN}Basic security hardening applied${NC}"
            ;;
        medium)
            systemctl enable --now firewalld
            setenforce 1
            sed -i 's/^SELINUX=.*/SELINUX=enforcing/' /etc/selinux/config
            sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
            systemctl restart sshd
            systemctl enable --now fail2ban
            cat > /etc/fail2ban/jail.d/sshd.local << EOF
[sshd]
enabled = true
port = ssh
filter = sshd
logpath = /var/log/secure
maxretry = 5
bantime = 3600
findtime = 600
EOF
            fail2ban-client reload
            yum -y update
            yum -y install dnf-automatic
            sed -i 's/^apply_updates.*/apply_updates = yes/' /etc/dnf/automatic.conf
            systemctl enable --now dnf-automatic.timer
            echo -e "${GREEN}Medium security hardening applied${NC}"
            ;;
        high)
            systemctl enable --now firewalld
            firewall-cmd --set-default-zone=drop
            firewall-cmd --permanent --zone=drop --add-service=ssh
            firewall-cmd --reload
            setenforce 1
            sed -i 's/^SELINUX=.*/SELINUX=enforcing/' /etc/selinux/config
            sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
            sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
            sed -i 's/^#*Protocol.*/Protocol 2/' /etc/ssh/sshd_config
            echo "MaxAuthTries 3" >> /etc/ssh/sshd_config
            sed -i 's/^#*PermitEmptyPasswords.*/PermitEmptyPasswords no/' /etc/ssh/sshd_config
            systemctl restart sshd
            systemctl enable --now fail2ban
            cat > /etc/fail2ban/jail.d/sshd.local << EOF
[sshd]
enabled = true
port = ssh
filter = sshd
logpath = /var/log/secure
maxretry = 3
bantime = 86400
findtime = 600
EOF
            fail2ban-client reload
            yum -y update
            yum -y install dnf-automatic
            sed -i 's/^apply_updates.*/apply_updates = yes/' /etc/dnf/automatic.conf
            systemctl enable --now dnf-automatic.timer
            echo -e "${GREEN}High security hardening applied${NC}"
            echo -e "${YELLOW}Warning: The system is now in a highly secured state.${NC}"
            echo -e "${YELLOW}Ensure you have SSH keys set up before logging out.${NC}"
            ;;
        *)
            echo -e "${RED}Error: Unknown hardening level. Use 'basic', 'medium', or 'high'${NC}"
            return 1
            ;;
    esac
}