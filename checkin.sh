#!/bin/bash
#This script will check in with curl on a remote live webserver
#Variables

#Server e.g. 172.17.0.2 or checkin.vives.live
server='https://checkin.vives.live'
#server='localhost:3100'
#Duration in seconds 3h = 10800
duration=5
#Poll insterval
interval=1
#set start date
start=$(date +%s)
# end date = start + 3 hours 10800 sec
end=$(( $start + $duration ))

#curl loop every second
while [ $(date +%s) -lt $end ]
do
  sleep $interval
    wget $server
    curl -d "name=$HOST&ip=$(ifconfig en0)" $server
done