#!/bin/bash

RESTAURANT_URL="https://www.dobartek.hr/robot?ref=small"
CHECK_INTERVAL=60  # seconds
USER_AGENT="Mozilla/5.0"
ALREADY_OPEN=0

echo "[*] Monitoring Restoran Robot every $CHECK_INTERVAL seconds..."

while true; do
    TIMESTAMP=$(date "+%H:%M:%S")
    
    
    HTML=$(curl -s -A "$USER_AGENT" "$RESTAURANT_URL")

    if echo "$HTML" | grep -q "TRENUTNO ZATVOREN"; then
        echo "[$TIMESTAMP] [-] Still closed..."
        ALREADY_OPEN=0
    else
        if [[ $ALREADY_OPEN -eq 0 ]]; then
            echo "[$TIMESTAMP] [+] Restoran Robot is OPEN!"

            #Sound I have made using Text-2-Speech with ElevenLabs, so when restauran opens, I get voice notiff and text banner on screen
            afplay /Users/trpimraj.mac/Library/Sounds/narudjba.aiff &

            #Used terminal-notifier because default notification settings were buggy, they would not display
            terminal-notifier \
                -title "!!! Restoran Robot je OTVOREN !!!" \
                -message "Klikni za narudžbu :)" \
                -open "$RESTAURANT_URL" &



            ALREADY_OPEN=1
        fi
    fi

    sleep "$CHECK_INTERVAL"
done
