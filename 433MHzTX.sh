#!/bin/bash

# Notes

# Command Structure:
# 433MHzTX.sh --code=4543795 --protocol=0 --pulse-width=170 --tx-number=5 --gaps=0.2 --device=monitors

# Variables
start=`date +%s`
CODE=$(echo $1 | sed -n -e 's/^.*=//p')
PROTOCOL=$(echo $2 | sed -n -e 's/^.*=//p')
PULSE_WIDTH=$(echo $3 | sed -n -e 's/^.*=//p')
TX_NUMBER=$(echo $4 | sed -n -e 's/^.*=//p')
GAPS=$(echo $5 | sed -n -e 's/^.*=//p')
DEVICE=$(echo $6 | sed -n -e 's/^.*=//p')
COUNTER="1"

# Script

# Debugging
echo "
Your arguements were: $CODE $PROTOCOL $PULSE_WIDTH $TX_NUMBER $GAPS $DEVICE
"

echo "codesend $CODE $PROTOCOL $PULSE_WIDTH"



while [ $COUNTER -le $TX_NUMBER ]
do
	echo "Sending signal..."
    sudo /home/pi/433Utils/RPi_utils/codesend $CODE $PROTOCOL $PULSE_WIDTH
    sleep 
	((COUNTER++))
done

((COUNTER--)) # Corrects Counter
echo "`date` - $COUNTER signals of the code $CODE were transmitted to the $DEVICE" >> 433MHz.log

# Records end time
end=`date +%s`

# Calculates time difference and puts number of seconds into $runtime variable
runtime=$((end-start))

# Displays the number of seconds that the script took to execute
echo "Runtime: $runtime seconds"

exit 0
