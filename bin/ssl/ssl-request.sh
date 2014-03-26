#!/bin/bash
## SSL files (Server vs CA vs Client)
##@ Server
##  private.key(+pub.key) -> csr(Signning Request file)
site=$1
. ssl-newkey $site
. db-setfield $site ssl
input="/C=${country:-US}/ST=${state:-HI}/L=${city:-HILO}/O=${company:-NAOJ}"
input="$input/OU=${section:-STN}/CN=${fdqn:-$site}"
input="$input/emailAddress=${email:-$site}"
openssl req -new -key $site.key -subj "$input" > $site.csr
if [ -s "$site.csr" ] ;then
    echo "CSR is generated"
else
    rm "$site.csr"
    echo "Generate CSR failed"
    exit 1
fi

