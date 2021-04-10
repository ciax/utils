#!/bin/bash
[ "$1" ] || { echo "Usage:aws-mklist (-ad)"; exit; }
ofile="output.json"
afile=".archive_list.txt"
dfile=".delete_list.txt"
dres=".deleted.txt"
rres=".remained.txt"
case "$1" in
    -a)
        [ -e $ofile ] || { echo "No input file($ofile)"; exit; }
        jq -r .ArchiveList[].ArchiveId $ofile > $afile
        ;;
    -d)
        [ -e $afile ] || { echo "No input file($afile)"; exit; }
        if [ -e $dres ]; then
            sort $afile $dres | uniq -u > $dfile:
        else
            cp $afile $dfile
        fi
        ;;
esac
