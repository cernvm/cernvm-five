### This file is part of CernVM 5. ###
#### Environment and Aliases for CernVM 5 ###
# TODO:  /etc/bash_completion.d/

# Sets up PATH for System Applications
export PATH="$PATH:/cvmfs/cernvm-five.cern.ch/systemapps/usr/local/sbin:/cvmfs/cernvm-five.cern.ch/systemapps/usr/local/bin:/cvmfs/cernvm-five.cern.ch/systemapps/usr/sbin:/cvmfs/cernvm-five.cern.ch/systemapps/usr/bin:/cvmfs/cernvm-five.cern.ch/systemapps/sbin:/cvmfs/cernvm-five.cern.ch/systemapps/bin"

# Wrapping dnf 
alias dnf='wrapped_dnf'
wrapped_dnf() {
    LLP=${LD_LIBRARY_PATH}
    export LD_LIBRARY_PATH=""
    /usr/bin/dnf "$@"
    res=$?
    export LD_LIBRARY_PATH=${LLP}
    return $res
}

alias yum='/usr/bin/dnf "$@"'
alias cernvm_config='bash /etc/cernvm/cernvm_config "$@"'

set_banner() {
echo -e "\033[32mCernVM Appliance v5\033[0m" 
echo "$(rpm -iq --queryformat 'CernVM Config: %{VERSION}\n' cernvm-config-default)"
echo "https://github.com/cernvm/cernvm-five"
}

set_titel() {
  echo -e "\e]0;"; echo -n CernVM 5; echo -ne "\007"
}