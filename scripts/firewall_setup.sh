#!/bin/bash
echo "[INFO] Installing and configuring firewalld..."
sudo yum install -y firewalld
sudo systemctl enable firewalld
sudo systemctl start firewalld

# Allow SSH, HTTP, HTTPS
sudo firewall-cmd --permanent --add-service=ssh
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
sudo firewall-cmd --reload

echo "[SUCCESS] Firewall setup completed!"
