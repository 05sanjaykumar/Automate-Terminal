#!/bin/bash

# Colors
GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[1;33m"
NC="\033[0m"

# Default threshold
THRESHOLD=85

# Optional: allow user to set a custom threshold
if [ ! -z "$1" ]; then
  THRESHOLD=$1
fi

echo -e "${YELLOW}🔍 Checking disk usage... (Threshold: ${THRESHOLD}%)${NC}"
echo ""

# Get disk usage info (excluding tmpfs, devfs, etc.)
df -h | grep -vE '^Filesystem|tmpfs|devfs' | while read line; do
  USAGE=$(echo $line | awk '{print $5}' | sed 's/%//g')
  MOUNT=$(echo $line | awk '{print $6}')

  if [ "$USAGE" -ge "$THRESHOLD" ]; then
    echo -e "${RED}⚠️  $MOUNT is $USAGE% full!${NC}"
  else
    echo -e "${GREEN}✅ $MOUNT is $USAGE% used — all good.${NC}"
  fi
done
