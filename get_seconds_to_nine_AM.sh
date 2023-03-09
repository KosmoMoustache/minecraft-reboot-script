#!/bin/bash

# Return the number of seconds until 9am

current_time=$(date +%s)
# Get the time of 9am today in seconds
nine_am=$(date -d "9am today" +%s)

# Check if the current time is past 9am
if [ "$current_time" -gt "$nine_am" ]; then
  echo "Error: Current time is past 9am."
  exit 1
fi

# Calculate the number of seconds between the current time and 9am
seconds_until_nine_am=$((nine_am - current_time))

# Print the number of seconds
echo "Seconds until 9am: $seconds_until_nine_am"
