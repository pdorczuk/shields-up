# cluster-apps

Collection of services to bootstrap a Kubernetes cluster to enable authentication/authorization/auditing, ingress routing and certificate management, policy as code, and other infrastructure needs to run a Kubernetes cluster in a secure and compliant fashion.

I designed this as a learning sandbox environment for me to play around with different tools, concepts, and processes. So I'll put my disclaimer here that while I try to adhere to best practices, this is NOT suitable for production workloads.

## Getting Started

Since I am doing a lot of experimentation, I designed this setup to be really easy to tear down to the studs and rebuild at both the cluster and application level. I am running a single physical server and using Kubeadm to provision a single node cluster.

### Prerequisites

There is a wrapper script to create a single node cluster using Kubeadm. That script does NOT install the KubeAdm [prerequisite components](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/)  If you don't use this, you'll need access to a Kubernetes cluster.

You will also need to have a current version of [Kustomize](https://kubectl.docs.kubernetes.io/installation/kustomize/).

If you want to use the Kubeadm script, clone this repo on the server that you want to install Kubernetes on. Mine is a single Ubuntu 20.04 server. Modify the values in both /kubeadm/kubeadm-config.yaml and /kubeadm/calico-config.yaml to fit your environment. Then:
```
bash ./kubeadm/cluster-wrapper.sh create
```

You should now have a working Kubernetes cluster that we can play with.

### Installing

While I am striving to automate the entire bootstrap process using GitOps in ArgoCD. There is a chicken and egg problem so I need to install a couple of applications manually before I can automate all the things. There are more detailed explanations and instructions in each of the respective application directories.

Sealed Secrets

```
cd sealedsecrets
kustomize build . | kubectl create -f-
```

Install ArgoCD

```
kustomize build ./argocd | kubectl create -f-
```
