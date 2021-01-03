#!/bin/bash

# See README.md for usage and more information.

# Script Variables
SCRIPT=$(readlink -f $0)
SCRIPT_PATH=`dirname $SCRIPT`
CODE=$(echo $1 | sed -n -e 's/^.*=//p')
PROTOCOL=$(echo $2 | sed -n -e 's/^.*=//p')
PULSE_WIDTH=$(echo $3 | sed -n -e 's/^.*=//p')
REPETITIONS=$(echo $4 | sed -n -e 's/^.*=//p')
GAPS=$(echo $5 | sed -n -e 's/^.*=//p')
DEVICE=$(echo $6 | sed -n -e 's/^.*=//p')
COUNTER="1"

# Node Specific Variables
source $SCRIPT_PATH/settings

# Debugging Variables
start=`date +%s`

# Script

## Debugging Section ##
echo "I ran at `date`" >> /home/pi/433MHzTX/run.log
# echo "Your arguements were: $CODE $PROTOCOL $PULSE_WIDTH $REPETITIONS $GAPS $DEVICE "
## End of Debugging Section##

## Dispatches signal to Slave Server if one exists, but it should only do this once
if [ ! -z "$SLAVE" ]
then
    ssh -p $SLAVE_SSH_PORT -i $PRIVATE_SSH_KEY_PATH pi@$SLAVE "433mhztx --code=$CODE --protocol=$PROTOCOL --pulse-width=$PULSE_WIDTH --repetitions=$REPETITIONS --device=$DEVICE"
fi

## Transmission Loop which sends the signal ##
while [ "$COUNTER" -le "$REPETITIONS" ]
do
    echo "This is `hostname` sending..."
    sudo codesend $CODE $PROTOCOL $PULSE_WIDTH
    sleep $GAPS

    # Increments Counter by 1
	((COUNTER++))
done

((COUNTER--)) # Corrects Counter

# Records end time
end=`date +%s`

# Calculates time difference and puts number of seconds into $runtime variable
runtime=$((end-start))

echo "`date` - $COUNTER signals of the code $CODE were transmitted over $runtime seconds to the $DEVICE" | tee -a $SCRIPT_PATH/tx-433MHz.log

# Displays the number of seconds that the script took to execute
echo "Runtime: $runtime seconds"

exit 0
