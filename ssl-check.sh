#!/bin/bash
## SSL files (Server vs CA vs Client)
[ "$1" ] || . set.usage "[site]"
cd ~/.var
site="$1"
echo -n "KEY:"
openssl rsa -in "$site.key" -modulus -noout| openssl md5
echo -n "CSR:"
openssl req -in "$site.csr" -modulus -noout| openssl md5
echo -n "CRT:"
openssl x509 -in "$site.crt" -modulus -noout |openssl md5
