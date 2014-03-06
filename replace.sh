#!/bin/bash
# Required script: func.usage, func.color, func.temp, set.query, file-register
# Required packages: coreutils(tty,cat,tail),grep
. func.usage "[oldstr] [newstr] (ext)" $2 <<EOF
ENV[files] for target
ENV[ex] for exclude line
(ext) includes [mv old.ext new.ext]
EOF
. func.color
. func.temp outtmp
oldstr="$1"
newstr="$2"
ext="$3"
for orgfile in $(grep --exclude-dir=.git -RIl "$oldstr" ${files:-.}); do
    [[ $orgfile == *~ ]] && continue
    color2 "#### File:[$orgfile] ####"
    if grep "$newstr" "$orgfile" ; then
        color1 "\tmight conflict with ($oldstr -> $newstr)!"
    else
        color1 "\tmake this file change?"
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
            color2 "\t====>"
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
    color2 "#### Rename:[$oldfn] ####"
    if [ -e "$newfn" ] ; then
        color1 "\tnewfn aleady exists"
    else
        color1 "\trename $oldfn -> $newfn?"
        . set.query && mv $oldfn $newfn
    fi
fi
file-register
