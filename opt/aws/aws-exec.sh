#!/bin/bash
. aws-conf
[ "$1" ] || usage
case "$1" in
    -r)#retrival
	      eval $(aws-mkcmd -r) > $jobjson
        ;;
    -q)#query job
        eval $(aws-mkcmd -q) > $resjson
        aws-showres
        ;;
    -g)#get data
        eval $(aws-mkcmd -g)
        ;;
    -d)#delete archive
        touch $delarc
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
