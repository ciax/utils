#!/bin/bash
# Required scripts: func.getpar func.ssh
# Description: impose self trust to the object host (push pub-key anonymously)
. func.getpar
. func.ssh
_usage "[(user@)host(:port)] .."
for url;do
    _ssh_fetch $url
done
_ssh-impose
for url;do
    _ssh_push $url
done
