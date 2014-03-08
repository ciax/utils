#!/bin/bash
# Description: unify the file permittion under the current/sub dir
# Required packages: findutils
#alias rwx
regexp='.*\.(sh|pl|py|rb|exp|js)$'
sudo find . -regextype posix-awk -type f \
\( ! -regex $regexp -exec chmod -c 664 {} \; \) , \
\( -regex $regexp -exec chmod -c 775 {} \; \)
