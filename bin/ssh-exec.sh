#!/bin/bash
# Description: remote command exec with .bashrc
#alias rex
. func.getpar
_usage "[(user@)host] [command] (par..)"
dst="$1";shift
cmd="ssh $dst \"bash -i -c '$*'\""
eval "$cmd"
