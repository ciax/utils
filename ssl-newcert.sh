#!/bin/bash
## SSL files (Server vs CA vs Client)
##@ Server
##  private.key(+pub.key) -> csr(Signning Request file) -> Submit to CA
##@ CA
## csr -> (Convert with ca.key) -> crt(Certificate) -> Send back to Server
##@ Server
## set crt file to web server
##@ Client
## set crt of ca into web browser
. set.color
title(){
    echo "============ $C1 $1 $C0============="
}
key2csr(){
    req=$1
    ca=${2:-$req}
    title "Create Server Private Key"
    [ -e $req.key ] || openssl genrsa 2048 > $req.key
    if [ "$ver" ] ; then
        echo
        title "Show $req.key"
        openssl rsa -text < $req.key
        echo;echo;echo
    fi
    title "Create Certificate Request $C3(Need Site Information Input)"
    openssl req -new -key $req.key > $req.csr
    if [ "$ver" ] ; then
        echo
        title "Show $req.csr"
        openssl req -text < $req.csr
        echo;echo;echo
    fi
    title "Send Certificate Reqest (csr) to CA"
    openssl x509 -days 9999 -req -signkey $ca.key < $req.csr > $req.crt
    title "Get CertiCreate file (crt)"
}
[ "$1" = "-v" ] && { shift; ver=1; }
[ "$1" ] || . set.usage "[child] (parent)"
cd ~/.var
key2csr $*
