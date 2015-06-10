#!/bin/bash
# Original script to get content using Firefox cookies. by Jean-Sebastien Morisset (http://surniaulula.com/)
id=$1
urlfile=~/cfg.*/etc/cookie_location.$1.txt
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
conv-cookie $sqlfile > $cookie
