#!/bin/bash

# Config
SERVICE_NAME="myapp"
URL="http://localhost:8000"
LOG_FILE="$HOME/healthcheck.log"  # Log file in the user's home directory
DISCORD_WEBHOOK=""

# Checking the service status by checking the URL response code
STATUS=$(curl -s -o /dev/null -w "%{http_code}" $URL)
echo "[$(date)] Status code: $STATUS" >> $LOG_FILE

# If the service is down, restart it and notify via Discord (if webhook provided)
if [ "$STATUS" -ne 200 ]; then
    echo "[$(date)] $SERVICE_NAME is down! Restarting..." >> $LOG_FILE

    # Check if the service is running and terminate it
    PID=$(pgrep -f $SERVICE_NAME)
    if [ -n "$PID" ]; then
        kill $PID
        echo "[$(date)] $SERVICE_NAME process terminated." >> $LOG_FILE
    else
        echo "[$(date)] $SERVICE_NAME process not found." >> $LOG_FILE
    fi

    # Restart the service/application
    nohup "/Users/sanjaykumar/Documents/vscode projects/Bash Project/Devops-Wizard/healthcheck.sh" &  # Restarts it in the background

    echo "[$(date)] $SERVICE_NAME restarted." >> $LOG_FILE

    # Optionally notify via Discord webhook
    if [ ! -z "$DISCORD_WEBHOOK" ]; then
        curl -H "Content-Type: application/json" \
            -X POST \
            -d "{\"content\": \"⚠️ $SERVICE_NAME was down. Restarted at $(date).\"}" \
            $DISCORD_WEBHOOK
    fi
else
  echo "[$(date)] $SERVICE_NAME is running fine." >> $LOG_FILE
fi
