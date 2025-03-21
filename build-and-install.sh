#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Check if running in the correct directory
if [ ! -d "rpm/SOURCES" ] || [ ! -f "rpm/SOURCES/rupp-cli.sh" ]; then
    echo -e "${RED}Error: Must run this script from the rupp-cli directory with rpm/SOURCES/rupp-cli.sh present.${NC}"
    exit 1
fi

# Check for sudo privileges (needed for install)
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}This script requires sudo privileges for RPM installation. Please run with sudo.${NC}"
    exit 1
fi

# Install rpm-build if not present
if ! command -v rpmbuild &> /dev/null; then
    echo "Installing rpm-build..."
    yum install -y rpm-build || {
        echo -e "${RED}Error: Failed to install rpm-build. Please install it manually.${NC}"
        exit 1
    }
fi

# Set up RPM build directories
echo "Setting up RPM build environment..."
mkdir -p ~/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}

# Copy the script to ~/rpmbuild/SOURCES
cp rpm/SOURCES/rupp-cli.sh ~/rpmbuild/SOURCES/ || {
    echo -e "${RED}Error: Failed to copy rupp-cli.sh to ~/rpmbuild/SOURCES.${NC}"
    exit 1
}

# Create the spec file if it doesn’t exist
SPEC_FILE="rpm/SPECS/rupp-cli.spec"
if [ ! -f "$SPEC_FILE" ]; then
    echo "Creating rupp-cli.spec..."
    cat > "$SPEC_FILE" << 'EOF'
Name:           rupp-cli
Version:        1.0
Release:        1
Summary:        A CLI tool to manage firewalld
License:        GPL
Source0:        rupp-cli.sh

%description
A simple CLI tool to manage firewalld rules, zones, and services.

%prep
# No prep needed for a single script

%build
# No build step for a Bash script

%install
mkdir -p %{buildroot}/usr/bin
install -m 755 rupp-cli.sh %{buildroot}/usr/bin/rupp-cli

%files
/usr/bin/rupp-cli

%changelog
* Fri Mar 21 2025 Your Name <you@example.com> - 1.0-1
- Initial release
EOF
fi

# Copy spec file to ~/rpmbuild/SPECS
cp "$SPEC_FILE" ~/rpmbuild/SPECS/ || {
    echo -e "${RED}Error: Failed to copy rupp-cli.spec to ~/rpmbuild/SPECS.${NC}"
    exit 1
}

# Build the RPM
echo "Building RPM package..."
rpmbuild -ba ~/rpmbuild/SPECS/rupp-cli.spec || {
    echo -e "${RED}Error: Failed to build RPM package.${NC}"
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
