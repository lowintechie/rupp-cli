# CentShield - Usage Guide
This guide explains how to use CentShield's CLI tool and Web UI.

---

## 🖥 **1. Using the CLI (Command Line Interface)**

### 🔹 **Launch CentShield**
```bash
sudo security-tool
```
You will see a menu:
```
Welcome to CentShield!
1) Setup Firewall
2) Install Fail2Ban
3) Enable Automatic Updates
4) Start Web Interface
5) Exit
Choose an option:
```

#### ✅ **1. Setup Firewall**
This option configures `firewalld` with secure rules:
```bash
sudo security-tool --firewall
```

#### ✅ **2. Install Fail2Ban**
This sets up **Fail2Ban** to protect against brute-force attacks:
```bash
sudo security-tool --fail2ban
```

#### ✅ **3. Enable Automatic Updates**
Run:
```bash
sudo security-tool --auto-update
```

#### ✅ **4. Start the Web UI**
```bash
sudo security-tool --web
```
Then open **http://server-ip:5000** in your browser.

---

## 🌐 **2. Using the Web Interface**
To access the **CentShield Web UI**, go to:
```
http://server-ip:5000
```
You'll see buttons to:
- **Setup Firewall**
- **Install Fail2Ban**
- **Enable Automatic Updates**
Click the button to execute security actions.

---

## 🔎 **3. Log Monitoring**
CentShield sets up **Logwatch** to track security events.

Check logs manually:
```bash
sudo logwatch --detail High
```

For Fail2Ban logs:
```bash
sudo cat /var/log/fail2ban.log
```

---

## 🛠 **4. Troubleshooting**
### ❌ **Issue: Firewall Not Starting?**
Check status:
```bash
sudo systemctl status firewalld
```
Restart:
```bash
sudo systemctl restart firewalld
```

### ❌ **Issue: Web UI Not Loading?**
Ensure Flask is installed:
```bash
pip3 install flask
```
Start the UI:
```bash
cd web-ui
python3 app.py
```

---

## 🎉 **That's It! Your CentOS System is Secure with CentShield.**
For more details, visit the **INSTALL.md** file.
```

---

### 🚀 Now You Have:
✅ **INSTALL.md** for setting up CentShield  
✅ **USAGE.md** for running CentShield’s CLI & Web UI  

Let me know if you want any changes! 🚀🔥