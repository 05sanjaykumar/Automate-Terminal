#!/bin/bash

# Color codes for pretty output
GREEN="\033[0;32m"
RED="\033[0;31m"
NC="\033[0m" # No Color

# Default interval (in seconds)
INTERVAL=5

# Check if user gave a URL
if [ -z "$1" ]; then
  echo -e "${RED}Error: No target provided.${NC}"
  echo "Usage:"
  echo "  ./health_check.sh https://example.com"
  echo "  ./health_check.sh 127.0.0.1:3000"
  exit 1
fi

TARGET=$1
shift

while [[ $# -gt 0 ]]; do
    case "$1" in
    --watch)
      WATCH=true;;
    --interval)
      shift
      INTERVAL=$1;;
      *)
      echo -e "${RED}Unknown option: $1${NC}"
      exit 1;;
    esac
    shift
  done
    

# If target contains http or https → treat as URL
if [[ "$TARGET" == http* ]]; then
    STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$TARGET")
    if [ "$STATUS" -eq 200 ]; then
        echo -e "${GREEN}✅ $TARGET is UP (HTTP $STATUS)${NC}"
    else
        echo -e "${RED}❌ $TARGET is DOWN or Unreachable (HTTP $STATUS)${NC}"
    fi
# Else treat as IP:Port
elif [[ "$TARGET" == *:* ]]; then
  IP=$(echo "$TARGET" | cut -d':' -f1)
  PORT=$(echo "$TARGET" | cut -d':' -f2)

  nc -z -w2 "$IP" "$PORT" > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ $IP:$PORT is reachable${NC}"
  else
    echo -e "${RED}❌ $IP:$PORT is unreachable${NC}"
  fi

else
  echo -e "${RED}Invalid input. Please provide a URL or IP:port.${NC}"
fi