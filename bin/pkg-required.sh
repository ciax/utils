#!/bin/bash
# Required scripts: func.app, show-required
# Description: Debian package utils
. func.app
while read cmd;do
    type $cmd >/dev/null 2>&1 || apt-file search "bin/$cmd "
done < <(show-required commands)|sort -u
