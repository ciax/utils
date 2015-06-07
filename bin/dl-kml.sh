#!/bin/bash
# Original script to get content using Firefox cookies. by Jean-Sebastien Morisset (http://surniaulula.com/)
# Required packages: sqlite3 curl
# Get KML by Firefox (Need firefox)
# Darwin is Mac OS-X
#alias kml
conv_duration(){ # print 20XX-XX-XX startsec endsec
    local dur=$1
    local day=${2:-$(date +%d)}
    local mon=${3:-$(date +%m)}
    case $os in
        Linux) startday="-d $mon/$day";;
        Darwin) startday="-j $(printf %02d%02d0000 $mon $day)";;
    esac
    local start=$(date $startday +%s)
    local end=$(( start + 86400*dur )) #One Day is 86400sec
    local day=$(date $startday +%F) # 20XX-XX-XX
    echo "${day}_$dur $start $end"

}
[ "$1" ]||{ echo "Usage: dl-kml [days] [day] [month]"; exit; }
# Make URL and DL file name
site="https://maps.google.com/locationhistory/b/0/kml"
set - $(conv_duration $*)
outfile=~/.var/history-$1.kml
# Convert cookie
cookie=~/.var/cookie.txt
[ -s $cookie ] || { echo "No cookie file" 1>&2; exit; }
# Convert user agent
user_agent=~/.var/user_agent.txt
[ -s $user_agent ]|| { echo "No user agent file" 1>&2; exit; }
# Get file
url="$site?startTime=${2}000&endTime=${3}000"
cat <<EOF
curl -b $cookie -A "$(<$user_agent)" -o $outfile $url
EOF
