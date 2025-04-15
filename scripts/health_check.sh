#!/bin/bash

# Color codes for pretty output
GREEN="\033[0;32m"
RED="\033[0;31m"
NC="\033[0m" # No Color

# Check if user gave a URL
if [ -z "$1" ]; then
  echo -e "${RED}Error: No URL provided.${NC}"
  echo "Usage: ./health_check.sh https://example.com"
  exit 1
fi

URL=$1

# Send a request and get the HTTP status code
STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$URL")

if [ "$STATUS" -eq 200 ]; then
  echo -e "${GREEN}✅ $URL is UP (HTTP $STATUS)${NC}"
else
  echo -e "${RED}❌ $URL is DOWN or Unreachable (HTTP $STATUS)${NC}"
fi
