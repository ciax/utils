#!/bin/bash
#alias wol
# Required commands: wakeonlan
# Required scripts: func.getpar, db-exec
# Required tables: mac(host)
# Description: make network devices wake up
. func.getpar
_usage "[host]" <(db-exec "select host from mac where host in (select id from host where hub in (select id from subnet where network == '$(info-subnet)'));")
wakeonlan $(db-exec "select id from mac where host == '$1';")
