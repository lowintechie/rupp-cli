#!/bin/bash
echo "[INFO] Enabling automatic security updates..."
sudo yum install -y dnf-automatic
sudo systemctl enable --now dnf-automatic.timer
echo "[SUCCESS] Security updates enabled!"
