#!/bin/bash
[ "$1" ] || { echo "Usage:aws-mklist (-ad)"; exit; }
. aws-conf
case "$1" in
    -a)
        [ -e $outjson ] || { echo "No input file($outjson)"; exit; }
        jq -r .ArchiveList[].ArchiveId $outjson > $arclist
        ;;
    -d)
        if [ -e $dellist ] ; then
            if [ -e $dellog ] ; then
                sort $dellist $dellog | uniq -u > $tmp
                mv $tmp $dellist
            fi
        elif [ -e $arclist ] ; then
            if [ -e $dellog ]; then
                sort $arclist $dellog | uniq -u > $dellist
            else
                sort -u $arclist > $dellist
            fi
        else
            echo "No input file($arclist)"
        fi
        ;;
esac
