#!/bin/bash
[ "$2" ] || . set.usage "[oldstr] [newstr] (ext)" "ENV[files] for target" "ENV[ex] for exclude line" "(ext) includes [mv old.ext new.ext]"
. set.color
hl(){ echo -en "$C2${*}$C0"; }
al(){ echo -en "$C1${*}$C0"; }
. set.tempfile outtmp
oldstr="$1"
newstr="$2"
ext="$3"
tty=`tty`
for orgfile in $(grep --exclude-dir=.git -RIl "$oldstr" ${files:-.}); do
    [[ $orgfile == *~ ]] && continue
    hl "#### File:[$orgfile] ####\n"
    if grep "$newstr" "$orgfile" ; then
        al "\tmight conflict with ($oldstr -> $newstr)!\n"
    else
        al "\tmake this file change?\n"
    fi
    . set.query || continue
    IFS=$'\n\r'
    while read -r line ; do
        conv="${line//$oldstr/$newstr}"
        if [ "$conv" != "$line" ] && ! { [ "$ex" ] && [[ "$line" == *$ex* ]]; }
        then
            before="${line//$oldstr/`al $oldstr`}"
            after="${line//$oldstr/`al $newstr`}"
            echo -n "${before}"
            hl "\t====>\n"
            echo "${after}"
            . set.query && line="$conv"
        fi
        echo "$line" >> "$outtmp"
    done < <(cat "$orgfile";tail -c1 "$orgfile"|grep -q . && echo)
    file-move "$outtmp" "$orgfile"
done
[ "$ext" ] || exit
oldfn="$oldstr.$ext"
newfn="$newstr.$ext"
if [ -e "$oldfn" ] ; then
    hl "#### Rename:[$oldfn] ####\n"
    if [ -e "$newfn" ] ; then
        al "\tnewfn aleady exists\n"
    else
        al "\trename $oldfn -> $newfn?\n"
        . set.query && mv $oldfn $newfn
    fi
fi
register-files