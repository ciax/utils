#!/bin/bash
#alias wol
# Required packages(Debian): wakeonlan
# Required packages(Ubuntu): wakeonlan
# Required scripts: func.getpar db-exec
# Required tables: mac(host)
# Description: make network devices wake up
. func.getpar
_usage "[host]" <(net-hosts)
wakeonlan $(db-exec "select id from mac where host == '$1';")
