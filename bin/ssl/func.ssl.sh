#!/bin/bash
# Required packages: openssl
# Required scripts: func.getpar
# Description: SSL library
. func.getpar
vardir=~/.var/ssl
mkdir -p $vardir
ca='rootca'
site=$1
[ -s "$site.csr" ] || cd $vardir
