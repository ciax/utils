#!/bin/bash
# Required scripts: func.ssl ssl-request
## SSL files (Server vs CA vs Client)
##@ Server Site (Site as a server)
##  csr(Signning Request file) -> Submit to CA
##@ CA (Certificate Authority) = Site of Issuing Certificate (Derived)
## csr -> (Convert with ca.key) -> crt(Certificate) -> Send back to Server
. func.ssl
. func.getpar
# Options
opt-s(){ role+="nsCertType=server\n"; } #server
opt-c(){ role+="nsCertType=client\n"; } #client
opt-a(){ role+="basicConstraints=CA:true\n"; } #ca
_usage "[site] ..."
_exe_opt
[ -s "$ca.key" ] || _abort "No ca key file"
[ -s "$ca.srl" ] || opt="-CAcreateserial"
if [ "$role" ] ; then
    _temp v3
    echo -e "$role" > "$v3"
    ext="-extfile $v3"
fi
for ss; do
    . ssl-request "$ss"
    openssl x509 -CA "$ca.crt" -CAkey "$ca.key" -req -days 3650 -in "$ss.csr" -out "$ss.crt" $opt $ext
done
