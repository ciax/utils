#!/bin/bash
# Required scripts: func.getpar func.query link-self file-clean
# Description: replace string in files
#alias rep
. func.getpar
opt-e(){ # =[ext] file extension for rename {git mv old.ext new.ext}
    [ "$1" ] || return
    oldfn="$oldstr.$1"
    newfn="$newstr.$1"
    cd $(dirname $(realpath $oldfn))
    file-rename $oldfn $newfn && file-register $newfn
}
opt-x(){ # =[regexp] for exclude line
    ex=$1;
}
_usage "[oldstr] [newstr] (files)"
. func.query
_temp outtmp
oldstr="$1";shift
newstr="$1";shift
files="$*"
_exe_opt x
echo "OLDSTR=$oldstr, NEWSTR=$newstr"
for orgfile in $(grep --exclude-dir=.git -RIl "$oldstr" ${files:-.}); do
    [[ $orgfile == *~ ]] && continue
    _msg "#### File:[$orgfile] ####"
    [ -h $orgfile ] && orgfile=$(realpath $orgfile)
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
    _overwrite "$orgfile" "$outtmp"
done
_exe_opt
