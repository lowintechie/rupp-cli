Here are the **INSTALL.md** and **USAGE.md** files for your **CentShield** project.

---

# 📄 **INSTALL.md** (Installation Guide)
```
# CentShield - Security System for CentOS
CentShield is an automated security tool for CentOS, providing firewall protection, intrusion detection, and log monitoring.

## 🚀 Installation Guide

### 1️⃣ Prerequisites
Before installing CentShield, ensure your system has:
- **CentOS 7 or 8** (or Rocky Linux, AlmaLinux)
- **Root or sudo access**
- **Firewalld, Fail2Ban, Logwatch**
- **Python 3** (for Web UI)

### 2️⃣ Download & Install CentShield

#### ✅ **Option 1: Install via RPM**
If you have the RPM package, install it using:
```bash
sudo rpm -ivh centshield-1.0.rpm
```

#### ✅ **Option 2: Manual Installation**
If installing manually, clone the repository and install dependencies:
```bash
git clone https://github.com/yourname/centshield.git
cd centshield
sudo ./setup.sh
```

### 3️⃣ Verify Installation
Check if CentShield is installed:
```bash
security-tool --version
```

---

## 🎯 Post-Installation Setup

### ✅ **Start the CLI Tool**
```bash
sudo security-tool
```

### ✅ **Start the Web Interface**
```bash
cd web-ui
python3 app.py
```
Access it in your browser at:  
🔗 `http://server-ip:5000`

---

## 🛠 Uninstallation
To remove CentShield:
```bash
sudo rpm -e centshield
```
Or if installed manually:
```bash
rm -rf /opt/centshield
```

---

## 🎉 Congratulations! CentShield is now protecting your system.
For help, check the **USAGE.md** file.

