#!/bin/bash

# See README.md for usage and more information.

# Node Specific Variables
source ./settings
NODE_TYPE="master" # Master or Slave
SLAVE="RFPi2" # Hostname or IP of Slave 433Mhz TX Server
SLAVE_SSH_PORT="7669"
PRIVATE_SSH_KEY_PATH="/home/pi/.ssh/key_to_connect_to_RFPi2"

# Script Variables
CODE=$(echo $1 | sed -n -e 's/^.*=//p')
PROTOCOL=$(echo $2 | sed -n -e 's/^.*=//p')
PULSE_WIDTH=$(echo $3 | sed -n -e 's/^.*=//p')
REPETITIONS=$(echo $4 | sed -n -e 's/^.*=//p')
GAPS=$(echo $5 | sed -n -e 's/^.*=//p')
DEVICE=$(echo $6 | sed -n -e 's/^.*=//p')
COUNTER="1"

# Debugging Variables
start=`date +%s`

# Script

## Debugging Section ##
echo "
Your arguements were: $CODE $PROTOCOL $PULSE_WIDTH $REPETITIONS $GAPS $DEVICE
"

echo "codesend $CODE $PROTOCOL $PULSE_WIDTH"
## End of Debugging Section##

## Transmission Loop which sends the signal ##
while [ "$COUNTER" -le "$REPETITIONS" ]
do
    sudo codesend $CODE $PROTOCOL $PULSE_WIDTH
    sleep $GAPS

    ## Dispatches signal to Slave Server if one exists, but it should only do this once
    while [ "$COUNTER" -le "2" ]
    do
        if [ ! -z "$SLAVE" ]
        then
            ssh -p $SLAVE_SSH_PORT -i $PRIVATE_SSH_KEY_PATH pi@$SLAVE "sudo codesend --code=$CODE --protocol=$PROTOCOL --pulse-width=$PULSE_WIDTH --repetitions=$REPETITIONS &" &
        fi
    done

    # Increments Counter by 1
	((COUNTER++))
done

((COUNTER--)) # Corrects Counter

# Records end time
end=`date +%s`

# Calculates time difference and puts number of seconds into $runtime variable
runtime=$((end-start))

echo "`date` - $COUNTER signals of the code $CODE were transmitted over $runtime seconds to the $DEVICE" >> ~/tx-433MHz.log

# Displays the number of seconds that the script took to execute
echo "Runtime: $runtime seconds"

exit 0
