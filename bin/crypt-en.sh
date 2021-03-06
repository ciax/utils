#!/bin/bash
# Required packages: gnupg
# Required scripts: func.getpar
# Description: encrypt strings
#   need ~/.ssh/gpgpass for passphrase
. func.getpar
passfile="$HOME/.ssh/gpgpass"
salt="--passphrase-file $passfile"
_usage "<file>"
gpg -c --force-mdc --batch $salt -o - | base64 -w0
