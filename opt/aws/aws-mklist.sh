#!/bin/bash
. aws-conf
[ "$1" ] || usage
case "$1" in
    -a)#archive
        [ -e $outjson ] || { echo "No input file($outjson)"; exit; }
        [ -e $arclist ] && mv -b $arclist $arclist.old
        jq -r .ArchiveList[].ArchiveId $outjson > $arclist
        ;;
    -d)#delete
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
