#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCES_DIR="$SCRIPT_DIR/rpm/SOURCES"
SPEC_FILE="$SCRIPT_DIR/rpm/SPECS/rupp-cli.spec"

# Check if running in the correct directory with rupp-cli.sh present
if [ ! -d "$SOURCES_DIR" ] || [ ! -f "$SOURCES_DIR/rupp-cli.sh" ]; then
    echo -e "${RED}Error: rupp-cli.sh not found in $SOURCES_DIR/.${NC}"
    echo "Please ensure the script is in the correct location and try again."
    exit 1
fi

# Check for sudo privileges (needed for install)
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}This script requires sudo privileges to build and install the RPM.${NC}"
    echo "Please run with sudo (e.g., 'sudo ./build-and-install.sh')."
    exit 1
fi

# Set up RPM build directories
echo "Setting up RPM build environment..."
mkdir -p ~/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}

# Copy all scripts and the lib/ folder to ~/rpmbuild/SOURCES
echo "Copying scripts to ~/rpmbuild/SOURCES..."
cp -r "$SOURCES_DIR"/* ~/rpmbuild/SOURCES/ || {
    echo -e "${RED}Error: Failed to copy scripts to ~/rpmbuild/SOURCES.${NC}"
    exit 1
}

# Create the spec file
echo "Creating rupp-cli.spec..."
cat > "$SPEC_FILE" << 'EOF'
Name:           rupp-cli
Version:        1.0
Release:        1
Summary:        A CLI tool to manage system configurations
License:        GPL
Source0:        rupp-cli.sh
Source1:        audit.sh
Source2:        banner.sh
Source3:        checks.sh
Source4:        config.sh
Source5:        firewall.sh
Source6:        harden.sh
Source7:        help.sh
Source8:        ids.sh
Source9:        selinux.sh
Source10:       ssh.sh
Source11:       status.sh
Source12:       updates.sh
Source13:       lib

%description
A CLI tool to manage various system configurations, including firewalld.

%prep
# No prep needed for scripts

%build
# No build step for Bash scripts

%install
mkdir -p %{buildroot}/usr/share/rupp-cli
mkdir -p %{buildroot}/usr/bin
# Install all scripts and lib/ folder
cp -r rupp-cli.sh audit.sh banner.sh checks.sh config.sh firewall.sh harden.sh help.sh ids.sh selinux.sh ssh.sh status.sh updates.sh lib %{buildroot}/usr/share/rupp-cli/
# Create symlink for rupp-cli
ln -sf /usr/share/rupp-cli/rupp-cli.sh %{buildroot}/usr/bin/rupp-cli
# Set executable permissions
chmod +x %{buildroot}/usr/share/rupp-cli/*.sh

%files
/usr/share/rupp-cli/*
/usr/bin/rupp-cli

%changelog
* Fri Mar 21 2025 Your Name <you@example.com> - 1.0-1
- Initial release
EOF

# Copy spec file to ~/rpmbuild/SPECS
cp "$SPEC_FILE" ~/rpmbuild/SPECS/ || {
    echo -e "${RED}Error: Failed to copy rupp-cli.spec to ~/rpmbuild/SPECS.${NC}"
    exit 1
}

# Build the RPM
echo "Building RPM package..."
rpmbuild -ba ~/rpmbuild/SPECS/rupp-cli.spec || {
    echo -e "${RED}Error: Failed to build RPM package. Ensure rpm-build is installed.${NC}"
    exit 1
}

# Find and install the RPM
RPM_FILE=$(find ~/rpmbuild/RPMS -name "rupp-cli-1.0-1*.rpm" | head -n 1)
if [ -z "$RPM_FILE" ]; then
    echo -e "${RED}Error: RPM file not found.${NC}"
    exit 1
fi

echo "Installing RPM package..."
rpm -ivh "$RPM_FILE" || {
    echo -e "${RED}Error: Failed to install RPM package.${NC}"
    exit 1
}

echo -e "${GREEN}Installation complete! You can now use 'rupp-cli' (e.g., 'rupp-cli status').${NC}"
