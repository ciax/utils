#Required packages: coreutils,bash,sudo,perl,findutils(find),perl
# command usage by prefix
set.*.sh: use by source (i.e. source 'command')

### Git Tips
#To make new repository
git --bare init
#To clone empty repository
git clone (dir)
#To push to bare repository at first time
git push origin master

### Setup
cd
git clone ssh://ciax@ciax.sum.naoj.org/export/scr/repos-pub/utils
~/utils/setup.sh

### App Dirs
~/utils(.*) ~/cfg.*

### Work Dirs
~/bin ~/db ~/.var

