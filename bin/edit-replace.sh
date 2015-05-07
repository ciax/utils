#!/bin/bash
#alias rep
# Required scripts: func.getpar func.query file-selflink file-clean
# Description: replace string in files
. func.getpar
_usage "[oldstr] [newstr] (ext)
\tENV{files} for target
\tENV{ex} for exclude line
\t(ext) includes {git mv old.ext new.ext}"
. func.query
_temp outtmp
oldstr="$1"
newstr="$2"
ext="$3"
echo "OLDSTR=$oldstr, NEWSTR=$newstr"
for orgfile in $(grep --exclude-dir=.git -RIl "$oldstr" ${files:-.}); do
    [[ $orgfile == *~ ]] && continue
    echo $C2"#### File:[$orgfile] ####"$C0
    if [ "$newstr" ] && grep "$newstr" "$orgfile" ; then
        _al "might conflict with ($oldstr -> $newstr)!"
    else
        _al "make this file change?"
    fi
    _query || continue
    IFS=$'\n\r'
    while read -r line ; do
        conv="${line//$oldstr/$newstr}"
        if [ "$conv" != "$line" ] && ! { [ "$ex" ] && [[ "$line" == *$ex* ]]; }
        then
            before="${line//$oldstr/$C1$oldstr$C0}"
            after="${line//$oldstr/$C1$newstr$C0}"
            echo -n "${before}"
            _hl "====>"
            echo "${after}"
            _query && line="$conv"
        fi
        echo "$line" >> "$outtmp"
    done < <(cat "$orgfile";tail -c1 "$orgfile"|grep -q . && echo)
    _overwrite "$outtmp" "$orgfile"
done
[ "$ext" ] || exit
oldfn="$oldstr.$ext"
newfn="$newstr.$ext"
if [ -e "$oldfn" ] ; then
    echo $C2"#### Rename:[$oldfn] ####"$C0
    if [ -e "$newfn" ] ; then
        _al "newfn aleady exists"
    else
        _al "rename $oldfn -> $newfn?"
        _query && git mv $oldfn $newfn
    fi
fi
file-clean ~/bin
file-selflink
