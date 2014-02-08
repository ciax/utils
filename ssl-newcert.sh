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
    echo
    title "Show $req.key"
    openssl rsa -text < $req.key
    echo;echo;echo
    title "Create Certificate Request (csr)"
    title "(Need Site Information Input)"
    openssl req -new -key $req.key > $req.csr
    echo;echo;echo
    title "Show $req.csr"
    openssl req -text < $req.csr
    echo;echo;echo
    title "Send Certificate Reqest (csr) to CA"
    openssl x509 -days 9999 -req -signkey $ca.key < $req.csr > $req.crt
    echo
    title "Get CertiCreate file (crt)"
}
cd ~/.var
key2csr `hostname`
