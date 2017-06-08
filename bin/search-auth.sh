#!/bin/bash
#alias auth
# Required packages: expect
# Required scripts: func.auth
# Description: Get auth info
. func.getpar
. func.auth
_usage "[id]" $(db-list auth)
_auth $1
echo $password
