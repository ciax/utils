#!/bin/bash
# Unify the file permittion under the current/sub dir;
regexp='.*\.(sh|pl|py|rb|exp|js)$'
sudo find . -regextype posix-awk -type f \
\( ! -regex $regexp -exec chmod -c 664 {} \; \) , \
\( -regex $regexp -exec chmod -c 775 {} \; \)
