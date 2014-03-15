#!/bin/bash
#alias wol
# Required packages: wakeonlan
# Required scripts: rc.app, db-register
# Required tables: mac(host)
# Description: make network devices wake up
. rc.app
_usage "[host]" $1
wakeonlan $(db-register "select id from mac where host == '$1';")
