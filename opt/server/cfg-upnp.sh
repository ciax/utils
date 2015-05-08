#!/bin/bash
# Required packages: miniupnpc
dir=/etc/network/if-up.d
file=cfg-upnp
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
        cat > $file <<EOF
#!/bin/sh
set \$(ip route)
shift \$((\$# - 1))
upnpc -a \$1 22 $ext tcp
EOF
        chmod +x $file
        sudo mv $file $dir
        sudo $dir/$file
        ;;
    *)
        echo "$0 (-d) [port]"
        ;;
esac
