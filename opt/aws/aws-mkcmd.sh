#!/bin/bash
# Required packages: jq
getjob(){
    [ -e $jobfile ] || { echo "No jobfile"; exit; }
    job="--job-id $(jq .jobId $jobfile)"
}
getres(){
    [ -e $response ] || { echo "No response file"; exit; }
    set - $(jq '.StatusCode, .CreationDate' $response)
    echo $1
    echo $2
}

. aws-opt
[ "$1" ] || { echo "Usage:aws-mkcmd (-rqg) (-d [archive-id])"; exit; }
opt="--vault-name $VAULT --account-id $ACCOUNT"
jobfile="job_id.json"
response="response.json"
case "$1" in
    #retrival
    -r)
	      cmd="initiate-job $opt --job-parameters '"
	      cmd+='{"Type":"inventory-retrieval"}'
	      cmd+="' > $jobfile"
    ;;
    #query job
    -q)
        getjob
	      cmd="describe-job $opt $job > $response"
    ;;
    #get data
    -g)
        getjob
	      cmd="get-job-output $opt $job output.json"
    ;;
    #delete archive
    -d)
	      arc="--archive-id $2"
	      cmd="delete-archive $opt $arc"
    ;;
esac
echo "aws glacier $cmd"
