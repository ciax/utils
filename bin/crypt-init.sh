#!/bin/bash
# Description: init crypt passphrase
#   need ~/.ssh/gpgpass for passphrase
passfile="$HOME/.ssh/gpgpass"
grep -q . "$passfile" >/dev/null 2>&1 && exit
read -sp "GPG Password:" -e passphrase < /dev/tty
echo "$passphrase" > $passfile
chmod 600 $passfile
