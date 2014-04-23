#!/bin/bash
# Required packages: gnupg
# Required scripts: func.getpar
# Description: crypt/decrypt strings
#   need ~/.ssh/.gpgpass for passphrase
. func.getpar
passfile="$HOME/.var/gpgpass"
salt="--passphrase-file $passfile"
opt-i(){ #init
    grep -q . "$passfile" >/dev/null 2>&1 && exit
    read -p "GPG Password:" -e passphrase < /dev/tty
    echo "$passphrase" > $passfile
    chomd 600 $passfile
    exit
}
opt-e(){ #encrypt
    cat $*|gpg -c --force-mdc $salt|base64 -w0
    exit
}
_usage "<file>"
base64 -d|gpg $salt || rm $passfile
