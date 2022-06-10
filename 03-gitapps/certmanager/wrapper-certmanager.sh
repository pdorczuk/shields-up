#!/usr/bin/env bash

# Globals
GREEN="\033[0;32m"
PURPLE="\033[0;35m"
BLUE="\033[0;34m"
NC="\033[0m" # No Color
OK="${GREEN}OK${NC}\r\n"


case "$1" in
    install)      
        printf "${PURPLE}Deploy Certmanager..."        
        kustomize build --enable-helm . | kubectl create -f- > /dev/null 2>&1
        printf "${OK}"
    ;;

    remove)
        printf "${PURPLE}Remove Certmanager..."
        kustomize build --enable-helm . | kubectl delete -f- > /dev/null 2>&1
        printf "${OK}"
    ;;
esac