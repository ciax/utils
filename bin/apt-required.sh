#!/bin/bash
# Required scripts: func.app, show-required
# Description: Debian package utils
. func.app
_temp list
while read cmd;do
    echo "bin/$cmd "
done < <(show-required commands)|sort -u >$list
cat $list
apt-file search $(< $list)
