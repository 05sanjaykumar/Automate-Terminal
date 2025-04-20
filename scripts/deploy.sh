#!/bin/bash

# Colors
GREEN="\033[0;32m"
RED="\033[0;31m"
NC="\033[0m"

if [ "$#" -ne 3 ]; then
    echo -e "${RED}Usage: $0 <local-folder> <user@host> <remote-path>${NC}"
    exit 1
fi

LOCAL_FOLDER=$1
REMOTE_HOST=$2
REMOTE_PATH=$3

echo -e "${GREEN}🚀 Deploying '$LOCAL_FOLDER' to '$REMOTE_HOST:$REMOTE_PATH'...${NC}"

# Run SCP
scp -r "$LOCAL_FOLDER" "$REMOTE_HOST:$REMOTE_PATH"

if [ $? -eq 0 ]; then
  echo -e "${GREEN}✅ Deployment complete!${NC}"
else
  echo -e "${RED}❌ Deployment failed!${NC}"
fi