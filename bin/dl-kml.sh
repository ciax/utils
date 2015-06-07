#!/bin/bash
# Original script to get content using Firefox cookies. by Jean-Sebastien Morisset (http://surniaulula.com/)
# Required packages: sqlite3 curl
# Get KML by Firefox (Need firefox)
# Darwin is Mac OS-X
#alias kml
conv_duration(){ # print 20XX-XX-XX startsec endsec
    local day=${1:-$(date +%d)}
    local mon=${2:-$(date +%m)}
    local dur=${3:-1}
    case $(uname) in
        Linux) startday="-d $mon/$day";;
        Darwin) startday="-j $(printf %02d%02d0000 $mon $day)";;
    esac
    local start=$(date $startday +%s)
    local end=$(( start + 86400*dur )) #One Day is 86400sec
    local day=$(date $startday +%F) # 20XX-XX-XX
    echo "$start $end ${day}_$dur"

}
[ "$1" ]||{ echo "Usage: dl-kml [day|-] (month) (days)"; exit; }
[ $1 = - ] && shift
# Make URL and DL file name
site="https://maps.google.com/locationhistory/b/0/kml"
set - $(conv_duration $*)
url="$site?startTime=${1}000&endTime=${2}000"
outfile=~/.var/history-$3.kml
# Convert cookie
cookie=~/.var/cookie.txt
[ -s $cookie ] || { echo "No cookie file" 1>&2; exit; }
# Convert user agent
user_agent=~/.var/user_agent.txt
[ -s $user_agent ]|| { echo "No user agent file" 1>&2; exit; }
# Get file
curl -b $cookie -A "$(<$user_agent)" -o $outfile $url
