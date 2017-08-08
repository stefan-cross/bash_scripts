#!/usr/bin/env bash

# Font formatting
bold=$(tput bold)
normal=$(tput sgr0)

clear
printf "THIS SCRIPT WILL ATTEMPT TO UPDATE YOUR CODE REPOS... \n"
printf "Please enter the absolute path of your main code/project folder \n"
printf "e.g ~/code/ or /home/this_user/projects/ \n"
read mainRepoFolder

cd $mainRepoFolder
echo "Updating Project repos in $mainRepoFolder..."

files=($(ls -d */))
FAILEDUPDATES=()

for f in "${files[@]}"
do
  printf "Updating ${bold} $f ${normal} ... \n"
  cd $f
    git pull
    if [ $? -eq 0 ]; then
        echo ${bold} $f - OK ${normal}
    else
        FAILEDUPDATES+=($f)
        echo ${bold} $f - FAILED ${normal}
    fi
  cd ..
done

printf "\n \n \n The following directories encountered issues when updating the repo: \n"
echo ${bold}
declare -p FAILEDUPDATES;
echo ${normal}
printf "It is likely that these have uncommited changes that need your attention."
