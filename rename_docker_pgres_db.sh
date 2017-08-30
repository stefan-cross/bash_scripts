#!/bin/bash

printf "Enter the container name to connect to: \n"
docker ps | grep name
printf "e.g. activiti_postgres9.5.5 \n"
read CONTAINER

printf "Enter the name of the existing DB to rename: \n"
read EXISTING_DB_NAME

printf "enter the new db name: \n"
read NEW_DB_NAME

docker exec -i activiti_postgres9.5.5 bash <<EOF
psql -U postgres -d postgres

\c postgres

SELECT pg_terminate_backend( pid ) FROM pg_stat_activity
WHERE pid <> pg_backend_pid( ) AND datname = $EXISTING_DB_NAME;

ALTER DATABASE $EXISTING_DB_NAME RENAME TO $NEW_DB_NAME;

\q

EOF

printf "Script complete \n"

# Userful redundant commands
# docker exec -it activiti_postgres9.5.5 psql -U postgres -d postgres
