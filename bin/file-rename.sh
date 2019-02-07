#!/bin/bash
# Required scripts: func.getpar func.query
# Description: rename files
#alias ren
. func.getpar
. func.query
_usage "[oldname] [newname]"
oldfn="$1";shift
newfn="$1";shift
[ -e "$oldfn" ] || exit 1
_msg "#### Rename:[$oldfn] ####"
if [ -e "$newfn" ] ; then
    _al "newfn aleady exists"
    exit 1
else
    _al "rename $oldfn -> $newfn?"
    _query || exit
fi
if git status >/dev/null 2>&1; then
    git mv $oldfn $newfn
else
    mv $oldfn $newfn
fi
