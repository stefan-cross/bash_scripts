#!/usr/bin/env bash

# ...if curl requires proxy
# export https_proxy=http://proxy:8090

printf "\n\n Activity Workflow API DELETION script, read the code before you run!...\n"

printf "\nEnter the ENV you wish to query (dev, stg, PRD): "
read env
printf "\nEnter the auth token for the Activiti API: "
read token
case $env in
  "dev") authHeader="authorization: Basic $token";;
  "stg") authHeader="authorization: Basic $token";;
  "PRD") authHeader="authorization: Basic $token";;
  * ) echo "ENV not recognised, entry is case sensitive!"
      exit;;
esac

printf "\nEnter the back off time between API calls (int as secs): "
read backoffTime

printf "\nEnter Ids from file? Y/n: "
read fromFile

if [ $fromFile == "Y" ]
then
  printf "\nEnter the file path to read Ids from: "
  read filePath
  ids=$(cat $filePath)
  # echo $ids
else
  printf "\nEnter the process ids (comma seperated) you wish to process: "
  read ids
fi

printf "\n"

counter=0
for id in $(echo $ids | sed "s/,/ /g")
do
  ((counter++))

  # Delete an processn from workflow
  request=$(curl -X DELETE -H "$authHeader" -sS https://activity.$env.com/runtime/process-instances/$id)

  # Checks for unset or empty string value
  if [ -z "$request" ]
  then
    printf "\nAppId: $id, deleted successfully"
  else
    error=$(echo $request | jq '. | .message')
    printf "\nAppId: $id, ERROR: $error"
  fi

  sleep $backoffTime

done

printf "\n\n $counter records processed. \n EXITING... \n"
