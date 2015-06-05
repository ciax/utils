#!/bin/sh
# Original script to get content using Firefox cookies. by Jean-Sebastien Morisset (http://surniaulula.com/)
# Required packages: firefox sqlite3 curl
# Get KML by Firefox
# 
#alias kml
[ "$1" ]||{ echo "Usage: dl-kml [days] [day] [month]"; exit; }
dur=$1
day=${2:-$(date +%d)}
mon=${3:-$(date +%m)}
site="https://maps.google.com/locationhistory/b/0/kml"
case $(uname) in
    Linux)
        startday="-d $mon/$day"
        cookie_dir="$HOME/.mozilla/firefox"
        user_agent="Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Firefox/31.0"
        ;;
    Darwin) # Mac OSX
        startday="-j $(printf %02d%02d0000 $mon $day)"
        cookie_dir="$HOME/Library/Application\ Support/Firefox/Profiles"
        user_agent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:15.0) Gecko/20100101 Firefox/15.0.1"
        ;;
    *)
        exit;;
esac
# Make URL and DL file name
filedate="$(date $startday +%F)" # 20XX-XX-XX
startsec=$(date $startday +%s)
endsec=$(( startsec + 86400*dur )) #One Day is 86400sec
url="$site?startTime=${startsec}000&endTime=${endsec}000"
# Convert cookie
cookie_file="`echo $cookie_dir/*.default/cookies.sqlite`"
[ -s "$cookie_filie" ] || { echo "No cookie file"; exit 1; }
[ -d ~/.var ] || mkdir ~/.var
cookie=~/.var/cookie.txt
sqlite3 "$cookie_file" <<EOF > $cookie
.mode tabs
select host, case when host glob '.*' then 'TRUE' else 'FALSE' end,
path, case when isSecure then 'TRUE' else 'FALSE' end, 
expiry, name, value from moz_cookies;
EOF
# Get file
curl -b $cookie -A "$user_agent" -o $outfile $url
