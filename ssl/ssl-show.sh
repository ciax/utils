#!/bin/bash
[ "$1" ] || . set.usage "[site]"
cd ~/.var
openssl x509 -text -noout -in $1.crt
