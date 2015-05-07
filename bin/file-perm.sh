#!/bin/bash
# Required commands: find
# Description: unify the file permittion under the current/sub dir
#alias rwx
. func.msg
_warn "Set File Permissions"
regexp='.*\.(sh|pl|py|rb|exp|js)$'
sudo find . -regex '.*\.git' -prune -o -regextype posix-awk -type f \
\( ! -regex $regexp -exec chmod -c 644 {} \; \) , \
\( -regex $regexp -exec chmod -c 755 {} \; \)
