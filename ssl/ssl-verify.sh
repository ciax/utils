#!/bin/bash
## Vefiry the relationship
[ "$1" ] || . set.usage "[ca name] [site name]"
cd ~/.var
cacrt="$1.crt";shift
[ -s "$cacrt" ] || { echo "No ca crt file"; exit; }
site="$1.crt";shift
[ -s "$site" ] || { echo "No site crt file"; exit; }
openssl verify -CAfile $cacrt $site

