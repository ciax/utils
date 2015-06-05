#!/bin/sh
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
    echo "${day}_$dul $start $end"

}
[ "$1" ]||{ echo "Usage: dl-kml [days] [day] [month]"; exit; }
os=$(uname)
case $os in
    Linux) user_agent="Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Firefox/31.0";;
    Darwin) user_agent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:15.0) Gecko/20100101 Firefox/15.0.1";;
    *) echo "No OS" 1>&2; exit;;
esac
# Make URL and DL file name
site="https://maps.google.com/locationhistory/b/0/kml"
set - $(conv_duration $*)
outfile=~/.var/history-$1.kml
url="$site?startTime=${2}000&endTime=${3}000"
echo $url
# Convert cookie
cookie=~/.var/cookie.txt
[ -s $cookie ] || { echo "No cookie file" 1>&2; exit; }
# Get file
curl -b $cookie -A "$user_agent" -o $outfile $url
