#!/bin/bash
# Some commands to run after container startup
#Run with > /dev/null

# Set title of terminal to "CernVM 5"
echo -e "\e]0;"; echo -n CernVM 5; echo -ne "\007"

# Set bash prompt
export PS1="\e[1;36m[CVM bash-\v \w]\$ \e[0m"


# Saying bye
#draft
trap 'echo "Leaving container..."; exit' EXIT SIGINT TERM
