#!/usr/bin/env bash

# ... if curl requires proxy
# export https_proxy=http://proxy:8090

printf "\n\n Activity Workflow API repair script, read the code before you run!...\n"

printf "\nEnter the ENV you wish to query (pre, stg, PRD): "
read env
printf "\nEnter the auth token for the Activiti API: "
read token
case $env in
  "pre") authHeader="authorization: Basic $token";;
  "stg") authHeader="authorization: Basic $token";;
  "PRD") authHeader="authorization: Basic $token";;
  * ) echo "ENV not recognised, entry is case sensitive!"
      exit;;

printf "\nEnter the back off time between API calls (accepts floating point as well as int): "
read backoffTime

printf "\nEnter Ids from file? Y/n: "
read fromFile

if [ $fromFile == "Y" ]
then
  printf "\nEnter the file path to read Ids from: "
  read filePath
  Ids=$(cat $filePath)
  # echo $Ids
else
  printf "\nEnter the process ids (comma seperated) for the processes you wish to process: "
  read Ids
fi

printf "\n"

counter=0
for id in $(echo $Ids | sed "s/,/ /g")
do
  ((counter++))

  # Execute an process id in workflow
  request=$(curl -H "$authHeader" -sS https://activity.$env.com/runtime/executions/$id)
  success=$(echo $request | jq '. | .activityId')
  error=$(echo $request | jq '. | .message')
  printf "\nAppId: $id, activityId: $success, error: $error"

  sleep $backoffTime

done

printf "\n\n $counter records processed. \n EXITING... \n"
