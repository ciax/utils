#!/bin/bash
#alias wol
# Required packages(Debian,Raspbian,Ubuntu): wakeonlan
# Required scripts: func.getpar search-mac
# Description: make network devices wake up
. func.getpar
_usage "[host]" <(list-hosts)
wakeonlan $(search-mac $1)
