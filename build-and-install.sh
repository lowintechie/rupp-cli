#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCES_DIR="$SCRIPT_DIR/rpm/SOURCES"
LIB_DIR="$SOURCES_DIR/lib"
SPEC_FILE="$SCRIPT_DIR/rpm/SPECS/rupp-cli.spec"

# Check if running in the correct directory with rupp-cli.sh present
if [ ! -d "$SOURCES_DIR" ] || [ ! -f "$SOURCES_DIR/rupp-cli.sh" ]; then
    echo -e "${RED}Error: rupp-cli.sh not found in $SOURCES_DIR/.${NC}"
    echo "Please ensure the script is in the correct location and try again."
    exit 1
fi

# Check if lib/ directory exists
if [ ! -d "$LIB_DIR" ]; then
    echo -e "${RED}Error: lib/ directory not found in $SOURCES_DIR/.${NC}"
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

# Debug: List files in rpm/SOURCES before copying
echo "Files in $SOURCES_DIR before copying:"
ls -la "$SOURCES_DIR"

# Debug: List files in rpm/SOURCES/lib before copying
echo "Files in $LIB_DIR before copying:"
ls -la "$LIB_DIR"

# Copy rupp-cli.sh from rpm/SOURCES/ to ~/rpmbuild/SOURCES/
echo "Copying rupp-cli.sh to ~/rpmbuild/SOURCES..."
cp -v "$SOURCES_DIR/rupp-cli.sh" ~/rpmbuild/SOURCES/ || {
    echo -e "${RED}Error: Failed to copy rupp-cli.sh to ~/rpmbuild/SOURCES.${NC}"
    exit 1
}

# Copy all scripts from rpm/SOURCES/lib/ to ~/rpmbuild/SOURCES/
echo "Copying scripts from $LIB_DIR to ~/rpmbuild/SOURCES..."
cp -rv "$LIB_DIR"/* ~/rpmbuild/SOURCES/ || {
    echo -e "${RED}Error: Failed to copy scripts from $LIB_DIR to ~/rpmbuild/SOURCES.${NC}"
    exit 1
}

# Debug: List files in ~/rpmbuild/SOURCES to verify
echo "Verifying files in ~/rpmbuild/SOURCES after copying..."
ls -la ~/rpmbuild/SOURCES/ || {
    echo -e "${RED}Error: Could not list files in ~/rpmbuild/SOURCES.${NC}"
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

%description
A CLI tool to manage various system configurations, including firewalld.

%prep
# No prep needed for scripts

%build
# No build step for Bash scripts

%install
# Create directories
mkdir -p %{buildroot}/usr/share/rupp-cli
mkdir -p %{buildroot}/usr/share/rupp-cli/lib
mkdir -p %{buildroot}/usr/bin
# Copy rupp-cli.sh to /usr/share/rupp-cli/
install -m 755 %{SOURCE0} %{buildroot}/usr/share/rupp-cli/rupp-cli.sh
# Copy other scripts to /usr/share/rupp-cli/lib/
install -m 755 %{SOURCE1} %{buildroot}/usr/share/rupp-cli/lib/audit.sh
install -m 755 %{SOURCE2} %{buildroot}/usr/share/rupp-cli/lib/banner.sh
install -m 755 %{SOURCE3} %{buildroot}/usr/share/rupp-cli/lib/checks.sh
install -m 755 %{SOURCE4} %{buildroot}/usr/share/rupp-cli/lib/config.sh
install -m 755 %{SOURCE5} %{buildroot}/usr/share/rupp-cli/lib/firewall.sh
install -m 755 %{SOURCE6} %{buildroot}/usr/share/rupp-cli/lib/harden.sh
install -m 755 %{SOURCE7} %{buildroot}/usr/share/rupp-cli/lib/help.sh
install -m 755 %{SOURCE8} %{buildroot}/usr/share/rupp-cli/lib/ids.sh
install -m 755 %{SOURCE9} %{buildroot}/usr/share/rupp-cli/lib/selinux.sh
install -m 755 %{SOURCE10} %{buildroot}/usr/share/rupp-cli/lib/ssh.sh
install -m 755 %{SOURCE11} %{buildroot}/usr/share/rupp-cli/lib/status.sh
install -m 755 %{SOURCE12} %{buildroot}/usr/share/rupp-cli/lib/updates.sh
# Create symlink for rupp-cli
ln -sf /usr/share/rupp-cli/rupp-cli.sh %{buildroot}/usr/bin/rupp-cli

%files
/usr/share/rupp-cli/*
/usr/share/rupp-cli/lib/*
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
