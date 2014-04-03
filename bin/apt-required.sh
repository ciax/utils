#!/bin/bash
# Required scripts: func.app, show-required
# Description: Debian package utils
. func.app
while read cmd;do
    dpkg -S "*bin/$cmd"
done < <(show-required commands) | cut -d: -f1|sort -u
