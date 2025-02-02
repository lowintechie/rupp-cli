import os

class Config:
    """Configuration settings for CentShield Web UI"""

    # Server settings
    HOST = "0.0.0.0"  # Allows access from any network
    PORT = 5000       # Port for the web UI

    # Log files
    FIREWALL_LOG = "/var/log/firewalld.log"
    FAIL2BAN_LOG = "/var/log/fail2ban.log"
    SYSTEM_LOG = "/var/log/messages"

    # Security scripts directory
    SCRIPTS_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), "../scripts"))

    # Script file paths
    FIREWALL_SCRIPT = os.path.join(SCRIPTS_DIR, "firewall_setup.sh")
    FAIL2BAN_SCRIPT = os.path.join(SCRIPTS_DIR, "install_fail2ban.sh")
    UPDATE_SCRIPT = os.path.join(SCRIPTS_DIR, "enable_updates.sh")

    # Email settings (optional, for alerts)
    ADMIN_EMAIL = "admin@example.com"
    EMAIL_ALERTS_ENABLED = False

    # Logging
    LOGGING_ENABLED = True
    LOG_FILE = os.path.join(os.path.dirname(__file__), "centshield.log")

# Load config
config = Config()
