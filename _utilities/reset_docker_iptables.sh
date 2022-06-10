#!/usr/bin/env bash

# Globals
GREEN="\033[0;32m"
PURPLE="\033[0;35m"
BLUE="\033[0;34m"
NC="\033[0m" # No Color
OK="${GREEN}OK${NC}\r\n"
ROOT="$(readlink -f ./)"

printf "${PURPLE}Flushing iptables rules..."
sudo iptables -t filter -F > /dev/null 2>&1
sudo iptables -t filter -X > /dev/null 2>&1
printf "${OK}"

printf "${PURPLE}Restarting Docker service..."
sudo systemctl restart docker > /dev/null 2>&1
printf "${OK}"