#!/bin/bash
echo "[INFO] Installing Fail2Ban..."
sudo yum install -y epel-release
sudo yum install -y fail2ban
sudo systemctl enable fail2ban
sudo systemctl start fail2ban

echo "[INFO] Configuring Fail2Ban..."
cat <<EOF | sudo tee /etc/fail2ban/jail.local
[sshd]
enabled = true
bantime = 3600
findtime = 600
maxretry = 3
EOF

sudo systemctl restart fail2ban
echo "[SUCCESS] Fail2Ban setup completed!"
