#!/bin/bash
# Required scripts: func.getpar db-exec
# Description: lantronix configulator
# use nc for input to lantronix (i.e. ltcfg id | nc host 23)
. func.getpar
_usage "[id] (range)" <(db-exec "select distinct host from lantronix;")
IFS='|'
echo "s";echo "su";echo "system"
while read port protocol; do
    for i in $2; do
        [ "${i%-*}" -le "$port" -a "${i#*-}" -ge "$port" ] && break
    done || continue
    tcpp=$(( 4000 + $port))
    eval "$(db-trace $protocol protocol)"
    echo "define port $port speed $speed"
    echo "define port $port character $character"
    echo "define port $port parity $parity"
    echo "define port $port stop $stop"
    echo "define port $port flow $flow"
    echo "define service rs_$port tcpport $tcpp"
    echo "define service rs_$port binary en"
    echo "define service rs_$port port $port en"
    echo "define port $port dedicated service rs_$port"
done < <(db-exec "select port,protocol from lantronix where host == '$1';")
echo "initialize server delay 0"