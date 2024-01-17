#!/bin/sh
/oc.sh $PROJECT all
echo "Starting container Movies Copy Backup..."
crond -f -l 8 -d 8 -L /dev/stdout
