#!/bin/bash
# Required script: set.usage, func.color, set.tempfile, set.query, file-register
# Required packages: coreutils(tty,cat,tail),grep
[ "$2" ] || . set.usage "[oldstr] [newstr] (ext)" "ENV[files] for target" "ENV[ex] for exclude line" "(ext) includes [mv old.ext new.ext]"
. func.color
hl(){ echo -en "$C2${*}$C0"; }
al(){ echo -en "$C1${*}$C0"; }
. set.tempfile outtmp
oldstr="$1"
newstr="$2"
ext="$3"
for orgfile in $(grep --exclude-dir=.git -RIl "$oldstr" ${files:-.}); do
    [[ $orgfile == *~ ]] && continue
    echo2 "#### File:[$orgfile] ####\n"
    if grep "$newstr" "$orgfile" ; then
        echo1 "\tmight conflict with ($oldstr -> $newstr)!\n"
    else
        echo1 "\tmake this file change?\n"
    fi
    . set.query || continue
    IFS=$'\n\r'
    while read -r line ; do
        conv="${line//$oldstr/$newstr}"
        if [ "$conv" != "$line" ] && ! { [ "$ex" ] && [[ "$line" == *$ex* ]]; }
        then
            before="${line//$oldstr/$C1$oldstr$C0}"
            after="${line//$oldstr/$C1$newstr$C0}"
            echo -n "${before}"
            echo2 "\t====>\n"
            echo "${after}"
            . set.query && line="$conv"
        fi
        echo "$line" >> "$outtmp"
    done < <(cat "$orgfile";tail -c1 "$orgfile"|grep -q . && echo)
    overwrite "$outtmp" "$orgfile"
done
[ "$ext" ] || exit
oldfn="$oldstr.$ext"
newfn="$newstr.$ext"
if [ -e "$oldfn" ] ; then
    echo2 "#### Rename:[$oldfn] ####\n"
    if [ -e "$newfn" ] ; then
        echo1 "\tnewfn aleady exists\n"
    else
        echo1 "\trename $oldfn -> $newfn?\n"
        . set.query && mv $oldfn $newfn
    fi
fi
file-register
