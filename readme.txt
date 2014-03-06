#Required packages: coreutils,bash,sudo,perl,findutils(find),perl
# command usage by prefix
func.*.sh: should be source for loading functions;

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

### Relevant Dirs
# App Dirs
~/utils(.*)

# Config Dirs
 ~/cfg.*

# Work Dirs
~/bin ~/db ~/.var ~/.trash

### Required Package
 Should be put in comment line as "# Required Package: app1,app2,app3(cmd)..."

### Alias
 Should be put in comment line as "#alias str"
