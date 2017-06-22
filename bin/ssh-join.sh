#!/bin/bash
# Required scripts: func.getpar func.ssh
# Desctiption: share authorized keys with remote host (Accepts join)
. func.getpar
. func.ssh
_usage "[(user@)host(:port)] .."
for url;do
    _ssh-fetch $url
done
_ssh-accept
for url;do
    _ssh-push $url
done
