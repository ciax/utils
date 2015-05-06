#!/bin/bash
# Required scripts: func.getpar db-exec
# Required tables: subnet(network,netmask,vpn)
# Description: Generate routing commands
. func.getpar
mode="add"
opt-r(){ mode="del"; } #remove
_usage "[vpnhost]" <(db-list vpn)
_exe_opt
db-exec <<EOF
select
 'route $mode -net '
 ||network
 ||'.0 netmask '
 ||netmask
from
 subnet
where
 route == (
  select route
  from vpn
  where id == '$1'
 )
;
EOF
