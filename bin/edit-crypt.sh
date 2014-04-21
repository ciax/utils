#!/bin/bash
# Required packages: gnupg
# Required scripts: func.getpar
# Description: crypt/decrypt strings
#   need ~/.ssh/.gpgpass for passphrase
. func.getpar
passfile="$HOME/.ssh/.gpgpass"
salt="--passphrase-file $passfile"
opt-d(){ #decrypt
    base64 -d|gpg $salt
    exit
}
if [ ! -s "$passfile" ] ; then
    read -p "GPG Password:" -e passphrase < $(tty)
    echo "$passphrase" > $passfile
fi
_usage "<file>"
cat $*|gpg -c --force-mdc $salt|base64 -w0
