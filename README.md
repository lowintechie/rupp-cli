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

### From RPM

```bash
sudo rpm -ivh rupp-cli-1.0.0-1.el8.noarch.rpm
```

### Build from Source

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/rupp-cli.git
   cd rupp-cli
   ```

2. Build the RPM package:
   ```bash
   rpmbuild -ba SPECS/rupp.spec
   ```

3. Install the package:
   ```bash
   sudo rpm -ivh RPMS/noarch/rupp-cli-1.0.0-1.el8.noarch.rpm
   ```

## Usage

```bash
rupp [COMMAND] [OPTIONS]
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
rupp status

# Enable firewall
rupp firewall enable

# Apply medium hardening profile
rupp harden medium

# Get help for SSH hardening options
rupp help ssh
```

## Requirements

- CentOS 8/RHEL 8 or later
- Root privileges for most operations

## License

MIT