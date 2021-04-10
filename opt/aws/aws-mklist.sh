#!/bin/bash
[ "$1" ] || { echo "Usage:aws-mklist (-ad)"; exit; }
ofile="output.json"
afile=".archive_list.txt"
dfile=".delete_list.txt"
dres=".deleted.txt"
rres=".remained.txt"
tmp=".temp.txt"
case "$1" in
    -a)
        [ -e $ofile ] || { echo "No input file($ofile)"; exit; }
        jq -r .ArchiveList[].ArchiveId $ofile > $afile
        ;;
    -d)
        if [ -e $dfile ] ; then
            if [ -e $dres ] ; then
                sort $dfile $dres | uniq -u > $tmp
                mv $tmp $dfile
            fi
        elif [ -e $afile ] ; then
            if [ -e $dres ]; then
                sort $afile $dres | uniq -u > $dfile
            else
                sort -u $afile > $dfile
            fi
        else
            echo "No input file($afile)"
        fi
        ;;
esac
