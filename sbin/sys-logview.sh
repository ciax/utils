#!/bin/bash
#alias syslog
# Description: show syslog file
#  Usage: sys-logview (-h|-f| serch word)

. func.sudo
xopt-h(){ #http error log
    _sudy tail /var/log/httpd/error_log
}
xopt-f(){ #coutinuous update
    _sudy tail -f /var/log/syslog
}
_usage "[search word]"
_sudy grep "$1" /var/log/syslog

