#!bin/bash

## Config ##
# server root path
server_path="/path/to/server"
# screen name :  
screen_name="mc"
# delay
tellraw_delay=0
stop_delay=0
backup_delay=5
start_delay=5

tellraw() {
    screen -S ${screen_name} -X stuff 'tellraw @a {"text":"Redémarrage du serveur dans 60 sec"}\n'
    screen -S ${screen_name} -X stuff 'title @a actionbar {"text":"Redémarrage du serveur dans 60 sec"}\n'
    sleep 60
    screen -S ${screen_name} -X stuff 'tellraw @a {"text":"Redémarrage du serveur dans 10 sec"}\n'
    screen -S ${screen_name} -X stuff 'title @a actionbar {"text":"Redémarrage du serveur dans 10 sec"}\n'
    sleep 5
    screen -S ${screen_name} -X stuff 'tellraw @a {"text":"Redémarrage du serveur dans 5 sec"}\n'
    screen -S ${screen_name} -X stuff 'title @a actionbar {"text":"Redémarrage du serveur dans 5 sec"}\n'
    sleep 1
    screen -S ${screen_name} -X stuff 'tellraw @a {"text":"Redémarrage du serveur dans 4 sec"}\n'
    screen -S ${screen_name} -X stuff 'title @a actionbar {"text":"Redémarrage du serveur dans 4 sec"}\n'
    sleep 1
    screen -S ${screen_name} -X stuff 'tellraw @a {"text":"Redémarrage du serveur dans 3 sec"}\n'
    screen -S ${screen_name} -X stuff 'title @a actionbar {"text":"Redémarrage du serveur dans 3 sec"}\n'
    sleep 1
    screen -S ${screen_name} -X stuff 'tellraw @a {"text":"Redémarrage du serveur dans 2 sec"}\n'
    screen -S ${screen_name} -X stuff 'title @a actionbar {"text":"Redémarrage du serveur dans 2 sec"}\n'
    sleep 1
    screen -S ${screen_name} -X stuff 'tellraw @a {"text":"Redémarrage du serveur dans 1 sec"}\n'
    screen -S ${screen_name} -X stuff 'title @a actionbar {"text":"Redémarrage du serveur dans 1 sec"}\n'
    sleep 1
    screen -S ${screen_name} -X stuff 'tellraw @a {"text":"Redémarrage du serveur dans 0 sec"}\n'
    screen -S ${screen_name} -X stuff 'title @a actionbar {"text":"Redémarrage du serveur dans 0 sec"}\n'
    sleep 1
    screen -S ${screen_name} -X stuff 'tellraw @a {"text":"Redémarrage du serveur"}\n'
    screen -S ${screen_name} -X stuff 'title @a actionbar {"text":"Redémarrage du serveur"}\n'
}


backup() {
    # date=$(date "+%d-%m-%Y_%H-%M-%S")
    date=$(date "+%d-%m-%Y")
    FILE=${server_path}/backups/r_${date}_world.tar.gz
    if [ -f "$FILE" ]; then
        index=0
        while [ -f "$FILE" ]; do  
            echo "while $FILE"
            index=$((index+1))
            ((index=index+1))
            FILE=${server_path}/backups/r_${date}_world_${index}.tar.gz
        done
        tar -czvf ${server_path}/backups/r_${date}_world_${index}.tar.gz ${server_path}/world
    else
        tar -czvf ${server_path}/backups/r_${date}_world.tar.gz ${server_path}/world
    fi
    screen -S ${screen_name} -X stuff 'sh start.sh\n'
}


# Main script

# Tell player of the upcoming shutdown
sleep ${tellraw_delay}
tellraw

# Stop server
sleep ${stop_delay}
screen -S ${screen_name} -X stuff 'stop\n'

# Make backup and restart the server
sleep ${backup_delay}
backup

# WebHook Discord
curl -X POST "webhook url" -H 'Content-Type: application/json' -d "$(cat payload.json)"