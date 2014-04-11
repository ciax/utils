#!/bin/bash
# Required packages: gnupg
# Required scripts: func.getpar
# Description: crypt/decrypt strings
#   need ~/.ssh/.gpgpass for passphrase
. func.getpar
pass="$HOME/.ssh/.gpgpass"
salt="--passphrase-file $pass"
opt-d(){ #decrypt
    base64 -d|gpg $salt
    exit
}
[ -s "$pass" ] || _abort "No passphrse file"
_usage "<file>"
cat $*|gpg -c --force-mdc $salt|base64 -w0
