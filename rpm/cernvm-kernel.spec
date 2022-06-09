Summary: CernVM 5 VM System
Name: cernvm-kernel-default
Version: 1.0.0
Group: System/Middleware
Release: 1
Group: Applications/System
License: BSD
BuildArch: noarch

Requires: kernel-core
Requires: systemd
Requires: NetworkManager
Requires: e2fsprogs
Requires: sudo
Requires: dracut
Requires: qemu-guest-agent
Requires: openssh-server

%description
Meta-package including packages to build a kernel-enabled CernVM 5 Image

%files

%doc

%changelog