#!/bin/bash
# Required scripts: func.getpar func.ssh
# Desctiption: impose self trust to the object host (push pub-key anonymously)
. func.getpar
. func.ssh
_usage "[(user@)host(:port)] .."
for url;do
    _rem-fetch $url
done
_rem-impose
for url;do
    _rem-push $url
done
