#!/bin/bash
## SSL files (Server vs CA vs Client)
##@ Server
##  private.key(+pub.key) -> csr(Signning Request file)
[ "$1" ] || . set.usage "[site name]"
cd ~/.var
site="$1"
IFS=','
set - $(echo "select * from ssl where id = '$site';"|db-device)
shift
[ "$1" ] || { echo "No such site"; exit; }
if [ -e "$site.key" ] ;then
    echo "[[$site.key exists]]"
else
    openssl genrsa 2048 > $site.key
fi
for i;do echo $i;done|openssl req -new -key $site.key > $site.csr
echo
