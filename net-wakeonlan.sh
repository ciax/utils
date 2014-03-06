#!/bin/bash
# Required packages: wakeonlan
#alias wol
. set.usage "[host]" $1
wakeonlan $(db-register "select id from mac where host == '$1';")
