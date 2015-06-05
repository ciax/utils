#!/bin/bash
id=$1
urlfile=~/cfg.*/etc/cookie.$1.url
sqlfile=~/.var/cookie.$id.sq3
cookie=~/.var/cookie.$id.txt
[ -s $urlfile ] || {
    echo "Usage: dl-cookie [user]" 1>&2
    for i in ~/cfg.*/etc/cookie.*.url;do
        i=${i#*cookie.}
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
ln -sf $cookie ~/.var/cookie.txt
