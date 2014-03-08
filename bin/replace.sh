#!/bin/bash
# Required scripts: func.usage, func.temp, func.query, file-register
# Required packages: coreutils(tty,cat,tail),grep
. func.usage "[oldstr] [newstr] (ext)" $2 <<EOF
ENV[files] for target
ENV[ex] for exclude line
(ext) includes [mv old.ext new.ext]
EOF
al(){ echo -e "\t"$C1"$*"$C0; }
hl(){ echo -e "\t"$C2"$*"$C0; }
. func.query
. func.temp outtmp
oldstr="$1"
newstr="$2"
ext="$3"
for orgfile in $(grep --exclude-dir=.git -RIl "$oldstr" ${files:-.}); do
    [[ $orgfile == *~ ]] && continue
    echo $C2"#### File:[$orgfile] ####"$C0
    if grep "$newstr" "$orgfile" ; then
        al "might conflict with ($oldstr -> $newstr)!"
    else
        al "make this file change?"
    fi
    query || continue
    IFS=$'\n\r'
    while read -r line ; do
        conv="${line//$oldstr/$newstr}"
        if [ "$conv" != "$line" ] && ! { [ "$ex" ] && [[ "$line" == *$ex* ]]; }
        then
            before="${line//$oldstr/$C1$oldstr$C0}"
            after="${line//$oldstr/$C1$newstr$C0}"
            echo -n "${before}"
            hl "====>"
            echo "${after}"
            query && line="$conv"
        fi
        echo "$line" >> "$outtmp"
    done < <(cat "$orgfile";tail -c1 "$orgfile"|grep -q . && echo)
    overwrite "$outtmp" "$orgfile"
done
[ "$ext" ] || exit
oldfn="$oldstr.$ext"
newfn="$newstr.$ext"
if [ -e "$oldfn" ] ; then
    echo $C2"#### Rename:[$oldfn] ####"$C0
    if [ -e "$newfn" ] ; then
        al "newfn aleady exists"
    else
        al "rename $oldfn -> $newfn?"
        query && mv $oldfn $newfn
    fi
fi
file-register
