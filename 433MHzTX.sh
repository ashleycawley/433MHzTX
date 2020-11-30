#!/bin/bash

# Records start time
start=`date +%s`

# Script
echo "Your arguments were: $1 $2 $3"

CODE=$(echo $1 | sed -n -e 's/^.*=//p')

echo "Code: $CODE"

ping -c 5 bbc.co.uk

# Records end time
end=`date +%s`

# Calculates time difference and puts number of seconds into $runtime variable
runtime=$((end-start))

# Displays the number of seconds that the script took to execute
echo "Runtime: $runtime seconds"

exit 0
