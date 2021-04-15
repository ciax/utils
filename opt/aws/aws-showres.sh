#!/bin/bash
#alias showres
. aws-conf
[ -e $resjson ] || { echo "No response file"; exit; }
set - $(jq -r '.StatusCode, .CreationDate, .CompletionDate' $resjson)
echo "Status : $1"
echo -n "Elapsed : "
[ "$3" = null ] || last="-d $3"
elap $(( $(date $last +%s) - $(date -d "$2" +%s)  ))
