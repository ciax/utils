#!/bin/bash
# Original script to get content using Firefox cookies. by Jean-Sebastien Morisset (http://surniaulula.com/)
id=$1
urlfile=~/cfg.*/etc/cookie_location.$1.txt
agentfile=~/cfg.*/etc/user_agent.$1.txt
sqlfile=~/.var/cookie.$id.sq3
cookie=~/.var/cookie.$id.txt
[ -s $urlfile ] || {
    echo "Usage: dl-cookie [user]" 1>&2
    for i in ~/cfg.*/etc/cookie_location.*.txt;do
        i=${i#*location.}
        echo "    ${i%.*}" 1>&2
    done
    exit
}
scp "$(< $urlfile)" $sqlfile
sqlite3 $sqlfile <<EOF > $cookie
.mode tabs
select host, case when host glob '.*' then 'TRUE' else 'FALSE' end,
path, case when isSecure then 'TRUE' else 'FALSE' end, 
expiry, name, value from moz_cookies;
EOF
[ -s $cookie ] && ln -sf $cookie ~/.var/cookie.txt
[ -s $agentfile ] && ln -sf $agentfile ~/.var/user_agent.txt
