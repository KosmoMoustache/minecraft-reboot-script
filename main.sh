#!/bin/bash

# Main script
# This script will check if there are any players online and if not, it will make a backup using simplebackup mod and shut down the server.
# And put to sleep the laptop until 9am.

# Path to the Minecraft server directory
server_dir="/path/to/server"
# Path to the server log file
log_file="$server_dir/logs/latest.log"
username="username" # Linux username

# Get the number of players online
function get_player_number() {
  # execute /list command in the server's console
  execute_in_screen "list"
  sleep 1
  local last_line=$(tail -n 1 "$log_file")
  player_number=$(echo "$last_line" | grep -o "[0-9]* of a max" | grep -o "[0-9]*")
  echo $player_number
}

# Get the number of seconds until 9am
function get_time_to_nine() {
  # Get the current time in seconds
  current_time=$(date +%s)
  # Get the time of 9am today in seconds
  nine_am=$(date -d "11am today" +%s)

  # Check if the current time is past 9am
  if [ "$current_time" -gt "$nine_am" ]; then
    return -1
  fi

  # Calculate the number of seconds between the current time and 9am
  # Shared variable
  seconds_until_nine_am=$((nine_am - current_time))
}

# Check if there is at least one player online
function is_players_online() {
  local result=$(get_player_number)
  if [ "$result" -ge 0 ]; then
    echo 1
  else
    echo 0
  fi
}

# Say something in the server's chat
function log_in_chat() {
   su - $username -c "screen -S server -p 0 -X stuff 'say [$(date "+%D %T")] $1^M'"
}
function execute_in_screen() {
   su - $username -c "screen -S server -p 0 -X stuff '$1^M'"
}
# Log
function log() {
  echo "[$(date "+%D %T")] $1"
}

# Main loop
while true; do
  if [ "$(is_players_online)" -eq 1 ]; then
    log "Player(s) are online. (Checking again in 5 minutes)"
    log_in_chat "Player(s) are online. (Checking again in 5 minutes)"
    sleep 300
  else
    log "No player online. (Checking again in 5 minutes)"
    log_in_chat "No player online. (Checking again in 5 minutes)"
    sleep 300
  if [ "$(is_players_online)" -eq 1 ]; then
      log "Player(s) are back."
      log_in_chat "Player(s) are back."
    else
      log "Still no player online. Server will be backed up and stopped."
      log_in_chat "Still no player online. Server will be backed up and stopped."
      # TODO: Check if the backup is successful before stopping the server
      execute_in_screen "simplebackups backup start^M"
      sleep 60
      execute_in_screen "say Arrêt du serveur dans 30 secondes.^M"
      sleep 30
      execute_in_screen "stop^M"
      sleep 60
      log "Server will be restarted in 9 hours."
      # Sleep the laptop until 9am
      get_time_to_nine
      rtcwake -m mem -t $?
      # rtcwake -m mem -t $(($(date +%s) + 9*3600))
      execute_in_screen "./run.sh^M"
      exit 0
    fi
  fi
done
