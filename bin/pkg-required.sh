#!/bin/bash
# Required scripts: func.app, show-required
# Description: Debian package utils
. func.app
while read cmd;do
    type $cmd >/dev/null 2>&1 || pkg where "$cmd"
done < <(show-required commands)|sort -u
