#!/bin/bash
# Required commands: find
# Description: unify the file permittion under the current/sub dir
#alias rwx
echo $C3"Set File Permissions"$C0
regexp='.*\.(sh|pl|py|rb|exp|js)$'
sudo find . -regex '.*\.git' -prune -o -regextype posix-awk -type f \
\( ! -regex $regexp -exec chmod -c 644 {} \; \) , \
\( -regex $regexp -exec chmod -c 755 {} \; \)
