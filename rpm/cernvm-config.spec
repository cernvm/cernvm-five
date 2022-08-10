Summary: CernVM 5 config files and scripts
Name: cernvm-config-default
Version: 1.0.2
Release: 1
Group: Applications/System
Source0: cernvm_env.sh
Source1: 90-cernvm.conf
Source2: cernvm-five.cern.ch.conf
Source3: cernvm-five.cern.ch.pub
Source4: cernvm_config
BuildArch: noarch
License: BSD

%description
Contains default configuration for CernVM 5 container images

%prep

%build

%install

mkdir -p %{buildroot}/etc/cernvm/
mkdir -p %{buildroot}/etc/cvmfs/config.d/
mkdir -p %{buildroot}/etc/cvmfs/default.d/
mkdir -p %{buildroot}/etc/cvmfs/keys/

install -m 444 %{SOURCE0} %{buildroot}/etc/profile.d/cernvm_env.sh
install -m 444 %{SOURCE1} %{buildroot}/etc/cvmfs/default.d/90-cernvm.conf
install -m 444 %{SOURCE2} %{buildroot}/etc/cvmfs/config.d/cernvm-five.cern.ch.conf
install -m 444 %{SOURCE3} %{buildroot}/etc/cvmfs/keys/cernvm-five.cern.ch.pub
install -m 444 %{SOURCE4} %{buildroot}/etc/cernvm/cernvm_config

%files
/etc/profile.d/cernvm_env.sh
/etc/cvmfs/default.d/90-cernvm.conf
/etc/cvmfs/config.d/cernvm-five.cern.ch.conf
/etc/cvmfs/keys/cernvm-five.cern.ch.pub
/etc/cernvm/cernvm_config

%changelog