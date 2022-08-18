#!/bin/bash
### This file is part of CernVM 5. ###
#### Environment and Aliases for CernVM 5 ###
# TODO:  /etc/bash_completion.d/

# Sets up PATH for System Applications
export PATH="$PATH:/cvmfs/cernvm-five.cern.ch/systemapps/usr/local/sbin:/cvmfs/cernvm-five.cern.ch/x86_64/1.2/usr/local/sbin:/cvmfs/cernvm-five.cern.ch/x86_64/1.2/usr/local/bin:/cvmfs/cernvm-five.cern.ch/x86_64/1.2/usr/sbin:/cvmfs/cernvm-five.cern.ch/x86_64/1.2/usr/bin"

# Wrapping dnf 
alias dnf='wrapped_dnf'
wrapped_dnf() {
    LLP=${LD_LIBRARY_PATH}
    unset LD_LIBRARY_PATH
    /usr/bin/dnf "$@"
    res=$?
    export LD_LIBRARY_PATH=${LLP}
    return $res
}

alias yum='/usr/bin/dnf "$@"'

cernvm_config(){
  bash /etc/cernvm/cernvm_config "$@"
  return $?
}

set_banner() {
echo -e "\033[32mCernVM Appliance v5\033[0m" 
echo "$(rpm -iq --queryformat 'CernVM Config: %{VERSION}\n' cernvm-config-default)"
}

if [[ $CERNVM_NO_BANNER != "true" ]]; then 
    set_banner
  fi


set_titel() {
  echo -e "\e]0;"; echo -n CernVM 5; echo -ne "\007"
}
if [[ $CERNVM_NO_SHELL_TITLE != "true" ]]; then 
    set_titel
  fi

### For testing
apps=("nano" "vim" "ping" "wget" "strace" "tree" "diff" "cmp" "dnf" "ed" "patchelf")