#!/bin/bash
# Required scripts: func.getpar setup-ssh func.ssh
# Desctiption: impose self trust to the object host (push pub-key anonymously)
. func.getpar
. func.ssh
_usage "[(user@)host(:port)] .."
setup-ssh
for rem; do
    _ssh-fetch $rem # | _overwrite ~/$ATH
done
