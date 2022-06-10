#!/usr/bin/env bash

# Globals
GREEN="\033[0;32m"
PURPLE="\033[0;35m"
BLUE="\033[0;34m"
NC="\033[0m" # No Color
OK="${GREEN}OK${NC}\r\n"


# TODO write a script that rencrypts all sealed secrets in the repository.
# use case is rotating a master.key which you should do pretty regularly
# script should backup they current key
# kubectl get secret -n kube-system -l sealedsecrets.bitnami.com/sealed-secrets-key -o yaml > old_master.key
# then kustomize destroy sealed secrets and rebuild
# then run again
# kubectl get secret -n kube-system -l sealedsecrets.bitnami.com/sealed-secrets-key -o yaml > new_master.key
# then for each folder follow rekey procedures from here
# https://github.com/bitnami-labs/sealed-secrets
# kubeseal --re-encrypt <my_sealed_secret.json >tmp.json \
#  && mv tmp.json my_sealed_secret.json