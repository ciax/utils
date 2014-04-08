#!/bin/bash
#alias wol
# Required commands: wakeonlan
# Required scripts: func.getpar, db-exec
# Required tables: mac(host)
# Description: make network devices wake up
. func.getpar
_usage "[host]" <(db-list host)
wakeonlan <(db-exec "select id from mac where host == '$1';")
