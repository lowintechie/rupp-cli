Name:           rupp-cli
Version:        1.0.0
Release:        1%{?dist}
Summary:        A comprehensive network security CLI tool for Linux systems

License:        MIT
Source0:        %{name}.tar.gz

BuildArch:      noarch
Requires:       bash, iptables, fail2ban-client, selinux-policy, openssh-server, yum, systemd

%description
rupp-cli is a command-line tool for managing network security on Linux systems. It provides features for firewall management, SELinux configuration, SSH hardening, intrusion detection, system updates, and one-click security hardening.

%prep
%setup -q -n %{name}

%build
# No build step required for shell scripts

%install
rm -rf %{buildroot}
install -d %{buildroot}/usr/bin
install -d %{buildroot}/usr/lib/rupp-cli
install -m 755 rupp-cli.sh %{buildroot}/usr/bin/rupp-cli
install -m 644 lib/*.sh %{buildroot}/usr/lib/rupp-cli/

%files
/usr/bin/rupp-cli
/usr/lib/rupp-cli/*.sh

%changelog
* Thu Mar 20 2025 Your Name <your.email@example.com> - 1.0.0-1
- Initial release