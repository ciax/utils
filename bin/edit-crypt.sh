#!/bin/bash
# Required packages: gnupg
# Required scripts: func.getpar
# Description: crypt/decrypt strings
#   need ~/.ssh/.gpgpass for passphrase
. func.getpar
salt="--passphrase-file $HOME/.ssh/.gpgpass"
opt-d(){ #decrypt
    base64 -d|gpg $salt
    exit
}
_usage "<file>"
cat $*|gpg -c --force-mdc $salt|base64 -w0
