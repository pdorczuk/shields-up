#!/usr/bin/env bash

# Globals
GREEN="\033[0;32m"
PURPLE="\033[0;35m"
BLUE="\033[0;34m"
NC="\033[0m" # No Color
OK="${GREEN}OK${NC}\r\n"
ROOT="$(readlink -f ./)"

case "$1" in
    kube|k)
        printf "${PURPLE}Destroying existing cluster..."
        sudo kubeadm reset --force > /dev/null 2>&1
        printf "${OK}"

        printf "${PURPLE}Clean up iptables..."
        sudo iptables -F > /dev/null 2>&1
        sudo iptables -t nat -F > /dev/null 2>&1
        sudo iptables -t mangle -F > /dev/null 2>&1
        sudo iptables -X > /dev/null 2>&1
        printf "${OK}"

        printf "${PURPLE}Remove kubectl config file..."
        rm -rf $HOME/.kube/config > /dev/null 2>&1
        printf "${OK}"

        # Initialize the cluster using the config file that includes OIDC configuration
        printf "${PURPLE}Create cluster using Kubeadm..."
        NO_PROXY=.svc,.svc.cluster.local sudo kubeadm init --config=./kubeadm-config.yaml > /dev/null 2>&1
        printf "${OK}"

        # Copy the root credentials file into my home directory.
        printf "${PURPLE}Copy kubectl config files..."
        mkdir -p $HOME/.kube > /dev/null 2>&1
        sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config > /dev/null 2>&1
        sudo chown $(id -u):$(id -g) $HOME/.kube/config > /dev/null 2>&1
        printf "${OK}"

        # Allow pods to run on master
        printf "${PURPLE}Taint the node to allow pod scheduling..."
        kubectl taint nodes --all node-role.kubernetes.io/master- > /dev/null 2>&1
        printf "${OK}"

        # Install Calico
        printf "${PURPLE}Install Calico networking..."
        kubectl create -f https://docs.projectcalico.org/manifests/tigera-operator.yaml > /dev/null 2>&1
        kubectl create -f ./calico-config.yaml > /dev/null 2>&1
        printf "${OK}"
    ;;
    tools|t)
        # Build kubeseal container
        # TODO finish building docker containers for kubectl and anything else
        docker build -f _kubeseal.Dockerfile -t kubeseal:01282022 .
        docker build -f _helm.Dockerfile -t helm:01312022 .
    ;;
    alias|a)
    # TODO fix and test these aliases. they kind of work but i need to focus on other stuff for now
        # This section adds Fish abbreviations needed to map to Docker tools. 
        # Each abbreviation is appended to the config.fish file after checking if it already exists.
        
        # kubectl
        #grep -qxF "abbr kubectl 'microk8s kubectl'" ~/.config/fish/config.fish || echo "abbr kubectl 'microk8s kubectl'" >> ~/.config/fish/config.fish

        # kubeseal
        grep -qxF "abbr kubeseal 'docker run -v /home/phil/.kube:/root/.kube ktools:01282022 kubeseal --controller-namespace operations --controller-name=sealedsecrets-sealed-secrets'" ~/.config/fish/config.fish || echo "abbr kubeseal 'docker run -v /home/phil/.kube:/root/.kube ktools:01282022 kubeseal --controller-namespace operations --controller-name=sealedsecrets-sealed-secrets'" >> ~/.config/fish/config.fish

        # kustomize
        grep -qxF "abbr kustomize 'docker run -v /home/phil/.kube:/root/.kube us.gcr.io/k8s-artifacts-prod/kustomize/kustomize:v4.4.1'" ~/.config/fish/config.fish || echo "abbr kustomize 'docker run -v /home/phil/.kube:/root/.kube us.gcr.io/k8s-artifacts-prod/kustomize/kustomize:v4.4.1'" >> ~/.config/fish/config.fish

        # helm
        #grep -qxF "abbr helm 'docker run -v /home/phil/.kube:/root/.kube us.gcr.io/k8s-artifacts-prod/kustomize/kustomize:v4.4.1'" ~/.config/fish/config.fish || echo "abbr kubeseal 'docker run -v /home/phil/.kube:/root/.kube us.gcr.io/k8s-artifacts-prod/kustomize/kustomize:v4.4.1'" >> ~/.config/fish/config.fish

        source ~/.config/fish/config.fish
    ;;
    iptables|rip)
        # Reset IP tables rules and restart the docker service which can fix a lot of container networking issues
        # The most common one is DNS issues when building a container. Flushing the rules will usually fix it.
        printf "${PURPLE}Flushing iptables rules..."
        sudo iptables -t filter -F > /dev/null 2>&1
        sudo iptables -t filter -X > /dev/null 2>&1
        printf "${OK}"

        printf "${PURPLE}Restarting Docker service..."
        sudo systemctl restart docker > /dev/null 2>&1
        printf "${OK}"
    ;;
esac
