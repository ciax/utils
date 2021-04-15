#!/bin/bash
# Required packages: jq
. aws-conf
[ "$1" ] || usage '[archive-id]'
getjob(){
    [ -e $jobjson ] || { echo "No job-id file($jobjson)"; exit; }
    job="--job-id $(jq .jobId $jobjson)"
}
case "$1" in
    -r)#retrival
	      cmd="initiate-job $opt --job-parameters "
	      cmd+="'{\"Type\":\"inventory-retrieval\"}'"
    ;;
    -q)#query job
        getjob
	      cmd="describe-job $opt $job"
    ;;
    -g)#get data
        getjob
	      cmd="get-job-output $opt $job output.json"
    ;;
    -d)#delete archive [archive-id]
        arc=${2-$(head -1 $dellist)}
	      cmd="delete-archive $opt --archive-id \" $arc\""
    ;;
esac
echo "aws glacier $cmd"
