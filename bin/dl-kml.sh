#!/bin/bash
# Required packages(Debian,Raspbian,Ubuntu): sqlite3 curl
# Required scripts: info-date conv-cookie
# Get KML by Firefox (Need firefox)
# Darwin is Mac OS-X
#alias kml
dl_url(){
    curl -c $jar -b $gcookie -A "$(<$user_agent)" -o $tmpfile $url
    [ -s $tmpfile ] || { echo "Failed"; return; }
    if [ -s $outfile ]; then
        set - $( stat -c%s $tmpfile $outfile)
        [ $1 -gt $2 ] || { echo "No cange"; exit; }
    fi
    mv $tmpfile $outfile
    echo "Downloaded $outfile"
    exit
}
mk_cookie(){
    # Check cookie
    cookie=~/.var/cache/cookie.$tag.txt
    [ -s $cookie ] || dl-cookie $tag
    [ -s $cookie ] || { echo "No cookie file" 1>&2; exit; }
    gcookie=~/.var/cache/google.$tag.txt
    grep $'\t'/$'\t' $cookie|egrep '^.google.com' > $gcookie
    grep SID $gcookie > /dev/null 2>&1 || { echo "No SID in cookie file" 1>&2; exit; }
}
mk_uagent(){
    user_agent=~/.var/cache/user_agent.txt
    for file in ~/cfg.*/etc/user_agent.$tag.txt; do
        if [ -s $file ]; then
            ln -sf $file $user_agent
            break
        fi
    done
    # Check user_agent
    [ -s $user_agent ]|| { echo "No user agent file" 1>&2; exit; }
}
[ "$1" ]||{ echo "Usage: dl-kml [tag] ((month/)day|-day)"; exit; }
tag=$1;shift
eval "$(info-date ${1:-0})"
# Make URL and DL file name
#site="https://maps.google.com/locationhistory/b/0/kml"
#url="$site?startTime=${sec}000&endTime=$(( sec + 86400 ))000" # 1day=86400sec
site="https://www.google.com/maps/timeline/kml"
opt="authuser=0&pb=!1m8!1m3${gdate}!2m3$gdate"
url="$site?$opt"
dir=${STORE:-~/.var/cache}
mkdir -p $dir/location
outfile=$dir/location/history-$tag-$date.kml
tmpfile=~/.var/cache/temp-$date.kml
jar=~/.var/cache/cookie_jar.$tag.txt
mk_uagent
mk_cookie
# Get file
echo "Getting: $url"
dl_url
rm -f $cookie
mk_cookie
dl_url
