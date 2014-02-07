#Required packages: coreutils,bash,sudo,perl,findutils(find),perl
# command usage by prefix
set.*.sh: use by source (i.e. source 'command')

#To make new repository
git --bare init
#To clone empty repository
git clone (dir)
#To push to bare repository at first time
git push origin master
