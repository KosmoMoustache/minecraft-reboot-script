#!/bin/bash

# Get the number of players online

# Set the path to the Minecraft server directory
server_dir="/path/to/server"
# Set the path to the server log file
log_file="$server_dir/logs/latest.log"

# Read the last line of the log file
screen -S server -p 0 -X stuff "list^M"
last_line=$(tail -n 1 "$log_file")

# Check if players are online
if echo "$last_line" | grep -q "There are [1-9][0-9]* of a max of [1-9][0-9]* players online"; then
  # Extract the number of players online from the log line
  num_players=$(echo "$last_line" | grep -o "There are [1-9][0-9]* of a max of " | grep -o "[1-9][0-9]*")

  # Print the number of players online
  echo "numplayer: $num_players"
else
  echo "No players online"
fi
