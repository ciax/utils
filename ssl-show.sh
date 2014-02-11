#!/bin/bash
[ "$1" ] || . set.usage "[site]"
cd ~/.var
openssl x509 -text -in $1.crt
