#!/usr/bin/env bash
port=${1:-51820}
host=${2:-localhost}
socat -v PIPE udp-recvfrom:$port,fork &
nc -u $host $port
fg
