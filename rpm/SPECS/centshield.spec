Name: centshield
Version: 1.0
Release: 1%{?dist}
Summary: A network security tool for CentOS
License: GPL
Source0: centshield.tar.gz
BuildArch: noarch
Requires: firewalld, fail2ban, logwatch

%description
CentShield secures CentOS systems with automated firewall setup, intrusion detection, and log monitoring.

%prep

%build

%install
install -m 755 %{_builddir}/security-tool.sh %{buildroot}/usr/bin/security-tool

%files
/usr/bin/security-tool

%changelog
* Fri Feb 02 2025 Your Name <your@email.com> - 1.0-1
- Initial build
