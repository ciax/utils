#!/bin/bash
# Required scripts: show-required
# Description: Debian package utils
while read cmd;do
    type $cmd >/dev/null 2>&1 || pkg where "$cmd"
done < <(show-required commands)|sort -u