#!/bin/bash
# Description: unify the file permittion under the current/sub dir
# Required packages: findutils
#alias rwx
regexp='.*\.(sh|pl|py|rb|exp|js)$'
sudo find . -regex '.*\.git' -prune -o -regextype posix-awk -type f \
\( ! -regex $regexp -exec chmod -c 644 {} \; \) , \
\( -regex $regexp -exec chmod -c 755 {} \; \)
