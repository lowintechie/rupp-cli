#!/bin/bash

# Check for required tools
command -v rpmbuild >/dev/null 2>&1 || { echo "rpmbuild is required. Install it with 'sudo yum install rpm-build'"; exit 1; }
command -v dnf >/dev/null 2>&1 || { echo "dnf is required. Install it with 'sudo yum install dnf'"; exit 1; }

# Build the RPM package
echo "Building RPM package..."
cd rpm
rpmbuild -ba *.spec || { echo "RPM build failed"; exit 1; }

# Install the built RPM
echo "Installing RPM..."
sudo dnf install -y ~/rpmbuild/RPMS/*/*.rpm || { echo "Installation failed"; exit 1; }

echo "rupp-cli installed successfully!"
