Summary: CernVM 5 config files and scripts
Name: cernvm-config-default
Version: 1.0.1
Release: 1
Group: Applications/System
Source1: functions
Source2: 90-cernvm.conf
Source3: cernvm-five.cern.ch.conf
Source4: cernvm-five.cern.ch.pub
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

install -m 444 %{SOURCE1} %{buildroot}/etc/cernvm/functions
install -m 444 %{SOURCE2} %{buildroot}/etc/cvmfs/default.d/90-cernvm.conf
install -m 444 %{SOURCE3} %{buildroot}/etc/cvmfs/config.d/cernvm-five.cern.ch.conf
install -m 444 %{SOURCE4} %{buildroot}/etc/cvmfs/keys/cernvm-five.cern.ch.pub

%files
/etc/cernvm/systemapps
/etc/cvmfs/default.d/90-cernvm.conf
/etc/cvmfs/config.d/cernvm-five.cern.ch.conf
/etc/cvmfs/keys/cernvm-five.cern.ch.pub


%changelog
