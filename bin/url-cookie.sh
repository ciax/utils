#!/bin/bash
# Required packages(Debian,Raspbian,Ubuntu): sqlite3 curl
# Required scripts: conv-cookie
# Get CURL Conf by Firefox (Need firefox)
# Darwin is Mac OS-X
# pipe to "curl -K-"
[ "$1" ]||{ echo "Usage: url-cookie [tag]"; exit; }
tag=$1;shift
# Check cookie
cookie=~/.var/cache/cookie.$tag.txt
[ -s $cookie ] || { echo "No cookie file" 1>&2; exit; }
user_agent=~/.var/cache/user_agent.txt
for file in ~/cfg.*/etc/user_agent.$tag.txt; do
    if [ -s $file ]; then
        ln -sf $file $user_agent
        break
    fi
done
# Check user_agent
[ -s $user_agent ]|| { echo "No user agent file" 1>&2; exit; }
# Get file
echo "user-agent=\"$(<$user_agent)\""
echo "cookie=\"$cookie\""
