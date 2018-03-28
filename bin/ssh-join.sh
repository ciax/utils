#!/bin/bash
# Required scripts: func.getpar func.ssh
# Description: share authorized keys with remote host (Accepts join)
. func.getpar
. func.ssh
_usage "[(user@)host(:port)] .."
for url;do
    _ssh_fetch $url
done
_ssh-accept
for url;do
    _ssh_push $url
done
