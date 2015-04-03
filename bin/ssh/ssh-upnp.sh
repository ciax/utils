#!/bin/bash
# Requied packages: miniupnpc
dir=/etc/network/if-up.d
file=ssh-upnp
case "$1" in
    -d)
        if [ -e $dir/$file ] ; then
            set - $(<$dir/$file)
            scr="upnpc -d $5 tcp"
            sudo rm $dir/$file
            echo $scr
            $scr
        else
            upnpc -d $2 tcp
        fi
        ;;
    [0-9]*)
        ext=$1
        a=$(ip route)
        set - ${a##*src }
        scr="upnpc -a $1 22 $ext tcp"
        cd
        echo $scr > $file
        chmod +x $file
        sudo mv $file $dir
        $scr
        ;;
    *)
        echo "$0 (-d) [port]"
        ;;
esac
