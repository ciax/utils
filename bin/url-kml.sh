#!/bin/bash
# Required scripts: info-date
# Make URL of Geting KML
[ "$1" ]||{ echo "Usage: cfg-kml ((month/)day|-day)"; exit; }
eval "$(info-date ${1:-0})"
# Make URL and DL file name
#site="https://maps.google.com/locationhistory/b/0/kml"
#url="$site?startTime=${sec}000&endTime=$(( sec + 86400 ))000" # 1day=86400sec
site="https://www.google.com/maps/timeline/kml"
opt="authuser=0&pb=!1m8!1m3${gdate}!2m3$gdate"
echo "url=\"$site?$opt\""
echo "output=\"history-$date.kml\""
