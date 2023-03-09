#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

function get_time_to_nine() {
  # Get the current time in seconds
  current_time=$(date +%s)

  # Get the time of 9am today in seconds
  nine_am=$(date -d "9am today" +%s)

  # Check if the current time is past 9am
  if [ "$current_time" -gt "$nine_am" ]; then
    return -1
  fi

  # Calculate the number of seconds between the current time and 9am
  seconds_until_nine_am=$((nine_am - current_time))

  # Print the number of seconds
  return $seconds_until_nine_am
}

get_time_to_nine
rtcwake -m mem -t $? && screen -S server -p 0 -X stuff "./run.sh^M"