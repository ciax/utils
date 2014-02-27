#!/bin/bash
# Required packages: wakeonlan
#alias wol
[ "$1" ] || . set.usage "[host]"
wakeonlan $(db-register <<< "select id from mac where host == '$1';")
