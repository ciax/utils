#!/bin/bash
## SSL files (Server vs CA vs Client)
##@ Server
##  private.key(+pub.key) -> csr(Signning Request file)
input=
site=$1
. ssl-newkey $site
for i in $(db-register -s "select * from ssl where id = '$site';"); do
    if [ "$1" = "$site" ]; then
        set C= ST= L= O= OU= CN= emailAddress=
    else
        input="$input/$1$i"
        shift
    fi
done
echo $input
exit
openssl req -new -key $site.key ${input:+-subj "$input"} > $site.csr
[ -s "$site.csr" ] || { rm "$site.csr";echo "Generate CSR failed"; }
