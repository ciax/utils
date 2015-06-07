#!/bin/bash
# Original script to get content using Firefox cookies. by Jean-Sebastien Morisset (http://surniaulula.com/)
# Required packages: sqlite3 curl
# Required scripts: info-date2sec
# Get KML by Firefox (Need firefox)
# Darwin is Mac OS-X
#alias kml
[ "$1" ]||{ echo "Usage: dl-kml [(month/)day|-]"; exit; }
eval "$(info-date2sec $*)"
# Make URL and DL file name
site="https://maps.google.com/locationhistory/b/0/kml"
url="$site?startTime=${start}000&endTime=${end}000"
outfile=~/.var/history-$date.kml
# Convert cookie
cookie=~/.var/cookie.txt
[ -s $cookie ] || { echo "No cookie file" 1>&2; exit; }
# Convert user agent
user_agent=~/.var/user_agent.txt
[ -s $user_agent ]|| { echo "No user agent file" 1>&2; exit; }
# Get file
curl -b $cookie -A "$(<$user_agent)" -o $outfile $url

