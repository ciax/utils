#!/bin/bash
. aws-conf
[ "$1" ] || usage
subtract(){
    [ -e $dellog ] || return
    sort $dellist $dellog | uniq -u > $tmp
    mv $tmp $dellist
    cat $dellog >> $delarc
    : > $dellog
}
case "$1" in
    -a)#archive
        [ -e $outjson ] || { echo "No input file($outjson)"; exit; }
        [ -e $arclist ] && mv -b $arclist $arclist.old
        jq -r .ArchiveList[].ArchiveId $outjson > $arclist
        ;;
    -d)#delete
        if [ -e $dellist ] ; then
            subtract
        elif [ -e $arclist ] ; then
            cp $arclist $dellist
            subtract
        else
            echo "No input file($arclist)"
        fi
        ;;
esac
