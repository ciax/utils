#!/bin/bash
# Required packages: jq
[ "$1" ] || { echo "Usage:aws-mkcmd (-rqg) (-d [archive-id])"; exit; }
. aws-conf
case "$1" in
    #retrival
    -r)
	      cmd="initiate-job $opt --job-parameters '"
	      cmd+='{"Type":"inventory-retrieval"}'
	      cmd+="'"
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
	      arc="--archive-id \"$2\""
	      cmd="delete-archive $opt $arc"
    ;;
esac
echo "aws glacier $cmd"
