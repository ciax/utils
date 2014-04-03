#!/bin/bash
# Required commands: openssl
# Required scripts: func.app
# Description: Vefiry the relationship
. func.app
_usage "[ca name] [site name]"
cd ~/.var
cacrt="$1.crt";shift
[ -s "$cacrt" ] || _abort "No ca crt file"
site="$1.crt";shift
[ -s "$site" ] || _abort "No site crt file"
openssl verify -CAfile $cacrt $site

