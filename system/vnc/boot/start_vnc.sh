#!/bin/bash
set -e
export VNC_IP=$(hostname -i)
#change vnc password
mkdir -p "$HOME/.vnc"
PASSWD_PATH="$HOME/.vnc/passwd"

if [[ -f $PASSWD_PATH ]]; then
    echo -e "\n---------  purging existing VNC password settings  ---------"
    rm -f $PASSWD_PATH
fi

if [[ $VNC_VIEW_ONLY == "true" ]]; then
    echo "start VNC server in VIEW ONLY mode!"
    #create random pw to prevent access
    echo $(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 20) | vncpasswd -f > $PASSWD_PATH
fi
echo "$VNC_PW" | vncpasswd -f >> $PASSWD_PATH 
chmod 600 $PASSWD_PATH

#Starting VNC-Server
vncserver $DISPLAY -depth $VNC_COL_DEPTH -geometry $VNC_RESOLUTION #&> $BOOT_SCRIPTS/no_vnc_startup.log
#Starting a Xfce4-Session
xfce4-session --display=$DISPLAY &> xfce.log &
