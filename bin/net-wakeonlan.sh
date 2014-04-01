#!/bin/bash
#alias wol
# Required packages: wakeonlan
# Required scripts: src.app, db-exec
# Required tables: mac(host)
# Description: make network devices wake up
. src.app
_usage "[host]"
wakeonlan $(db-exec "select id from mac where host == '$1';")
