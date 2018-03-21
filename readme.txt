############## Description #############
Here is the utilities of bash script.

Features:
 - All scripts are put into '~/bin' as symbolic links. 
 - All variable or temporaly data are put into '~/.var'.
 - All configurations are stored in RDB (using sqlite3).

Scope: Linux (Debian,Ubuntu and CentOS are tested)

Copyright (c) 2014 Koji Omata (MIT License)

############## Setup ##############
### Required System Setup
 1. Install sudo
 2. /etc/sudoers
   %sudo ALL=(ALL:ALL) NOPASSWD:ALL
 3. /etc/group
   add username to sudo group
 4. Install ssh,git,coreutils
 
### Setup at Home Dir
> git clone https://git.hub/ciax/cfg.(proj).git
> source ~/cfg.(proj)/setup-cfg-(proj).sh  <--- automatically retrieves dependent apps
> pkg-(apt|yum) init
> db-update -f

############# Local Rules ###############

### Command usage
  func.*: should be sourced for loading functions
  function names defined in func.* should have '_' prefix
  function will be executed if func.* is linked to the function name.
  function will be executed if the first arg of func.* is the function name.
  Public function: function names followed by their comments in the same line.
    It will be listed when func.* is invoked
    It will be appeared in ~/bin as the link of their original func.* file.

### Relevant Dirs
  App Dirs    :  ~/utils
  Config Dirs :  ~/cfg.*  <------- Project name
  Work Dirs   :  ~/bin ~/.var ~/.trash

### Comment in script files
 # Required packages: *   <--- Package list that is required in the script file
 # Required packages(DIST,..): * <--- Package list limited by distributions
 # Required scripts: *    <------- Script file list for dependency check
 #alias *                 <------- Alias name for the script file
 #link  *                 <------- Symbolic link name for the script file
 #link(DIST,..) *         <------- Link if distribution matches
 #link(HOST,..) *         <------- Link if hostname matches

### Comment in generated text
 #file /*/*/filename         <--- file name for generated text

############### General information ################

### rcfile priority (bash executes just one of them)
 Invoked bash as a Login shell
  .bash_profile || .bash_login || .profile (calls .bashrc)
 Invoked bash as others 
  .bashrc

### Git Tips
 To make new repository
   git --bare init
 To clone empty repository
   git clone (dir)
 To push to bare repository at first time
   git push origin master
