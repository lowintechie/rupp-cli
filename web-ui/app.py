from flask import Flask, render_template, request, redirect, url_for
import os
from config import config  # Import settings

app = Flask(__name__)

@app.route('/')
def index():
    return render_template("index.html")

@app.route('/logs')
def logs():
    log_path = config.SYSTEM_LOG
    try:
        with open(log_path, "r") as log_file:
            logs = log_file.readlines()[-20:]  # Show last 20 log entries
    except Exception as e:
        logs = [f"Error reading log file: {str(e)}"]
    
    return render_template("logs.html", logs="".join(logs))

@app.route('/settings')
def settings():
    return render_template("settings.html")

# 🔹 Toggle Firewall
@app.route('/toggle_firewall', methods=['POST'])
def toggle_firewall():
    os.system("sudo systemctl is-active --quiet firewalld && sudo systemctl stop firewalld || sudo systemctl start firewalld")
    return redirect(url_for('settings'))

# 🔹 Toggle Fail2Ban
@app.route('/toggle_fail2ban', methods=['POST'])
def toggle_fail2ban():
    os.system("sudo systemctl is-active --quiet fail2ban && sudo systemctl stop fail2ban || sudo systemctl start fail2ban")
    return redirect(url_for('settings'))

# 🔹 Toggle Automatic Updates
@app.route('/toggle_updates', methods=['POST'])
def toggle_updates():
    os.system("sudo systemctl is-active --quiet dnf-automatic.timer && sudo systemctl stop dnf-automatic.timer || sudo systemctl start dnf-automatic.timer")
    return redirect(url_for('settings'))

# 🔹 Restart System
@app.route('/restart_system', methods=['POST'])
def restart_system():
    os.system("sudo reboot")
    return "System is restarting..."

if __name__ == "__main__":
    app.run(host=config.HOST, port=config.PORT, debug=True)
