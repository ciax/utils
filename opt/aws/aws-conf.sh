#!/bin/bash
# Required packages: jq
elap(){
    set - $(date -ud @$1 +"%j %R:%S")
    [ $1 -gt 1 ] && echo -n "$(( $1 -1 ))day "
    echo $2
}
getjob(){
    [ -e $jobjson ] || { echo "No job-id file($jobjson)"; exit; }
    job="--job-id $(jq .jobId $jobjson)"
}
newlog(){
    cat $dellog >> $delarc
    : > $dellog
}
. ~/.aws/aws-opt.ini
opt="--account-id $ACCOUNT --vault-name $VAULT"
jobjson="job_id.json"
resjson="response.json"
outjson="output.json"
arclist=".archive_list.txt"
dellist=".delete_list.txt"
dellog=".deleted.txt"
delarc=".deleted_arc.txt"
remlog=".remained.txt"
tmp=".temp.txt"
cd ~/awstmp || exit
