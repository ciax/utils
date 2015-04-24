#!/bin/bash
# You need to join video group
if [ -d ~/mmal ] ; do
    mkdir ~/mmal
    cd ~/mmal
    sudo apt-get install motion libjpeg62
    wget https://www.dropbox.com/s/0gzxtkxhvwgfocs/motion-mmal.tar.gz
    tar xvzf motion-mmal.tar.gz
else
    cd ~/mmal
    ./motion-mmal -n -c motion-mmalcam.conf &
fi
