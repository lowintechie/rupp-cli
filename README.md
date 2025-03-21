# Rupp-Cli

Rupp-Cli is a comprehensive security management tool for Linux systems.

## Features

- **Firewall Management**: Easy configuration of firewalld rules
- **SELinux Management**: Toggle between enforcing and permissive modes
- **SSH Hardening**: Secure SSH configurations with multiple options
- **Intrusion Detection**: fail2ban configuration and management
- **System Updates**: Manage and schedule system updates
- **One-Click Hardening**: Apply security profiles with a single command

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/rupp-cli.git
   cd rupp-cli
   ```

2. Build and Install the RPM package:
   ```bash
   chmod +x build-and-install.sh
   sudo ./build-and-install.sh
   ```

## Usage

```bash
rupp-cli [COMMAND] [OPTIONS]
```

### Available Commands

- `status` - Show system security status
- `audit` - Run security audit
- `firewall` - Manage firewall settings
- `selinux` - Manage SELinux configuration
- `ssh` - Configure SSH hardening
- `ids` - Manage intrusion detection system
- `updates` - Manage system updates
- `harden` - Apply one-click hardening (basic/medium/high)
- `help` - Show help for specific command

## Examples

```bash
# Show security status
rupp-cil status

# Enable firewall
rupp-cli firewall enable

# Apply medium hardening profile
rupp-cli harden medium

# Get help for SSH hardening options
rupp-cli help ssh
```

## Requirements

- CentOS 8/RHEL 8 or later
- Root privileges for most operations

## License

MIT
