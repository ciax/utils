#!/bin/bash
[ "$1" ] || { echo "Usage:aws-exec -(rqgd)" ; exit; }
. aws-conf
case "$1" in
    #retrival
    -r)
	      eval $(aws-mkcmd -r) > $jobjson
        ;;
    #query job
    -q)
        eval $(aws-mkcmd -q) > $resjson
        showres
        ;;
    #get data
    -g)
        eval $(aws-mkcmd -g)
        ;;
    #delete archive
    -d)
        touch $dellist
        while read line; do
            if eval $(aws-mkcmd -d $line) ; then
                echo "$line" >> $dellog
                echo "deleted $line"
            else
                echo "failed $line"
                break
            fi 
        done < $dellist
        ;;
esac
