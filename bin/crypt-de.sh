#!/bin/bash
# Required packages: gnupg
# Required scripts: func.getpar
# Description: decrypt strings
#   need ~/.ssh/.gpgpass for passphrase
. func.getpar
passfile="$HOME/.ssh/gpgpass"
salt="--passphrase-file $passfile"
_usage "<file>"
base64 -d|gpg --no-tty -qd $salt || rm -f $passfile
