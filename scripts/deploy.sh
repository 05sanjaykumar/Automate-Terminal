#!/bin/bash

# Colors
GREEN="\033[0;32m"
RED="\033[0;31m"
NC="\033[0m"

# Check arguments
if [ "$#" -ne 2 ]; then
  echo -e "${RED}Usage: $0 <local-folder-or-file> <user@host:path>${NC}"
  exit 1
fi

LOCAL_PATH=$1
REMOTE_HOST_PATH=$2

# Debugging: Print out the received arguments
echo "Arguments: $LOCAL_PATH $REMOTE_HOST_PATH"

# Split REMOTE_HOST_PATH into REMOTE_HOST and REMOTE_PATH
REMOTE_HOST=$(echo $REMOTE_HOST_PATH | cut -d':' -f1)
REMOTE_PATH=$(echo $REMOTE_HOST_PATH | cut -d':' -f2-)

# Debugging: Check the split results
echo "REMOTE_HOST: $REMOTE_HOST"
echo "REMOTE_PATH: $REMOTE_PATH"

# Check if local path is a directory or file
if [ -d "$LOCAL_PATH" ]; then
  echo -e "${GREEN}🚀 Deploying directory '$LOCAL_PATH' to '$REMOTE_HOST:$REMOTE_PATH'...${NC}"
  # Deploy directory
  scp -r "$LOCAL_PATH" "$REMOTE_HOST:$REMOTE_PATH"
elif [ -f "$LOCAL_PATH" ]; then
  echo -e "${GREEN}🚀 Deploying file '$LOCAL_PATH' to '$REMOTE_HOST:$REMOTE_PATH'...${NC}"
  # Deploy single file
  scp "$LOCAL_PATH" "$REMOTE_HOST:$REMOTE_PATH"
else
  echo -e "${RED}Error: '$LOCAL_PATH' is not a valid file or directory.${NC}"
  exit 1
fi

# Check the status of the SCP command
if [ $? -eq 0 ]; then
  echo -e "${GREEN}✅ Deployment complete!${NC}"
else
  echo -e "${RED}❌ Deployment failed!${NC}"
fi
