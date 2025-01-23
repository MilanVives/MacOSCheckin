#! /bin/bash

echo "Starting screen"
#screen -dmS checkin bash -c 'bash checkin.sh'
screen -S Checking ./checkin.sh
