Summary: CernVM 5 config files and scripts
Name: cernvm-config-default
Version: 1.0.0
Release: 1
Group: Applications/System
License: BSD

%description
Contains default configuratins for CernVM FS client in CernVM 5

%prep

%build

%install

mkdir -p %{buildroot}/etc/cernvm/
mkdir -p %{buildroot}/etc/cvmfs/config.d/
mkdir -p %{buildroot}/etc/cvmfs/default.d/
mkdir -p %{buildroot}/etc/cvmfs/keys/

install -m 444 /build/cernvm-five/config/etc/cernvm/userapps %{buildroot}/etc/cernvm/userapps
install -m 444 /build/cernvm-five/config/etc/cernvm/functions %{buildroot}/etc/cernvm/functions
install -m 444 /build/cernvm-five/config/etc/cvmfs/default.d/90-cernvm.conf %{buildroot}/etc/cvmfs/default.d/90-cernvm.conf
install -m 444 /build/cernvm-five/config/etc/cvmfs/config.d/cernvm-five.cern.ch.conf %{buildroot}/etc/cvmfs/config.d/cernvm-five.cern.ch.conf
install -m 444 /build/cernvm-five/config/etc/cvmfs/keys/cernvm-five.cern.ch.pub %{buildroot}/etc/cvmfs/keys/cernvm-five.cern.ch.pub

%files
/etc/cernvm/userapps
/etc/cernvm/functions
/etc/cvmfs/default.d/90-cernvm.conf
/etc/cvmfs/config.d/cernvm-five.cern.ch.conf
/etc/cvmfs/keys/cernvm-five.cern.ch.pub


%changelog
