#!/bin/bash
# Required packages: wakeonlan
#alias wol
. func.usage "[host]" $1
wakeonlan $(db-register "select id from mac where host == '$1';")
