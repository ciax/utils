############## Description #############
Here is the bash scripts.

Features:
 - All scripts are put into '~/bin' together as symbolic links. 
 - All variable or temporaly data are put into '~/.var'.
 - All configurations are in RDB (using sqlite3).

Scope: Linux (Debian,Ubuntu,CentOS are tested)

Copyright (c) 2014 Koji Omata (MIT License)

############## Setup ##############
### Required System Setup
 1. Install sudo
 2. /etc/sudoers
   %sudo ALL=(ALL:ALL) NOPASSWD:ALL
 3. /etc/group
   add username to sudo group
 4. Install ssh,git
 
### Setup at Home Dir
git clone ssh://ciax@ciax.sum.naoj.org/export/scr/repos-pub/cfg.pub
~/cfg.pub/setup

############# Local Rules ###############

### Command usage
 func.app.sh: should be source for loading functions;

### Relevant Dirs
  App Dirs    :  ~/utils
  Config Dirs :  ~/cfg.*  <------- Project name
  Work Dirs   :  ~/bin ~/db ~/.var ~/.trash

### Comment in scripts
 # Required packages: *   <------- Package list that wants to be installed
 # Required scripts: *    <------- Script list for dependency check
 #alias *                 <------- Alias name that itself wants to be
 #link  *                 <------- Symbolic link name that itself wants to be
 #link:distribution *     <------- Link if distribution is matched

############### General information ################

### rcfile priority (bash executes just one of them)
 Invoked bash as a Login shell
  .bash_profile || .bash_login || .profile (calls .bashrc)
 Invoked bash as others 
  .bashrc (calls .bash_complete)

### Git Tips
#To make new repository
git --bare init
#To clone empty repository
git clone (dir)
#To push to bare repository at first time
git push origin master
