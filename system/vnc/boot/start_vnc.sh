#!/bin/bash
# This file is part of CernVM 5.
# This script first sets a password (Dockerfile ENV VNC_PW) for the VNC Server and then starts the server 
set -e
export VNC_IP=$(hostname -i)
# Change VNC password to Dockerfile ENV VNC_PW
mkdir -p "$HOME/.vnc"
PASSWD_PATH="$HOME/.vnc/passwd"

if [[ -f $PASSWD_PATH ]]; then
    echo -e "\n---------  purging existing VNC password settings  ---------"
    rm -f $PASSWD_PATH
fi

echo "$VNC_PW" | vncpasswd -f >> $PASSWD_PATH 
chmod 600 $PASSWD_PATH

#Starting VNC-Server
vncserver $DISPLAY -depth $VNC_COL_DEPTH -geometry $VNC_RESOLUTION #&> $BOOT_SCRIPTS/no_vnc_startup.log

#Starting a Xfce4-Session
xfce4-session --display=$DISPLAY &> xfce.log &
