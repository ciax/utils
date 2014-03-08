#!/bin/bash
# Required packages: wakeonlan
# Required scripts: func.usage, db-register
# Required tables: mac(host)
#alias wol
. func.usage "[host]" $1
wakeonlan $(db-register "select id from mac where host == '$1';")
