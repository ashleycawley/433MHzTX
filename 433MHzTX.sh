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

if [ "$1" == "--help" ] || [ "$1" == "-help" ] || [ "$1" == "-h" ]
then
	clear && echo "
### Description ###
This script allows you to send 433MHz wireless signals. You can supply arguements to the script on the shell so that different variables/settings can be specified easily.


### Dependencies ###
This program relies upon another program called codesend to work, there are different versions of codesend, the one which allows you to specify the protocol and pulse-width or length is the desired one. MD5SUM Hash of a codesend version that works: 2b4c93fc4cc82220d53c368398d6017b 

This tool is an additional layer which sits in front of codesend and easily allows other applications or platforms to specify arguements on the fly with different settings or signals etc.


### Example Usage of this tool ###

433MHzTX.sh --code=4543795 --protocol=0 --pulse-width=170 --tx-number=5 --gaps=0.2 --device=monitors


### Arguement Descriptions ### 
--code
The 433MHz code which is transmitted.

--protocol
The protocol used when transmitted the signal.

--pulse-length
The pulse length in microseconds of the signal transmitted.

--tx-number
The number of times the signal is transmitted. For example 5 would send the signal 5 times.

--gaps
The number of seconds between each signal being sent, so 0.5 would be half a second between each signal transmission.

--device
The name of the device you are sending the signal to, this is used just for logging and informational purposes.
" | less
fi

# Debugging
echo "
Your arguements were: $CODE $PROTOCOL $PULSE_WIDTH $TX_NUMBER $GAPS $DEVICE
"

echo "codesend $CODE $PROTOCOL $PULSE_WIDTH"


while [ $COUNTER -le $TX_NUMBER ]
do
    sudo /home/pi/433Utils/RPi_utils/codesend $CODE $PROTOCOL $PULSE_WIDTH
    sleep $GAPS
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
