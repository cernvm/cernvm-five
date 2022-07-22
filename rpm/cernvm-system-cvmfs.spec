Summary: CernVM 5 system applications meta-package for CVMFS
Name: cernvm-system-cvmfs-default
Version: 1.0.1
Group: System/Middleware
Release: 1
Group: Applications/System
License: BSD
BuildArch: noarch

Requires: dnf
Requires: bash
Requires: HEP_OSlibs
Requires: vim
Requires: iputils
Requires: wget
Requires: tree
Requires: diffutils
Requires: ed
Requires: bc
Requires: nano
Requires: chrpath
Requires: tar
Requires: grep

%description
Meta-package including packages to build a CernVM 5 system applications area on CernVM-FS.
Includes common utilities and applications. 

%files

%doc

%changelog