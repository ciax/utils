#!/bin/bash
# Required scripts: func.getpar func.ssh
# Desctiption: share authorized keys with remote host (Accepts join)
. func.getpar
. func.ssh
_usage "[(user@)host(:port)] .."
ADMIN=1
for url;do
    _rem-fetch $url
done
_rem-trim
for url;do
    _rem-push $url
done
