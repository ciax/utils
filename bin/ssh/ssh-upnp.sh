#!/bin/bash
# Requied packages: miniupnpc
pfile=~/.var/ssh-export.txt
case "$1" in
    -d)
        ext=${2:-$(<$pfile)}
        upnpc -d $ext tcp
        ;;
    -c)
        file=~/ssh-upnp
        scr="$HOME/utils/bin/ssh/ssh-upnp.sh ${2:-$(<$pfile)}"
        echo $scr > $file
        chmod +x $file
        sudo mv $file /etc/network/if-up.d/
        cat /etc/network/if-up.d/ssh-upnp
        ;;
    [0-9]*)
        ext=$1
        a=$(ip route)
        l=${a##*src }
        upnpc -a $l 22 $ext tcp
        echo $ext > $pfile
        ;;
    *)
        echo "$0 (-d,c) [port]"
        ;;
esac
