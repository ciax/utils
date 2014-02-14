#!/bin/bash
## SSL files (Server vs CA vs Client)
##@ Server Site
##  csr(Signning Request file) -> Submit to CA
##@ CA
## csr -> (Convert with ca.key) -> crt(Certificate) -> Send back to Server
cd ~/.var
case "$1" in
    '') . set.usage "(-s:server,-c:client) [ca] [site] ..."
        ;;
    -s) shift;role=server;;
    -c) shift;role=client;;
    *);;
esac
ca=$1;shift
[ -s "$ca.key" ] || { echo "No ca key file"; exit; }
[ -s $ca.srl ] || opt="-CAcreateserial"
if [ "$role" ]; then
    echo "nsCertType=$role" > v3.ext
    ext="-extfile v3.ext"
fi
for ss; do
    . ssl-mkcsr "$ss"
    openssl x509 -CA $ca.crt -CAkey $ca.key -req -in $ss.csr -out $ss.crt $opt $ext
done
