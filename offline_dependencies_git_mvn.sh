#!/usr/bin/env bash

# specify your base project folder
# locate all projects in main folder, list and prompt if specific folders to update to update all
# run a git pull recursively on each folder
# run a mvn clean install to ensure all dependencies
# display success of failures

# Font formatting
bold=$(tput bold)
normal=$(tput sgr0)

clear
printf "THIS SCRIPT WILL ATTEMPT TO GATHER ALL YOUR CODE DEPENDECIES... \n"
printf "Please enter the absolute path of your main code/project folder \n"
printf "e.g /home/this_user/projects/ \n"
read mainRepoFolder

cd $mainRepoFolder
printf "\n Updating Project repos in $mainRepoFolder..."

files=($(ls -d */))
pom="pom.xml"
failedupdates=()

checkForPomFile() {
  if [ -f "$pom" ]
  then
    printf "\n ${bold}  $pom found. ${normal}"
    mvn clean install -DskipTests | tail -n 14
  else
    printf "\n ${bold}  $pom NOT found. ${normal}"
  fi
}

for f in "${files[@]}"
do
  printf "\n Updating ${bold} $f ${normal} ... \n"
  cd $f
    git pull
    if [ $? -eq 0 ]; then
        echo ${bold} $f - GIT PULL OK ${normal}
        printf "\n Attempting to gather maven resrouces... \n"

        checkForPomFile
    else
        failedupdates+=($f)
        echo ${bold} $f - GIT PULL FAILED ${normal}
        printf "\n Attempting to gather maven resrouces... \n"

        checkForPomFile
    fi
  printf "\n\n\n${bold}***************************************** \n$f GIT repo & MVN targets finished \n***************************************** ${normal} \n \n \n"
  cd ..
done

printf "\n \n \n The following directories encountered issues when updating the repo: \n"
echo ${bold}
declare -p failedupdates;
echo ${normal}
printf "It is likely that these have uncommited changes that need your attention or pulling from an upstream location. \n \n"
