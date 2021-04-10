#!/bin/bash
# Required packages: jq
getjob(){
    [ -e $jobjson ] || { echo "No job-id file($jobjson)"; exit; }
    job="--job-id $(jq .jobId $jobjson)"
}
showres(){
    [ -e $resjson ] || { echo "No response file"; exit; }
    set - $(jq '.StatusCode, .CreationDate' $resjson)
    echo "Status:$1"
    echo "Elapsed:$2"
}
. aws-opt
opt="--vault-name $VAULT --account-id $ACCOUNT"
jobjson="job_id.json"
resjson="response.json"
outjson="output.json"
arclist=".archive_list.txt"
dellist=".delete_list.txt"
dellog=".deleted.txt"
remlog=".remained.txt"
tmp=".temp.txt"
