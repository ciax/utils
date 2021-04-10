#!/bin/bash
# Required packages: jq
. aws-opt
[ "$1" ] || { echo "Usage:aws-mkcmd (-rqgd)"; exit; }
opt="--vault-name $VAULT --account-id $ACCOUNT"
case "$1" in
    #retrival
    -r)
	cmd="initiate-job $opt --job-parameters '"
	cmd+='{"Type":"inventory-retrieval"}'
	cmd+="'"
    ;;
    #query job
    -q)
	cmd="describe-job $opt $job"
    ;;
    #get data
    -g)
	cmd="get-job-output $opt $job output.json"
    ;;
    #delete archive
    -d)
	arc="--archive-id $id"
	cmd="delete-archive $opt $arc"
    ;;
esac
echo "aws glacier $cmd"
