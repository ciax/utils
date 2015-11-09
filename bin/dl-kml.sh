#!/bin/bash
# Required packages: sqlite3 curl
# Required scripts: info-date conv-cookie
# Get KML by Firefox (Need firefox)
# Darwin is Mac OS-X
#alias kml
[ "$1" ]||{ echo "Usage: dl-kml [tag] ((month/)day|-day)"; exit; }
tag=$1;shift
eval "$(info-date ${1:-0})"
# Make URL and DL file name
#site="https://maps.google.com/locationhistory/b/0/kml"
#url="$site?startTime=${sec}000&endTime=$(( sec + 86400 ))000" # 1day=86400sec
site="https://www.google.com/maps/timeline/kml"
opt="authuser=0&pb=!1m8!1m3${gdate}!2m3$gdate"
url="$site?$opt"
dir=${STORE:-~/.var}
[ -d $dir/location ] || mkdir $dir/location
outfile=$dir/location/history-$tag-$date.kml
# Check cookie
cookie=~/.var/cookie.$tag.txt
[ -s $cookie ] || { echo "No cookie file" 1>&2; exit; }
user_agent=~/.var/user_agent.txt
for file in ~/cfg.*/etc/user_agent.$tag.txt; do
    if [ -s $file ]; then
        ln -sf $file $user_agent
        break
    fi
done
# Check user_agent
[ -s $user_agent ]|| { echo "No user agent file" 1>&2; exit; }
# Get file
echo "Getting: $url"
curl -b $cookie -A "$(<$user_agent)" -o $outfile $url
if [ -e $outfile ] ; then
    echo "Downloaded $outfile"
else
    dl-cookie $tag
    curl -b $cookie -A "$(<$user_agent)" -o $outfile $url
fi

