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

############### Comment in scripts ################
 # Required packages: *   <------- Package list that wants to be installed
 # Required scripts: *    <------- Script list for dependency check
 #alias *                 <------- Alias name that itself wants to be
 #link  *                 <------- Symbolic link name that itself wants to be
