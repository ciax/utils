#!/bin/sh
# Original script to get content using Firefox cookies. by Jean-Sebastien Morisset (http://surniaulula.com/)
# Required packages: sqlite3 wget
# Get KML by Firefox
# Usage: dl-kml [date] [days]
#alias kml
startday=${1:-$(date +%D)}
days=${2-1}
startsec=$(date -d$startday +%s)
endsec=$(( startsec + 86400*days )) #One Day is 86400sec
url="https://maps.google.com/locationhistory/b/0/kml?startTime=${startsec}000&endTime=${endsec}000"
[ -d ~/.var ] || mkdir ~/.var
cookie=~/.var/cookie.txt
outfile="history-$(date +%F)_$days.kml"
case $(uname) in
    Linux)
        cookie_dir="$HOME/.mozilla/firefox"
        user_agent="Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Firefox/31.0"
        ;;
    Darwin) # Mac OSX
        cookie_dir="$HOME/Library/Application\ Support/Firefox/Profiles"
        user_agent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:15.0) Gecko/20100101 Firefox/15.0.1"
        ;;
    *)
        exit;;
esac
cookie_file="`echo $cookie_dir/*.default/cookies.sqlite`"
sqlite3 "$cookie_file" <<EOF > $cookie
.mode tabs
select host, case when host glob '.*' then 'TRUE' else 'FALSE' end,
path, case when isSecure then 'TRUE' else 'FALSE' end, 
expiry, name, value from moz_cookies;
EOF
wget --load-cookies=$cookie --user-agent="$user_agent" --output-document=$outfile $url
