#!/bin/bash
# Required packages: jq
[ "$1" ] || { echo "Usage:aws-mkcmd (-rqg) (-d [archive-id])"; exit; }
. aws-conf
getjob(){
    [ -e $jobjson ] || { echo "No job-id file($jobjson)"; exit; }
    job="--job-id $(jq .jobId $jobjson)"
}
case "$1" in
    #retrival
    -r)
	      cmd="initiate-job $opt --job-parameters "
	      cmd+="'{\"Type\":\"inventory-retrieval\"}'"
    ;;
    #query job
    -q)
        getjob
	      cmd="describe-job $opt $job"
    ;;
    #get data
    -g)
        getjob
	      cmd="get-job-output $opt $job output.json"
    ;;
    #delete archive
    -d)
        arc=${2-$(head -1 $dellist)}
	      cmd="delete-archive $opt --archive-id \" $arc\""
    ;;
esac
echo "aws glacier $cmd"
