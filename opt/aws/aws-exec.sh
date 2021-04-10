#!/bin/bash
[ "$1" ] || { echo "Usage:aws-exec -(rqgd)" ; exit; }
. aws-conf
case "$1" in
    #retrival
    -r)
	      $(aws-mkcmd -r) > $jobjson
        ;;
    #query job
    -q)
        $(aws-mkcmd -q) > $resjson
        showres
        ;;
    #get data
    -g)
        $(aws-mkcmd -g)
        ;;
    #delete archive
    -d)
        while read line; do
            if $(aws-mkcmd -d "$line") ; then
                echo "$line" >> $dellog
                echo "deleted $line"
            else
                echo "failed $line"
            fi 
        done < $dellist
        ;;
esac
