In values.yaml make sure you change the variable

global.leaderElection.namespace from "kube-system" to "cert-manager" otherwise you will get permissions errors and clusterissuers won't be able to deploy due to X.509 certificate untrusted.