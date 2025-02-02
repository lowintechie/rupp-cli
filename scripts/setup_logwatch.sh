#!/bin/bash
echo "[INFO] Installing Logwatch..."
sudo yum install -y logwatch

echo "[INFO] Configuring Logwatch to send email reports..."
sudo bash -c "echo '/usr/sbin/logwatch --output mail --mailto admin@example.com --detail High' > /etc/cron.daily/logwatch"
sudo chmod +x /etc/cron.daily/logwatch

echo "[SUCCESS] Logwatch setup completed!"
