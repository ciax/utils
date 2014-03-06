#!/bin/bash
. func.usage "[site]" $1
cd ~/.var
openssl x509 -text -noout -in $1.crt
