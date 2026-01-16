#!/bin/bash
#This script will check in with curl on a remote live webserver

#Variables

#Server e.g. 172.17.0.2 or checkin.vives.live
server='https://checkin.vives.live'
#server='localhost:3100'

#Duration in seconds 4h = 14400
duration=14400

#Poll interval
interval=1

#set start date
start=$(date +%s)
# end date = start + 4 hours 14400 sec
end=$(( $start + $duration ))

# Function to get active network interface with IP
get_active_interface() {
    # Try common interfaces in order: en0, en1, en2, en3
    for interface in en0 en1 en2 en3; do
        # Check if interface exists and has an IP address (not 127.0.0.1)
        ip=$(ifconfig $interface 2>/dev/null | grep 'inet ' | grep -v '127.0.0.1' | awk '{print $2}')
        if [ ! -z "$ip" ]; then
            echo $interface
            return
        fi
    done
    # Fallback to en0 if nothing found
    echo "en0"
}

# Detect active network interface
nic=$(get_active_interface)
echo "Using network interface: $nic"

#curl loop every second
while [ $(date +%s) -lt $end ]
do
  sleep $interval
    wget $server -O ./down/checkin.html 2>/dev/null
    curl -s -d "name=$(hostname -s)&ip=$(ifconfig $nic)" $server > /dev/null
done
