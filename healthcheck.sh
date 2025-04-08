#!/bin/bash

# Config
SERVICE_NAME="myapp"
URL="http://localhost:8000"
LOG_FILE="/var/log/healthcheck.log"
DISCORD_WEBHOOK=""

STATUS=$(curl -s -o /dev/null -w "%{http_code}" $URL)
echo "[$(date)] Status code: $STATUS" >> $LOG_FILE

if [ "$STATUS" -ne 200 ]; then
    echo "[$(date)] $SERVICE_NAME is down! Restarting..." >> $LOG_FILE
    systemctl restart $SERVICE_NAME
    echo "[$(date)] $SERVICE_NAME restarted." >> $LOG_FILE

    if [ ! -z "$DISCORD_WEBHOOK" ]; then
        curl -H "Content-Type: application/json" \
            -X POST \
            -d "{\"content\": \"⚠️ $SERVICE_NAME was down. Restarted at $(date).\"}" \
            $DISCORD_WEBHOOK
    fi

else
  echo "[$(date)] $SERVICE_NAME is running fine." >> $LOG_FILE
fi