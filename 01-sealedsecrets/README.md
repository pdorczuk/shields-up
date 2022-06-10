# "Sealed Secrets" for Kubernetes

Kustomize inflates the off-the-shelf Bitnami Sealed Secrets Helm chart. 

In the kustomization.yaml file, an additional resource called "master.key" is added. This is a backup of an existing Sealed Secret master key which you can pull down using 

```
kubectl get secret -n kube-system -l sealedsecrets.bitnami.com/sealed-secrets-key -o yaml > master.key
```

```
kustomize build --enable-helm . | kubectl create -f-
```

# TODO mention the utility script to re-key
# TODO use kubeseal to seal the master key so it can be entered into github